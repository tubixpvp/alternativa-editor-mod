package alternativa.engine3d.core
{
    import alternativa.gfx.agal.VertexShader;

    public class DepthRendererDepthVertexShader extends VertexShader 
    {

        public function DepthRendererDepthVertexShader(_arg_1:Boolean, _arg_2:Boolean)
        {
            mov(vt0, vc[0]);
            dp4(vt0.x, va0, vc[0]);
            dp4(vt0.y, va0, vc[1]);
            dp4(vt0.z, va0, vc[2]);
            mul(vt0.xy, vt0, vc[4]);
            mul(vt1, vc[5], vt0.z);
            sub(vt0.xy, vt0, vt1);
            mul(v0, vt0, vc[4]);
            if (_arg_1)
            {
                dp3(vt1, va1, vc[0]);
                dp3(vt1.y, va1, vc[1]);
                mul(v0.xy, vt1, vc[6]);
                dp3(v0.w, va1, vc[2]);
            };
            mov(op.xw, vt0.xz);
            neg(op.y, vt0);
            mul(vt0.z, vt0, vc[3]);
            add(op.z, vt0, vc[3].w);
            if (_arg_2)
            {
                mul(v1, va2, vc[7]);
            };
        }

    }
}//package alternativa.engine3d.core