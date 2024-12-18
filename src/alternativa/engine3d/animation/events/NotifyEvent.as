package alternativa.engine3d.animation.events
{
    import flash.events.Event;
    import alternativa.engine3d.animation.AnimationNotify;

    public class NotifyEvent extends Event 
    {

        public static const NOTIFY:String = "notify";

        public function NotifyEvent(_arg_1:AnimationNotify)
        {
            super(NOTIFY);
        }

        public function get notify():AnimationNotify
        {
            return (AnimationNotify(target));
        }


    }
}//package alternativa.engine3d.animation.events