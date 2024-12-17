package alternativa.editor
{
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   
   public class KeyMapper
   {
      private const MAX_KEYS:int = 31;
      
      private var keys:int;
      
      private var map:Vector.<int>;
      
      private var _dispatcher:IEventDispatcher;
      
      public function KeyMapper(param1:IEventDispatcher = null)
      {
         this.map = new Vector.<int>(this.MAX_KEYS);
         super();
         if(param1 != null)
         {
            this.startListening(param1);
         }
      }
      
      private function checkKey(param1:int) : void
      {
         if(param1 < 0 || param1 > this.MAX_KEYS - 1)
         {
            throw new ArgumentError("keyNum is out of range");
         }
      }
      
      public function mapKey(param1:int, param2:int) : void
      {
         this.checkKey(param1);
         this.map[param1] = param2;
      }
      
      public function unmapKey(param1:int) : void
      {
         this.checkKey(param1);
         this.map[param1] = 0;
         this.keys &= ~(1 << param1);
      }
      
      public function checkEvent(param1:KeyboardEvent) : void
      {
         var loc2:int = int(this.map.indexOf(param1.keyCode));
         if(loc2 > -1)
         {
            if(param1.type == KeyboardEvent.KEY_DOWN)
            {
               this.keys |= 1 << loc2;
            }
            else
            {
               this.keys &= ~(1 << loc2);
            }
         }
      }
      
      public function getKeyState(param1:int) : int
      {
         return this.keys >> param1 & 1;
      }
      
      public function keyPressed(param1:int) : Boolean
      {
         return this.getKeyState(param1) == 1;
      }
      
      public function startListening(param1:IEventDispatcher) : void
      {
         if(this._dispatcher == param1)
         {
            return;
         }
         if(this._dispatcher != null)
         {
            this.unregisterListeners();
         }
         this._dispatcher = param1;
         if(this._dispatcher != null)
         {
            this.registerListeners();
         }
      }
      
      public function stopListening() : void
      {
         if(this._dispatcher != null)
         {
            this.unregisterListeners();
         }
         this._dispatcher = null;
         this.keys = 0;
      }
      
      private function registerListeners() : void
      {
         this._dispatcher.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this._dispatcher.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function unregisterListeners() : void
      {
         this._dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this._dispatcher.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         this.checkEvent(param1);
      }
   }
}

