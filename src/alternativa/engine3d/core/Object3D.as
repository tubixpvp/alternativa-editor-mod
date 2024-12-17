package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.errors.Object3DHierarchyError;
   import alternativa.engine3d.errors.Object3DNotFoundError;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import alternativa.utils.ObjectUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   use namespace alternativa3d;
   
   public class Object3D implements IEventDispatcher
   {
      alternativa3d static var matrix1:Matrix3D = new Matrix3D();
      
      alternativa3d static var matrix2:Matrix3D = new Matrix3D();
      
      private static var counter:uint = 0;
      
      alternativa3d var changeRotationOrScaleOperation:Operation;
      
      alternativa3d var changeCoordsOperation:Operation;
      
      alternativa3d var calculateTransformationOperation:Operation;
      
      alternativa3d var calculateMobilityOperation:Operation;
      
      alternativa3d var _name:String;
      
      alternativa3d var _scene:Scene3D;
      
      alternativa3d var _parent:Object3D;
      
      alternativa3d var _children:Set;
      
      alternativa3d var _mobility:int = 0;
      
      alternativa3d var inheritedMobility:int;
      
      alternativa3d var _coords:Point3D;
      
      alternativa3d var _rotationX:Number = 0;
      
      alternativa3d var _rotationY:Number = 0;
      
      alternativa3d var _rotationZ:Number = 0;
      
      alternativa3d var _scaleX:Number = 1;
      
      alternativa3d var _scaleY:Number = 1;
      
      alternativa3d var _scaleZ:Number = 1;
      
      alternativa3d var _transformation:Matrix3D;
      
      alternativa3d var globalCoords:Point3D;
      
      public var mouseEnabled:Boolean = true;
      
      private var dispatcher:EventDispatcher;
      
      public function Object3D(param1:String = null)
      {
         this.alternativa3d::changeRotationOrScaleOperation = new Operation("changeRotationOrScale",this);
         this.alternativa3d::changeCoordsOperation = new Operation("changeCoords",this);
         this.alternativa3d::calculateTransformationOperation = new Operation("calculateTransformation",this,this.alternativa3d::calculateTransformation,Operation.alternativa3d::OBJECT_CALCULATE_TRANSFORMATION);
         this.alternativa3d::calculateMobilityOperation = new Operation("calculateMobility",this,this.calculateMobility,Operation.alternativa3d::OBJECT_CALCULATE_MOBILITY);
         this.alternativa3d::_children = new Set();
         this.alternativa3d::_coords = new Point3D();
         this.alternativa3d::_transformation = new Matrix3D();
         this.alternativa3d::globalCoords = new Point3D();
         super();
         this.alternativa3d::_name = param1 != null ? param1 : this.defaultName();
         this.alternativa3d::changeRotationOrScaleOperation.alternativa3d::addSequel(this.alternativa3d::calculateTransformationOperation);
         this.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::calculateTransformationOperation);
      }
      
      alternativa3d function calculateTransformation() : void
      {
         if(this.alternativa3d::changeRotationOrScaleOperation.alternativa3d::queued)
         {
            this.alternativa3d::_transformation.toTransform(this.alternativa3d::_coords.x,this.alternativa3d::_coords.y,this.alternativa3d::_coords.z,this.alternativa3d::_rotationX,this.alternativa3d::_rotationY,this.alternativa3d::_rotationZ,this.alternativa3d::_scaleX,this.alternativa3d::_scaleY,this.alternativa3d::_scaleZ);
            if(this.alternativa3d::_parent != null)
            {
               this.alternativa3d::_transformation.combine(this.alternativa3d::_parent.alternativa3d::_transformation);
            }
            this.alternativa3d::globalCoords.x = this.alternativa3d::_transformation.d;
            this.alternativa3d::globalCoords.y = this.alternativa3d::_transformation.h;
            this.alternativa3d::globalCoords.z = this.alternativa3d::_transformation.l;
         }
         else
         {
            this.alternativa3d::globalCoords.copy(this.alternativa3d::_coords);
            if(this.alternativa3d::_parent != null)
            {
               this.alternativa3d::globalCoords.transform(this.alternativa3d::_parent.alternativa3d::_transformation);
            }
            this.alternativa3d::_transformation.offset(this.alternativa3d::globalCoords.x,this.alternativa3d::globalCoords.y,this.alternativa3d::globalCoords.z);
         }
      }
      
      private function calculateMobility() : void
      {
         this.alternativa3d::inheritedMobility = (this.alternativa3d::_parent != null ? this.alternativa3d::_parent.alternativa3d::inheritedMobility : 0) + this.alternativa3d::_mobility;
      }
      
      public function addChild(param1:Object3D) : Object3D
      {
         var loc2:Object3D = null;
         if(param1 == null)
         {
            throw new Object3DHierarchyError(null,this);
         }
         if(param1.alternativa3d::_parent == this)
         {
            return param1;
         }
         if(param1 == this)
         {
            throw new Object3DHierarchyError(this,this);
         }
         if(param1.alternativa3d::_scene == this.alternativa3d::_scene)
         {
            loc2 = this.alternativa3d::_parent;
            while(loc2 != null)
            {
               if(param1 == loc2)
               {
                  throw new Object3DHierarchyError(param1,this);
               }
               loc2 = loc2.alternativa3d::_parent;
            }
         }
         if(param1.alternativa3d::_parent != null)
         {
            param1.alternativa3d::_parent.alternativa3d::_children.remove(param1);
         }
         else if(param1.alternativa3d::_scene != null && param1.alternativa3d::_scene.alternativa3d::_root == param1)
         {
            param1.alternativa3d::_scene.root = null;
         }
         this.alternativa3d::_children.add(param1);
         param1.alternativa3d::setParent(this);
         param1.alternativa3d::setLevel((this.alternativa3d::calculateTransformationOperation.alternativa3d::priority & 0xFFFFFF) + 1);
         param1.alternativa3d::setScene(this.alternativa3d::_scene);
         return param1;
      }
      
      public function removeChild(param1:Object3D) : Object3D
      {
         if(param1 == null)
         {
            throw new Object3DNotFoundError(null,this);
         }
         if(param1.alternativa3d::_parent != this)
         {
            throw new Object3DNotFoundError(param1,this);
         }
         this.alternativa3d::_children.remove(param1);
         param1.alternativa3d::setParent(null);
         param1.alternativa3d::setScene(null);
         return param1;
      }
      
      alternativa3d function setParent(param1:Object3D) : void
      {
         if(this.alternativa3d::_parent != null)
         {
            this.removeParentSequels();
         }
         this.alternativa3d::_parent = param1;
         if(param1 != null)
         {
            this.addParentSequels();
         }
      }
      
      alternativa3d function setScene(param1:Scene3D) : void
      {
         var loc2:* = undefined;
         var loc3:Object3D = null;
         if(this.alternativa3d::_scene != param1)
         {
            if(this.alternativa3d::_scene != null)
            {
               this.removeFromScene(this.alternativa3d::_scene);
            }
            if(param1 != null)
            {
               this.addToScene(param1);
            }
            this.alternativa3d::_scene = param1;
         }
         else
         {
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
            this.alternativa3d::addOperationToScene(this.alternativa3d::calculateMobilityOperation);
         }
         for(loc2 in this.alternativa3d::_children)
         {
            loc3 = loc2;
            loc3.alternativa3d::setScene(this.alternativa3d::_scene);
         }
      }
      
      alternativa3d function setLevel(param1:uint) : void
      {
         var loc2:* = undefined;
         var loc3:Object3D = null;
         this.alternativa3d::calculateTransformationOperation.alternativa3d::priority = this.alternativa3d::calculateTransformationOperation.alternativa3d::priority & 4278190080 | param1;
         this.alternativa3d::calculateMobilityOperation.alternativa3d::priority = this.alternativa3d::calculateMobilityOperation.alternativa3d::priority & 4278190080 | param1;
         for(loc2 in this.alternativa3d::_children)
         {
            loc3 = loc2;
            loc3.alternativa3d::setLevel(param1 + 1);
         }
      }
      
      private function addParentSequels() : void
      {
         this.alternativa3d::_parent.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::changeCoordsOperation);
         this.alternativa3d::_parent.alternativa3d::changeRotationOrScaleOperation.alternativa3d::addSequel(this.alternativa3d::changeRotationOrScaleOperation);
         this.alternativa3d::_parent.alternativa3d::calculateMobilityOperation.alternativa3d::addSequel(this.alternativa3d::calculateMobilityOperation);
      }
      
      private function removeParentSequels() : void
      {
         this.alternativa3d::_parent.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(this.alternativa3d::changeCoordsOperation);
         this.alternativa3d::_parent.alternativa3d::changeRotationOrScaleOperation.alternativa3d::removeSequel(this.alternativa3d::changeRotationOrScaleOperation);
         this.alternativa3d::_parent.alternativa3d::calculateMobilityOperation.alternativa3d::removeSequel(this.alternativa3d::calculateMobilityOperation);
      }
      
      protected function addToScene(param1:Scene3D) : void
      {
         param1.alternativa3d::addOperation(this.alternativa3d::changeRotationOrScaleOperation);
         param1.alternativa3d::addOperation(this.alternativa3d::calculateMobilityOperation);
      }
      
      protected function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::removeOperation(this.alternativa3d::changeRotationOrScaleOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::changeCoordsOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::calculateMobilityOperation);
      }
      
      public function get name() : String
      {
         return this.alternativa3d::_name;
      }
      
      public function set name(param1:String) : void
      {
         this.alternativa3d::_name = param1;
      }
      
      public function get scene() : Scene3D
      {
         return this.alternativa3d::_scene;
      }
      
      public function get parent() : Object3D
      {
         return this.alternativa3d::_parent;
      }
      
      public function get children() : Set
      {
         return this.alternativa3d::_children.clone();
      }
      
      public function get mobility() : int
      {
         return this.alternativa3d::_mobility;
      }
      
      public function set mobility(param1:int) : void
      {
         if(this.alternativa3d::_mobility != param1)
         {
            this.alternativa3d::_mobility = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::calculateMobilityOperation);
         }
      }
      
      public function get x() : Number
      {
         return this.alternativa3d::_coords.x;
      }
      
      public function get y() : Number
      {
         return this.alternativa3d::_coords.y;
      }
      
      public function get z() : Number
      {
         return this.alternativa3d::_coords.z;
      }
      
      public function set x(param1:Number) : void
      {
         if(this.alternativa3d::_coords.x != param1)
         {
            this.alternativa3d::_coords.x = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
         }
      }
      
      public function set y(param1:Number) : void
      {
         if(this.alternativa3d::_coords.y != param1)
         {
            this.alternativa3d::_coords.y = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
         }
      }
      
      public function set z(param1:Number) : void
      {
         if(this.alternativa3d::_coords.z != param1)
         {
            this.alternativa3d::_coords.z = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
         }
      }
      
      public function get coords() : Point3D
      {
         return this.alternativa3d::_coords.clone();
      }
      
      public function set coords(param1:Point3D) : void
      {
         if(!this.alternativa3d::_coords.equals(param1))
         {
            this.alternativa3d::_coords.copy(param1);
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
         }
      }
      
      public function get rotationX() : Number
      {
         return this.alternativa3d::_rotationX;
      }
      
      public function get rotationY() : Number
      {
         return this.alternativa3d::_rotationY;
      }
      
      public function get rotationZ() : Number
      {
         return this.alternativa3d::_rotationZ;
      }
      
      public function set rotationX(param1:Number) : void
      {
         if(this.alternativa3d::_rotationX != param1)
         {
            this.alternativa3d::_rotationX = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function set rotationY(param1:Number) : void
      {
         if(this.alternativa3d::_rotationY != param1)
         {
            this.alternativa3d::_rotationY = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function set rotationZ(param1:Number) : void
      {
         if(this.alternativa3d::_rotationZ != param1)
         {
            this.alternativa3d::_rotationZ = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function get scaleX() : Number
      {
         return this.alternativa3d::_scaleX;
      }
      
      public function get scaleY() : Number
      {
         return this.alternativa3d::_scaleY;
      }
      
      public function get scaleZ() : Number
      {
         return this.alternativa3d::_scaleZ;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this.alternativa3d::_scaleX != param1)
         {
            this.alternativa3d::_scaleX = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this.alternativa3d::_scaleY != param1)
         {
            this.alternativa3d::_scaleY = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function set scaleZ(param1:Number) : void
      {
         if(this.alternativa3d::_scaleZ != param1)
         {
            this.alternativa3d::_scaleZ = param1;
            this.alternativa3d::addOperationToScene(this.alternativa3d::changeRotationOrScaleOperation);
         }
      }
      
      public function toString() : String
      {
         return "[" + ObjectUtils.getClassName(this) + " " + this.alternativa3d::_name + "]";
      }
      
      protected function defaultName() : String
      {
         return "object" + ++counter;
      }
      
      alternativa3d function addOperationToScene(param1:Operation) : void
      {
         if(this.alternativa3d::_scene != null)
         {
            this.alternativa3d::_scene.alternativa3d::addOperation(param1);
         }
      }
      
      alternativa3d function removeOperationFromScene(param1:Operation) : void
      {
         if(this.alternativa3d::_scene != null)
         {
            this.alternativa3d::_scene.alternativa3d::removeOperation(param1);
         }
      }
      
      protected function createEmptyObject() : Object3D
      {
         return new Object3D();
      }
      
      protected function clonePropertiesFrom(param1:Object3D) : void
      {
         this.alternativa3d::_name = param1.alternativa3d::_name;
         this.alternativa3d::_mobility = param1.alternativa3d::_mobility;
         this.alternativa3d::_coords.x = param1.alternativa3d::_coords.x;
         this.alternativa3d::_coords.y = param1.alternativa3d::_coords.y;
         this.alternativa3d::_coords.z = param1.alternativa3d::_coords.z;
         this.alternativa3d::_rotationX = param1.alternativa3d::_rotationX;
         this.alternativa3d::_rotationY = param1.alternativa3d::_rotationY;
         this.alternativa3d::_rotationZ = param1.alternativa3d::_rotationZ;
         this.alternativa3d::_scaleX = param1.alternativa3d::_scaleX;
         this.alternativa3d::_scaleY = param1.alternativa3d::_scaleY;
         this.alternativa3d::_scaleZ = param1.alternativa3d::_scaleZ;
      }
      
      public function clone() : Object3D
      {
         var loc2:* = undefined;
         var loc3:Object3D = null;
         var loc1:Object3D = this.createEmptyObject();
         loc1.clonePropertiesFrom(this);
         for(loc2 in this.alternativa3d::_children)
         {
            loc3 = loc2;
            loc1.addChild(loc3.clone());
         }
         return loc1;
      }
      
      public function getChildByName(param1:String, param2:Boolean = false) : Object3D
      {
         var loc3:* = undefined;
         var loc4:Object3D = null;
         for(loc3 in this.alternativa3d::_children)
         {
            loc4 = loc3;
            if(loc4.alternativa3d::_name == param1)
            {
               return loc4;
            }
         }
         if(param2)
         {
            for(loc3 in this.alternativa3d::_children)
            {
               loc4 = loc3;
               loc4 = loc4.getChildByName(param1,true);
               if(loc4 != null)
               {
                  return loc4;
               }
            }
         }
         return null;
      }
      
      public function localToGlobal(param1:Point3D, param2:Point3D = null) : Point3D
      {
         if(this.alternativa3d::_scene == null)
         {
            return null;
         }
         if(param2 == null)
         {
            param2 = param1.clone();
         }
         if(this.alternativa3d::_parent == null)
         {
            return param2;
         }
         this.alternativa3d::getTransformation(alternativa3d::matrix2);
         param2.transform(alternativa3d::matrix2);
         return param2;
      }
      
      public function globalToLocal(param1:Point3D, param2:Point3D = null) : Point3D
      {
         if(this.alternativa3d::_scene == null)
         {
            return null;
         }
         if(param2 == null)
         {
            param2 = param1.clone();
         }
         if(this.alternativa3d::_parent == null)
         {
            return param2;
         }
         this.alternativa3d::getTransformation(alternativa3d::matrix2);
         alternativa3d::matrix2.invert();
         param2.transform(alternativa3d::matrix2);
         return param2;
      }
      
      public function get transformation() : Matrix3D
      {
         if(this.alternativa3d::_scene == null)
         {
            return null;
         }
         var loc1:Matrix3D = new Matrix3D();
         this.alternativa3d::getTransformation(loc1);
         return loc1;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(this.dispatcher == null)
         {
            this.dispatcher = new EventDispatcher(this);
         }
         param3 = false;
         this.dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(this.dispatcher != null)
         {
            this.dispatcher.dispatchEvent(param1);
         }
         return false;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         if(this.dispatcher != null)
         {
            return this.dispatcher.hasEventListener(param1);
         }
         return false;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(this.dispatcher != null)
         {
            param3 = false;
            this.dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         if(this.dispatcher != null)
         {
            return this.dispatcher.willTrigger(param1);
         }
         return false;
      }
      
      alternativa3d function getTransformation(param1:Matrix3D) : Boolean
      {
         var loc3:Object3D = null;
         var loc2:Object3D = this.alternativa3d::_scene.alternativa3d::_root;
         var loc4:Object3D = this;
         do
         {
            if(loc4.alternativa3d::changeCoordsOperation.alternativa3d::queued || loc4.alternativa3d::changeRotationOrScaleOperation.alternativa3d::queued)
            {
               loc3 = loc4.alternativa3d::_parent;
            }
         }
         while(loc4 = loc4.alternativa3d::_parent, loc4 != loc2);
         
         if(loc3 != null)
         {
            param1.toTransform(this.alternativa3d::_coords.x,this.alternativa3d::_coords.y,this.alternativa3d::_coords.z,this.alternativa3d::_rotationX,this.alternativa3d::_rotationY,this.alternativa3d::_rotationZ,this.alternativa3d::_scaleX,this.alternativa3d::_scaleY,this.alternativa3d::_scaleZ);
            loc4 = this;
            while(true)
            {
               loc4 = loc4.alternativa3d::_parent;
               if(loc4 == loc3)
               {
                  break;
               }
               alternativa3d::matrix1.toTransform(loc4.alternativa3d::_coords.x,loc4.alternativa3d::_coords.y,loc4.alternativa3d::_coords.z,loc4.alternativa3d::_rotationX,loc4.alternativa3d::_rotationY,loc4.alternativa3d::_rotationZ,loc4.alternativa3d::_scaleX,loc4.alternativa3d::_scaleY,loc4.alternativa3d::_scaleZ);
               param1.combine(alternativa3d::matrix1);
            }
            if(loc3 != loc2)
            {
               param1.combine(loc3.alternativa3d::_transformation);
            }
            return true;
         }
         param1.copy(this.alternativa3d::_transformation);
         return false;
      }
      
      public function forEach(param1:Function) : void
      {
         var loc2:* = undefined;
         param1.call(this,this);
         for(loc2 in this.alternativa3d::_children)
         {
            Object3D(loc2).forEach(param1);
         }
      }
   }
}

