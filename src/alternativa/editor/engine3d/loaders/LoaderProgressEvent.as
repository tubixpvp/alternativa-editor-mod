package alternativa.editor.engine3d.loaders
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class LoaderProgressEvent extends ProgressEvent
   {
      public static const LOADING_PROGRESS:String = "loadingProgress";
      
      private var _loadingStage:int;
      
      private var _totalItems:int;
      
      private var _currentItem:int;
      
      public function LoaderProgressEvent(type:String, loadingStage:int, totalItems:int, currentItem:int, bytesLoaded:uint = 0, bytesTotal:uint = 0)
      {
         super(type,false,false,bytesLoaded,bytesTotal);
         this._loadingStage = loadingStage;
         this._totalItems = totalItems;
         this._currentItem = currentItem;
      }
      
      public function get currentItem() : int
      {
         return this._currentItem;
      }
      
      override public function clone() : Event
      {
         return new LoaderProgressEvent(type,this._loadingStage,this._totalItems,this._currentItem,bytesLoaded,bytesTotal);
      }
      
      public function get loadingStage() : int
      {
         return this._loadingStage;
      }
      
      public function get totalItems() : int
      {
         return this._totalItems;
      }
      
      override public function toString() : String
      {
         return "[LoaderProgressEvent type=\"" + type + "\", loadingStage=" + this._loadingStage + ", totalItems=" + this._totalItems + ", currentItem=" + this._currentItem + ", bytesTotal=" + bytesTotal + ", bytesLoaded=" + bytesLoaded + "]";
      }
   }
}

