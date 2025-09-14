package alternativa.editor.propslib
{
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.net.URLRequest;
   import alternativa.editor.propslib.loaders.MeshLoader;
   import alternativa.types.Map;
   import alternativa.editor.engine3d.loaders.TextureMapsInfo;
   import alternativa.editor.propslib.events.PropLibProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ErrorEvent;
   import alternativa.editor.propslib.loaders.SpriteLoader;
   
   public class PropsLibrary extends EventDispatcher
   {
      public var name:String;
      public var rootGroup:PropGroup;

      private var _url:String;
      private var _propLoaders:Vector.<PropLoader> = new Vector.<PropLoader>();
      private var _propCount:int;
      private var _loadedPropCount:int = 0;

      public function PropsLibrary(url:String = null)
      {
         super();
         if(url != null) load(url);
      }
      
      public function load(url:String):void
      {
         if(url == null) throw new ArgumentError();
         _url = url + "/";
         trace(_url);

         var loader:URLLoader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.TEXT;
         loader.addEventListener(Event.COMPLETE, parseLibraryInfo);
         loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
         loader.load(new URLRequest(_url + "library.xml"));
      }

      private function onError(event:ErrorEvent):void
      {
         dispatchEvent(event);
      }

      private function parseLibraryInfo(event:Event):void
      {
         var loader:URLLoader = event.target as URLLoader;
         loader.removeEventListener(Event.COMPLETE, parseLibraryInfo);

         var libraryInfo:XML = new XML(loader.data);
         name = libraryInfo.@name;
         rootGroup = parsePropGroup(libraryInfo);

         // Load props
         _propCount = _propLoaders.length;
         for each (var propLoader:PropLoader in _propLoaders)
         {
            propLoader.addEventListener(Event.COMPLETE, onPropLoaded);
            propLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            propLoader.load();
         }
      }

      private function onPropLoaded(event:Event):void
      {
         var propLoader:PropLoader = event.target as PropLoader;
         propLoader.removeEventListener(Event.COMPLETE, onPropLoaded);
         _loadedPropCount++;
         
         dispatchEvent(new PropLibProgressEvent(_loadedPropCount, _propCount));
         if (_loadedPropCount == _propCount) dispatchEvent(new Event(Event.COMPLETE));
      }

      private function parsePropGroup(propGroupInfo:XML):PropGroup
      {
         var propGroup:PropGroup = new PropGroup(propGroupInfo.@name);
         for each(var propInfo:XML in propGroupInfo.prop)
         {
            var propLoader:PropLoader = parseProp(propInfo, propGroup);
            if (propLoader != null) _propLoaders.push(propLoader);
         }
         for each(var nestedPropGroupInfo:XML in propGroupInfo.elements("prop-group"))
         {
            var nestedPropGroup:PropGroup = parsePropGroup(nestedPropGroupInfo);
            propGroup.addGroup(nestedPropGroup);
         }
         
         return propGroup;
      }

      private function parseProp(propInfo:XML, propGroup:PropGroup):PropLoader
      {
         if (propInfo.hasOwnProperty("mesh"))
         {
            // Mesh prop
            var meshInfo:XML = propInfo.mesh[0];
            var meshProp:PropLibMesh = new PropLibMesh(propInfo.@name);
            
            // Parse <texture> elements
            var textureMap:Map = null;
            if (meshInfo.texture.length() > 0) textureMap = new Map();
            for each (var textureInfo:XML in meshInfo.texture)
            {
               var diffuseMapUrl:String = _url + textureInfo.attribute("diffuse-map").toLowerCase();
               var opacityMapUrl:String = null;
               if (textureInfo.attribute("opacity-map").length() > 0)
               {
                  opacityMapUrl = _url + textureInfo.attribute("opacity-map").toLowerCase();
               }

               var textureMapInfo:TextureMapsInfo = new TextureMapsInfo(diffuseMapUrl, opacityMapUrl);
               textureMap.add(textureInfo.@name.toString(), textureMapInfo);
            }
            
            // Create prop loader
            var meshFileUrl:String = _url + meshInfo.@file.toString().toLowerCase();
            var meshObject:String = null;
            if (meshInfo.@object.length() > 0) meshObject = meshInfo.@object.toString().toLowerCase();

            return new PropLoader(
               new MeshLoader(meshFileUrl, meshObject, textureMap, _url),
               meshProp,
               propGroup
            );
         }
         else if (propInfo.hasOwnProperty("sprite"))
         {
            // Sprite prop
            var spriteInfo:XML = propInfo.sprite[0];
            var spriteProp:PropLibObject = new PropLibObject(propInfo.@name);

            // Create prop loader
            var spriteFileUrl:String = _url + spriteInfo.@file.toString().toLowerCase();
            var alphaTextureUrl:String = null;
            if (spriteInfo.@alpha.length() > 0) alphaTextureUrl = _url + spriteInfo.@alpha.toString().toLowerCase();
            var originX:Number = 0.5;
            if (spriteInfo.attribute("origin-x").length() > 0) originX = spriteInfo.attribute("origin-x");
            var originY:Number = 1;
            if (spriteInfo.attribute("origin-y").length() > 0) originY = spriteInfo.attribute("origin-y");
            var scale:Number = 1;
            if (spriteInfo.@scale.length() > 0) scale = spriteInfo.attribute.@scale;
            trace(spriteInfo.@alpha);
            trace(alphaTextureUrl);

            return new PropLoader(
               new SpriteLoader(spriteFileUrl, alphaTextureUrl, originX, originY, scale),
               spriteProp,
               propGroup
            );
         }
         else
         {
            // Unknown prop
            throw new Error("Unknown prop: " + propInfo);
         }
      }
   }
}

import flash.net.URLLoader;
import flash.events.EventDispatcher;
import alternativa.editor.propslib.loaders.ObjectLoader;
import alternativa.editor.propslib.PropLibObject;
import alternativa.editor.propslib.PropGroup;
import flash.events.Event;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import alternativa.editor.propslib.PropLibMesh;
import alternativa.editor.propslib.loaders.SpriteLoader;
import alternativa.editor.propslib.loaders.MeshLoader;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;

class PropLoader extends EventDispatcher
{
   private static const _loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
   private var _loader:ObjectLoader;
   private var _object:PropLibObject;
   private var _group:PropGroup;

   public function PropLoader(loader:ObjectLoader, object:PropLibObject, group:PropGroup)
   {
      _loader = loader;
      _object = object;
      _group = group;
   }
   
   public function load():void
   {
      _loader.addEventListener(Event.COMPLETE, onPropLoadComplete);
      _loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
      _loader.load(_loaderContext);
   }

   private function onPropLoadComplete(event:Event):void
   {
      _loader.removeEventListener(Event.COMPLETE, onPropLoadComplete);
      if (_object is PropLibMesh)
      {
         var meshLoader:MeshLoader = _loader as MeshLoader;
         var meshObject:PropLibMesh = _object as PropLibMesh;
         meshObject.mainObject = meshLoader.object;
         meshObject.bitmaps = meshLoader.bitmaps;
         meshObject.objects = meshLoader.objects;
      }
      else
      {
         _object.mainObject = (_loader as SpriteLoader).sprite;         
      }
      _group.addProp(_object);
      dispatchEvent(new Event(Event.COMPLETE));
   }

   private function onError(event:ErrorEvent):void
   {
      dispatchEvent(event);
   }
}
