package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Vertex;
   import alternativa.utils.TextUtils;
   
   public class VertexNotFoundError extends ObjectNotFoundError
   {
      public function VertexNotFoundError(param1:Object = null, param2:Mesh = null)
      {
         if(param1 is Vertex)
         {
            message = "Mesh %1. Vertex %2 not found.";
         }
         else
         {
            message = "Mesh %1. Vertex with ID \'%2\' not found.";
         }
         super(TextUtils.insertVars(message,param2,param1),param1,param2);
         this.name = "VertexNotFoundError";
      }
   }
}

