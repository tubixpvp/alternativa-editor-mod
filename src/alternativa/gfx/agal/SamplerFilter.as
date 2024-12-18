package alternativa.gfx.agal{
    public class SamplerFilter extends SamplerOption {

        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        public static const NEAREST:SamplerFilter = new SamplerFilter(0);
        public static const LINEAR:SamplerFilter = new SamplerFilter(1);

        public function SamplerFilter(_arg_1:uint){
            super(_arg_1, SAMPLER_FILTER_SHIFT);
        }

    }
}//package alternativa.gfx.agal