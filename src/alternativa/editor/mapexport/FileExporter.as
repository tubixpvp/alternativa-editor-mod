package alternativa.editor.mapexport
{
   import flash.filesystem.FileStream;
   import alternativa.engine3d.core.Object3DContainer;
   
   public class FileExporter
   {
      public var sceneRoot:Object3DContainer;
      
      public function FileExporter(param1:Object3DContainer)
      {
         super();
         this.sceneRoot = param1;
      }
      
      public function exportToFileStream(param1:FileStream) : void
      {
      }
   }
}

