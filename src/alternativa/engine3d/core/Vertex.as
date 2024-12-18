package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.VertexBinding;
   import flash.geom.Vector3D;
   use namespace alternativa3d;
   
   public class Vertex
   {
      
      alternativa3d static var collector:Vertex;
       
      
      public var x:Number = 0;
	  
	  alternativa3d var vertexbinding:VertexBinding;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public var u:Number = 0;
      
      public var v:Number = 0;
      
      public var normalX:Number;
      
      public var normalY:Number;
      
      public var normalZ:Number;
      
      alternativa3d var cameraX:Number;
      
      alternativa3d var cameraY:Number;
      
      alternativa3d var cameraZ:Number;
      
      alternativa3d var offset:Number = 1;
      
      alternativa3d var transformId:int = 0;
      
      alternativa3d var drawId:int = 0;
      
      alternativa3d var index:int;
      
      public var next:Vertex;
      
      alternativa3d var value:Vertex;
      
      public var id:Object;
      
      public function Vertex()
      {
         super();
      }

      public function copyToVector3D(vec:Vector3D) : Vector3D
      {
         vec.x = this.x;
         vec.y = this.y;
         vec.z = this.z;
         return vec;
      }
      
      alternativa3d static function createList(param1:int) : Vertex
      {
         var _loc3_:Vertex = null;
         var _loc2_:Vertex = collector;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_;
            while(param1 > 1)
            {
               _loc3_.transformId = 0;
               _loc3_.drawId = 0;
               if(_loc3_.next == null)
               {
                  while(param1 > 1)
                  {
                     _loc3_.next = new Vertex();
                     _loc3_ = _loc3_.next;
                     param1--;
                  }
                  break;
               }
               _loc3_ = _loc3_.next;
               param1--;
            }
            collector = _loc3_.next;
            _loc3_.transformId = 0;
            _loc3_.drawId = 0;
            _loc3_.next = null;
         }
         else
         {
            _loc2_ = new Vertex();
            _loc3_ = _loc2_;
            while(param1 > 1)
            {
               _loc3_.next = new Vertex();
               _loc3_ = _loc3_.next;
               param1--;
            }
         }
         return _loc2_;
      }
      
      alternativa3d function create() : Vertex
      {
         var _loc1_:Vertex = null;
         if(collector != null)
         {
            _loc1_ = collector;
            collector = _loc1_.next;
            _loc1_.next = null;
            _loc1_.transformId = 0;
            _loc1_.drawId = 0;
            return _loc1_;
         }
         return new Vertex();
      }
      
      public function toString() : String
      {
         return "[Vertex " + this.id + " " + this.x.toFixed(2) + ", " + this.y.toFixed(2) + ", " + this.z.toFixed(2) + ", " + this.u.toFixed(3) + ", " + this.v.toFixed(3) + "]";
      }
      
      public function destroy() : *
      {
         delete this[this];
      }
   }
}
