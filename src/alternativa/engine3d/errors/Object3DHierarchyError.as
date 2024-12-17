package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.utils.TextUtils;
   
   public class Object3DHierarchyError extends Engine3DError
   {
      public var object:Object3D;
      
      public function Object3DHierarchyError(param1:Object3D = null, param2:Object3D = null)
      {
         super(TextUtils.insertVars("Object3D %1. Object %2 cannot be added",param2,param1),param2);
         this.object = param1;
         this.name = "Object3DHierarchyError";
      }
   }
}

