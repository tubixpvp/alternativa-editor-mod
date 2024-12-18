package alternativa.gfx.agal{
    public class SamplerOption {

        public var mask:uint;
        public var flag:uint;

        public function SamplerOption(_arg_1:uint, _arg_2:uint){
            this.mask = _arg_1;
            this.flag = _arg_2;
        }

        public function apply(_arg_1:int):int{
            _arg_1 = (_arg_1 & (~(15 << this.flag)));
            return (_arg_1 | (this.mask << this.flag));
        }


    }
}//package alternativa.gfx.agal