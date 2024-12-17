package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class PolyPrimitive
   {
      private static var collector:Array = new Array();
      
      alternativa3d var num:uint;
      
      alternativa3d var points:Array;
      
      alternativa3d var face:Face;
      
      alternativa3d var parent:PolyPrimitive;
      
      alternativa3d var sibling:PolyPrimitive;
      
      alternativa3d var backFragment:PolyPrimitive;
      
      alternativa3d var frontFragment:PolyPrimitive;
      
      alternativa3d var node:BSPNode;
      
      alternativa3d var splits:uint;
      
      alternativa3d var disbalance:int;
      
      public var splitQuality:Number;
      
      public var mobility:int;
      
      public function PolyPrimitive()
      {
         this.alternativa3d::points = new Array();
         super();
      }
      
      alternativa3d static function create() : PolyPrimitive
      {
         var loc1:PolyPrimitive = null;
         loc1 = collector.pop();
         if(loc1 != null)
         {
            return loc1;
         }
         return new PolyPrimitive();
      }
      
      alternativa3d static function destroy(param1:PolyPrimitive) : void
      {
         param1.alternativa3d::face = null;
         param1.alternativa3d::points.length = 0;
         collector.push(param1);
      }
      
      alternativa3d function createFragment() : PolyPrimitive
      {
         var loc1:PolyPrimitive = alternativa3d::create();
         loc1.alternativa3d::face = this.alternativa3d::face;
         loc1.mobility = this.mobility;
         return loc1;
      }
      
      public function toString() : String
      {
         return "[Primitive " + this.alternativa3d::face.alternativa3d::_mesh.alternativa3d::_name + "]";
      }
   }
}

