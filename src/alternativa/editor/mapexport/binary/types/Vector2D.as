package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class Vector2D
    {
        public var x:Number;

        public var y:Number;


        public function Vector2D(x:Number = 0, y:Number = 0)
        {
            this.x = x;
            this.y = y;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeFloat(x);
            buffer.writer.writeFloat(y);
        }
    }
}