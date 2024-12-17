package alternativa.editor.propslib.loaders
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.loaders.Loader3DS;
   import alternativa.engine3d.loaders.TextureMapsBatchLoader;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Map;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.system.LoaderContext;
   
   public class MeshLoader extends ObjectLoader
   {
      public var object:Mesh;
      
      public var bitmaps:Map;
      
      private var url:String;
      
      private var objectName:String;
      
      private var textures:Map;
      
      private var loader3DS:Loader3DS;
      
      private var texturesLoader:TextureMapsBatchLoader;
      
      private var loaderContext:LoaderContext;
      
      public function MeshLoader(param1:String, param2:String, param3:Map)
      {
         super();
         this.url = param1;
         this.objectName = param2;
         this.textures = param3;
      }
      
      override public function load(param1:LoaderContext) : void
      {
         this.loaderContext = param1;
         this.loader3DS = new Loader3DS();
         this.loader3DS.addEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader3DS.addEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.loader3DS.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onErrorEvent);
         this.loader3DS.smooth = true;
         this.loader3DS.repeat = false;
         this.loader3DS.load(this.url,param1);
      }
      
      private function on3DSLoadingComplete(param1:Event) : void
      {
         if(this.objectName != null)
         {
            this.object = this.loader3DS.content.getChildByName(this.objectName,true) as Mesh;
         }
         else
         {
            this.object = this.loader3DS.content.children.peek() as Mesh;
         }
         this.loader3DS.removeEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader3DS.removeEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.loader3DS.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onErrorEvent);
         this.loader3DS = null;
         if(this.textures != null)
         {
            this.texturesLoader = new TextureMapsBatchLoader();
            this.texturesLoader.addEventListener(Event.COMPLETE,this.onTexturesLoadingComplete);
            this.texturesLoader.addEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
            this.texturesLoader.load("",this.textures,this.loaderContext);
         }
         else
         {
            this.initDefaultTexture();
            complete();
         }
      }
      
      private function initDefaultTexture() : void
      {
         var loc1:Mesh = Mesh(this.object);
         var loc2:Surface = loc1.surfaces.peek();
         var loc3:TextureMaterial = loc2.material as TextureMaterial;
         if(loc3 != null)
         {
            this.bitmaps = new Map();
            this.bitmaps.add("DEFAULT",loc3.texture.bitmapData);
         }
      }
      
      private function onTexturesLoadingComplete(param1:Event) : void
      {
         this.bitmaps = this.texturesLoader.textures;
         this.texturesLoader.removeEventListener(Event.COMPLETE,this.onTexturesLoadingComplete);
         this.texturesLoader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.texturesLoader = null;
         complete();
      }
      
      override public function toString() : String
      {
         return "[MeshLoader url=" + this.url + ", objectName=" + this.objectName + ", textures=" + this.textures + "]";
      }
   }
}

