package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.display.Skin;
   import alternativa.types.Matrix3D;
   import alternativa.types.Texture;
   import alternativa.types.alternativatypes;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   use namespace alternativa3d;
   use namespace alternativatypes;
   
   public class SpriteTextureMaterial extends SpriteMaterial
   {
      private static var drawRect:Rectangle = new Rectangle();
      
      private static var textureMatrix:Matrix = new Matrix();
      
      alternativa3d var _texture:Texture;
      
      alternativa3d var _smooth:Boolean;
      
      alternativa3d var _originX:Number;
      
      alternativa3d var _originY:Number;
      
      public function SpriteTextureMaterial(param1:Texture, param2:Number = 1, param3:Boolean = false, param4:String = "normal", param5:Number = 0.5, param6:Number = 0.5)
      {
         super(param2,param4);
         this.alternativa3d::_texture = param1;
         this.alternativa3d::_smooth = param3;
         this.alternativa3d::_originX = param5;
         this.alternativa3d::_originY = param6;
      }
      
      override alternativa3d function canDraw(param1:Camera3D) : Boolean
      {
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc13:Number = NaN;
         if(this.alternativa3d::_texture == null)
         {
            return false;
         }
         var loc2:Matrix3D = param1.alternativa3d::cameraMatrix;
         var loc3:Number = Number(alternativa3d::_sprite.alternativa3d::globalCoords.x);
         var loc4:Number = Number(alternativa3d::_sprite.alternativa3d::globalCoords.y);
         var loc5:Number = Number(alternativa3d::_sprite.alternativa3d::globalCoords.z);
         var loc6:Number = loc2.a * loc3 + loc2.b * loc4 + loc2.c * loc5 + loc2.d;
         var loc7:Number = loc2.e * loc3 + loc2.f * loc4 + loc2.g * loc5 + loc2.h;
         var loc8:Number = loc2.i * loc3 + loc2.j * loc4 + loc2.k * loc5 + loc2.l;
         if(param1.alternativa3d::_orthographic)
         {
            if(param1.alternativa3d::_nearClipping && loc8 < param1.alternativa3d::_nearClippingDistance || param1.alternativa3d::_farClipping && loc8 > param1.alternativa3d::_farClippingDistance)
            {
               return false;
            }
            loc9 = this.alternativa3d::_texture.alternativatypes::_width * param1.alternativa3d::_zoom * alternativa3d::_sprite.alternativa3d::_materialScale;
            loc10 = this.alternativa3d::_texture.alternativatypes::_height * param1.alternativa3d::_zoom * alternativa3d::_sprite.alternativa3d::_materialScale;
            loc3 = loc6 - loc9 * this.alternativa3d::_originX;
            loc4 = loc7 - loc10 * this.alternativa3d::_originY;
         }
         else
         {
            if(loc8 <= 0 || param1.alternativa3d::_nearClipping && loc8 < param1.alternativa3d::_nearClippingDistance || param1.alternativa3d::_farClipping && loc8 > param1.alternativa3d::_farClippingDistance)
            {
               return false;
            }
            loc13 = param1.alternativa3d::_focalLength / loc8;
            loc9 = this.alternativa3d::_texture.alternativatypes::_width * loc13 * alternativa3d::_sprite.alternativa3d::_materialScale;
            loc10 = this.alternativa3d::_texture.alternativatypes::_height * loc13 * alternativa3d::_sprite.alternativa3d::_materialScale;
            loc3 = loc6 * loc13 - loc9 * this.alternativa3d::_originX;
            loc4 = loc7 * loc13 - loc10 * this.alternativa3d::_originY;
         }
         var loc11:Number = param1.alternativa3d::_view.alternativa3d::_width * 0.5;
         var loc12:Number = param1.alternativa3d::_view.alternativa3d::_height * 0.5;
         if(param1.alternativa3d::_viewClipping && (loc3 >= loc11 || loc4 >= loc12 || loc3 + loc9 <= -loc11 || loc4 + loc10 <= -loc12))
         {
            return false;
         }
         textureMatrix.a = loc9 / this.alternativa3d::_texture.alternativatypes::_width;
         textureMatrix.d = loc10 / this.alternativa3d::_texture.alternativatypes::_height;
         textureMatrix.tx = loc3;
         textureMatrix.ty = loc4;
         if(param1.alternativa3d::_viewClipping)
         {
            if(loc3 < -loc11)
            {
               loc9 -= -loc11 - loc3;
               loc3 = -loc11;
            }
            if(loc3 + loc9 > loc11)
            {
               loc9 = loc11 - loc3;
            }
            if(loc4 < -loc12)
            {
               loc10 -= -loc12 - loc4;
               loc4 = -loc12;
            }
            if(loc4 + loc10 > loc12)
            {
               loc10 = loc12 - loc4;
            }
         }
         drawRect.x = loc3;
         drawRect.y = loc4;
         drawRect.width = loc9;
         drawRect.height = loc10;
         return true;
      }
      
      override alternativa3d function draw(param1:Camera3D, param2:Skin) : void
      {
         param2.alpha = alternativa3d::_alpha;
         param2.blendMode = alternativa3d::_blendMode;
         param2.alternativa3d::gfx.beginBitmapFill(this.alternativa3d::_texture.alternativatypes::_bitmapData,textureMatrix,false,this.alternativa3d::_smooth);
         param2.alternativa3d::gfx.drawRect(drawRect.x,drawRect.y,drawRect.width,drawRect.height);
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
      
      public function get smooth() : Boolean
      {
         return this.alternativa3d::_smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(this.alternativa3d::_smooth != param1)
         {
            this.alternativa3d::_smooth = param1;
            markToChange();
         }
      }
      
      public function get originX() : Number
      {
         return this.alternativa3d::_originX;
      }
      
      public function set originX(param1:Number) : void
      {
         if(this.alternativa3d::_originX != param1)
         {
            this.alternativa3d::_originX = param1;
            markToChange();
         }
      }
      
      public function get originY() : Number
      {
         return this.alternativa3d::_originY;
      }
      
      public function set originY(param1:Number) : void
      {
         if(this.alternativa3d::_originY != param1)
         {
            this.alternativa3d::_originY = param1;
            markToChange();
         }
      }
      
      override public function clone() : Material
      {
         return new SpriteTextureMaterial(this.alternativa3d::_texture,alternativa3d::_alpha,this.alternativa3d::_smooth,alternativa3d::_blendMode,this.alternativa3d::_originX,this.alternativa3d::_originY);
      }
   }
}

