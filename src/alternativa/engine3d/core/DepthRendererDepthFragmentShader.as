package alternativa.engine3d.core
{
    import alternativa.gfx.agal.FragmentShader;
    import alternativa.gfx.agal.SamplerRepeat;
    import alternativa.gfx.agal.SamplerFilter;
    import alternativa.gfx.agal.SamplerMipMap;
    import alternativa.gfx.agal.SamplerType;
    import alternativa.gfx.agal.SamplerDim;

    public class DepthRendererDepthFragmentShader extends FragmentShader 
    {

        public function DepthRendererDepthFragmentShader(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean, _arg_5:Boolean)
        {
            var _local_6:SamplerRepeat;
            var _local_7:SamplerFilter;
            var _local_8:SamplerMipMap;
            var _local_9:SamplerType;
            super();
            if (_arg_2)
            {
                _local_6 = ((_arg_4) ? SamplerRepeat.WRAP : SamplerRepeat.CLAMP);
                _local_7 = ((_arg_3) ? SamplerFilter.LINEAR : SamplerFilter.NEAREST);
                _local_8 = ((_arg_5) ? ((_arg_3) ? SamplerMipMap.LINEAR : SamplerMipMap.NEAREST) : SamplerMipMap.NONE);
                _local_9 = SamplerType.RGBA;
                tex(ft0, v1, fs1.dim(SamplerDim.D2).repeat(_local_6).filter(_local_7).mipmap(_local_8).type(_local_9));
                sub(ft0.w, ft0, v1);
                kil(ft0.w);
            };
            frc(ft0, v0.z);
            sub(ft0.x, v0.z, ft0);
            mul(ft0.x, ft0, fc[0]);
            if (_arg_1)
            {
                mov(ft1.zw, fc[0]);
                mov(ft1.xy, v0);
                nrm(ft1.xyz, ft1.xyz);
                mul(ft1.xy, ft1, fc[1]);
                add(ft1.xy, ft1, fc[1]);
                tex(ft2, ft1, fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
                mov(ft0.w, ft2.z);
                mul(ft1.xy, v0, v0);
                add(ft1.x, ft1, ft1.y);
                sqt(ft1.x, ft1);
                neg(ft1.y, v0.w);
                mul(ft1.xy, ft1, fc[1]);
                add(ft1.xy, ft1, fc[1]);
                tex(ft2, ft1, fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
                mov(ft0.z, ft2.z);
            };
            mov(oc, ft0);
        }

    }
}//package alternativa.engine3d.core