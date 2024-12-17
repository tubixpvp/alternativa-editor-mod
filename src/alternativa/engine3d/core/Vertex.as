package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   
   use namespace alternativa3d;
   
   public final class Vertex
   {
      alternativa3d var changeCoordsOperation:Operation;
      
      alternativa3d var calculateCoordsOperation:Operation;
      
      alternativa3d var _mesh:Mesh;
      
      alternativa3d var _coords:Point3D;
      
      alternativa3d var _faces:Set;
      
      alternativa3d var globalCoords:Point3D;
      
      public function Vertex(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         this.alternativa3d::changeCoordsOperation = new Operation("changeCoords",this);
         this.alternativa3d::calculateCoordsOperation = new Operation("calculateCoords",this,this.calculateCoords,Operation.alternativa3d::VERTEX_CALCULATE_COORDS);
         this.alternativa3d::_faces = new Set();
         this.alternativa3d::globalCoords = new Point3D();
         super();
         this.alternativa3d::_coords = new Point3D(param1,param2,param3);
         this.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::calculateCoordsOperation);
      }
      
      private function calculateCoords() : void
      {
         this.alternativa3d::globalCoords.copy(this.alternativa3d::_coords);
         this.alternativa3d::globalCoords.transform(this.alternativa3d::_mesh.alternativa3d::_transformation);
      }
      
      public function set x(param1:Number) : void
      {
         if(this.alternativa3d::_coords.x != param1)
         {
            this.alternativa3d::_coords.x = param1;
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
            }
         }
      }
      
      public function set y(param1:Number) : void
      {
         if(this.alternativa3d::_coords.y != param1)
         {
            this.alternativa3d::_coords.y = param1;
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
            }
         }
      }
      
      public function set z(param1:Number) : void
      {
         if(this.alternativa3d::_coords.z != param1)
         {
            this.alternativa3d::_coords.z = param1;
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
            }
         }
      }
      
      public function set coords(param1:Point3D) : void
      {
         if(!this.alternativa3d::_coords.equals(param1))
         {
            this.alternativa3d::_coords.copy(param1);
            if(this.alternativa3d::_mesh != null)
            {
               this.alternativa3d::_mesh.alternativa3d::addOperationToScene(this.alternativa3d::changeCoordsOperation);
            }
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
      
      public function get coords() : Point3D
      {
         return this.alternativa3d::_coords.clone();
      }
      
      public function get mesh() : Mesh
      {
         return this.alternativa3d::_mesh;
      }
      
      public function get faces() : Set
      {
         return this.alternativa3d::_faces.clone();
      }
      
      public function get id() : Object
      {
         return this.alternativa3d::_mesh != null ? this.alternativa3d::_mesh.getVertexId(this) : null;
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
         param1.alternativa3d::addOperation(this.alternativa3d::calculateCoordsOperation);
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::removeOperation(this.alternativa3d::calculateCoordsOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::changeCoordsOperation);
      }
      
      alternativa3d function addToMesh(param1:Mesh) : void
      {
         param1.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(this.alternativa3d::calculateCoordsOperation);
         param1.alternativa3d::changeRotationOrScaleOperation.alternativa3d::addSequel(this.alternativa3d::calculateCoordsOperation);
         this.alternativa3d::_mesh = param1;
      }
      
      alternativa3d function removeFromMesh(param1:Mesh) : void
      {
         var loc2:* = undefined;
         var loc3:Face = null;
         param1.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(this.alternativa3d::calculateCoordsOperation);
         param1.alternativa3d::changeRotationOrScaleOperation.alternativa3d::removeSequel(this.alternativa3d::calculateCoordsOperation);
         for(loc2 in this.alternativa3d::_faces)
         {
            loc3 = loc2;
            param1.removeFace(loc3);
         }
         this.alternativa3d::_mesh = null;
      }
      
      alternativa3d function addToFace(param1:Face) : void
      {
         this.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(param1.alternativa3d::calculateUVOperation);
         this.alternativa3d::changeCoordsOperation.alternativa3d::addSequel(param1.alternativa3d::calculateNormalOperation);
         this.alternativa3d::_faces.add(param1);
      }
      
      alternativa3d function removeFromFace(param1:Face) : void
      {
         this.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(param1.alternativa3d::calculateUVOperation);
         this.alternativa3d::changeCoordsOperation.alternativa3d::removeSequel(param1.alternativa3d::calculateNormalOperation);
         this.alternativa3d::_faces.remove(param1);
      }
      
      public function toString() : String
      {
         return "[Vertex ID:" + this.id + " " + this.alternativa3d::_coords.x.toFixed(2) + ", " + this.alternativa3d::_coords.y.toFixed(2) + ", " + this.alternativa3d::_coords.z.toFixed(2) + "]";
      }
   }
}

