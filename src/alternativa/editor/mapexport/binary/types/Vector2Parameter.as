package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class Vector2Parameter
    {
        public var name:String;

        public var value:Vector2D;


        public function Vector2Parameter(name:String, value:Vector2D)
        {
            this.name = name;
            this.value = value;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            StringCodec.encode(buffer, name);
            value.encode(buffer);
        }

    }
}