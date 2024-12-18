package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class VertexBinding 
    {

        alternativa3d var next:VertexBinding;
        alternativa3d var vertex:Vertex;
        alternativa3d var weight:Number = 0;


    }
}//package alternativa.engine3d.objects