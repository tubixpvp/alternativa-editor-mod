package alternativa.engine3d.animation.keys
{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class NumberKey extends Keyframe 
    {

        alternativa3d var _value:Number = 0;
        alternativa3d var next:NumberKey;


        public function interpolate(_arg_1:NumberKey, _arg_2:NumberKey, _arg_3:Number):void
        {
            this._value = (((1 - _arg_3) * _arg_1._value) + (_arg_3 * _arg_2._value));
        }

        override public function get value():Object
        {
            return (this._value);
        }

        override public function set value(_arg_1:Object):void
        {
            this._value = Number(_arg_1);
        }

        override alternativa3d function get nextKeyFrame():Keyframe
        {
            return (this.next);
        }

        override alternativa3d function set nextKeyFrame(_arg_1:Keyframe):void
        {
            this.next = NumberKey(_arg_1);
        }


    }
}//package alternativa.engine3d.animation.keys