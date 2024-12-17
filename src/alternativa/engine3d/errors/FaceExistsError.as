package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Surface;
   import alternativa.utils.TextUtils;
   
   public class FaceExistsError extends ObjectExistsError
   {
      public function FaceExistsError(param1:Object = null, param2:Object = null)
      {
         var loc3:* = null;
         if(param2 is Mesh)
         {
            loc3 = "Mesh ";
         }
         else if(param2 is Surface)
         {
            loc3 = "Surface ";
         }
         if(param1 is Face)
         {
            loc3 += "%1. Face %2 already exists.";
         }
         else
         {
            loc3 += "%1. Face with ID \'%2\' already exists.";
         }
         super(TextUtils.insertVars(loc3,param2,param1),param1,param2);
         this.name = "FaceExistsError";
      }
   }
}

