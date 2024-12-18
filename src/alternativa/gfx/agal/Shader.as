package alternativa.gfx.agal{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class Shader {

        public static const v0:CommonRegister = new CommonRegister(0, 4);
        public static const v1:CommonRegister = new CommonRegister(1, 4);
        public static const v2:CommonRegister = new CommonRegister(2, 4);
        public static const v3:CommonRegister = new CommonRegister(3, 4);
        public static const v4:CommonRegister = new CommonRegister(4, 4);
        public static const v5:CommonRegister = new CommonRegister(5, 4);
        public static const v6:CommonRegister = new CommonRegister(6, 4);
        public static const v7:CommonRegister = new CommonRegister(7, 4);
        public static const cc:RelativeRegister = new RelativeRegister(0, 1);
        protected static const MOV:int = 0;
        protected static const ADD:int = 1;
        protected static const SUB:int = 2;
        protected static const MUL:int = 3;
        protected static const DIV:int = 4;
        protected static const RCP:int = 5;
        protected static const MIN:int = 6;
        protected static const MAX:int = 7;
        protected static const FRC:int = 8;
        protected static const SQT:int = 9;
        protected static const RSQ:int = 10;
        protected static const POW:int = 11;
        protected static const LOG:int = 12;
        protected static const EXP:int = 13;
        protected static const NRM:int = 14;
        protected static const SIN:int = 15;
        protected static const COS:int = 16;
        protected static const CRS:int = 17;
        protected static const DP3:int = 18;
        protected static const DP4:int = 19;
        protected static const ABS:int = 20;
        protected static const NEG:int = 21;
        protected static const SAT:int = 22;
        protected static const M33:int = 23;
        protected static const M44:int = 24;
        protected static const M34:int = 25;
        protected static const DDX:int = 26;
        protected static const DDY:int = 27;
        protected static const IFE:int = 28;
        protected static const INE:int = 29;
        protected static const IFG:int = 30;
        protected static const IFL:int = 31;
        protected static const ELS:int = 32;
        protected static const EIF:int = 33;
        protected static const TED:int = 38;
        protected static const KIL:int = 39;
        protected static const TEX:int = 40;
        protected static const SGE:int = 41;
        protected static const SLT:int = 42;
        protected static const SGN:int = 43;
        protected static const SEQ:int = 44;
        protected static const SNE:int = 45;

        protected var data:ByteArray;

        public function Shader(){
            this.data = new ByteArray();
            this.data.endian = Endian.LITTLE_ENDIAN;
            this.data.writeByte(160);
            this.data.writeUnsignedInt(1);
            this.data.writeByte(161);
        }

        public function mov(_arg_1:Register, _arg_2:Register):void{
            this.op2(MOV, _arg_1, _arg_2);
        }

        public function add(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(ADD, _arg_1, _arg_2, _arg_3);
        }

        public function sub(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SUB, _arg_1, _arg_2, _arg_3);
        }

        public function mul(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(MUL, _arg_1, _arg_2, _arg_3);
        }

        public function div(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(DIV, _arg_1, _arg_2, _arg_3);
        }

        public function rcp(_arg_1:Register, _arg_2:Register):void{
            this.op2(RCP, _arg_1, _arg_2);
        }

        public function min(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(MIN, _arg_1, _arg_2, _arg_3);
        }

        public function max(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(MAX, _arg_1, _arg_2, _arg_3);
        }

        public function frc(_arg_1:Register, _arg_2:Register):void{
            this.op2(FRC, _arg_1, _arg_2);
        }

        public function sqt(_arg_1:Register, _arg_2:Register):void{
            this.op2(SQT, _arg_1, _arg_2);
        }

        public function rsq(_arg_1:Register, _arg_2:Register):void{
            this.op2(RSQ, _arg_1, _arg_2);
        }

        public function pow(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(POW, _arg_1, _arg_2, _arg_3);
        }

        public function log(_arg_1:Register, _arg_2:Register):void{
            this.op2(LOG, _arg_1, _arg_2);
        }

        public function exp(_arg_1:Register, _arg_2:Register):void{
            this.op2(EXP, _arg_1, _arg_2);
        }

        public function nrm(_arg_1:Register, _arg_2:Register):void{
            this.op2(NRM, _arg_1, _arg_2);
        }

        public function sin(_arg_1:Register, _arg_2:Register):void{
            this.op2(SIN, _arg_1, _arg_2);
        }

        public function cos(_arg_1:Register, _arg_2:Register):void{
            this.op2(COS, _arg_1, _arg_2);
        }

        public function crs(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(CRS, _arg_1, _arg_2, _arg_3);
        }

        public function dp3(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(DP3, _arg_1, _arg_2, _arg_3);
        }

        public function dp4(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(DP4, _arg_1, _arg_2, _arg_3);
        }

        public function abs(_arg_1:Register, _arg_2:Register):void{
            this.op2(ABS, _arg_1, _arg_2);
        }

        public function neg(_arg_1:Register, _arg_2:Register):void{
            this.op2(NEG, _arg_1, _arg_2);
        }

        public function sat(_arg_1:Register, _arg_2:Register):void{
            this.op2(SAT, _arg_1, _arg_2);
        }

        public function m33(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(M33, _arg_1, _arg_2, _arg_3);
        }

        public function m44(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(M44, _arg_1, _arg_2, _arg_3);
        }

        public function m34(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(M34, _arg_1, _arg_2, _arg_3);
        }

        public function sge(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SGE, _arg_1, _arg_2, _arg_3);
        }

        public function slt(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SLT, _arg_1, _arg_2, _arg_3);
        }

        public function sgn(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SGN, _arg_1, _arg_2, _arg_3);
        }

        public function seq(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SEQ, _arg_1, _arg_2, _arg_3);
        }

        public function sne(_arg_1:Register, _arg_2:Register, _arg_3:Register):void{
            this.op3(SNE, _arg_1, _arg_2, _arg_3);
        }

        protected function op2(_arg_1:int, _arg_2:Register, _arg_3:Register):void{
            this.data.writeUnsignedInt(_arg_1);
            _arg_2.writeDest(this.data);
            _arg_3.writeSource(this.data);
            this.data.writeUnsignedInt(0);
            this.data.writeUnsignedInt(0);
        }

        protected function op3(_arg_1:int, _arg_2:Register, _arg_3:Register, _arg_4:Register):void{
            this.data.writeUnsignedInt(_arg_1);
            _arg_2.writeDest(this.data);
            _arg_3.writeSource(this.data);
            _arg_4.writeSource(this.data);
        }

        public function get agalcode():ByteArray{
            return (this.data);
        }


    }
}//package alternativa.gfx.agal