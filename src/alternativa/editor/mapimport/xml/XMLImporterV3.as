package alternativa.editor.mapimport.xml
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.prop.BonusRegion;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.scene.MainScene;
   import alternativa.types.Point3D;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import mx.controls.Alert;
   
   public class XMLImporterV3 extends XMLImporterBase implements IXMLImporter
   {
      private static const STAGE_LOADING_MESHES:int = 1;
      
      private static const STAGE_LOADING_SPRITES:int = 2;
      
      private var mapXML:XML;
      
      private var scene:MainScene;
      
      private var libraryManager:LibraryManager;
      
      private var propDatas:Array;
      
      private var numMeshes:int;
      
      private var numSprites:int;
      
      private var loadingStage:int;
      
      public function XMLImporterV3()
      {
         super();
      }
      
      public function importMap(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
         this.mapXML = param1;
         this.scene = param2;
         this.libraryManager = param3;
         param2.view.visible = false;
         this.createPropRegistry();
         setTimeout(this.loadMeshes,10);
      }
      
      public function addInternalObjectsToExistingScene(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
      }
      
      private function createPropRegistry() : void
      {
         var loc4:XML = null;
         var loc5:Array = null;
         var loc6:Prop = null;
         this.propDatas = [];
         var loc1:XMLList = this.mapXML.elements("prop");
         var loc2:int = int(loc1.length());
         var loc3:int = 0;
         while(loc3 < loc2)
         {
            loc4 = loc1[loc3];
            loc5 = [loc4.attribute("library-name").toString(),loc4.attribute("group-name").toString(),loc4.attribute("name").toString()];
            loc6 = this.libraryManager.propByKey[loc5.join("")];
            if(loc6 == null)
            {
               throw new Error("Prop " + loc5.join("/") + " not found");
            }
            this.propDatas[loc3] = new PropData(loc6,loc4.elements("texture-name"));
            loc3++;
         }
      }
      
      private function loadMeshes() : void
      {
         var loc1:XMLList = this.mapXML.mesh;
         this.numMeshes = loc1.length();
         this.numSprites = this.mapXML.sprite.length();
         if(this.numMeshes > 0)
         {
            this.loadingStage = STAGE_LOADING_MESHES;
            startBatchExecution(200,loc1);
         }
         else
         {
            this.loadSprites();
         }
      }
      
      private function loadSprites() : void
      {
         var loc1:XMLList = this.mapXML.sprite;
         if(this.numSprites > 0)
         {
            this.loadingStage = STAGE_LOADING_SPRITES;
            startBatchExecution(200,loc1);
         }
         else
         {
            this.completeLoading();
         }
      }
      
      private function completeLoading() : void
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
         this.propDatas = null;
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      override protected function processItem(param1:XML) : void
      {
         var item:XML = param1;
         try
         {
            switch(this.loadingStage)
            {
               case STAGE_LOADING_MESHES:
                  this.processMesh(item);
                  break;
               case STAGE_LOADING_SPRITES:
                  this.processSprite(item);
            }
            this.scene.calculate();
         }
         catch(e:Error)
         {
            Alert.show(e.message);
         }
      }
      
      private function processMesh(param1:XML) : void
      {
         var textureName:String = null;
         var tile:MeshProp = null;
         var tName:String = null;
         var meshXML:XML = param1;
         var propData:PropData = this.propDatas[int(meshXML.attribute("prop-index"))];
         var prop:Prop = propData.prop;
         var position:Point3D = this.getPoint3DFromXML(meshXML.elements("position")[0]);
         var rotation:Number = Number(meshXML.elements("rotation-z"));
         prop = this.scene.addProp(prop,position,rotation,true,false);
         var free:Boolean = meshXML.@free == "true";
         this.scene.occupyMap.occupy(prop);
         textureName = null;
         if(meshXML.elements("texture-index").length() > 0)
         {
            textureName = propData.textureNames[int(meshXML.elements("texture-index")[0])];
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
      }
      
      private function processSprite(param1:XML) : void
      {
         var loc2:PropData = this.propDatas[int(param1.attribute("prop-index"))];
         var loc3:Prop = loc2.prop;
         var loc4:Point3D = this.getPoint3DFromXML(param1.elements("position")[0]);
         loc4.z += 0.1;
         loc3 = this.scene.addProp(loc3,loc4,0,true,false);
         var loc5:* = param1.@free == "true";
         if(!loc5)
         {
            this.scene.occupyMap.occupy(loc3);
         }
      }
      
      override protected function batchComplete(param1:int) : void
      {
         var loc2:Number = NaN;
         switch(this.loadingStage)
         {
            case STAGE_LOADING_MESHES:
               loc2 = param1 / (this.numMeshes + this.numSprites);
               break;
            case STAGE_LOADING_SPRITES:
               loc2 = (this.numMeshes + param1) / (this.numMeshes + this.numSprites);
         }
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(new EditorProgressEvent(loc2));
         }
      }
      
      override protected function batchExecutionComplete() : void
      {
         switch(this.loadingStage)
         {
            case STAGE_LOADING_MESHES:
               this.loadSprites();
               break;
            case STAGE_LOADING_SPRITES:
               this.completeLoading();
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
