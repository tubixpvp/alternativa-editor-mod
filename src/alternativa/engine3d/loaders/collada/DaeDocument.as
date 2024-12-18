package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace collada;
   use namespace alternativa3d;
   use namespace daeAlternativa3DLibrary;
   
   public class DaeDocument
   {
       
      
      public var scene:DaeVisualScene;
      
      private var data:XML;
      
      public var sources:Object;
      
      public var arrays:Object;
      
      public var vertices:Object;
      
      public var geometries:Object;
      
      public var nodes:Object;
      
      public var lights:Object;
      
      public var images:Object;
      
      public var effects:Object;
      
      public var controllers:Object;
      
      public var samplers:Object;
      
      public var alternativa3DObjects:Object;
      
      public var materials:Object;
      
      public var logger:DaeLogger;
      
      public var versionMajor:uint;
      
      public var versionMinor:uint;
      
      public var alternativa3DExtensionVersionMajor:uint = 0;
      
      public var alternativa3DExtensionVersionMinor:uint = 0;
      
      public function DaeDocument(param1:XML)
      {
         super();
         this.data = param1;
         var _loc2_:Array = this.data.@version[0].toString().split(/[.,]/);
         this.versionMajor = parseInt(_loc2_[1],10);
         this.versionMinor = parseInt(_loc2_[2],10);
         this.logger = new DaeLogger();
         this.constructStructures();
         this.constructScenes();
         this.registerInstanceControllers();
         this.constructAnimations();
         this.constructAlternativa3DObjects();
      }
      
      private function getLocalID(param1:XML) : String
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.charAt(0) == "#")
         {
            return _loc2_.substr(1);
         }
         this.logger.logExternalError(param1);
         return null;
      }
      
      private function constructStructures() : void
      {
         var _loc1_:XML = null;
         var _loc2_:DaeSource = null;
         var _loc3_:DaeLight = null;
         var _loc4_:DaeImage = null;
         var _loc5_:DaeEffect = null;
         var _loc6_:DaeMaterial = null;
         var _loc7_:DaeGeometry = null;
         var _loc8_:DaeController = null;
         var _loc9_:DaeNode = null;
         this.sources = new Object();
         this.arrays = new Object();
         for each(_loc1_ in this.data..source)
         {
            _loc2_ = new DaeSource(_loc1_,this);
            if(_loc2_.id != null)
            {
               this.sources[_loc2_.id] = _loc2_;
            }
         }
         this.lights = new Object();
         for each(_loc1_ in this.data.library_lights.light)
         {
            _loc3_ = new DaeLight(_loc1_,this);
            if(_loc3_.id != null)
            {
               this.lights[_loc3_.id] = _loc3_;
            }
         }
         this.images = new Object();
         for each(_loc1_ in this.data.library_images.image)
         {
            _loc4_ = new DaeImage(_loc1_,this);
            if(_loc4_.id != null)
            {
               this.images[_loc4_.id] = _loc4_;
            }
         }
         this.effects = new Object();
         for each(_loc1_ in this.data.library_effects.effect)
         {
            _loc5_ = new DaeEffect(_loc1_,this);
            if(_loc5_.id != null)
            {
               this.effects[_loc5_.id] = _loc5_;
            }
         }
         this.materials = new Object();
         for each(_loc1_ in this.data.library_materials.material)
         {
            _loc6_ = new DaeMaterial(_loc1_,this);
            if(_loc6_.id != null)
            {
               this.materials[_loc6_.id] = _loc6_;
            }
         }
         this.geometries = new Object();
         this.vertices = new Object();
         for each(_loc1_ in this.data.library_geometries.geometry)
         {
            _loc7_ = new DaeGeometry(_loc1_,this);
            if(_loc7_.id != null)
            {
               this.geometries[_loc7_.id] = _loc7_;
            }
         }
         this.controllers = new Object();
         for each(_loc1_ in this.data.library_controllers.controller)
         {
            _loc8_ = new DaeController(_loc1_,this);
            if(_loc8_.id != null)
            {
               this.controllers[_loc8_.id] = _loc8_;
            }
         }
         this.nodes = new Object();
         for each(_loc1_ in this.data.library_nodes.node)
         {
            _loc9_ = new DaeNode(_loc1_,this);
            if(_loc9_.id != null)
            {
               this.nodes[_loc9_.id] = _loc9_;
            }
         }
      }
      
      private function constructScenes() : void
      {
         var _loc3_:XML = null;
         var _loc4_:DaeVisualScene = null;
         var _loc1_:XML = this.data.scene.instance_visual_scene.@url[0];
         var _loc2_:String = this.getLocalID(_loc1_);
         for each(_loc3_ in this.data.library_visual_scenes.visual_scene)
         {
            _loc4_ = new DaeVisualScene(_loc3_,this);
            if(_loc4_.id == _loc2_)
            {
               this.scene = _loc4_;
            }
         }
         if(_loc2_ != null && this.scene == null)
         {
            this.logger.logNotFoundError(_loc1_);
         }
      }
      
      private function registerInstanceControllers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.scene != null)
         {
            _loc1_ = 0;
            _loc2_ = this.scene.nodes.length;
            while(_loc1_ < _loc2_)
            {
               this.scene.nodes[_loc1_].registerInstanceControllers();
               _loc1_++;
            }
         }
      }
      
      private function constructAnimations() : void
      {
         var _loc1_:XML = null;
         var _loc2_:DaeSampler = null;
         var _loc3_:DaeChannel = null;
         var _loc4_:DaeNode = null;
         this.samplers = new Object();
         for each(_loc1_ in this.data.library_animations..sampler)
         {
            _loc2_ = new DaeSampler(_loc1_,this);
            if(_loc2_.id != null)
            {
               this.samplers[_loc2_.id] = _loc2_;
            }
         }
         for each(_loc1_ in this.data.library_animations..channel)
         {
            _loc3_ = new DaeChannel(_loc1_,this);
            _loc4_ = _loc3_.node;
            if(_loc4_ != null)
            {
               _loc4_.addChannel(_loc3_);
            }
         }
      }
      
      private function constructAlternativa3DObjects() : void
      {
         var alternativa3dXML:XML = null;
         var versionComponents:Array = null;
         var element:XML = null;
         var object:DaeAlternativa3DObject = null;
         this.alternativa3DObjects = new Object();
         alternativa3dXML = this.data.extra.technique.(@profile = "Alternativa3D").library[0];
         if(alternativa3dXML != null)
         {
            versionComponents = alternativa3dXML.version[0].text().toString().split(/[.,]/);
            this.alternativa3DExtensionVersionMajor = parseInt(versionComponents[0],10);
            this.alternativa3DExtensionVersionMinor = parseInt(versionComponents[1],10);
            for each(element in alternativa3dXML.library_containers.children())
            {
               object = new DaeAlternativa3DObject(element,this);
               if(object.id != null)
               {
                  this.alternativa3DObjects[object.id] = object;
               }
            }
            for each(element in alternativa3dXML.library_sprites.sprite)
            {
               object = new DaeAlternativa3DObject(element,this);
               if(object.id != null)
               {
                  this.alternativa3DObjects[object.id] = object;
               }
            }
            for each(element in alternativa3dXML.library_lods.lod)
            {
               object = new DaeAlternativa3DObject(element,this);
               if(object.id != null)
               {
                  this.alternativa3DObjects[object.id] = object;
               }
            }
            for each(element in alternativa3dXML.library_meshes.mesh)
            {
               object = new DaeAlternativa3DObject(element,this);
               if(object.id != null)
               {
                  this.alternativa3DObjects[object.id] = object;
               }
            }
         }
         else
         {
            this.alternativa3DExtensionVersionMajor = this.alternativa3DExtensionVersionMinor = 0;
         }
      }
      
      public function findArray(param1:XML) : DaeArray
      {
         return this.arrays[this.getLocalID(param1)];
      }
      
      public function findSource(param1:XML) : DaeSource
      {
         return this.sources[this.getLocalID(param1)];
      }
      
      public function findLight(param1:XML) : DaeLight
      {
         return this.lights[this.getLocalID(param1)];
      }
      
      public function findImage(param1:XML) : DaeImage
      {
         return this.images[this.getLocalID(param1)];
      }
      
      public function findImageByID(param1:String) : DaeImage
      {
         return this.images[param1];
      }
      
      public function findEffect(param1:XML) : DaeEffect
      {
         return this.effects[this.getLocalID(param1)];
      }
      
      public function findMaterial(param1:XML) : DaeMaterial
      {
         return this.materials[this.getLocalID(param1)];
      }
      
      public function findVertices(param1:XML) : DaeVertices
      {
         return this.vertices[this.getLocalID(param1)];
      }
      
      public function findGeometry(param1:XML) : DaeGeometry
      {
         return this.geometries[this.getLocalID(param1)];
      }
      
      public function findNode(param1:XML) : DaeNode
      {
         return this.nodes[this.getLocalID(param1)];
      }
      
      public function findNodeByID(param1:String) : DaeNode
      {
         return this.nodes[param1];
      }
      
      public function findController(param1:XML) : DaeController
      {
         return this.controllers[this.getLocalID(param1)];
      }
      
      public function findSampler(param1:XML) : DaeSampler
      {
         return this.samplers[this.getLocalID(param1)];
      }
      
      public function findAlternativa3DObject(param1:XML) : DaeAlternativa3DObject
      {
         return this.alternativa3DObjects[this.getLocalID(param1)];
      }
   }
}
