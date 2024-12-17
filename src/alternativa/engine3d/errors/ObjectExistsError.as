package alternativa.engine3d.errors
{
   public class ObjectExistsError extends Engine3DError
   {
      public var object:Object;
      
      public function ObjectExistsError(param1:String = "", param2:Object = null, param3:Object = null)
      {
         super(param1,param3);
         this.object = param2;
         this.name = "ObjectExistsError";
      }
   }
}

