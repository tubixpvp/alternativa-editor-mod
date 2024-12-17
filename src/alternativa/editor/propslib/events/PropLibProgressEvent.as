package alternativa.editor.propslib.events
{
   import flash.events.Event;
   
   public class PropLibProgressEvent extends Event
   {
      public static const PROGRESS:String = "progress";
      
      public var propsLoaded:int;
      
      public var propsTotal:int;
      
      public function PropLibProgressEvent(param1:int, param2:int)
      {
         super(PROGRESS);
         this.propsLoaded = param1;
         this.propsTotal = param2;
      }
      
      override public function clone() : Event
      {
         return new PropLibProgressEvent(this.propsLoaded,this.propsTotal);
      }
   }
}

