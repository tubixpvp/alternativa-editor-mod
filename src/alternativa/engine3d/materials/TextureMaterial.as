package alternativa.engine3d.materials
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.PolyPrimitive;
   import alternativa.engine3d.display.Skin;
   import alternativa.types.*;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   use namespace alternativa3d;
   use namespace alternativatypes;
   
   public class TextureMaterial extends SurfaceMaterial
   {
      private static var stubBitmapData:BitmapData;
      
      private static var stubMatrix:Matrix;
      
      private var gfx:Graphics;
      
      private var textureMatrix:Matrix;
      
      private var focalLength:Number;
      
      private var distortion:Number;
      
      alternativa3d var _texture:Texture;
      
      alternativa3d var _repeat:Boolean;
      
      alternativa3d var _smooth:Boolean;
      
      alternativa3d var _precision:Number;
      
      alternativa3d var _wireThickness:Number;
      
      alternativa3d var _wireColor:uint;
      
      public function TextureMaterial(param1:Texture, param2:Number = 1, param3:Boolean = true, param4:Boolean = false, param5:String = "normal", param6:Number = -1, param7:uint = 0, param8:Number = 10)
      {
         this.textureMatrix = new Matrix();
         super(param2,param5);
         this.alternativa3d::_texture = param1;
         this.alternativa3d::_repeat = param3;
         this.alternativa3d::_smooth = param4;
         this.alternativa3d::_wireThickness = param6;
         this.alternativa3d::_wireColor = param7;
         this.alternativa3d::_precision = param8;
         alternativa3d::useUV = true;
      }
      
      override alternativa3d function canDraw(param1:PolyPrimitive) : Boolean
      {
         return this.alternativa3d::_texture != null;
      }
      
      override alternativa3d function draw(param1:Camera3D, param2:Skin, param3:uint, param4:Array) : void
      {
         var loc5:uint = 0;
         var loc6:DrawPoint = null;
         var loc7:Number = NaN;
         var loc8:Face = null;
         var loc9:uint = 0;
         var loc10:uint = 0;
         var loc11:uint = 0;
         var loc12:uint = 0;
         var loc13:* = false;
         var loc14:DrawPoint = null;
         var loc15:DrawPoint = null;
         var loc16:DrawPoint = null;
         var loc17:Number = NaN;
         var loc18:Number = NaN;
         var loc19:Number = NaN;
         var loc20:Number = NaN;
         var loc21:Number = NaN;
         var loc22:Number = NaN;
         var loc23:Number = NaN;
         var loc24:Number = NaN;
         var loc25:Number = NaN;
         var loc26:Number = NaN;
         var loc27:Number = NaN;
         param2.alpha = alternativa3d::_alpha;
         param2.blendMode = alternativa3d::_blendMode;
         this.gfx = param2.alternativa3d::gfx;
         if(param2.alternativa3d::primitive.alternativa3d::face.alternativa3d::uvMatrixBase == null)
         {
            if(stubBitmapData == null)
            {
               stubBitmapData = new BitmapData(2,2,false,0);
               stubBitmapData.setPixel(0,0,16711935);
               stubBitmapData.setPixel(1,1,16711935);
               stubMatrix = new Matrix(10,0,0,10,0,0);
            }
            this.gfx.beginBitmapFill(stubBitmapData,stubMatrix);
            if(param1.alternativa3d::_orthographic)
            {
               if(this.alternativa3d::_wireThickness >= 0)
               {
                  this.gfx.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
               }
               loc6 = param4[0];
               this.gfx.moveTo(loc6.x,loc6.y);
               loc5 = 1;
               while(loc5 < param3)
               {
                  loc6 = param4[loc5];
                  this.gfx.lineTo(loc6.x,loc6.y);
                  loc5++;
               }
               if(this.alternativa3d::_wireThickness >= 0)
               {
                  loc6 = param4[0];
                  this.gfx.lineTo(loc6.x,loc6.y);
               }
            }
            else
            {
               if(this.alternativa3d::_wireThickness >= 0)
               {
                  this.gfx.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
               }
               loc6 = param4[0];
               loc7 = param1.alternativa3d::_focalLength / loc6.z;
               this.gfx.moveTo(loc6.x * loc7,loc6.y * loc7);
               loc5 = 1;
               while(loc5 < param3)
               {
                  loc6 = param4[loc5];
                  loc7 = param1.alternativa3d::_focalLength / loc6.z;
                  this.gfx.lineTo(loc6.x * loc7,loc6.y * loc7);
                  loc5++;
               }
               if(this.alternativa3d::_wireThickness >= 0)
               {
                  loc6 = param4[0];
                  loc7 = param1.alternativa3d::_focalLength / loc6.z;
                  this.gfx.lineTo(loc6.x * loc7,loc6.y * loc7);
               }
            }
            return;
         }
         if(param1.alternativa3d::_orthographic)
         {
            loc8 = param2.alternativa3d::primitive.alternativa3d::face;
            if(!param1.alternativa3d::uvMatricesCalculated[loc8])
            {
               param1.alternativa3d::calculateUVMatrix(loc8,this.alternativa3d::_texture.alternativatypes::_width,this.alternativa3d::_texture.alternativatypes::_height);
            }
            this.gfx.beginBitmapFill(this.alternativa3d::_texture.alternativatypes::_bitmapData,loc8.alternativa3d::orthoTextureMatrix,this.alternativa3d::_repeat,this.alternativa3d::_smooth);
            if(this.alternativa3d::_wireThickness >= 0)
            {
               this.gfx.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
            }
            loc6 = param4[0];
            this.gfx.moveTo(loc6.x,loc6.y);
            loc5 = 1;
            while(loc5 < param3)
            {
               loc6 = param4[loc5];
               this.gfx.lineTo(loc6.x,loc6.y);
               loc5++;
            }
            if(this.alternativa3d::_wireThickness >= 0)
            {
               loc6 = param4[0];
               this.gfx.lineTo(loc6.x,loc6.y);
            }
         }
         else
         {
            this.focalLength = param1.alternativa3d::_focalLength;
            this.distortion = param1.alternativa3d::focalDistortion * this.alternativa3d::_precision;
            loc9 = 0;
            loc10 = param3 - 1;
            loc11 = 1;
            loc12 = loc10 > 0 ? loc10 - 1 : param3 - 1;
            loc13 = true;
            loc14 = param4[loc10];
            loc16 = param4[loc9];
            if(this.alternativa3d::_precision > 0)
            {
               loc17 = loc14.x / loc14.z;
               loc18 = loc14.y / loc14.z;
               loc21 = loc16.x / loc16.z;
               loc22 = loc16.y / loc16.z;
               loc23 = (loc16.x + loc14.x) / (loc16.z + loc14.z) - 0.5 * (loc21 + loc17);
               loc24 = (loc16.y + loc14.y) / (loc16.z + loc14.z) - 0.5 * (loc22 + loc18);
               loc27 = loc23 * loc23 + loc24 * loc24;
               while(loc9 != loc12)
               {
                  if(loc13)
                  {
                     loc14 = param4[loc9];
                     loc15 = param4[loc11];
                     loc16 = param4[loc10];
                     loc19 = loc17;
                     loc20 = loc18;
                     loc17 = loc21;
                     loc18 = loc22;
                     loc21 = loc19;
                     loc22 = loc20;
                     loc19 = loc15.x / loc15.z;
                     loc20 = loc15.y / loc15.z;
                     loc23 = (loc15.x + loc16.x) / (loc15.z + loc16.z) - 0.5 * (loc19 + loc21);
                     loc24 = (loc15.y + loc16.y) / (loc15.z + loc16.z) - 0.5 * (loc20 + loc22);
                     loc26 = loc23 * loc23 + loc24 * loc24;
                     loc9 = loc11;
                     loc11 = loc9 < param3 - 1 ? uint(loc9 + 1) : 0;
                  }
                  else
                  {
                     loc14 = param4[loc12];
                     loc15 = param4[loc10];
                     loc16 = param4[loc9];
                     loc17 = loc19;
                     loc18 = loc20;
                     loc19 = loc21;
                     loc20 = loc22;
                     loc21 = loc17;
                     loc22 = loc18;
                     loc17 = loc14.x / loc14.z;
                     loc18 = loc14.y / loc14.z;
                     loc23 = (loc16.x + loc14.x) / (loc16.z + loc14.z) - 0.5 * (loc21 + loc17);
                     loc24 = (loc16.y + loc14.y) / (loc16.z + loc14.z) - 0.5 * (loc22 + loc18);
                     loc27 = loc23 * loc23 + loc24 * loc24;
                     loc10 = loc12;
                     loc12 = loc10 > 0 ? loc10 - 1 : param3 - 1;
                  }
                  if((loc19 - loc17) * (loc22 - loc18) - (loc20 - loc18) * (loc21 - loc17) < -param1.alternativa3d::focalDistortion)
                  {
                     loc23 = (loc14.x + loc15.x) / (loc14.z + loc15.z) - 0.5 * (loc17 + loc19);
                     loc24 = (loc14.y + loc15.y) / (loc14.z + loc15.z) - 0.5 * (loc18 + loc20);
                     loc25 = loc23 * loc23 + loc24 * loc24;
                     this.bisection(loc14.x,loc14.y,loc14.z,loc14.u,loc14.v,loc15.x,loc15.y,loc15.z,loc15.u,loc15.v,loc16.x,loc16.y,loc16.z,loc16.u,loc16.v,loc25,loc26,loc27);
                  }
                  loc13 = !loc13;
               }
            }
            else
            {
               loc17 = this.focalLength * loc14.x / loc14.z;
               loc18 = this.focalLength * loc14.y / loc14.z;
               loc21 = this.focalLength * loc16.x / loc16.z;
               loc22 = this.focalLength * loc16.y / loc16.z;
               while(loc9 != loc12)
               {
                  if(loc13)
                  {
                     loc14 = param4[loc9];
                     loc15 = param4[loc11];
                     loc16 = param4[loc10];
                     loc19 = loc17;
                     loc20 = loc18;
                     loc17 = loc21;
                     loc18 = loc22;
                     loc21 = loc19;
                     loc22 = loc20;
                     loc19 = this.focalLength * loc15.x / loc15.z;
                     loc20 = this.focalLength * loc15.y / loc15.z;
                     loc9 = loc11;
                     loc11 = loc9 < param3 - 1 ? uint(loc9 + 1) : 0;
                  }
                  else
                  {
                     loc14 = param4[loc12];
                     loc15 = param4[loc10];
                     loc16 = param4[loc9];
                     loc17 = loc19;
                     loc18 = loc20;
                     loc19 = loc21;
                     loc20 = loc22;
                     loc21 = loc17;
                     loc22 = loc18;
                     loc17 = this.focalLength * loc14.x / loc14.z;
                     loc18 = this.focalLength * loc14.y / loc14.z;
                     loc10 = loc12;
                     loc12 = loc10 > 0 ? loc10 - 1 : param3 - 1;
                  }
                  this.drawTriangle(loc17,loc18,loc14.u,loc14.v,loc19,loc20,loc15.u,loc15.v,loc21,loc22,loc16.u,loc16.v);
                  loc13 = !loc13;
               }
            }
         }
      }
      
      private function bisection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number, param17:Number, param18:Number) : void
      {
         var loc19:Number = NaN;
         var loc20:Number = NaN;
         var loc21:Number = NaN;
         var loc22:Number = NaN;
         var loc23:Number = NaN;
         var loc24:Number = NaN;
         var loc25:Number = NaN;
         var loc26:Number = NaN;
         var loc27:Number = NaN;
         var loc28:Number = NaN;
         if(param16 > param17)
         {
            if(param16 > param18)
            {
               if(param16 > this.distortion)
               {
                  loc19 = 0.5 * (param1 + param6);
                  loc20 = 0.5 * (param2 + param7);
                  loc21 = 0.5 * (param3 + param8);
                  loc22 = 0.5 * (param4 + param9);
                  loc23 = 0.5 * (param5 + param10);
                  loc24 = (param1 + loc19) / (param3 + loc21) - 0.5 * (param1 / param3 + loc19 / loc21);
                  loc25 = (param2 + loc20) / (param3 + loc21) - 0.5 * (param2 / param3 + loc20 / loc21);
                  loc26 = loc24 * loc24 + loc25 * loc25;
                  loc24 = (param6 + loc19) / (param8 + loc21) - 0.5 * (param6 / param8 + loc19 / loc21);
                  loc25 = (param7 + loc20) / (param8 + loc21) - 0.5 * (param7 / param8 + loc20 / loc21);
                  loc27 = loc24 * loc24 + loc25 * loc25;
                  loc24 = (param11 + loc19) / (param13 + loc21) - 0.5 * (param11 / param13 + loc19 / loc21);
                  loc25 = (param12 + loc20) / (param13 + loc21) - 0.5 * (param12 / param13 + loc20 / loc21);
                  loc28 = loc24 * loc24 + loc25 * loc25;
                  this.bisection(loc19,loc20,loc21,loc22,loc23,param11,param12,param13,param14,param15,param1,param2,param3,param4,param5,loc28,param18,loc26);
                  this.bisection(loc19,loc20,loc21,loc22,loc23,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,loc27,param17,loc28);
                  return;
               }
            }
            else if(param18 > this.distortion)
            {
               loc19 = 0.5 * (param11 + param1);
               loc20 = 0.5 * (param12 + param2);
               loc21 = 0.5 * (param13 + param3);
               loc22 = 0.5 * (param14 + param4);
               loc23 = 0.5 * (param15 + param5);
               loc24 = (param1 + loc19) / (param3 + loc21) - 0.5 * (param1 / param3 + loc19 / loc21);
               loc25 = (param2 + loc20) / (param3 + loc21) - 0.5 * (param2 / param3 + loc20 / loc21);
               loc26 = loc24 * loc24 + loc25 * loc25;
               loc24 = (param6 + loc19) / (param8 + loc21) - 0.5 * (param6 / param8 + loc19 / loc21);
               loc25 = (param7 + loc20) / (param8 + loc21) - 0.5 * (param7 / param8 + loc20 / loc21);
               loc27 = loc24 * loc24 + loc25 * loc25;
               loc24 = (param11 + loc19) / (param13 + loc21) - 0.5 * (param11 / param13 + loc19 / loc21);
               loc25 = (param12 + loc20) / (param13 + loc21) - 0.5 * (param12 / param13 + loc20 / loc21);
               loc28 = loc24 * loc24 + loc25 * loc25;
               this.bisection(loc19,loc20,loc21,loc22,loc23,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,loc27,param17,loc28);
               this.bisection(loc19,loc20,loc21,loc22,loc23,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,loc26,param16,loc27);
               return;
            }
         }
         else if(param17 > param18)
         {
            if(param17 > this.distortion)
            {
               loc19 = 0.5 * (param6 + param11);
               loc20 = 0.5 * (param7 + param12);
               loc21 = 0.5 * (param8 + param13);
               loc22 = 0.5 * (param9 + param14);
               loc23 = 0.5 * (param10 + param15);
               loc24 = (param1 + loc19) / (param3 + loc21) - 0.5 * (param1 / param3 + loc19 / loc21);
               loc25 = (param2 + loc20) / (param3 + loc21) - 0.5 * (param2 / param3 + loc20 / loc21);
               loc26 = loc24 * loc24 + loc25 * loc25;
               loc24 = (param6 + loc19) / (param8 + loc21) - 0.5 * (param6 / param8 + loc19 / loc21);
               loc25 = (param7 + loc20) / (param8 + loc21) - 0.5 * (param7 / param8 + loc20 / loc21);
               loc27 = loc24 * loc24 + loc25 * loc25;
               loc24 = (param11 + loc19) / (param13 + loc21) - 0.5 * (param11 / param13 + loc19 / loc21);
               loc25 = (param12 + loc20) / (param13 + loc21) - 0.5 * (param12 / param13 + loc20 / loc21);
               loc28 = loc24 * loc24 + loc25 * loc25;
               this.bisection(loc19,loc20,loc21,loc22,loc23,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,loc26,param16,loc27);
               this.bisection(loc19,loc20,loc21,loc22,loc23,param11,param12,param13,param14,param15,param1,param2,param3,param4,param5,loc28,param18,loc26);
               return;
            }
         }
         else if(param18 > this.distortion)
         {
            loc19 = 0.5 * (param11 + param1);
            loc20 = 0.5 * (param12 + param2);
            loc21 = 0.5 * (param13 + param3);
            loc22 = 0.5 * (param14 + param4);
            loc23 = 0.5 * (param15 + param5);
            loc24 = (param1 + loc19) / (param3 + loc21) - 0.5 * (param1 / param3 + loc19 / loc21);
            loc25 = (param2 + loc20) / (param3 + loc21) - 0.5 * (param2 / param3 + loc20 / loc21);
            loc26 = loc24 * loc24 + loc25 * loc25;
            loc24 = (param6 + loc19) / (param8 + loc21) - 0.5 * (param6 / param8 + loc19 / loc21);
            loc25 = (param7 + loc20) / (param8 + loc21) - 0.5 * (param7 / param8 + loc20 / loc21);
            loc27 = loc24 * loc24 + loc25 * loc25;
            loc24 = (param11 + loc19) / (param13 + loc21) - 0.5 * (param11 / param13 + loc19 / loc21);
            loc25 = (param12 + loc20) / (param13 + loc21) - 0.5 * (param12 / param13 + loc20 / loc21);
            loc28 = loc24 * loc24 + loc25 * loc25;
            this.bisection(loc19,loc20,loc21,loc22,loc23,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,loc27,param17,loc28);
            this.bisection(loc19,loc20,loc21,loc22,loc23,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,loc26,param16,loc27);
            return;
         }
         var loc29:Number = this.focalLength / param3;
         var loc30:Number = this.focalLength / param8;
         var loc31:Number = this.focalLength / param13;
         this.drawTriangle(param1 * loc29,param2 * loc29,param4,param5,param6 * loc30,param7 * loc30,param9,param10,param11 * loc31,param12 * loc31,param14,param15);
      }
      
      private function drawTriangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number) : void
      {
         var loc13:Number = param5 - param1;
         var loc14:Number = param6 - param2;
         var loc15:Number = param9 - param1;
         var loc16:Number = param10 - param2;
         var loc17:Number = param7 - param3;
         var loc18:Number = param8 - param4;
         var loc19:Number = param11 - param3;
         var loc20:Number = param12 - param4;
         var loc21:Number = loc17 * loc20 - loc18 * loc19;
         var loc22:Number = this.alternativa3d::_texture.alternativatypes::_width;
         var loc23:Number = this.alternativa3d::_texture.alternativatypes::_height;
         this.textureMatrix.a = (loc20 * loc13 - loc18 * loc15) / loc21;
         this.textureMatrix.b = (loc20 * loc14 - loc18 * loc16) / loc21;
         this.textureMatrix.c = (loc19 * loc13 - loc17 * loc15) / loc21;
         this.textureMatrix.d = (loc19 * loc14 - loc17 * loc16) / loc21;
         this.textureMatrix.tx = (param4 - 1) * this.textureMatrix.c - param3 * this.textureMatrix.a + param1;
         this.textureMatrix.ty = (param4 - 1) * this.textureMatrix.d - param3 * this.textureMatrix.b + param2;
         this.textureMatrix.a /= loc22;
         this.textureMatrix.b /= loc22;
         this.textureMatrix.c /= loc23;
         this.textureMatrix.d /= loc23;
         this.gfx.beginBitmapFill(this.alternativa3d::_texture.alternativatypes::_bitmapData,this.textureMatrix,this.alternativa3d::_repeat,this.alternativa3d::_smooth);
         if(this.alternativa3d::_wireThickness >= 0)
         {
            this.gfx.lineStyle(this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor);
         }
         this.gfx.moveTo(param1,param2);
         this.gfx.lineTo(param5,param6);
         this.gfx.lineTo(param9,param10);
         if(this.alternativa3d::_wireThickness >= 0)
         {
            this.gfx.lineTo(param1,param2);
         }
      }
      
      public function get texture() : Texture
      {
         return this.alternativa3d::_texture;
      }
      
      public function set texture(param1:Texture) : void
      {
         if(this.alternativa3d::_texture != param1)
         {
            this.alternativa3d::_texture = param1;
            markToChange();
         }
      }
      
      public function get repeat() : Boolean
      {
         return this.alternativa3d::_repeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         if(this.alternativa3d::_repeat != param1)
         {
            this.alternativa3d::_repeat = param1;
            markToChange();
         }
      }
      
      public function get smooth() : Boolean
      {
         return this.alternativa3d::_smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(this.alternativa3d::_smooth != param1)
         {
            this.alternativa3d::_smooth = param1;
            if(alternativa3d::_surface != null)
            {
               alternativa3d::_surface.alternativa3d::addMaterialChangedOperationToScene();
            }
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
      
      public function get precision() : Number
      {
         return this.alternativa3d::_precision;
      }
      
      public function set precision(param1:Number) : void
      {
         if(this.alternativa3d::_precision != param1)
         {
            this.alternativa3d::_precision = param1;
            markToChange();
         }
      }
      
      override public function clone() : Material
      {
         return new TextureMaterial(this.alternativa3d::_texture,alternativa3d::_alpha,this.alternativa3d::_repeat,this.alternativa3d::_smooth,alternativa3d::_blendMode,this.alternativa3d::_wireThickness,this.alternativa3d::_wireColor,this.alternativa3d::_precision);
      }
   }
}

