package alternativa.types
{
   import flash.display.BitmapData;
   
   use namespace alternativatypes;
   
   public class Texture
   {
      alternativatypes var _height:uint;
      
      alternativatypes var _width:uint;
      
      alternativatypes var _name:String;
      
      alternativatypes var _bitmapData:BitmapData;
      
      public function Texture(param1:BitmapData, param2:String = null)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Cannot create texture from null bitmapData");
         }
         alternativatypes::_bitmapData = param1;
         alternativatypes::_width = param1.width;
         alternativatypes::_height = param1.height;
         alternativatypes::_name = param2;
      }
      
      public function get name() : String
      {
         return alternativatypes::_name;
      }
      
      public function get width() : uint
      {
         return alternativatypes::_width;
      }
      
      public function get height() : uint
      {
         return alternativatypes::_height;
      }
      
      public function get bitmapData() : BitmapData
      {
         return alternativatypes::_bitmapData;
      }
      
      public function toString() : String
      {
         return "[Texture " + (alternativatypes::_name != null ? alternativatypes::_name : "") + " " + alternativatypes::_width + "x" + alternativatypes::_height + "]";
      }
   }
}

