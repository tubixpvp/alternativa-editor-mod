package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.errors.FaceExistsError;
   import alternativa.engine3d.errors.FaceNeedMoreVerticesError;
   import alternativa.engine3d.errors.FaceNotFoundError;
   import alternativa.engine3d.errors.InvalidIDError;
   import alternativa.engine3d.errors.SurfaceExistsError;
   import alternativa.engine3d.errors.SurfaceNotFoundError;
   import alternativa.engine3d.errors.VertexExistsError;
   import alternativa.engine3d.errors.VertexNotFoundError;
   import alternativa.engine3d.materials.SurfaceMaterial;
   import alternativa.types.Map;
   import alternativa.utils.ObjectUtils;
   import flash.geom.Point;
   
   use namespace alternativa3d;
   
   public class Mesh extends Object3D
   {
      private static var counter:uint = 0;
      
      private var vertexIDCounter:uint = 0;
      
      private var faceIDCounter:uint = 0;
      
      private var surfaceIDCounter:uint = 0;
      
      alternativa3d var _vertices:Map;
      
      alternativa3d var _faces:Map;
      
      alternativa3d var _surfaces:Map;
      
      public function Mesh(param1:String = null)
      {
         this.alternativa3d::_vertices = new Map();
         this.alternativa3d::_faces = new Map();
         this.alternativa3d::_surfaces = new Map();
         super(param1);
      }
      
      public function createVertex(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Object = null) : Vertex
      {
         if(param4 != null)
         {
            if(this.alternativa3d::_vertices[param4] != undefined)
            {
               if(this.alternativa3d::_vertices[param4] is Vertex)
               {
                  throw new VertexExistsError(param4,this);
               }
               throw new InvalidIDError(param4,this);
            }
         }
         else
         {
            while(this.alternativa3d::_vertices[this.vertexIDCounter] != undefined)
            {
               ++this.vertexIDCounter;
            }
            param4 = this.vertexIDCounter;
         }
         var loc5:Vertex = new Vertex(param1,param2,param3);
         if(alternativa3d::_scene != null)
         {
            loc5.alternativa3d::addToScene(alternativa3d::_scene);
         }
         loc5.alternativa3d::addToMesh(this);
         this.alternativa3d::_vertices[param4] = loc5;
         return loc5;
      }
      
      public function removeVertex(param1:Object) : Vertex
      {
         var loc2:* = param1 is Vertex;
         if(param1 == null)
         {
            throw new VertexNotFoundError(null,this);
         }
         if(loc2)
         {
            if(Vertex(param1).alternativa3d::_mesh != this)
            {
               throw new VertexNotFoundError(param1,this);
            }
         }
         else
         {
            if(this.alternativa3d::_vertices[param1] == undefined)
            {
               throw new VertexNotFoundError(param1,this);
            }
            if(!(this.alternativa3d::_vertices[param1] is Vertex))
            {
               throw new InvalidIDError(param1,this);
            }
         }
         var loc3:Vertex = loc2 ? Vertex(param1) : this.alternativa3d::_vertices[param1];
         var loc4:Object = loc2 ? this.getVertexId(Vertex(param1)) : param1;
         if(alternativa3d::_scene != null)
         {
            loc3.alternativa3d::removeFromScene(alternativa3d::_scene);
         }
         loc3.alternativa3d::removeFromMesh(this);
         delete this.alternativa3d::_vertices[loc4];
         return loc3;
      }
      
      public function createFace(param1:Array, param2:Object = null) : Face
      {
         var loc5:Vertex = null;
         if(param1 == null)
         {
            throw new FaceNeedMoreVerticesError(this);
         }
         if(param2 != null)
         {
            if(this.alternativa3d::_faces[param2] != undefined)
            {
               if(this.alternativa3d::_faces[param2] is Face)
               {
                  throw new FaceExistsError(param2,this);
               }
               throw new InvalidIDError(param2,this);
            }
         }
         else
         {
            while(this.alternativa3d::_faces[this.faceIDCounter] != undefined)
            {
               ++this.faceIDCounter;
            }
            param2 = this.faceIDCounter;
         }
         var loc3:uint = param1.length;
         if(loc3 < 3)
         {
            throw new FaceNeedMoreVerticesError(this,loc3);
         }
         var loc4:Array = new Array();
         var loc6:uint = 0;
         while(loc6 < loc3)
         {
            if(param1[loc6] is Vertex)
            {
               loc5 = param1[loc6];
               if(loc5.alternativa3d::_mesh != this)
               {
                  throw new VertexNotFoundError(param1[loc6],this);
               }
            }
            else
            {
               if(this.alternativa3d::_vertices[param1[loc6]] == null)
               {
                  throw new VertexNotFoundError(param1[loc6],this);
               }
               if(!(this.alternativa3d::_vertices[param1[loc6]] is Vertex))
               {
                  throw new InvalidIDError(param1[loc6],this);
               }
               loc5 = this.alternativa3d::_vertices[param1[loc6]];
            }
            loc4.push(loc5);
            loc6++;
         }
         var loc7:Face = new Face(loc4);
         if(alternativa3d::_scene != null)
         {
            loc7.alternativa3d::addToScene(alternativa3d::_scene);
         }
         loc7.alternativa3d::addToMesh(this);
         this.alternativa3d::_faces[param2] = loc7;
         return loc7;
      }
      
      public function removeFace(param1:Object) : Face
      {
         var loc2:* = param1 is Face;
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(loc2)
         {
            if(Face(param1).alternativa3d::_mesh != this)
            {
               throw new FaceNotFoundError(param1,this);
            }
         }
         else
         {
            if(this.alternativa3d::_faces[param1] == undefined)
            {
               throw new FaceNotFoundError(param1,this);
            }
            if(!(this.alternativa3d::_faces[param1] is Face))
            {
               throw new InvalidIDError(param1,this);
            }
         }
         var loc3:Face = loc2 ? Face(param1) : this.alternativa3d::_faces[param1];
         var loc4:Object = loc2 ? this.getFaceId(Face(param1)) : param1;
         loc3.alternativa3d::removeVertices();
         if(loc3.alternativa3d::_surface != null)
         {
            loc3.alternativa3d::_surface.alternativa3d::_faces.remove(loc3);
            loc3.alternativa3d::removeFromSurface(loc3.alternativa3d::_surface);
         }
         if(alternativa3d::_scene != null)
         {
            loc3.alternativa3d::removeFromScene(alternativa3d::_scene);
         }
         loc3.alternativa3d::removeFromMesh(this);
         delete this.alternativa3d::_faces[loc4];
         return loc3;
      }
      
      public function createSurface(param1:Array = null, param2:Object = null) : Surface
      {
         var loc4:uint = 0;
         var loc5:uint = 0;
         if(param2 != null)
         {
            if(this.alternativa3d::_surfaces[param2] != undefined)
            {
               if(this.alternativa3d::_surfaces[param2] is Surface)
               {
                  throw new SurfaceExistsError(param2,this);
               }
               throw new InvalidIDError(param2,this);
            }
         }
         else
         {
            while(this.alternativa3d::_surfaces[this.surfaceIDCounter] != undefined)
            {
               ++this.surfaceIDCounter;
            }
            param2 = this.surfaceIDCounter;
         }
         var loc3:Surface = new Surface();
         if(alternativa3d::_scene != null)
         {
            loc3.alternativa3d::addToScene(alternativa3d::_scene);
         }
         loc3.alternativa3d::addToMesh(this);
         this.alternativa3d::_surfaces[param2] = loc3;
         if(param1 != null)
         {
            loc4 = param1.length;
            loc5 = 0;
            while(loc5 < loc4)
            {
               loc3.addFace(param1[loc5]);
               loc5++;
            }
         }
         return loc3;
      }
      
      public function removeSurface(param1:Object) : Surface
      {
         var loc2:* = param1 is Surface;
         if(param1 == null)
         {
            throw new SurfaceNotFoundError(null,this);
         }
         if(loc2)
         {
            if(Surface(param1).alternativa3d::_mesh != this)
            {
               throw new SurfaceNotFoundError(param1,this);
            }
         }
         else
         {
            if(this.alternativa3d::_surfaces[param1] == undefined)
            {
               throw new SurfaceNotFoundError(param1,this);
            }
            if(!(this.alternativa3d::_surfaces[param1] is Surface))
            {
               throw new InvalidIDError(param1,this);
            }
         }
         var loc3:Surface = loc2 ? Surface(param1) : this.alternativa3d::_surfaces[param1];
         var loc4:Object = loc2 ? this.getSurfaceId(Surface(param1)) : param1;
         if(alternativa3d::_scene != null)
         {
            loc3.alternativa3d::removeFromScene(alternativa3d::_scene);
         }
         loc3.alternativa3d::removeFaces();
         loc3.alternativa3d::removeFromMesh(this);
         delete this.alternativa3d::_surfaces[loc4];
         return loc3;
      }
      
      public function moveAllFacesToSurface(param1:Object = null, param2:Boolean = false) : Surface
      {
         var loc3:Surface = null;
         var loc4:Object = null;
         var loc5:Face = null;
         var loc6:Map = null;
         var loc7:* = undefined;
         var loc8:Surface = null;
         if(param1 is Surface)
         {
            if(param1._mesh != this)
            {
               throw new SurfaceNotFoundError(param1,this);
            }
            loc3 = Surface(param1);
         }
         else if(this.alternativa3d::_surfaces[param1] == undefined)
         {
            loc3 = this.createSurface(null,param1);
            loc4 = param1;
         }
         else
         {
            if(!(this.alternativa3d::_surfaces[param1] is Surface))
            {
               throw new InvalidIDError(param1,this);
            }
            loc3 = this.alternativa3d::_surfaces[param1];
         }
         for each(loc5 in this.alternativa3d::_faces)
         {
            if(loc5.alternativa3d::_surface != loc3)
            {
               loc3.addFace(loc5);
            }
         }
         if(param2)
         {
            if(loc4 == null)
            {
               loc4 = this.getSurfaceId(loc3);
            }
            loc6 = new Map();
            loc6[loc4] = loc3;
            delete this.alternativa3d::_surfaces[loc4];
            for(loc7 in this.alternativa3d::_surfaces)
            {
               loc8 = this.alternativa3d::_surfaces[loc7];
               if(alternativa3d::_scene != null)
               {
                  loc8.alternativa3d::removeFromScene(alternativa3d::_scene);
               }
               loc8.alternativa3d::removeFromMesh(this);
               delete this.alternativa3d::_surfaces[loc7];
            }
            this.alternativa3d::_surfaces = loc6;
         }
         return loc3;
      }
      
      public function setMaterialToSurface(param1:SurfaceMaterial, param2:Object) : void
      {
         var loc3:* = param2 is Surface;
         if(param2 == null)
         {
            throw new SurfaceNotFoundError(null,this);
         }
         if(loc3)
         {
            if(Surface(param2).alternativa3d::_mesh != this)
            {
               throw new SurfaceNotFoundError(param2,this);
            }
         }
         else
         {
            if(this.alternativa3d::_surfaces[param2] == undefined)
            {
               throw new SurfaceNotFoundError(param2,this);
            }
            if(!(this.alternativa3d::_surfaces[param2] is Surface))
            {
               throw new InvalidIDError(param2,this);
            }
         }
         var loc4:Surface = loc3 ? Surface(param2) : this.alternativa3d::_surfaces[param2];
         loc4.material = param1;
      }
      
      public function cloneMaterialToAllSurfaces(param1:SurfaceMaterial) : void
      {
         var loc2:Surface = null;
         for each(loc2 in this.alternativa3d::_surfaces)
         {
            loc2.material = param1 != null ? SurfaceMaterial(param1.clone()) : null;
         }
      }
      
      public function setUVsToFace(param1:Point, param2:Point, param3:Point, param4:Object) : void
      {
         var loc5:* = param4 is Face;
         if(param4 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(loc5)
         {
            if(Face(param4).alternativa3d::_mesh != this)
            {
               throw new FaceNotFoundError(param4,this);
            }
         }
         else
         {
            if(this.alternativa3d::_faces[param4] == undefined)
            {
               throw new FaceNotFoundError(param4,this);
            }
            if(!(this.alternativa3d::_faces[param4] is Face))
            {
               throw new InvalidIDError(param4,this);
            }
         }
         var loc6:Face = loc5 ? Face(param4) : this.alternativa3d::_faces[param4];
         loc6.aUV = param1;
         loc6.bUV = param2;
         loc6.cUV = param3;
      }
      
      public function get vertices() : Map
      {
         return this.alternativa3d::_vertices.clone();
      }
      
      public function get faces() : Map
      {
         return this.alternativa3d::_faces.clone();
      }
      
      public function get surfaces() : Map
      {
         return this.alternativa3d::_surfaces.clone();
      }
      
      public function getVertexById(param1:Object) : Vertex
      {
         if(param1 == null)
         {
            throw new VertexNotFoundError(null,this);
         }
         if(this.alternativa3d::_vertices[param1] == undefined)
         {
            throw new VertexNotFoundError(param1,this);
         }
         if(this.alternativa3d::_vertices[param1] is Vertex)
         {
            return this.alternativa3d::_vertices[param1];
         }
         throw new InvalidIDError(param1,this);
      }
      
      public function getVertexId(param1:Vertex) : Object
      {
         var loc2:Object = null;
         if(param1 == null)
         {
            throw new VertexNotFoundError(null,this);
         }
         if(param1.alternativa3d::_mesh != this)
         {
            throw new VertexNotFoundError(param1,this);
         }
         for(loc2 in this.alternativa3d::_vertices)
         {
            if(this.alternativa3d::_vertices[loc2] == param1)
            {
               return loc2;
            }
         }
         throw new VertexNotFoundError(param1,this);
      }
      
      public function hasVertex(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            throw new VertexNotFoundError(null,this);
         }
         if(param1 is Vertex)
         {
            return param1._mesh == this;
         }
         if(this.alternativa3d::_vertices[param1] != undefined)
         {
            if(this.alternativa3d::_vertices[param1] is Vertex)
            {
               return true;
            }
            throw new InvalidIDError(param1,this);
         }
         return false;
      }
      
      public function getFaceById(param1:Object) : Face
      {
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(this.alternativa3d::_faces[param1] == undefined)
         {
            throw new FaceNotFoundError(param1,this);
         }
         if(this.alternativa3d::_faces[param1] is Face)
         {
            return this.alternativa3d::_faces[param1];
         }
         throw new InvalidIDError(param1,this);
      }
      
      public function getFaceId(param1:Face) : Object
      {
         var loc2:Object = null;
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(param1.alternativa3d::_mesh != this)
         {
            throw new FaceNotFoundError(param1,this);
         }
         for(loc2 in this.alternativa3d::_faces)
         {
            if(this.alternativa3d::_faces[loc2] == param1)
            {
               return loc2;
            }
         }
         throw new FaceNotFoundError(param1,this);
      }
      
      public function hasFace(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            throw new FaceNotFoundError(null,this);
         }
         if(param1 is Face)
         {
            return param1._mesh == this;
         }
         if(this.alternativa3d::_faces[param1] != undefined)
         {
            if(this.alternativa3d::_faces[param1] is Face)
            {
               return true;
            }
            throw new InvalidIDError(param1,this);
         }
         return false;
      }
      
      public function getSurfaceById(param1:Object) : Surface
      {
         if(param1 == null)
         {
            throw new SurfaceNotFoundError(null,this);
         }
         if(this.alternativa3d::_surfaces[param1] == undefined)
         {
            throw new SurfaceNotFoundError(param1,this);
         }
         if(this.alternativa3d::_surfaces[param1] is Surface)
         {
            return this.alternativa3d::_surfaces[param1];
         }
         throw new InvalidIDError(param1,this);
      }
      
      public function getSurfaceId(param1:Surface) : Object
      {
         var loc2:Object = null;
         if(param1 == null)
         {
            throw new SurfaceNotFoundError(null,this);
         }
         if(param1.alternativa3d::_mesh != this)
         {
            throw new SurfaceNotFoundError(param1,this);
         }
         for(loc2 in this.alternativa3d::_surfaces)
         {
            if(this.alternativa3d::_surfaces[loc2] == param1)
            {
               return loc2;
            }
         }
         return null;
      }
      
      public function hasSurface(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            throw new SurfaceNotFoundError(null,this);
         }
         if(param1 is Surface)
         {
            return param1._mesh == this;
         }
         if(this.alternativa3d::_surfaces[param1] != undefined)
         {
            if(this.alternativa3d::_surfaces[param1] is Surface)
            {
               return true;
            }
            throw new InvalidIDError(param1,this);
         }
         return false;
      }
      
      override alternativa3d function setScene(param1:Scene3D) : void
      {
         var loc2:Vertex = null;
         var loc3:Face = null;
         var loc4:Surface = null;
         if(alternativa3d::_scene != param1)
         {
            if(param1 != null)
            {
               for each(loc2 in this.alternativa3d::_vertices)
               {
                  loc2.alternativa3d::addToScene(param1);
               }
               for each(loc3 in this.alternativa3d::_faces)
               {
                  loc3.alternativa3d::addToScene(param1);
               }
               for each(loc4 in this.alternativa3d::_surfaces)
               {
                  loc4.alternativa3d::addToScene(param1);
               }
            }
            else
            {
               for each(loc2 in this.alternativa3d::_vertices)
               {
                  loc2.alternativa3d::removeFromScene(alternativa3d::_scene);
               }
               for each(loc3 in this.alternativa3d::_faces)
               {
                  loc3.alternativa3d::removeFromScene(alternativa3d::_scene);
               }
               for each(loc4 in this.alternativa3d::_surfaces)
               {
                  loc4.alternativa3d::removeFromScene(alternativa3d::_scene);
               }
            }
         }
         super.alternativa3d::setScene(param1);
      }
      
      override protected function defaultName() : String
      {
         return "mesh" + ++counter;
      }
      
      override public function toString() : String
      {
         return "[" + ObjectUtils.getClassName(this) + " " + alternativa3d::_name + " vertices: " + this.alternativa3d::_vertices.length + " faces: " + this.alternativa3d::_faces.length + "]";
      }
      
      override protected function createEmptyObject() : Object3D
      {
         return new Mesh();
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var loc3:* = undefined;
         var loc4:int = 0;
         var loc5:int = 0;
         var loc7:Map = null;
         var loc8:Vertex = null;
         var loc9:Face = null;
         var loc10:Array = null;
         var loc11:Face = null;
         var loc12:Surface = null;
         var loc13:Array = null;
         var loc14:Surface = null;
         var loc15:SurfaceMaterial = null;
         super.clonePropertiesFrom(param1);
         var loc2:Mesh = Mesh(param1);
         var loc6:Map = new Map(true);
         for(loc3 in loc2.alternativa3d::_vertices)
         {
            loc8 = loc2.alternativa3d::_vertices[loc3];
            loc6[loc8] = this.createVertex(loc8.x,loc8.y,loc8.z,loc3);
         }
         loc7 = new Map(true);
         for(loc3 in loc2.alternativa3d::_faces)
         {
            loc9 = loc2.alternativa3d::_faces[loc3];
            loc4 = int(loc9.alternativa3d::_vertices.length);
            loc10 = new Array(loc4);
            loc5 = 0;
            while(loc5 < loc4)
            {
               loc10[loc5] = loc6[loc9.alternativa3d::_vertices[loc5]];
               loc5++;
            }
            loc11 = this.createFace(loc10,loc3);
            loc11.aUV = loc9.alternativa3d::_aUV;
            loc11.bUV = loc9.alternativa3d::_bUV;
            loc11.cUV = loc9.alternativa3d::_cUV;
            loc7[loc9] = loc11;
         }
         for(loc3 in loc2.alternativa3d::_surfaces)
         {
            loc12 = loc2.alternativa3d::_surfaces[loc3];
            loc13 = loc12.alternativa3d::_faces.toArray();
            loc4 = int(loc13.length);
            loc5 = 0;
            while(loc5 < loc4)
            {
               loc13[loc5] = loc7[loc13[loc5]];
               loc5++;
            }
            loc14 = this.createSurface(loc13,loc3);
            loc15 = loc12.material;
            if(loc15 != null)
            {
               loc14.material = SurfaceMaterial(loc15.clone());
            }
         }
      }
   }
}

