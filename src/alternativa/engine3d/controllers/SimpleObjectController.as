package alternativa.engine3d.controllers
{
    import flash.display.InteractiveObject;
    import alternativa.engine3d.core.Object3D;
    import flash.geom.Vector3D;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Matrix3D;
    import flash.utils.getTimer;
    import alternativa.engine3d.core.Camera3D;
    import flash.ui.Keyboard;
    import __AS3__.vec.*;

    public class SimpleObjectController 
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

        public var speed:Number;
        public var speedMultiplier:Number;
        public var mouseSensitivity:Number;
        public var maxPitch:Number = 1E22;
        public var minPitch:Number = -1E22;
        private var eventSource:InteractiveObject;
        private var _object:Object3D;
        private var _up:Boolean;
        private var _down:Boolean;
        private var _forward:Boolean;
        private var _back:Boolean;
        private var _left:Boolean;
        private var _right:Boolean;
        private var _accelerate:Boolean;
        private var displacement:Vector3D = new Vector3D();
        private var mousePoint:Point = new Point();
        private var mouseLook:Boolean;
        private var objectTransform:Vector.<Vector3D>;
        private var time:int;
        private var actionBindings:Object = {};
        protected var keyBindings:Object = {};
        private var _vin:Vector.<Number> = new Vector.<Number>(3);
        private var _vout:Vector.<Number> = new Vector.<Number>(3);

        public function SimpleObjectController(_arg_1:InteractiveObject, _arg_2:Object3D, _arg_3:Number, _arg_4:Number=3, _arg_5:Number=1)
        {
            this.eventSource = _arg_1;
            this.object = _arg_2;
            this.speed = _arg_3;
            this.speedMultiplier = _arg_4;
            this.mouseSensitivity = _arg_5;
            this.actionBindings[ACTION_FORWARD] = this.moveForward;
            this.actionBindings[ACTION_BACK] = this.moveBack;
            this.actionBindings[ACTION_LEFT] = this.moveLeft;
            this.actionBindings[ACTION_RIGHT] = this.moveRight;
            this.actionBindings[ACTION_UP] = this.moveUp;
            this.actionBindings[ACTION_DOWN] = this.moveDown;
            this.actionBindings[ACTION_ACCELERATE] = this.accelerate;
            this.setDefaultBindings();
            this.enable();
        }

        public function enable():void
        {
            this.eventSource.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            this.eventSource.addEventListener(KeyboardEvent.KEY_UP, this.onKey);
            this.eventSource.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.eventSource.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }

        public function disable():void
        {
            this.eventSource.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            this.eventSource.removeEventListener(KeyboardEvent.KEY_UP, this.onKey);
            this.eventSource.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.eventSource.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            this.stopMouseLook();
        }

        private function onMouseDown(_arg_1:MouseEvent):void
        {
            this.startMouseLook();
        }

        private function onMouseUp(_arg_1:MouseEvent):void
        {
            this.stopMouseLook();
        }

        public function startMouseLook():void
        {
            this.mousePoint.x = this.eventSource.mouseX;
            this.mousePoint.y = this.eventSource.mouseY;
            this.mouseLook = true;
        }

        public function stopMouseLook():void
        {
            this.mouseLook = false;
        }

        private function onKey(_arg_1:KeyboardEvent):void
        {
            var _local_2:Function = this.keyBindings[_arg_1.keyCode];
            if (_local_2 != null)
            {
                _local_2.call(this, (_arg_1.type == KeyboardEvent.KEY_DOWN));
            };
        }

        public function get object():Object3D
        {
            return (this._object);
        }

        public function set object(_arg_1:Object3D):void
        {
            this._object = _arg_1;
            this.updateObjectTransform();
        }

        public function updateObjectTransform():void
        {
            if (this._object != null)
            {
                this.objectTransform = this._object.matrix.decompose();
            };
        }

        public function update():void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Vector3D;
            var _local_6:Number;
            var _local_7:Matrix3D;
            if (this._object == null)
            {
                return;
            };
            var _local_1:Number = this.time;
            this.time = getTimer();
            _local_1 = (0.001 * (this.time - _local_1));
            if (_local_1 > 0.1)
            {
                _local_1 = 0.1;
            };
            var _local_2:Boolean;
            if (this.mouseLook)
            {
                _local_3 = (this.eventSource.mouseX - this.mousePoint.x);
                _local_4 = (this.eventSource.mouseY - this.mousePoint.y);
                this.mousePoint.x = this.eventSource.mouseX;
                this.mousePoint.y = this.eventSource.mouseY;
                _local_5 = this.objectTransform[1];
                _local_5.x = (_local_5.x - (((_local_4 * Math.PI) / 180) * this.mouseSensitivity));
                if (_local_5.x > this.maxPitch)
                {
                    _local_5.x = this.maxPitch;
                };
                if (_local_5.x < this.minPitch)
                {
                    _local_5.x = this.minPitch;
                };
                _local_5.z = (_local_5.z - (((_local_3 * Math.PI) / 180) * this.mouseSensitivity));
                _local_2 = true;
            };
            this.displacement.x = ((this._right) ? 1 : ((this._left) ? -1 : 0));
            this.displacement.y = ((this._forward) ? 1 : ((this._back) ? -1 : 0));
            this.displacement.z = ((this._up) ? 1 : ((this._down) ? -1 : 0));
            if (this.displacement.lengthSquared > 0)
            {
                if ((this._object is Camera3D))
                {
                    _local_6 = this.displacement.z;
                    this.displacement.z = this.displacement.y;
                    this.displacement.y = -(_local_6);
                };
                this.deltaTransformVector(this.displacement);
                if (this._accelerate)
                {
                    this.displacement.scaleBy((((this.speedMultiplier * this.speed) * _local_1) / this.displacement.length));
                } else
                {
                    this.displacement.scaleBy(((this.speed * _local_1) / this.displacement.length));
                };
                (this.objectTransform[0] as Vector3D).incrementBy(this.displacement);
                _local_2 = true;
            };
            if (_local_2)
            {
                _local_7 = new Matrix3D();
                _local_7.recompose(this.objectTransform);
                this._object.matrix = _local_7;
            };
        }

        public function setObjectPos(_arg_1:Vector3D):void
        {
            var _local_2:Vector3D;
            if (this._object != null)
            {
                _local_2 = this.objectTransform[0];
                _local_2.x = _arg_1.x;
                _local_2.y = _arg_1.y;
                _local_2.z = _arg_1.z;
            };
        }

        public function setObjectPosXYZ(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Vector3D;
            if (this._object != null)
            {
                _local_4 = this.objectTransform[0];
                _local_4.x = _arg_1;
                _local_4.y = _arg_2;
                _local_4.z = _arg_3;
            };
        }

        public function lookAt(_arg_1:Vector3D):void
        {
            this.lookAtXYZ(_arg_1.x, _arg_1.y, _arg_1.z);
        }

        public function lookAtXYZ(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            if (this._object == null)
            {
                return;
            };
            var _local_4:Vector3D = this.objectTransform[0];
            var _local_5:Number = (_arg_1 - _local_4.x);
            var _local_6:Number = (_arg_2 - _local_4.y);
            var _local_7:Number = (_arg_3 - _local_4.z);
            _local_4 = this.objectTransform[1];
            _local_4.x = Math.atan2(_local_7, Math.sqrt(((_local_5 * _local_5) + (_local_6 * _local_6))));
            if ((this._object is Camera3D))
            {
                _local_4.x = (_local_4.x - (0.5 * Math.PI));
            };
            _local_4.y = 0;
            _local_4.z = -(Math.atan2(_local_5, _local_6));
            var _local_8:Matrix3D = this._object.matrix;
            _local_8.recompose(this.objectTransform);
            this._object.matrix = _local_8;
        }

        private function deltaTransformVector(_arg_1:Vector3D):void
        {
            this._vin[0] = _arg_1.x;
            this._vin[1] = _arg_1.y;
            this._vin[2] = _arg_1.z;
            this._object.matrix.transformVectors(this._vin, this._vout);
            var _local_2:Vector3D = this.objectTransform[0];
            _arg_1.x = (this._vout[0] - _local_2.x);
            _arg_1.y = (this._vout[1] - _local_2.y);
            _arg_1.z = (this._vout[2] - _local_2.z);
        }

        public function moveForward(_arg_1:Boolean):void
        {
            this._forward = _arg_1;
        }

        public function moveBack(_arg_1:Boolean):void
        {
            this._back = _arg_1;
        }

        public function moveLeft(_arg_1:Boolean):void
        {
            this._left = _arg_1;
        }

        public function moveRight(_arg_1:Boolean):void
        {
            this._right = _arg_1;
        }

        public function moveUp(_arg_1:Boolean):void
        {
            this._up = _arg_1;
        }

        public function moveDown(_arg_1:Boolean):void
        {
            this._down = _arg_1;
        }

        public function accelerate(_arg_1:Boolean):void
        {
            this._accelerate = _arg_1;
        }

        public function bindKey(_arg_1:uint, _arg_2:String):void
        {
            var _local_3:Function = this.actionBindings[_arg_2];
            if (_local_3 != null)
            {
                this.keyBindings[_arg_1] = _local_3;
            };
        }

        public function bindKeys(_arg_1:Array):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                this.bindKey(_arg_1[_local_2], _arg_1[(_local_2 + 1)]);
                _local_2 = (_local_2 + 2);
            };
        }

        public function unbindKey(_arg_1:uint):void
        {
            delete this.keyBindings[_arg_1];
        }

        public function unbindAll():void
        {
            var _local_1:String;
            for (_local_1 in this.keyBindings)
            {
                delete this.keyBindings[_local_1];
            };
        }

        public function setDefaultBindings():void
        {
            this.bindKey(87, ACTION_FORWARD);
            this.bindKey(83, ACTION_BACK);
            this.bindKey(65, ACTION_LEFT);
            this.bindKey(68, ACTION_RIGHT);
            this.bindKey(69, ACTION_UP);
            this.bindKey(67, ACTION_DOWN);
            this.bindKey(Keyboard.SHIFT, ACTION_ACCELERATE);
            this.bindKey(Keyboard.UP, ACTION_FORWARD);
            this.bindKey(Keyboard.DOWN, ACTION_BACK);
            this.bindKey(Keyboard.LEFT, ACTION_LEFT);
            this.bindKey(Keyboard.RIGHT, ACTION_RIGHT);
        }


    }
}//package alternativa.engine3d.controllers