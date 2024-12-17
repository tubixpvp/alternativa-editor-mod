package alternativa.engine3d.controllers
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Scene3D;
   import alternativa.engine3d.physics.EllipsoidCollider;
   import alternativa.types.Map;
   import alternativa.types.Point3D;
   import alternativa.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
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
      
      protected var _forward:Boolean;
      
      protected var _back:Boolean;
      
      protected var _left:Boolean;
      
      protected var _right:Boolean;
      
      protected var _up:Boolean;
      
      protected var _down:Boolean;
      
      protected var _pitchUp:Boolean;
      
      protected var _pitchDown:Boolean;
      
      protected var _yawLeft:Boolean;
      
      protected var _yawRight:Boolean;
      
      protected var _accelerate:Boolean;
      
      protected var _mouseLookActive:Boolean;
      
      protected var startMouseCoords:Point3D;
      
      protected var _enabled:Boolean = true;
      
      protected var _eventsSource:DisplayObject;
      
      protected var keyBindings:Map;
      
      protected var actionBindings:Map;
      
      protected var _keyboardEnabled:Boolean;
      
      protected var _mouseEnabled:Boolean;
      
      protected var _mouseSensitivity:Number = 1;
      
      protected var _mouseSensitivityY:Number = 0.008726646259971648;
      
      protected var _mouseSensitivityX:Number = 0.008726646259971648;
      
      protected var _mouseCoefficientY:Number;
      
      protected var _mouseCoefficientX:Number;
      
      protected var _pitchSpeed:Number = 1;
      
      protected var _yawSpeed:Number = 1;
      
      protected var _speed:Number = 100;
      
      protected var _speedMultiplier:Number = 2;
      
      protected var _object:Object3D;
      
      protected var lastFrameTime:uint;
      
      protected var _coords:Point3D;
      
      protected var _isMoving:Boolean;
      
      protected var _collider:EllipsoidCollider;
      
      public var checkCollisions:Boolean;
      
      public var onStartMoving:Function;
      
      public var onStopMoving:Function;
      
      private var _displacement:Point3D;
      
      public function ObjectController(param1:DisplayObject)
      {
         this.startMouseCoords = new Point3D();
         this.keyBindings = new Map();
         this.actionBindings = new Map();
         this._mouseCoefficientY = this._mouseSensitivity * this._mouseSensitivityY;
         this._mouseCoefficientX = this._mouseSensitivity * this._mouseSensitivityX;
         this._coords = new Point3D();
         this._collider = new EllipsoidCollider();
         this._displacement = new Point3D();
         super();
         if(param1 == null)
         {
            throw new ArgumentError(ObjectUtils.getClassName(this) + ": eventsSourceObject is null");
         }
         this._eventsSource = param1;
         this.actionBindings[ACTION_FORWARD] = this.moveForward;
         this.actionBindings[ACTION_BACK] = this.moveBack;
         this.actionBindings[ACTION_LEFT] = this.moveLeft;
         this.actionBindings[ACTION_RIGHT] = this.moveRight;
         this.actionBindings[ACTION_UP] = this.moveUp;
         this.actionBindings[ACTION_DOWN] = this.moveDown;
         this.actionBindings[ACTION_PITCH_UP] = this.pitchUp;
         this.actionBindings[ACTION_PITCH_DOWN] = this.pitchDown;
         this.actionBindings[ACTION_YAW_LEFT] = this.yawLeft;
         this.actionBindings[ACTION_YAW_RIGHT] = this.yawRight;
         this.actionBindings[ACTION_ACCELERATE] = this.accelerate;
         this.actionBindings[ACTION_MOUSE_LOOK] = this.setMouseLook;
         this.keyboardEnabled = true;
         this.mouseEnabled = true;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         if(this._enabled)
         {
            if(this._mouseEnabled)
            {
               this.registerMouseListeners();
            }
            if(this._keyboardEnabled)
            {
               this.registerKeyboardListeners();
            }
         }
         else
         {
            if(this._mouseEnabled)
            {
               this.unregisterMouseListeners();
               this.setMouseLook(false);
            }
            if(this._keyboardEnabled)
            {
               this.unregisterKeyboardListeners();
            }
         }
      }
      
      public function get coords() : Point3D
      {
         return this._coords.clone();
      }
      
      public function set coords(param1:Point3D) : void
      {
         this._coords.copy(param1);
         this.setObjectCoords();
      }
      
      public function readCoords(param1:Point3D) : void
      {
         param1.copy(this._coords);
      }
      
      public function get object() : Object3D
      {
         return this._object;
      }
      
      public function set object(param1:Object3D) : void
      {
         this._object = param1;
         this._collider.scene = this._object == null ? null : this._object.scene;
         this.setObjectCoords();
      }
      
      public function get collider() : EllipsoidCollider
      {
         return this._collider;
      }
      
      public function moveForward(param1:Boolean) : void
      {
         this._forward = param1;
      }
      
      public function moveBack(param1:Boolean) : void
      {
         this._back = param1;
      }
      
      public function moveLeft(param1:Boolean) : void
      {
         this._left = param1;
      }
      
      public function moveRight(param1:Boolean) : void
      {
         this._right = param1;
      }
      
      public function moveUp(param1:Boolean) : void
      {
         this._up = param1;
      }
      
      public function moveDown(param1:Boolean) : void
      {
         this._down = param1;
      }
      
      public function pitchUp(param1:Boolean) : void
      {
         this._pitchUp = param1;
      }
      
      public function pitchDown(param1:Boolean) : void
      {
         this._pitchDown = param1;
      }
      
      public function yawLeft(param1:Boolean) : void
      {
         this._yawLeft = param1;
      }
      
      public function yawRight(param1:Boolean) : void
      {
         this._yawRight = param1;
      }
      
      public function accelerate(param1:Boolean) : void
      {
         this._accelerate = param1;
      }
      
      public function get pitchSpeed() : Number
      {
         return this._pitchSpeed;
      }
      
      public function set pitchSpeed(param1:Number) : void
      {
         this._pitchSpeed = param1;
      }
      
      public function get yawSpeed() : Number
      {
         return this._yawSpeed;
      }
      
      public function set yawSpeed(param1:Number) : void
      {
         this._yawSpeed = param1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1 < 0 ? -param1 : param1;
      }
      
      public function get speedMultiplier() : Number
      {
         return this._speedMultiplier;
      }
      
      public function set speedMultiplier(param1:Number) : void
      {
         this._speedMultiplier = param1;
      }
      
      public function get mouseSensitivity() : Number
      {
         return this._mouseSensitivity;
      }
      
      public function set mouseSensitivity(param1:Number) : void
      {
         this._mouseSensitivity = param1;
         this._mouseCoefficientY = this._mouseSensitivity * this._mouseSensitivityY;
         this._mouseCoefficientX = this._mouseSensitivity * this._mouseSensitivityX;
      }
      
      public function get mouseSensitivityY() : Number
      {
         return this._mouseSensitivityY;
      }
      
      public function set mouseSensitivityY(param1:Number) : void
      {
         this._mouseSensitivityY = param1;
         this._mouseCoefficientY = this._mouseSensitivity * this._mouseSensitivityY;
      }
      
      public function get mouseSensitivityX() : Number
      {
         return this._mouseSensitivityX;
      }
      
      public function set mouseSensitivityX(param1:Number) : void
      {
         this._mouseSensitivityX = param1;
         this._mouseCoefficientX = this._mouseSensitivity * this._mouseSensitivityX;
      }
      
      public function setMouseLook(param1:Boolean) : void
      {
         if(this._mouseLookActive != param1)
         {
            this._mouseLookActive = param1;
            if(this._mouseLookActive)
            {
               this.startMouseLook();
            }
            else
            {
               this.stopMouseLook();
            }
         }
      }
      
      protected function startMouseLook() : void
      {
         this.startMouseCoords.x = this._eventsSource.stage.mouseX;
         this.startMouseCoords.y = this._eventsSource.stage.mouseY;
      }
      
      protected function stopMouseLook() : void
      {
      }
      
      public function processInput() : void
      {
         if(!this._enabled || this._object == null)
         {
            return;
         }
         var loc1:Number = getTimer() - this.lastFrameTime;
         if(loc1 == 0)
         {
            return;
         }
         this.lastFrameTime += loc1;
         if(loc1 > 100)
         {
            loc1 = 100;
         }
         loc1 /= 1000;
         this.rotateObject(loc1);
         this.getDisplacement(loc1,this._displacement);
         this.applyDisplacement(loc1,this._displacement);
         if(this._object.alternativa3d::changeRotationOrScaleOperation.alternativa3d::queued || this._object.alternativa3d::changeCoordsOperation.alternativa3d::queued)
         {
            if(!this._isMoving)
            {
               this._isMoving = true;
               if(this.onStartMoving != null)
               {
                  this.onStartMoving.call(this);
               }
            }
         }
         else if(this._isMoving)
         {
            this._isMoving = false;
            if(this.onStopMoving != null)
            {
               this.onStopMoving.call(this);
            }
         }
      }
      
      protected function rotateObject(param1:Number) : void
      {
      }
      
      protected function getDisplacement(param1:Number, param2:Point3D) : void
      {
      }
      
      protected function applyDisplacement(param1:Number, param2:Point3D) : void
      {
      }
      
      public function bindKey(param1:uint, param2:String) : void
      {
         var loc3:Function = this.actionBindings[param2];
         if(loc3 != null)
         {
            this.keyBindings[param1] = loc3;
         }
      }
      
      public function unbindKey(param1:uint) : void
      {
         this.keyBindings.remove(param1);
      }
      
      public function unbindAll() : void
      {
         this.keyBindings.clear();
      }
      
      public function setDefaultBindings() : void
      {
      }
      
      public function get keyboardEnabled() : Boolean
      {
         return this._keyboardEnabled;
      }
      
      public function set keyboardEnabled(param1:Boolean) : void
      {
         if(this._keyboardEnabled != param1)
         {
            this._keyboardEnabled = param1;
            if(this._keyboardEnabled)
            {
               if(this._enabled)
               {
                  this.registerKeyboardListeners();
               }
            }
            else
            {
               this.unregisterKeyboardListeners();
            }
         }
      }
      
      private function onKeyboardEvent(param1:KeyboardEvent) : void
      {
         var loc2:Function = this.keyBindings[param1.keyCode];
         if(loc2 != null)
         {
            loc2.call(this,param1.type == KeyboardEvent.KEY_DOWN);
         }
      }
      
      protected function registerKeyboardListeners() : void
      {
         this._eventsSource.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardEvent);
         this._eventsSource.addEventListener(KeyboardEvent.KEY_UP,this.onKeyboardEvent);
      }
      
      protected function unregisterKeyboardListeners() : void
      {
         this.clearCommandFlags();
         this._eventsSource.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardEvent);
         this._eventsSource.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyboardEvent);
      }
      
      public function get mouseEnabled() : Boolean
      {
         return this._mouseEnabled;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         if(this._mouseEnabled != param1)
         {
            this._mouseEnabled = param1;
            if(this._mouseEnabled)
            {
               if(this._enabled)
               {
                  this.registerMouseListeners();
               }
            }
            else
            {
               this.unregisterMouseListeners();
            }
         }
      }
      
      protected function registerMouseListeners() : void
      {
         this._eventsSource.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      protected function unregisterMouseListeners() : void
      {
         this._eventsSource.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._eventsSource.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.setMouseLook(true);
         this._eventsSource.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.setMouseLook(false);
         this._eventsSource.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      protected function setObjectCoords() : void
      {
         if(this._object != null)
         {
            this._object.coords = this._coords;
         }
      }
      
      public function get accelerated() : Boolean
      {
         return this._accelerate;
      }
      
      protected function clearCommandFlags() : void
      {
         this._forward = false;
         this._back = false;
         this._left = false;
         this._right = false;
         this._up = false;
         this._down = false;
         this._pitchUp = false;
         this._pitchDown = false;
         this._yawLeft = false;
         this._yawRight = false;
         this._accelerate = false;
         this._mouseLookActive = false;
      }
   }
}

