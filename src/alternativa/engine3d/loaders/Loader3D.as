package alternativa.engine3d.loaders
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.events.LoaderEvent;
   import alternativa.engine3d.loaders.events.LoaderProgressEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class Loader3D extends EventDispatcher
   {
      protected var loaderState:int = 0;
      
      protected var baseURL:String;
      
      protected var loaderContext:LoaderContext;
      
      protected var _content:Object3D;
      
      private var mainLoader:URLLoader;
      
      public function Loader3D()
      {
         super(this);
      }
      
      final public function get content() : Object3D
      {
         return this._content;
      }
      
      final public function load(param1:String, param2:LoaderContext = null) : void
      {
         this.baseURL = param1.substring(0,param1.lastIndexOf("/") + 1);
         this.loaderContext = param2;
         if(this.mainLoader == null)
         {
            this.mainLoader = new URLLoader();
            this.mainLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.mainLoader.addEventListener(Event.COMPLETE,this.onMainLoadingComplete);
            this.mainLoader.addEventListener(ProgressEvent.PROGRESS,this.onMainLoadingProgress);
            this.mainLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onMainLoadingError);
            this.mainLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onMainLoadingError);
         }
         else
         {
            this.close();
         }
         this._content = null;
         this.setState(Loader3DState.LOADING_MAIN);
         this.mainLoader.load(new URLRequest(param1));
         if(hasEventListener(LoaderEvent.LOADING_START))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_START,LoadingStage.MAIN_FILE));
         }
      }
      
      final public function loadBytes(param1:ByteArray, param2:String = null, param3:LoaderContext = null) : void
      {
         if(param2 == null)
         {
            param2 = "";
         }
         else if(param2.length > 0 && param2.charAt(param2.length - 1) != "/")
         {
            param2 += "/";
         }
         this.baseURL = param2;
         this.loaderContext = param3;
         this.close();
         this._content = null;
         this.parse(param1);
      }
      
      final public function close() : void
      {
         if(this.loaderState == Loader3DState.LOADING_MAIN)
         {
            this.mainLoader.close();
         }
         this.closeInternal();
         this.clean();
         this.setState(Loader3DState.IDLE);
      }
      
      final public function unload() : void
      {
         if(this.loaderState != Loader3DState.IDLE)
         {
            return;
         }
         this._content = null;
         this.unloadInternal();
      }
      
      protected function closeInternal() : void
      {
      }
      
      protected function unloadInternal() : void
      {
      }
      
      protected function setState(param1:int) : void
      {
         this.loaderState = param1;
      }
      
      protected function parse(param1:ByteArray) : void
      {
      }
      
      protected function onMainLoadingError(param1:ErrorEvent) : void
      {
         this.setState(Loader3DState.IDLE);
         dispatchEvent(param1);
      }
      
      final protected function complete() : void
      {
         this.setState(Loader3DState.IDLE);
         this.clean();
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function clean() : void
      {
      }
      
      private function onMainLoadingComplete(param1:Event) : void
      {
         this.setState(Loader3DState.IDLE);
         if(hasEventListener(LoaderEvent.LOADING_COMPLETE))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_COMPLETE,LoadingStage.MAIN_FILE));
         }
         this.parse(this.mainLoader.data);
      }
      
      private function onMainLoadingProgress(param1:ProgressEvent) : void
      {
         if(hasEventListener(LoaderProgressEvent.LOADING_PROGRESS))
         {
            dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADING_PROGRESS,LoadingStage.MAIN_FILE,1,0,param1.bytesLoaded,param1.bytesTotal));
         }
      }
   }
}

