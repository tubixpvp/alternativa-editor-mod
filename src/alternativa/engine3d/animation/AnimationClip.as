package alternativa.engine3d.animation
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.animation.keys.Track;
    import alternativa.engine3d.objects.Joint;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.objects.Skin;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationClip extends AnimationNode 
    {

        alternativa3d var _objects:Array;
        public var name:String;
        public var loop:Boolean = true;
        public var length:Number = 0;
        public var animated:Boolean = true;
        private var _time:Number = 0;
        private var _numTracks:int = 0;
        private var _tracks:Vector.<Track> = new Vector.<Track>();
        private var _notifiersList:AnimationNotify;

        public function AnimationClip(_arg_1:String=null)
        {
            this.name = _arg_1;
        }

        public function get objects():Array
        {
            return ((this._objects == null) ? null : [].concat(this._objects));
        }

        public function set objects(_arg_1:Array):void
        {
            this.updateObjects(this._objects, controller, _arg_1, controller);
            this._objects = ((_arg_1 == null) ? null : [].concat(_arg_1));
        }

        override alternativa3d function setController(_arg_1:AnimationController):void
        {
            this.updateObjects(this._objects, controller, this._objects, _arg_1);
            this.controller = _arg_1;
        }

        private function addObject(_arg_1:Object):void
        {
            if (this._objects == null)
            {
                this._objects = [_arg_1];
            } else
            {
                this._objects.push(_arg_1);
            };
            if (controller != null)
            {
                controller.addObject(_arg_1);
            };
        }

        private function updateObjects(_arg_1:Array, _arg_2:AnimationController, _arg_3:Array, _arg_4:AnimationController):void
        {
            var _local_5:int;
            var _local_6:int;
            if (((!(_arg_2 == null)) && (!(_arg_1 == null))))
            {
                _local_5 = 0;
                _local_6 = this._objects.length;
                while (_local_5 < _local_6)
                {
                    _arg_2.removeObject(_arg_1[_local_5]);
                    _local_5++;
                };
            };
            if (((!(_arg_4 == null)) && (!(_arg_3 == null))))
            {
                _local_5 = 0;
                _local_6 = _arg_3.length;
                while (_local_5 < _local_6)
                {
                    _arg_4.addObject(_arg_3[_local_5]);
                    _local_5++;
                };
            };
        }

        public function updateLength():void
        {
            var _local_2:Track;
            var _local_3:Number;
            var _local_1:int;
            while (_local_1 < this._numTracks)
            {
                _local_2 = this._tracks[_local_1];
                _local_3 = _local_2.length;
                if (_local_3 > this.length)
                {
                    this.length = _local_3;
                };
                _local_1++;
            };
        }

        public function addTrack(_arg_1:Track):Track
        {
            if (_arg_1 == null)
            {
                throw (new Error("Track can not be null"));
            };
            var _local_2:* = this._numTracks++;
            this._tracks[_local_2] = _arg_1;
            if (_arg_1.length > this.length)
            {
                this.length = _arg_1.length;
            };
            return (_arg_1);
        }

        public function removeTrack(_arg_1:Track):Track
        {
            var _local_5:Track;
            var _local_2:int = this._tracks.indexOf(_arg_1);
            if (_local_2 < 0)
            {
                throw (new ArgumentError("Track not found"));
            };
            this._numTracks--;
            var _local_3:int = (_local_2 + 1);
            while (_local_2 < this._numTracks)
            {
                this._tracks[_local_2] = this._tracks[_local_3];
                _local_2++;
                _local_3++;
            };
            this._tracks.length = this._numTracks;
            this.length = 0;
            var _local_4:int;
            while (_local_4 < this._numTracks)
            {
                _local_5 = this._tracks[_local_4];
                if (_local_5.length > this.length)
                {
                    this.length = _local_5.length;
                };
                _local_4++;
            };
            return (_arg_1);
        }

        public function getTrackAt(_arg_1:int):Track
        {
            return (this._tracks[_arg_1]);
        }

        public function get numTracks():int
        {
            return (this._numTracks);
        }

        override alternativa3d function update(_arg_1:Number, _arg_2:Number):void
        {
            var _local_4:int;
            var _local_5:Track;
            var _local_6:AnimationState;
            var _local_3:Number = this._time;
            if (this.animated)
            {
                this._time = (this._time + (_arg_1 * speed));
                if (this.loop)
                {
                    if (this._time < 0)
                    {
                        this._time = 0;
                    } else
                    {
                        if (this._time >= this.length)
                        {
                            this.collectNotifiers(_local_3, this.length);
                            this._time = ((this.length <= 0) ? 0 : (this._time % this.length));
                            this.collectNotifiers(0, this._time);
                        } else
                        {
                            this.collectNotifiers(_local_3, this._time);
                        };
                    };
                } else
                {
                    if (this._time < 0)
                    {
                        this._time = 0;
                    } else
                    {
                        if (this._time >= this.length)
                        {
                            this._time = this.length;
                        };
                    };
                    this.collectNotifiers(_local_3, this._time);
                };
            };
            if (_arg_2 > 0)
            {
                _local_4 = 0;
                while (_local_4 < this._numTracks)
                {
                    _local_5 = this._tracks[_local_4];
                    if (_local_5.object != null)
                    {
                        _local_6 = controller.getState(_local_5.object);
                        if (_local_6 != null)
                        {
                            _local_5.blend(this._time, _arg_2, _local_6);
                        };
                    };
                    _local_4++;
                };
            };
        }

        public function get time():Number
        {
            return (this._time);
        }

        public function set time(_arg_1:Number):void
        {
            this._time = _arg_1;
        }

        public function get normalizedTime():Number
        {
            return ((this.length == 0) ? 0 : (this._time / this.length));
        }

        public function set normalizedTime(_arg_1:Number):void
        {
            this._time = (_arg_1 * this.length);
        }

        private function getNumChildren(_arg_1:Object):int
        {
            if ((_arg_1 is Joint))
            {
                return (Joint(_arg_1).numChildren);
            };
            if ((_arg_1 is Object3DContainer))
            {
                return (Object3DContainer(_arg_1).numChildren);
            };
            if ((_arg_1 is Skin))
            {
                return (Skin(_arg_1).numJoints);
            };
            return (0);
        }

        private function getChildAt(_arg_1:Object, _arg_2:int):Object
        {
            if ((_arg_1 is Joint))
            {
                return (Joint(_arg_1).getChildAt(_arg_2));
            };
            if ((_arg_1 is Object3DContainer))
            {
                return (Object3DContainer(_arg_1).getChildAt(_arg_2));
            };
            if ((_arg_1 is Skin))
            {
                return (Skin(_arg_1).getJointAt(_arg_2));
            };
            return (null);
        }

        private function addChildren(_arg_1:Object):void
        {
            var _local_4:Object;
            var _local_2:int;
            var _local_3:int = this.getNumChildren(_arg_1);
            while (_local_2 < _local_3)
            {
                _local_4 = this.getChildAt(_arg_1, _local_2);
                this.addObject(_local_4);
                this.addChildren(_local_4);
                _local_2++;
            };
        }

        public function attach(_arg_1:Object, _arg_2:Boolean):void
        {
            this.updateObjects(this._objects, controller, null, controller);
            this._objects = null;
            this.addObject(_arg_1);
            if (_arg_2)
            {
                this.addChildren(_arg_1);
            };
        }

        alternativa3d function collectNotifiers(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:AnimationNotify = this._notifiersList;
            while (_local_3 != null)
            {
                if (_local_3._time > _arg_1)
                {
                    if (_local_3._time > _arg_2)
                    {
                        return;
                    };
                    _local_3.processNext = controller.nearestNotifyers;
                    controller.nearestNotifyers = _local_3;
                };
                _local_3 = _local_3.next;
            };
        }

        public function addNotify(_arg_1:Number, _arg_2:String=null):AnimationNotify
        {
            var _local_4:AnimationNotify;
            _arg_1 = ((_arg_1 <= 0) ? 0 : ((_arg_1 >= this.length) ? this.length : _arg_1));
            var _local_3:AnimationNotify = new AnimationNotify(_arg_2);
            _local_3._time = _arg_1;
            if (this._notifiersList == null)
            {
                this._notifiersList = _local_3;
                return (_local_3);
            };
            if (this._notifiersList._time > _arg_1)
            {
                _local_3.next = this._notifiersList;
                this._notifiersList = _local_3;
                return (_local_3);
            };
            _local_4 = this._notifiersList;
            while (((!(_local_4.next == null)) && (_local_4.next._time <= _arg_1)))
            {
                _local_4 = _local_4.next;
            };
            if (_local_4.next == null)
            {
                _local_4.next = _local_3;
            } else
            {
                _local_3.next = _local_4.next;
                _local_4.next = _local_3;
            };
            return (_local_3);
        }

        public function addNotifyAtEnd(_arg_1:Number=0, _arg_2:String=null):AnimationNotify
        {
            return (this.addNotify((this.length - _arg_1), _arg_2));
        }

        public function removeNotify(_arg_1:AnimationNotify):AnimationNotify
        {
            var _local_2:AnimationNotify;
            if (this._notifiersList != null)
            {
                if (this._notifiersList == _arg_1)
                {
                    this._notifiersList = this._notifiersList.next;
                    return (_arg_1);
                };
                _local_2 = this._notifiersList;
                while (((!(_local_2.next == null)) && (!(_local_2.next == _arg_1))))
                {
                    _local_2 = _local_2.next;
                };
                if (_local_2.next == _arg_1)
                {
                    _local_2.next = _arg_1.next;
                    return (_arg_1);
                };
            };
            throw (new Error("Notify not found"));
        }

        public function get notifiers():Vector.<AnimationNotify>
        {
            var _local_1:Vector.<AnimationNotify> = new Vector.<AnimationNotify>();
            var _local_2:int;
            var _local_3:AnimationNotify = this._notifiersList;
            while (_local_3 != null)
            {
                _local_1[_local_2] = _local_3;
                _local_2++;
                _local_3 = _local_3.next;
            };
            return (_local_1);
        }

        public function slice(_arg_1:Number, _arg_2:Number=1.79769313486232E308):AnimationClip
        {
            var _local_3:AnimationClip = new AnimationClip(this.name);
            _local_3._objects = ((this._objects == null) ? null : [].concat(this._objects));
            var _local_4:int;
            while (_local_4 < this._numTracks)
            {
                _local_3.addTrack(this._tracks[_local_4].slice(_arg_1, _arg_2));
                _local_4++;
            };
            return (_local_3);
        }

        public function clone():AnimationClip
        {
            var _local_1:AnimationClip = new AnimationClip(this.name);
            _local_1._objects = ((this._objects == null) ? null : [].concat(this._objects));
            var _local_2:int;
            while (_local_2 < this._numTracks)
            {
                _local_1.addTrack(this._tracks[_local_2]);
                _local_2++;
            };
            _local_1.length = this.length;
            return (_local_1);
        }


    }
}//package alternativa.engine3d.animation