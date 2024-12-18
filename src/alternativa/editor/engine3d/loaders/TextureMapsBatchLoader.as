package alternativa.editor.engine3d.loaders
{
   import alternativa.types.Map;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.system.LoaderContext;
   
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="loadingComplete",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   [Event(name="loadingProgress",type="alternativa.engine3d.loaders.events.LoaderProgressEvent")]
   [Event(name="loadingStart",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   public class TextureMapsBatchLoader extends EventDispatcher
   {
      public static var stubBitmapData:BitmapData;
      
      private var loader:TextureMapsLoader;
      
      private var _textures:Map;
      
      private var totalFiles:int;
      
      private var loaderContext:LoaderContext;
      
      private var baseUrl:String;
      
      private var materialNames:Array;
      
      private var materialIndex:int;
      
      private var batch:Map;
      
      private var currentFileNumber:int;
      
      public function TextureMapsBatchLoader()
      {
         super();
      }
      
      private function loadNextTextureFile() : void
      {
         var info:TextureMapsInfo = this.batch[this.materialNames[this.materialIndex]];
         this.loader.load(this.baseUrl + info.diffuseMapFileName,info.opacityMapFileName == null ? null : this.baseUrl + info.opacityMapFileName,this.loaderContext);
      }
      
      private function clean() : void
      {
         this.loaderContext = null;
         this.batch = null;
         this.materialNames = null;
      }
      
      public function get textures() : Map
      {
         return this._textures;
      }
      
      private function onTextureLoadingStart(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      private function onProgress(e:ProgressEvent) : void
      {
         dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADING_PROGRESS,LoadingStage.TEXTURE,this.totalFiles,this.currentFileNumber,e.bytesLoaded,e.bytesTotal));
      }
      
      public function load(baseURL:String, batch:Map, loaderContext:LoaderContext) : void
      {
         var materialName:String = null;
         var info:TextureMapsInfo = null;
         this.baseUrl = baseURL;
         this.batch = batch;
         this.loaderContext = loaderContext;
         if(this.loader == null)
         {
            this.loader = new TextureMapsLoader();
            this.loader.addEventListener(LoaderEvent.LOADING_START,this.onTextureLoadingStart);
            this.loader.addEventListener(LoaderEvent.LOADING_COMPLETE,this.onTextureLoadingComplete);
            this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.addEventListener(Event.COMPLETE,this.onMaterialTexturesLoadingComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onMaterialTexturesLoadingComplete);
         }
         else
         {
            this.close();
         }
         this.totalFiles = 0;
         this.materialNames = new Array();
         for(materialName in batch)
         {
            this.materialNames.push(materialName);
            info = batch[materialName];
            this.totalFiles += info.opacityMapFileName == null ? 1 : 2;
         }
         this.currentFileNumber = 1;
         this.materialIndex = 0;
         this._textures = new Map();
         this.loadNextTextureFile();
      }
      
      private function onMaterialTexturesLoadingComplete(e:Event) : void
      {
         if(e is IOErrorEvent)
         {
            this._textures.add(this.materialNames[this.materialIndex],this.getStubBitmapData());
            dispatchEvent(e);
         }
         else
         {
            this._textures.add(this.materialNames[this.materialIndex],this.loader.bitmapData);
         }
         if(++this.materialIndex == this.materialNames.length)
         {
            this.clean();
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            this.loadNextTextureFile();
         }
      }
      
      public function close() : void
      {
         if(this.loader != null)
         {
            this.loader.close();
         }
      }
      
      private function onTextureLoadingComplete(e:Event) : void
      {
         dispatchEvent(e);
         ++this.currentFileNumber;
      }
      
      private function getStubBitmapData() : BitmapData
      {
         var size:uint = 0;
         var i:uint = 0;
         var j:uint = 0;
         if(stubBitmapData == null)
         {
            size = 20;
            stubBitmapData = new BitmapData(size,size,false,0);
            for(i = 0; i < size; i++)
            {
               for(j = 0; j < size; j += 2)
               {
                  stubBitmapData.setPixel(Boolean(i % 2) ? int(j) : j + 1,i,16711935);
               }
            }
         }
         return stubBitmapData;
      }
      
      public function unload() : void
      {
         this._textures = null;
      }
   }
}

