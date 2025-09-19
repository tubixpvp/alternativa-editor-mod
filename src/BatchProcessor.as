package
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.mapexport.FileType;
   import alternativa.editor.mapimport.TanksXmlImporter;
   import alternativa.editor.scene.MainScene;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class BatchProcessor extends EventDispatcher
   {
      private var files:Vector.<File>;
      
      private var currentFileIndex:int;
      
      private var importer:TanksXmlImporter;
      
      private var mainScene:MainScene;
      
      public function BatchProcessor(param1:MainScene, param2:LibraryManager)
      {
         super();
         this.mainScene = param1;
         this.importer = new TanksXmlImporter(param1,param2);
         this.importer.addEventListener(Event.COMPLETE,this.onImportComplete);
         this.importer.addEventListener(EditorProgressEvent.PROGRESS,this.onProgress);
      }
      
      private static function selectXMLFiles(param1:Array) : Vector.<File>
      {
         var loc3:File = null;
         var loc2:Vector.<File> = new Vector.<File>();
         for each(loc3 in param1)
         {
            if(loc3.extension.toLowerCase() == "xml")
            {
               loc2.push(loc3);
            }
         }
         return loc2;
      }
      
      private function onProgress(param1:EditorProgressEvent) : void
      {
         var loc2:Number = 1 / this.files.length;
         dispatchEvent(new EditorProgressEvent((this.currentFileIndex + param1.progress) * loc2));
      }
      
      public function run(param1:Array) : void
      {
         this.files = selectXMLFiles(param1);
         this.currentFileIndex = -1;
         this.processNextFile();
      }
      
      private function processNextFile() : void
      {
         ++this.currentFileIndex;
         if(this.currentFileIndex < this.files.length)
         {
            this.importFile();
         }
         else
         {
            this.complete();
         }
      }
      
      private function importFile() : void
      {
         this.mainScene.clear();
         var loc1:FileStream = new FileStream();
         loc1.open(this.getCurrentFile(),FileMode.READ);
         this.importer.importFromFileStream(loc1);
      }
      
      private function onImportComplete(param1:Event) : void
      {
         var loc2:FileStream = new FileStream();
         loc2.open(this.getCurrentFile(),FileMode.WRITE);
         this.mainScene.exportScene(FileType.MAP_XML_VERSION_1_FULL,loc2,null);
         this.processNextFile();
      }
      
      private function getCurrentFile() : File
      {
         return this.files[this.currentFileIndex];
      }
      
      private function complete() : void
      {
         this.files = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

