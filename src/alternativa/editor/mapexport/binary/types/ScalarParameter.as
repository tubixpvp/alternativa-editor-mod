package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class ScalarParameter
    {
        public var name:String;

        public var value:Number;


        public function ScalarParameter(name:String, value:Number)
        {
            this.name = name;
            this.value = value;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            StringCodec.encode(buffer, name);
            buffer.writer.writeFloat(value);
        }
    }
}