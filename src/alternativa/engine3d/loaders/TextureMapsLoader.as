package alternativa.engine3d.loaders
{
   import alternativa.engine3d.loaders.events.LoaderEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class TextureMapsLoader extends EventDispatcher
   {
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_LOADING_DIFFUSE_MAP:int = 1;
      
      private static const STATE_LOADING_ALPHA_MAP:int = 2;
      
      private var _bitmapData:BitmapData;
      
      private var bitmapLoader:Loader;
      
      private var alphaTextureUrl:String;
      
      private var loaderContext:LoaderContext;
      
      private var loaderState:int = 0;
      
      public function TextureMapsLoader(param1:String = null, param2:String = null, param3:LoaderContext = null)
      {
         super();
         if(param1 != null)
         {
            this.load(param1,param2,param3);
         }
      }
      
      public function load(param1:String, param2:String = null, param3:LoaderContext = null) : void
      {
         this.alphaTextureUrl = param2;
         this.loaderContext = param3;
         if(this.bitmapLoader == null)
         {
            this.bitmapLoader = new Loader();
            this.bitmapLoader.contentLoaderInfo.addEventListener(Event.OPEN,this.onOpen);
            this.bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
            this.bitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.bitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         }
         else
         {
            this.close();
         }
         this.startLoading(STATE_LOADING_DIFFUSE_MAP,param1);
      }
      
      private function onOpen(param1:Event) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_START,LoadingStage.TEXTURE));
      }
      
      private function onProgress(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function startLoading(param1:int, param2:String) : void
      {
         this.loaderState = param1;
         this.bitmapLoader.load(new URLRequest(param2),this.loaderContext);
      }
      
      private function onComplete(param1:Event) : void
      {
         var loc2:BitmapData = null;
         var loc3:BitmapData = null;
         dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_COMPLETE,LoadingStage.TEXTURE));
         switch(this.loaderState)
         {
            case STATE_LOADING_DIFFUSE_MAP:
               this._bitmapData = Bitmap(this.bitmapLoader.content).bitmapData;
               if(this.alphaTextureUrl != null)
               {
                  this.startLoading(STATE_LOADING_ALPHA_MAP,this.alphaTextureUrl);
                  break;
               }
               this.complete();
               break;
            case STATE_LOADING_ALPHA_MAP:
               loc2 = this._bitmapData;
               this._bitmapData = new BitmapData(this._bitmapData.width,this._bitmapData.height,true,0);
               this._bitmapData.copyPixels(loc2,loc2.rect,new Point());
               loc3 = Bitmap(this.bitmapLoader.content).bitmapData;
               if(this._bitmapData.width != loc3.width || this._bitmapData.height != loc3.height)
               {
                  loc2.draw(loc3,new Matrix(this._bitmapData.width / loc3.width,0,0,this._bitmapData.height / loc3.height),null,BlendMode.NORMAL,null,true);
                  loc3.dispose();
                  loc3 = loc2;
               }
               this._bitmapData.copyChannel(loc3,loc3.rect,new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
               loc3.dispose();
               this.complete();
         }
      }
      
      private function onLoadError(param1:IOErrorEvent) : void
      {
         this.loaderState = STATE_IDLE;
         dispatchEvent(param1);
      }
      
      private function complete() : void
      {
         this.loaderState = STATE_IDLE;
         this.bitmapLoader.unload();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function close() : void
      {
         if(this.loaderState != STATE_IDLE)
         {
            this.loaderState = STATE_IDLE;
            this.bitmapLoader.close();
         }
         this.unload();
      }
      
      public function unload() : void
      {
         if(this.loaderState == STATE_IDLE)
         {
            if(this.bitmapLoader != null)
            {
               this.bitmapLoader.unload();
            }
            this.loaderContext = null;
            this._bitmapData = null;
         }
      }
   }
}

