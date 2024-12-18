package alternativa.engine3d.animation.keys
{
    import flash.geom.Vector3D;
    import flash.geom.Orientation3D;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix3D;
    import alternativa.engine3d.animation.AnimationState;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class TransformTrack extends Track 
    {

        private static var tempQuat:Vector3D = new Vector3D();
        private static var temp:TransformKey = new TransformKey();

        private var keyList:TransformKey;

        public function TransformTrack(_arg_1:String)
        {
            this.object = _arg_1;
        }

        override alternativa3d function get keyFramesList():Keyframe
        {
            return (this.keyList);
        }

        override alternativa3d function set keyFramesList(_arg_1:Keyframe):void
        {
            this.keyList = TransformKey(_arg_1);
        }

        public function addKey(_arg_1:Number, _arg_2:Matrix3D):TransformKey
        {
            var _local_3:TransformKey;
            _local_3 = new TransformKey();
            _local_3._time = _arg_1;
            var _local_4:Vector.<Vector3D> = _arg_2.decompose(Orientation3D.QUATERNION);
            _local_3.x = _local_4[0].x;
            _local_3.y = _local_4[0].y;
            _local_3.z = _local_4[0].z;
            _local_3.rotation = _local_4[1];
            _local_3.scaleX = _local_4[2].x;
            _local_3.scaleY = _local_4[2].y;
            _local_3.scaleZ = _local_4[2].z;
            addKeyToList(_local_3);
            return (_local_3);
        }

        public function addKeyComponents(_arg_1:Number, _arg_2:Number=0, _arg_3:Number=0, _arg_4:Number=0, _arg_5:Number=0, _arg_6:Number=0, _arg_7:Number=0, _arg_8:Number=1, _arg_9:Number=1, _arg_10:Number=1):TransformKey
        {
            var _local_11:TransformKey = new TransformKey();
            _local_11._time = _arg_1;
            _local_11.x = _arg_2;
            _local_11.y = _arg_3;
            _local_11.z = _arg_4;
            _local_11.rotation = this.createQuatFromEuler(_arg_5, _arg_6, _arg_7);
            _local_11.scaleX = _arg_8;
            _local_11.scaleY = _arg_9;
            _local_11.scaleZ = _arg_10;
            addKeyToList(_local_11);
            return (_local_11);
        }

        private function appendQuat(_arg_1:Vector3D, _arg_2:Vector3D):void
        {
            var _local_3:Number = ((((_arg_2.w * _arg_1.w) - (_arg_2.x * _arg_1.x)) - (_arg_2.y * _arg_1.y)) - (_arg_2.z * _arg_1.z));
            var _local_4:Number = ((((_arg_2.w * _arg_1.x) + (_arg_2.x * _arg_1.w)) + (_arg_2.y * _arg_1.z)) - (_arg_2.z * _arg_1.y));
            var _local_5:Number = ((((_arg_2.w * _arg_1.y) + (_arg_2.y * _arg_1.w)) + (_arg_2.z * _arg_1.x)) - (_arg_2.x * _arg_1.z));
            var _local_6:Number = ((((_arg_2.w * _arg_1.z) + (_arg_2.z * _arg_1.w)) + (_arg_2.x * _arg_1.y)) - (_arg_2.y * _arg_1.x));
            _arg_1.w = _local_3;
            _arg_1.x = _local_4;
            _arg_1.y = _local_5;
            _arg_1.z = _local_6;
        }

        private function normalizeQuat(_arg_1:Vector3D):void
        {
            var _local_2:Number = ((((_arg_1.w * _arg_1.w) + (_arg_1.x * _arg_1.x)) + (_arg_1.y * _arg_1.y)) + (_arg_1.z * _arg_1.z));
            if (_local_2 == 0)
            {
                _arg_1.w = 1;
            } else
            {
                _local_2 = (1 / Math.sqrt(_local_2));
                _arg_1.w = (_arg_1.w * _local_2);
                _arg_1.x = (_arg_1.x * _local_2);
                _arg_1.y = (_arg_1.y * _local_2);
                _arg_1.z = (_arg_1.z * _local_2);
            };
        }

        private function setQuatFromAxisAngle(_arg_1:Vector3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):void
        {
            _arg_1.w = Math.cos((0.5 * _arg_5));
            var _local_6:Number = (Math.sin((0.5 * _arg_5)) / Math.sqrt((((_arg_2 * _arg_2) + (_arg_3 * _arg_3)) + (_arg_4 * _arg_4))));
            _arg_1.x = (_arg_2 * _local_6);
            _arg_1.y = (_arg_3 * _local_6);
            _arg_1.z = (_arg_4 * _local_6);
        }

        private function createQuatFromEuler(_arg_1:Number, _arg_2:Number, _arg_3:Number):Vector3D
        {
            var _local_4:Vector3D = new Vector3D();
            this.setQuatFromAxisAngle(_local_4, 1, 0, 0, _arg_1);
            this.setQuatFromAxisAngle(tempQuat, 0, 1, 0, _arg_2);
            this.appendQuat(_local_4, tempQuat);
            this.normalizeQuat(_local_4);
            this.setQuatFromAxisAngle(tempQuat, 0, 0, 1, _arg_3);
            this.appendQuat(_local_4, tempQuat);
            this.normalizeQuat(_local_4);
            return (_local_4);
        }

        override alternativa3d function blend(_arg_1:Number, _arg_2:Number, _arg_3:AnimationState):void
        {
            var _local_4:TransformKey;
            var _local_5:TransformKey = this.keyList;
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
                    _arg_3.addWeightedTransform(temp, _arg_2);
                } else
                {
                    _arg_3.addWeightedTransform(_local_4, _arg_2);
                };
            } else
            {
                if (_local_5 != null)
                {
                    _arg_3.addWeightedTransform(_local_5, _arg_2);
                };
            };
        }

        override alternativa3d function createKeyFrame():Keyframe
        {
            return (new TransformKey());
        }

        override alternativa3d function interpolateKeyFrame(_arg_1:Keyframe, _arg_2:Keyframe, _arg_3:Keyframe, _arg_4:Number):void
        {
            TransformKey(_arg_1).interpolate(TransformKey(_arg_2), TransformKey(_arg_3), _arg_4);
        }

        override public function slice(_arg_1:Number, _arg_2:Number=1.79769313486232E308):Track
        {
            var _local_3:TransformTrack = new TransformTrack(object);
            sliceImplementation(_local_3, _arg_1, _arg_2);
            return (_local_3);
        }


    }
}//package alternativa.engine3d.animation.keys