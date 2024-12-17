package alternativa.editor.mapexport
{
   import alternativa.engine3d.core.Object3D;
   import flash.filesystem.FileStream;
   
   public class FileExporter
   {
      public var sceneRoot:Object3D;
      
      public function FileExporter(param1:Object3D)
      {
         super();
         this.sceneRoot = param1;
      }
      
      public function exportToFileStream(param1:FileStream) : void
      {
      }
   }
}

