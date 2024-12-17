package alternativa.engine3d.loaders
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.loaders.events.LoaderEvent;
   import alternativa.engine3d.loaders.events.LoaderProgressEvent;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Texture;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class Loader3DS extends Loader3D
   {
      public var loadMaterials:Boolean = true;
      
      private var bitmapLoader:TextureMapsBatchLoader;
      
      private var parser:Parser3DS;
      
      public function Loader3DS()
      {
         super();
         this.parser = new Parser3DS();
      }
      
      public function get repeat() : Boolean
      {
         return this.parser.repeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         this.parser.repeat = param1;
      }
      
      public function get smooth() : Boolean
      {
         return this.parser.smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         this.parser.smooth = param1;
      }
      
      public function get blendMode() : String
      {
         return this.parser.blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this.parser.blendMode = param1;
      }
      
      public function get precision() : Number
      {
         return this.parser.precision;
      }
      
      public function set precision(param1:Number) : void
      {
         this.parser.precision = param1;
      }
      
      public function get scale() : Number
      {
         return this.parser.scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this.parser.scale = param1;
      }
      
      public function get mobility() : int
      {
         return this.parser.mobility;
      }
      
      public function set mobility(param1:int) : void
      {
         this.parser.mobility = param1;
      }
      
      override protected function closeInternal() : void
      {
         super.closeInternal();
         if(loaderState == Loader3DState.LOADING_TEXTURE)
         {
            this.bitmapLoader.close();
         }
      }
      
      override protected function unloadInternal() : void
      {
         if(this.bitmapLoader != null)
         {
            this.bitmapLoader.unload();
         }
      }
      
      override protected function parse(param1:ByteArray) : void
      {
         this.parser.parse(param1);
         _content = this.parser.content;
         if(this.loadMaterials && this.parser.textureMaterials != null)
         {
            this.loadTextures();
         }
         else
         {
            complete();
         }
      }
      
      private function loadTextures() : void
      {
         if(this.bitmapLoader == null)
         {
            this.bitmapLoader = new TextureMapsBatchLoader();
            this.bitmapLoader.addEventListener(LoaderEvent.LOADING_START,this.onTextureLoadingStart);
            this.bitmapLoader.addEventListener(LoaderEvent.LOADING_COMPLETE,this.onTextureLoadingComplete);
            this.bitmapLoader.addEventListener(LoaderProgressEvent.LOADING_PROGRESS,this.onTextureLoadingProgress);
            this.bitmapLoader.addEventListener(Event.COMPLETE,this.onTextureMaterialsLoadingComplete);
            this.bitmapLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onTextureLoadingError);
         }
         setState(Loader3DState.LOADING_TEXTURE);
         this.bitmapLoader.load(baseURL,this.parser.textureMaterials,loaderContext);
      }
      
      private function onTextureLoadingError(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onTextureLoadingStart(param1:LoaderEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      private function onTextureLoadingComplete(param1:LoaderEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      private function onTextureLoadingProgress(param1:LoaderProgressEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      private function onTextureMaterialsLoadingComplete(param1:Event) : void
      {
         this.parser.content.forEach(this.setTextures);
         complete();
      }
      
      private function setTextures(param1:Object3D) : void
      {
         var loc3:String = null;
         var loc4:TextureMapsInfo = null;
         var loc5:Texture = null;
         var loc6:Surface = null;
         var loc2:Mesh = param1 as Mesh;
         if(loc2 != null)
         {
            for(loc3 in loc2.alternativa3d::_surfaces)
            {
               loc4 = this.parser.textureMaterials[loc3];
               if(loc4 != null)
               {
                  loc5 = new Texture(this.bitmapLoader.textures[loc3],loc4.diffuseMapFileName);
                  loc6 = loc2.alternativa3d::_surfaces[loc3];
                  TextureMaterial(loc6.material).texture = loc5;
               }
            }
         }
      }
   }
}

