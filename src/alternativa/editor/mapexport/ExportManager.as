package alternativa.editor.mapexport
{
   import alternativa.editor.scene.MainScene;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class ExportManager
   {
      private var mainScene:MainScene;
      
      private var file:File;
      
      private var fileType:FileType;
      
      public function ExportManager(param1:MainScene)
      {
         super();
         this.mainScene = param1;
         this.file = new File();
         this.file.addEventListener(Event.SELECT,this.onFileSelected);
      }
      
      public function exportMap(param1:FileType) : void
      {
         this.fileType = param1;
         this.file.browseForSave("Save");
      }
      
      private function onFileSelected(param1:Event) : void
      {
         var loc2:FileStream = new FileStream();
         loc2.open(this.file,FileMode.WRITE);
         this.mainScene.exportScene(this.fileType,loc2);
         loc2.close();
      }
   }
}

