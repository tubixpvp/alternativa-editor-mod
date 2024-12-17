package alternativa.utils
{
   import flash.geom.Point;
   
   public final class MathUtils
   {
      private static const toRad:Number = Math.PI / 180;
      
      private static const toDeg:Number = 180 / Math.PI;
      
      public static const DEG1:Number = toRad;
      
      public static const DEG5:Number = Math.PI / 36;
      
      public static const DEG10:Number = Math.PI / 18;
      
      public static const DEG30:Number = Math.PI / 6;
      
      public static const DEG45:Number = Math.PI / 4;
      
      public static const DEG60:Number = Math.PI / 3;
      
      public static const DEG90:Number = Math.PI / 2;
      
      public static const DEG180:Number = Math.PI;
      
      public static const DEG360:Number = Math.PI + Math.PI;
      
      public function MathUtils()
      {
         super();
      }
      
      public static function vectorCross(param1:Point, param2:Point) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function segmentDistance(param1:Point, param2:Point, param3:Point) : Number
      {
         var loc4:Number = param2.x - param1.x;
         var loc5:Number = param2.y - param1.y;
         var loc6:Number = param3.x - param1.x;
         var loc7:Number = param3.y - param1.y;
         return (loc4 * loc7 - loc5 * loc6) / Math.sqrt(loc4 * loc4 + loc5 * loc5);
      }
      
      public static function vectorAngleFast(param1:Point, param2:Point) : Number
      {
         var loc3:Number = vectorDot(param1,param2);
         if(Math.abs(loc3) > 1)
         {
            loc3 = loc3 > 0 ? 1 : -1;
         }
         return Math.acos(loc3);
      }
      
      public static function randomAngle() : Number
      {
         return Math.random() * DEG360;
      }
      
      public static function vectorAngle(param1:Point, param2:Point) : Number
      {
         var loc3:Number = param1.length * param2.length;
         var loc4:Number = loc3 != 0 ? vectorDot(param1,param2) / loc3 : 1;
         return Math.acos(loc4);
      }
      
      public static function limitAngle(param1:Number) : Number
      {
         var loc2:Number = param1 % DEG360;
         return loc2 > 0 ? (loc2 > DEG180 ? loc2 - DEG360 : loc2) : (loc2 < -DEG180 ? loc2 + DEG360 : loc2);
      }
      
      public static function random(param1:Number = NaN, param2:Number = NaN) : Number
      {
         if(isNaN(param1))
         {
            return Math.random();
         }
         if(isNaN(param2))
         {
            return Math.random() * param1;
         }
         return Math.random() * (param2 - param1) + param1;
      }
      
      public static function vectorDot(param1:Point, param2:Point) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function toDegree(param1:Number) : Number
      {
         return param1 * toDeg;
      }
      
      public static function deltaAngle(param1:Number, param2:Number) : Number
      {
         var loc3:Number = param2 - param1;
         if(loc3 > DEG180)
         {
            return loc3 - DEG360;
         }
         if(loc3 < -DEG180)
         {
            return loc3 + DEG360;
         }
         return loc3;
      }
      
      public static function toRadian(param1:Number) : Number
      {
         return param1 * toRad;
      }
      
      public static function triangleHasPoint(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         if(vectorCross(param3.subtract(param1),param4.subtract(param1)) <= 0)
         {
            if(vectorCross(param2.subtract(param3),param4.subtract(param3)) <= 0)
            {
               if(vectorCross(param1.subtract(param2),param4.subtract(param2)) <= 0)
               {
                  return true;
               }
               return false;
            }
            return false;
         }
         return false;
      }
      
      public static function equals(param1:Number, param2:Number, param3:Number = 0) : Boolean
      {
         return param2 - param1 <= param3 && param2 - param1 >= -param3;
      }
   }
}

