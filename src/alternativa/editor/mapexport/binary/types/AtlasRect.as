package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class AtlasRect
    {
        public var height:int;

        public var libraryName:String;

        public var name:String;

        public var width:int;

        public var x:int;

        public var y:int;

        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeInt(height);
            StringCodec.encode(buffer, libraryName);
            StringCodec.encode(buffer, name);
            buffer.writer.writeInt(width);
            buffer.writer.writeInt(x);
            buffer.writer.writeInt(y);
        }
    }
}