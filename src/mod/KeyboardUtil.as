package mod
{
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    public class KeyboardUtil
    {
        public static function stopEventPropagation(event:KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                case Keyboard.ENTER:
                case Keyboard.ESCAPE:
                case Keyboard.TAB:
                    return;
                default:
                    event.stopPropagation();
                    return;
            }
        }
    }
}