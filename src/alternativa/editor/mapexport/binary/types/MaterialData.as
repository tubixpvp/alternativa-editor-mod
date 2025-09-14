package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;
    import alternativa.protocol.OptionalCodecDecorator;
    import alternativa.protocol.LengthCodecHelper;

    public class MaterialData
    {
        public var id:int;

        public var name:String;

        public var scalarParameters:Vector.<ScalarParameter>; //nullable

        public var shader:String;

        public var textureParameters:Vector.<TextureParameter>;

        public var vector2Parameters:Vector.<Vector2Parameter>; //nullable

        public var vector3Parameters:Vector.<Vector3Parameter>; //nullable

        public var vector4Parameters:Vector.<Vector4Parameter>; //nullable


        public function encode(buffer:ProtocolBuffer) : void
        {
            buffer.writer.writeInt(id);
            StringCodec.encode(buffer, name);

            OptionalCodecDecorator.encodeIsNull(buffer, scalarParameters == null);
            if(scalarParameters != null)
            {
                LengthCodecHelper.encodeLength(buffer, scalarParameters.length);
                for each(var scalarParameter:ScalarParameter in scalarParameters)
                {
                    scalarParameter.encode(buffer);
                }
            }

            StringCodec.encode(buffer, shader);

            LengthCodecHelper.encodeLength(buffer, textureParameters.length);
            for each(var textureParameter:TextureParameter in textureParameters)
            {
                textureParameter.encode(buffer);
            }

            OptionalCodecDecorator.encodeIsNull(buffer, vector2Parameters == null);
            if(vector2Parameters != null)
            {
                for each(var vector2Parameter:Vector2Parameter in vector2Parameters)
                {
                    vector2Parameter.encode(buffer);
                }
            }

            OptionalCodecDecorator.encodeIsNull(buffer, vector3Parameters == null);
            if(vector3Parameters != null)
            {
                for each(var vector3Parameter:Vector3Parameter in vector3Parameters)
                {
                    vector3Parameter.encode(buffer);
                }
            }

            OptionalCodecDecorator.encodeIsNull(buffer, vector4Parameters == null);
            if(vector4Parameters != null)
            {
                for each(var vector4Parameter:Vector4Parameter in vector4Parameters)
                {
                    vector4Parameter.encode(buffer);
                }
            }
        }

    }
}