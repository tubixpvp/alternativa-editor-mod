package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class SpritePrimitive extends PolyPrimitive
   {
      alternativa3d var sprite:Sprite3D;
      
      alternativa3d var screenDepth:Number;
      
      public function SpritePrimitive()
      {
         super();
      }
      
      override public function toString() : String
      {
         return "[SpritePrimitive " + this.alternativa3d::sprite.toString() + "]";
      }
   }
}

