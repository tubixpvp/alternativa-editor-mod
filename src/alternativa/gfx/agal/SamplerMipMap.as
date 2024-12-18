package alternativa.gfx.agal{
    public class SamplerMipMap extends SamplerOption {

        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        public static const NONE:SamplerMipMap = new SamplerMipMap(0);
        public static const NEAREST:SamplerMipMap = new SamplerMipMap(1);
        public static const LINEAR:SamplerMipMap = new SamplerMipMap(2);

        public function SamplerMipMap(_arg_1:uint){
            super(_arg_1, SAMPLER_MIPMAP_SHIFT);
        }

    }
}//package alternativa.gfx.agal