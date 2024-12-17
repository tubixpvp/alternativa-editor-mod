package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.utils.TextUtils;
   
   public class Object3DNotFoundError extends ObjectNotFoundError
   {
      public function Object3DNotFoundError(param1:Object3D = null, param2:Object3D = null)
      {
         super(TextUtils.insertVars("Object3D %1. Object %2 not in child list",param2,param1),param1,param2);
         this.name = "Object3DNotFoundError";
      }
   }
}

