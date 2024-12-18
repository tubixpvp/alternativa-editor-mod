package alternativa.engine3d.core{
    import alternativa.gfx.agal.FragmentShader;
    import alternativa.gfx.agal.SamplerDim;
    import alternativa.gfx.agal.SamplerRepeat;
    import alternativa.gfx.agal.SamplerFilter;
    import alternativa.gfx.agal.SamplerMipMap;

    public class ShadowAtlasFragmentShader extends FragmentShader {

        public function ShadowAtlasFragmentShader(_arg_1:int, _arg_2:Boolean){
            var _local_3:int;
            super();
            mov(ft1, v0);
            tex(ft3, ft1, fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
            if (_arg_2)
            {
                sub(ft1.x, v0, fc[1]);
            } else
            {
                sub(ft1.y, v0, fc[1]);
            };
            _local_3 = -(_arg_1);
            while (_local_3 <= _arg_1)
            {
                if (_local_3 != 0)
                {
                    tex(ft2, ft1, fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
                    add(ft3.w, ft3, ft2);
                };
                if (_arg_2)
                {
                    add(ft1.x, ft1, fc[0]);
                } else
                {
                    add(ft1.y, ft1, fc[0]);
                };
                _local_3++;
            };
            div(ft3.w, ft3, fc[0]);
            mov(oc, ft3);
        }

    }
}//package alternativa.engine3d.core