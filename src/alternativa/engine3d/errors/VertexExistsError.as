package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.utils.TextUtils;
   
   public class VertexExistsError extends ObjectExistsError
   {
      public function VertexExistsError(param1:Object = null, param2:Mesh = null)
      {
         super(TextUtils.insertVars("Mesh %1. Vertex with ID \'%2\' already exists.",param2,param1),param1,param2);
         this.name = "VertexExistsError";
      }
   }
}

