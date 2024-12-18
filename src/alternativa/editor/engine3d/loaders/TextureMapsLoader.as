package alternativa.editor.engine3d.loaders
{
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
   import mx.controls.Alert;
   import flash.filesystem.File;
   
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="loadingComplete",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   [Event(name="loadingStart",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   public class TextureMapsLoader extends EventDispatcher
   {
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_LOADING_DIFFUSE_MAP:int = 1;
      
      private static const STATE_LOADING_ALPHA_MAP:int = 2;
      
      private var bitmapLoader:Loader;
      
      private var loaderContext:LoaderContext;
      
      private var alphaTextureUrl:String;
      
      private var _bitmapData:BitmapData;
      
      private var loaderState:int = 0;

      private var _triedPNG:Boolean = false;
      private var _triedUnderscore:Boolean = false;
      private var _originalUrl:String;
      
      public function TextureMapsLoader(diffuseTextureUrl:String = null, alphaTextureUrl:String = null, loaderContext:LoaderContext = null)
      {
         super();
         if(diffuseTextureUrl != null)
         {
            this.load(diffuseTextureUrl,alphaTextureUrl,loaderContext);
         }
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
      
      public function load(diffuseTextureUrl:String, alphaTextureUrl:String = null, loaderContext:LoaderContext = null) : void
      {
         this.alphaTextureUrl = alphaTextureUrl;
         this.loaderContext = loaderContext;
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
         _originalUrl = diffuseTextureUrl;
         this.startLoading(STATE_LOADING_DIFFUSE_MAP,diffuseTextureUrl);
      }
      
      private function onComplete(e:Event) : void
      {
         var tmpBmp:BitmapData = null;
         var alpha:BitmapData = null;
         dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_COMPLETE,LoadingStage.TEXTURE));
         switch(this.loaderState)
         {
            case STATE_LOADING_DIFFUSE_MAP:
               this._bitmapData = Bitmap(this.bitmapLoader.content).bitmapData;
               if(this.alphaTextureUrl != null)
               {
                  _originalUrl = this.alphaTextureUrl;
                  this.startLoading(STATE_LOADING_ALPHA_MAP,this.alphaTextureUrl);
               }
               else
               {
                  this.complete();
               }
               break;
            case STATE_LOADING_ALPHA_MAP:
               tmpBmp = this._bitmapData;
               this._bitmapData = new BitmapData(this._bitmapData.width,this._bitmapData.height,true,0);
               this._bitmapData.copyPixels(tmpBmp,tmpBmp.rect,new Point());
               alpha = Bitmap(this.bitmapLoader.content).bitmapData;
               if(this._bitmapData.width != alpha.width || this._bitmapData.height != alpha.height)
               {
                  tmpBmp.draw(alpha,new Matrix(this._bitmapData.width / alpha.width,0,0,this._bitmapData.height / alpha.height),null,BlendMode.NORMAL,null,true);
                  alpha.dispose();
                  alpha = tmpBmp;
               }
               this._bitmapData.copyChannel(alpha,alpha.rect,new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
               alpha.dispose();
               this.complete();
         }
      }
      
      private function onOpen(e:Event) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.LOADING_START,LoadingStage.TEXTURE));
      }
      
      private function onLoadError(e:IOErrorEvent) : void
      {
         var split:Array = _originalUrl.split(File.separator);
         var lastPart:String = split[split.length-1];
         if(!_triedUnderscore && lastPart.indexOf("_") != -1)
         {
            _triedUnderscore = true;
            var underscoreIndex:int = _originalUrl.lastIndexOf("_");
            this.bitmapLoader.load(new URLRequest(_originalUrl.slice(0,underscoreIndex)+_originalUrl.slice(underscoreIndex,_originalUrl.length-underscoreIndex)),this.loaderContext);
            return;
         }
         if(!_triedPNG && _originalUrl.indexOf(".jpg") != -1)
         {
            _triedPNG = true;
            this.bitmapLoader.load(new URLRequest(_originalUrl.replace(".jpg",".png")),this.loaderContext);
            return;
         }
         this.loaderState = STATE_IDLE;
         //dispatchEvent(e);

         this._bitmapData = new BitmapData(1,1,false,0xff00ff);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onProgress(e:Event) : void
      {
         dispatchEvent(e);
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
      
      private function complete() : void
      {
         this.loaderState = STATE_IDLE;
         this.bitmapLoader.unload();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function startLoading(state:int, url:String) : void
      {
         this.loaderState = state;
         this.bitmapLoader.load(new URLRequest(url),this.loaderContext);
      }
   }
}

