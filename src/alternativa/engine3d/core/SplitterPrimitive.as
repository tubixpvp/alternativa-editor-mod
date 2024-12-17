package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class SplitterPrimitive extends PolyPrimitive
   {
      private static var collector:Array = new Array();
      
      alternativa3d var splitter:Splitter;
      
      public function SplitterPrimitive()
      {
         super();
      }
      
      alternativa3d static function create() : SplitterPrimitive
      {
         var loc1:SplitterPrimitive = null;
         loc1 = collector.pop();
         if(loc1 != null)
         {
            return loc1;
         }
         return new SplitterPrimitive();
      }
      
      alternativa3d static function destroy(param1:SplitterPrimitive) : void
      {
         param1.alternativa3d::splitter = null;
         param1.alternativa3d::points.length = 0;
         collector.push(param1);
      }
      
      override alternativa3d function createFragment() : PolyPrimitive
      {
         var loc1:SplitterPrimitive = alternativa3d::create();
         loc1.alternativa3d::splitter = this.alternativa3d::splitter;
         loc1.mobility = mobility;
         return loc1;
      }
   }
}

