package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Surface;
   import alternativa.utils.TextUtils;
   
   public class InvalidIDError extends Engine3DError
   {
      public var id:Object;
      
      public function InvalidIDError(param1:Object = null, param2:Object = null)
      {
         var loc3:String = null;
         if(param2 is Mesh)
         {
            loc3 = "Mesh %2. ";
         }
         else if(param2 is Surface)
         {
            loc3 = "Surface %2. ";
         }
         super(TextUtils.insertVars(loc3 + "ID %1 is reserved and cannot be used",[param1,param2]),param2);
         this.id = param1;
         this.name = "InvalidIDError";
      }
   }
}

