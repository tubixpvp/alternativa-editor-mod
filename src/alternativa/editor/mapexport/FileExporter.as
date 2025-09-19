package alternativa.editor.mapexport
{
   import flash.filesystem.FileStream;
   import alternativa.engine3d.core.Object3DContainer;
   
   public class FileExporter
   {
      public var sceneRoot:Object3DContainer;
      
      public function FileExporter(sceneRoot:Object3DContainer)
      {
         super();
         this.sceneRoot = sceneRoot;
      }
      
      public function exportToFileStream(stream:FileStream, exportSettings:Object) : void
      {
      }
   }
}

