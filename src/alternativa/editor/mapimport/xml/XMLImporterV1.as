package alternativa.editor.mapimport.xml
{
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.prop.ControlPoint;
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.editor.scene.MainScene;
   import alternativa.types.Point3D;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import mx.controls.Alert;
   
   public class XMLImporterV1 extends XMLImporterBase implements IXMLImporter
   {
      private static const BATCH_SIZE:int = 100;
      
      protected var mapXML:XML;
      
      protected var scene:MainScene;
      
      protected var libraryManager:LibraryManager;
      
      private var tiles:XMLList;
      
      public function XMLImporterV1()
      {
         super();
      }
      
      protected static function getDominationKeyPointKey() : String
      {
         return FunctionalProps.LIBRARY_NAME + FunctionalProps.GRP_DOMINATION + FunctionalProps.DOMINATION_POINT;
      }
      
      protected static function getPoint3DFromXML(param1:XML) : Point3D
      {
         return new Point3D(Number(param1.x),Number(param1.y),Number(param1.z));
      }
      
      protected static function getSpawnPointKey(param1:String) : String
      {
         if(param1.indexOf("dom") == 0)
         {
            return FunctionalProps.LIBRARY_NAME + FunctionalProps.GRP_DOMINATION + param1;
         }
         return FunctionalProps.LIBRARY_NAME + FunctionalProps.GRP_SPAWN_POINTS + param1;
      }
      
      public function importMap(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
         ErrorHandler.clearMessages();
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
         var loc1:XML = this.mapXML.child("static-geometry")[0];
         if(loc1)
         {
            this.tiles = loc1.elements("prop");
            startBatchExecution(BATCH_SIZE,this.tiles);
         }
         else
         {
            this.complete();
         }
      }
      
      protected function complete() : void
      {
         this.loadFunctionalElements();
         this.scene.view.visible = true;
         this.mapXML = null;
         this.scene = null;
         this.libraryManager = null;
         this.tiles = null;
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function loadFunctionalElements() : void
      {
         try
         {
            this.loadBonuses();
            this.loadSpawns();
            this.loadFlags();
            this.loadDominationControlPoints();
         }
         catch(e:Error)
         {
            Alert.show(e.message + " " + e.getStackTrace());
         }
      }
      
      override protected function processItem(param1:XML) : void
      {
         var propKey:String = null;
         var prop:Prop = null;
         var position:Point3D = null;
         var rotation:Number = NaN;
         var free:Boolean = false;
         var textureName:String = null;
         var tile:MeshProp = null;
         var tName:String = null;
         var item:XML = param1;
         try
         {
            propKey = item.attribute("library-name").toString() + item.attribute("group-name").toString() + item.attribute("name").toString();
            prop = this.libraryManager.propByKey[propKey];
            if(prop)
            {
               position = getPoint3DFromXML(item.position[0]);
               rotation = Number(item.rotation.z);
               /*if(prop is Sprite3DProp) - multiple import/export will cause growing offset
               {
                  position.z += 0.1;
               }*/
               prop = this.scene.addProp(prop,position,rotation,true,false);
               free = item.@free.toString() == "true";
               if(!(free && prop is Sprite3DProp))
               {
                  this.scene.occupyMap.occupy(prop);
               }
               textureName = item.elements("texture-name")[0];
               tile = prop as MeshProp;
               if(tile)
               {
                  if(!(tile is Sprite3DProp))
                  {
                     tile.collisionEnabled = !(item.@noCollision.toString() == "true");
                  }
                  try
                  {
                     if(textureName != "")
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
                        break;//
                     }
                     Alert.show("Tile " + tile.name + ": texture " + textureName + " not found");
                  }
               }
            }
            else
            {
               ErrorHandler.setMessage("Libraries are not loaded properly");
               ErrorHandler.addText(propKey + " can\'t be loaded");
               ErrorHandler.showWindow();
            }
         }
         catch(e:Error)
         {
            Alert.show(e.message + " " + e.getStackTrace());
         }
      }
      
      override protected function batchComplete(param1:int) : void
      {
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(new EditorProgressEvent(param1 / this.tiles.length()));
         }
      }
      
      override protected function batchExecutionComplete() : void
      {
         this.complete();
      }
      
      protected function loadFlags() : void
      {
         var loc1:XML = this.mapXML.elements("ctf-flags")[0];
         if(loc1)
         {
            this.addFlag(loc1.child("flag-red")[0],"red_flag");
            this.addFlag(loc1.child("flag-blue")[0],"blue_flag");
         }
      }
      
      protected function addFlag(param1:XML, param2:String) : void
      {
         var loc3:Prop = this.libraryManager.propByKey["FunctionalFlags" + param2];
         if(loc3 != null)
         {
            this.scene.addProp(loc3,new Point3D(Number(param1.x),Number(param1.y),Number(param1.z)),0,true,false);
            //this.scene.calculate();
         }
      }
      
      protected function loadBonuses() : void
      {
         var loc2:XMLList = null;
         var loc3:int = 0;
         var loc4:XML = null;
         var loc5:String = null;
         var loc6:FreeBonusRegion = null;
         var loc7:XMLList = null;
         var loc8:XML = null;
         var loc9:XMLList = null;
         var loc10:XML = null;
         var loc11:* = false;
         var loc1:XML = this.mapXML.elements("bonus-regions")[0];
         if(loc1)
         {
            loc2 = loc1.child("bonus-region");
            loc3 = 0;
            while(loc3 < loc2.length())
            {
               loc4 = loc2[loc3];
               loc5 = FunctionalProps.LIBRARY_NAME + FunctionalProps.GRP_BONUS_REGIONS + FunctionalProps.FREE_BONUS_NAME;
               loc6 = this.libraryManager.propByKey[loc5];
               if(loc6)
               {
                  loc7 = loc4.child("bonus-type");
                  loc6.typeNames.clear();
                  for each(loc8 in loc7)
                  {
                     loc6.typeNames.add(loc8.toString());
                  }
                  loc9 = loc4.child("game-mode");
                  loc6.gameModes.clear();
                  for each(loc10 in loc9)
                  {
                     loc6.gameModes.add(loc10.toString());
                  }
                  loc6 = FreeBonusRegion(this.scene.addProp(loc6,new Point3D(Number(loc4.position.x),Number(loc4.position.y),Number(loc4.position.z)),0,true,false));
                  loc6.minX = Number(loc4.min.x);
                  loc6.minY = Number(loc4.min.y);
                  loc6.minZ = Number(loc4.min.z);
                  loc6.maxx = Number(loc4.max.x);
                  loc6.maxy = Number(loc4.max.y);
                  loc6.maxz = Number(loc4.max.z);
                  if(loc4.hasOwnProperty("@parachute"))
                  {
                     loc6.parachute = loc4.@parachute;
                  }
                  loc11 = loc4.attribute("free").toString() == "true";
                  if(!loc11)
                  {
                     this.scene.occupyMap.occupy(loc6);
                  }
                  //this.scene.calculate();
               }
               loc3++;
            }
         }
      }
      
      protected function loadSpawns() : void
      {
         var loc2:XML = null;
         var loc1:XML = this.mapXML.elements("spawn-points")[0];
         if(loc1)
         {
            for each(loc2 in loc1.child("spawn-point"))
            {
               this.createSpawnPoint(loc2);
            }
         }
      }
      
      protected function createSpawnPoint(param1:XML) : SpawnPoint
      {
         var loc4:XML = null;
         var loc5:XML = null;
         var loc6:* = false;
         var loc2:String = getSpawnPointKey(param1.attribute("type").toString());
         var loc3:Prop = this.libraryManager.propByKey[loc2];
         if(loc3)
         {
            loc4 = param1.child("position")[0];
            loc5 = param1.child("rotation")[0];
            loc3 = this.scene.addProp(loc3,new Point3D(Number(loc4.child("x")[0]),Number(loc4.child("y")[0]),Number(loc4.child("z")[0])),Number(loc5.child("z")[0]),true,false);
            loc6 = param1.attribute("free").toString() == "true";
            if(!loc6)
            {
               this.scene.occupyMap.occupy(loc3);
            }
            //this.scene.calculate();
         }
         return SpawnPoint(loc3);
      }
      
      protected function loadDominationControlPoints() : void
      {
         var loc2:XMLList = null;
         var loc3:Prop = null;
         var loc4:XML = null;
         var loc5:XML = null;
         var loc6:Prop = null;
         var loc7:* = false;
         var loc1:XML = this.mapXML.elements("dom-keypoints")[0];
         if(loc1)
         {
            loc2 = loc1.child("dom-keypoint");
            loc3 = this.libraryManager.propByKey[getDominationKeyPointKey()];
            for each(loc4 in loc2)
            {
               loc5 = loc4.child("position")[0];
               loc6 = this.scene.addProp(loc3,new Point3D(Number(loc5.child("x")[0]),Number(loc5.child("y")[0]),Number(loc5.child("z")[0])),0,true,false);
               loc7 = loc4.attribute("free").toString() == "true";
               ControlPoint(loc6).controlPointName = loc4.@name;
               if(!loc7)
               {
                  this.scene.occupyMap.occupy(loc6);
               }
               this.loadDominationPointSpawns(loc4,ControlPoint(loc6));
               //this.scene.calculate();
            }
         }
      }
      
      protected function loadDominationPointSpawns(param1:XML, param2:ControlPoint) : void
      {
         var loc3:XML = null;
         var loc4:SpawnPoint = null;
         for each(loc3 in param1.elements("spawn-point"))
         {
            loc4 = this.createSpawnPoint(loc3);
            param2.addSpawnPoint(loc4);
         }
      }
   }
}

