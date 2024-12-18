package alternativa.editor.engine3d.controllers
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.types.Matrix4;
   import alternativa.types.Point3D;
   import alternativa.utils.KeyboardUtils;
   import alternativa.utils.MathUtils;
   import flash.display.DisplayObject;
   import flash.geom.Vector3D;
   
   use namespace alternativa3d;
   
   public class WalkController extends ObjectController
   {
      private var _airControlCoefficient:Number = 1;
      
      private var _objectZPosition:Number = 0.5;
      
      private var destination:Point3D;
      
      private var tmpVelocity:Point3D;
      
      private var _onGround:Boolean;
      
      private var _currentSpeed:Number = 0;
      
      public var jumpSpeed:Number = 0;
      
      //private var _groundMesh:Mesh;
      
      private const collisionPos:Vector3D = new Vector3D();
      private const collisionNormal:Vector3D = new Vector3D();
      
      public var gravity:Number = 0;
      
      private var minGroundCos:Number;
      
      private var controlsActive:Boolean;
      
      private var velocity:Point3D;
      
      private var startRotX:Number;
      
      public var speedThreshold:Number = 1;
      
      private var startRotZ:Number;
      
      private var currentMouseCoords:Point3D;
      
      private var prevMouseCoords:Point3D;
      
      private var inJump:Boolean;
      
      private var _flyMode:Boolean;
      
      private var _jumpLocked:Boolean;
      
      public function WalkController(eventSourceObject:DisplayObject)
      {
         minGroundCos = Math.cos(MathUtils.toRadian(70));
         destination = new Point3D();
         //collision = new Collision();
         velocity = new Point3D();
         tmpVelocity = new Point3D();
         prevMouseCoords = new Point3D();
         currentMouseCoords = new Point3D();
         super(eventSourceObject);
      }
      
      public function get airControlCoefficient() : Number
      {
         return _airControlCoefficient;
      }
      
      public function set airControlCoefficient(value:Number) : void
      {
         _airControlCoefficient = value > 0 ? value : -value;
      }
      
      public function get maxGroundAngle() : Number
      {
         return Math.acos(minGroundCos);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(!value)
         {
            velocity.reset();
            _currentSpeed = 0;
         }
      }
      
      override protected function getDisplacement(frameTime:Number, displacement:Point3D) : void
      {
         var len:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var matrix:Matrix4 = null;
         var heading:Number = NaN;
         var headingCos:Number = NaN;
         var headingSin:Number = NaN;
         var spd:Number = NaN;
         var cos:Number = 0;
         if(checkCollisions && !_flyMode)
         {
            displacement.x = 0;
            displacement.y = 0;
            displacement.z = -0.5 * gravity * frameTime * frameTime;
            if(_collider.getCollision(_coords.toVector3D(),displacement.toVector3D(), collisionPos,collisionNormal, _object))
            {
               cos = collisionNormal.z;
               //_groundMesh = collision.face.alternativa3d::_mesh;
            }
            else
            {
               //_groundMesh = null;
            }
         }
         _onGround = cos > minGroundCos;
         if(_onGround && inJump)
         {
            inJump = false;
            if(!_up)
            {
               _jumpLocked = false;
            }
         }
         controlsActive = _forward || _back || _right || _left;
         if(flyMode || gravity == 0)
         {
            controlsActive = controlsActive || (_up || _down);
         }
         if(controlsActive)
         {
            if(_flyMode)
            {
               tmpVelocity.x = 0;
               tmpVelocity.y = 0;
               tmpVelocity.z = 0;
               if(_forward)
               {
                  tmpVelocity.y = 1;
               }
               else if(_back)
               {
                  tmpVelocity.y = -1;
               }
               if(_right)
               {
                  tmpVelocity.x = 1;
               }
               else if(_left)
               {
                  tmpVelocity.x = -1;
               }
               if(_up)
               {
                  tmpVelocity.z = 1;
               }
               else if(_down)
               {
                  tmpVelocity.z = -1;
               }
               matrix = _object.transformation;
               x = tmpVelocity.x;
               if(_object is Camera3D)
               {
                  y = -tmpVelocity.z;
                  z = tmpVelocity.y;
               }
               else
               {
                  y = tmpVelocity.y;
                  z = tmpVelocity.z;
               }
               velocity.x += (x * matrix.a + y * matrix.b + z * matrix.c) * _speed;
               velocity.y += (x * matrix.e + y * matrix.f + z * matrix.g) * _speed;
               velocity.z += (x * matrix.i + y * matrix.j + z * matrix.k) * _speed;
            }
            else
            {
               heading = _object.rotationZ;
               headingCos = Math.cos(heading);
               headingSin = Math.sin(heading);
               spd = _speed;
               if(gravity != 0 && !_onGround)
               {
                  spd *= _airControlCoefficient;
               }
               if(_forward)
               {
                  velocity.x -= spd * headingSin;
                  velocity.y += spd * headingCos;
               }
               else if(_back)
               {
                  velocity.x += spd * headingSin;
                  velocity.y -= spd * headingCos;
               }
               if(_right)
               {
                  velocity.x += spd * headingCos;
                  velocity.y += spd * headingSin;
               }
               else if(_left)
               {
                  velocity.x -= spd * headingCos;
                  velocity.y -= spd * headingSin;
               }
               if(gravity == 0)
               {
                  if(_up)
                  {
                     velocity.z += _speed;
                  }
                  else if(_down)
                  {
                     velocity.z -= _speed;
                  }
               }
            }
         }
         else
         {
            len = 1 / Math.pow(3,frameTime * 10);
            if(_flyMode || gravity == 0)
            {
               velocity.x *= len;
               velocity.y *= len;
               velocity.z *= len;
            }
            else if(_onGround)
            {
               velocity.x *= len;
               velocity.y *= len;
               if(velocity.z < 0)
               {
                  velocity.z *= len;
               }
            }
            else if(cos > 0 && velocity.z > 0)
            {
               velocity.z = 0;
            }
         }
         if(_onGround && _up && !inJump && !_jumpLocked)
         {
            velocity.z = jumpSpeed;
            inJump = true;
            _onGround = false;
            _jumpLocked = true;
            cos = 0;
         }
         if(!(_flyMode || _onGround))
         {
            velocity.z -= gravity * frameTime;
         }
         var max:Number = _accelerate ? _speed * _speedMultiplier : _speed;
         if(_flyMode || gravity == 0)
         {
            len = velocity.length;
            if(len > max)
            {
               velocity.length = max;
            }
         }
         else
         {
            len = Math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
            if(len > max)
            {
               velocity.x *= max / len;
               velocity.y *= max / len;
            }
            if(cos > 0 && velocity.z > 0)
            {
               velocity.z = 0;
            }
         }
         displacement.x = velocity.x * frameTime;
         displacement.y = velocity.y * frameTime;
         displacement.z = velocity.z * frameTime;
      }
      
      public function set objectZPosition(value:Number) : void
      {
         _objectZPosition = value;
         setObjectCoords();
      }
      
      public function set maxGroundAngle(value:Number) : void
      {
         minGroundCos = Math.cos(value);
      }
      
      /*public function get groundMesh() : Mesh
      {
         return _groundMesh;
      }*/
      
      override protected function startMouseLook() : void
      {
         super.startMouseLook();
         startRotX = _object is Camera3D ? _object.rotationX + MathUtils.DEG90 : _object.rotationX;
         startRotZ = _object.rotationZ;
      }
      
      override protected function applyDisplacement(frameTime:Number, displacement:Point3D) : void
      {
         if(checkCollisions)
         {
            var destination3D:Vector3D = _collider.calculateDestination(_coords.toVector3D(),displacement.toVector3D(),_object);
            destination.copyFromVector3D(destination3D);
            displacement.x = destination.x - _coords.x;
            displacement.y = destination.y - _coords.y;
            displacement.z = destination.z - _coords.z;
         }
         else
         {
            destination.x = _coords.x + displacement.x;
            destination.y = _coords.y + displacement.y;
            destination.z = _coords.z + displacement.z;
         }
         velocity.x = displacement.x / frameTime;
         velocity.y = displacement.y / frameTime;
         velocity.z = displacement.z / frameTime;
         _coords.x = destination.x;
         _coords.y = destination.y;
         _coords.z = destination.z;
         setObjectCoords();
         var len:Number = Math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y + velocity.z * velocity.z);
         if(len < speedThreshold)
         {
            velocity.x = 0;
            velocity.y = 0;
            velocity.z = 0;
            _currentSpeed = 0;
         }
         else
         {
            _currentSpeed = len;
         }
      }
      
      public function lookAt(point:Point3D) : void
      {
         if(_object == null)
         {
            return;
         }
         var dx:Number = point.x - _object.x;
         var dy:Number = point.y - _object.y;
         var dz:Number = point.z - _object.z;
         _object.rotationX = Math.atan2(dz,Math.sqrt(dx * dx + dy * dy)) - (_object is Camera3D ? MathUtils.DEG90 : 0);
         _object.rotationY = 0;
         _object.rotationZ = -Math.atan2(dx,dy);
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
      
      public function get flyMode() : Boolean
      {
         return _flyMode;
      }
      
      override protected function setObjectCoords() : void
      {
         if(_object != null)
         {
            _object.x = _coords.x;
            _object.y = _coords.y;
            _object.z = _coords.z + (2 * _objectZPosition - 1) * _collider.radiusZ;
         }
      }
      
      public function get objectZPosition() : Number
      {
         return _objectZPosition;
      }
      
      override public function moveUp(value:Boolean) : void
      {
         super.moveUp(value);
         if(!inJump && !value)
         {
            _jumpLocked = false;
         }
      }
      
      public function get onGround() : Boolean
      {
         return _onGround;
      }
      
      public function set flyMode(value:Boolean) : void
      {
         _flyMode = value;
      }
      
      override protected function rotateObject(frameTime:Number) : void
      {
         var rotX:Number = NaN;
         if(_mouseLookActive)
         {
            prevMouseCoords.copy(currentMouseCoords);
            currentMouseCoords.x = _eventsSource.stage.mouseX;
            currentMouseCoords.y = _eventsSource.stage.mouseY;
            if(!prevMouseCoords.equals(currentMouseCoords))
            {
               _object.rotationZ = startRotZ + (startMouseCoords.x - currentMouseCoords.x) * _mouseCoefficientX;
               rotX = startRotX + (startMouseCoords.y - currentMouseCoords.y) * _mouseCoefficientY;
               if(_object is Camera3D)
               {
                  _object.rotationX = rotX > MathUtils.DEG90 ? 0 : (rotX < -MathUtils.DEG90 ? -Math.PI : rotX - MathUtils.DEG90);
               }
               else
               {
                  _object.rotationX = rotX > MathUtils.DEG90 ? MathUtils.DEG90 : (rotX < -MathUtils.DEG90 ? -MathUtils.DEG90 : rotX);
               }
            }
         }
         if(_yawLeft)
         {
            _object.rotationZ += _yawSpeed * frameTime;
         }
         else if(_yawRight)
         {
            _object.rotationZ -= _yawSpeed * frameTime;
         }
         rotX = NaN;
         if(_pitchUp)
         {
            rotX = _object.rotationX + _pitchSpeed * frameTime;
         }
         else if(_pitchDown)
         {
            rotX = _object.rotationX - _pitchSpeed * frameTime;
         }
         if(!isNaN(rotX))
         {
            if(_object is Camera3D)
            {
               _object.rotationX = rotX > 0 ? 0 : (rotX < -Math.PI ? -Math.PI : rotX);
            }
            else
            {
               _object.rotationX = rotX > MathUtils.DEG90 ? MathUtils.DEG90 : (rotX < -MathUtils.DEG90 ? -MathUtils.DEG90 : rotX);
            }
         }
      }
      
      public function get currentSpeed() : Number
      {
         return _currentSpeed;
      }
   }
}

