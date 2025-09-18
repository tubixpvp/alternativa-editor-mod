package alternativa.protocol
{  
   public class LengthCodecHelper
   {
       
      
      public function LengthCodecHelper()
      {
         super();
      }
      
      public static function encodeLength(param1:ProtocolBuffer, param2:int) : void
      {
         var _loc3_:Number = NaN;
         if(param2 < 0)
         {
            throw new Error("Length is incorrect (" + param2 + ")");
         }
         if(param2 < 128)
         {
            param1.writer.writeByte(int(param2 & 127));
         }
         else if(param2 < 16384)
         {
            _loc3_ = (param2 & 16383) + 32768;
            param1.writer.writeByte(int((_loc3_ & 65280) >> 8));
            param1.writer.writeByte(int(_loc3_ & 255));
         }
         else
         {
            if(param2 >= 4194304)
            {
               throw new Error("Length is incorrect (" + param2 + ")");
            }
            _loc3_ = (param2 & 4194303) + 12582912;
            param1.writer.writeByte(int((_loc3_ & 16711680) >> 16));
            param1.writer.writeByte(int((_loc3_ & 65280) >> 8));
            param1.writer.writeByte(int(_loc3_ & 255));
         }
      }
      
      public static function decodeLength(param1:ProtocolBuffer) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc2_:int = int(param1.reader.readByte());
         var _loc3_:Boolean = (_loc2_ & 128) == 0;
         if(_loc3_)
         {
            return _loc2_;
         }
         _loc4_ = int(param1.reader.readByte());
         _loc5_ = (_loc2_ & 64) == 0;
         if(_loc5_)
         {
            return ((_loc2_ & 63) << 8) + (_loc4_ & 255);
         }
         _loc6_ = int(param1.reader.readByte());
         return ((_loc2_ & 63) << 16) + ((_loc4_ & 255) << 8) + (_loc6_ & 255);
      }
   }
}
