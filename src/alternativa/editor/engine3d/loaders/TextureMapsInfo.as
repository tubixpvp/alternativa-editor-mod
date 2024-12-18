package alternativa.editor.engine3d.loaders
{
   public class TextureMapsInfo
   {
      public var opacityMapFileName:String;
      
      public var diffuseMapFileName:String;
      
      public function TextureMapsInfo(diffuseMapFileName:String = null, opacityMapFileName:String = null)
      {
         super();
         this.diffuseMapFileName = diffuseMapFileName;
         this.opacityMapFileName = opacityMapFileName;
      }
   }
}

