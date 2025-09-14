package alternativa.protocol
{
    public class OptionalCodecDecorator
    {
        public static function encodeIsNull(buffer:ProtocolBuffer, isNull:Boolean) : void
        {
            buffer.optionalMap.addBit(isNull);
        }
    }
}