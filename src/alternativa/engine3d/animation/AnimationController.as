package alternativa.engine3d.animation
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Object3D;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import alternativa.engine3d.animation.events.NotifyEvent;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationController 
    {

        private var _root:AnimationNode;
        private var _objects:Vector.<Object>;
        private var _object3ds:Vector.<Object3D> = new Vector.<Object3D>();
        private var objectsUsedCount:Dictionary = new Dictionary();
        private var states:Object = new Object();
        private var lastTime:int = -1;
        alternativa3d var nearestNotifyers:AnimationNotify;


        public function get root():AnimationNode
        {
            return (this._root);
        }

        public function set root(_arg_1:AnimationNode):void
        {
            if (this._root != _arg_1)
            {
                if (this._root != null)
                {
                    this._root.setController(null);
                    this._root._isActive = false;
                };
                if (_arg_1 != null)
                {
                    _arg_1.setController(this);
                    _arg_1._isActive = true;
                };
                this._root = _arg_1;
            };
        }

        public function update():void
        {
            var _local_1:Number;
            var _local_2:AnimationState;
            var _local_3:int;
            var _local_4:int;
            var _local_6:int;
            var _local_7:Object3D;
            if (this.lastTime < 0)
            {
                this.lastTime = getTimer();
                _local_1 = 0;
            } else
            {
                _local_6 = getTimer();
                _local_1 = (0.001 * (_local_6 - this.lastTime));
                this.lastTime = _local_6;
            };
            if (this._root == null)
            {
                return;
            };
            for each (_local_2 in this.states)
            {
                _local_2.reset();
            };
            this._root.update(_local_1, 1);
            _local_3 = 0;
            _local_4 = this._object3ds.length;
            while (_local_3 < _local_4)
            {
                _local_7 = this._object3ds[_local_3];
                _local_2 = this.states[_local_7.name];
                if (_local_2 != null)
                {
                    _local_2.apply(_local_7);
                };
                _local_3++;
            };
            var _local_5:AnimationNotify = this.nearestNotifyers;
            while (_local_5 != null)
            {
                if (_local_5.willTrigger(NotifyEvent.NOTIFY))
                {
                    _local_5.dispatchEvent(new NotifyEvent(_local_5));
                };
                _local_5 = _local_5.processNext;
            };
            this.nearestNotifyers = null;
        }

        alternativa3d function addObject(_arg_1:Object):void
        {
            if ((_arg_1 in this.objectsUsedCount))
            {
                this.objectsUsedCount[_arg_1]++;
            } else
            {
                if ((_arg_1 is Object3D))
                {
                    this._object3ds.push(_arg_1);
                } else
                {
                    this._objects.push(_arg_1);
                };
                this.objectsUsedCount[_arg_1] = 1;
            };
        }

        alternativa3d function removeObject(_arg_1:Object):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_2:int = this.objectsUsedCount[_arg_1];
            _local_2--;
            if (_local_2 <= 0)
            {
                if ((_arg_1 is Object3D))
                {
                    _local_3 = this._object3ds.indexOf(_arg_1);
                    _local_5 = (this._object3ds.length - 1);
                    _local_4 = (_local_3 + 1);
                    while (_local_3 < _local_5)
                    {
                        this._object3ds[_local_3] = this._object3ds[_local_4];
                        _local_3++;
                        _local_4++;
                    };
                    this._object3ds.length = _local_5;
                } else
                {
                    _local_3 = this._objects.indexOf(_arg_1);
                    _local_5 = (this._objects.length - 1);
                    _local_4 = (_local_3 + 1);
                    while (_local_3 < _local_5)
                    {
                        this._objects[_local_3] = this._objects[_local_4];
                        _local_3++;
                        _local_4++;
                    };
                    this._objects.length = _local_5;
                };
                delete this.objectsUsedCount[_arg_1];
            } else
            {
                this.objectsUsedCount[_arg_1] = _local_2;
            };
        }

        alternativa3d function getState(_arg_1:String):AnimationState
        {
            var _local_2:AnimationState = this.states[_arg_1];
            if (_local_2 == null)
            {
                _local_2 = new AnimationState();
                this.states[_arg_1] = _local_2;
            };
            return (_local_2);
        }

        public function freeze():void
        {
            this.lastTime = -1;
        }


    }
}//package alternativa.engine3d.animation