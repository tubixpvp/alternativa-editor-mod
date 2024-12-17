package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.display.Skin;
   import alternativa.engine3d.display.View;
   import alternativa.engine3d.materials.DrawPoint;
   import alternativa.engine3d.materials.SpriteMaterial;
   import alternativa.engine3d.materials.SurfaceMaterial;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.geom.Matrix;
   
   use namespace alternativa3d;
   
   public class Camera3D extends Object3D
   {
      private static var counter:uint = 0;
      
      alternativa3d var calculateMatrixOperation:Operation;
      
      alternativa3d var calculatePlanesOperation:Operation;
      
      alternativa3d var renderOperation:Operation;
      
      alternativa3d var sector:Sector;
      
      alternativa3d var _fov:Number = 1.5707963267948966;
      
      alternativa3d var _focalLength:Number;
      
      alternativa3d var focalDistortion:Number;
      
      alternativa3d var uvMatricesCalculated:Set;
      
      private var textureA:Point3D;
      
      private var textureB:Point3D;
      
      private var textureC:Point3D;
      
      alternativa3d var _view:View;
      
      alternativa3d var _orthographic:Boolean = false;
      
      private var fullDraw:Boolean;
      
      alternativa3d var _zoom:Number = 1;
      
      private var viewAngle:Number;
      
      private var direction:Point3D;
      
      alternativa3d var cameraMatrix:Matrix3D;
      
      private var firstSkin:Skin;
      
      private var prevSkin:Skin;
      
      private var currentSkin:Skin;
      
      private var leftPlane:Point3D;
      
      private var rightPlane:Point3D;
      
      private var topPlane:Point3D;
      
      private var bottomPlane:Point3D;
      
      private var farPlane:Point3D;
      
      private var leftOffset:Number;
      
      private var rightOffset:Number;
      
      private var topOffset:Number;
      
      private var bottomOffset:Number;
      
      private var nearOffset:Number;
      
      private var farOffset:Number;
      
      private var points1:Array;
      
      private var points2:Array;
      
      private var drawPoints:Array;
      
      private var spritePoint:Point3D;
      
      private var spritePrimitives:Array;
      
      alternativa3d var _nearClippingDistance:Number = 1;
      
      alternativa3d var _farClippingDistance:Number = 1;
      
      alternativa3d var _nearClipping:Boolean = false;
      
      alternativa3d var _farClipping:Boolean = false;
      
      alternativa3d var _viewClipping:Boolean = true;
      
      public function Camera3D(param1:String = null)
      {
         this.alternativa3d::calculateMatrixOperation = new Operation("calculateMatrix",this,this.calculateMatrix,Operation.alternativa3d::CAMERA_CALCULATE_MATRIX);
         this.alternativa3d::calculatePlanesOperation = new Operation("calculatePlanes",this,this.calculatePlanes,Operation.alternativa3d::CAMERA_CALCULATE_PLANES);
         this.alternativa3d::renderOperation = new Operation("render",this,this.render,Operation.alternativa3d::CAMERA_RENDER);
         this.alternativa3d::uvMatricesCalculated = new Set(true);
         this.textureA = new Point3D();
         this.textureB = new Point3D();
         this.textureC = new Point3D();
         this.direction = new Point3D(0,0,1);
         this.alternativa3d::cameraMatrix = new Matrix3D();
         this.leftPlane = new Point3D();
         this.rightPlane = new Point3D();
         this.topPlane = new Point3D();
         this.bottomPlane = new Point3D();
         this.farPlane = new Point3D();
         this.points1 = new Array();
         this.points2 = new Array();
         this.drawPoints = new Array();
         this.spritePoint = new Point3D();
         this.spritePrimitives = new Array();
         super(param1);
      }
      
      private function calculateMatrix() : void
      {
         this.alternativa3d::cameraMatrix.copy(alternativa3d::_transformation);
         this.alternativa3d::cameraMatrix.invert();
         if(this.alternativa3d::_orthographic)
         {
            this.alternativa3d::cameraMatrix.scale(this.alternativa3d::_zoom,this.alternativa3d::_zoom,this.alternativa3d::_zoom);
         }
         this.direction.x = alternativa3d::_transformation.c;
         this.direction.y = alternativa3d::_transformation.g;
         this.direction.z = alternativa3d::_transformation.k;
         this.direction.normalize();
      }
      
      private function calculatePlanes() : void
      {
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc11:Number = NaN;
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         var loc14:Number = NaN;
         var loc15:Number = NaN;
         var loc16:Number = NaN;
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
         var loc28:Number = NaN;
         var loc29:Number = NaN;
         var loc1:Number = this.alternativa3d::_view.alternativa3d::_width * 0.5;
         var loc2:Number = this.alternativa3d::_view.alternativa3d::_height * 0.5;
         var loc3:Number = alternativa3d::_transformation.a * loc1;
         var loc4:Number = alternativa3d::_transformation.e * loc1;
         var loc5:Number = alternativa3d::_transformation.i * loc1;
         var loc6:Number = alternativa3d::_transformation.b * loc2;
         var loc7:Number = alternativa3d::_transformation.f * loc2;
         var loc8:Number = alternativa3d::_transformation.j * loc2;
         if(this.alternativa3d::_orthographic)
         {
            if(this.alternativa3d::_viewClipping)
            {
               loc3 /= this.alternativa3d::_zoom;
               loc4 /= this.alternativa3d::_zoom;
               loc5 /= this.alternativa3d::_zoom;
               loc6 /= this.alternativa3d::_zoom;
               loc7 /= this.alternativa3d::_zoom;
               loc8 /= this.alternativa3d::_zoom;
               this.leftPlane.x = alternativa3d::_transformation.f * alternativa3d::_transformation.k - alternativa3d::_transformation.j * alternativa3d::_transformation.g;
               this.leftPlane.y = alternativa3d::_transformation.j * alternativa3d::_transformation.c - alternativa3d::_transformation.b * alternativa3d::_transformation.k;
               this.leftPlane.z = alternativa3d::_transformation.b * alternativa3d::_transformation.g - alternativa3d::_transformation.f * alternativa3d::_transformation.c;
               this.leftOffset = (alternativa3d::_transformation.d - loc3) * this.leftPlane.x + (alternativa3d::_transformation.h - loc4) * this.leftPlane.y + (alternativa3d::_transformation.l - loc5) * this.leftPlane.z;
               this.rightPlane.x = -this.leftPlane.x;
               this.rightPlane.y = -this.leftPlane.y;
               this.rightPlane.z = -this.leftPlane.z;
               this.rightOffset = (alternativa3d::_transformation.d + loc3) * this.rightPlane.x + (alternativa3d::_transformation.h + loc4) * this.rightPlane.y + (alternativa3d::_transformation.l + loc5) * this.rightPlane.z;
               this.topPlane.x = alternativa3d::_transformation.g * alternativa3d::_transformation.i - alternativa3d::_transformation.k * alternativa3d::_transformation.e;
               this.topPlane.y = alternativa3d::_transformation.k * alternativa3d::_transformation.a - alternativa3d::_transformation.c * alternativa3d::_transformation.i;
               this.topPlane.z = alternativa3d::_transformation.c * alternativa3d::_transformation.e - alternativa3d::_transformation.g * alternativa3d::_transformation.a;
               this.topOffset = (alternativa3d::_transformation.d - loc6) * this.topPlane.x + (alternativa3d::_transformation.h - loc7) * this.topPlane.y + (alternativa3d::_transformation.l - loc8) * this.topPlane.z;
               this.bottomPlane.x = -this.topPlane.x;
               this.bottomPlane.y = -this.topPlane.y;
               this.bottomPlane.z = -this.topPlane.z;
               this.bottomOffset = (alternativa3d::_transformation.d + loc6) * this.bottomPlane.x + (alternativa3d::_transformation.h + loc7) * this.bottomPlane.y + (alternativa3d::_transformation.l + loc8) * this.bottomPlane.z;
            }
         }
         else
         {
            this.alternativa3d::_focalLength = Math.sqrt(this.alternativa3d::_view.alternativa3d::_width * this.alternativa3d::_view.alternativa3d::_width + this.alternativa3d::_view.alternativa3d::_height * this.alternativa3d::_view.alternativa3d::_height) * 0.5 / Math.tan(0.5 * this.alternativa3d::_fov);
            this.alternativa3d::focalDistortion = 1 / (this.alternativa3d::_focalLength * this.alternativa3d::_focalLength);
            if(this.alternativa3d::_viewClipping)
            {
               loc13 = alternativa3d::_transformation.c * this.alternativa3d::_focalLength;
               loc14 = alternativa3d::_transformation.g * this.alternativa3d::_focalLength;
               loc15 = alternativa3d::_transformation.k * this.alternativa3d::_focalLength;
               loc16 = -loc3 - loc6 + loc13;
               loc17 = -loc4 - loc7 + loc14;
               loc18 = -loc5 - loc8 + loc15;
               loc19 = loc3 - loc6 + loc13;
               loc20 = loc4 - loc7 + loc14;
               loc21 = loc5 - loc8 + loc15;
               loc22 = -loc3 + loc6 + loc13;
               loc23 = -loc4 + loc7 + loc14;
               loc24 = -loc5 + loc8 + loc15;
               loc25 = loc3 + loc6 + loc13;
               loc26 = loc4 + loc7 + loc14;
               loc27 = loc5 + loc8 + loc15;
               this.leftPlane.x = loc23 * loc18 - loc24 * loc17;
               this.leftPlane.y = loc24 * loc16 - loc22 * loc18;
               this.leftPlane.z = loc22 * loc17 - loc23 * loc16;
               this.leftOffset = alternativa3d::_transformation.d * this.leftPlane.x + alternativa3d::_transformation.h * this.leftPlane.y + alternativa3d::_transformation.l * this.leftPlane.z;
               this.rightPlane.x = loc20 * loc27 - loc21 * loc26;
               this.rightPlane.y = loc21 * loc25 - loc19 * loc27;
               this.rightPlane.z = loc19 * loc26 - loc20 * loc25;
               this.rightOffset = alternativa3d::_transformation.d * this.rightPlane.x + alternativa3d::_transformation.h * this.rightPlane.y + alternativa3d::_transformation.l * this.rightPlane.z;
               this.topPlane.x = loc17 * loc21 - loc18 * loc20;
               this.topPlane.y = loc18 * loc19 - loc16 * loc21;
               this.topPlane.z = loc16 * loc20 - loc17 * loc19;
               this.topOffset = alternativa3d::_transformation.d * this.topPlane.x + alternativa3d::_transformation.h * this.topPlane.y + alternativa3d::_transformation.l * this.topPlane.z;
               this.bottomPlane.x = loc26 * loc24 - loc27 * loc23;
               this.bottomPlane.y = loc27 * loc22 - loc25 * loc24;
               this.bottomPlane.z = loc25 * loc23 - loc26 * loc22;
               this.bottomOffset = alternativa3d::_transformation.d * this.bottomPlane.x + alternativa3d::_transformation.h * this.bottomPlane.y + alternativa3d::_transformation.l * this.bottomPlane.z;
               loc28 = Math.sqrt(loc16 * loc16 + loc17 * loc17 + loc18 * loc18);
               loc16 /= loc28;
               loc17 /= loc28;
               loc18 /= loc28;
               loc28 = Math.sqrt(loc19 * loc19 + loc20 * loc20 + loc21 * loc21);
               loc19 /= loc28;
               loc20 /= loc28;
               loc21 /= loc28;
               loc28 = Math.sqrt(loc22 * loc22 + loc23 * loc23 + loc24 * loc24);
               loc22 /= loc28;
               loc23 /= loc28;
               loc24 /= loc28;
               loc28 = Math.sqrt(loc25 * loc25 + loc26 * loc26 + loc27 * loc27);
               loc25 /= loc28;
               loc26 /= loc28;
               loc27 /= loc28;
               this.viewAngle = loc16 * this.direction.x + loc17 * this.direction.y + loc18 * this.direction.z;
               loc29 = loc19 * this.direction.x + loc20 * this.direction.y + loc21 * this.direction.z;
               this.viewAngle = loc29 < this.viewAngle ? loc29 : this.viewAngle;
               loc29 = loc22 * this.direction.x + loc23 * this.direction.y + loc24 * this.direction.z;
               this.viewAngle = loc29 < this.viewAngle ? loc29 : this.viewAngle;
               loc29 = loc25 * this.direction.x + loc26 * this.direction.y + loc27 * this.direction.z;
               this.viewAngle = loc29 < this.viewAngle ? loc29 : this.viewAngle;
               this.viewAngle = Math.sin(Math.acos(this.viewAngle));
            }
            else
            {
               this.viewAngle = 1;
            }
         }
         if(this.alternativa3d::_nearClipping)
         {
            if(this.alternativa3d::_orthographic)
            {
               loc12 = this.alternativa3d::_nearClippingDistance / this.alternativa3d::_zoom;
               loc9 = alternativa3d::_transformation.c * loc12 + alternativa3d::_transformation.d;
               loc10 = alternativa3d::_transformation.g * loc12 + alternativa3d::_transformation.h;
               loc11 = alternativa3d::_transformation.k * loc12 + alternativa3d::_transformation.l;
            }
            else
            {
               loc9 = alternativa3d::_transformation.c * this.alternativa3d::_nearClippingDistance + alternativa3d::_transformation.d;
               loc10 = alternativa3d::_transformation.g * this.alternativa3d::_nearClippingDistance + alternativa3d::_transformation.h;
               loc11 = alternativa3d::_transformation.k * this.alternativa3d::_nearClippingDistance + alternativa3d::_transformation.l;
            }
            this.nearOffset = this.direction.x * loc9 + this.direction.y * loc10 + this.direction.z * loc11;
         }
         if(this.alternativa3d::_farClipping)
         {
            if(this.alternativa3d::_orthographic)
            {
               loc12 = this.alternativa3d::_farClippingDistance / this.alternativa3d::_zoom;
               loc9 = alternativa3d::_transformation.c * loc12 + alternativa3d::_transformation.d;
               loc10 = alternativa3d::_transformation.g * loc12 + alternativa3d::_transformation.h;
               loc11 = alternativa3d::_transformation.k * loc12 + alternativa3d::_transformation.l;
            }
            else
            {
               loc9 = alternativa3d::_transformation.c * this.alternativa3d::_farClippingDistance + alternativa3d::_transformation.d;
               loc10 = alternativa3d::_transformation.g * this.alternativa3d::_farClippingDistance + alternativa3d::_transformation.h;
               loc11 = alternativa3d::_transformation.k * this.alternativa3d::_farClippingDistance + alternativa3d::_transformation.l;
            }
            this.farPlane.x = -this.direction.x;
            this.farPlane.y = -this.direction.y;
            this.farPlane.z = -this.direction.z;
            this.farOffset = this.farPlane.x * loc9 + this.farPlane.y * loc10 + this.farPlane.z * loc11;
         }
      }
      
      private function render() : void
      {
         this.fullDraw = this.alternativa3d::calculateMatrixOperation.alternativa3d::queued || this.alternativa3d::calculatePlanesOperation.alternativa3d::queued;
         this.prevSkin = null;
         this.currentSkin = this.firstSkin;
         this.alternativa3d::sector = null;
         this.findSector(alternativa3d::_scene.alternativa3d::bsp);
         this.renderSplitterNode(alternativa3d::_scene.alternativa3d::bsp);
         this.alternativa3d::uvMatricesCalculated.clear();
         while(this.currentSkin != null)
         {
            this.removeCurrentSkin();
         }
         if(this.alternativa3d::_view.alternativa3d::_interactive)
         {
            this.alternativa3d::_view.alternativa3d::checkMouseOverOut(true);
         }
      }
      
      private function findSector(param1:BSPNode) : void
      {
         var loc2:Point3D = null;
         if(param1 != null && param1.alternativa3d::splitter != null)
         {
            loc2 = param1.alternativa3d::normal;
            if(alternativa3d::globalCoords.x * loc2.x + alternativa3d::globalCoords.y * loc2.y + alternativa3d::globalCoords.z * loc2.z - param1.alternativa3d::offset >= 0)
            {
               if(param1.alternativa3d::frontSector != null)
               {
                  this.alternativa3d::sector = param1.alternativa3d::frontSector;
               }
               else
               {
                  this.findSector(param1.alternativa3d::front);
               }
            }
            else if(param1.alternativa3d::backSector != null)
            {
               this.alternativa3d::sector = param1.alternativa3d::backSector;
            }
            else
            {
               this.findSector(param1.alternativa3d::back);
            }
         }
      }
      
      private function renderSplitterNode(param1:BSPNode) : void
      {
         var loc3:Point3D = null;
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         if(param1 != null)
         {
            if(param1.alternativa3d::splitter != null)
            {
               loc3 = param1.alternativa3d::normal;
               loc4 = this.direction.x * loc3.x + this.direction.y * loc3.y + this.direction.z * loc3.z;
               if(!this.alternativa3d::_orthographic)
               {
                  loc5 = alternativa3d::globalCoords.x * loc3.x + alternativa3d::globalCoords.y * loc3.y + alternativa3d::globalCoords.z * loc3.z - param1.alternativa3d::offset;
               }
               if(this.alternativa3d::_orthographic ? loc4 < 0 : loc5 > 0)
               {
                  if((this.alternativa3d::_orthographic || loc4 < this.viewAngle) && (param1.alternativa3d::splitter.alternativa3d::_open && (param1.alternativa3d::backSector == null || this.alternativa3d::sector == null || this.alternativa3d::sector.alternativa3d::_visible[param1.alternativa3d::backSector])))
                  {
                     this.renderSplitterNode(param1.alternativa3d::back);
                  }
                  if(param1.alternativa3d::frontSector == null || this.alternativa3d::sector == null || Boolean(this.alternativa3d::sector.alternativa3d::_visible[param1.alternativa3d::frontSector]))
                  {
                     this.renderSplitterNode(param1.alternativa3d::front);
                  }
               }
               else
               {
                  if((this.alternativa3d::_orthographic || loc4 > -this.viewAngle) && (param1.alternativa3d::splitter.alternativa3d::_open && (param1.alternativa3d::frontSector == null || this.alternativa3d::sector == null || this.alternativa3d::sector.alternativa3d::_visible[param1.alternativa3d::frontSector])))
                  {
                     this.renderSplitterNode(param1.alternativa3d::front);
                  }
                  if(param1.alternativa3d::backSector == null || this.alternativa3d::sector == null || Boolean(this.alternativa3d::sector.alternativa3d::_visible[param1.alternativa3d::backSector]))
                  {
                     this.renderSplitterNode(param1.alternativa3d::back);
                  }
               }
            }
            else
            {
               this.renderBSPNode(param1);
            }
         }
      }
      
      private function renderBSPNode(param1:BSPNode) : void
      {
         var loc2:* = undefined;
         var loc3:Point3D = null;
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         if(param1 != null)
         {
            if(param1.alternativa3d::isSprite)
            {
               if(param1.alternativa3d::primitive != null)
               {
                  this.drawSpriteSkin(param1.alternativa3d::primitive as SpritePrimitive);
               }
               else
               {
                  this.drawSpritePrimitives(param1.alternativa3d::frontPrimitives);
               }
            }
            else
            {
               loc3 = param1.alternativa3d::normal;
               loc4 = this.direction.x * loc3.x + this.direction.y * loc3.y + this.direction.z * loc3.z;
               if(!this.alternativa3d::_orthographic)
               {
                  loc5 = alternativa3d::globalCoords.x * loc3.x + alternativa3d::globalCoords.y * loc3.y + alternativa3d::globalCoords.z * loc3.z - param1.alternativa3d::offset;
               }
               if(this.alternativa3d::_orthographic ? loc4 < 0 : loc5 > 0)
               {
                  if(this.alternativa3d::_orthographic || loc4 < this.viewAngle)
                  {
                     this.renderBSPNode(param1.alternativa3d::back);
                     if(param1.alternativa3d::primitive != null)
                     {
                        this.drawSkin(param1.alternativa3d::primitive);
                     }
                     else
                     {
                        for(loc2 in param1.alternativa3d::frontPrimitives)
                        {
                           this.drawSkin(loc2);
                        }
                     }
                  }
                  this.renderBSPNode(param1.alternativa3d::front);
               }
               else
               {
                  if(this.alternativa3d::_orthographic || loc4 > -this.viewAngle)
                  {
                     this.renderBSPNode(param1.alternativa3d::front);
                     if(param1.alternativa3d::primitive == null)
                     {
                        for(loc2 in param1.alternativa3d::backPrimitives)
                        {
                           this.drawSkin(loc2);
                        }
                     }
                  }
                  this.renderBSPNode(param1.alternativa3d::back);
               }
            }
         }
      }
      
      private function drawSpritePrimitives(param1:Set) : void
      {
         var loc2:SpritePrimitive = null;
         var loc4:* = undefined;
         var loc6:Point3D = null;
         var loc7:Number = NaN;
         var loc3:int = -1;
         for(loc4 in param1)
         {
            loc2 = loc4;
            loc6 = loc2.alternativa3d::sprite.alternativa3d::globalCoords;
            loc7 = this.alternativa3d::cameraMatrix.i * loc6.x + this.alternativa3d::cameraMatrix.j * loc6.y + this.alternativa3d::cameraMatrix.k * loc6.z + this.alternativa3d::cameraMatrix.l;
            loc2.alternativa3d::screenDepth = loc7;
            var loc10:*;
            this.spritePrimitives[loc10 = ++loc3] = loc2;
         }
         if(loc3 > 0)
         {
            this.sortSpritePrimitives(0,loc3);
         }
         var loc5:int = loc3;
         while(loc5 >= 0)
         {
            this.drawSpriteSkin(this.spritePrimitives[loc5]);
            loc5--;
         }
      }
      
      private function sortSpritePrimitives(param1:int, param2:int) : void
      {
         var loc5:SpritePrimitive = null;
         var loc7:SpritePrimitive = null;
         var loc3:int = param1;
         var loc4:int = param2;
         var loc6:Number = Number(this.spritePrimitives[param2 + param1 >> 1].screenDepth);
         while(true)
         {
            loc5 = this.spritePrimitives[loc3];
            if(loc5.alternativa3d::screenDepth >= loc6)
            {
               while(loc6 < (loc7 = this.spritePrimitives[loc4]).alternativa3d::screenDepth)
               {
                  loc4--;
               }
               if(loc3 <= loc4)
               {
                  var loc8:*;
                  this.spritePrimitives[loc8 = loc3++] = loc7;
                  var loc9:*;
                  this.spritePrimitives[loc9 = loc4--] = loc5;
               }
               if(loc3 > loc4)
               {
                  break;
               }
            }
            else
            {
               loc3++;
            }
         }
         if(param1 < loc4)
         {
            this.sortSpritePrimitives(param1,loc4);
         }
         if(loc3 < param2)
         {
            this.sortSpritePrimitives(loc3,param2);
         }
      }
      
      private function drawSpriteSkin(param1:SpritePrimitive) : void
      {
         var loc2:Sprite3D = null;
         var loc3:SpriteMaterial = null;
         if(!this.fullDraw && this.currentSkin != null && this.currentSkin.alternativa3d::primitive == param1 && !alternativa3d::_scene.alternativa3d::changedPrimitives[param1])
         {
            this.prevSkin = this.currentSkin;
            this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
         }
         else
         {
            loc2 = param1.alternativa3d::sprite;
            loc3 = loc2.alternativa3d::_material;
            if(loc3 == null)
            {
               return;
            }
            if(!loc3.alternativa3d::canDraw(this))
            {
               return;
            }
            if(this.fullDraw || Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[param1]))
            {
               if(this.currentSkin == null)
               {
                  this.addCurrentSkin();
               }
               else if(this.fullDraw || Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[this.currentSkin.alternativa3d::primitive]))
               {
                  this.currentSkin.alternativa3d::material.alternativa3d::clear(this.currentSkin);
               }
               else
               {
                  this.insertCurrentSkin();
               }
               this.currentSkin.alternativa3d::primitive = param1;
               this.currentSkin.alternativa3d::material = loc3;
               loc3.alternativa3d::draw(this,this.currentSkin);
               this.prevSkin = this.currentSkin;
               this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
            }
            else
            {
               while(this.currentSkin != null && Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[this.currentSkin.alternativa3d::primitive]))
               {
                  this.removeCurrentSkin();
               }
               if(this.currentSkin != null)
               {
                  this.prevSkin = this.currentSkin;
                  this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
               }
            }
         }
      }
      
      private function drawSkin(param1:PolyPrimitive) : void
      {
         var loc2:Surface = null;
         var loc3:SurfaceMaterial = null;
         var loc4:uint = 0;
         var loc6:Array = null;
         var loc7:uint = 0;
         var loc8:Point3D = null;
         var loc9:DrawPoint = null;
         var loc10:Number = NaN;
         var loc11:Number = NaN;
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         var loc14:Matrix3D = null;
         var loc15:Number = NaN;
         var loc16:Number = NaN;
         if(!this.fullDraw && this.currentSkin != null && this.currentSkin.alternativa3d::primitive == param1 && !alternativa3d::_scene.alternativa3d::changedPrimitives[param1])
         {
            this.prevSkin = this.currentSkin;
            this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
         }
         else
         {
            loc2 = param1.alternativa3d::face.alternativa3d::_surface;
            if(loc2 == null)
            {
               return;
            }
            loc3 = loc2.alternativa3d::_material;
            if(loc3 == null || !loc3.alternativa3d::canDraw(param1))
            {
               return;
            }
            loc4 = param1.alternativa3d::num;
            loc6 = param1.alternativa3d::points;
            if(this.alternativa3d::_farClipping && this.alternativa3d::_nearClipping)
            {
               loc4 = this.clip(loc4,loc6,this.points1,this.direction,this.nearOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc4 = this.clip(loc4,this.points1,this.points2,this.farPlane,this.farOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc6 = this.points2;
            }
            else if(this.alternativa3d::_nearClipping)
            {
               loc4 = this.clip(loc4,loc6,this.points2,this.direction,this.nearOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc6 = this.points2;
            }
            else if(this.alternativa3d::_farClipping)
            {
               loc4 = this.clip(loc4,loc6,this.points2,this.farPlane,this.farOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc6 = this.points2;
            }
            if(this.alternativa3d::_viewClipping)
            {
               loc4 = this.clip(loc4,loc6,this.points1,this.leftPlane,this.leftOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc4 = this.clip(loc4,this.points1,this.points2,this.rightPlane,this.rightOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc4 = this.clip(loc4,this.points2,this.points1,this.topPlane,this.topOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc4 = this.clip(loc4,this.points1,this.points2,this.bottomPlane,this.bottomOffset);
               if(loc4 < 3)
               {
                  return;
               }
               loc6 = this.points2;
            }
            if(this.fullDraw || Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[param1]))
            {
               loc14 = param1.alternativa3d::face.alternativa3d::uvMatrix;
               if(!this.alternativa3d::_orthographic && loc3.alternativa3d::useUV && Boolean(loc14))
               {
                  loc7 = 0;
                  while(loc7 < loc4)
                  {
                     loc8 = loc6[loc7];
                     loc10 = loc8.x;
                     loc11 = loc8.y;
                     loc12 = loc8.z;
                     loc13 = this.alternativa3d::cameraMatrix.i * loc10 + this.alternativa3d::cameraMatrix.j * loc11 + this.alternativa3d::cameraMatrix.k * loc12 + this.alternativa3d::cameraMatrix.l;
                     if(loc13 < 0)
                     {
                        return;
                     }
                     loc15 = loc14.a * loc10 + loc14.b * loc11 + loc14.c * loc12 + loc14.d;
                     loc16 = loc14.e * loc10 + loc14.f * loc11 + loc14.g * loc12 + loc14.h;
                     loc9 = this.drawPoints[loc7];
                     if(loc9 == null)
                     {
                        this.drawPoints[loc7] = new DrawPoint(this.alternativa3d::cameraMatrix.a * loc10 + this.alternativa3d::cameraMatrix.b * loc11 + this.alternativa3d::cameraMatrix.c * loc12 + this.alternativa3d::cameraMatrix.d,this.alternativa3d::cameraMatrix.e * loc10 + this.alternativa3d::cameraMatrix.f * loc11 + this.alternativa3d::cameraMatrix.g * loc12 + this.alternativa3d::cameraMatrix.h,loc13,loc15,loc16);
                     }
                     else
                     {
                        loc9.x = this.alternativa3d::cameraMatrix.a * loc10 + this.alternativa3d::cameraMatrix.b * loc11 + this.alternativa3d::cameraMatrix.c * loc12 + this.alternativa3d::cameraMatrix.d;
                        loc9.y = this.alternativa3d::cameraMatrix.e * loc10 + this.alternativa3d::cameraMatrix.f * loc11 + this.alternativa3d::cameraMatrix.g * loc12 + this.alternativa3d::cameraMatrix.h;
                        loc9.z = loc13;
                        loc9.u = loc15;
                        loc9.v = loc16;
                     }
                     loc7++;
                  }
               }
               else
               {
                  loc7 = 0;
                  while(loc7 < loc4)
                  {
                     loc8 = loc6[loc7];
                     loc10 = loc8.x;
                     loc11 = loc8.y;
                     loc12 = loc8.z;
                     loc13 = this.alternativa3d::cameraMatrix.i * loc10 + this.alternativa3d::cameraMatrix.j * loc11 + this.alternativa3d::cameraMatrix.k * loc12 + this.alternativa3d::cameraMatrix.l;
                     if(loc13 < 0 && !this.alternativa3d::_orthographic)
                     {
                        return;
                     }
                     loc9 = this.drawPoints[loc7];
                     if(loc9 == null)
                     {
                        this.drawPoints[loc7] = new DrawPoint(this.alternativa3d::cameraMatrix.a * loc10 + this.alternativa3d::cameraMatrix.b * loc11 + this.alternativa3d::cameraMatrix.c * loc12 + this.alternativa3d::cameraMatrix.d,this.alternativa3d::cameraMatrix.e * loc10 + this.alternativa3d::cameraMatrix.f * loc11 + this.alternativa3d::cameraMatrix.g * loc12 + this.alternativa3d::cameraMatrix.h,loc13);
                     }
                     else
                     {
                        loc9.x = this.alternativa3d::cameraMatrix.a * loc10 + this.alternativa3d::cameraMatrix.b * loc11 + this.alternativa3d::cameraMatrix.c * loc12 + this.alternativa3d::cameraMatrix.d;
                        loc9.y = this.alternativa3d::cameraMatrix.e * loc10 + this.alternativa3d::cameraMatrix.f * loc11 + this.alternativa3d::cameraMatrix.g * loc12 + this.alternativa3d::cameraMatrix.h;
                        loc9.z = loc13;
                     }
                     loc7++;
                  }
               }
               if(this.currentSkin == null)
               {
                  this.addCurrentSkin();
               }
               else if(this.fullDraw || Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[this.currentSkin.alternativa3d::primitive]))
               {
                  this.currentSkin.alternativa3d::material.alternativa3d::clear(this.currentSkin);
               }
               else
               {
                  this.insertCurrentSkin();
               }
               this.currentSkin.alternativa3d::primitive = param1;
               this.currentSkin.alternativa3d::material = loc3;
               loc3.alternativa3d::draw(this,this.currentSkin,loc4,this.drawPoints);
               this.prevSkin = this.currentSkin;
               this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
            }
            else
            {
               while(this.currentSkin != null && Boolean(alternativa3d::_scene.alternativa3d::changedPrimitives[this.currentSkin.alternativa3d::primitive]))
               {
                  this.removeCurrentSkin();
               }
               if(this.currentSkin != null)
               {
                  this.prevSkin = this.currentSkin;
                  this.currentSkin = this.currentSkin.alternativa3d::nextSkin;
               }
            }
         }
      }
      
      private function clip(param1:uint, param2:Array, param3:Array, param4:Point3D, param5:Number) : uint
      {
         var loc6:uint = 0;
         var loc7:Number = NaN;
         var loc9:Point3D = null;
         var loc10:Point3D = null;
         var loc11:Point3D = null;
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         var loc8:uint = 0;
         loc10 = param2[param1 - 1];
         loc12 = param4.x * loc10.x + param4.y * loc10.y + param4.z * loc10.z - param5;
         loc6 = 0;
         while(loc6 < param1)
         {
            loc11 = param2[loc6];
            loc13 = param4.x * loc11.x + param4.y * loc11.y + param4.z * loc11.z - param5;
            if(loc13 > 0)
            {
               if(loc12 <= 0)
               {
                  loc7 = loc13 / (loc13 - loc12);
                  loc9 = param3[loc8];
                  if(loc9 == null)
                  {
                     loc9 = new Point3D(loc11.x - (loc11.x - loc10.x) * loc7,loc11.y - (loc11.y - loc10.y) * loc7,loc11.z - (loc11.z - loc10.z) * loc7);
                     param3[loc8] = loc9;
                  }
                  else
                  {
                     loc9.x = loc11.x - (loc11.x - loc10.x) * loc7;
                     loc9.y = loc11.y - (loc11.y - loc10.y) * loc7;
                     loc9.z = loc11.z - (loc11.z - loc10.z) * loc7;
                  }
                  loc8++;
               }
               loc9 = param3[loc8];
               if(loc9 == null)
               {
                  loc9 = new Point3D(loc11.x,loc11.y,loc11.z);
                  param3[loc8] = loc9;
               }
               else
               {
                  loc9.x = loc11.x;
                  loc9.y = loc11.y;
                  loc9.z = loc11.z;
               }
               loc8++;
            }
            else if(loc12 > 0)
            {
               loc7 = loc13 / (loc13 - loc12);
               loc9 = param3[loc8];
               if(loc9 == null)
               {
                  loc9 = new Point3D(loc11.x - (loc11.x - loc10.x) * loc7,loc11.y - (loc11.y - loc10.y) * loc7,loc11.z - (loc11.z - loc10.z) * loc7);
                  param3[loc8] = loc9;
               }
               else
               {
                  loc9.x = loc11.x - (loc11.x - loc10.x) * loc7;
                  loc9.y = loc11.y - (loc11.y - loc10.y) * loc7;
                  loc9.z = loc11.z - (loc11.z - loc10.z) * loc7;
               }
               loc8++;
            }
            loc12 = loc13;
            loc10 = loc11;
            loc6++;
         }
         return loc8;
      }
      
      private function addCurrentSkin() : void
      {
         this.currentSkin = Skin.alternativa3d::createSkin();
         this.alternativa3d::_view.alternativa3d::canvas.addChild(this.currentSkin);
         if(this.prevSkin == null)
         {
            this.firstSkin = this.currentSkin;
         }
         else
         {
            this.prevSkin.alternativa3d::nextSkin = this.currentSkin;
         }
      }
      
      private function insertCurrentSkin() : void
      {
         var loc1:Skin = Skin.alternativa3d::createSkin();
         this.alternativa3d::_view.alternativa3d::canvas.addChildAt(loc1,this.alternativa3d::_view.alternativa3d::canvas.getChildIndex(this.currentSkin));
         loc1.alternativa3d::nextSkin = this.currentSkin;
         if(this.prevSkin == null)
         {
            this.firstSkin = loc1;
         }
         else
         {
            this.prevSkin.alternativa3d::nextSkin = loc1;
         }
         this.currentSkin = loc1;
      }
      
      private function removeCurrentSkin() : void
      {
         var loc1:Skin = this.currentSkin.alternativa3d::nextSkin;
         this.alternativa3d::_view.alternativa3d::canvas.removeChild(this.currentSkin);
         if(this.currentSkin.alternativa3d::material != null)
         {
            this.currentSkin.alternativa3d::material.alternativa3d::clear(this.currentSkin);
         }
         this.currentSkin.alternativa3d::nextSkin = null;
         this.currentSkin.alternativa3d::primitive = null;
         this.currentSkin.alternativa3d::material = null;
         Skin.alternativa3d::destroySkin(this.currentSkin);
         this.currentSkin = loc1;
         if(this.prevSkin == null)
         {
            this.firstSkin = this.currentSkin;
         }
         else
         {
            this.prevSkin.alternativa3d::nextSkin = this.currentSkin;
         }
      }
      
      alternativa3d function calculateUVMatrix(param1:Face, param2:uint, param3:uint) : void
      {
         var loc4:Point3D = param1.alternativa3d::primitive.alternativa3d::points[0];
         this.textureA.x = this.alternativa3d::cameraMatrix.a * loc4.x + this.alternativa3d::cameraMatrix.b * loc4.y + this.alternativa3d::cameraMatrix.c * loc4.z;
         this.textureA.y = this.alternativa3d::cameraMatrix.e * loc4.x + this.alternativa3d::cameraMatrix.f * loc4.y + this.alternativa3d::cameraMatrix.g * loc4.z;
         loc4 = param1.alternativa3d::primitive.alternativa3d::points[1];
         this.textureB.x = this.alternativa3d::cameraMatrix.a * loc4.x + this.alternativa3d::cameraMatrix.b * loc4.y + this.alternativa3d::cameraMatrix.c * loc4.z;
         this.textureB.y = this.alternativa3d::cameraMatrix.e * loc4.x + this.alternativa3d::cameraMatrix.f * loc4.y + this.alternativa3d::cameraMatrix.g * loc4.z;
         loc4 = param1.alternativa3d::primitive.alternativa3d::points[2];
         this.textureC.x = this.alternativa3d::cameraMatrix.a * loc4.x + this.alternativa3d::cameraMatrix.b * loc4.y + this.alternativa3d::cameraMatrix.c * loc4.z;
         this.textureC.y = this.alternativa3d::cameraMatrix.e * loc4.x + this.alternativa3d::cameraMatrix.f * loc4.y + this.alternativa3d::cameraMatrix.g * loc4.z;
         var loc5:Number = this.textureB.x - this.textureA.x;
         var loc6:Number = this.textureB.y - this.textureA.y;
         var loc7:Number = this.textureC.x - this.textureA.x;
         var loc8:Number = this.textureC.y - this.textureA.y;
         var loc9:Matrix = param1.alternativa3d::uvMatrixBase;
         var loc10:Matrix = param1.alternativa3d::orthoTextureMatrix;
         loc10.a = (loc9.a * loc5 + loc9.b * loc7) / param2;
         loc10.b = (loc9.a * loc6 + loc9.b * loc8) / param2;
         loc10.c = -(loc9.c * loc5 + loc9.d * loc7) / param3;
         loc10.d = -(loc9.c * loc6 + loc9.d * loc8) / param3;
         loc10.tx = (loc9.tx + loc9.c) * loc5 + (loc9.ty + loc9.d) * loc7 + this.textureA.x + this.alternativa3d::cameraMatrix.d;
         loc10.ty = (loc9.tx + loc9.c) * loc6 + (loc9.ty + loc9.d) * loc8 + this.textureA.y + this.alternativa3d::cameraMatrix.h;
         this.alternativa3d::uvMatricesCalculated[param1] = true;
      }
      
      public function get view() : View
      {
         return this.alternativa3d::_view;
      }
      
      public function set view(param1:View) : void
      {
         if(param1 != this.alternativa3d::_view)
         {
            if(this.alternativa3d::_view != null)
            {
               this.alternativa3d::_view.camera = null;
            }
            if(param1 != null)
            {
               param1.camera = this;
            }
         }
      }
      
      public function get orthographic() : Boolean
      {
         return this.alternativa3d::_orthographic;
      }
      
      public function set orthographic(param1:Boolean) : void
      {
         if(this.alternativa3d::_orthographic != param1)
         {
            alternativa3d::addOperationToScene(this.alternativa3d::calculateMatrixOperation);
            this.alternativa3d::_orthographic = param1;
         }
      }
      
      public function get fov() : Number
      {
         return this.alternativa3d::_fov;
      }
      
      public function set fov(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : (param1 > Math.PI - 0.0001 ? Math.PI - 0.0001 : param1);
         if(this.alternativa3d::_fov != param1)
         {
            if(!this.alternativa3d::_orthographic)
            {
               alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
            }
            this.alternativa3d::_fov = param1;
         }
      }
      
      public function get focalLength() : Number
      {
         if(this.alternativa3d::_view == null)
         {
            return NaN;
         }
         if(this.orthographic || this.alternativa3d::calculatePlanesOperation.alternativa3d::queued || scene == null)
         {
            return 0.5 * Math.sqrt(this.alternativa3d::_view.alternativa3d::_width * this.alternativa3d::_view.alternativa3d::_width + this.alternativa3d::_view.alternativa3d::_height * this.alternativa3d::_view.alternativa3d::_height) / Math.tan(0.5 * this.alternativa3d::_fov);
         }
         return this.alternativa3d::_focalLength;
      }
      
      public function get zoom() : Number
      {
         return this.alternativa3d::_zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         if(this.alternativa3d::_zoom != param1)
         {
            if(this.alternativa3d::_orthographic)
            {
               alternativa3d::addOperationToScene(this.alternativa3d::calculateMatrixOperation);
            }
            this.alternativa3d::_zoom = param1;
         }
      }
      
      public function get currentSector() : Sector
      {
         if(alternativa3d::_scene == null)
         {
            return null;
         }
         this.alternativa3d::sector = null;
         this.findSector(alternativa3d::_scene.alternativa3d::bsp);
         return this.alternativa3d::sector;
      }
      
      override protected function addToScene(param1:Scene3D) : void
      {
         super.addToScene(param1);
         if(this.alternativa3d::_view != null)
         {
            param1.alternativa3d::addOperation(this.alternativa3d::calculatePlanesOperation);
            param1.alternativa3d::changePrimitivesOperation.alternativa3d::addSequel(this.alternativa3d::renderOperation);
         }
      }
      
      override protected function removeFromScene(param1:Scene3D) : void
      {
         super.removeFromScene(param1);
         param1.alternativa3d::removeOperation(this.alternativa3d::calculateMatrixOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::calculatePlanesOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::renderOperation);
         if(this.alternativa3d::_view != null)
         {
            param1.alternativa3d::changePrimitivesOperation.alternativa3d::removeSequel(this.alternativa3d::renderOperation);
         }
      }
      
      alternativa3d function addToView(param1:View) : void
      {
         this.firstSkin = param1.alternativa3d::canvas.numChildren > 0 ? Skin(param1.alternativa3d::canvas.getChildAt(0)) : null;
         alternativa3d::calculateTransformationOperation.alternativa3d::addSequel(this.alternativa3d::calculateMatrixOperation);
         this.alternativa3d::calculateMatrixOperation.alternativa3d::addSequel(this.alternativa3d::calculatePlanesOperation);
         this.alternativa3d::calculatePlanesOperation.alternativa3d::addSequel(this.alternativa3d::renderOperation);
         if(alternativa3d::_scene != null)
         {
            alternativa3d::_scene.alternativa3d::addOperation(this.alternativa3d::calculateMatrixOperation);
            alternativa3d::_scene.alternativa3d::changePrimitivesOperation.alternativa3d::addSequel(this.alternativa3d::renderOperation);
         }
         this.alternativa3d::_view = param1;
      }
      
      alternativa3d function removeFromView(param1:View) : void
      {
         this.firstSkin = null;
         alternativa3d::calculateTransformationOperation.alternativa3d::removeSequel(this.alternativa3d::calculateMatrixOperation);
         this.alternativa3d::calculateMatrixOperation.alternativa3d::removeSequel(this.alternativa3d::calculatePlanesOperation);
         this.alternativa3d::calculatePlanesOperation.alternativa3d::removeSequel(this.alternativa3d::renderOperation);
         if(alternativa3d::_scene != null)
         {
            alternativa3d::_scene.alternativa3d::removeOperation(this.alternativa3d::calculateMatrixOperation);
            alternativa3d::_scene.alternativa3d::removeOperation(this.alternativa3d::calculatePlanesOperation);
            alternativa3d::_scene.alternativa3d::removeOperation(this.alternativa3d::renderOperation);
            alternativa3d::_scene.alternativa3d::changePrimitivesOperation.alternativa3d::removeSequel(this.alternativa3d::renderOperation);
         }
         this.alternativa3d::_view = null;
      }
      
      override protected function defaultName() : String
      {
         return "camera" + ++counter;
      }
      
      override protected function createEmptyObject() : Object3D
      {
         return new Camera3D();
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var loc2:Camera3D = Camera3D(param1);
         this.orthographic = loc2.alternativa3d::_orthographic;
         this.zoom = loc2.alternativa3d::_zoom;
         this.fov = loc2.alternativa3d::_fov;
      }
      
      public function get nearClipping() : Boolean
      {
         return this.alternativa3d::_nearClipping;
      }
      
      public function set nearClipping(param1:Boolean) : void
      {
         if(this.alternativa3d::_nearClipping != param1)
         {
            this.alternativa3d::_nearClipping = param1;
            alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
         }
      }
      
      public function get nearClippingDistance() : Number
      {
         return this.alternativa3d::_nearClippingDistance;
      }
      
      public function set nearClippingDistance(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.alternativa3d::_nearClippingDistance != param1)
         {
            this.alternativa3d::_nearClippingDistance = param1;
            alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
         }
      }
      
      public function get farClipping() : Boolean
      {
         return this.alternativa3d::_farClipping;
      }
      
      public function set farClipping(param1:Boolean) : void
      {
         if(this.alternativa3d::_farClipping != param1)
         {
            this.alternativa3d::_farClipping = param1;
            alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
         }
      }
      
      public function get farClippingDistance() : Number
      {
         return this.alternativa3d::_farClippingDistance;
      }
      
      public function set farClippingDistance(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.alternativa3d::_farClippingDistance != param1)
         {
            this.alternativa3d::_farClippingDistance = param1;
            alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
         }
      }
      
      public function get viewClipping() : Boolean
      {
         return this.alternativa3d::_viewClipping;
      }
      
      public function set viewClipping(param1:Boolean) : void
      {
         if(this.alternativa3d::_viewClipping != param1)
         {
            this.alternativa3d::_viewClipping = param1;
            alternativa3d::addOperationToScene(this.alternativa3d::calculatePlanesOperation);
         }
      }
   }
}

