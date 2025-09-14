package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;

    public class SpawnPointData
    {
        public var position:Vector3D;

        public var rotation:Vector3D;

        public var type:int; //SpawnPointType


        public function SpawnPointData(position:Vector3D, rotation:Vector3D, type:int)
        {
            this.position = position;
            this.rotation = rotation;
            this.type = type;
        }

        public function encode(buffer:ProtocolBuffer) : void
        {
            position.encode(buffer);
            rotation.encode(buffer);
            buffer.writer.writeInt(type);
        }
    }
}