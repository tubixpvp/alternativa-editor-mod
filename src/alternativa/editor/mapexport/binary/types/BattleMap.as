package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.OptionalCodecDecorator;
    import alternativa.protocol.LengthCodecHelper;

    public class BattleMap
    {
        public var atlases:Vector.<Atlas>; //nullable

        public var batches:Vector.<Batch>; //nullable

        public var collisionGeometry:CollisionGeometry;

        public var collisionGeometryOutsideGamingZone:CollisionGeometry;

        public var materials:Vector.<MaterialData>;

        public var spawnPoints:Vector.<SpawnPointData>; //nullable

        public var staticGeometry:StaticGeometry;


        public function encode(buffer:ProtocolBuffer) : void
        {
            OptionalCodecDecorator.encodeIsNull(buffer, atlases == null);
            if(atlases != null)
            {
                LengthCodecHelper.encodeLength(buffer, atlases.length);
                for each(var atlas:Atlas in atlases)
                {
                    atlas.encode(buffer);
                }
            }

            OptionalCodecDecorator.encodeIsNull(buffer, batches == null);
            if(batches != null)
            {
                LengthCodecHelper.encodeLength(buffer, batches.length);
                for each(var batch:Batch in batches)
                {
                    batch.encode(buffer);
                }
            }

            collisionGeometry.encode(buffer);
            collisionGeometryOutsideGamingZone.encode(buffer);

            LengthCodecHelper.encodeLength(buffer, materials.length);
            for each(var material:MaterialData in materials)
            {
                material.encode(buffer);
            }

            OptionalCodecDecorator.encodeIsNull(buffer, spawnPoints == null);
            if(spawnPoints != null)
            {
                LengthCodecHelper.encodeLength(buffer, spawnPoints.length);
                for each(var spawnPoint:SpawnPointData in spawnPoints)
                {
                    spawnPoint.encode(buffer);
                }
            }

            staticGeometry.encode(buffer);
        }
    }
}