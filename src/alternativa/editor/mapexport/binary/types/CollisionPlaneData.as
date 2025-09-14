package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class CollisionPlaneData
    {
        public var length:Number;

        public var position:Vector3D;

        public var rotation:Vector3D;

        public var width:Number;


        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeDouble(length);
            position.encode(buffer);
            rotation.encode(buffer);
            buffer.writer.writeDouble(width);
        }
    }
}