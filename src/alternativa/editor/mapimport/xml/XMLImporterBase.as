package alternativa.editor.mapimport.xml
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class XMLImporterBase extends EventDispatcher
   {
      private var maxBatchSize:int;
      
      private var items:XMLList;
      
      private var firstIndex:int;
      
      private var timer:Timer;
      
      public function XMLImporterBase()
      {
         super();
      }
      
      protected function startBatchExecution(param1:int, param2:XMLList) : void
      {
         this.maxBatchSize = param1;
         this.items = param2;
         this.firstIndex = 0;
         this.timer = new Timer(10,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.processBatch();
      }
      
      protected function processItem(param1:XML) : void
      {
      }
      
      protected function batchComplete(param1:int) : void
      {
      }
      
      protected function batchExecutionComplete() : void
      {
      }
      
      private function processBatch() : void
      {
         if(this.firstIndex == this.items.length())
         {
            this.batchExecutionComplete();
            return;
         }
         var loc1:int = this.firstIndex + this.maxBatchSize;
         if(loc1 > this.items.length())
         {
            loc1 = int(this.items.length());
         }
         var loc2:int = this.firstIndex;
         while(loc2 < loc1)
         {
            this.processItem(this.items[loc2]);
            loc2++;
         }
         this.firstIndex = loc1;
         this.batchComplete(this.firstIndex);
         this.timer.reset();
         this.timer.start();
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.processBatch();
      }
   }
}

