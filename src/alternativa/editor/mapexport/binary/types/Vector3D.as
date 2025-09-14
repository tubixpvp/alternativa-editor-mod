package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class Vector3D
    {
        public var x:Number;

        public var y:Number;

        public var z:Number;


        public function Vector3D(x:Number = 0, y:Number = 0, z:Number = 0)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeFloat(x);
            buffer.writer.writeFloat(y);
            buffer.writer.writeFloat(z);
        }
    }
}