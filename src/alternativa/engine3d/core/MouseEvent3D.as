package alternativa.engine3d.core
{
    import flash.events.Event;
    import flash.geom.Vector3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class MouseEvent3D extends Event 
    {

        public static const CLICK:String = "click3D";
        public static const DOUBLE_CLICK:String = "doubleClick3D";
        public static const MOUSE_DOWN:String = "mouseDown3D";
        public static const MOUSE_UP:String = "mouseUp3D";
        public static const MOUSE_OVER:String = "mouseOver3D";
        public static const MOUSE_OUT:String = "mouseOut3D";
        public static const ROLL_OVER:String = "rollOver3D";
        public static const ROLL_OUT:String = "rollOut3D";
        public static const MOUSE_MOVE:String = "mouseMove3D";
        public static const MOUSE_WHEEL:String = "mouseWheel3D";

        public var ctrlKey:Boolean;
        public var altKey:Boolean;
        public var shiftKey:Boolean;
        public var buttonDown:Boolean;
        public var delta:int;
        public var relatedObject:Object3D;
        public var localOrigin:Vector3D = new Vector3D();
        public var localDirection:Vector3D = new Vector3D();
        alternativa3d var _target:Object3D;
        alternativa3d var _currentTarget:Object3D;
        alternativa3d var _bubbles:Boolean;
        alternativa3d var _eventPhase:uint = 3;
        alternativa3d var stop:Boolean = false;
        alternativa3d var stopImmediate:Boolean = false;

        public function MouseEvent3D(_arg_1:String, _arg_2:Boolean=true, _arg_3:Object3D=null, _arg_4:Boolean=false, _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:Boolean=false, _arg_8:int=0)
        {
            super(_arg_1, _arg_2);
            this.relatedObject = _arg_3;
            this.altKey = _arg_4;
            this.ctrlKey = _arg_5;
            this.shiftKey = _arg_6;
            this.buttonDown = _arg_7;
            this.delta = _arg_8;
        }

        alternativa3d function calculateLocalRay(_arg_1:Number, _arg_2:Number, _arg_3:Object3D, _arg_4:Camera3D):void
        {
            _arg_4.calculateRay(this.localOrigin, this.localDirection, _arg_1, _arg_2);
            _arg_3.composeMatrix();
            var _local_5:Object3D = _arg_3;
            while (_local_5._parent != null)
            {
                _local_5 = _local_5._parent;
                _local_5.composeMatrix();
                _arg_3.appendMatrix(_local_5);
            };
            _arg_3.invertMatrix();
            var _local_6:Number = this.localOrigin.x;
            var _local_7:Number = this.localOrigin.y;
            var _local_8:Number = this.localOrigin.z;
            var _local_9:Number = this.localDirection.x;
            var _local_10:Number = this.localDirection.y;
            var _local_11:Number = this.localDirection.z;
            this.localOrigin.x = ((((_arg_3.ma * _local_6) + (_arg_3.mb * _local_7)) + (_arg_3.mc * _local_8)) + _arg_3.md);
            this.localOrigin.y = ((((_arg_3.me * _local_6) + (_arg_3.mf * _local_7)) + (_arg_3.mg * _local_8)) + _arg_3.mh);
            this.localOrigin.z = ((((_arg_3.mi * _local_6) + (_arg_3.mj * _local_7)) + (_arg_3.mk * _local_8)) + _arg_3.ml);
            this.localDirection.x = (((_arg_3.ma * _local_9) + (_arg_3.mb * _local_10)) + (_arg_3.mc * _local_11));
            this.localDirection.y = (((_arg_3.me * _local_9) + (_arg_3.mf * _local_10)) + (_arg_3.mg * _local_11));
            this.localDirection.z = (((_arg_3.mi * _local_9) + (_arg_3.mj * _local_10)) + (_arg_3.mk * _local_11));
        }

        override public function get bubbles():Boolean
        {
            return (this._bubbles);
        }

        override public function get eventPhase():uint
        {
            return (this._eventPhase);
        }

        override public function get target():Object
        {
            return (this._target);
        }

        override public function get currentTarget():Object
        {
            return (this._currentTarget);
        }

        override public function stopPropagation():void
        {
            this.stop = true;
        }

        override public function stopImmediatePropagation():void
        {
            this.stopImmediate = true;
        }

        override public function clone():Event
        {
            return (new MouseEvent3D(type, this._bubbles, this.relatedObject, this.altKey, this.ctrlKey, this.shiftKey, this.buttonDown, this.delta));
        }

        override public function toString():String
        {
            return (formatToString("MouseEvent3D", "type", "bubbles", "eventPhase", "relatedObject", "altKey", "ctrlKey", "shiftKey", "buttonDown", "delta"));
        }


    }
}//package alternativa.engine3d.core