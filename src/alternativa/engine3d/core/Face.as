package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   use namespace alternativa3d;
   
   public final class Face implements IEventDispatcher
   {
      private static const uvThreshold:Number = 1 / 2880;
      
      alternativa3d var calculateNormalOperation:Operation;
      
      alternativa3d var calculateBaseUVOperation:Operation;
      
      alternativa3d var calculateUVOperation:Operation;
      
      alternativa3d var updatePrimitiveOperation:Operation;
      
      alternativa3d var updateMaterialOperation:Operation;
      
      alternativa3d var _mesh:Mesh;
      
      alternativa3d var _surface:Surface;
      
      alternativa3d var _vertices:Array;
      
      alternativa3d var _verticesCount:uint;
      
      alternativa3d var primitive:PolyPrimitive;
      
      alternativa3d var _aUV:Point;
      
      alternativa3d var _bUV:Point;
      
      alternativa3d var _cUV:Point;
      
      alternativa3d var uvMatrixBase:Matrix;
      
      alternativa3d var uvMatrix:Matrix3D;
      
      alternativa3d var orthoTextureMatrix:Matrix;
      
      alternativa3d var globalNormal:Point3D;
      
      alternativa3d var globalOffset:Number;
      
      public var mouseEnabled:Boolean = true;
      
      private var dispatcher:EventDispatcher;
      
      public function Face(param1:Array)
      {
         var loc3:Vertex = null;
         this.alternativa3d::calculateNormalOperation = new Operation("calculateNormal",this,this.calculateNormal,Operation.alternativa3d::FACE_CALCULATE_NORMAL);
         this.alternativa3d::calculateBaseUVOperation = new Operation("calculateBaseUV",this,this.calculateBaseUV,Operation.alternativa3d::FACE_CALCULATE_BASE_UV);
         this.alternativa3d::calculateUVOperation = new Operation("calculateUV",this,this.calculateUV,Operation.alternativa3d::FACE_CALCULATE_UV);
         this.alternativa3d::updatePrimitiveOperation = new Operation("updatePrimitive",this,this.updatePrimitive,Operation.alternativa3d::FACE_UPDATE_PRIMITIVE);
         this.alternativa3d::updateMaterialOperation = new Operation("updateMaterial",this,this.updateMaterial,Operation.alternativa3d::FACE_UPDATE_MATERIAL);
         this.alternativa3d::globalNormal = new Point3D();
         super();
         this.alternativa3d::_vertices = param1;
         this.alternativa3d::_verticesCount = param1.length;
         this.alternativa3d::primitive = PolyPrimitive.alternativa3d::create();
         this.alternativa3d::primitive.alternativa3d::face = this;
         this.alternativa3d::primitive.alternativa3d::num = this.alternativa3d::_verticesCount;
         var loc2:uint = 0;
         while(loc2 < this.alternativa3d::_verticesCount)
         {
            loc3 = param1[loc2];
            this.alternativa3d::primitive.alternativa3d::points.push(loc3.alternativa3d::globalCoords);
            loc3.alternativa3d::addToFace(this);
            loc2++;
         }
         this.alternativa3d::calculateNormalOperation.alternativa3d::addSequel(this.alternativa3d::updatePrimitiveOperation);
         this.alternativa3d::calculateNormalOperation.alternativa3d::addSequel(this.alternativa3d::calculateUVOperation);
         this.alternativa3d::calculateBaseUVOperation.alternativa3d::addSequel(this.alternativa3d::calculateUVOperation);
         this.alternativa3d::calculateUVOperation.alternativa3d::addSequel(this.alternativa3d::updateMaterialOperation);
      }
      
      private function calculateNormal() : void
      {
         var loc1:Vertex = this.alternativa3d::_vertices[0];
         var loc2:Point3D = loc1.alternativa3d::globalCoords;
         loc1 = this.alternativa3d::_vertices[1];
         var loc3:Point3D = loc1.alternativa3d::globalCoords;
         var loc4:Number = loc3.x - loc2.x;
         var loc5:Number = loc3.y - loc2.y;
         var loc6:Number = loc3.z - loc2.z;
         loc1 = this.alternativa3d::_vertices[2];
         var loc7:Point3D = loc1.alternativa3d::globalCoords;
         var loc8:Number = loc7.x - loc2.x;
         var loc9:Number = loc7.y - loc2.y;
         var loc10:Number = loc7.z - loc2.z;
         this.alternativa3d::globalNormal.x = loc10 * loc5 - loc9 * loc6;
         this.alternativa3d::globalNormal.y = loc8 * loc6 - loc10 * loc4;
         this.alternativa3d::globalNormal.z = loc9 * loc4 - loc8 * loc5;
         this.alternativa3d::globalNormal.normalize();
      }
      
      private function updatePrimitive() : void
      {
         var loc1:Vertex = this.alternativa3d::_vertices[0];
         this.alternativa3d::globalOffset = loc1.alternativa3d::globalCoords.x * this.alternativa3d::globalNormal.x + loc1.alternativa3d::globalCoords.y * this.alternativa3d::globalNormal.y + loc1.alternativa3d::globalCoords.z * this.alternativa3d::globalNormal.z;
         this.removePrimitive(this.alternativa3d::primitive);
         this.alternativa3d::primitive.mobility = this.alternativa3d::_mesh.alternativa3d::inheritedMobility;
         this.alternativa3d::_mesh.alternativa3d::_scene.alternativa3d::addPrimitives.push(this.alternativa3d::primitive);
      }
      
      private function removePrimitive(param1:PolyPrimitive) : void
      {
         if(param1.alternativa3d::backFragment != null)
         {
            this.removePrimitive(param1.alternativa3d::backFragment);
            this.removePrimitive(param1.alternativa3d::frontFragment);
            param1.alternativa3d::backFragment = null;
            param1.alternativa3d::frontFragment = null;
            if(param1 != this.alternativa3d::primitive)
            {
               param1.alternativa3d::parent = null;
               param1.alternativa3d::sibling = null;
               PolyPrimitive.alternativa3d::destroy(param1);
            }
         }
         else if(param1.alternativa3d::node != null)
         {
            this.alternativa3d::_mesh.alternativa3d::_scene.alternativa3d::removeBSPPrimitive(param1);
         }
      }
      
      private function updateMaterial() : void
      {
         if(!this.alternativa3d::updatePrimitiveOperation.alternativa3d::queued)
         {
            this.changePrimitive(this.alternativa3d::primitive);
         }
      }
      
      private function changePrimitive(param1:PolyPrimitive) : void
      {
         if(param1.alternativa3d::backFragment != null)
         {
            this.changePrimitive(param1.alternativa3d::backFragment);
            this.changePrimitive(param1.alternativa3d::frontFragment);
         }
         else
         {
            this.alternativa3d::_mesh.alternativa3d::_scene.alternativa3d::changedPrimitives[param1] = true;
         }
      }
      
      private function calculateBaseUV() : void
      {
         var loc1:Number = NaN;
         var loc2:Number = NaN;
         var loc3:Number = NaN;
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         if(this.alternativa3d::_aUV != null && this.alternativa3d::_bUV != null && this.alternativa3d::_cUV != null)
         {
            loc1 = this.alternativa3d::_bUV.x - this.alternativa3d::_aUV.x;
            loc2 = this.alternativa3d::_bUV.y - this.alternativa3d::_aUV.y;
            loc3 = this.alternativa3d::_cUV.x - this.alternativa3d::_aUV.x;
            loc4 = this.alternativa3d::_cUV.y - this.alternativa3d::_aUV.y;
            loc5 = loc1 * loc4 - loc2 * loc3;
            if(loc5 < uvThreshold && loc5 > -uvThreshold)
            {
               if(loc1 < uvThreshold && loc1 > -uvThreshold && loc2 < uvThreshold && loc2 > -uvThreshold)
               {
                  if(loc3 < uvThreshold && loc3 > -uvThreshold && loc4 < uvThreshold && loc4 > -uvThreshold)
                  {
                     loc1 = uvThreshold;
                     loc4 = uvThreshold;
                  }
                  else
                  {
                     loc6 = Math.sqrt(loc3 * loc3 + loc4 * loc4);
                     loc1 = uvThreshold * loc4 / loc6;
                     loc2 = -uvThreshold * loc3 / loc6;
                  }
               }
               else if(loc3 < uvThreshold && loc3 > -uvThreshold && loc4 < uvThreshold && loc4 > -uvThreshold)
               {
                  loc6 = Math.sqrt(loc1 * loc1 + loc2 * loc2);
                  loc3 = -uvThreshold * loc2 / loc6;
                  loc4 = uvThreshold * loc1 / loc6;
               }
               else
               {
                  loc6 = Math.sqrt(loc1 * loc1 + loc2 * loc2);
                  loc3 += uvThreshold * loc2 / loc6;
                  loc4 -= uvThreshold * loc1 / loc6;
               }
               loc5 = loc1 * loc4 - loc2 * loc3;
            }
            if(this.alternativa3d::uvMatrixBase == null)
            {
               this.alternativa3d::uvMatrixBase = new Matrix();
               this.alternativa3d::orthoTextureMatrix = new Matrix();
            }
            this.alternativa3d::uvMatrixBase.a = loc4 / loc5;
            this.alternativa3d::uvMatrixBase.b = -loc2 / loc5;
            this.alternativa3d::uvMatrixBase.c = -loc3 / loc5;
            this.alternativa3d::uvMatrixBase.d = loc1 / loc5;
            this.alternativa3d::uvMatrixBase.tx = -(this.alternativa3d::uvMatrixBase.a * this.alternativa3d::_aUV.x + this.alternativa3d::uvMatrixBase.c * this.alternativa3d::_aUV.y);
            this.alternativa3d::uvMatrixBase.ty = -(this.alternativa3d::uvMatrixBase.b * this.alternativa3d::_aUV.x + this.alternativa3d::uvMatrixBase.d * this.alternativa3d::_aUV.y);
         }
         else
         {
            this.alternativa3d::uvMatrixBase = null;
            this.alternativa3d::orthoTextureMatrix = null;
         }
      }
      
      private function calculateUV() : void
      {
         var loc1:Point3D = null;
         var loc2:Point3D = null;
         var loc3:Point3D = null;
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Number = NaN;
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
         if(this.alternativa3d::uvMatrixBase != null)
         {
            if(this.alternativa3d::uvMatrix == null)
            {
               this.alternativa3d::uvMatrix = new Matrix3D();
            }
            loc1 = this.alternativa3d::_vertices[0].globalCoords;
            loc2 = this.alternativa3d::_vertices[1].globalCoords;
            loc3 = this.alternativa3d::_vertices[2].globalCoords;
            loc4 = loc2.x - loc1.x;
            loc5 = loc2.y - loc1.y;
            loc6 = loc2.z - loc1.z;
            loc7 = loc3.x - loc1.x;
            loc8 = loc3.y - loc1.y;
            loc9 = loc3.z - loc1.z;
            this.alternativa3d::uvMatrix.a = loc4 * this.alternativa3d::uvMatrixBase.a + loc7 * this.alternativa3d::uvMatrixBase.b;
            this.alternativa3d::uvMatrix.b = loc4 * this.alternativa3d::uvMatrixBase.c + loc7 * this.alternativa3d::uvMatrixBase.d;
            this.alternativa3d::uvMatrix.c = this.alternativa3d::globalNormal.x;
            this.alternativa3d::uvMatrix.d = loc4 * this.alternativa3d::uvMatrixBase.tx + loc7 * this.alternativa3d::uvMatrixBase.ty + loc1.x;
            this.alternativa3d::uvMatrix.e = loc5 * this.alternativa3d::uvMatrixBase.a + loc8 * this.alternativa3d::uvMatrixBase.b;
            this.alternativa3d::uvMatrix.f = loc5 * this.alternativa3d::uvMatrixBase.c + loc8 * this.alternativa3d::uvMatrixBase.d;
            this.alternativa3d::uvMatrix.g = this.alternativa3d::globalNormal.y;
            this.alternativa3d::uvMatrix.h = loc5 * this.alternativa3d::uvMatrixBase.tx + loc8 * this.alternativa3d::uvMatrixBase.ty + loc1.y;
            this.alternativa3d::uvMatrix.i = loc6 * this.alternativa3d::uvMatrixBase.a + loc9 * this.alternativa3d::uvMatrixBase.b;
            this.alternativa3d::uvMatrix.j = loc6 * this.alternativa3d::uvMatrixBase.c + loc9 * this.alternativa3d::uvMatrixBase.d;
            this.alternativa3d::uvMatrix.k = this.alternativa3d::globalNormal.z;
            this.alternativa3d::uvMatrix.l = loc6 * this.alternativa3d::uvMatrixBase.tx + loc9 * this.alternativa3d::uvMatrixBase.ty + loc1.z;
            loc10 = this.alternativa3d::uvMatrix.a;
            loc11 = this.alternativa3d::uvMatrix.b;
            loc12 = this.alternativa3d::uvMatrix.c;
            loc13 = this.alternativa3d::uvMatrix.d;
            loc14 = this.alternativa3d::uvMatrix.e;
            loc15 = this.alternativa3d::uvMatrix.f;
            loc16 = this.alternativa3d::uvMatrix.g;
            loc17 = this.alternativa3d::uvMatrix.h;
            loc18 = this.alternativa3d::uvMatrix.i;
            loc19 = this.alternativa3d::uvMatrix.j;
            loc20 = this.alternativa3d::uvMatrix.k;
            loc21 = this.alternativa3d::uvMatrix.l;
            loc22 = -loc12 * loc15 * loc18 + loc11 * loc16 * loc18 + loc12 * loc14 * loc19 - loc10 * loc16 * loc19 - loc11 * loc14 * loc20 + loc10 * loc15 * loc20;
            if(loc22 != 0)
            {
               this.alternativa3d::uvMatrix.a = (-loc16 * loc19 + loc15 * loc20) / loc22;
               this.alternativa3d::uvMatrix.b = (loc12 * loc19 - loc11 * loc20) / loc22;
               this.alternativa3d::uvMatrix.c = (-loc12 * loc15 + loc11 * loc16) / loc22;
               this.alternativa3d::uvMatrix.d = (loc13 * loc16 * loc19 - loc12 * loc17 * loc19 - loc13 * loc15 * loc20 + loc11 * loc17 * loc20 + loc12 * loc15 * loc21 - loc11 * loc16 * loc21) / loc22;
               this.alternativa3d::uvMatrix.e = (loc16 * loc18 - loc14 * loc20) / loc22;
               this.alternativa3d::uvMatrix.f = (-loc12 * loc18 + loc10 * loc20) / loc22;
               this.alternativa3d::uvMatrix.g = (loc12 * loc14 - loc10 * loc16) / loc22;
               this.alternativa3d::uvMatrix.h = (loc12 * loc17 * loc18 - loc13 * loc16 * loc18 + loc13 * loc14 * loc20 - loc10 * loc17 * loc20 - loc12 * loc14 * loc21 + loc10 * loc16 * loc21) / loc22;
               this.alternativa3d::uvMatrix.i = (-loc15 * loc18 + loc14 * loc19) / loc22;
               this.alternativa3d::uvMatrix.j = (loc11 * loc18 - loc10 * loc19) / loc22;
               this.alternativa3d::uvMatrix.k = (-loc11 * loc14 + loc10 * loc15) / loc22;
               this.alternativa3d::uvMatrix.l = (loc13 * loc15 * loc18 - loc11 * loc17 * loc18 - loc13 * loc14 * loc19 + loc10 * loc17 * loc19 + loc11 * loc14 * loc21 - loc10 * loc15 * loc21) / loc22;
            }
            else
            {
               this.alternativa3d::uvMatrix = null;
            }
         }
         else
         {
            this.alternativa3d::uvMatrix = null;
         }
      }
      
      public function get vertices() : Array
      {
         return new Array().concat(this.alternativa3d::_vertices);
      }
      
      public function get verticesCount() : uint
      {
         return this.alternativa3d::_verticesCount;
      }
      
      public function get mesh() : Mesh
      {
         return this.alternativa3d::_mesh;
      }
      
      public function get surface() : Surface
      {
         return this.alternativa3d::_surface;
      }
      
      public function get id() : Object
      {
         return this.alternativa3d::_mesh != null ? this.alternativa3d::_mesh.getFaceId(this) : null;
      }
      
      public function get aUV() : Point
      {
         return this.alternativa3d::_aUV != null ? this.alternativa3d::_aUV.clone() : null;
      }
      
      public function get bUV() : Point
      {
         return this.alternativa3d::_bUV != null ? this.alternativa3d::_bUV.clone() : null;
      }
      
      public function get cUV() : Point
      {
         return this.alternativa3d::_cUV != null ? this.alternativa3d::_cUV.clone() : null;
      }
      
      public function set aUV(param1:Point) : void
      {
         if(this.alternativa3d::_aUV != null)
         {
            if(param1 != null)
            {
               if(!this.alternativa3d::_aUV.equals(param1))
               {
                  this.alternativa3d::_aUV.x = param1.x;
                  this.alternativa3d::_aUV.y = param1.y;
                  if(this.alternativa3d::_mesh != null)
                  {
                     this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
                  }
               }
            }
            else
            {
               this.alternativa3d::_aUV = null;
               if(this.alternativa3d::_mesh != null)
               {
                  this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
               }
            }
         }
         else if(param1 != null)
         {
            this.alternativa3d::_aUV = param1.clone();
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
            }
         }
      }
      
      public function set bUV(param1:Point) : void
      {
         if(this.alternativa3d::_bUV != null)
         {
            if(param1 != null)
            {
               if(!this.alternativa3d::_bUV.equals(param1))
               {
                  this.alternativa3d::_bUV.x = param1.x;
                  this.alternativa3d::_bUV.y = param1.y;
                  if(this.alternativa3d::_mesh != null)
                  {
                     this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
                  }
               }
            }
            else
            {
               this.alternativa3d::_bUV = null;
               if(this.alternativa3d::_mesh != null)
               {
                  this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
               }
            }
         }
         else if(param1 != null)
         {
            this.alternativa3d::_bUV = param1.clone();
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
            }
         }
      }
      
      public function set cUV(param1:Point) : void
      {
         if(this.alternativa3d::_cUV != null)
         {
            if(param1 != null)
            {
               if(!this.alternativa3d::_cUV.equals(param1))
               {
                  this.alternativa3d::_cUV.x = param1.x;
                  this.alternativa3d::_cUV.y = param1.y;
                  if(this.alternativa3d::_mesh != null)
                  {
                     this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
                  }
               }
            }
            else
            {
               this.alternativa3d::_cUV = null;
               if(this.alternativa3d::_mesh != null)
               {
                  this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
               }
            }
         }
         else if(param1 != null)
         {
            this.alternativa3d::_cUV = param1.clone();
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::calculateBaseUVOperation);
            }
         }
      }
      
      public function get normal() : Point3D
      {
         var loc12:Number = NaN;
         var loc1:Point3D = new Point3D();
         var loc2:Vertex = this.alternativa3d::_vertices[0];
         var loc3:Point3D = loc2.coords;
         loc2 = this.alternativa3d::_vertices[1];
         var loc4:Point3D = loc2.coords;
         var loc5:Number = loc4.x - loc3.x;
         var loc6:Number = loc4.y - loc3.y;
         var loc7:Number = loc4.z - loc3.z;
         loc2 = this.alternativa3d::_vertices[2];
         var loc8:Point3D = loc2.coords;
         var loc9:Number = loc8.x - loc3.x;
         var loc10:Number = loc8.y - loc3.y;
         var loc11:Number = loc8.z - loc3.z;
         loc1.x = loc11 * loc6 - loc10 * loc7;
         loc1.y = loc9 * loc7 - loc11 * loc5;
         loc1.z = loc10 * loc5 - loc9 * loc6;
         if(loc1.x != 0 || loc1.y != 0 || loc1.z != 0)
         {
            loc12 = Math.sqrt(loc1.x * loc1.x + loc1.y * loc1.y + loc1.z * loc1.z);
            loc1.x /= loc12;
            loc1.y /= loc12;
            loc1.z /= loc12;
         }
         return loc1;
      }
      
      public function getUV(param1:Point3D) : Point
      {
         return this.alternativa3d::getUVFast(param1,this.normal);
      }
      
      alternativa3d function getUVFast(param1:Point3D, param2:Point3D) : Point
      {
         var loc3:uint = 0;
         if(this.alternativa3d::_aUV == null || this.alternativa3d::_bUV == null || this.alternativa3d::_cUV == null)
         {
            return null;
         }
         if((param2.x < 0 ? -param2.x : param2.x) > (param2.y < 0 ? -param2.y : param2.y))
         {
            if((param2.x < 0 ? -param2.x : param2.x) > (param2.z < 0 ? -param2.z : param2.z))
            {
               loc3 = 0;
            }
            else
            {
               loc3 = 2;
            }
         }
         else if((param2.y < 0 ? -param2.y : param2.y) > (param2.z < 0 ? -param2.z : param2.z))
         {
            loc3 = 1;
         }
         else
         {
            loc3 = 2;
         }
         var loc4:Vertex = this.alternativa3d::_vertices[0];
         var loc5:Point3D = loc4.alternativa3d::_coords;
         loc4 = this.alternativa3d::_vertices[1];
         var loc6:Point3D = loc4.alternativa3d::_coords;
         loc4 = this.alternativa3d::_vertices[2];
         var loc7:Point3D = loc4.alternativa3d::_coords;
         var loc8:Number = loc3 == 0 ? loc6.y - loc5.y : loc6.x - loc5.x;
         var loc9:Number = loc3 == 2 ? loc6.y - loc5.y : loc6.z - loc5.z;
         var loc10:Number = loc3 == 0 ? loc7.y - loc5.y : loc7.x - loc5.x;
         var loc11:Number = loc3 == 2 ? loc7.y - loc5.y : loc7.z - loc5.z;
         var loc12:Number = loc8 * loc11 - loc10 * loc9;
         var loc13:Number = loc3 == 0 ? param1.y - loc5.y : param1.x - loc5.x;
         var loc14:Number = loc3 == 2 ? param1.y - loc5.y : param1.z - loc5.z;
         var loc15:Number = (loc13 * loc11 - loc10 * loc14) / loc12;
         var loc16:Number = (loc8 * loc14 - loc13 * loc9) / loc12;
         var loc17:Number = this.alternativa3d::_bUV.x - this.alternativa3d::_aUV.x;
         var loc18:Number = this.alternativa3d::_bUV.y - this.alternativa3d::_aUV.y;
         var loc19:Number = this.alternativa3d::_cUV.x - this.alternativa3d::_aUV.x;
         var loc20:Number = this.alternativa3d::_cUV.y - this.alternativa3d::_aUV.y;
         return new Point(this.alternativa3d::_aUV.x + loc17 * loc15 + loc19 * loc16,this.alternativa3d::_aUV.y + loc18 * loc15 + loc20 * loc16);
      }
      
      public function get edgeJoinedFaces() : Set
      {
         var loc3:Vertex = null;
         var loc4:Vertex = null;
         var loc5:* = undefined;
         var loc6:Face = null;
         var loc1:Set = new Set(true);
         var loc2:uint = 0;
         while(loc2 < this.alternativa3d::_verticesCount)
         {
            loc3 = this.alternativa3d::_vertices[loc2];
            loc4 = this.alternativa3d::_vertices[loc2 < this.alternativa3d::_verticesCount - 1 ? loc2 + 1 : 0];
            for(loc5 in loc3.alternativa3d::_faces)
            {
               loc6 = loc5;
               if(loc6 != this && loc6.alternativa3d::_vertices.indexOf(loc4) >= 0)
               {
                  loc1[loc6] = true;
               }
            }
            loc2++;
         }
         return loc1;
      }
      
      alternativa3d function removeVertices() : void
      {
         var loc2:Vertex = null;
         var loc1:uint = 0;
         while(loc1 < this.alternativa3d::_verticesCount)
         {
            loc2 = this.alternativa3d::_vertices.pop();
            loc2.alternativa3d::removeFromFace(this);
            loc1++;
         }
         this.alternativa3d::primitive.alternativa3d::points.length = 0;
         this.alternativa3d::_verticesCount = 0;
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
         param1.alternativa3d::addOperation(this.alternativa3d::calculateNormalOperation);
         param1.alternativa3d::addOperation(this.alternativa3d::calculateBaseUVOperation);
         this.alternativa3d::updatePrimitiveOperation.alternativa3d::addSequel(param1.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updateMaterialOperation.alternativa3d::addSequel(param1.alternativa3d::changePrimitivesOperation);
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::removeOperation(this.alternativa3d::calculateBaseUVOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::calculateNormalOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::updatePrimitiveOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::updateMaterialOperation);
         this.removePrimitive(this.alternativa3d::primitive);
         param1.alternativa3d::addOperation(param1.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updatePrimitiveOperation.alternativa3d::removeSequel(param1.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updateMaterialOperation.alternativa3d::removeSequel(param1.alternativa3d::changePrimitivesOperation);
      }
      
      alternativa3d function addToMesh(param1:Mesh) : void
      {
         param1.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::updatePrimitiveOperation);
         param1.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::calculateUVOperation);
         param1.alternativa3d::changeRotationOrScaleOperation.alternativa3d::addSequel(this.alternativa3d::calculateNormalOperation);
         param1.alternativa3d::calculateMobilityOperation.alternativa3d::addSequel(this.alternativa3d::updatePrimitiveOperation);
         this.alternativa3d::_mesh = param1;
      }
      
      alternativa3d function removeFromMesh(param1:Mesh) : void
      {
         param1.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(this.alternativa3d::updatePrimitiveOperation);
         param1.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(this.alternativa3d::calculateUVOperation);
         param1.alternativa3d::changeRotationOrScaleOperation.alternativa3d::removeSequel(this.alternativa3d::calculateNormalOperation);
         param1.alternativa3d::calculateMobilityOperation.alternativa3d::removeSequel(this.alternativa3d::updatePrimitiveOperation);
         this.alternativa3d::_mesh = null;
      }
      
      alternativa3d function addToSurface(param1:Surface) : void
      {
         param1.alternativa3d::changeMaterialOperation.alternativa3d::addSequel(this.alternativa3d::updateMaterialOperation);
         if(this.alternativa3d::_mesh != null && (this.alternativa3d::_surface != null && this.alternativa3d::_surface.alternativa3d::_material != param1.alternativa3d::_material || this.alternativa3d::_surface == null && param1.alternativa3d::_material != null))
         {
            this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::updateMaterialOperation);
         }
         this.alternativa3d::_surface = param1;
      }
      
      alternativa3d function removeFromSurface(param1:Surface) : void
      {
         param1.alternativa3d::changeMaterialOperation.alternativa3d::removeSequel(this.alternativa3d::updateMaterialOperation);
         if(param1.alternativa3d::_material != null)
         {
            this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::updateMaterialOperation);
         }
         this.alternativa3d::_surface = null;
      }
      
      public function toString() : String
      {
         var loc3:Vertex = null;
         var loc1:String = "[Face ID:" + this.id + (this.alternativa3d::_verticesCount > 0 ? " vertices:" : "");
         var loc2:uint = 0;
         while(loc2 < this.alternativa3d::_verticesCount)
         {
            loc3 = this.alternativa3d::_vertices[loc2];
            loc1 += loc3.id + (loc2 < this.alternativa3d::_verticesCount - 1 ? ", " : "");
            loc2++;
         }
         return loc1 + "]";
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(this.dispatcher == null)
         {
            this.dispatcher = new EventDispatcher(this);
         }
         param3 = false;
         this.dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(this.dispatcher != null)
         {
            this.dispatcher.dispatchEvent(param1);
         }
         return false;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         if(this.dispatcher != null)
         {
            return this.dispatcher.hasEventListener(param1);
         }
         return false;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(this.dispatcher != null)
         {
            param3 = false;
            this.dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         if(this.dispatcher != null)
         {
            return this.dispatcher.willTrigger(param1);
         }
         return false;
      }
   }
}

