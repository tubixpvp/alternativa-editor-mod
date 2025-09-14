package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.LengthCodecHelper;

    public class StaticGeometry
    {
        public var props:Vector.<PropData>;

        public function StaticGeometry(props:Vector.<PropData>) : void
        {
            this.props = props;
        }

        public function encode(buffer:ProtocolBuffer) : void
        {
            LengthCodecHelper.encodeLength(buffer, props.length);
            for each(var prop:PropData in props)
            {
                prop.encode(buffer);
            }
        }
    }
}