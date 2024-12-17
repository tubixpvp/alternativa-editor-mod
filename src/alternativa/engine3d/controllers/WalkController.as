package alternativa.engine3d.controllers
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.physics.Collision;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.utils.KeyboardUtils;
   import alternativa.utils.MathUtils;
   import flash.display.DisplayObject;
   
   use namespace alternativa3d;
   
   public class WalkController extends ObjectController
   {
      public var gravity:Number = 0;
      
      public var jumpSpeed:Number = 0;
      
      private var _groundMesh:Mesh;
      
      public var speedThreshold:Number = 1;
      
      public var maxPitch:Number = 1.5707963267948966;
      
      public var minPitch:Number = -1.5707963267948966;
      
      private var _airControlCoefficient:Number = 1;
      
      private var _currentSpeed:Number = 0;
      
      private var minGroundCos:Number;
      
      private var destination:Point3D;
      
      private var collision:Collision;
      
      private var _objectZPosition:Number = 0.5;
      
      private var _flyMode:Boolean;
      
      private var _onGround:Boolean;
      
      private var _jumpLocked:Boolean;
      
      private var velocity:Point3D;
      
      private var tmpVelocity:Point3D;
      
      private var controlsActive:Boolean;
      
      private var inJump:Boolean;
      
      private var startRotX:Number;
      
      private var startRotZ:Number;
      
      private var prevMouseCoords:Point3D;
      
      private var currentMouseCoords:Point3D;
      
      public function WalkController(param1:DisplayObject, param2:Object3D = null)
      {
         this.minGroundCos = Math.cos(MathUtils.toRadian(70));
         this.destination = new Point3D();
         this.collision = new Collision();
         this.velocity = new Point3D();
         this.tmpVelocity = new Point3D();
         this.prevMouseCoords = new Point3D();
         this.currentMouseCoords = new Point3D();
         super(param1);
         this.object = param2;
      }
      
      public function get groundMesh() : Mesh
      {
         return this._groundMesh;
      }
      
      public function lookAt(param1:Point3D) : void
      {
         if(_object == null)
         {
            return;
         }
         var loc2:Number = param1.x - _object.x;
         var loc3:Number = param1.y - _object.y;
         var loc4:Number = param1.z - _object.z;
         _object.rotationX = Math.atan2(loc4,Math.sqrt(loc2 * loc2 + loc3 * loc3)) - (_object is Camera3D ? MathUtils.DEG90 : 0);
         _object.rotationY = 0;
         _object.rotationZ = -Math.atan2(loc2,loc3);
      }
      
      public function get airControlCoefficient() : Number
      {
         return this._airControlCoefficient;
      }
      
      public function set airControlCoefficient(param1:Number) : void
      {
         this._airControlCoefficient = param1 > 0 ? param1 : -param1;
      }
      
      public function get maxGroundAngle() : Number
      {
         return Math.acos(this.minGroundCos);
      }
      
      public function set maxGroundAngle(param1:Number) : void
      {
         this.minGroundCos = Math.cos(param1);
      }
      
      public function get objectZPosition() : Number
      {
         return this._objectZPosition;
      }
      
      public function set objectZPosition(param1:Number) : void
      {
         this._objectZPosition = param1;
         this.setObjectCoords();
      }
      
      public function get flyMode() : Boolean
      {
         return this._flyMode;
      }
      
      public function set flyMode(param1:Boolean) : void
      {
         this._flyMode = param1;
      }
      
      public function get onGround() : Boolean
      {
         return this._onGround;
      }
      
      public function get currentSpeed() : Number
      {
         return this._currentSpeed;
      }
      
      override public function setDefaultBindings() : void
      {
         unbindAll();
         bindKey(KeyboardUtils.W,ACTION_FORWARD);
         bindKey(KeyboardUtils.S,ACTION_BACK);
         bindKey(KeyboardUtils.A,ACTION_LEFT);
         bindKey(KeyboardUtils.D,ACTION_RIGHT);
         bindKey(KeyboardUtils.SPACE,ACTION_UP);
         bindKey(KeyboardUtils.Z,ACTION_DOWN);
         bindKey(KeyboardUtils.UP,ACTION_PITCH_UP);
         bindKey(KeyboardUtils.DOWN,ACTION_PITCH_DOWN);
         bindKey(KeyboardUtils.LEFT,ACTION_YAW_LEFT);
         bindKey(KeyboardUtils.RIGHT,ACTION_YAW_RIGHT);
         bindKey(KeyboardUtils.SHIFT,ACTION_ACCELERATE);
         bindKey(KeyboardUtils.M,ACTION_MOUSE_LOOK);
      }
      
      override protected function rotateObject(param1:Number) : void
      {
         var loc2:Number = NaN;
         if(_mouseLookActive)
         {
            this.prevMouseCoords.copy(this.currentMouseCoords);
            this.currentMouseCoords.x = _eventsSource.stage.mouseX;
            this.currentMouseCoords.y = _eventsSource.stage.mouseY;
            if(!this.prevMouseCoords.equals(this.currentMouseCoords))
            {
               _object.rotationZ = this.startRotZ + (startMouseCoords.x - this.currentMouseCoords.x) * _mouseCoefficientX;
               loc2 = this.startRotX + (startMouseCoords.y - this.currentMouseCoords.y) * _mouseCoefficientY;
               if(_object is Camera3D)
               {
                  _object.rotationX = (loc2 > this.maxPitch ? this.maxPitch : (loc2 < this.minPitch ? this.minPitch : loc2)) - MathUtils.DEG90;
               }
               else
               {
                  _object.rotationX = loc2 > this.maxPitch ? this.maxPitch : (loc2 < this.minPitch ? this.minPitch : loc2);
               }
            }
         }
         if(_yawLeft)
         {
            _object.rotationZ += _yawSpeed * param1;
         }
         else if(_yawRight)
         {
            _object.rotationZ -= _yawSpeed * param1;
         }
         loc2 = NaN;
         if(_pitchUp)
         {
            loc2 = _object.rotationX + _pitchSpeed * param1;
         }
         else if(_pitchDown)
         {
            loc2 = _object.rotationX - _pitchSpeed * param1;
         }
         if(!isNaN(loc2))
         {
            if(_object is Camera3D)
            {
               _object.rotationX = loc2 > 0 ? 0 : (loc2 < -Math.PI ? -Math.PI : loc2);
            }
            else
            {
               _object.rotationX = loc2 > MathUtils.DEG90 ? MathUtils.DEG90 : (loc2 < -MathUtils.DEG90 ? -MathUtils.DEG90 : loc2);
            }
         }
      }
      
      override protected function getDisplacement(param1:Number, param2:Point3D) : void
      {
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc9:Matrix3D = null;
         var loc10:Number = NaN;
         var loc11:Number = NaN;
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         var loc3:Number = 0;
         if(checkCollisions && !this._flyMode)
         {
            param2.x = 0;
            param2.y = 0;
            param2.z = -0.5 * this.gravity * param1 * param1;
            if(_collider.getCollision(_coords,param2,this.collision))
            {
               loc3 = this.collision.normal.z;
               this._groundMesh = this.collision.face.alternativa3d::_mesh;
            }
            else
            {
               this._groundMesh = null;
            }
         }
         this._onGround = loc3 > this.minGroundCos;
         if(this._onGround && this.inJump)
         {
            this.inJump = false;
            if(!_up)
            {
               this._jumpLocked = false;
            }
         }
         this.controlsActive = _forward || _back || _right || _left;
         if(this.flyMode || this.gravity == 0)
         {
            this.controlsActive = this.controlsActive || (_up || _down);
         }
         if(this.controlsActive)
         {
            if(this._flyMode)
            {
               this.tmpVelocity.x = 0;
               this.tmpVelocity.y = 0;
               this.tmpVelocity.z = 0;
               if(_forward)
               {
                  this.tmpVelocity.y = 1;
               }
               else if(_back)
               {
                  this.tmpVelocity.y = -1;
               }
               if(_right)
               {
                  this.tmpVelocity.x = 1;
               }
               else if(_left)
               {
                  this.tmpVelocity.x = -1;
               }
               if(_up)
               {
                  this.tmpVelocity.z = 1;
               }
               else if(_down)
               {
                  this.tmpVelocity.z = -1;
               }
               loc9 = _object.alternativa3d::_transformation;
               loc5 = this.tmpVelocity.x;
               if(_object is Camera3D)
               {
                  loc6 = -this.tmpVelocity.z;
                  loc7 = this.tmpVelocity.y;
               }
               else
               {
                  loc6 = this.tmpVelocity.y;
                  loc7 = this.tmpVelocity.z;
               }
               this.velocity.x += (loc5 * loc9.a + loc6 * loc9.b + loc7 * loc9.c) * _speed;
               this.velocity.y += (loc5 * loc9.e + loc6 * loc9.f + loc7 * loc9.g) * _speed;
               this.velocity.z += (loc5 * loc9.i + loc6 * loc9.j + loc7 * loc9.k) * _speed;
            }
            else
            {
               loc10 = _object.rotationZ;
               loc11 = Math.cos(loc10);
               loc12 = Math.sin(loc10);
               loc13 = _speed;
               if(this.gravity != 0 && !this._onGround)
               {
                  loc13 *= this._airControlCoefficient;
               }
               if(_forward)
               {
                  this.velocity.x -= loc13 * loc12;
                  this.velocity.y += loc13 * loc11;
               }
               else if(_back)
               {
                  this.velocity.x += loc13 * loc12;
                  this.velocity.y -= loc13 * loc11;
               }
               if(_right)
               {
                  this.velocity.x += loc13 * loc11;
                  this.velocity.y += loc13 * loc12;
               }
               else if(_left)
               {
                  this.velocity.x -= loc13 * loc11;
                  this.velocity.y -= loc13 * loc12;
               }
               if(this.gravity == 0)
               {
                  if(_up)
                  {
                     this.velocity.z += _speed;
                  }
                  else if(_down)
                  {
                     this.velocity.z -= _speed;
                  }
               }
            }
         }
         else
         {
            loc4 = 1 / Math.pow(3,param1 * 10);
            if(this._flyMode || this.gravity == 0)
            {
               this.velocity.x *= loc4;
               this.velocity.y *= loc4;
               this.velocity.z *= loc4;
            }
            else if(this._onGround)
            {
               this.velocity.x *= loc4;
               this.velocity.y *= loc4;
               if(this.velocity.z < 0)
               {
                  this.velocity.z *= loc4;
               }
            }
            else if(loc3 > 0 && this.velocity.z > 0)
            {
               this.velocity.z = 0;
            }
         }
         if(this._onGround && _up && !this.inJump && !this._jumpLocked)
         {
            this.velocity.z = this.jumpSpeed;
            this.inJump = true;
            this._onGround = false;
            this._jumpLocked = true;
            loc3 = 0;
         }
         if(!(this._flyMode || this._onGround))
         {
            this.velocity.z -= this.gravity * param1;
         }
         var loc8:Number = _accelerate ? _speed * _speedMultiplier : _speed;
         if(this._flyMode || this.gravity == 0)
         {
            loc4 = this.velocity.length;
            if(loc4 > loc8)
            {
               this.velocity.length = loc8;
            }
         }
         else
         {
            loc4 = Math.sqrt(this.velocity.x * this.velocity.x + this.velocity.y * this.velocity.y);
            if(loc4 > loc8)
            {
               this.velocity.x *= loc8 / loc4;
               this.velocity.y *= loc8 / loc4;
            }
            if(loc3 > 0 && this.velocity.z > 0)
            {
               this.velocity.z = 0;
            }
         }
         param2.x = this.velocity.x * param1;
         param2.y = this.velocity.y * param1;
         param2.z = this.velocity.z * param1;
      }
      
      override protected function applyDisplacement(param1:Number, param2:Point3D) : void
      {
         if(checkCollisions)
         {
            _collider.calculateDestination(_coords,param2,this.destination);
            param2.x = this.destination.x - _coords.x;
            param2.y = this.destination.y - _coords.y;
            param2.z = this.destination.z - _coords.z;
         }
         else
         {
            this.destination.x = _coords.x + param2.x;
            this.destination.y = _coords.y + param2.y;
            this.destination.z = _coords.z + param2.z;
         }
         this.velocity.x = param2.x / param1;
         this.velocity.y = param2.y / param1;
         this.velocity.z = param2.z / param1;
         _coords.x = this.destination.x;
         _coords.y = this.destination.y;
         _coords.z = this.destination.z;
         this.setObjectCoords();
         var loc3:Number = Math.sqrt(this.velocity.x * this.velocity.x + this.velocity.y * this.velocity.y + this.velocity.z * this.velocity.z);
         if(loc3 < this.speedThreshold)
         {
            this.velocity.x = 0;
            this.velocity.y = 0;
            this.velocity.z = 0;
            this._currentSpeed = 0;
         }
         else
         {
            this._currentSpeed = loc3;
         }
      }
      
      override protected function setObjectCoords() : void
      {
         if(_object != null)
         {
            _object.x = _coords.x;
            _object.y = _coords.y;
            _object.z = _coords.z + (2 * this._objectZPosition - 1) * _collider.radiusZ;
         }
      }
      
      override protected function startMouseLook() : void
      {
         super.startMouseLook();
         this.startRotX = _object is Camera3D ? _object.rotationX + MathUtils.DEG90 : _object.rotationX;
         this.startRotZ = _object.rotationZ;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(!param1)
         {
            this.velocity.reset();
            this._currentSpeed = 0;
         }
      }
      
      override public function moveUp(param1:Boolean) : void
      {
         super.moveUp(param1);
         if(!this.inJump && !param1)
         {
            this._jumpLocked = false;
         }
      }
   }
}

