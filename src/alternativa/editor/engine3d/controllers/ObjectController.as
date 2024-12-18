package alternativa.editor.engine3d.controllers
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Object3D;
   import alternativa.types.Map;
   import alternativa.types.Point3D;
   import alternativa.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import alternativa.engine3d.core.EllipsoidCollider;
   import flash.geom.Vector3D;
   
   use namespace alternativa3d;
   
   public class ObjectController
   {
      public static const ACTION_FORWARD:String = "ACTION_FORWARD";
      
      public static const ACTION_BACK:String = "ACTION_BACK";
      
      public static const ACTION_LEFT:String = "ACTION_LEFT";
      
      public static const ACTION_RIGHT:String = "ACTION_RIGHT";
      
      public static const ACTION_UP:String = "ACTION_UP";
      
      public static const ACTION_DOWN:String = "ACTION_DOWN";
      
      public static const ACTION_PITCH_UP:String = "ACTION_PITCH_UP";
      
      public static const ACTION_PITCH_DOWN:String = "ACTION_PITCH_DOWN";
      
      public static const ACTION_YAW_LEFT:String = "ACTION_YAW_LEFT";
      
      public static const ACTION_YAW_RIGHT:String = "ACTION_YAW_RIGHT";
      
      public static const ACTION_ACCELERATE:String = "ACTION_ACCELERATE";
      
      public static const ACTION_MOUSE_LOOK:String = "ACTION_MOUSE_LOOK";
      
      protected var _enabled:Boolean = true;
      
      protected var keyBindings:Map;
      
      protected var _mouseSensitivity:Number = 1;
      
      protected var _keyboardEnabled:Boolean;
      
      protected var _right:Boolean;
      
      protected var _speedMultiplier:Number = 2;
      
      //public var onStopMoving:Function;
      
      protected var _up:Boolean;
      
      protected var _coords:Point3D;
      
      protected var _speed:Number = 100;
      
      protected var _yawRight:Boolean;
      
      protected var _collider:EllipsoidCollider;
      
      protected var _object:Object3D;
      
      protected var _mouseSensitivityX:Number;
      
      protected var _mouseSensitivityY:Number;
      
      protected var startMouseCoords:Point3D;
      
      protected var _eventsSource:DisplayObject;
      
      protected var _yawSpeed:Number = 1;
      
      protected var _accelerate:Boolean;
      
      protected var _down:Boolean;
      
      protected var _pitchDown:Boolean;
      
      protected var _forward:Boolean;
      
      protected var _mouseCoefficientX:Number;
      
      protected var _mouseCoefficientY:Number;
      
      protected var _pitchSpeed:Number = 1;
      
      //protected var _isMoving:Boolean;
      
      public var checkCollisions:Boolean;
      
      protected var _mouseEnabled:Boolean;
      
      protected var _pitchUp:Boolean;
      
      protected var _back:Boolean;
      
      protected var _mouseLookActive:Boolean;
      
      protected var _yawLeft:Boolean;
      
      protected var actionBindings:Map;
      
      protected var _left:Boolean;
      
      protected var lastFrameTime:uint;
      
      //public var onStartMoving:Function;
      
      private var _displacement:Point3D;
      
      public function ObjectController(eventsSourceObject:DisplayObject)
      {
         startMouseCoords = new Point3D();
         keyBindings = new Map();
         actionBindings = new Map();
         _mouseSensitivityY = Math.PI / 360;
         _mouseSensitivityX = Math.PI / 360;
         _mouseCoefficientY = _mouseSensitivity * _mouseSensitivityY;
         _mouseCoefficientX = _mouseSensitivity * _mouseSensitivityX;
         _coords = new Point3D();
         _collider = new EllipsoidCollider(50,50,50);
         _displacement = new Point3D();
         super();
         if(eventsSourceObject == null)
         {
            throw new ArgumentError(ObjectUtils.getClassName(this) + ": eventsSourceObject is null");
         }
         _eventsSource = eventsSourceObject;
         actionBindings[ACTION_FORWARD] = moveForward;
         actionBindings[ACTION_BACK] = moveBack;
         actionBindings[ACTION_LEFT] = moveLeft;
         actionBindings[ACTION_RIGHT] = moveRight;
         actionBindings[ACTION_UP] = moveUp;
         actionBindings[ACTION_DOWN] = moveDown;
         actionBindings[ACTION_PITCH_UP] = pitchUp;
         actionBindings[ACTION_PITCH_DOWN] = pitchDown;
         actionBindings[ACTION_YAW_LEFT] = yawLeft;
         actionBindings[ACTION_YAW_RIGHT] = yawRight;
         actionBindings[ACTION_ACCELERATE] = accelerate;
         actionBindings[ACTION_MOUSE_LOOK] = setMouseLook;
         keyboardEnabled = true;
         mouseEnabled = true;
      }
      
      public function pitchDown(value:Boolean) : void
      {
         _pitchDown = value;
      }
      
      public function moveDown(value:Boolean) : void
      {
         _down = value;
      }
      
      public function yawLeft(value:Boolean) : void
      {
         _yawLeft = value;
      }
      
      public function get yawSpeed() : Number
      {
         return _yawSpeed;
      }
      
      public function get coords() : Point3D
      {
         return _coords.clone();
      }
      public function get coords3D() : Vector3D
      {
         return _coords.toVector3D();
      }
      
      public function get accelerated() : Boolean
      {
         return _accelerate;
      }
      
      public function setDefaultBindings() : void
      {
      }
      
      public function set yawSpeed(spd:Number) : void
      {
         _yawSpeed = spd;
      }
      
      public function unbindKey(keyCode:uint) : void
      {
         keyBindings.remove(keyCode);
      }
      
      protected function stopMouseLook() : void
      {
      }
      
      public function set coords(value:Point3D) : void
      {
         _coords.copy(value);
         setObjectCoords();
      }

      public function setObjectPos(pos:Vector3D) : void
      {
         _coords.copyFromVector3D(pos);
         setObjectCoords();
      }
      
      public function get object() : Object3D
      {
         return _object;
      }
      
      protected function unregisterKeyboardListeners() : void
      {
         clearCommandFlags();
         _eventsSource.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent);
         _eventsSource.removeEventListener(KeyboardEvent.KEY_UP,onKeyboardEvent);
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function readCoords(point:Point3D) : void
      {
         point.copy(_coords);
      }
      
      public function moveBack(value:Boolean) : void
      {
         _back = value;
      }
      
      public function get keyboardEnabled() : Boolean
      {
         return _keyboardEnabled;
      }
      
      public function moveUp(value:Boolean) : void
      {
         _up = value;
      }
      
      private function onKeyboardEvent(e:KeyboardEvent) : void
      {
         var method:Function = keyBindings[e.keyCode];
         if(method != null)
         {
            method.call(this,e.type == KeyboardEvent.KEY_DOWN);
         }
      }
      
      public function get speedMultiplier() : Number
      {
         return _speedMultiplier;
      }
      
      public function unbindAll() : void
      {
         keyBindings.clear();
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         setMouseLook(false);
         _eventsSource.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
      }
      
      public function moveLeft(value:Boolean) : void
      {
         _left = value;
      }
      
      public function set mouseSensitivity(sensitivity:Number) : void
      {
         _mouseSensitivity = sensitivity;
         _mouseCoefficientY = _mouseSensitivity * _mouseSensitivityY;
         _mouseCoefficientX = _mouseSensitivity * _mouseSensitivityX;
      }
      
      protected function unregisterMouseListeners() : void
      {
         _eventsSource.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         _eventsSource.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
      }
      
      public function set object(value:Object3D) : void
      {
         _object = value;
         //_collider.scene = _object == null ? null : _object.scene;
         setObjectCoords();
      }
      
      public function set enabled(value:Boolean) : void
      {
         _enabled = value;
         if(_enabled)
         {
            if(_mouseEnabled)
            {
               registerMouseListeners();
            }
            if(_keyboardEnabled)
            {
               registerKeyboardListeners();
            }
         }
         else
         {
            if(_mouseEnabled)
            {
               unregisterMouseListeners();
               setMouseLook(false);
            }
            if(_keyboardEnabled)
            {
               unregisterKeyboardListeners();
            }
         }
      }
      
      public function set speed(value:Number) : void
      {
         _speed = value < 0 ? -value : value;
      }
      
      protected function rotateObject(frameTime:Number) : void
      {
      }
      
      protected function getDisplacement(frameTime:Number, displacement:Point3D) : void
      {
      }
      
      public function processInput() : void
      {
         if(!_enabled || _object == null)
         {
            return;
         }
         var frameTime:Number = getTimer() - lastFrameTime;
         if(frameTime == 0)
         {
            return;
         }
         lastFrameTime += frameTime;
         if(frameTime > 100)
         {
            frameTime = 100;
         }
         frameTime /= 1000;
         rotateObject(frameTime);
         getDisplacement(frameTime,_displacement);
         applyDisplacement(frameTime,_displacement);
         /*if(Boolean(_object.changeRotationOrScaleOperation.queued) || Boolean(_object.changeCoordsOperation.queued))
         {
            if(!_isMoving)
            {
               _isMoving = true;
               if(onStartMoving != null)
               {
                  onStartMoving.call(this);
               }
            }
         }
         else if(_isMoving)
         {
            _isMoving = false;
            if(onStopMoving != null)
            {
               onStopMoving.call(this);
            }
         }*/
      }
      
      protected function registerMouseListeners() : void
      {
         _eventsSource.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
      }
      
      public function setMouseLook(value:Boolean) : void
      {
         if(_mouseLookActive != value)
         {
            _mouseLookActive = value;
            if(_mouseLookActive)
            {
               startMouseLook();
            }
            else
            {
               stopMouseLook();
            }
         }
      }
      
      protected function applyDisplacement(frameTime:Number, displacement:Point3D) : void
      {
      }
      
      protected function startMouseLook() : void
      {
         startMouseCoords.x = _eventsSource.stage.mouseX;
         startMouseCoords.y = _eventsSource.stage.mouseY;
      }
      
      public function moveForward(value:Boolean) : void
      {
         _forward = value;
      }
      
      protected function registerKeyboardListeners() : void
      {
         _eventsSource.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent);
         _eventsSource.addEventListener(KeyboardEvent.KEY_UP,onKeyboardEvent);
      }
      
      public function set mouseEnabled(value:Boolean) : void
      {
         if(_mouseEnabled != value)
         {
            _mouseEnabled = value;
            if(_mouseEnabled)
            {
               if(_enabled)
               {
                  registerMouseListeners();
               }
            }
            else
            {
               unregisterMouseListeners();
            }
         }
      }
      
      public function get mouseSensitivity() : Number
      {
         return _mouseSensitivity;
      }
      
      protected function setObjectCoords() : void
      {
         if(_object != null)
         {
            _object.setPositionXYZ(_coords.x,_coords.y,_coords.z);
         }
      }
      
      public function set mouseSensitivityY(value:Number) : void
      {
         _mouseSensitivityY = value;
         _mouseCoefficientY = _mouseSensitivity * _mouseSensitivityY;
      }
      
      public function set pitchSpeed(spd:Number) : void
      {
         _pitchSpeed = spd;
      }
      
      public function set speedMultiplier(value:Number) : void
      {
         _speedMultiplier = value;
      }
      
      public function moveRight(value:Boolean) : void
      {
         _right = value;
      }
      
      public function set mouseSensitivityX(value:Number) : void
      {
         _mouseSensitivityX = value;
         _mouseCoefficientX = _mouseSensitivity * _mouseSensitivityX;
      }
      
      public function set keyboardEnabled(value:Boolean) : void
      {
         if(_keyboardEnabled != value)
         {
            _keyboardEnabled = value;
            if(_keyboardEnabled)
            {
               if(_enabled)
               {
                  registerKeyboardListeners();
               }
            }
            else
            {
               unregisterKeyboardListeners();
            }
         }
      }
      
      public function get mouseEnabled() : Boolean
      {
         return _mouseEnabled;
      }
      
      public function accelerate(value:Boolean) : void
      {
         _accelerate = value;
      }
      
      public function get mouseSensitivityX() : Number
      {
         return _mouseSensitivityX;
      }
      
      public function get mouseSensitivityY() : Number
      {
         return _mouseSensitivityY;
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         setMouseLook(true);
         _eventsSource.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
      }
      
      public function get pitchSpeed() : Number
      {
         return _pitchSpeed;
      }
      
      public function bindKey(keyCode:uint, action:String) : void
      {
         var method:Function = actionBindings[action];
         if(method != null)
         {
            keyBindings[keyCode] = method;
         }
      }
      
      public function yawRight(value:Boolean) : void
      {
         _yawRight = value;
      }
      
      protected function clearCommandFlags() : void
      {
         _forward = false;
         _back = false;
         _left = false;
         _right = false;
         _up = false;
         _down = false;
         _pitchUp = false;
         _pitchDown = false;
         _yawLeft = false;
         _yawRight = false;
         _accelerate = false;
         _mouseLookActive = false;
      }
      
      public function get collider() : EllipsoidCollider
      {
         return _collider;
      }
      
      public function pitchUp(value:Boolean) : void
      {
         _pitchUp = value;
      }
   }
}

