package alternativa.editor.mapimport.xml
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.prop.BonusRegion;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.editor.scene.MainScene;
   import alternativa.types.Point3D;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import mx.controls.Alert;
   
   public class XMLImporterV2 extends XMLImporterBase implements IXMLImporter
   {
      private var mapXML:XML;
      
      private var scene:MainScene;
      
      private var libraryManager:LibraryManager;
      
      private var referencePopData:Array;
      
      private var numProps:int;
      
      public function XMLImporterV2()
      {
         super();
      }
      
      public function importMap(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
         this.mapXML = param1;
         this.scene = param2;
         this.libraryManager = param3;
         param2.view.visible = false;
         setTimeout(this.loadTiles,10);
      }
      
      public function addInternalObjectsToExistingScene(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
      }
      
      private function loadTiles() : void
      {
         var loc1:Prop = null;
         var loc5:XML = null;
         var loc6:Array = null;
         this.referencePopData = [];
         var loc2:XMLList = this.mapXML.elements("prop");
         var loc3:int = int(loc2.length());
         var loc4:int = 0;
         while(loc4 < loc3)
         {
            loc5 = loc2[loc4];
            loc6 = [loc5.attribute("library-name").toString(),loc5.attribute("group-name").toString(),loc5.attribute("name").toString()];
            loc1 = this.libraryManager.propByKey[loc6.join("")];
            if(loc1 == null)
            {
               throw new Error("Prop " + loc6.join("/") + " not found");
            }
            this.referencePopData[loc4] = new PropData(loc1,loc5.elements("texture-name"));
            loc4++;
         }
         this.numProps = this.mapXML.elements("map-object").length();
         startBatchExecution(200,this.mapXML.elements("map-object"));
      }
      
      override protected function processItem(param1:XML) : void
      {
         var propData:PropData = null;
         var prop:Prop = null;
         var position:Point3D = null;
         var rotation:Number = NaN;
         var free:Boolean = false;
         var textureName:String = null;
         var tile:MeshProp = null;
         var tName:String = null;
         var mapObjectXML:XML = param1;
         try
         {
            propData = this.referencePopData[int(mapObjectXML.attribute("prop-index"))];
            prop = propData.prop;
            position = this.getPoint3DFromXML(mapObjectXML.elements("position")[0]);
            rotation = Number(mapObjectXML.elements("rotation-z"));
            if(prop is Sprite3DProp)
            {
               position.z += 0.1;
            }
            prop = this.scene.addProp(prop,position,rotation,true,false);
            free = mapObjectXML.@free == "true";
            if(!(free && prop is Sprite3DProp))
            {
               this.scene.occupyMap.occupy(prop);
            }
            textureName = null;
            if(mapObjectXML.elements("texture-index").length() > 0)
            {
               textureName = propData.textureNames[int(mapObjectXML.elements("texture-index")[0])];
            }
            tile = prop as MeshProp;
            if(tile)
            {
               try
               {
                  if(textureName != null)
                  {
                     tile.textureName = textureName;
                  }
               }
               catch(err:Error)
               {
                  var loc4:int = 0;
                  var loc5:* = tile.bitmaps;
                  for(tName in loc5)
                  {
                     tile.textureName = tName;
                  }
                  Alert.show("Tile " + tile.name + ": texture " + textureName + " not found");
               }
            }
            this.scene.calculate();
         }
         catch(e:Error)
         {
            Alert.show(e.message);
         }
      }
      
      override protected function batchComplete(param1:int) : void
      {
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(new EditorProgressEvent(param1 / this.numProps));
         }
      }
      
      override protected function batchExecutionComplete() : void
      {
         try
         {
            this.loadBonuses(this.mapXML.elements("bonus-region"));
            this.loadSpawns(this.mapXML.elements("spawn-point"));
            this.loadFlags(this.mapXML.elements("ctf-flags"));
         }
         catch(err:Error)
         {
            Alert.show(err.message);
         }
         this.scene.view.visible = true;
         this.mapXML = null;
         this.scene = null;
         this.libraryManager = null;
         this.referencePopData = null;
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function loadBonuses(param1:XMLList) : void
      {
         var loc4:XML = null;
         var loc5:String = null;
         var loc6:Prop = null;
         var loc7:Point3D = null;
         var loc8:Number = NaN;
         var loc9:* = false;
         var loc10:XMLList = null;
         var loc11:int = 0;
         var loc2:int = int(param1.length());
         var loc3:int = 0;
         while(loc3 < loc2)
         {
            loc4 = param1[loc3];
            loc5 = "FunctionalBonus Regions" + loc4.@name.toString();
            loc6 = this.libraryManager.propByKey[loc5];
            if(loc6)
            {
               loc7 = this.getPoint3DFromXML(loc4.elements("position")[0]);
               loc8 = Number(loc4.elements("rotation")[0]);
               loc6 = this.scene.addProp(loc6,loc7,loc8,true,false);
               loc9 = loc4.@free == "true";
               if(!loc9)
               {
                  this.scene.occupyMap.occupy(loc6);
               }
               loc10 = loc4.child("bonus-type");
               BonusRegion(loc6).typeNames.clear();
               loc11 = 0;
               while(loc11 < loc10.length())
               {
                  BonusRegion(loc6).typeNames.add(loc10[loc11].toString());
                  loc11++;
               }
               this.scene.calculate();
            }
            loc3++;
         }
      }
      
      private function loadSpawns(param1:XMLList) : void
      {
         var loc4:XML = null;
         var loc5:String = null;
         var loc6:Prop = null;
         var loc7:Point3D = null;
         var loc8:Number = NaN;
         var loc9:* = false;
         var loc2:int = int(param1.length());
         var loc3:int = 0;
         while(loc3 < loc2)
         {
            loc4 = param1[loc3];
            loc5 = "FunctionalSpawn Points" + loc4.@type.toString();
            loc6 = this.libraryManager.propByKey[loc5];
            if(loc6)
            {
               loc7 = this.getPoint3DFromXML(loc4.elements("position")[0]);
               loc8 = Number(loc4.elements("direction")[0]);
               loc6 = this.scene.addProp(loc6,loc7,loc8,true,false);
               loc9 = loc4.@free == "true";
               if(!loc9)
               {
                  this.scene.occupyMap.occupy(loc6);
               }
               this.scene.calculate();
            }
            loc3++;
         }
      }
      
      private function loadFlags(param1:XMLList) : void
      {
         if(param1.length() == 0)
         {
            return;
         }
         var loc2:XML = param1[0];
         this.addFlag(loc2.child("flag-red")[0],"red_flag");
         this.addFlag(loc2.child("flag-blue")[0],"blue_flag");
      }
      
      private function addFlag(param1:XML, param2:String) : void
      {
         var loc3:Prop = this.libraryManager.propByKey["FunctionalFlags" + param2];
         if(loc3 != null)
         {
            loc3 = this.scene.addProp(loc3,this.getPoint3DFromXML(param1),0,true,false);
            this.scene.calculate();
         }
      }
      
      private function getPoint3DFromXML(param1:XML) : Point3D
      {
         return new Point3D(Number(param1.@x),Number(param1.@y),Number(param1.@z));
      }
   }
}

import alternativa.editor.prop.Prop;

class PropData
{
   public var prop:Prop;
   
   public var textureNames:Array;
   
   public function PropData(param1:Prop, param2:XMLList)
   {
      var loc3:XML = null;
      super();
      this.prop = param1;
      if(param2.length() > 0)
      {
         this.textureNames = [];
         for each(loc3 in param2)
         {
            this.textureNames.push(loc3.toString());
         }
      }
   }
}
