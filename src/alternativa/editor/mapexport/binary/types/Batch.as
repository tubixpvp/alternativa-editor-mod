package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class Batch
    {
        public var materialId:int;

        public var name:String;

        public var position:Vector3D;

        public var propsIds:String;

        
        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeInt(materialId);
            StringCodec.encode(buffer, name);
            position.encode(buffer);
            StringCodec.encode(buffer, propsIds);
        }

    }
}