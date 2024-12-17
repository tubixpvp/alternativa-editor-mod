package alternativa.engine3d.physics
{
   import alternativa.engine3d.core.Face;
   import alternativa.types.Point3D;
   
   public class Collision
   {
      public var face:Face;
      
      public var normal:Point3D;
      
      public var offset:Number;
      
      public var point:Point3D;
      
      public function Collision()
      {
         super();
      }
   }
}

