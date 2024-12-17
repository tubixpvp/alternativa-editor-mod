package alternativa.utils
{
   public class ColorUtils
   {
      public static const BLACK:uint = 0;
      
      public static const RED:uint = 8323072;
      
      public static const GREEN:uint = 32512;
      
      public static const BLUE:uint = 127;
      
      public static const BROWN:uint = 8355584;
      
      public static const CYAN:uint = 32639;
      
      public static const MAGENTA:uint = 8323199;
      
      public static const GRAY:uint = 8355711;
      
      public static const LIGHT_RED:uint = 16711680;
      
      public static const LIGHT_GREEN:uint = 65280;
      
      public static const LIGHT_BLUE:uint = 255;
      
      public static const YELLOW:uint = 16776960;
      
      public static const LIGHT_CYAN:uint = 65535;
      
      public static const LIGHT_MAGENTA:uint = 16711935;
      
      public static const WHITE:uint = 16777215;
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function interpolate(param1:uint, param2:uint, param3:Number = 0.5) : uint
      {
         var loc4:int = (param1 & 0xFF0000) >>> 16;
         loc4 = loc4 + (((param2 & 0xFF0000) >>> 16) - loc4) * param3;
         var loc5:int = (param1 & 0xFF00) >>> 8;
         loc5 = loc5 + (((param2 & 0xFF00) >>> 8) - loc5) * param3;
         var loc6:* = param1 & 0xFF;
         loc6 = loc6 + ((param2 & 0xFF) - loc6) * param3;
         return rgb(loc4,loc5,loc6);
      }
      
      public static function random(param1:uint = 0, param2:uint = 255, param3:uint = 0, param4:uint = 255, param5:uint = 0, param6:uint = 255) : uint
      {
         return rgb(MathUtils.random(param1,param2),MathUtils.random(param3,param4),MathUtils.random(param5,param6));
      }
      
      public static function sum(param1:uint, param2:uint) : uint
      {
         var loc3:int = (param1 & 0xFF0000) + (param2 & 0xFF0000);
         var loc4:int = (param1 & 0xFF00) + (param2 & 0xFF00);
         var loc5:int = (param1 & 0xFF) + (param2 & 0xFF);
         return (!!(loc3 >>> 24) ? 16711680 : loc3) + (!!(loc4 >>> 16) ? 65280 : loc4) + (!!(loc5 >>> 8) ? 255 : loc5);
      }
      
      public static function red(param1:uint) : uint
      {
         return (param1 & 0xFF0000) >>> 16;
      }
      
      public static function rgb(param1:int, param2:int, param3:int) : uint
      {
         return (param1 < 0 ? 0 : (!!(param1 >>> 8) ? 16711680 : param1 << 16)) + (param2 < 0 ? 0 : (!!(param2 >>> 8) ? 65280 : param2 << 8)) + (param3 < 0 ? 0 : (!!(param3 >>> 8) ? 255 : param3));
      }
      
      public static function green(param1:uint) : uint
      {
         return (param1 & 0xFF00) >>> 8;
      }
      
      public static function multiply(param1:uint, param2:Number) : uint
      {
         var loc3:int = ((param1 & 0xFF0000) >>> 16) * param2;
         var loc4:int = ((param1 & 0xFF00) >>> 8) * param2;
         var loc5:int = (param1 & 0xFF) * param2;
         return rgb(loc3,loc4,loc5);
      }
      
      public static function blue(param1:uint) : uint
      {
         return param1 & 0xFF;
      }
      
      public static function difference(param1:uint, param2:uint) : uint
      {
         var loc3:int = (param1 & 0xFF0000) - (param2 & 0xFF0000);
         var loc4:int = (param1 & 0xFF00) - (param2 & 0xFF00);
         var loc5:int = (param1 & 0xFF) - (param2 & 0xFF);
         return (loc3 < 0 ? 0 : loc3) + (loc4 < 0 ? 0 : loc4) + (loc5 < 0 ? 0 : loc5);
      }
   }
}

