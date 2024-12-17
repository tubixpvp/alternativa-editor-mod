package alternativa.engine3d.errors
{
   public class Engine3DError extends Error
   {
      public var source:Object;
      
      public function Engine3DError(param1:String = "", param2:Object = null)
      {
         super(param1);
         this.source = param2;
         this.name = "Engine3DError";
      }
   }
}

