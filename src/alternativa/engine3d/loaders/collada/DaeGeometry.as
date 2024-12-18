package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace collada;
   use namespace alternativa3d;
   use namespace daeAlternativa3DMesh;
   
   public class DaeGeometry extends DaeElement
   {
       
      
      private var primitives:Vector.<DaePrimitive>;
      
      private var vertices:DaeVertices;
      
      public function DaeGeometry(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
         this.constructVertices();
      }
      
      private function constructVertices() : void
      {
         var _loc1_:XML = data.mesh.vertices[0];
         if(_loc1_ != null)
         {
            this.vertices = new DaeVertices(_loc1_,document);
            document.vertices[this.vertices.id] = this.vertices;
         }
      }
      
      override protected function parseImplementation() : Boolean
      {
         if(this.vertices != null)
         {
            return this.parsePrimitives();
         }
         return false;
      }
      
      private function parsePrimitives() : Boolean
      {
         var _loc4_:XML = null;
         this.primitives = new Vector.<DaePrimitive>();
         var _loc1_:XMLList = data.mesh.children();
         var _loc2_:int = 0;
         var _loc3_:int = _loc1_.length();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_[_loc2_];
            switch(_loc4_.localName())
            {
               case "polygons":
               case "polylist":
               case "triangles":
               case "trifans":
               case "tristrips":
                  this.primitives.push(new DaePrimitive(_loc4_,document));
                  break;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function parseMesh(param1:Object) : Mesh
      {
         var _loc2_:Mesh = null;
         if(data.mesh.length() > 0)
         {
            _loc2_ = new Mesh();
            this.fillInMesh(_loc2_,param1);
            this.cleanVertices(_loc2_);
            _loc2_.calculateFacesNormals(true);
            _loc2_.calculateBounds();
            return _loc2_;
         }
         return null;
      }
      
      public function fillInMesh(param1:Mesh, param2:Object) : Vector.<Vertex>
      {
         var _loc6_:DaePrimitive = null;
         this.vertices.parse();
         var _loc3_:Vector.<Vertex> = this.vertices.fillInMesh(param1);
         var _loc4_:int = 0;
         var _loc5_:int = this.primitives.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.primitives[_loc4_];
            _loc6_.parse();
            if(_loc6_.verticesEquals(this.vertices))
            {
               _loc6_.fillInMesh(param1,_loc3_,param2[_loc6_.materialSymbol]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function cleanVertices(param1:Mesh) : void
      {
         var _loc2_:Vertex = param1.vertexList;
         while(_loc2_ != null)
         {
            _loc2_.index = 0;
            _loc2_.value = null;
            _loc2_ = _loc2_.next;
         }
      }
   }
}
