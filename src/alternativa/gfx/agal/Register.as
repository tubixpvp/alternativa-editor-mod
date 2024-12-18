package alternativa.gfx.agal{
    import flash.utils.ByteArray;

    public class Register {

        protected var parent:Register;
        protected var swizzle:int = 228;
        protected var destMask:int = 15;
        protected var index:int;
        protected var emitCode:int;
        protected var relOffset:int;
        protected var relType:int;
        protected var relSel:uint;


        public static function get(_arg_1:int=228, _arg_2:int=15, _arg_3:Register=null):Register{
            var _local_4:Register = new (Register)();
            _local_4.parent = _arg_3;
            if (_arg_3 != null)
            {
                _local_4.index = _arg_3.index;
                _local_4.emitCode = _arg_3.emitCode;
            };
            _local_4.swizzle = _arg_1;
            _local_4.destMask = _arg_2;
            return (_local_4);
        }

        protected static function getSwizzle(_arg_1:int=0, _arg_2:int=1, _arg_3:int=2, _arg_4:int=3):int{
            return (((_arg_1 | (_arg_2 << 2)) | (_arg_3 << 4)) | (_arg_4 << 6));
        }

        protected static function getDestMask(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean):int{
            var _local_5:int;
            if (_arg_1)
            {
                _local_5 = (_local_5 | 0x01);
            };
            if (_arg_2)
            {
                _local_5 = (_local_5 | 0x02);
            };
            if (_arg_3)
            {
                _local_5 = (_local_5 | 0x04);
            };
            if (_arg_4)
            {
                _local_5 = (_local_5 | 0x08);
            };
            return (_local_5);
        }


        public function writeDest(_arg_1:ByteArray):void{
            _arg_1.writeShort(((!(this.parent == null)) ? this.parent.index : this.index));
            _arg_1.writeByte(this.destMask);
            _arg_1.writeByte(((!(this.parent == null)) ? this.parent.emitCode : this.emitCode));
        }

        public function writeSource(_arg_1:ByteArray):void{
            _arg_1.writeShort(((!(this.parent == null)) ? this.parent.index : this.index));
            _arg_1.writeByte(((!(this.parent == null)) ? this.parent.relOffset : this.relOffset));
            _arg_1.writeByte(this.swizzle);
            _arg_1.writeByte(((!(this.parent == null)) ? this.parent.emitCode : this.emitCode));
            _arg_1.writeByte(((!(this.parent == null)) ? this.parent.relType : this.relType));
            _arg_1.writeShort(((!(this.parent == null)) ? this.parent.relSel : this.relSel));
        }

        protected function relate(_arg_1:Register, _arg_2:uint):void{
            this.relType = _arg_1.emitCode;
            this.index = _arg_1.index;
            if ((_arg_1.destMask & (_arg_1.destMask - 1)) != 0)
            {
                throw (new Error("Register must has simple swizzle: .x, .y, .z, .w"));
            };
            this.relSel = (Math.log(_arg_1.destMask) / Math.LN2);
            this.relSel = (this.relSel | (1 << 15));
            this.relOffset = _arg_2;
        }


    }
}//package alternativa.gfx.agal