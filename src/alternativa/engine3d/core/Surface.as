package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.errors.FaceExistsError;
   import alternativa.engine3d.errors.FaceNotFoundError;
   import alternativa.engine3d.errors.InvalidIDError;
   import alternativa.engine3d.materials.SurfaceMaterial;
   import alternativa.types.Set;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   use namespace alternativa3d;
   
   public class Surface implements IEventDispatcher
   {
      alternativa3d var changeFacesOperation:Operation;
      
      alternativa3d var changeMaterialOperation:Operation;
      
      alternativa3d var _mesh:Mesh;
      
      alternativa3d var _material:SurfaceMaterial;
      
      alternativa3d var _faces:Set;
      
      public var mouseEnabled:Boolean = true;
      
      private var dispatcher:EventDispatcher;
      
      public function Surface()
      {
         this.alternativa3d::changeFacesOperation = new Operation("changeFaces",this);
         this.alternativa3d::changeMaterialOperation = new Operation("changeMaterial",this);
         this.alternativa3d::_faces = new Set();
         super();
      }
      
      public function addFace(param1:Object) : void
      {
         var loc2:* = param1 is Face;
         if(this.alternativa3d::_mesh == null)
         {
            throw new FaceNotFoundError(param1,this);
         }
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(loc2)
         {
            if(Face(param1).alternativa3d::_mesh != this.alternativa3d::_mesh)
            {
               throw new FaceNotFoundError(param1,this);
            }
         }
         else
         {
            if(this.alternativa3d::_mesh.alternativa3d::_faces[param1] == undefined)
            {
               throw new FaceNotFoundError(param1,this);
            }
            if(!(this.alternativa3d::_mesh.alternativa3d::_faces[param1] is Face))
            {
               throw new InvalidIDError(param1,this);
            }
         }
         var loc3:Face = loc2 ? Face(param1) : this.alternativa3d::_mesh.alternativa3d::_faces[param1];
         if(this.alternativa3d::_faces.has(loc3))
         {
            throw new FaceExistsError(loc3,this);
         }
         if(loc3.alternativa3d::_surface != null)
         {
            loc3.alternativa3d::_surface.alternativa3d::_faces.remove(loc3);
            loc3.alternativa3d::removeFromSurface(loc3.alternativa3d::_surface);
         }
         this.alternativa3d::_faces.add(loc3);
         loc3.alternativa3d::addToSurface(this);
         this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeFacesOperation);
      }
      
      public function removeFace(param1:Object) : void
      {
         var loc2:* = param1 is Face;
         if(this.alternativa3d::_mesh == null)
         {
            throw new FaceNotFoundError(param1,this);
         }
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(loc2)
         {
            if(Face(param1).alternativa3d::_mesh != this.alternativa3d::_mesh)
            {
               throw new FaceNotFoundError(param1,this);
            }
         }
         else
         {
            if(this.alternativa3d::_mesh.alternativa3d::_faces[param1] == undefined)
            {
               throw new FaceNotFoundError(param1,this);
            }
            if(!(this.alternativa3d::_mesh.alternativa3d::_faces[param1] is Face))
            {
               throw new InvalidIDError(param1,this);
            }
         }
         var loc3:Face = loc2 ? Face(param1) : this.alternativa3d::_mesh.alternativa3d::_faces[param1];
         if(!this.alternativa3d::_faces.has(loc3))
         {
            throw new FaceNotFoundError(loc3,this);
         }
         this.alternativa3d::_faces.remove(loc3);
         loc3.alternativa3d::removeFromSurface(this);
         this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeFacesOperation);
      }
      
      public function get material() : SurfaceMaterial
      {
         return this.alternativa3d::_material;
      }
      
      public function set material(param1:SurfaceMaterial) : void
      {
         if(this.alternativa3d::_material != param1)
         {
            if(this.alternativa3d::_material != null)
            {
               this.alternativa3d::_material.alternativa3d::removeFromSurface(this);
               if(this.alternativa3d::_mesh != null)
               {
                  this.alternativa3d::_material.alternativa3d::removeFromMesh(this.alternativa3d::_mesh);
                  if(this.alternativa3d::_mesh.alternativa3d::_scene != null)
                  {
                     this.alternativa3d::_material.alternativa3d::removeFromScene(this.alternativa3d::_mesh.alternativa3d::_scene);
                  }
               }
            }
            if(param1 != null)
            {
               if(param1.alternativa3d::_surface != null)
               {
                  param1.alternativa3d::_surface.material = null;
               }
               param1.alternativa3d::addToSurface(this);
               if(this.alternativa3d::_mesh != null)
               {
                  param1.alternativa3d::addToMesh(this.alternativa3d::_mesh);
                  if(this.alternativa3d::_mesh.alternativa3d::_scene != null)
                  {
                     param1.alternativa3d::addToScene(this.alternativa3d::_mesh.alternativa3d::_scene);
                  }
               }
            }
            this.alternativa3d::_material = param1;
            this.alternativa3d::addMaterialChangedOperationToScene();
         }
      }
      
      public function get faces() : Set
      {
         return this.alternativa3d::_faces.clone();
      }
      
      public function get mesh() : Mesh
      {
         return this.alternativa3d::_mesh;
      }
      
      public function get id() : Object
      {
         return this.alternativa3d::_mesh != null ? this.alternativa3d::_mesh.getSurfaceId(this) : null;
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::addToScene(param1);
         }
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::removeOperation(this.alternativa3d::changeFacesOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::changeMaterialOperation);
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::removeFromScene(param1);
         }
      }
      
      alternativa3d function addToMesh(param1:Mesh) : void
      {
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::addToMesh(param1);
         }
         this.alternativa3d::_mesh = param1;
      }
      
      alternativa3d function removeFromMesh(param1:Mesh) : void
      {
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::removeFromMesh(param1);
         }
         this.alternativa3d::_mesh = null;
      }
      
      alternativa3d function removeFaces() : void
      {
         var loc1:* = undefined;
         var loc2:Face = null;
         for(loc1 in this.alternativa3d::_faces)
         {
            loc2 = loc1;
            this.alternativa3d::_faces.remove(loc2);
            loc2.alternativa3d::removeFromSurface(this);
         }
      }
      
      alternativa3d function addMaterialChangedOperationToScene() : void
      {
         if(this.alternativa3d::_mesh != null)
         {
            this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeMaterialOperation);
         }
      }
      
      public function toString() : String
      {
         var loc4:* = undefined;
         var loc5:Face = null;
         var loc1:uint = this.alternativa3d::_faces.length;
         var loc2:String = "[Surface ID:" + this.id + (loc1 > 0 ? " faces:" : "");
         var loc3:uint = 0;
         for(loc4 in this.alternativa3d::_faces)
         {
            loc5 = loc4;
            loc2 += loc5.id + (loc3 < loc1 - 1 ? ", " : "");
            loc3++;
         }
         return loc2 + "]";
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
   }
}

