package alternativa.protocol
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class OptionalMapCodecHelper
   {
      
      private static const INPLACE_MASK_FLAG:int = 128;
      
      private static const MASK_LENGTH_2_BYTES_FLAG:int = 64;
      
      private static const INPLACE_MASK_1_BYTES:int = 32;
      
      private static const INPLACE_MASK_3_BYTES:int = 96;
      
      private static const INPLACE_MASK_2_BYTES:int = 64;
      
      private static const MASK_LENGTH_1_BYTE:int = 128;
      
      private static const MASK_LEGTH_3_BYTE:int = 12582912;
       
      
      public function OptionalMapCodecHelper()
      {
         super();
      }
      
      public static function encodeNullMap(param1:OptionalMap, param2:ByteArray) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:int = param1.getSize();
         var _loc4_:ByteArray = param1.getMap();
         if(_loc3_ <= 5)
         {
            param2.writeByte(int((_loc4_[0] & 255) >>> 3));
         }
         else if(_loc3_ <= 13)
         {
            param2.writeByte(int(((_loc4_[0] & 255) >>> 3) + INPLACE_MASK_1_BYTES));
            param2.writeByte(((_loc4_[1] & 255) >>> 3) + (_loc4_[0] << 5));
         }
         else if(_loc3_ <= 21)
         {
            param2.writeByte(int(((_loc4_[0] & 255) >>> 3) + INPLACE_MASK_2_BYTES));
            param2.writeByte(int(((_loc4_[1] & 255) >>> 3) + (_loc4_[0] << 5)));
            param2.writeByte(int(((_loc4_[2] & 255) >>> 3) + (_loc4_[1] << 5)));
         }
         else if(_loc3_ <= 29)
         {
            param2.writeByte(int(((_loc4_[0] & 255) >>> 3) + INPLACE_MASK_3_BYTES));
            param2.writeByte(int(((_loc4_[1] & 255) >>> 3) + (_loc4_[0] << 5)));
            param2.writeByte(int(((_loc4_[2] & 255) >>> 3) + (_loc4_[1] << 5)));
            param2.writeByte(int(((_loc4_[3] & 255) >>> 3) + (_loc4_[2] << 5)));
         }
         else if(_loc3_ <= 504)
         {
            _loc5_ = (_loc3_ >>> 3) + ((_loc3_ & 7) == 0 ? 0 : 1);
            _loc6_ = int((_loc5_ & 255) + MASK_LENGTH_1_BYTE);
            param2.writeByte(_loc6_);
            param2.writeBytes(_loc4_,0,_loc5_);
         }
         else
         {
            if(_loc3_ > 33554432)
            {
               throw new Error("NullMap overflow");
            }
            _loc5_ = (_loc3_ >>> 3) + ((_loc3_ & 7) == 0 ? 0 : 1);
            _loc7_ = _loc5_ + MASK_LEGTH_3_BYTE;
            _loc6_ = int((_loc7_ & 16711680) >>> 16);
            _loc8_ = int((_loc7_ & 65280) >>> 8);
            _loc9_ = int(_loc7_ & 255);
            param2.writeByte(_loc6_);
            param2.writeByte(_loc8_);
            param2.writeByte(_loc9_);
            param2.writeBytes(_loc4_,0,_loc5_);
         }
      }
      
      public static function decodeNullMap(param1:IDataInput, param2:OptionalMap) : void
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         var _loc5_:int = int(param1.readByte());
         var _loc6_:Boolean = (_loc5_ & INPLACE_MASK_FLAG) != 0;
         if(_loc6_)
         {
            _loc7_ = _loc5_ & 63;
            _loc8_ = (_loc5_ & MASK_LENGTH_2_BYTES_FLAG) != 0;
            if(_loc8_)
            {
               _loc10_ = int(param1.readByte());
               _loc11_ = int(param1.readByte());
               _loc4_ = (_loc7_ << 16) + ((_loc10_ & 255) << 8) + (_loc11_ & 255);
            }
            else
            {
               _loc4_ = _loc7_;
            }
            param1.readBytes(_loc3_,0,_loc4_);
            _loc9_ = _loc4_ << 3;
            param2.init(_loc9_,_loc3_);
            return;
         }
         _loc7_ = int(_loc5_ << 3);
         _loc4_ = int((_loc5_ & 96) >> 5);
         switch(_loc4_)
         {
            case 0:
               _loc3_.writeByte(_loc7_);
               param2.init(5,_loc3_);
               return;
            case 1:
               _loc10_ = int(param1.readByte());
               _loc3_.writeByte(int(_loc7_ + ((_loc10_ & 255) >>> 5)));
               _loc3_.writeByte(int(_loc10_ << 3));
               param2.init(13,_loc3_);
               return;
            case 2:
               _loc10_ = int(param1.readByte());
               _loc11_ = int(param1.readByte());
               _loc3_.writeByte(int(_loc7_ + ((_loc10_ & 255) >>> 5)));
               _loc3_.writeByte(int((_loc10_ << 3) + ((_loc11_ & 255) >>> 5)));
               _loc3_.writeByte(int(_loc11_ << 3));
               param2.init(21,_loc3_);
               return;
            case 3:
               _loc10_ = int(param1.readByte());
               _loc11_ = int(param1.readByte());
               _loc12_ = int(param1.readByte());
               _loc3_.writeByte(int(_loc7_ + ((_loc10_ & 255) >>> 5)));
               _loc3_.writeByte(int((_loc10_ << 3) + ((_loc11_ & 255) >>> 5)));
               _loc3_.writeByte(int((_loc11_ << 3) + ((_loc12_ & 255) >>> 5)));
               _loc3_.writeByte(int(_loc12_ << 3));
               param2.init(29,_loc3_);
               return;
            default:
               throw new Error("Invalid OptionalMap");
         }
      }
   }
}
