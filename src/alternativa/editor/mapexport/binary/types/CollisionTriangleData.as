package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class CollisionTriangleData
    {
        public var length:Number;

        public var position:Vector3D;

        public var rotation:Vector3D;

        public var v0:Vector3D;

        public var v1:Vector3D;

        public var v2:Vector3D;


        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeDouble(length);
            position.encode(buffer);
            rotation.encode(buffer);
            v0.encode(buffer);
            v1.encode(buffer);
            v2.encode(buffer);
        }
    }
}