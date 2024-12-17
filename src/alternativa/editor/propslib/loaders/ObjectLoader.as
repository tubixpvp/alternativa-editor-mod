package alternativa.editor.propslib.loaders
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.LoaderContext;
   
   public class ObjectLoader extends EventDispatcher
   {
      public function ObjectLoader()
      {
         super();
      }
      
      public function load(param1:LoaderContext) : void
      {
      }
      
      public function complete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onErrorEvent(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
      }
   }
}

