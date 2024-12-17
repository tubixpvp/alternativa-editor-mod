package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.utils.TextUtils;
   
   public class SurfaceExistsError extends ObjectExistsError
   {
      public function SurfaceExistsError(param1:Object = null, param2:Mesh = null)
      {
         super(TextUtils.insertVars("Mesh %1. Surface with ID \'%2\' already exists.",param2,param1),param1,param2);
         this.name = "SurfaceExistsError";
      }
   }
}

