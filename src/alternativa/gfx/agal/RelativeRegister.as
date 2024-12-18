package alternativa.gfx.agal{
    public class RelativeRegister extends CommonRegister {

        public function RelativeRegister(_arg_1:int, _arg_2:int){
            super(_arg_1, _arg_2);
        }

        public function rel(_arg_1:Register, _arg_2:uint):CommonRegister{
            relate(_arg_1, _arg_2);
            return (this);
        }


    }
}//package alternativa.gfx.agal