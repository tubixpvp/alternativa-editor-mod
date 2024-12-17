package alternativa.utils
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class ObjectUtils
   {
      public function ObjectUtils()
      {
         super();
      }
      
      public static function getClassTree(param1:*, param2:Class = null) : Array
      {
         var loc3:Array = new Array();
         var loc4:Class = Class(getDefinitionByName(getQualifiedClassName(param1)));
         param2 = param2 == null ? Object : param2;
         while(loc4 != param2)
         {
            loc3.push(loc4);
            loc4 = Class(getDefinitionByName(getQualifiedSuperclassName(loc4)));
         }
         loc3.push(loc4);
         return loc3;
      }
      
      public static function getClass(param1:*) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function getClassName(param1:*) : String
      {
         var loc2:String = getQualifiedClassName(param1);
         var loc3:int = int(loc2.indexOf("::"));
         return loc3 == -1 ? loc2 : loc2.substring(loc3 + 2);
      }
   }
}

