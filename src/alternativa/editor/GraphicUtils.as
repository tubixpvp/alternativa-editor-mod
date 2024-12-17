package alternativa.editor
{
   import alternativa.types.Point3D;
   import flash.display.Graphics;
   
   public class GraphicUtils
   {
      public function GraphicUtils()
      {
         super();
      }
      
      public static function drawLine(param1:Graphics, param2:Point3D, param3:Point3D) : void
      {
         param1.moveTo(param2.x,param2.y);
         param1.lineTo(param3.x,param3.y);
      }
   }
}

