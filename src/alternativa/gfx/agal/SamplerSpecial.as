package alternativa.gfx.agal{
    public class SamplerSpecial extends SamplerOption {

        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        public static const CENTROID:SamplerSpecial = new SamplerSpecial(1);
        public static const SINGLE:SamplerSpecial = new SamplerSpecial(2);
        public static const IGNORESAMPLER:SamplerSpecial = new SamplerSpecial(4);

        public function SamplerSpecial(_arg_1:int){
            super(_arg_1, SAMPLER_SPECIAL_SHIFT);
        }

        override public function apply(_arg_1:int):int{
            return (_arg_1 | (uint(mask) << uint(flag)));
        }


    }
}//package alternativa.gfx.agal