package alternativa.engine3d.materials
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.display.Skin;
   import flash.display.Graphics;
   
   use namespace alternativa3d;
   
   public class FillMaterial extends SurfaceMaterial
   {
      alternativa3d var _color:uint;
      
      alternativa3d var _wireThickness:Number;
      
      alternativa3d var _wireColor:uint;
      
      public function FillMaterial(param1:uint, param2:Number = 1, param3:String = "normal", param4:Number = -1, param5:uint = 0)
      {
         super(param2,param3);
         this.alternativa3d::_color = param1;
         this.alternativa3d::_wireThickness = param4;
         this.alternativa3d::_wireColor = param5;
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
            loc7.beginFill(this.alternativa3d::_color);
            if(this.alternativa3d::_wireThickness >= 0)
            {
               loc7.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
            }
            loc6 = param4[0];
            loc7.moveTo(loc6.x,loc6.y);
            loc5 = 1;
            while(loc5 < param3)
            {
               loc6 = param4[loc5];
               loc7.lineTo(loc6.x,loc6.y);
               loc5++;
            }
            if(this.alternativa3d::_wireThickness >= 0)
            {
               loc6 = param4[0];
               loc7.lineTo(loc6.x,loc6.y);
            }
         }
         else
         {
            loc7.beginFill(this.alternativa3d::_color);
            if(this.alternativa3d::_wireThickness >= 0)
            {
               loc7.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
            }
            loc6 = param4[0];
            loc8 = param1.alternativa3d::_focalLength / loc6.z;
            loc7.moveTo(loc6.x * loc8,loc6.y * loc8);
            loc5 = 1;
            while(loc5 < param3)
            {
               loc6 = param4[loc5];
               loc8 = param1.alternativa3d::_focalLength / loc6.z;
               loc7.lineTo(loc6.x * loc8,loc6.y * loc8);
               loc5++;
            }
            if(this.alternativa3d::_wireThickness >= 0)
            {
               loc6 = param4[0];
               loc8 = param1.alternativa3d::_focalLength / loc6.z;
               loc7.lineTo(loc6.x * loc8,loc6.y * loc8);
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
      
      public function get wireThickness() : Number
      {
         return this.alternativa3d::_wireThickness;
      }
      
      public function set wireThickness(param1:Number) : void
      {
         if(this.alternativa3d::_wireThickness != param1)
         {
            this.alternativa3d::_wireThickness = param1;
            markToChange();
         }
      }
      
      public function get wireColor() : uint
      {
         return this.alternativa3d::_wireColor;
      }
      
      public function set wireColor(param1:uint) : void
      {
         if(this.alternativa3d::_wireColor != param1)
         {
            this.alternativa3d::_wireColor = param1;
            markToChange();
         }
      }
      
      override public function clone() : Material
      {
         return new FillMaterial(this.alternativa3d::_color,alternativa3d::_alpha,alternativa3d::_blendMode,this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
      }
   }
}

