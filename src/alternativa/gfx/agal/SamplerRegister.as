package alternativa.gfx.agal{
    import flash.utils.ByteArray;

    public class SamplerRegister extends Register {

        protected var samplerbits:int = 5;

        public function SamplerRegister(_arg_1:int){
            this.index = _arg_1;
        }

        public function dim(_arg_1:SamplerDim):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        public function type(_arg_1:SamplerType):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        public function special(_arg_1:SamplerSpecial):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        public function repeat(_arg_1:SamplerRepeat):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        public function mipmap(_arg_1:SamplerMipMap):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        public function filter(_arg_1:SamplerFilter):SamplerRegister{
            this.addSamplerOption(_arg_1);
            return (this);
        }

        private function addSamplerOption(_arg_1:SamplerOption):void{
            this.samplerbits = _arg_1.apply(this.samplerbits);
        }

        override public function writeSource(_arg_1:ByteArray):void{
            _arg_1.writeShort(index);
            _arg_1.writeShort(0);
            _arg_1.writeUnsignedInt(this.samplerbits);
            this.samplerbits = 5;
        }


    }
}//package alternativa.gfx.agal