package alternativa.engine3d.loaders
{
   public class TextureMapsInfo
   {
      public var diffuseMapFileName:String;
      
      public var opacityMapFileName:String;
      
      public function TextureMapsInfo(param1:String = null, param2:String = null)
      {
         super();
         this.diffuseMapFileName = param1;
         this.opacityMapFileName = param2;
      }
      
      public function toString() : String
      {
         return "[Object TextureMapsInfo, diffuseMapFileName:" + this.diffuseMapFileName + ", opacityMapFileName: " + this.opacityMapFileName + "]";
      }
   }
}

