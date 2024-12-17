package alternativa.editor.eventjournal
{
   import alternativa.types.Set;
   
   public class EventJournalItem
   {
      public var operation:int;
      
      public var props:Set;
      
      public var oldState:*;
      
      public function EventJournalItem(param1:int, param2:Set, param3:*)
      {
         super();
         this.operation = param1;
         this.props = param2;
         this.oldState = param3;
      }
   }
}

