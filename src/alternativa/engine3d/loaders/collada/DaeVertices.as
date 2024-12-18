package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   use namespace collada;
   
   public class DaeVertices extends DaeElement
   {
       
      
      private var positions:DaeSource;
      
      public function DaeVertices(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
      }
      
      override protected function parseImplementation() : Boolean
      {
         var inputXML:XML = null;
         inputXML = data.input.(@semantic == "POSITION")[0];
         if(inputXML != null)
         {
            this.positions = new DaeInput(inputXML,document).prepareSource(3);
            if(this.positions != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function fillInMesh(param1:Mesh) : Vector.<Vertex>
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vertex = null;
         var _loc2_:int = this.positions.stride;
         var _loc3_:Vector.<Number> = this.positions.numbers;
         var _loc4_:int = this.positions.numbers.length / _loc2_;
         var _loc5_:Vector.<Vertex> = new Vector.<Vertex>(_loc4_);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc2_ * _loc6_;
            _loc8_ = new Vertex();
            _loc8_.next = param1.vertexList;
            param1.vertexList = _loc8_;
            _loc8_.x = _loc3_[_loc7_];
            _loc8_.y = _loc3_[int(_loc7_ + 1)];
            _loc8_.z = _loc3_[int(_loc7_ + 2)];
            _loc8_.index = -1;
            _loc5_[_loc6_] = _loc8_;
            _loc6_++;
         }
         return _loc5_;
      }
   }
}
