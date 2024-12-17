package alternativa.engine3d.loaders.events
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class LoaderProgressEvent extends ProgressEvent
   {
      public static const LOADING_PROGRESS:String = "loadingProgress";
      
      private var _loadingStage:int;
      
      private var _totalItems:int;
      
      private var _currentItem:int;
      
      public function LoaderProgressEvent(param1:String, param2:int, param3:int, param4:int, param5:uint = 0, param6:uint = 0)
      {
         super(param1,false,false,param5,param6);
         this._loadingStage = param2;
         this._totalItems = param3;
         this._currentItem = param4;
      }
      
      public function get loadingStage() : int
      {
         return this._loadingStage;
      }
      
      public function get totalItems() : int
      {
         return this._totalItems;
      }
      
      public function get currentItem() : int
      {
         return this._currentItem;
      }
      
      override public function clone() : Event
      {
         return new LoaderProgressEvent(type,this._loadingStage,this._totalItems,this._currentItem,bytesLoaded,bytesTotal);
      }
      
      override public function toString() : String
      {
         return "[LoaderProgressEvent type=\"" + type + "\", loadingStage=" + this._loadingStage + ", totalItems=" + this._totalItems + ", currentItem=" + this._currentItem + ", bytesTotal=" + bytesTotal + ", bytesLoaded=" + bytesLoaded + "]";
      }
   }
}

