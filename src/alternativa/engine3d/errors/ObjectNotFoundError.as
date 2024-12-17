package alternativa.engine3d.errors
{
   public class ObjectNotFoundError extends Engine3DError
   {
      public var object:Object;
      
      public function ObjectNotFoundError(param1:String = "", param2:Object = null, param3:Object = null)
      {
         super(param1,param3);
         this.object = param2;
         this.name = "ObjectNotFoundError";
      }
   }
}

