package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.OptionalCodecDecorator;
    import alternativa.protocol.codecs.StringCodec;

    public class TextureParameter
    {
        public var libraryName:String; //nullable

        public var name:String;

        public var textureName:String;


        public function TextureParameter(libraryName:String, name:String, textureName:String)
        {
            this.libraryName = libraryName;
            this.name = name;
            this.textureName = textureName;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            OptionalCodecDecorator.encodeIsNull(buffer, libraryName == null);
            if(libraryName != null)
                StringCodec.encode(buffer, libraryName);
            StringCodec.encode(buffer, name);
            StringCodec.encode(buffer, textureName);
        }

    }
}