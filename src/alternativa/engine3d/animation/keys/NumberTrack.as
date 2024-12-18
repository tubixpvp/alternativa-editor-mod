package alternativa.engine3d.animation.keys
{
    import alternativa.engine3d.animation.AnimationState;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class NumberTrack extends Track 
    {

        private static var temp:NumberKey = new NumberKey();

        alternativa3d var keyList:NumberKey;
        public var property:String;

        public function NumberTrack(_arg_1:String, _arg_2:String)
        {
            this.property = _arg_2;
            this.object = _arg_1;
        }

        override alternativa3d function get keyFramesList():Keyframe
        {
            return (this.keyList);
        }

        override alternativa3d function set keyFramesList(_arg_1:Keyframe):void
        {
            this.keyList = NumberKey(_arg_1);
        }

        public function addKey(_arg_1:Number, _arg_2:Number=0):Keyframe
        {
            var _local_3:NumberKey = new NumberKey();
            _local_3._time = _arg_1;
            _local_3.value = _arg_2;
            addKeyToList(_local_3);
            return (_local_3);
        }

        override alternativa3d function blend(_arg_1:Number, _arg_2:Number, _arg_3:AnimationState):void
        {
            var _local_4:NumberKey;
            if (this.property == null)
            {
                return;
            };
            var _local_5:NumberKey = this.keyList;
            while (((!(_local_5 == null)) && (_local_5._time < _arg_1)))
            {
                _local_4 = _local_5;
                _local_5 = _local_5.next;
            };
            if (_local_4 != null)
            {
                if (_local_5 != null)
                {
                    temp.interpolate(_local_4, _local_5, ((_arg_1 - _local_4._time) / (_local_5._time - _local_4._time)));
                    _arg_3.addWeightedNumber(this.property, temp._value, _arg_2);
                } else
                {
                    _arg_3.addWeightedNumber(this.property, _local_4._value, _arg_2);
                };
            } else
            {
                if (_local_5 != null)
                {
                    _arg_3.addWeightedNumber(this.property, _local_5._value, _arg_2);
                };
            };
        }

        override alternativa3d function createKeyFrame():Keyframe
        {
            return (new NumberKey());
        }

        override alternativa3d function interpolateKeyFrame(_arg_1:Keyframe, _arg_2:Keyframe, _arg_3:Keyframe, _arg_4:Number):void
        {
            NumberKey(_arg_1).interpolate(NumberKey(_arg_2), NumberKey(_arg_3), _arg_4);
        }

        override public function slice(_arg_1:Number, _arg_2:Number=1.79769313486232E308):Track
        {
            var _local_3:NumberTrack = new NumberTrack(object, this.property);
            sliceImplementation(_local_3, _arg_1, _arg_2);
            return (_local_3);
        }


    }
}//package alternativa.engine3d.animation.keys