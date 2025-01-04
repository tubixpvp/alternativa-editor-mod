package alternativa.editor.mapimport
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.mapimport.xml.XMLImporterV1;
   import alternativa.editor.mapimport.xml.XMLImporterV1Full;
   import alternativa.editor.mapimport.xml.XMLImporterV2;
   import alternativa.editor.mapimport.xml.XMLImporterV3;
   import alternativa.editor.scene.MainScene;
   import flash.events.Event;
   import flash.filesystem.FileStream;
   import mx.controls.Alert;
   import alternativa.editor.mapimport.xml.IXMLImporter;
   
   public class TanksXmlImporter extends FileImporter
   {
      private static const DEFAULT_IMPORTER:String = "1.0";

      private var importers:Object;
      
      public function TanksXmlImporter(param1:MainScene, param2:LibraryManager)
      {
         super(param1,param2);
         this.importers = {};
         this.addImporter("1.0.Light",new XMLImporterV1());
         this.addImporter("1.0",new XMLImporterV1Full());
         this.addImporter("2.0",new XMLImporterV2());
         this.addImporter("3.0",new XMLImporterV3());
      }
      
      override public function importFromFileStream(param1:FileStream) : void
      {
         var loc2:XML = new XML(param1.readUTFBytes(param1.bytesAvailable));
         param1.close();
         var loc3:String = loc2.attribute("version")[0];
         var loc4:IXMLImporter = this.importers[loc3];
         if(loc4 == null)
         {
            loc4 = this.importers[DEFAULT_IMPORTER];
            Alert.show("Unsupported importer version " + loc3 + "! 1.0 is used as a default");
         }
         loc4.importMap(loc2,scene,libraryManager);
      }
      
      public function specialImport(param1:FileStream) : void
      {
         var loc2:XML = new XML(param1.readUTFBytes(param1.bytesAvailable));
         param1.close();
         var loc3:String = loc2.attribute("version")[0];
         var loc4:IXMLImporter = this.importers[loc3];
         if(loc4 == null)
         {
            loc4 = this.importers[DEFAULT_IMPORTER];
            Alert.show("Unsupported importer version " + loc3 + "! 1.0 is used as a default");
         }
         loc4.addInternalObjectsToExistingScene(loc2,scene,libraryManager);
      }
      
      private function addImporter(param1:String, param2:IXMLImporter) : void
      {
         this.importers[param1] = param2;
         param2.addEventListener(Event.COMPLETE,this.onImportComplete);
         param2.addEventListener(EditorProgressEvent.PROGRESS,this.onImportProgress);
      }
      
      private function onImportComplete(param1:Event) : void
      {
         endLoadLevel();
      }
      
      private function onImportProgress(param1:EditorProgressEvent) : void
      {
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(param1);
         }
      }
   }
}

