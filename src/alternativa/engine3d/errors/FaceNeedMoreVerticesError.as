package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.utils.TextUtils;
   
   public class FaceNeedMoreVerticesError extends Engine3DError
   {
      public var count:uint;
      
      public function FaceNeedMoreVerticesError(param1:Mesh = null, param2:uint = 0)
      {
         super(TextUtils.insertVars("Mesh %1. %2 vertices not enough for face creation.",param1,param2),param1);
         this.count = param2;
         this.name = "FaceNeedMoreVerticesError";
      }
   }
}

