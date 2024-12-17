package alternativa.editor.events
{
   import flash.events.Event;
   
   public class EditorProgressEvent extends Event
   {
      public static const PROGRESS:String = "progress";
      
      public var progress:Number;
      
      public function EditorProgressEvent(param1:Number)
      {
         super(PROGRESS);
         this.progress = param1;
      }
      
      override public function clone() : Event
      {
         return new EditorProgressEvent(this.progress);
      }
      
      override public function toString() : String
      {
         return "EditorProgressEvent progress=" + this.progress;
      }
   }
}

