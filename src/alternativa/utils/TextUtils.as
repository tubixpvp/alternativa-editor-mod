package alternativa.utils
{
   public final class TextUtils
   {
      public function TextUtils()
      {
         super();
      }
      
      public static function insertVars(param1:String, ... rest) : String
      {
         var loc3:String = param1;
         var loc4:int = 1;
         while(loc4 <= rest.length)
         {
            loc3 = loc3.replace("%" + loc4.toString(),rest[loc4 - 1]);
            loc4++;
         }
         return loc3;
      }
   }
}

