package alternativa.editor.engine3d.loaders
{
   import alternativa.types.Map;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.system.LoaderContext;
   
   public class TextureMapsBatchLoader extends EventDispatcher
   {
      public static var stubBitmapData:BitmapData;
      
      private var loader:TextureMapsLoader;
      
      private var loaderContext:LoaderContext;
      
      private var baseUrl:String;
      
      private var batch:Map;
      
      private var materialNames:Array;
      
      private var totalFiles:int;
      
      private var currFileIndex:int;
      
      private var materialIndex:int;
      
      private var _textures:Map;
      
      public function TextureMapsBatchLoader()
      {
         super();
      }
      
      public function get textures() : Map
      {
         return this._textures;
      }
      
      private function getStubBitmapData() : BitmapData
      {
         var loc1:uint = 0;
         var loc2:uint = 0;
         var loc3:uint = 0;
         if(stubBitmapData == null)
         {
            loc1 = 20;
            stubBitmapData = new BitmapData(loc1,loc1,false,0);
            loc2 = 0;
            while(loc2 < loc1)
            {
               loc3 = 0;
               while(loc3 < loc1)
               {
                  stubBitmapData.setPixel(!!(loc2 % 2) ? int(loc3) : loc3 + 1,loc2,16711935);
                  loc3 += 2;
               }
               loc2++;
            }
         }
         return stubBitmapData;
      }
      
      public function close() : void
      {
         if(this.loader != null)
         {
            this.loader.close();
         }
      }
      
      private function clean() : void
      {
         this.loaderContext = null;
         this.batch = null;
         this.materialNames = null;
      }
      
      public function unload() : void
      {
         this._textures = null;
      }
      
      public function load(param1:String, param2:Map, param3:LoaderContext) : void
      {
         var loc4:String = null;
         var loc5:TextureMapsInfo = null;
         this.baseUrl = param1;
         this.batch = param2;
         this.loaderContext = param3;
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
         for(loc4 in param2)
         {
            this.materialNames.push(loc4);
            loc5 = param2[loc4];
            this.totalFiles += loc5.opacityMapFileName == null ? 1 : 2;
         }
         this.currFileIndex = 0;
         this.materialIndex = 0;
         this._textures = new Map();
         this.loadNextTextureFile();
      }
      
      private function loadNextTextureFile() : void
      {
         var loc1:TextureMapsInfo = this.batch[this.materialNames[this.materialIndex]];
         this.loader.load(this.baseUrl + loc1.diffuseMapFileName,loc1.opacityMapFileName == null ? null : this.baseUrl + loc1.opacityMapFileName,this.loaderContext);
      }
      
      private function onTextureLoadingStart(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function onTextureLoadingComplete(param1:Event) : void
      {
         dispatchEvent(param1);
         ++this.currFileIndex;
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADING_PROGRESS,LoadingStage.TEXTURE,this.totalFiles,this.currFileIndex,param1.bytesLoaded,param1.bytesTotal));
      }
      
      private function onMaterialTexturesLoadingComplete(param1:Event) : void
      {
         var loc2:IOErrorEvent = null;
         var loc3:TextureMapsInfo = null;
         if(param1 is IOErrorEvent)
         {
            this._textures.add(this.materialNames[this.materialIndex],this.getStubBitmapData());
            loc2 = IOErrorEvent(param1);
            loc3 = this.batch[this.materialNames[this.materialIndex]];
            if(loc3.diffuseMapFileName)
            {
               loc2.text += this.baseUrl + loc3.diffuseMapFileName;
            }
            if(loc3.opacityMapFileName)
            {
               loc2.text += this.baseUrl + loc3.opacityMapFileName;
            }
            dispatchEvent(loc2);
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
   }
}

