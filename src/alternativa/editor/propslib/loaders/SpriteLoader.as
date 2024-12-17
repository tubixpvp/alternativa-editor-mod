package alternativa.editor.propslib.loaders
{
   import alternativa.engine3d.core.Sprite3D;
   import alternativa.engine3d.loaders.TextureMapsLoader;
   import alternativa.engine3d.materials.SpriteTextureMaterial;
   import alternativa.types.Texture;
   import flash.display.BlendMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.LoaderContext;
   
   public class SpriteLoader extends ObjectLoader
   {
      private var file:String;
      
      private var alpha:String;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var scale:Number;
      
      private var loader:TextureMapsLoader;
      
      public var sprite:Sprite3D;
      
      public function SpriteLoader(param1:String, param2:String, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.file = param1;
         this.alpha = param2;
         this.originX = param3;
         this.originY = param4;
         this.scale = param5;
      }
      
      override public function load(param1:LoaderContext) : void
      {
         this.loader = new TextureMapsLoader(this.file,this.alpha,param1);
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
      }
      
      private function onLoadingComplete(param1:Event) : void
      {
         this.sprite = new Sprite3D();
         this.sprite.material = new SpriteTextureMaterial(new Texture(this.loader.bitmapData),1,true,BlendMode.NORMAL,this.originX,this.originY);
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

