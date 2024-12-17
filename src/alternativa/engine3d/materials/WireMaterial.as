package alternativa.engine3d.materials
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.PolyPrimitive;
   import alternativa.engine3d.display.Skin;
   import flash.display.Graphics;
   
   use namespace alternativa3d;
   
   public class WireMaterial extends SurfaceMaterial
   {
      alternativa3d var _color:uint;
      
      alternativa3d var _thickness:Number;
      
      public function WireMaterial(param1:Number = 0, param2:uint = 0, param3:Number = 1, param4:String = "normal")
      {
         super(param3,param4);
         this.alternativa3d::_color = param2;
         this.alternativa3d::_thickness = param1;
      }
      
      override alternativa3d function canDraw(param1:PolyPrimitive) : Boolean
      {
         return this.alternativa3d::_thickness >= 0;
      }
      
      override alternativa3d function draw(param1:Camera3D, param2:Skin, param3:uint, param4:Array) : void
      {
         var loc5:uint = 0;
         var loc6:DrawPoint = null;
         var loc8:Number = NaN;
         param2.alpha = alternativa3d::_alpha;
         param2.blendMode = alternativa3d::_blendMode;
         var loc7:Graphics = param2.alternativa3d::gfx;
         if(param1.alternativa3d::_orthographic)
         {
            loc7.lineStyle(this.alternativa3d::_thickness,this.alternativa3d::_color);
            loc6 = param4[param3 - 1];
            loc7.moveTo(loc6.x,loc6.y);
            loc5 = 0;
            while(loc5 < param3)
            {
               loc6 = param4[loc5];
               loc7.lineTo(loc6.x,loc6.y);
               loc5++;
            }
         }
         else
         {
            loc7.lineStyle(this.alternativa3d::_thickness,this.alternativa3d::_color);
            loc6 = param4[param3 - 1];
            loc8 = param1.alternativa3d::_focalLength / loc6.z;
            loc7.moveTo(loc6.x * loc8,loc6.y * loc8);
            loc5 = 0;
            while(loc5 < param3)
            {
               loc6 = param4[loc5];
               loc8 = param1.alternativa3d::_focalLength / loc6.z;
               loc7.lineTo(loc6.x * loc8,loc6.y * loc8);
               loc5++;
            }
         }
      }
      
      public function get color() : uint
      {
         return this.alternativa3d::_color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this.alternativa3d::_color != param1)
         {
            this.alternativa3d::_color = param1;
            markToChange();
         }
      }
      
      public function get thickness() : Number
      {
         return this.alternativa3d::_thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this.alternativa3d::_thickness != param1)
         {
            this.alternativa3d::_thickness = param1;
            markToChange();
         }
      }
      
      override public function clone() : Material
      {
         return new WireMaterial(this.alternativa3d::_thickness,this.alternativa3d::_color,alternativa3d::_alpha,alternativa3d::_blendMode);
      }
   }
}

