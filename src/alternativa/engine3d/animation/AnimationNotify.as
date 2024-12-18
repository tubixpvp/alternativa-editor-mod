package alternativa.engine3d.animation
{
    import flash.events.EventDispatcher;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationNotify extends EventDispatcher 
    {

        public var name:String;
        alternativa3d var _time:Number = 0;
        alternativa3d var next:AnimationNotify;
        alternativa3d var updateTime:Number;
        alternativa3d var processNext:AnimationNotify;

        public function AnimationNotify(_arg_1:String)
        {
            this.name = _arg_1;
        }

        public function get time():Number
        {
            return (this._time);
        }


    }
}//package alternativa.engine3d.animation