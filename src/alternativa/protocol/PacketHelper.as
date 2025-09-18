package alternativa.protocol
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class PacketHelper
   {
      
      private static const ZIP_PACKET_SIZE_DELIMITER:int = 2000;
      
      private static const LONG_SIZE_DELIMITER:int = 16384;
      
      private static const ZIPPED_FLAG:int = 64;
      
      private static const BIG_LENGTH_FLAG:int = 128;
      
      private static const HELPER:ByteArray = new ByteArray();
       
      
      public function PacketHelper()
      {
         super();
      }
      
      public static function unwrapPacket(param1:IDataInput, param2:ProtocolBuffer, param3:CompressionType) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(param1.bytesAvailable < 2)
         {
            return false;
         }
         var _loc6_:int = param1.readByte();
         var _loc7_:Boolean = (_loc6_ & BIG_LENGTH_FLAG) != 0;
         if(_loc7_)
         {
            if(param1.bytesAvailable < 3)
            {
               return false;
            }
            _loc4_ = param3 != CompressionType.NONE;
            _loc10_ = (_loc6_ ^ BIG_LENGTH_FLAG) << 24;
            _loc11_ = (param1.readByte() & 255) << 16;
            _loc12_ = (param1.readByte() & 255) << 8;
            _loc13_ = param1.readByte() & 255;
            _loc5_ = _loc10_ + _loc11_ + _loc12_ + _loc13_;
         }
         else
         {
            _loc4_ = (_loc6_ & ZIPPED_FLAG) != 0;
            _loc10_ = (_loc6_ & 63) << 8;
            _loc12_ = param1.readByte() & 255;
            _loc5_ = _loc10_ + _loc12_;
         }
         if(param1.bytesAvailable < _loc5_)
         {
            return false;
         }
         var _loc8_:ByteArray = new ByteArray();
         if(_loc5_ != 0)
         {
            param1.readBytes(_loc8_,0,_loc5_);
         }
         if(_loc4_)
         {
            _loc8_.uncompress();
         }
         _loc8_.position = 0;
         var _loc9_:ByteArray = ByteArray(param2.reader);
         OptionalMapCodecHelper.decodeNullMap(_loc8_,param2.optionalMap);
         _loc9_.writeBytes(_loc8_,_loc8_.position,_loc8_.length - _loc8_.position);
         _loc9_.position = 0;
         return true;
      }
      
      public static function wrapPacket(param1:IDataOutput, param2:ProtocolBuffer, param3:CompressionType) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Boolean = false;
         switch(param3)
         {
            case CompressionType.NONE:
               break;
            case CompressionType.DEFLATE:
               _loc4_ = true;
               break;
            case CompressionType.DEFLATE_AUTO:
               _loc4_ = determineZipped(param2.reader);
         }
         HELPER.position = 0;
         HELPER.length = 0;
         OptionalMapCodecHelper.encodeNullMap(param2.optionalMap,HELPER);
         param2.reader.readBytes(HELPER,HELPER.position,param2.reader.bytesAvailable);
         HELPER.position = 0;
         var _loc5_:Boolean = isLongSize(HELPER);
         if(_loc4_)
         {
            HELPER.compress();
         }
         var _loc6_:int = int(HELPER.length);
         if(_loc5_)
         {
            _loc7_ = _loc6_ + (BIG_LENGTH_FLAG << 24);
            param1.writeInt(_loc7_);
         }
         else
         {
            _loc8_ = int(((_loc6_ & 65280) >> 8) + (_loc4_ ? ZIPPED_FLAG : 0));
            _loc9_ = int(_loc6_ & 255);
            param1.writeByte(_loc8_);
            param1.writeByte(_loc9_);
         }
         param1.writeBytes(HELPER,0,_loc6_);
      }
      
      private static function isLongSize(param1:IDataInput) : Boolean
      {
         return param1.bytesAvailable >= LONG_SIZE_DELIMITER || param1.bytesAvailable == -1;
      }
      
      private static function determineZipped(param1:IDataInput) : Boolean
      {
         return param1.bytesAvailable == -1 || param1.bytesAvailable > ZIP_PACKET_SIZE_DELIMITER;
      }
      
      private static function bytesToString(param1:ByteArray, param2:int, param3:int, param4:int) : String
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc5_:String = "";
         var _loc6_:int = int(param1.position);
         param1.position = param2;
         while(param1.bytesAvailable > 0 && _loc9_ < param3)
         {
            _loc9_++;
            _loc10_ = param1.readUnsignedByte().toString(16);
            if(_loc10_.length == 1)
            {
               _loc10_ = "0" + _loc10_;
            }
            _loc5_ += _loc10_;
            _loc8_++;
            if(_loc8_ == 4)
            {
               _loc8_ = 0;
               _loc7_++;
               if(_loc7_ == param4)
               {
                  _loc7_ = 0;
                  _loc5_ += "\n";
               }
               else
               {
                  _loc5_ += "  ";
               }
            }
            else
            {
               _loc5_ += " ";
            }
         }
         if(_loc9_ < param3)
         {
            _loc5_ += "\nOnly " + _loc9_ + " of " + param3 + " bytes have been read";
         }
         param1.position = _loc6_;
         return _loc5_;
      }
   }
}
