package alternativa.editor.mapexport.binary
{
    import alternativa.editor.mapexport.FileExporter;
    import alternativa.engine3d.core.Object3DContainer;
    import flash.filesystem.FileStream;
    import alternativa.editor.mapexport.binary.types.BattleMap;
    import flash.utils.ByteArray;
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.OptionalMap;
    import alternativa.protocol.PacketHelper;
    import alternativa.protocol.CompressionType;
    import alternativa.engine3d.core.Object3D;
    import alternativa.editor.prop.Prop;
    import alternativa.editor.mapexport.binary.types.Atlas;
    import alternativa.editor.mapexport.binary.types.CollisionGeometry;
    import alternativa.editor.mapexport.binary.types.MaterialData;
    import alternativa.editor.prop.SpawnPoint;
    import alternativa.editor.mapexport.binary.types.SpawnPointData;
    import alternativa.editor.mapexport.binary.types.StaticGeometry;
    import alternativa.editor.mapexport.binary.types.PropData;
    import alternativa.editor.prop.MeshProp;
    import alternativa.editor.mapexport.CollisionPrimitivesCache;
    import alternativa.editor.mapexport.CollisionPrimitive;
    import alternativa.editor.mapexport.xml.TanksXmlExporterV1Lite;

    public class MapBinaryExporter extends FileExporter
    {

        private const collisionPrimitivesCache:CollisionPrimitivesCache = new CollisionPrimitivesCache();


        public function MapBinaryExporter(sceneRoot:Object3DContainer)
        {
            super(sceneRoot);
        }
        
        public override function exportToFileStream(stream:FileStream) : void
        {
            var map:BattleMap = constructMapData();
            
            var mapBytes:ByteArray = new ByteArray();
            var buffer:ProtocolBuffer = new ProtocolBuffer(mapBytes, mapBytes, new OptionalMap());

            map.encode(buffer);
            
            mapBytes.position = 0;
            PacketHelper.wrapPacket(stream, buffer, CompressionType.NONE);
        }

        private function constructMapData() : BattleMap
        {
            var map:BattleMap = new BattleMap();

            map.collisionGeometry = CollisionGeometry.instantiate();
            map.collisionGeometryOutsideGamingZone = CollisionGeometry.instantiate();

            map.materials = new Vector.<MaterialData>();

            //map.spawnPoints = new Vector.<SpawnPointData>();

            map.staticGeometry = new StaticGeometry(new Vector.<PropData>());

            var children:Vector.<Object3D> = sceneRoot.children;
            for each(var propObj:Object3D in children)
            {
                var prop:Prop = propObj as Prop;
                if(prop == null)
                    continue;

                constructPropData(prop, map);
            }

            return map;
        }

        private function constructPropData(prop:Prop, mapOutput:BattleMap) : void
        {
            if(prop.type == Prop.TILE)
            {
                constructMeshProp(prop as MeshProp, mapOutput);
            }
        }

        private function constructMeshProp(prop:MeshProp, mapOutput:BattleMap) : void
        {
            if(prop.collisionEnabled)
            {
                var primitives:Vector.<CollisionPrimitive> = collisionPrimitivesCache.getPrimitives(prop.libraryName, prop.groupName, prop.name);
                if(primitives == null)
                {
                    primitives = TanksXmlExporterV1Lite.createPropCollisionPrimitives(prop);
                    collisionPrimitivesCache.addPrimitives(prop.libraryName, prop.groupName, prop.name, primitives);
                }
                for each(var primitive:CollisionPrimitive in primitives)
                {
                    primitive.addToBinaryData(mapOutput, prop.transformation);
                }
            }
        }

    }
}