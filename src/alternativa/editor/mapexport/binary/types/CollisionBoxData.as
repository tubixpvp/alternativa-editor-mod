package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class CollisionBoxData
    {
        public var position:Vector3D;

        public var rotation:Vector3D;

        public var size:Vector3D;


        public function encode(buffer:ProtocolBuffer) : void
        {
            position.encode(buffer);
            rotation.encode(buffer);
            size.encode(buffer);
        }
    }
}