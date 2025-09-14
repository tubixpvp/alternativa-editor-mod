package alternativa.editor.mapimport.xml
{
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.LibraryManager;
   import alternativa.editor.prop.KillBox;
   import alternativa.editor.scene.MainScene;
   import alternativa.types.Point3D;
   import flash.events.Event;
   import mx.controls.Alert;
   
   public class XMLImporterV1Full extends XMLImporterV1
   {
      public function XMLImporterV1Full()
      {
         super();
      }
      
      override protected function loadFunctionalElements() : void
      {
         try
         {
            loadBonuses();
            loadSpawns();
            loadFlags();
            this.loadKillZones();
            loadDominationControlPoints();
         }
         catch(e:Error)
         {
            Alert.show(e.message + " " + e.getStackTrace());
         }
      }
      
      override public function addInternalObjectsToExistingScene(param1:XML, param2:MainScene, param3:LibraryManager) : void
      {
         ErrorHandler.clearMessages();
         this.mapXML = param1;
         this.scene = param2;
         this.libraryManager = param3;
         this.scene.view.visible = false;
         this.loadKillZones();
         this.scene.view.visible = true;
         this.mapXML = null;
         this.scene = null;
         this.libraryManager = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function loadKillZones() : void
      {
         var loc2:int = 0;
         var loc1:XMLList = mapXML.*.elements(FunctionalProps.KILL_BOX_NAME);
         if(loc1)
         {
            loc2 = 0;
            while(loc2 < loc1.length())
            {
               this.addKillZone(loc1[loc2],FunctionalProps.KILL_GEOMETRY);
               loc2++;
            }
         }
      }
      
      protected function addKillZone(param1:XML, param2:String) : void
      {
         var loc3:KillBox = KillBox(libraryManager.propByKey["Functional" + FunctionalProps.KILL_GEOMETRY + param2]);
         if(loc3 != null)
         {
            loc3 = KillBox(scene.addProp(loc3,new Point3D(Number(param1.position.x),Number(param1.position.y),Number(param1.position.z)),0,true,false));
            loc3.minX = Number(param1.minX);
            loc3.minY = Number(param1.minY);
            loc3.minZ = Number(param1.minZ);
            loc3.maxx = Number(param1.maxX);
            loc3.maxy = Number(param1.maxY);
            loc3.maxz = Number(param1.maxZ);
            loc3.action = param1.action;
            //scene.calculate();
         }
      }
   }
}

