package alternativa.engine3d.physics
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.BSPNode;
   import alternativa.engine3d.core.PolyPrimitive;
   import alternativa.engine3d.core.Scene3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import alternativa.utils.ObjectUtils;
   
   use namespace alternativa3d;
   
   public class EllipsoidCollider
   {
      private static const MAX_COLLISIONS:uint = 50;
      
      private var _radius:Number = 100;
      
      private var _radius2:Number;
      
      private var _radiusX:Number;
      
      private var _radiusY:Number;
      
      private var _radiusZ:Number;
      
      private var _radiusX2:Number;
      
      private var _radiusY2:Number;
      
      private var _radiusZ2:Number;
      
      private var _scaleX:Number = 1;
      
      private var _scaleY:Number = 1;
      
      private var _scaleZ:Number = 1;
      
      private var _scaleX2:Number = 1;
      
      private var _scaleY2:Number = 1;
      
      private var _scaleZ2:Number = 1;
      
      private var collisionSource:Point3D;
      
      private var currentDisplacement:Point3D;
      
      private var collisionDestination:Point3D;
      
      private var collisionPlanes:Array;
      
      private var collisionPrimitive:PolyPrimitive;
      
      private var collisionPrimitiveNearest:PolyPrimitive;
      
      private var collisionPlanePoint:Point3D;
      
      private var collisionPrimitiveNearestLengthSqr:Number;
      
      private var collisionPrimitivePoint:Point3D;
      
      private var collisionNormal:Point3D;
      
      private var collisionPoint:Point3D;
      
      private var collisionOffset:Number;
      
      private var currentCoords:Point3D;
      
      private var collision:Collision;
      
      private var collisionRadius:Number;
      
      private var radiusVector:Point3D;
      
      private var p1:Point3D;
      
      private var p2:Point3D;
      
      private var localCollisionPlanePoint:Point3D;
      
      private var useSimpleAlgorithm:Boolean = true;
      
      public var scene:Scene3D;
      
      public var offsetThreshold:Number = 0.0001;
      
      public var collisionSet:Set;
      
      private var _collisionSetMode:int = 1;
      
      public function EllipsoidCollider(param1:Scene3D = null, param2:Number = 100, param3:Number = 100, param4:Number = 100)
      {
         this._radius2 = this._radius * this._radius;
         this._radiusX = this._radius;
         this._radiusY = this._radius;
         this._radiusZ = this._radius;
         this._radiusX2 = this._radiusX * this._radiusX;
         this._radiusY2 = this._radiusY * this._radiusY;
         this._radiusZ2 = this._radiusZ * this._radiusZ;
         this.currentDisplacement = new Point3D();
         this.collisionDestination = new Point3D();
         this.collisionPlanes = new Array();
         this.collisionPlanePoint = new Point3D();
         this.collisionPrimitivePoint = new Point3D();
         this.collisionNormal = new Point3D();
         this.collisionPoint = new Point3D();
         this.currentCoords = new Point3D();
         this.collision = new Collision();
         this.radiusVector = new Point3D();
         this.p1 = new Point3D();
         this.p2 = new Point3D();
         this.localCollisionPlanePoint = new Point3D();
         super();
         this.scene = param1;
         this.radiusX = param2;
         this.radiusY = param3;
         this.radiusZ = param4;
      }
      
      public function get collisionSetMode() : int
      {
         return this._collisionSetMode;
      }
      
      public function set collisionSetMode(param1:int) : void
      {
         if(param1 != CollisionSetMode.EXCLUDE && param1 != CollisionSetMode.INCLUDE)
         {
            throw ArgumentError(ObjectUtils.getClassName(this) + ".collisionSetMode invalid value");
         }
         this._collisionSetMode = param1;
      }
      
      public function get radiusX() : Number
      {
         return this._radiusX;
      }
      
      public function set radiusX(param1:Number) : void
      {
         this._radiusX = param1 >= 0 ? param1 : -param1;
         this._radiusX2 = this._radiusX * this._radiusX;
         this.calculateScales();
      }
      
      public function get radiusY() : Number
      {
         return this._radiusY;
      }
      
      public function set radiusY(param1:Number) : void
      {
         this._radiusY = param1 >= 0 ? param1 : -param1;
         this._radiusY2 = this._radiusY * this._radiusY;
         this.calculateScales();
      }
      
      public function get radiusZ() : Number
      {
         return this._radiusZ;
      }
      
      public function set radiusZ(param1:Number) : void
      {
         this._radiusZ = param1 >= 0 ? param1 : -param1;
         this._radiusZ2 = this._radiusZ * this._radiusZ;
         this.calculateScales();
      }
      
      private function calculateScales() : void
      {
         this._radius = this._radiusX;
         if(this._radiusY > this._radius)
         {
            this._radius = this._radiusY;
         }
         if(this._radiusZ > this._radius)
         {
            this._radius = this._radiusZ;
         }
         this._radius2 = this._radius * this._radius;
         this._scaleX = this._radiusX / this._radius;
         this._scaleY = this._radiusY / this._radius;
         this._scaleZ = this._radiusZ / this._radius;
         this._scaleX2 = this._scaleX * this._scaleX;
         this._scaleY2 = this._scaleY * this._scaleY;
         this._scaleZ2 = this._scaleZ * this._scaleZ;
         this.useSimpleAlgorithm = this._radiusX == this._radiusY && this._radiusX == this._radiusZ;
      }
      
      public function calculateDestination(param1:Point3D, param2:Point3D, param3:Point3D) : void
      {
         if(param2.x < this.offsetThreshold && param2.x > -this.offsetThreshold && param2.y < this.offsetThreshold && param2.y > -this.offsetThreshold && param2.z < this.offsetThreshold && param2.z > -this.offsetThreshold)
         {
            param3.x = param1.x;
            param3.y = param1.y;
            param3.z = param1.z;
            return;
         }
         this.currentCoords.x = param1.x;
         this.currentCoords.y = param1.y;
         this.currentCoords.z = param1.z;
         this.currentDisplacement.x = param2.x;
         this.currentDisplacement.y = param2.y;
         this.currentDisplacement.z = param2.z;
         param3.x = param1.x + this.currentDisplacement.x;
         param3.y = param1.y + this.currentDisplacement.y;
         param3.z = param1.z + this.currentDisplacement.z;
         if(this.useSimpleAlgorithm)
         {
            this.calculateDestinationS(param1,param3);
         }
         else
         {
            this.calculateDestinationE(param1,param3);
         }
      }
      
      private function calculateDestinationS(param1:Point3D, param2:Point3D) : void
      {
         var loc4:Boolean = false;
         var loc5:Number = NaN;
         var loc3:uint = 0;
         do
         {
            loc4 = this.getCollision(this.currentCoords,this.currentDisplacement,this.collision);
            if(loc4)
            {
               loc5 = this._radius + this.offsetThreshold + this.collision.offset - param2.x * this.collision.normal.x - param2.y * this.collision.normal.y - param2.z * this.collision.normal.z;
               param2.x += this.collision.normal.x * loc5;
               param2.y += this.collision.normal.y * loc5;
               param2.z += this.collision.normal.z * loc5;
               this.currentCoords.x = this.collision.point.x + this.collision.normal.x * (this._radius + this.offsetThreshold);
               this.currentCoords.y = this.collision.point.y + this.collision.normal.y * (this._radius + this.offsetThreshold);
               this.currentCoords.z = this.collision.point.z + this.collision.normal.z * (this._radius + this.offsetThreshold);
               this.currentDisplacement.x = param2.x - this.currentCoords.x;
               this.currentDisplacement.y = param2.y - this.currentCoords.y;
               this.currentDisplacement.z = param2.z - this.currentCoords.z;
               if(this.currentDisplacement.x < this.offsetThreshold && this.currentDisplacement.x > -this.offsetThreshold && this.currentDisplacement.y < this.offsetThreshold && this.currentDisplacement.y > -this.offsetThreshold && this.currentDisplacement.z < this.offsetThreshold && this.currentDisplacement.z > -this.offsetThreshold)
               {
                  break;
               }
            }
         }
         while(loc4 && ++loc3 < MAX_COLLISIONS);
         
         if(loc3 == MAX_COLLISIONS)
         {
            param2.x = param1.x;
            param2.y = param1.y;
            param2.z = param1.z;
         }
      }
      
      private function calculateDestinationE(param1:Point3D, param2:Point3D) : void
      {
         var loc4:Boolean = false;
         var loc5:Number = NaN;
         var loc3:uint = 0;
         do
         {
            loc4 = this.getCollision(this.currentCoords,this.currentDisplacement,this.collision);
            if(loc4)
            {
               loc5 = this.collisionRadius + this.offsetThreshold + this.collision.offset - param2.x * this.collision.normal.x - param2.y * this.collision.normal.y - param2.z * this.collision.normal.z;
               param2.x += this.collision.normal.x * loc5;
               param2.y += this.collision.normal.y * loc5;
               param2.z += this.collision.normal.z * loc5;
               this.collisionRadius = (this.collisionRadius + this.offsetThreshold) / this.collisionRadius;
               this.currentCoords.x = this.collision.point.x - this.collisionRadius * this.radiusVector.x;
               this.currentCoords.y = this.collision.point.y - this.collisionRadius * this.radiusVector.y;
               this.currentCoords.z = this.collision.point.z - this.collisionRadius * this.radiusVector.z;
               this.currentDisplacement.x = param2.x - this.currentCoords.x;
               this.currentDisplacement.y = param2.y - this.currentCoords.y;
               this.currentDisplacement.z = param2.z - this.currentCoords.z;
               if(this.currentDisplacement.x < this.offsetThreshold && this.currentDisplacement.x > -this.offsetThreshold && this.currentDisplacement.y < this.offsetThreshold && this.currentDisplacement.y > -this.offsetThreshold && this.currentDisplacement.z < this.offsetThreshold && this.currentDisplacement.z > -this.offsetThreshold)
               {
                  param2.x = this.currentCoords.x;
                  param2.y = this.currentCoords.y;
                  param2.z = this.currentCoords.z;
                  break;
               }
            }
         }
         while(loc4 && ++loc3 < MAX_COLLISIONS);
         
         if(loc3 == MAX_COLLISIONS)
         {
            param2.x = param1.x;
            param2.y = param1.y;
            param2.z = param1.z;
         }
      }
      
      public function getCollision(param1:Point3D, param2:Point3D, param3:Collision) : Boolean
      {
         var loc4:CollisionPlane = null;
         if(this.scene == null)
         {
            return false;
         }
         this.collisionSource = param1;
         this.currentDisplacement.x = param2.x;
         this.currentDisplacement.y = param2.y;
         this.currentDisplacement.z = param2.z;
         this.collisionDestination.x = this.collisionSource.x + this.currentDisplacement.x;
         this.collisionDestination.y = this.collisionSource.y + this.currentDisplacement.y;
         this.collisionDestination.z = this.collisionSource.z + this.currentDisplacement.z;
         this.collectPotentialCollisionPlanes(this.scene.alternativa3d::bsp);
         this.collisionPlanes.sortOn("sourceOffset",Array.NUMERIC | Array.DESCENDING);
         if(this.useSimpleAlgorithm)
         {
            while(true)
            {
               loc4 = this.collisionPlanes.pop();
               if(loc4 == null)
               {
                  break;
               }
               if(this.collisionPrimitive == null)
               {
                  this.calculateCollisionWithPlaneS(loc4);
               }
               CollisionPlane.alternativa3d::destroyCollisionPlane(loc4);
            }
         }
         else
         {
            while(true)
            {
               loc4 = this.collisionPlanes.pop();
               if(loc4 == null)
               {
                  break;
               }
               if(this.collisionPrimitive == null)
               {
                  this.calculateCollisionWithPlaneE(loc4);
               }
               CollisionPlane.alternativa3d::destroyCollisionPlane(loc4);
            }
         }
         var loc5:* = this.collisionPrimitive != null;
         if(loc5)
         {
            param3.face = this.collisionPrimitive.alternativa3d::face;
            param3.normal = this.collisionNormal;
            param3.offset = this.collisionOffset;
            param3.point = this.collisionPoint;
         }
         this.collisionPrimitive = null;
         this.collisionSource = null;
         return loc5;
      }
      
      private function collectPotentialCollisionPlanes(param1:BSPNode) : void
      {
         var loc4:CollisionPlane = null;
         if(param1 == null)
         {
            return;
         }
         var loc2:Number = this.collisionSource.x * param1.alternativa3d::normal.x + this.collisionSource.y * param1.alternativa3d::normal.y + this.collisionSource.z * param1.alternativa3d::normal.z - param1.alternativa3d::offset;
         var loc3:Number = this.collisionDestination.x * param1.alternativa3d::normal.x + this.collisionDestination.y * param1.alternativa3d::normal.y + this.collisionDestination.z * param1.alternativa3d::normal.z - param1.alternativa3d::offset;
         if(loc2 >= 0)
         {
            this.collectPotentialCollisionPlanes(param1.alternativa3d::front);
            if(loc3 < this._radius && !param1.alternativa3d::isSprite)
            {
               if(param1.alternativa3d::splitter == null)
               {
                  loc4 = CollisionPlane.alternativa3d::createCollisionPlane(param1,true,loc2,loc3);
                  this.collisionPlanes.push(loc4);
               }
               this.collectPotentialCollisionPlanes(param1.alternativa3d::back);
            }
         }
         else
         {
            this.collectPotentialCollisionPlanes(param1.alternativa3d::back);
            if(loc3 > -this._radius)
            {
               if(param1.alternativa3d::backPrimitives != null)
               {
                  loc4 = CollisionPlane.alternativa3d::createCollisionPlane(param1,false,-loc2,-loc3);
                  this.collisionPlanes.push(loc4);
               }
               this.collectPotentialCollisionPlanes(param1.alternativa3d::front);
            }
         }
      }
      
      private function calculateCollisionWithPlaneS(param1:CollisionPlane) : void
      {
         var loc3:* = undefined;
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
         this.collisionPlanePoint.copy(this.collisionSource);
         var loc2:Point3D = param1.node.alternativa3d::normal;
         if(param1.sourceOffset <= this._radius)
         {
            if(param1.infront)
            {
               this.collisionPlanePoint.x -= loc2.x * param1.sourceOffset;
               this.collisionPlanePoint.y -= loc2.y * param1.sourceOffset;
               this.collisionPlanePoint.z -= loc2.z * param1.sourceOffset;
            }
            else
            {
               this.collisionPlanePoint.x += loc2.x * param1.sourceOffset;
               this.collisionPlanePoint.y += loc2.y * param1.sourceOffset;
               this.collisionPlanePoint.z += loc2.z * param1.sourceOffset;
            }
         }
         else
         {
            loc4 = (param1.sourceOffset - this._radius) / (param1.sourceOffset - param1.destinationOffset);
            this.collisionPlanePoint.x = this.collisionSource.x + this.currentDisplacement.x * loc4;
            this.collisionPlanePoint.y = this.collisionSource.y + this.currentDisplacement.y * loc4;
            this.collisionPlanePoint.z = this.collisionSource.z + this.currentDisplacement.z * loc4;
            if(param1.infront)
            {
               this.collisionPlanePoint.x -= loc2.x * this._radius;
               this.collisionPlanePoint.y -= loc2.y * this._radius;
               this.collisionPlanePoint.z -= loc2.z * this._radius;
            }
            else
            {
               this.collisionPlanePoint.x += loc2.x * this._radius;
               this.collisionPlanePoint.y += loc2.y * this._radius;
               this.collisionPlanePoint.z += loc2.z * this._radius;
            }
         }
         this.collisionPrimitiveNearestLengthSqr = Number.MAX_VALUE;
         this.collisionPrimitiveNearest = null;
         if(param1.infront)
         {
            loc3 = param1.node.alternativa3d::primitive;
            if(loc3 != null)
            {
               if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc3.face._mesh]) || Boolean(this.collisionSet[loc3.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc3.face._mesh] || this.collisionSet[loc3.face._surface]))
               {
                  this.calculateCollisionWithPrimitiveS(param1.node.alternativa3d::primitive);
               }
            }
            else
            {
               for(loc3 in param1.node.alternativa3d::frontPrimitives)
               {
                  if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc3.face._mesh]) || Boolean(this.collisionSet[loc3.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc3.face._mesh] || this.collisionSet[loc3.face._surface]))
                  {
                     this.calculateCollisionWithPrimitiveS(loc3);
                     if(this.collisionPrimitive != null)
                     {
                        break;
                     }
                  }
               }
            }
         }
         else
         {
            for(loc3 in param1.node.alternativa3d::backPrimitives)
            {
               if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc3.face._mesh]) || Boolean(this.collisionSet[loc3.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc3.face._mesh] || this.collisionSet[loc3.face._surface]))
               {
                  this.calculateCollisionWithPrimitiveS(loc3);
                  if(this.collisionPrimitive != null)
                  {
                     break;
                  }
               }
            }
         }
         if(this.collisionPrimitive != null)
         {
            if(param1.infront)
            {
               this.collisionNormal.x = loc2.x;
               this.collisionNormal.y = loc2.y;
               this.collisionNormal.z = loc2.z;
               this.collisionOffset = param1.node.alternativa3d::offset;
            }
            else
            {
               this.collisionNormal.x = -loc2.x;
               this.collisionNormal.y = -loc2.y;
               this.collisionNormal.z = -loc2.z;
               this.collisionOffset = -param1.node.alternativa3d::offset;
            }
            this.collisionPoint.x = this.collisionPlanePoint.x;
            this.collisionPoint.y = this.collisionPlanePoint.y;
            this.collisionPoint.z = this.collisionPlanePoint.z;
         }
         else
         {
            loc5 = this.collisionSource.x - this.collisionPrimitivePoint.x;
            loc6 = this.collisionSource.y - this.collisionPrimitivePoint.y;
            loc7 = this.collisionSource.z - this.collisionPrimitivePoint.z;
            if(loc5 * this.currentDisplacement.x + loc6 * this.currentDisplacement.y + loc7 * this.currentDisplacement.z <= 0)
            {
               loc8 = Math.sqrt(this.currentDisplacement.x * this.currentDisplacement.x + this.currentDisplacement.y * this.currentDisplacement.y + this.currentDisplacement.z * this.currentDisplacement.z);
               loc9 = -this.currentDisplacement.x / loc8;
               loc10 = -this.currentDisplacement.y / loc8;
               loc11 = -this.currentDisplacement.z / loc8;
               loc12 = loc5 * loc5 + loc6 * loc6 + loc7 * loc7;
               loc13 = loc5 * loc9 + loc6 * loc10 + loc7 * loc11;
               loc14 = this._radius2 - loc12 + loc13 * loc13;
               if(loc14 > 0)
               {
                  loc15 = loc13 - Math.sqrt(loc14);
                  if(loc15 < loc8)
                  {
                     this.collisionPoint.x = this.collisionPrimitivePoint.x;
                     this.collisionPoint.y = this.collisionPrimitivePoint.y;
                     this.collisionPoint.z = this.collisionPrimitivePoint.z;
                     loc16 = Math.sqrt(loc12);
                     this.collisionNormal.x = loc5 / loc16;
                     this.collisionNormal.y = loc6 / loc16;
                     this.collisionNormal.z = loc7 / loc16;
                     this.collisionOffset = this.collisionPoint.x * this.collisionNormal.x + this.collisionPoint.y * this.collisionNormal.y + this.collisionPoint.z * this.collisionNormal.z;
                     this.collisionPrimitive = this.collisionPrimitiveNearest;
                  }
               }
            }
         }
      }
      
      private function calculateCollisionWithPrimitiveS(param1:PolyPrimitive) : void
      {
         var loc7:Point3D = null;
         var loc8:Point3D = null;
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
         var loc2:uint = param1.alternativa3d::num;
         var loc3:Array = param1.alternativa3d::points;
         var loc4:Point3D = param1.alternativa3d::face.alternativa3d::globalNormal;
         var loc5:Boolean = true;
         var loc6:uint = 0;
         while(loc6 < loc2)
         {
            loc7 = loc3[loc6];
            loc8 = loc3[loc6 < loc2 - 1 ? loc6 + 1 : 0];
            loc9 = loc8.x - loc7.x;
            loc10 = loc8.y - loc7.y;
            loc11 = loc8.z - loc7.z;
            loc12 = this.collisionPlanePoint.x - loc7.x;
            loc13 = this.collisionPlanePoint.y - loc7.y;
            loc14 = this.collisionPlanePoint.z - loc7.z;
            loc15 = loc13 * loc11 - loc14 * loc10;
            loc16 = loc14 * loc9 - loc12 * loc11;
            loc17 = loc12 * loc10 - loc13 * loc9;
            if(loc15 * loc4.x + loc16 * loc4.y + loc17 * loc4.z > 0)
            {
               loc5 = false;
               loc18 = loc9 * loc9 + loc10 * loc10 + loc11 * loc11;
               loc19 = (loc15 * loc15 + loc16 * loc16 + loc17 * loc17) / loc18;
               if(loc19 < this.collisionPrimitiveNearestLengthSqr)
               {
                  loc20 = Math.sqrt(loc18);
                  loc21 = loc9 / loc20;
                  loc22 = loc10 / loc20;
                  loc23 = loc11 / loc20;
                  loc24 = loc21 * loc12 + loc22 * loc13 + loc23 * loc14;
                  if(loc24 < 0)
                  {
                     loc25 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
                     if(loc25 < this.collisionPrimitiveNearestLengthSqr)
                     {
                        this.collisionPrimitiveNearestLengthSqr = loc25;
                        this.collisionPrimitivePoint.x = loc7.x;
                        this.collisionPrimitivePoint.y = loc7.y;
                        this.collisionPrimitivePoint.z = loc7.z;
                        this.collisionPrimitiveNearest = param1;
                     }
                  }
                  else if(loc24 > loc20)
                  {
                     loc12 = this.collisionPlanePoint.x - loc8.x;
                     loc13 = this.collisionPlanePoint.y - loc8.y;
                     loc14 = this.collisionPlanePoint.z - loc8.z;
                     loc25 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
                     if(loc25 < this.collisionPrimitiveNearestLengthSqr)
                     {
                        this.collisionPrimitiveNearestLengthSqr = loc25;
                        this.collisionPrimitivePoint.x = loc8.x;
                        this.collisionPrimitivePoint.y = loc8.y;
                        this.collisionPrimitivePoint.z = loc8.z;
                        this.collisionPrimitiveNearest = param1;
                     }
                  }
                  else
                  {
                     this.collisionPrimitiveNearestLengthSqr = loc19;
                     this.collisionPrimitivePoint.x = loc7.x + loc21 * loc24;
                     this.collisionPrimitivePoint.y = loc7.y + loc22 * loc24;
                     this.collisionPrimitivePoint.z = loc7.z + loc23 * loc24;
                     this.collisionPrimitiveNearest = param1;
                  }
               }
            }
            loc6++;
         }
         if(loc5)
         {
            this.collisionPrimitive = param1;
         }
      }
      
      private function calculateCollisionWithPlaneE(param1:CollisionPlane) : void
      {
         var loc14:* = undefined;
         var loc15:Number = NaN;
         var loc16:Boolean = false;
         var loc17:Number = NaN;
         var loc18:Number = NaN;
         var loc19:Number = NaN;
         var loc20:Number = NaN;
         var loc21:Number = NaN;
         var loc22:Number = NaN;
         var loc23:Number = NaN;
         var loc24:Number = NaN;
         var loc2:Number = param1.node.alternativa3d::normal.x;
         var loc3:Number = param1.node.alternativa3d::normal.y;
         var loc4:Number = param1.node.alternativa3d::normal.z;
         var loc5:Number = this.currentDisplacement.x * loc2 + this.currentDisplacement.y * loc3 + this.currentDisplacement.z * loc4;
         if(param1.infront)
         {
            loc5 = -loc5;
         }
         if(loc5 < 0)
         {
            return;
         }
         var loc6:Number = this._radius / Math.sqrt(loc2 * loc2 * this._scaleX2 + loc3 * loc3 * this._scaleY2 + loc4 * loc4 * this._scaleZ2);
         var loc7:Number = loc6 * loc2 * this._scaleX2;
         var loc8:Number = loc6 * loc3 * this._scaleY2;
         var loc9:Number = loc6 * loc4 * this._scaleZ2;
         var loc10:Number = this.collisionSource.x + loc7;
         var loc11:Number = this.collisionSource.y + loc8;
         var loc12:Number = this.collisionSource.z + loc9;
         var loc13:Number = loc10 * loc2 + loc11 * loc3 + loc12 * loc4 - param1.node.alternativa3d::offset;
         if(!param1.infront)
         {
            loc13 = -loc13;
         }
         if(loc13 > param1.sourceOffset)
         {
            loc10 = this.collisionSource.x - loc7;
            loc11 = this.collisionSource.y - loc8;
            loc12 = this.collisionSource.z - loc9;
            loc13 = loc10 * loc2 + loc11 * loc3 + loc12 * loc4 - param1.node.alternativa3d::offset;
            if(!param1.infront)
            {
               loc13 = -loc13;
            }
         }
         if(loc13 > loc5)
         {
            return;
         }
         if(loc13 <= 0)
         {
            if(param1.infront)
            {
               this.collisionPlanePoint.x = loc10 - loc2 * loc13;
               this.collisionPlanePoint.y = loc11 - loc3 * loc13;
               this.collisionPlanePoint.z = loc12 - loc4 * loc13;
            }
            else
            {
               this.collisionPlanePoint.x = loc10 + loc2 * loc13;
               this.collisionPlanePoint.y = loc11 + loc3 * loc13;
               this.collisionPlanePoint.z = loc12 + loc4 * loc13;
            }
         }
         else
         {
            loc15 = loc13 / loc5;
            this.collisionPlanePoint.x = loc10 + this.currentDisplacement.x * loc15;
            this.collisionPlanePoint.y = loc11 + this.currentDisplacement.y * loc15;
            this.collisionPlanePoint.z = loc12 + this.currentDisplacement.z * loc15;
         }
         this.collisionPrimitiveNearestLengthSqr = Number.MAX_VALUE;
         this.collisionPrimitiveNearest = null;
         if(param1.infront)
         {
            loc14 = param1.node.alternativa3d::primitive;
            if(loc14 != null)
            {
               if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc14.face._mesh]) || Boolean(this.collisionSet[loc14.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc14.face._mesh] || this.collisionSet[loc14.face._surface]))
               {
                  this.calculateCollisionWithPrimitiveE(loc14);
               }
            }
            else
            {
               for(loc14 in param1.node.alternativa3d::frontPrimitives)
               {
                  if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc14.face._mesh]) || Boolean(this.collisionSet[loc14.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc14.face._mesh] || this.collisionSet[loc14.face._surface]))
                  {
                     this.calculateCollisionWithPrimitiveE(loc14);
                     if(this.collisionPrimitive != null)
                     {
                        break;
                     }
                  }
               }
            }
         }
         else
         {
            for(loc14 in param1.node.alternativa3d::backPrimitives)
            {
               if(this._collisionSetMode == CollisionSetMode.EXCLUDE && (this.collisionSet == null || !(Boolean(this.collisionSet[loc14.face._mesh]) || Boolean(this.collisionSet[loc14.face._surface]))) || this._collisionSetMode == CollisionSetMode.INCLUDE && this.collisionSet != null && (this.collisionSet[loc14.face._mesh] || this.collisionSet[loc14.face._surface]))
               {
                  this.calculateCollisionWithPrimitiveE(loc14);
                  if(this.collisionPrimitive != null)
                  {
                     break;
                  }
               }
            }
         }
         if(this.collisionPrimitive != null)
         {
            if(param1.infront)
            {
               this.collisionNormal.x = loc2;
               this.collisionNormal.y = loc3;
               this.collisionNormal.z = loc4;
               this.collisionOffset = param1.node.alternativa3d::offset;
            }
            else
            {
               this.collisionNormal.x = -loc2;
               this.collisionNormal.y = -loc3;
               this.collisionNormal.z = -loc4;
               this.collisionOffset = -param1.node.alternativa3d::offset;
            }
            this.collisionRadius = loc7 * this.collisionNormal.x + loc8 * this.collisionNormal.y + loc9 * this.collisionNormal.z;
            if(this.collisionRadius < 0)
            {
               this.collisionRadius = -this.collisionRadius;
            }
            this.radiusVector.x = loc10 - this.collisionSource.x;
            this.radiusVector.y = loc11 - this.collisionSource.y;
            this.radiusVector.z = loc12 - this.collisionSource.z;
            this.collisionPoint.x = this.collisionPlanePoint.x;
            this.collisionPoint.y = this.collisionPlanePoint.y;
            this.collisionPoint.z = this.collisionPlanePoint.z;
         }
         else
         {
            loc10 = this.collisionPrimitivePoint.x;
            loc11 = this.collisionPrimitivePoint.y;
            loc12 = this.collisionPrimitivePoint.z;
            loc17 = loc10 * loc10 + loc11 * loc11 + loc12 * loc12;
            if(loc17 < this._radius2)
            {
               loc6 = this._radius / Math.sqrt(loc17);
               loc10 *= loc6 * this._scaleX;
               loc11 *= loc6 * this._scaleY;
               loc12 *= loc6 * this._scaleZ;
               loc16 = true;
            }
            else
            {
               loc18 = -this.currentDisplacement.x / this._scaleX;
               loc19 = -this.currentDisplacement.y / this._scaleY;
               loc20 = -this.currentDisplacement.z / this._scaleZ;
               loc21 = loc18 * loc18 + loc19 * loc19 + loc20 * loc20;
               loc22 = 2 * (loc10 * loc18 + loc11 * loc19 + loc12 * loc20);
               loc23 = loc17 - this._radius2;
               loc24 = loc22 * loc22 - 4 * loc21 * loc23;
               if(loc24 >= 0)
               {
                  loc15 = -0.5 * (loc22 + Math.sqrt(loc24)) / loc21;
                  if(loc15 >= 0 && loc15 <= 1)
                  {
                     loc10 = (loc10 + loc15 * loc18) * this._scaleX;
                     loc11 = (loc11 + loc15 * loc19) * this._scaleY;
                     loc12 = (loc12 + loc15 * loc20) * this._scaleZ;
                     loc16 = true;
                  }
               }
            }
            if(loc16)
            {
               this.collisionNormal.x = -loc10 / this._scaleX2;
               this.collisionNormal.y = -loc11 / this._scaleY2;
               this.collisionNormal.z = -loc12 / this._scaleZ2;
               this.collisionNormal.normalize();
               this.collisionRadius = loc10 * this.collisionNormal.x + loc11 * this.collisionNormal.y + loc12 * this.collisionNormal.z;
               if(this.collisionRadius < 0)
               {
                  this.collisionRadius = -this.collisionRadius;
               }
               this.radiusVector.x = loc10;
               this.radiusVector.y = loc11;
               this.radiusVector.z = loc12;
               this.collisionPoint.x = this.collisionPrimitivePoint.x * this._scaleX + this.currentCoords.x;
               this.collisionPoint.y = this.collisionPrimitivePoint.y * this._scaleY + this.currentCoords.y;
               this.collisionPoint.z = this.collisionPrimitivePoint.z * this._scaleZ + this.currentCoords.z;
               this.collisionOffset = this.collisionPoint.x * this.collisionNormal.x + this.collisionPoint.y * this.collisionNormal.y + this.collisionPoint.z * this.collisionNormal.z;
               this.collisionPrimitive = this.collisionPrimitiveNearest;
            }
         }
      }
      
      private function calculateCollisionWithPrimitiveE(param1:PolyPrimitive) : void
      {
         var loc6:Point3D = null;
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
         var loc2:uint = param1.alternativa3d::num;
         var loc3:Array = param1.alternativa3d::points;
         var loc4:Point3D = param1.alternativa3d::face.alternativa3d::globalNormal;
         var loc5:Boolean = true;
         var loc7:Point3D = loc3[loc2 - 1];
         this.p2.x = (loc7.x - this.currentCoords.x) / this._scaleX;
         this.p2.y = (loc7.y - this.currentCoords.y) / this._scaleY;
         this.p2.z = (loc7.z - this.currentCoords.z) / this._scaleZ;
         this.localCollisionPlanePoint.x = (this.collisionPlanePoint.x - this.currentCoords.x) / this._scaleX;
         this.localCollisionPlanePoint.y = (this.collisionPlanePoint.y - this.currentCoords.y) / this._scaleY;
         this.localCollisionPlanePoint.z = (this.collisionPlanePoint.z - this.currentCoords.z) / this._scaleZ;
         var loc8:uint = 0;
         while(loc8 < loc2)
         {
            loc6 = loc7;
            loc7 = loc3[loc8];
            this.p1.x = this.p2.x;
            this.p1.y = this.p2.y;
            this.p1.z = this.p2.z;
            this.p2.x = (loc7.x - this.currentCoords.x) / this._scaleX;
            this.p2.y = (loc7.y - this.currentCoords.y) / this._scaleY;
            this.p2.z = (loc7.z - this.currentCoords.z) / this._scaleZ;
            loc9 = this.p2.x - this.p1.x;
            loc10 = this.p2.y - this.p1.y;
            loc11 = this.p2.z - this.p1.z;
            loc12 = this.localCollisionPlanePoint.x - this.p1.x;
            loc13 = this.localCollisionPlanePoint.y - this.p1.y;
            loc14 = this.localCollisionPlanePoint.z - this.p1.z;
            loc15 = loc13 * loc11 - loc14 * loc10;
            loc16 = loc14 * loc9 - loc12 * loc11;
            loc17 = loc12 * loc10 - loc13 * loc9;
            if(loc15 * loc4.x + loc16 * loc4.y + loc17 * loc4.z > 0)
            {
               loc5 = false;
               loc18 = loc9 * loc9 + loc10 * loc10 + loc11 * loc11;
               loc19 = (loc15 * loc15 + loc16 * loc16 + loc17 * loc17) / loc18;
               if(loc19 < this.collisionPrimitiveNearestLengthSqr)
               {
                  loc20 = Math.sqrt(loc18);
                  loc21 = loc9 / loc20;
                  loc22 = loc10 / loc20;
                  loc23 = loc11 / loc20;
                  loc24 = loc21 * loc12 + loc22 * loc13 + loc23 * loc14;
                  if(loc24 < 0)
                  {
                     loc25 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
                     if(loc25 < this.collisionPrimitiveNearestLengthSqr)
                     {
                        this.collisionPrimitiveNearestLengthSqr = loc25;
                        this.collisionPrimitivePoint.x = this.p1.x;
                        this.collisionPrimitivePoint.y = this.p1.y;
                        this.collisionPrimitivePoint.z = this.p1.z;
                        this.collisionPrimitiveNearest = param1;
                     }
                  }
                  else if(loc24 > loc20)
                  {
                     loc12 = this.localCollisionPlanePoint.x - this.p2.x;
                     loc13 = this.localCollisionPlanePoint.y - this.p2.y;
                     loc14 = this.localCollisionPlanePoint.z - this.p2.z;
                     loc25 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
                     if(loc25 < this.collisionPrimitiveNearestLengthSqr)
                     {
                        this.collisionPrimitiveNearestLengthSqr = loc25;
                        this.collisionPrimitivePoint.x = this.p2.x;
                        this.collisionPrimitivePoint.y = this.p2.y;
                        this.collisionPrimitivePoint.z = this.p2.z;
                        this.collisionPrimitiveNearest = param1;
                     }
                  }
                  else
                  {
                     this.collisionPrimitiveNearestLengthSqr = loc19;
                     this.collisionPrimitivePoint.x = this.p1.x + loc21 * loc24;
                     this.collisionPrimitivePoint.y = this.p1.y + loc22 * loc24;
                     this.collisionPrimitivePoint.z = this.p1.z + loc23 * loc24;
                     this.collisionPrimitiveNearest = param1;
                  }
               }
            }
            loc8++;
         }
         if(loc5)
         {
            this.collisionPrimitive = param1;
         }
      }
   }
}

