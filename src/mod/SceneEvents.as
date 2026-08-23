package mod
{
    import flash.utils.Dictionary;
    import alternativa.editor.prop.Prop;

    public class SceneEvents
    {
        public static const PROP_POSITION_CHANGED:String = "prop-position-changed";

        public static var listeningProp:Prop = null;

        private static const _listeners:Dictionary = new Dictionary();


        public static function addListener(type:String, func:Function) : void
        {
            var listeners:Vector.<Function> = _listeners[type];
            if (listeners == null)
            {
                listeners = _listeners[type] = new Vector.<Function>();
            }
            listeners.push(func);
        }

        public static function invoke(type:String, prop:Prop) : void
        {
            if (prop != listeningProp)
                return;
            var listeners:Vector.<Function> = _listeners[type];
            for each(var func:Function in listeners)
            {
                func(prop);
            }
        }

    }
}