package alternativa.editor.scene
{
   import flash.geom.Point;
   
   public class CameraFacing
   {
      public static const X:CameraFacing = new CameraFacing(-1,0);
      
      public static const Y:CameraFacing = new CameraFacing(0,1);
      
      public static const NEGATIVE_X:CameraFacing = new CameraFacing(1,0);
      
      public static const NEGATIVE_Y:CameraFacing = new CameraFacing(0,-1);
      
      private var sin:Number;
      
      private var cos:Number;
      
      public function CameraFacing(param1:Number, param2:Number)
      {
         super();
         this.sin = param1;
         this.cos = param2;
      }
      
      public function getGlobalVector(param1:Point) : Point
      {
         var loc2:Point = new Point();
         loc2.x = this.cos * param1.x - this.sin * param1.y;
         loc2.y = this.sin * param1.x + this.cos * param1.y;
         return loc2;
      }
   }
}

