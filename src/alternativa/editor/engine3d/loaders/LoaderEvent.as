package alternativa.editor.engine3d.loaders
{
   import flash.events.Event;
   
   public class LoaderEvent extends Event
   {
      public static const LOADING_START:String = "loadingStart";
      
      public static const LOADING_COMPLETE:String = "loadingComplete";
      
      private var _loadingStage:int;
      
      public function LoaderEvent(type:String, loadingStage:int)
      {
         super(type);
         this._loadingStage = loadingStage;
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

