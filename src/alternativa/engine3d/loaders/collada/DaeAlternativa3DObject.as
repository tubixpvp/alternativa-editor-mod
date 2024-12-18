package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.containers.BSPContainer;
   import alternativa.engine3d.containers.ConflictContainer;
   import alternativa.engine3d.containers.DistanceSortContainer;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.containers.LODContainer;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   
   use namespace collada;
   use namespace alternativa3d;
   use namespace daeAlternativa3DLibrary;
   use namespace daeAlternativa3DMesh;
   
   public class DaeAlternativa3DObject extends DaeElement
   {
       
      
      public var isSplitter:Boolean = false;
      
      public var isBaseGeometry:Boolean = false;
      
      public function DaeAlternativa3DObject(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
      }
      
      override protected function parseImplementation() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         if(data.localName() == "mesh")
         {
            _loc2_ = data.baseGeometry[0];
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_.toString();
               this.isBaseGeometry = _loc1_ == "true" || parseInt(_loc1_) != 0;
            }
            _loc3_ = data.splitter[0];
            if(_loc3_ != null)
            {
               _loc1_ = _loc3_.toString();
               this.isSplitter = _loc1_ == "true" || parseInt(_loc1_) != 0;
            }
         }
         return true;
      }
      
      public function parseContainer(param1:String) : Object3DContainer
      {
         var _loc2_:Object3DContainer = null;
         var _loc3_:XML = null;
         switch(data.localName())
         {
            case "object3d":
               _loc2_ = new Object3DContainer();
               _loc2_.name = param1;
               return this.setParams(_loc2_);
            case "distanceSort":
               _loc2_ = new DistanceSortContainer();
               _loc2_.name = param1;
               return this.setParams(_loc2_);
            case "conflict":
               _loc2_ = new ConflictContainer();
               _loc2_.name = param1;
               return this.setParams(_loc2_);
            case "kdTree":
               _loc2_ = new KDContainer();
               _loc2_.name = param1;
               return this.setParams(_loc2_);
            case "bspTree":
               _loc2_ = new BSPContainer();
               _loc3_ = data.clipping[0];
               if(_loc3_ != null)
               {
                  (_loc2_ as BSPContainer).clipping = this.getClippingValue(_loc3_);
               }
               _loc2_.name = param1;
               return this.setParams(_loc2_);
            default:
               return null;
         }
      }
      
      private function getClippingValue(param1:XML) : int
      {
         switch(param1.toString())
         {
            case "BOUND_CULLING":
               return Clipping.BOUND_CULLING;
            case "FACE_CULLING":
               return Clipping.FACE_CULLING;
            case "FACE_CLIPPING":
               return Clipping.FACE_CLIPPING;
            default:
               return Clipping.BOUND_CULLING;
         }
      }
      
      private function getSortingValue(param1:XML) : int
      {
         switch(param1.toString())
         {
            case "STATIC_BSP":
               return 3;
            case "DYNAMIC_BSP":
               return Sorting.DYNAMIC_BSP;
            case "NONE":
               return Sorting.NONE;
            case "AVERAGE_Z":
               return Sorting.AVERAGE_Z;
            default:
               return Sorting.NONE;
         }
      }
      
      public function parseSprite3D(param1:String, param2:Material = null) : Sprite3D
      {
         var _loc3_:Sprite3D = null;
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         if(data.localName() == "sprite")
         {
            _loc3_ = new Sprite3D(100,100,param2);
            _loc3_.name = param1;
            _loc4_ = data.sorting[0];
            _loc5_ = data.clipping[0];
            if(_loc4_ != null)
            {
               _loc3_.sorting = this.getSortingValue(_loc4_);
            }
            if(_loc5_ != null)
            {
               _loc3_.clipping = this.getClippingValue(_loc5_);
            }
            _loc6_ = data.rotation[0];
            if(_loc6_ != null)
            {
               _loc3_.rotation = parseInt(_loc6_.toString()) * Math.PI / 180;
            }
            return this.setParams(_loc3_);
         }
         return null;
      }
      
      public function applyA3DMeshProperties(param1:Mesh) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Boolean = false;
         if(data.localName() == "mesh")
         {
            _loc2_ = data.sorting[0];
            _loc3_ = data.clipping[0];
            _loc4_ = data.optimizeBSP[0];
            if(_loc3_ != null)
            {
               param1.clipping = this.getClippingValue(_loc3_);
            }
            _loc5_ = _loc4_ != null ? Boolean(_loc4_.toString() != "false") : Boolean(true);
            if(_loc2_ != null)
            {
               param1.sorting = this.getSortingValue(_loc2_);
               if(_loc5_)
               {
                  param1.transformId = 1;
               }
            }
            this.setParams(param1);
         }
      }
      
      public function parseLOD(param1:String, param2:DaeNode) : LODContainer
      {
         var _loc3_:LODContainer = null;
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         var _loc8_:DaeNode = null;
         var _loc9_:DaeObject = null;
         if(data.localName() == "lod")
         {
            _loc3_ = new LODContainer();
            _loc3_.name = param1;
            _loc4_ = data.level;
            _loc5_ = _loc4_.length();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               _loc8_ = document.findNode(_loc7_.@url[0]);
               if(_loc8_.scene == null)
               {
                  param2.nodes.push(_loc8_);
               }
               _loc9_ = null;
               if(_loc8_ != null)
               {
                  if(_loc8_.rootJoint != null)
                  {
                     _loc8_ = _loc8_.rootJoint;
                     _loc8_.parse();
                     if(_loc8_.skins != null)
                     {
                        _loc9_ = _loc8_.skins[0];
                     }
                  }
                  else
                  {
                     _loc8_.parse();
                     if(_loc8_.objects != null)
                     {
                        _loc9_ = _loc8_.objects[0];
                     }
                  }
               }
               else
               {
                  document.logger.logNotFoundError(_loc7_.@url[0]);
               }
               if(_loc9_ != null)
               {
                  _loc9_.lodDistance = parseNumber(_loc7_.@distance[0]);
               }
               _loc6_++;
            }
            return this.setParams(_loc3_);
         }
         return null;
      }
      
      private function setParams(param1:*) : *
      {
         var param:XML = null;
         var name:String = null;
         var value:String = null;
         var num:Number = NaN;
         var object:* = param1;
         var params:XMLList = data.param;
         var i:int = 0;
         var count:int = params.length();
         for(; i < count; i++)
         {
            param = params[i];
            try
            {
               name = param.@name[0].toString();
               value = param.text().toString();
               if(value == "true")
               {
                  object[name] = true;
               }
               else if(value == "false")
               {
                  object[name] = false;
               }
               else if(value.charAt(0) == "\"" && value.charAt(value.length - 1) == "\"" || value.charAt(0) == "\'" && value.charAt(value.length - 1) == "\'")
               {
                  object[name] = value;
               }
               else
               {
                  if(value.indexOf(".") >= 0)
                  {
                     num = parseFloat(value);
                  }
                  else if(value.indexOf(",") >= 0)
                  {
                     value = value.replace(/,/,".");
                     num = parseFloat(value);
                  }
                  else
                  {
                     num = parseInt(value);
                  }
                  if(isNaN(num))
                  {
                     object[name] = value;
                  }
                  else
                  {
                     object[name] = num;
                  }
               }
            }
            catch(e:Error)
            {
               continue;
            }
         }
         return object;
      }
   }
}
