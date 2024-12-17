package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.display.Skin;
   
   use namespace alternativa3d;
   
   public class Material
   {
      alternativa3d var _alpha:Number;
      
      alternativa3d var _blendMode:String;
      
      public function Material(param1:Number, param2:String)
      {
         super();
         this.alternativa3d::_alpha = param1;
         this.alternativa3d::_blendMode = param2;
      }
      
      public function get alpha() : Number
      {
         return this.alternativa3d::_alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this.alternativa3d::_alpha != param1)
         {
            this.alternativa3d::_alpha = param1;
            this.markToChange();
         }
      }
      
      public function get blendMode() : String
      {
         return this.alternativa3d::_blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(this.alternativa3d::_blendMode != param1)
         {
            this.alternativa3d::_blendMode = param1;
            this.markToChange();
         }
      }
      
      protected function markToChange() : void
      {
      }
      
      alternativa3d function clear(param1:Skin) : void
      {
         param1.alternativa3d::gfx.clear();
      }
      
      public function clone() : Material
      {
         return new Material(this.alternativa3d::_alpha,this.alternativa3d::_blendMode);
      }
   }
}

