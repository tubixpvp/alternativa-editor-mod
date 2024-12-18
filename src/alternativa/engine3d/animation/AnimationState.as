package alternativa.engine3d.animation
{
    import alternativa.engine3d.animation.keys.TransformKey;
    import alternativa.engine3d.core.Object3D;
    import flash.geom.Vector3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationState 
    {

        public var useCount:int = 0;
        public var transform:TransformKey = new TransformKey();
        public var transformWeightSum:Number = 0;
        public var numbers:Object = new Object();
        public var numberWeightSums:Object = new Object();


        public function reset():void
        {
            var _local_1:String;
            this.transformWeightSum = 0;
            for (_local_1 in this.numbers)
            {
                delete this.numbers[_local_1];
                delete this.numberWeightSums[_local_1];
            };
        }

        public function addWeightedTransform(_arg_1:TransformKey, _arg_2:Number):void
        {
            this.transformWeightSum = (this.transformWeightSum + _arg_2);
            this.transform.interpolate(this.transform, _arg_1, (_arg_2 / this.transformWeightSum));
        }

        public function addWeightedNumber(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            var _local_5:Number;
            var _local_4:Number = this.numberWeightSums[_arg_1];
            if (_local_4 == _local_4)
            {
                _local_4 = (_local_4 + _arg_3);
                _arg_3 = (_arg_3 / _local_4);
                _local_5 = this.numbers[_arg_1];
                this.numbers[_arg_1] = (((1 - _arg_3) * _local_5) + (_arg_3 * _arg_2));
                this.numberWeightSums[_arg_1] = _local_4;
            } else
            {
                this.numbers[_arg_1] = _arg_2;
                this.numberWeightSums[_arg_1] = _arg_3;
            };
        }

        public function apply(_arg_1:Object3D):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:String;
            if (this.transformWeightSum > 0)
            {
                _arg_1.x = this.transform.x;
                _arg_1.y = this.transform.y;
                _arg_1.z = this.transform.z;
                this.setEulerAngles(this.transform.rotation, _arg_1);
                _arg_1.scaleX = this.transform.scaleX;
                _arg_1.scaleY = this.transform.scaleY;
                _arg_1.scaleZ = this.transform.scaleZ;
            };
            for (_local_4 in this.numbers)
            {
                switch (_local_4)
                {
                    case "x":
                        _local_2 = this.numberWeightSums["x"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.x = (((1 - _local_3) * _arg_1.x) + (_local_3 * this.numbers["x"]));
                        break;
                    case "y":
                        _local_2 = this.numberWeightSums["y"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.y = (((1 - _local_3) * _arg_1.y) + (_local_3 * this.numbers["y"]));
                        break;
                    case "z":
                        _local_2 = this.numberWeightSums["z"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.z = (((1 - _local_3) * _arg_1.z) + (_local_3 * this.numbers["z"]));
                        break;
                    case "rotationX":
                        _local_2 = this.numberWeightSums["rotationX"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationX = (((1 - _local_3) * _arg_1.rotationX) + (_local_3 * this.numbers["rotationX"]));
                        break;
                    case "rotationY":
                        _local_2 = this.numberWeightSums["rotationY"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationY = (((1 - _local_3) * _arg_1.rotationY) + (_local_3 * this.numbers["rotationY"]));
                        break;
                    case "rotationZ":
                        _local_2 = this.numberWeightSums["rotationZ"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationZ = (((1 - _local_3) * _arg_1.rotationZ) + (_local_3 * this.numbers["rotationZ"]));
                        break;
                    case "scaleX":
                        _local_2 = this.numberWeightSums["scaleX"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleX = (((1 - _local_3) * _arg_1.scaleX) + (_local_3 * this.numbers["scaleX"]));
                        break;
                    case "scaleY":
                        _local_2 = this.numberWeightSums["scaleY"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleY = (((1 - _local_3) * _arg_1.scaleY) + (_local_3 * this.numbers["scaleY"]));
                        break;
                    case "scaleZ":
                        _local_2 = this.numberWeightSums["scaleZ"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleZ = (((1 - _local_3) * _arg_1.scaleZ) + (_local_3 * this.numbers["scaleZ"]));
                        break;
                    default:
                        _arg_1[_local_4] = this.numbers[_local_4];
                };
            };
        }

        public function applyObject(_arg_1:Object):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:String;
            if (this.transformWeightSum > 0)
            {
                _arg_1.x = this.transform.x;
                _arg_1.y = this.transform.y;
                _arg_1.z = this.transform.z;
                this.setEulerAnglesObject(this.transform.rotation, _arg_1);
                _arg_1.scaleX = this.transform.scaleX;
                _arg_1.scaleY = this.transform.scaleY;
                _arg_1.scaleZ = this.transform.scaleZ;
            };
            for (_local_4 in this.numbers)
            {
                switch (_local_4)
                {
                    case "x":
                        _local_2 = this.numberWeightSums["x"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.x = (((1 - _local_3) * _arg_1.x) + (_local_3 * this.numbers["x"]));
                        break;
                    case "y":
                        _local_2 = this.numberWeightSums["y"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.y = (((1 - _local_3) * _arg_1.y) + (_local_3 * this.numbers["y"]));
                        break;
                    case "z":
                        _local_2 = this.numberWeightSums["z"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.z = (((1 - _local_3) * _arg_1.z) + (_local_3 * this.numbers["z"]));
                        break;
                    case "rotationX":
                        _local_2 = this.numberWeightSums["rotationX"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationX = (((1 - _local_3) * _arg_1.rotationX) + (_local_3 * this.numbers["rotationX"]));
                        break;
                    case "rotationY":
                        _local_2 = this.numberWeightSums["rotationY"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationY = (((1 - _local_3) * _arg_1.rotationY) + (_local_3 * this.numbers["rotationY"]));
                        break;
                    case "rotationZ":
                        _local_2 = this.numberWeightSums["rotationZ"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.rotationZ = (((1 - _local_3) * _arg_1.rotationZ) + (_local_3 * this.numbers["rotationZ"]));
                        break;
                    case "scaleX":
                        _local_2 = this.numberWeightSums["scaleX"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleX = (((1 - _local_3) * _arg_1.scaleX) + (_local_3 * this.numbers["scaleX"]));
                        break;
                    case "scaleY":
                        _local_2 = this.numberWeightSums["scaleY"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleY = (((1 - _local_3) * _arg_1.scaleY) + (_local_3 * this.numbers["scaleY"]));
                        break;
                    case "scaleZ":
                        _local_2 = this.numberWeightSums["scaleZ"];
                        _local_3 = (_local_2 / (_local_2 + this.transformWeightSum));
                        _arg_1.scaleZ = (((1 - _local_3) * _arg_1.scaleZ) + (_local_3 * this.numbers["scaleZ"]));
                        break;
                    default:
                        _arg_1[_local_4] = this.numbers[_local_4];
                };
            };
        }

        private function setEulerAngles(_arg_1:Vector3D, _arg_2:Object3D):void
        {
            var _local_3:Number = ((2 * _arg_1.x) * _arg_1.x);
            var _local_4:Number = ((2 * _arg_1.y) * _arg_1.y);
            var _local_5:Number = ((2 * _arg_1.z) * _arg_1.z);
            var _local_6:Number = ((2 * _arg_1.x) * _arg_1.y);
            var _local_7:Number = ((2 * _arg_1.y) * _arg_1.z);
            var _local_8:Number = ((2 * _arg_1.z) * _arg_1.x);
            var _local_9:Number = ((2 * _arg_1.w) * _arg_1.x);
            var _local_10:Number = ((2 * _arg_1.w) * _arg_1.y);
            var _local_11:Number = ((2 * _arg_1.w) * _arg_1.z);
            var _local_12:Number = ((1 - _local_4) - _local_5);
            var _local_13:Number = (_local_6 - _local_11);
            var _local_14:Number = (_local_6 + _local_11);
            var _local_15:Number = ((1 - _local_3) - _local_5);
            var _local_16:Number = (_local_8 - _local_10);
            var _local_17:Number = (_local_7 + _local_9);
            var _local_18:Number = ((1 - _local_3) - _local_4);
            if (((-1 < _local_16) && (_local_16 < 1)))
            {
                _arg_2.rotationX = Math.atan2(_local_17, _local_18);
                _arg_2.rotationY = -(Math.asin(_local_16));
                _arg_2.rotationZ = Math.atan2(_local_14, _local_12);
            } else
            {
                _arg_2.rotationX = 0;
                _arg_2.rotationY = ((_local_16 <= -1) ? Math.PI : -(Math.PI));
                _arg_2.rotationY = (_arg_2.rotationY * 0.5);
                _arg_2.rotationZ = Math.atan2(-(_local_13), _local_15);
            };
        }

        private function setEulerAnglesObject(_arg_1:Vector3D, _arg_2:Object):void
        {
            var _local_3:Number = ((2 * _arg_1.x) * _arg_1.x);
            var _local_4:Number = ((2 * _arg_1.y) * _arg_1.y);
            var _local_5:Number = ((2 * _arg_1.z) * _arg_1.z);
            var _local_6:Number = ((2 * _arg_1.x) * _arg_1.y);
            var _local_7:Number = ((2 * _arg_1.y) * _arg_1.z);
            var _local_8:Number = ((2 * _arg_1.z) * _arg_1.x);
            var _local_9:Number = ((2 * _arg_1.w) * _arg_1.x);
            var _local_10:Number = ((2 * _arg_1.w) * _arg_1.y);
            var _local_11:Number = ((2 * _arg_1.w) * _arg_1.z);
            var _local_12:Number = ((1 - _local_4) - _local_5);
            var _local_13:Number = (_local_6 - _local_11);
            var _local_14:Number = (_local_6 + _local_11);
            var _local_15:Number = ((1 - _local_3) - _local_5);
            var _local_16:Number = (_local_8 - _local_10);
            var _local_17:Number = (_local_7 + _local_9);
            var _local_18:Number = ((1 - _local_3) - _local_4);
            if (((-1 < _local_16) && (_local_16 < 1)))
            {
                _arg_2.rotationX = Math.atan2(_local_17, _local_18);
                _arg_2.rotationY = -(Math.asin(_local_16));
                _arg_2.rotationZ = Math.atan2(_local_14, _local_12);
            } else
            {
                _arg_2.rotationX = 0;
                _arg_2.rotationY = ((_local_16 <= -1) ? Math.PI : -(Math.PI));
                _arg_2.rotationY = (_arg_2.rotationY * 0.5);
                _arg_2.rotationZ = Math.atan2(-(_local_13), _local_15);
            };
        }


    }
}//package alternativa.engine3d.animation