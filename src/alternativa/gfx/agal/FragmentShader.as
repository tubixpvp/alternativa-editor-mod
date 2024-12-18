package alternativa.gfx.agal{
    import __AS3__.vec.Vector;

    public class FragmentShader extends Shader {

        public static const fc:Vector.<CommonRegister> = VertexShader.vc;
        public static const ft0:CommonRegister = VertexShader.vt0;
        public static const ft1:CommonRegister = VertexShader.vt1;
        public static const ft2:CommonRegister = VertexShader.vt2;
        public static const ft3:CommonRegister = VertexShader.vt3;
        public static const ft4:CommonRegister = VertexShader.vt4;
        public static const ft5:CommonRegister = VertexShader.vt5;
        public static const ft6:CommonRegister = VertexShader.vt6;
        public static const ft7:CommonRegister = VertexShader.vt7;
        public static const oc:CommonRegister = VertexShader.op;
        public static const fs0:SamplerRegister = new SamplerRegister(0);
        public static const fs1:SamplerRegister = new SamplerRegister(1);
        public static const fs2:SamplerRegister = new SamplerRegister(2);
        public static const fs3:SamplerRegister = new SamplerRegister(3);
        public static const fs4:SamplerRegister = new SamplerRegister(4);
        public static const fs5:SamplerRegister = new SamplerRegister(5);
        public static const fs6:SamplerRegister = new SamplerRegister(6);
        public static const fs7:SamplerRegister = new SamplerRegister(7);

        public function FragmentShader(){
            data.writeByte(1);
        }

        public function kil(_arg_1:Register):void{
            data.writeUnsignedInt(KIL);
            data.position = (data.position + 4);
            _arg_1.writeSource(data);
            data.position = (data.position + 8);
        }

        public function tex(_arg_1:Register, _arg_2:Register, _arg_3:SamplerRegister):void{
            data.writeUnsignedInt(TEX);
            _arg_1.writeDest(data);
            _arg_2.writeSource(data);
            _arg_3.writeSource(data);
        }


    }
}//package alternativa.gfx.agal