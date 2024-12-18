package alternativa.engine3d.materials
{
    import alternativa.gfx.agal.VertexShader;

    public class TextureMaterialVertexShader extends VertexShader 
    {

        public function TextureMaterialVertexShader(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:Boolean, _arg_9:Boolean, _arg_10:Boolean)
        {
            mov(vt0, vc[4]);
            if (_arg_1)
            {
                dp4(vt0.x, va0, vc[0]);
                dp4(vt0.y, va0, vc[1]);
                dp4(vt0.z, va0, vc[2]);
                mul(v0, va1, vc[4]);
            } else
            {
                mov(vt0.xyz, cc.rel(va0.x, 0));
                mov(vt1, cc.rel(va0.x, 1));
                mul(v0, vt1, vc[4]);
            };
            if (((_arg_2) || (_arg_3)))
            {
                mov(v1, vt0);
            };
            if (_arg_3)
            {
                if (_arg_1)
                {
                    if (_arg_4)
                    {
                        mul(vt1, va2, vc[11]);
                        nrm(vt1.xyz, vt1.xyz);
                        div(vt1, vt1, vc[11]);
                    } else
                    {
                        mov(vt1, vc[4]);
                        dp3(vt1.x, va2, vc[0]);
                        dp3(vt1.y, va2, vc[1]);
                        dp3(vt1.z, va2, vc[2]);
                    };
                } else
                {
                    mov(vt2, vc[4]);
                    mov(vt2.x, cc.rel(va0.x, 0).w);
                    mov(vt2.y, cc.rel(va0.x, 1).z);
                    mov(vt2.z, cc.rel(va0.x, 1).w);
                    if (_arg_4)
                    {
                        mul(vt1, vt2, vc[11]);
                        nrm(vt1.xyz, vt1.xyz);
                        div(vt1, vt1, vc[11]);
                    } else
                    {
                        mov(vt1, vc[4]);
                        dp3(vt1.x, vt2, vc[0]);
                        dp3(vt1.y, vt2, vc[1]);
                        dp3(vt1.z, vt2, vc[2]);
                    };
                };
                dp3(vt1.w, vt1, vc[10]);
                if (_arg_4)
                {
                    sub(vt1.w, vc[4], vt1);
                    mul(v1.w, vt1, vc[11]);
                } else
                {
                    sub(v1.w, vc[4], vt1);
                };
            } else
            {
                if (((((_arg_5) || (_arg_6)) || (_arg_9)) || (_arg_10)))
                {
                    mov(vt1, vc[4]);
                };
            };
            if (_arg_5)
            {
                dp4(v2.x, vt0, vc[6]);
                dp4(v2.y, vt0, vc[7]);
                dp4(v2.z, vt0, vc[8]);
                sub(vt1.w, vt0.z, vc[9].x);
                div(vt1.w, vt1, vc[9].y);
                sub(v2.w, vc[4], vt1);
            };
            if (_arg_6)
            {
                sub(vt1.w, vt0.z, vc[5].z);
                div(v0.w, vt1, vc[5]);
            };
            if (_arg_8)
            {
                mov(vt1, vt0);
                mul(vt1.x, vt1, vc[11].w);
                mul(vt1.y, vt1, vc[12].w);
                sub(vt1, vt1, vc[11]);
                dp3(v0.z, vt1, vc[12]);
            };
            if (_arg_7)
            {
                mul(vt0.xyz, vt0, vc[11]);
            };
            if (_arg_9)
            {
                div(vt1.z, vc[3].w, vt0);
                add(vt1.z, vt1, vc[3]);
                mul(vt1.z, vt1, vc[3].x);
                sub(vt1.z, vt1, vc[3].y);
                div(vt1.z, vt1, vc[3].x);
                sub(vt1.z, vt1, vc[3]);
                div(vt1.z, vc[3].w, vt1);
                mov(vt2, vc[4]);
                nrm(vt2.xyz, vt0.xyz);
                sub(vt1.z, vt0, vt1);
                div(vt1.z, vt1, vt2);
                mul(vt2, vt2, vt1.z);
                sub(vt0, vt0, vt2);
            };
            if (_arg_10)
            {
                mul(vt0.xy, vt0, vc[13]);
                mul(vt1.xy, vc[13].zw, vt0.z);
                add(vt0.xy, vt0, vt1);
            };
            mov(op.xw, vt0.xz);
            neg(op.y, vt0);
            mul(vt0.z, vt0, vc[3]);
            add(op.z, vt0, vc[3].w);
        }

    }
}//package alternativa.engine3d.materials