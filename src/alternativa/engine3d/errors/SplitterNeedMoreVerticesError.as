package alternativa.engine3d.errors
{
   import alternativa.utils.TextUtils;
   
   public class SplitterNeedMoreVerticesError extends Engine3DError
   {
      public var count:uint;
      
      public function SplitterNeedMoreVerticesError(param1:uint = 0)
      {
         super(TextUtils.insertVars("%1 points not enough for splitter creation.",param1),null);
         this.count = param1;
         this.name = "SplitterNeedMoreVerticesError";
      }
   }
}

