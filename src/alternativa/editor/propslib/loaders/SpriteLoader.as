package alternativa.editor.propslib.loaders
{
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.editor.engine3d.loaders.TextureMapsLoader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.LoaderContext;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import alternativa.editor.propslib.TextureDiffuseMapsRegistry;
   
   public class SpriteLoader extends ObjectLoader
   {
      private var baseUrl:String;

      private var file:String;
      
      private var alpha:String;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var scale:Number;
      
      private var loader:TextureMapsLoader;
      
      public var sprite:Sprite3D;

      private var _libraryName:String,
                  _groupName:String,
                  _propName:String;
      
      public function SpriteLoader(baseUrl:String, diffuseFileName:String, alphaFileName:String, originX:Number, originY:Number, scale:Number,
         libraryName:String,
         groupName:String,
         propName:String)
      {
         super();
         this.baseUrl = baseUrl;
         this.file = diffuseFileName;
         this.alpha = alphaFileName;
         this.originX = originX;
         this.originY = originY;
         this.scale = scale;
         this._libraryName = libraryName;
         this._groupName = groupName;
         this._propName = propName;
      }
      
      override public function load(param1:LoaderContext) : void
      {
         var alpha:String = this.alpha;
         if(alpha != null)
         {
            alpha = this.baseUrl + alpha;
         }
         this.loader = new TextureMapsLoader(this.baseUrl + this.file,alpha,param1);
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
      }
      
      private function onLoadingComplete(param1:Event) : void
      {
         var bitmap:BitmapData = this.loader.bitmapData;

         TextureDiffuseMapsRegistry.addTexture(_libraryName, _groupName, _propName, "DEFAULT", this.file);

         this.sprite = new Sprite3D(100,100);
         //this.sprite.material = new SpriteTextureMaterial(new Texture(this.loader.bitmapData),1,true,BlendMode.NORMAL,this.originX,this.originY);
         this.sprite.material = new TextureMaterial(bitmap);
         this.sprite.originX = this.originX;
         this.sprite.originY = this.originY;

         this.sprite.scaleX = this.scale;
         this.sprite.scaleY = this.scale;
         this.sprite.scaleZ = this.scale;
         this.loader.unload();
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.loader = null;
         complete();
      }
   }
}

