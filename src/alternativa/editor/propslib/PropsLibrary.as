package alternativa.editor.propslib
{
   import alternativa.editor.propslib.events.PropLibProgressEvent;
   import alternativa.editor.propslib.loaders.MeshLoader;
   import alternativa.editor.propslib.loaders.SpriteLoader;
   import alternativa.editor.engine3d.loaders.TextureMapsInfo;
   import alternativa.types.Map;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.net.URLLoaderDataFormat;
   
   public class PropsLibrary extends EventDispatcher
   {
      public var name:String;
      
      public var rootGroup:PropGroup;
      
      private var url:String;
      
      private var configLoader:URLLoader;
      
      private var loaders:Vector.<ObjectLoaderPair>;
      
      private var currLoader:ObjectLoaderPair;
      
      private var propsLoaded:int;
      
      private var propsTotal:int;

      private const _imagesRedirect:Dictionary = new Dictionary();
      
      public function PropsLibrary(param1:String = null)
      {
         super();
         if(param1 != null)
         {
            this.load(param1);
         }
      }
      
      private static function xmlReadAttrString(param1:XML, param2:String, param3:String = null) : String
      {
         var loc4:XMLList = param1.attribute(param2);
         if(loc4.length() > 0)
         {
            return loc4[0].toString();
         }
         return param3;
      }
      
      private static function xmlReadAttrNumber(param1:XML, param2:String, param3:Number) : Number
      {
         var loc4:XMLList = param1.attribute(param2);
         if(loc4.length() > 0)
         {
            return Number(loc4[0]);
         }
         return param3;
      }
      
      public function load(param1:String) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError();
         }
         this.url = (param1.length > 0 && param1.charAt(param1.length - 1) != "/" ? param1 + "/" : param1);
         this.configLoader = new URLLoader();
         this.configLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.tryLoadImagesXML();
      }

      private function tryLoadImagesXML() : void
      {
         this.configLoader.addEventListener(Event.COMPLETE,this.onImagesXMLLoadingComplete);
         this.configLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onImagesXMLLoadingFailed);
         this.configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImagesXMLLoadingFailed);
         this.configLoader.load(new URLRequest(this.url + "images.xml"));
      }
      
      private function onErrorEvent(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
      }

      private function onImagesXMLLoadingComplete(e:Event) : void
      {
         var imagesXML:XML = XML(this.configLoader.data);

         for each(var image:XML in imagesXML.image)
         {
            var originalName:String = image.@name;
            var diffuse:String = image.attribute("new-name").toString();
            var alpha:String = xmlReadAttrString(image, "alpha");

            _imagesRedirect[originalName] = new ImageData(diffuse, alpha);
         }

         loadLibraryXML();
      }
      private function onImagesXMLLoadingFailed(e:Event) : void
      {
         loadLibraryXML();
      }

      private function loadLibraryXML() : void
      {
         this.configLoader.removeEventListener(Event.COMPLETE,this.onImagesXMLLoadingComplete);
         this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onImagesXMLLoadingFailed);
         this.configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImagesXMLLoadingFailed);

         this.configLoader.addEventListener(Event.COMPLETE,this.onLibraryXMLLoadingComplete);
         this.configLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
         this.configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
         this.configLoader.load(new URLRequest(this.url + "library.xml"));
      }
      
      private function onLibraryXMLLoadingComplete(param1:Event) : void
      {
         var loc2:XML = XML(this.configLoader.data);
         this.configLoader.removeEventListener(Event.COMPLETE,this.onLibraryXMLLoadingComplete);
         this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
         this.configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
         this.configLoader = null;
         this.name = loc2.@name;
         this.loaders = new Vector.<ObjectLoaderPair>();
         this.rootGroup = this.parseGroup(loc2);
         this.propsLoaded = 0;
         this.propsTotal = this.loaders.length;
         this.loadPropObject();
      }
      
      private function loadPropObject() : void
      {
         this.currLoader = this.loaders.pop();
         this.currLoader.loader.addEventListener(Event.COMPLETE,this.onPropObjectLoadingComplete);
         this.currLoader.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
         this.currLoader.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
         var loc1:LoaderContext = new LoaderContext();
         loc1.applicationDomain = ApplicationDomain.currentDomain;
         this.currLoader.loader.load(loc1);
      }
      
      private function onPropObjectLoadingComplete(param1:Event) : void
      {
         var loc2:PropLibMesh = null;
         var loc3:MeshLoader = null;
         this.currLoader.loader.removeEventListener(Event.COMPLETE,this.onPropObjectLoadingComplete);
         this.currLoader.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
         this.currLoader.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
         if(this.currLoader.propObject is PropLibMesh)
         {
            loc2 = this.currLoader.propObject as PropLibMesh;
            loc3 = this.currLoader.loader as MeshLoader;
            loc2.mainObject = loc3.object;
            loc2.bitmaps = loc3.bitmaps;
            loc2.objects = loc3.objects;
         }
         else
         {
            this.currLoader.propObject.mainObject = (this.currLoader.loader as SpriteLoader).sprite;
         }
         ++this.propsLoaded;
         if(hasEventListener(PropLibProgressEvent.PROGRESS))
         {
            dispatchEvent(new PropLibProgressEvent(this.propsLoaded,this.propsTotal));
         }
         if(this.loaders.length > 0)
         {
            this.loadPropObject();
         }
         else
         {
            this.currLoader = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function parseGroup(param1:XML) : PropGroup
      {
         var loc2:XML = null;
         var loc3:PropGroup = new PropGroup(param1.@name);
         for each(loc2 in param1.prop)
         {
            loc3.addProp(this.parseProp(loc2, loc3.name));
         }
         for each(loc2 in param1.elements("prop-group"))
         {
            loc3.addGroup(this.parseGroup(loc2));
         }
         return loc3;
      }
      
      private function parseProp(param1:XML, groupName:String) : PropLibObject
      {
         var loc2:ObjectLoaderPair = this.createObjectLoaderPair(param1, groupName);
         this.loaders.push(loc2);
         return loc2.propObject;
      }
      
      private function createObjectLoaderPair(param1:XML, groupName:String) : ObjectLoaderPair
      {
         if(param1.mesh.length() > 0)
         {
            return this.createMeshLoaderPair(param1, groupName);
         }
         if(param1.sprite.length() > 0)
         {
            return this.createSpriteLoaderPair(param1, groupName);
         }
         throw new Error("Unknown prop: " + param1);
      }
      
      private function createMeshLoaderPair(param1:XML, groupName:String) : ObjectLoaderPair
      {
         var loc3:Map = null;
         var loc5:XML = null;
         var loc2:XML = param1.mesh[0];
         var propName:String = param1.@name;
         if(loc2.texture.length() > 0)
         {
            loc3 = new Map();
            for each(loc5 in loc2.texture)
            {
               var textureName:String = loc5.@name.toString();

               var diffuseName:String = loc5.attribute("diffuse-map").toString().toLowerCase();
               TextureDiffuseMapsRegistry.addTexture(this.name, groupName, propName, textureName, diffuseName);

               var alphaName:String = xmlReadAttrString(loc5,"opacity-map");

               var replacement:ImageData = _imagesRedirect[diffuseName];
               if(replacement != null)
               {
                  diffuseName = replacement.diffuseName;
                  alphaName = replacement.alphaName;
               }

               if(alphaName != null)
               {
                  alphaName = this.url + alphaName.toLowerCase();
               }
               loc3.add(textureName, new TextureMapsInfo(this.url + diffuseName,alphaName));
            }
         }
         var loc4:ObjectLoaderPair = new ObjectLoaderPair();
         loc4.propObject = new PropLibMesh(propName);
         loc4.loader = new MeshLoader(this.url + loc2.attribute("file").toString().toLowerCase(),xmlReadAttrString(loc2,"object"),loc3,this.url,
               this.name, groupName, propName, _imagesRedirect);
         return loc4;
      }
      
      private function createSpriteLoaderPair(param1:XML, groupName:String) : ObjectLoaderPair
      {
         var loc2:XML = param1.sprite[0];

         var diffuseName:String = loc2.attribute("file").toString().toLowerCase();
         var alphaName:String = null;

         var replacement:ImageData = _imagesRedirect[diffuseName];
         if(replacement != null)
         {
            diffuseName = replacement.diffuseName;
            alphaName = replacement.alphaName;
         }
         else
         {
            alphaName = xmlReadAttrString(loc2,"alpha");
            if(alphaName != null)
            {
               alphaName = alphaName.toLowerCase();
            }
         }

         var loc4:Number = xmlReadAttrNumber(loc2,"origin-x",0.5);
         var loc5:Number = xmlReadAttrNumber(loc2,"origin-y",1);
         var loc6:Number = xmlReadAttrNumber(loc2,"scale",1);

         var propName:String = param1.@name;

         var loc7:ObjectLoaderPair = new ObjectLoaderPair();
         loc7.propObject = new PropLibObject(propName);
         loc7.loader = new SpriteLoader(this.url, diffuseName, alphaName,loc4,loc5,loc6,
            this.name, groupName, propName);

         return loc7;
      }
   }
}

import alternativa.editor.propslib.loaders.ObjectLoader;
import alternativa.editor.propslib.PropLibObject;

class ObjectLoaderPair
{
   public var propObject:PropLibObject;
   
   public var loader:ObjectLoader;
   
   public function ObjectLoaderPair()
   {
      super();
   }
}
