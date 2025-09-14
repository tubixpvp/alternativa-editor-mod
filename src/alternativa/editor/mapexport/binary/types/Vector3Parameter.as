package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.codecs.StringCodec;

    public class Vector3Parameter
    {

        public var name:String;

        public var value:Vector3D;


        public function Vector3Parameter(name:String, value:Vector3D)
        {
            this.name = name;
            this.value = value;
        }


        public function encode(buffer:ProtocolBuffer) : void
        {
            StringCodec.encode(buffer, name);
            value.encode(buffer);
        }
    }
}