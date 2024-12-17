package alternativa.engine3d.loaders.events
{
   import flash.events.Event;
   
   public class LoaderEvent extends Event
   {
      public static const LOADING_START:String = "loadingStart";
      
      public static const LOADING_COMPLETE:String = "loadingComplete";
      
      private var _loadingStage:int;
      
      public function LoaderEvent(param1:String, param2:int)
      {
         super(param1);
         this._loadingStage = param2;
      }
      
      public function get loadingStage() : int
      {
         return this._loadingStage;
      }
      
      override public function clone() : Event
      {
         return new LoaderEvent(type,this._loadingStage);
      }
      
      override public function toString() : String
      {
         return "[LoaderEvent type=\"" + type + "\", loadingStage=" + this._loadingStage + "]";
      }
   }
}

