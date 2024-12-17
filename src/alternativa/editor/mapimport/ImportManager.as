package alternativa.editor.mapimport
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.scene.MainScene;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.FileFilter;
   import flash.utils.setTimeout;
   
   public class ImportManager extends EventDispatcher
   {
      private var mainScene:MainScene;
      
      private var tanksXmlImporter:TanksXmlImporter;
      
      private var file:File;
      
      private var xmlFilter:FileFilter;
      
      private var loadSpecials:Boolean;
      
      public function ImportManager(param1:MainScene, param2:LibraryManager)
      {
         this.xmlFilter = new FileFilter("Tanks level (*.xml)","*.xml");
         super();
         this.mainScene = param1;
         this.tanksXmlImporter = new TanksXmlImporter(param1,param2);
         this.tanksXmlImporter.addEventListener(Event.COMPLETE,this.onLeveleLoadingComplete);
         this.tanksXmlImporter.addEventListener(EditorProgressEvent.PROGRESS,this.onLeveleLoadingProgress);
         this.file = new File();
         this.file.addEventListener(Event.SELECT,this.onFileSelected);
      }
      
      public function importFromXML(param1:Boolean = false) : void
      {
         this.loadSpecials = param1;
         this.file.browseForOpen("Open",[this.xmlFilter]);
      }
      
      private function onFileSelected(param1:Event) : void
      {
         if(hasEventListener(Event.OPEN))
         {
            dispatchEvent(new Event(Event.OPEN));
         }
         if(this.loadSpecials)
         {
            setTimeout(this.startSpecialImport,100);
         }
         else
         {
            setTimeout(this.startImport,100);
         }
      }
      
      public function startImport(param1:File = null) : void
      {
         var loc2:FileStream = new FileStream();
         loc2.open(!!param1 ? param1 : this.file,FileMode.READ);
         this.tanksXmlImporter.importFromFileStream(loc2);
      }
      
      public function startSpecialImport(param1:File = null) : void
      {
         var loc2:FileStream = new FileStream();
         loc2.open(!!param1 ? param1 : this.file,FileMode.READ);
         this.tanksXmlImporter.specialImport(loc2);
      }
      
      public function clearScene() : void
      {
         this.mainScene.clear();
      }
      
      private function onLeveleLoadingComplete(param1:Event) : void
      {
         this.mainScene.changed = false;
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(param1);
         }
      }
      
      private function onLeveleLoadingProgress(param1:EditorProgressEvent) : void
      {
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(param1);
         }
      }
   }
}

