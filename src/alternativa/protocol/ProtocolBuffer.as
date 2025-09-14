package alternativa.protocol
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ProtocolBuffer
   {
       
      
      private var _writer:IDataOutput;
      
      private var _reader:IDataInput;
      
      private var _optionalMap:OptionalMap;
      
      public function ProtocolBuffer(param1:IDataOutput, param2:IDataInput, param3:OptionalMap)
      {
         super();
         this._writer = param1;
         this._reader = param2;
         this._optionalMap = param3;
      }
      
      public function get writer() : IDataOutput
      {
         return this._writer;
      }
      
      public function set writer(param1:IDataOutput) : void
      {
         this._writer = param1;
      }
      
      public function get reader() : IDataInput
      {
         return this._reader;
      }
      
      public function set reader(param1:IDataInput) : void
      {
         this._reader = param1;
      }
      
      public function get optionalMap() : OptionalMap
      {
         return this._optionalMap;
      }
      
      public function set optionalMap(param1:OptionalMap) : void
      {
         this._optionalMap = param1;
      }
      
      public function toString() : String
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc1_:String = "";
         var _loc2_:int = int(ByteArray(this.reader).position);
         _loc1_ += "\n=== Optional Map ===\n";
         _loc1_ += this.optionalMap.toString();
         _loc1_ += "\n=== Dump data (trunc 100 bytes) ===\n";
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(Boolean(ByteArray(this.reader).bytesAvailable) && _loc5_ < 100)
         {
            _loc6_ = int(this.reader.readByte());
            _loc7_ = String.fromCharCode(_loc6_);
            if(_loc6_ >= 0 && _loc6_ < 16)
            {
               _loc1_ += "0";
            }
            if(_loc6_ < 0)
            {
               _loc6_ = 256 + _loc6_;
            }
            _loc1_ += _loc6_.toString(16);
            _loc1_ += " ";
            if(_loc6_ < 12 && _loc6_ > 128)
            {
               _loc4_ += ".";
            }
            else
            {
               _loc4_ += _loc7_;
            }
            _loc3_++;
            if(_loc3_ > 16)
            {
               _loc1_ += "\t";
               _loc1_ += _loc4_;
               _loc1_ += "\n";
               _loc3_ = 0;
               _loc4_ = "";
            }
            _loc5_++;
         }
         if(_loc3_ != 0)
         {
            while(_loc3_ < 18)
            {
               _loc3_++;
               _loc1_ += "   ";
            }
            _loc1_ += "\t";
            _loc1_ += _loc4_;
            _loc1_ += "\n";
         }
         ByteArray(this.reader).position = _loc2_;
         return _loc1_;
      }
   }
}
