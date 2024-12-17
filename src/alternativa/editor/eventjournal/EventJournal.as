package alternativa.editor.eventjournal
{
   import alternativa.types.Set;
   
   public class EventJournal
   {
      public static const ADD:int = 0;
      
      public static const DELETE:int = 1;
      
      public static const ROTATE:int = 2;
      
      public static const MOVE:int = 3;
      
      public static const COPY:int = 4;
      
      public static const CHANGE_TEXTURE:int = 5;
      
      private var events:Array;
      
      private var cancelEvents:Array;
      
      public function EventJournal()
      {
         super();
         this.events = [];
         this.cancelEvents = [];
      }
      
      public function addEvent(param1:int, param2:Set, param3:* = null) : void
      {
         this.events.push(new EventJournalItem(param1,param2,param3));
         this.cancelEvents.length = 0;
      }
      
      public function undo(param1:Boolean = false) : EventJournalItem
      {
         var loc3:EventJournalItem = null;
         var loc2:int = int(this.events.length);
         if(loc2 > 0)
         {
            loc3 = this.events[loc2 - 1];
            this.events.pop();
            if(!param1)
            {
               this.cancelEvents.push(loc3);
            }
            return loc3;
         }
         return null;
      }
      
      public function redo() : EventJournalItem
      {
         var loc2:EventJournalItem = null;
         var loc1:int = int(this.cancelEvents.length);
         if(loc1 > 0)
         {
            loc2 = this.cancelEvents[loc1 - 1];
            this.cancelEvents.pop();
            this.events.push(loc2);
            return loc2;
         }
         return null;
      }
   }
}

