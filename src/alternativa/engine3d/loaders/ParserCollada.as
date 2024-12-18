package alternativa.engine3d.loaders
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.animation.AnimationClip;
   import alternativa.engine3d.animation.keys.Track;
   import alternativa.engine3d.containers.LODContainer;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.loaders.collada.DaeDocument;
   import alternativa.engine3d.loaders.collada.DaeMaterial;
   import alternativa.engine3d.loaders.collada.DaeNode;
   import alternativa.engine3d.loaders.collada.DaeObject;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class ParserCollada
   {
      
      public static const STATIC_OBJECT:uint = 0;
      
      public static const STATIC_GEOMETRY:uint = 1;
      
      public static const SPLITTER:uint = 2;
       
      
      public var objects:Vector.<Object3D>;
      
      public var parents:Vector.<Object3D>;
      
      public var hierarchy:Vector.<Object3D>;
      
      public var lights:Vector.<Light3D>;
      
      public var materials:Vector.<Material>;
      
      public var textureMaterials:Vector.<TextureMaterial>;
      
      public var animations:Vector.<AnimationClip>;
      
      private var layers:Dictionary;
      
      private var bspContainerChildrenTypes:Dictionary;
      
      public function ParserCollada()
      {
         super();
      }
      
      public static function parseAnimation(param1:XML) : AnimationClip
      {
         var _loc2_:DaeDocument = new DaeDocument(param1);
         var _loc3_:AnimationClip = new AnimationClip();
         collectAnimation(_loc3_,_loc2_.scene.nodes);
         return _loc3_.numTracks > 0?_loc3_:null;
      }
      
      private static function collectAnimation(param1:AnimationClip, param2:Vector.<DaeNode>) : void
      {
         var _loc5_:DaeNode = null;
         var _loc6_:AnimationClip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Track = null;
         var _loc3_:int = 0;
         var _loc4_:int = param2.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param2[_loc3_];
            _loc6_ = _loc5_.parseAnimation();
            if(_loc6_ != null)
            {
               _loc7_ = 0;
               _loc8_ = _loc6_.numTracks;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc6_.getTrackAt(_loc7_);
                  param1.addTrack(_loc9_);
                  _loc7_++;
               }
            }
            else
            {
               param1.addTrack(_loc5_.createStaticTransformTrack());
            }
            collectAnimation(param1,_loc5_.nodes);
            _loc3_++;
         }
      }
      
      public function clean() : void
      {
         this.objects = null;
         this.parents = null;
         this.hierarchy = null;
         this.lights = null;
         this.animations = null;
         this.materials = null;
         this.textureMaterials = null;
         this.layers = null;
         this.bspContainerChildrenTypes = null;
      }
      
      public function getObjectLayer(param1:Object3D) : String
      {
         return this.layers[param1];
      }
      
      public function getBspContainerChildType(param1:Object3D) : uint
      {
         return this.bspContainerChildrenTypes[param1];
      }
      
      private function init(param1:XML) : DaeDocument
      {
         this.clean();
         this.objects = new Vector.<Object3D>();
         this.parents = new Vector.<Object3D>();
         this.hierarchy = new Vector.<Object3D>();
         this.lights = new Vector.<Light3D>();
         this.animations = new Vector.<AnimationClip>();
         this.materials = new Vector.<Material>();
         this.textureMaterials = new Vector.<TextureMaterial>();
         this.layers = new Dictionary();
         this.bspContainerChildrenTypes = new Dictionary();
         return new DaeDocument(param1);
      }
      
      public function parse(param1:XML, param2:String = null, param3:Boolean = false) : void
      {
         var _loc4_:DaeDocument = this.init(param1);
         if(_loc4_.scene != null)
         {
            this.parseNodes(_loc4_.scene.nodes,null,false);
            this.parseMaterials(_loc4_.materials,param2,param3);
         }
      }
      
      private function hasSignifiantChildren(param1:DaeNode, param2:Boolean) : Boolean
      {
         var _loc6_:DaeNode = null;
         var _loc3_:Vector.<DaeNode> = param1.nodes;
         var _loc4_:int = 0;
         var _loc5_:int = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc6_.parse();
            if(_loc6_.skins != null)
            {
               return true;
            }
            if(_loc6_.skinOrTopmostJoint == false)
            {
               if(param2 == false)
               {
                  return true;
               }
            }
            if(this.hasSignifiantChildren(_loc6_,true))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function addObject(param1:DaeObject, param2:Object3D, param3:String) : Object3D
      {
         var _loc6_:LODContainer = null;
         var _loc7_:Number = NaN;
         var _loc4_:Object3D = param1.object as Object3D;
         this.objects.push(_loc4_);
         this.parents.push(param2);
         if(param2 == null)
         {
            this.hierarchy.push(_loc4_);
         }
         var _loc5_:Object3DContainer = param2 as Object3DContainer;
         if(_loc5_ != null)
         {
            _loc5_.addChild(_loc4_);
            _loc6_ = _loc5_ as LODContainer;
            if(_loc6_ != null)
            {
               _loc7_ = param1.lodDistance;
               if(_loc7_ != 0)
               {
                  _loc6_.setChildDistance(_loc4_,_loc7_);
               }
            }
         }
         if(_loc4_ is Light3D)
         {
            this.lights.push(Light3D(_loc4_));
         }
         if(param1.animation != null)
         {
            this.animations.push(param1.animation);
         }
         if(param3)
         {
            this.layers[_loc4_] = param3;
         }
         if(param1.isStaticGeometry)
         {
            this.bspContainerChildrenTypes[_loc4_] = STATIC_GEOMETRY;
         }
         else if(param1.isSplitter)
         {
            this.bspContainerChildrenTypes[_loc4_] = SPLITTER;
         }
         return _loc4_;
      }
      
      private function addObjects(param1:Vector.<DaeObject>, param2:Object3D, param3:String) : Object3D
      {
         var _loc4_:Object3D = this.addObject(param1[0],param2,param3);
         var _loc5_:int = 1;
         var _loc6_:int = param1.length;
         while(_loc5_ < _loc6_)
         {
            this.addObject(param1[_loc5_],param2,param3);
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function parseNodes(param1:Vector.<DaeNode>, param2:Object3DContainer, param3:Boolean = false) : void
      {
         var _loc6_:DaeNode = null;
         var _loc7_:Object3DContainer = null;
         var _loc8_:Boolean = false;
         var _loc9_:Object3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = param1.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1[_loc4_];
            _loc6_.parse();
            _loc7_ = null;
            _loc8_ = false;
            if(_loc6_.skins != null)
            {
               this.addObjects(_loc6_.skins,param2,_loc6_.layer);
            }
            else if(param3 == false && _loc6_.skinOrTopmostJoint == false)
            {
               if(_loc6_.objects != null)
               {
                  _loc7_ = this.addObjects(_loc6_.objects,param2,_loc6_.layer) as Object3DContainer;
               }
               else
               {
                  _loc8_ = true;
               }
            }
            if(_loc7_ == null)
            {
               if(this.hasSignifiantChildren(_loc6_,param3 || _loc6_.skinOrTopmostJoint))
               {
                  _loc7_ = new Object3DContainer();
                  _loc7_.name = _loc6_.name;
                  this.addObject(_loc6_.applyAnimation(_loc6_.applyTransformations(_loc7_)),param2,_loc6_.layer);
                  this.parseNodes(_loc6_.nodes,_loc7_,param3 || _loc6_.skinOrTopmostJoint);
                  _loc7_.calculateBounds();
               }
               else if(_loc8_)
               {
                  _loc9_ = new Object3D();
                  _loc9_.name = _loc6_.name;
                  this.addObject(_loc6_.applyAnimation(_loc6_.applyTransformations(_loc9_)),param2,_loc6_.layer);
               }
            }
            else
            {
               this.parseNodes(_loc6_.nodes,_loc7_,param3 || _loc6_.skinOrTopmostJoint);
               _loc7_.calculateBounds();
            }
            _loc4_++;
         }
      }
      
      private function trimPath(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/");
         return _loc2_ < 0?param1:param1.substr(_loc2_ + 1);
      }
      
      private function parseMaterials(param1:Object, param2:String, param3:Boolean) : void
      {
         var _loc4_:TextureMaterial = null;
         var _loc5_:DaeMaterial = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         for each(_loc5_ in param1)
         {
            if(_loc5_.used)
            {
               _loc5_.parse();
               this.materials.push(_loc5_.material);
               _loc4_ = _loc5_.material as TextureMaterial;
               if(_loc4_ != null)
               {
                  this.textureMaterials.push(_loc4_);
               }
            }
         }
         if(param3)
         {
            for each(_loc4_ in this.textureMaterials)
            {
               if(_loc4_.diffuseMapURL != null)
               {
                  _loc4_.diffuseMapURL = this.trimPath(this.fixURL(_loc4_.diffuseMapURL));
               }
               if(_loc4_.opacityMapURL != null)
               {
                  _loc4_.opacityMapURL = this.trimPath(this.fixURL(_loc4_.opacityMapURL));
               }
            }
         }
         else
         {
            for each(_loc4_ in this.textureMaterials)
            {
               if(_loc4_.diffuseMapURL != null)
               {
                  _loc4_.diffuseMapURL = this.fixURL(_loc4_.diffuseMapURL);
               }
               if(_loc4_.opacityMapURL != null)
               {
                  _loc4_.opacityMapURL = this.fixURL(_loc4_.opacityMapURL);
               }
            }
         }
         if(param2 != null)
         {
            param2 = this.fixURL(param2);
            _loc7_ = param2.lastIndexOf("/");
            _loc6_ = _loc7_ < 0?"":param2.substr(0,_loc7_);
            for each(_loc4_ in this.textureMaterials)
            {
               if(_loc4_.diffuseMapURL != null)
               {
                  _loc4_.diffuseMapURL = this.resolveURL(_loc4_.diffuseMapURL,_loc6_);
               }
               if(_loc4_.opacityMapURL != null)
               {
                  _loc4_.opacityMapURL = this.resolveURL(_loc4_.opacityMapURL,_loc6_);
               }
            }
         }
      }
      
      private function fixURL(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("://");
         _loc2_ = _loc2_ < 0?int(0):int(_loc2_ + 3);
         var _loc3_:int = param1.indexOf("?",_loc2_);
         _loc3_ = _loc3_ < 0?int(param1.indexOf("#",_loc2_)):int(_loc3_);
         var _loc4_:String = param1.substring(_loc2_,_loc3_ < 0?Number(2147483647):Number(_loc3_));
         _loc4_ = _loc4_.replace(/\\/g,"/");
         var _loc5_:int = param1.indexOf("file://");
         if(_loc5_ >= 0)
         {
            if(param1.charAt(_loc2_) == "/")
            {
               return "file://" + _loc4_ + (_loc3_ >= 0?param1.substring(_loc3_):"");
            }
            return "file:///" + _loc4_ + (_loc3_ >= 0?param1.substring(_loc3_):"");
         }
         return param1.substring(0,_loc2_) + _loc4_ + (_loc3_ >= 0?param1.substring(_loc3_):"");
      }
      
      private function mergePath(param1:String, param2:String, param3:Boolean = false) : String
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc4_:Array = param2.split("/");
         var _loc5_:Array = param1.split("/");
         var _loc6_:int = 0;
         var _loc7_:int = _loc5_.length;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc5_[_loc6_];
            if(_loc8_ == "..")
            {
               _loc9_ = _loc4_.pop();
               while(_loc9_ == "." || _loc9_ == "" && _loc9_ != null)
               {
                  _loc9_ = _loc4_.pop();
               }
               if(param3)
               {
                  if(_loc9_ == "..")
                  {
                     _loc4_.push("..","..");
                  }
                  else if(_loc9_ == null)
                  {
                     _loc4_.push("..");
                  }
               }
            }
            else
            {
               _loc4_.push(_loc8_);
            }
            _loc6_++;
         }
         return _loc4_.join("/");
      }
      
      private function resolveURL(param1:String, param2:String) : String
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         if(param2 == "")
         {
            return param1;
         }
         if(param1.charAt(0) == "." && param1.charAt(1) == "/")
         {
            return param2 + param1.substr(1);
         }
         if(param1.charAt(0) == "/")
         {
            return param1;
         }
         if(param1.charAt(0) == "." && param1.charAt(1) == ".")
         {
            _loc5_ = param1.indexOf("?");
            _loc5_ = _loc5_ < 0?int(param1.indexOf("#")):int(_loc5_);
            if(_loc5_ < 0)
            {
               _loc7_ = "";
               _loc6_ = param1;
            }
            else
            {
               _loc7_ = param1.substring(_loc5_);
               _loc6_ = param1.substring(0,_loc5_);
            }
            _loc9_ = param2.indexOf("/");
            _loc10_ = param2.indexOf(":");
            _loc11_ = param2.indexOf("//");
            if(_loc11_ < 0 || _loc11_ > _loc9_)
            {
               if(_loc10_ >= 0 && _loc10_ < _loc9_)
               {
                  _loc12_ = param2.substring(0,_loc10_ + 1);
                  _loc8_ = param2.substring(_loc10_ + 1);
                  if(_loc8_.charAt(0) == "/")
                  {
                     return _loc12_ + "/" + this.mergePath(_loc6_,_loc8_.substring(1),false) + _loc7_;
                  }
                  return _loc12_ + this.mergePath(_loc6_,_loc8_,false) + _loc7_;
               }
               if(param2.charAt(0) == "/")
               {
                  return "/" + this.mergePath(_loc6_,param2.substring(1),false) + _loc7_;
               }
               return this.mergePath(_loc6_,param2,true) + _loc7_;
            }
            _loc9_ = param2.indexOf("/",_loc11_ + 2);
            if(_loc9_ >= 0)
            {
               _loc13_ = param2.substring(0,_loc9_ + 1);
               _loc8_ = param2.substring(_loc9_ + 1);
               return _loc13_ + this.mergePath(_loc6_,_loc8_,false) + _loc7_;
            }
            _loc13_ = param2;
            return _loc13_ + "/" + this.mergePath(_loc6_,"",false);
         }
         var _loc3_:int = param1.indexOf(":");
         var _loc4_:int = param1.indexOf("/");
         if(_loc3_ >= 0 && (_loc3_ < _loc4_ || _loc4_ < 0))
         {
            return param1;
         }
         return param2 + "/" + param1;
      }
      
      public function getObjectByName(param1:String) : Object3D
      {
         var _loc2_:Object3D = null;
         for each(_loc2_ in this.objects)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getAnimationByObject(param1:Object) : AnimationClip
      {
         var _loc2_:AnimationClip = null;
         var _loc3_:Array = null;
         for each(_loc2_ in this.animations)
         {
            _loc3_ = _loc2_._objects;
            if(_loc3_.indexOf(param1) >= 0)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}
