package alternativa.editor
{
   import flash.display.Bitmap;
   
   public class InvisibleTexture
   {
      private static const InvisibleTextureClass:Class = InvisibleTexture_InvisibleTextureClass;
      
      public static const invisibleTexture:Bitmap = new InvisibleTextureClass();
      
      public static const TEXTURE_NAME:String = "invisible";
      
      public function InvisibleTexture()
      {
         super();
      }
   }
}

