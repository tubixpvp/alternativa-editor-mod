package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Scene3D;
   import alternativa.engine3d.core.Sector;
   import alternativa.utils.TextUtils;
   
   public class SectorInOtherSceneError extends Engine3DError
   {
      public function SectorInOtherSceneError(param1:Sector = null, param2:Scene3D = null)
      {
         super(TextUtils.insertVars("%1. Sector %2 is aready situated in the other scene",param2,param1),param2);
         this.name = "SectorInOtherSceneError";
      }
   }
}

