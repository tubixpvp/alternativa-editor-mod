package alternativa.protocol
{
   import flash.utils.ByteArray;
   
   public class OptionalMap
   {
       
      
      private var readPosition:int;
      
      private var size:int;
      
      private var map:ByteArray;
      
      public function OptionalMap(param1:int = 0, param2:ByteArray = null)
      {
         super();
         this.init(param1,param2);
      }
      
      public function getReadPosition() : int
      {
         return this.readPosition;
      }
      
      public function setReadPosition(param1:int) : void
      {
         this.readPosition = param1;
      }
      
      public function reset() : void
      {
         this.readPosition = 0;
      }
      
      public function init(param1:int = 0, param2:ByteArray = null) : void
      {
         this.map = param2;
         if(param2 == null)
         {
            this.map = new ByteArray();
         }
         else
         {
            this.map.position = 0;
         }
         this.size = param1;
         this.readPosition = 0;
      }
      
      public function clear() : void
      {
         this.size = 0;
         this.readPosition = 0;
      }
      
      public function addBit(param1:Boolean) : void
      {
         this.setBit(this.size,param1);
         ++this.size;
      }
      
      public function hasNextBit() : Boolean
      {
         return this.readPosition < this.size;
      }
      
      public function get() : Boolean
      {
         if(this.readPosition >= this.size)
         {
            throw new Error("Index out of bounds: " + this.readPosition);
         }
         var _loc1_:Boolean = this.getBit(this.readPosition);
         ++this.readPosition;
         return _loc1_;
      }
      
      public function getMap() : ByteArray
      {
         return this.map;
      }
      
      public function getSize() : int
      {
         return this.size;
      }
      
      private function getBit(param1:int) : Boolean
      {
         var _loc2_:int = param1 >> 3;
         var _loc3_:int = 7 ^ param1 & 7;
         this.map.position = _loc2_;
         return (this.map.readByte() & 1 << _loc3_) != 0;
      }
      
      private function setBit(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = param1 >> 3;
         var _loc4_:int = 7 ^ param1 & 7;
         this.map.position = _loc3_;
         if(param2)
         {
            this.map.writeByte(int(this.map[_loc3_] | 1 << _loc4_));
         }
         else
         {
            this.map.writeByte(int(this.map[_loc3_] & (255 ^ 1 << _loc4_)));
         }
      }
      
      private function convertSize(param1:int) : int
      {
         var _loc2_:int = param1 >> 3;
         var _loc3_:int = (param1 & 7) == 0 ? 0 : 1;
         return _loc2_ + _loc3_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "readPosition: " + this.readPosition + " size:" + this.getSize() + " mask:";
         var _loc2_:int = this.readPosition;
         var _loc3_:int = this.readPosition;
         while(_loc3_ < this.getSize())
         {
            _loc1_ += this.get() ? "1" : "0";
            _loc3_++;
         }
         this.readPosition = _loc2_;
         return _loc1_;
      }
      
      public function clone() : OptionalMap
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeBytes(this.map,0,this.convertSize(this.size));
         var _loc2_:OptionalMap = new OptionalMap(this.size,_loc1_);
         _loc2_.readPosition = this.readPosition;
         return _loc2_;
      }
   }
}
