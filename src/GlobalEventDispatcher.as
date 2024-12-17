package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class GlobalEventDispatcher
   {
      private static var eventDispatcher:EventDispatcher = new EventDispatcher();
      
      public function GlobalEventDispatcher()
      {
         super();
      }
      
      public static function addListener(param1:String, param2:Function) : void
      {
         eventDispatcher.addEventListener(param1,param2);
      }
      
      public static function removeListener(param1:String, param2:Function) : void
      {
         eventDispatcher.removeEventListener(param1,param2);
      }
      
      public static function dispatch(param1:Event) : void
      {
         eventDispatcher.dispatchEvent(param1);
      }
   }
}

