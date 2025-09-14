package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;
    import alternativa.protocol.LengthCodecHelper;

    public class Atlas
    {
        public var height:int;

        public var name:String;

        public var padding:int;

        public var rects:Vector.<AtlasRect>;

        public var width:int;

        
        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeInt(height);
            StringCodec.encode(buffer, name);
            buffer.writer.writeInt(padding);
            LengthCodecHelper.encodeLength(buffer, rects.length);
            for each(var rect:AtlasRect in rects)
            {
                rect.encode(buffer);
            }
            buffer.writer.writeInt(width);
        }
    }
}