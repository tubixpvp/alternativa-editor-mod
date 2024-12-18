package alternativa.engine3d.animation.keys
{
    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import flash.geom.Orientation3D;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class TransformKey extends Keyframe 
    {

        alternativa3d var x:Number = 0;
        alternativa3d var y:Number = 0;
        alternativa3d var z:Number = 0;
        alternativa3d var rotation:Vector3D = new Vector3D(0, 0, 0, 1);
        alternativa3d var scaleX:Number = 1;
        alternativa3d var scaleY:Number = 1;
        alternativa3d var scaleZ:Number = 1;
        alternativa3d var next:TransformKey;


        override public function get value():Object
        {
            var _local_1:Matrix3D = new Matrix3D();
            _local_1.recompose(Vector.<Vector3D>([new Vector3D(this.x, this.y, this.z), this.rotation, new Vector3D(this.scaleX, this.scaleY, this.scaleZ)]), Orientation3D.QUATERNION);
            return (_local_1);
        }

        override public function set value(_arg_1:Object):void
        {
            var _local_2:Matrix3D = Matrix3D(_arg_1);
            var _local_3:Vector.<Vector3D> = _local_2.decompose(Orientation3D.QUATERNION);
            this.x = _local_3[0].x;
            this.y = _local_3[0].y;
            this.z = _local_3[0].z;
            this.rotation = _local_3[1];
            this.scaleX = _local_3[2].x;
            this.scaleY = _local_3[2].y;
            this.scaleZ = _local_3[2].z;
        }

        public function interpolate(_arg_1:TransformKey, _arg_2:TransformKey, _arg_3:Number):void
        {
            var _local_4:Number = (1 - _arg_3);
            this.x = ((_local_4 * _arg_1.x) + (_arg_3 * _arg_2.x));
            this.y = ((_local_4 * _arg_1.y) + (_arg_3 * _arg_2.y));
            this.z = ((_local_4 * _arg_1.z) + (_arg_3 * _arg_2.z));
            this.slerp(_arg_1.rotation, _arg_2.rotation, _arg_3, this.rotation);
            this.scaleX = ((_local_4 * _arg_1.scaleX) + (_arg_3 * _arg_2.scaleX));
            this.scaleY = ((_local_4 * _arg_1.scaleY) + (_arg_3 * _arg_2.scaleY));
            this.scaleZ = ((_local_4 * _arg_1.scaleZ) + (_arg_3 * _arg_2.scaleZ));
        }

        private function slerp(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Number, _arg_4:Vector3D):void
        {
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_5:Number = 1;
            var _local_6:Number = ((((_arg_1.w * _arg_2.w) + (_arg_1.x * _arg_2.x)) + (_arg_1.y * _arg_2.y)) + (_arg_1.z * _arg_2.z));
            if (_local_6 < 0)
            {
                _local_6 = -(_local_6);
                _local_5 = -1;
            };
            if ((1 - _local_6) < 0.001)
            {
                _local_7 = (1 - _arg_3);
                _local_8 = (_arg_3 * _local_5);
                _arg_4.w = ((_arg_1.w * _local_7) + (_arg_2.w * _local_8));
                _arg_4.x = ((_arg_1.x * _local_7) + (_arg_2.x * _local_8));
                _arg_4.y = ((_arg_1.y * _local_7) + (_arg_2.y * _local_8));
                _arg_4.z = ((_arg_1.z * _local_7) + (_arg_2.z * _local_8));
                _local_9 = ((((_arg_4.w * _arg_4.w) + (_arg_4.x * _arg_4.x)) + (_arg_4.y * _arg_4.y)) + (_arg_4.z * _arg_4.z));
                if (_local_9 == 0)
                {
                    _arg_4.w = 1;
                } else
                {
                    _arg_4.scaleBy((1 / Math.sqrt(_local_9)));
                };
            } else
            {
                _local_10 = Math.acos(_local_6);
                _local_11 = Math.sin(_local_10);
                _local_12 = (Math.sin(((1 - _arg_3) * _local_10)) / _local_11);
                _local_13 = ((Math.sin((_arg_3 * _local_10)) / _local_11) * _local_5);
                _arg_4.w = ((_arg_1.w * _local_12) + (_arg_2.w * _local_13));
                _arg_4.x = ((_arg_1.x * _local_12) + (_arg_2.x * _local_13));
                _arg_4.y = ((_arg_1.y * _local_12) + (_arg_2.y * _local_13));
                _arg_4.z = ((_arg_1.z * _local_12) + (_arg_2.z * _local_13));
            };
        }

        override alternativa3d function get nextKeyFrame():Keyframe
        {
            return (this.next);
        }

        override alternativa3d function set nextKeyFrame(_arg_1:Keyframe):void
        {
            this.next = TransformKey(_arg_1);
        }


    }
}//package alternativa.engine3d.animation.keys