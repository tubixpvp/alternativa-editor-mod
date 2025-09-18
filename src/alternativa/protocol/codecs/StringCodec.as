package alternativa.protocol.codecs
{
    import flash.utils.ByteArray;
    import alternativa.protocol.LengthCodecHelper;
    import alternativa.protocol.ProtocolBuffer;

    public class StringCodec
    {

        private static const buffer:ByteArray = new ByteArray();


        public static function encode(output:ProtocolBuffer, input:String) : void
        {
            buffer.clear();
            buffer.writeUTFBytes(input);
            LengthCodecHelper.encodeLength(output, buffer.length);
            output.writer.writeBytes(buffer);
        }
    }
}