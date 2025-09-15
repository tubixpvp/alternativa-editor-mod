package alternativa.editor.propslib.loaders
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Map;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.system.LoaderContext;
   import flash.net.URLLoader;
   import alternativa.engine3d.loaders.Parser3DS;
   import flash.net.URLRequest;
   import flash.net.URLLoaderDataFormat;
   import alternativa.engine3d.core.Face;
   import alternativa.editor.engine3d.loaders.TextureMapsBatchLoader;
   import alternativa.engine3d.core.Object3D;
   import alternativa.editor.engine3d.loaders.TextureMapsInfo;
   import mx.controls.Alert;
   import flash.display.BitmapData;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.editor.propslib.TextureDiffuseMapsRegistry;
   
   public class MeshLoader extends ObjectLoader
   {
      public var object:Mesh;
      public var objects:Vector.<Object3D>;
      
      public var bitmaps:Map;
      
      private var url:String;
      
      private var objectName:String;
      
      private var textures:Map;
      
      private var loader3DS:URLLoader;
      private const parser3DS:Parser3DS = new Parser3DS();
      
      private var texturesLoader:TextureMapsBatchLoader;
      
      private var loaderContext:LoaderContext;

      private var baseUrl:String;

      private var libraryName:String;

      private var groupName:String;

      private var propName:String;
      
      public function MeshLoader(param1:String, param2:String, param3:Map, baseUrl:String,
         libraryName:String, groupName:String, propName:String)
      {
         super();
         this.url = param1;
         this.objectName = param2;
         this.textures = param3;
         this.baseUrl = baseUrl;
         this.libraryName = libraryName;
         this.groupName = groupName;
         this.propName = propName;
      }
      
      override public function load(param1:LoaderContext) : void
      {
         this.loaderContext = param1;
         this.loader3DS = new URLLoader();
         this.loader3DS.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader3DS.addEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader3DS.addEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.loader3DS.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onErrorEvent);
         //this.loader3DS.smooth = true;
         //this.loader3DS.repeat = false;
         //this.loader3DS.load(this.url,param1);
         this.loader3DS.load(new URLRequest(this.url));
      }
      
      private function on3DSLoadingComplete(param1:Event) : void
      {
         this.parser3DS.parse(this.loader3DS.data);

         this.loader3DS.removeEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader3DS.removeEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.loader3DS.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onErrorEvent);
         this.loader3DS = null;

         if(this.objectName != null)
         {
            this.object = this.parser3DS.getObjectByName(this.objectName) as Mesh;
         }
         else
         {
            this.object = this.parser3DS.objects[0] as Mesh;
         }

         //'child' objects for old engine
         this.objects = this.parser3DS.objects.concat();
         this.objects.removeAt(this.objects.indexOf(this.object));

         if(this.textures == null && this.parser3DS.textureMaterials.length > 0)
         {
            var defaultMaterial:TextureMaterial = this.parser3DS.textureMaterials[0];
            this.textures = new Map();
            var opacityUrl:String = (defaultMaterial.opacityMapURL != null ? this.baseUrl + defaultMaterial.opacityMapURL.toLowerCase() : null);
            var diffuseUrl:String = defaultMaterial.diffuseMapURL.toLowerCase();
            TextureDiffuseMapsRegistry.addTexture(libraryName, groupName, propName, "DEFAULT", diffuseUrl);
            this.textures.add("DEFAULT", new TextureMapsInfo(this.baseUrl+diffuseUrl, opacityUrl));
         }
         
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
         var loc2:Face = loc1.faceList;
         var loc3:TextureMaterial = loc2.material as TextureMaterial;
         if(loc3 != null)
         {
            this.bitmaps = new Map();
            this.bitmaps.add("DEFAULT",loc3.texture);
         }
      }
      
      private function onTexturesLoadingComplete(param1:Event) : void
      {
         this.bitmaps = this.texturesLoader.textures;
         this.texturesLoader.removeEventListener(Event.COMPLETE,this.onTexturesLoadingComplete);
         this.texturesLoader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorEvent);
         this.texturesLoader = null;

         if(this.object.faceList.material is FillMaterial)
         {
            this.object.setMaterialToAllFaces(null);
         }

         var defaultTexture:BitmapData = this.bitmaps["DEFAULT"];
         if(defaultTexture != null)
         {
            this.object.setMaterialToAllFaces(new TextureMaterial(defaultTexture));
         }
         else if(this.bitmaps.length == 0)
         {
            Alert.show("no textures: " + toString());
         }

         complete();
      }
      
      override public function toString() : String
      {
         return "[MeshLoader url=" + this.url + ", objectName=" + this.objectName + ", textures=" + this.textures + "]";
      }
   }
}

