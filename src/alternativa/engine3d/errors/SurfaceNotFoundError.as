package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Surface;
   import alternativa.utils.TextUtils;
   
   public class SurfaceNotFoundError extends ObjectNotFoundError
   {
      public function SurfaceNotFoundError(param1:Object = null, param2:Mesh = null)
      {
         if(param2 == null)
         {
         }
         if(param1 is Surface)
         {
            message = "Mesh %1. Surface %2 not found.";
         }
         else
         {
            message = "Mesh %1. Surface with ID \'%2\' not found.";
         }
         super(TextUtils.insertVars(message,param2,param1),param1,param2);
         this.name = "SurfaceNotFoundError";
      }
   }
}

