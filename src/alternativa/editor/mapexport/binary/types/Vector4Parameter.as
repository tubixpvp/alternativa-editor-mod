package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class Vector4Parameter
    {
        public var name:String;

        public var value:Vector4D;


        public function Vector4Parameter(name:String, value:Vector4D)
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