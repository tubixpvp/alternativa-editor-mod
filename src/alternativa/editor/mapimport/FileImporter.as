package alternativa.editor.mapimport
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.scene.MainScene;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filesystem.FileStream;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   
   public class FileImporter extends EventDispatcher
   {
      protected var scene:MainScene;
      
      protected var libraryManager:LibraryManager;
      
      protected var libname:String = "";
      
      public function FileImporter(param1:MainScene, param2:LibraryManager)
      {
         super();
         this.scene = param1;
         this.libraryManager = param2;
      }
      
      public function importFromFileStream(param1:FileStream) : void
      {
      }
      
      protected function libAlertListener(param1:CloseEvent) : void
      {
         switch(param1.detail)
         {
            case Alert.YES:
               break;
            case Alert.NO:
               this.scene.clear();
               this.endLoadLevel();
         }
      }
      
      protected function endLoadLevel() : void
      {
         this.scene.changed = false;
         this.libname = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

