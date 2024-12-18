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
         this.url = param1.length > 0 && param1.charAt(param1.length - 1) != "/" ? param1 + "/" : param1;
         this.configLoader = new URLLoader(new URLRequest(this.url + "library.xml"));
         this.configLoader.addEventListener(Event.COMPLETE,this.onXMLLoadingComplete);
         this.configLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
         this.configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
      }
      
      private function onErrorEvent(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onXMLLoadingComplete(param1:Event) : void
      {
         var loc2:XML = XML(this.configLoader.data);
         this.configLoader.removeEventListener(Event.COMPLETE,this.onXMLLoadingComplete);
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
            loc3.addProp(this.parseProp(loc2));
         }
         for each(loc2 in param1.elements("prop-group"))
         {
            loc3.addGroup(this.parseGroup(loc2));
         }
         return loc3;
      }
      
      private function parseProp(param1:XML) : PropLibObject
      {
         var loc2:ObjectLoaderPair = this.createObjectLoaderPair(param1);
         this.loaders.push(loc2);
         return loc2.propObject;
      }
      
      private function createObjectLoaderPair(param1:XML) : ObjectLoaderPair
      {
         if(param1.mesh.length() > 0)
         {
            return this.createMeshLoaderPair(param1);
         }
         if(param1.sprite.length() > 0)
         {
            return this.createSpriteLoaderPair(param1);
         }
         throw new Error("Unknown prop: " + param1);
      }
      
      private function createMeshLoaderPair(param1:XML) : ObjectLoaderPair
      {
         var loc3:Map = null;
         var loc5:XML = null;
         var loc6:String = null;
         var loc7:String = null;
         var loc2:XML = param1.mesh[0];
         if(loc2.texture.length() > 0)
         {
            loc3 = new Map();
            for each(loc5 in loc2.texture)
            {
               loc6 = loc5.attribute("diffuse-map").toString().toLowerCase();
               loc7 = xmlReadAttrString(loc5,"opacity-map");
               if(loc7 != null)
               {
                  loc7 = this.url + loc7.toLowerCase();
               }
               loc3.add(loc5.@name.toString(),new TextureMapsInfo(this.url + loc6,loc7));
            }
         }
         var loc4:ObjectLoaderPair = new ObjectLoaderPair();
         loc4.propObject = new PropLibMesh(param1.@name);
         loc4.loader = new MeshLoader(this.url + loc2.attribute("file").toString().toLowerCase(),xmlReadAttrString(loc2,"object"),loc3);
         return loc4;
      }
      
      private function createSpriteLoaderPair(param1:XML) : ObjectLoaderPair
      {
         var loc2:XML = param1.sprite[0];
         var loc3:String = xmlReadAttrString(loc2,"alpha");
         if(loc3 != null)
         {
            loc3 = this.url + loc3.toLowerCase();
         }
         var loc4:Number = xmlReadAttrNumber(loc2,"origin-x",0.5);
         var loc5:Number = xmlReadAttrNumber(loc2,"origin-y",1);
         var loc6:Number = xmlReadAttrNumber(loc2,"scale",1);
         var loc7:ObjectLoaderPair = new ObjectLoaderPair();
         loc7.propObject = new PropLibObject(param1.@name);
         loc7.loader = new SpriteLoader(this.url + loc2.attribute("file").toString().toLowerCase(),loc3,loc4,loc5,loc6);
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
