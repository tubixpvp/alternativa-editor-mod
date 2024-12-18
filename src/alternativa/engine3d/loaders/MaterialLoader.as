package alternativa.engine3d.loaders
{
   import alternativa.engine3d.loaders.events.LoaderErrorEvent;
   import alternativa.engine3d.loaders.events.LoaderEvent;
   import alternativa.engine3d.loaders.events.LoaderProgressEvent;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   [Event(name="loaderError",type="alternativa.engine3d.loaders.events.LoaderErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="partComplete",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   [Event(name="partOpen",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   public class MaterialLoader extends EventDispatcher
   {
      
      private static var stub:BitmapData;
       
      
      private var loader:Loader;
      
      private var context:LoaderContext;
      
      private var materials:Vector.<TextureMaterial>;
      
      private var urls:Vector.<String>;
      
      private var filesTotal:int;
      
      private var filesLoaded:int;
      
      private var diffuse:BitmapData;
      
      private var currentURL:String;
      
      private var index:int;
      
      public function MaterialLoader()
      {
         super();
      }
      
      public function load(param1:Vector.<TextureMaterial>, param2:LoaderContext = null) : void
      {
         var _loc5_:TextureMaterial = null;
         this.context = param2;
         this.materials = param1;
         this.urls = new Vector.<String>();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = param1[_loc3_];
            var _loc6_:* = _loc4_++;
            this.urls[_loc6_] = _loc5_.diffuseMapURL;
            ++this.filesTotal;
            if(_loc5_.opacityMapURL != null)
            {
               var _loc7_:* = _loc4_++;
               this.urls[_loc7_] = _loc5_.opacityMapURL;
               ++this.filesTotal;
            }
            else
            {
               _loc7_ = _loc4_++;
               this.urls[_loc7_] = null;
            }
            _loc3_++;
         }
         this.filesLoaded = 0;
         this.index = -1;
         this.loadNext(null);
      }
      
      public function close() : void
      {
         this.destroyLoader();
         this.materials = null;
         this.urls = null;
         this.diffuse = null;
         this.currentURL = null;
         this.context = null;
      }
      
      private function destroyLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.unload();
            this.loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.onPartOpen);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadNext);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onFileProgress);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR,this.loadNext);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadNext);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.loadNext);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.loadNext);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadNext);
            this.loader = null;
         }
      }
      
      private function loadNext(param1:Event) : void
      {
         var _loc2_:TextureMaterial = null;
         if(this.index >= 0)
         {
            if(this.index % 2 == 0)
            {
               if(param1 is ErrorEvent)
               {
                  this.diffuse = this.getStub();
                  this.onFileError((param1 as ErrorEvent).text);
               }
               else
               {
                  this.diffuse = (this.loader.content as Bitmap).bitmapData;
               }
               ++this.filesLoaded;
            }
            else
            {
               _loc2_ = this.materials[this.index - 1 >> 1];
               if(param1 == null)
               {
                  _loc2_.texture = this.diffuse;
               }
               else
               {
                  if(param1 is ErrorEvent)
                  {
                     _loc2_.texture = this.diffuse;
                     this.onFileError((param1 as ErrorEvent).text);
                  }
                  else
                  {
                     _loc2_.texture = this.merge(this.diffuse,(this.loader.content as Bitmap).bitmapData);
                  }
                  ++this.filesLoaded;
               }
               this.onPartComplete(this.index - 1 >> 1,_loc2_);
               this.diffuse = null;
            }
            this.destroyLoader();
         }
         if(++this.index >= this.urls.length)
         {
            this.close();
            if(hasEventListener(Event.COMPLETE))
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         else
         {
            this.currentURL = this.urls[this.index];
            if(this.currentURL != null && (this.diffuse == null || this.diffuse != stub))
            {
               this.loader = new Loader();
               if(this.index % 2 == 0)
               {
                  this.loader.contentLoaderInfo.addEventListener(Event.OPEN,this.onPartOpen);
               }
               this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadNext);
               this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onFileProgress);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.loadNext);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadNext);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.loadNext);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR,this.loadNext);
               this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadNext);
               this.loader.load(new URLRequest(this.currentURL),this.context);
            }
            else
            {
               this.loadNext(null);
            }
         }
      }
      
      private function onPartOpen(param1:Event) : void
      {
         if(hasEventListener(LoaderEvent.PART_OPEN))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PART_OPEN,this.urls.length >> 1,this.index >> 1,this.materials[this.index >> 1]));
         }
      }
      
      private function onPartComplete(param1:int, param2:TextureMaterial) : void
      {
         if(hasEventListener(LoaderEvent.PART_COMPLETE))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PART_COMPLETE,this.urls.length >> 1,param1,param2));
         }
      }
      
      private function onFileProgress(param1:ProgressEvent) : void
      {
         if(hasEventListener(LoaderProgressEvent.LOADER_PROGRESS))
         {
            dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADER_PROGRESS,this.filesTotal,this.filesLoaded,(this.filesLoaded + param1.bytesLoaded / param1.bytesTotal) / this.filesTotal,param1.bytesLoaded,param1.bytesTotal));
         }
      }
      
      private function onFileError(param1:String) : void
      {
         dispatchEvent(new LoaderErrorEvent(LoaderErrorEvent.LOADER_ERROR,this.currentURL,param1));
      }
      
      private function merge(param1:BitmapData, param2:BitmapData) : BitmapData
      {
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height);
         _loc3_.copyPixels(param1,param1.rect,new Point());
         if(param1.width != param2.width || param1.height != param2.height)
         {
            param1.draw(param2,new Matrix(param1.width / param2.width,0,0,param1.height / param2.height),null,BlendMode.NORMAL,null,true);
            param2.dispose();
            param2 = param1;
         }
         else
         {
            param1.dispose();
         }
         _loc3_.copyChannel(param2,param2.rect,new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
         param2.dispose();
         return _loc3_;
      }
      
      private function getStub() : BitmapData
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(stub == null)
         {
            _loc1_ = 32;
            stub = new BitmapData(_loc1_,_loc1_,false,0);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  stub.setPixel(Boolean(_loc2_ % 2)?int(_loc3_):int(_loc3_ + 1),_loc2_,16711935);
                  _loc3_ = _loc3_ + 2;
               }
               _loc2_++;
            }
         }
         return stub;
      }
   }
}
