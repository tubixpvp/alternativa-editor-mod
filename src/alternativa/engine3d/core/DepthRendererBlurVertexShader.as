package alternativa.engine3d.core
{
    import alternativa.gfx.agal.VertexShader;

    public class DepthRendererBlurVertexShader extends VertexShader 
    {

        public function DepthRendererBlurVertexShader()
        {
            mov(op, va0);
            mov(v0, va1);
        }

    }
}//package alternativa.engine3d.core