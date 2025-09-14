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
      
      public function addPrimitives(libraryName:String, groupName:String, name:String, param4:Vector.<CollisionPrimitive>) : void
      {
         var loc5:Object = this.cache[libraryName];
         if(loc5 == null)
         {
            this.cache[libraryName] = loc5 = {};
         }
         var loc6:Object = loc5[groupName];
         if(loc6 == null)
         {
            loc5[groupName] = loc6 = {};
         }
         loc6[name] = param4;
      }
      
      public function getPrimitives(libraryName:String, groupName:String, name:String) : Vector.<CollisionPrimitive>
      {
         var loc4:Object = this.cache[libraryName];
         if(loc4 == null)
         {
            return null;
         }
         loc4 = loc4[groupName];
         return loc4 != null ? loc4[name] : null;
      }
      
      public function clear() : void
      {
         this.cache = {};
      }
   }
}

