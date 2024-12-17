package alternativa.editor.mapexport
{
   public class CollisionPrimitivesCache
   {
      private var cache:Object;
      
      public function CollisionPrimitivesCache()
      {
         this.cache = {};
         super();
      }
      
      public function addPrimitives(param1:String, param2:String, param3:String, param4:Vector.<CollisionPrimitive>) : void
      {
         var loc5:Object = this.cache[param1];
         if(loc5 == null)
         {
            this.cache[param1] = loc5 = {};
         }
         var loc6:Object = loc5[param2];
         if(loc6 == null)
         {
            loc5[param2] = loc6 = {};
         }
         loc6[param3] = param4;
      }
      
      public function getPrimitives(param1:String, param2:String, param3:String) : Vector.<CollisionPrimitive>
      {
         var loc4:Object = this.cache[param1];
         if(loc4 == null)
         {
            return null;
         }
         loc4 = loc4[param2];
         return loc4 != null ? loc4[param3] : null;
      }
      
      public function clear() : void
      {
         this.cache = {};
      }
   }
}

