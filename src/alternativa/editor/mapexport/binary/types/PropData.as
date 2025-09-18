package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.OptionalCodecDecorator;
    import alternativa.protocol.codecs.StringCodec;

    public class PropData
    {
        public var groupName:String; //nullable

        public var id:int;

        public var libraryName:String;

        public var materialId:int;

        public var name:String;

        public var position:Vector3D;

        public var rotation:Vector3D; //nullable

        public var scale:Vector3D; //nullable


        public function encode(buffer:ProtocolBuffer) : void
        {
            OptionalCodecDecorator.encodeIsNull(buffer, groupName == null);
            if(groupName != null)
                StringCodec.encode(buffer, groupName);
            buffer.writer.writeInt(id);
            StringCodec.encode(buffer, libraryName);
            buffer.writer.writeInt(materialId);
            StringCodec.encode(buffer, name);
            position.encode(buffer);
            OptionalCodecDecorator.encodeIsNull(buffer, rotation == null);
            if(rotation != null)
                rotation.encode(buffer);
            OptionalCodecDecorator.encodeIsNull(buffer, scale == null);
            if(scale != null)
                scale.encode(buffer);
        }
        
    }
}