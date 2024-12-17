package alternativa.engine3d.errors
{
   import alternativa.engine3d.core.Scene3D;
   import alternativa.engine3d.core.Splitter;
   import alternativa.utils.TextUtils;
   
   public class SplitterInOtherSceneError extends Engine3DError
   {
      public function SplitterInOtherSceneError(param1:Splitter = null, param2:Scene3D = null)
      {
         super(TextUtils.insertVars("%1. Splitter %2 is aready situated in the other scene",param2,param1),param2);
         this.name = "SplitterInOtherSceneError";
      }
   }
}

