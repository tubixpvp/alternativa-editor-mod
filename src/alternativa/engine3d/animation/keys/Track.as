package alternativa.engine3d.animation.keys
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.animation.AnimationState;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Track 
    {

        public var object:String;
        alternativa3d var _length:Number = 0;


        public function get length():Number
        {
            return (this._length);
        }

        alternativa3d function get keyFramesList():Keyframe
        {
            return (null);
        }

        alternativa3d function set keyFramesList(_arg_1:Keyframe):void
        {
        }

        alternativa3d function addKeyToList(_arg_1:Keyframe):void
        {
            var _local_3:Keyframe;
            var _local_2:Number = _arg_1._time;
            if (this.keyFramesList == null)
            {
                this.keyFramesList = _arg_1;
                this._length = ((_local_2 <= 0) ? 0 : _local_2);
                return;
            };
            if (this.keyFramesList._time > _local_2)
            {
                _arg_1.nextKeyFrame = this.keyFramesList;
                this.keyFramesList = _arg_1;
                return;
            };
            _local_3 = this.keyFramesList;
            while (((!(_local_3.nextKeyFrame == null)) && (_local_3.nextKeyFrame._time <= _local_2)))
            {
                _local_3 = _local_3.nextKeyFrame;
            };
            if (_local_3.nextKeyFrame == null)
            {
                _local_3.nextKeyFrame = _arg_1;
                this._length = ((_local_2 <= 0) ? 0 : _local_2);
            } else
            {
                _arg_1.nextKeyFrame = _local_3.nextKeyFrame;
                _local_3.nextKeyFrame = _arg_1;
            };
        }

        public function removeKey(_arg_1:Keyframe):Keyframe
        {
            var _local_2:Keyframe;
            if (this.keyFramesList != null)
            {
                if (this.keyFramesList == _arg_1)
                {
                    this.keyFramesList = this.keyFramesList.nextKeyFrame;
                    if (this.keyFramesList == null)
                    {
                        this._length = 0;
                    };
                    return (_arg_1);
                };
                _local_2 = this.keyFramesList;
                while (((!(_local_2.nextKeyFrame == null)) && (!(_local_2.nextKeyFrame == _arg_1))))
                {
                    _local_2 = _local_2.nextKeyFrame;
                };
                if (_local_2.nextKeyFrame == _arg_1)
                {
                    if (_arg_1.nextKeyFrame == null)
                    {
                        this._length = ((_local_2._time <= 0) ? 0 : _local_2._time);
                    };
                    _local_2.nextKeyFrame = _arg_1.nextKeyFrame;
                    return (_arg_1);
                };
            };
            throw (new Error("Key not found"));
        }

        public function get keys():Vector.<Keyframe>
        {
            var _local_1:Vector.<Keyframe> = new Vector.<Keyframe>();
            var _local_2:int;
            var _local_3:Keyframe = this.keyFramesList;
            while (_local_3 != null)
            {
                _local_1[_local_2] = _local_3;
                _local_2++;
                _local_3 = _local_3.nextKeyFrame;
            };
            return (_local_1);
        }

        alternativa3d function blend(_arg_1:Number, _arg_2:Number, _arg_3:AnimationState):void
        {
        }

        public function slice(_arg_1:Number, _arg_2:Number=1.79769313486232E308):Track
        {
            return (null);
        }

        alternativa3d function createKeyFrame():Keyframe
        {
            return (null);
        }

        alternativa3d function interpolateKeyFrame(_arg_1:Keyframe, _arg_2:Keyframe, _arg_3:Keyframe, _arg_4:Number):void
        {
        }

        alternativa3d function sliceImplementation(_arg_1:Track, _arg_2:Number, _arg_3:Number):void
        {
            var _local_5:Keyframe;
            var _local_8:Keyframe;
            var _local_4:Number = ((_arg_2 > 0) ? _arg_2 : 0);
            var _local_6:Keyframe = this.keyFramesList;
            var _local_7:Keyframe = this.createKeyFrame();
            while (((!(_local_6 == null)) && (_local_6._time <= _arg_2)))
            {
                _local_5 = _local_6;
                _local_6 = _local_6.nextKeyFrame;
            };
            if (_local_5 != null)
            {
                if (_local_6 != null)
                {
                    this.interpolateKeyFrame(_local_7, _local_5, _local_6, ((_arg_2 - _local_5._time) / (_local_6._time - _local_5._time)));
                    _local_7._time = (_arg_2 - _local_4);
                } else
                {
                    this.interpolateKeyFrame(_local_7, _local_7, _local_5, 1);
                };
            } else
            {
                if (_local_6 != null)
                {
                    this.interpolateKeyFrame(_local_7, _local_7, _local_6, 1);
                    _local_7._time = (_local_6._time - _local_4);
                    _local_5 = _local_6;
                    _local_6 = _local_6.nextKeyFrame;
                } else
                {
                    return;
                };
            };
            _arg_1.keyFramesList = _local_7;
            if (((_local_6 == null) || (_arg_3 <= _arg_2)))
            {
                _arg_1._length = ((_local_7._time <= 0) ? 0 : _local_7._time);
                return;
            };
            while (((!(_local_6 == null)) && (_local_6._time <= _arg_3)))
            {
                _local_8 = this.createKeyFrame();
                this.interpolateKeyFrame(_local_8, _local_8, _local_6, 1);
                _local_8._time = (_local_6._time - _local_4);
                _local_7.nextKeyFrame = _local_8;
                _local_7 = _local_8;
                _local_5 = _local_6;
                _local_6 = _local_6.nextKeyFrame;
            };
            if (_local_6 != null)
            {
                _local_8 = this.createKeyFrame();
                this.interpolateKeyFrame(_local_8, _local_5, _local_6, ((_arg_3 - _local_5._time) / (_local_6._time - _local_5._time)));
                _local_8._time = (_arg_3 - _local_4);
                _local_7.nextKeyFrame = _local_8;
            };
            if (_local_8 != null)
            {
                _arg_1._length = ((_local_8._time <= 0) ? 0 : _local_8._time);
            };
        }


    }
}//package alternativa.engine3d.animation.keys