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
    import alternativa.editor.mapexport.binary.types.CollisionGeometry;
    import alternativa.editor.mapexport.binary.types.MaterialData;
    import alternativa.editor.mapexport.binary.types.StaticGeometry;
    import alternativa.editor.mapexport.binary.types.PropData;
    import alternativa.editor.prop.MeshProp;
    import alternativa.editor.mapexport.CollisionPrimitivesCache;
    import alternativa.editor.mapexport.CollisionPrimitive;
    import alternativa.editor.mapexport.xml.TanksXmlExporterV1Lite;
    import alternativa.editor.mapexport.binary.types.Vector3D;
    import alternativa.editor.mapexport.binary.atlasBuilder.AltasBuilder;
    import alternativa.editor.InvisibleTexture;
    import flash.utils.Dictionary;
    import mx.graphics.codec.PNGEncoder;
    import deng.fzip.FZip;
    import alternativa.editor.prop.SpawnPoint;
    import alternativa.editor.mapexport.binary.types.SpawnPointData;
    import alternativa.editor.mapexport.binary.types.SpawnPointType;
    import alternativa.editor.mapexport.binary.types.Atlas;
    import alternativa.editor.mapexport.binary.types.Batch;

    public class MapBinaryExporter extends FileExporter
    {

        private const collisionPrimitivesCache:CollisionPrimitivesCache = new CollisionPrimitivesCache();

        private var _materialCounter:int = 0;


        public function MapBinaryExporter(sceneRoot:Object3DContainer)
        {
            super(sceneRoot);
        }
        
        public override function exportToFileStream(stream:FileStream) : void
        {
            var mapData:ExportedMapData = constructMapData();
            
            var mapBytes:ByteArray = new ByteArray();
            var buffer:ProtocolBuffer = new ProtocolBuffer(mapBytes, mapBytes, new OptionalMap());

            mapData.map.encode(buffer);
            
            mapBytes.position = 0;

            var packetBytes:ByteArray = new ByteArray();
            PacketHelper.wrapPacket(packetBytes, buffer, CompressionType.NONE);

            var archive:FZip = new FZip();

            archive.addFile("map.bin", packetBytes, false);

            var pngEncoder:PNGEncoder = new PNGEncoder();

            for(var fileName:String in mapData.atlasFiles)
            {
                var imageBytes:ByteArray = pngEncoder.encode(mapData.atlasFiles[fileName]);

                archive.addFile(fileName, imageBytes, false);
            }

            archive.addFileFromString("map.json", JSON.stringify(mapData.map));

            archive.serialize(stream);
        }

        private function constructMapData() : ExportedMapData
        {
            var map:BattleMap = new BattleMap();

            map.atlases = new Vector.<Atlas>();
            map.batches = new Vector.<Batch>();

            map.collisionGeometry = CollisionGeometry.instantiate();
            map.collisionGeometryOutsideGamingZone = CollisionGeometry.instantiate();

            map.materials = new Vector.<MaterialData>();

            map.spawnPoints = new Vector.<SpawnPointData>();

            map.staticGeometry = new StaticGeometry(new Vector.<PropData>());

            var atlases:Vector.<AltasBuilder> = new Vector.<AltasBuilder>();

            var mapExtra:MapExtraData = new MapExtraData();

            var children:Vector.<Object3D> = sceneRoot.children;
            for each(var propObj:Object3D in children)
            {
                var prop:Prop = propObj as Prop;
                if(prop == null)
                    continue;

                constructPropData(prop, map, mapExtra, atlases);
            }

            var mapData:ExportedMapData = new ExportedMapData();

            mapData.map = map;
            mapData.atlasFiles = new Dictionary();
            mapData.extra = mapExtra;

            for each(var atlas:AltasBuilder in atlases)
            {
                map.atlases.push(atlas.atlas);
                
                atlas.addAllBatchesAndMaterials(map);

                var fileName:String = atlas.atlas.name;
                fileName = fileName + ".png";
                mapData.atlasFiles[fileName] = atlas.createAtlasBitmap();
            }

            return mapData;
        }

        private function constructPropData(prop:Prop, mapOutput:BattleMap, extraOutput:MapExtraData, atlases:Vector.<AltasBuilder>) : void
        {
            if(prop.type == Prop.TILE)
            {
                constructMeshProp(prop as MeshProp, mapOutput, atlases);
            }
            else if(prop.type == Prop.SPAWN)
            {
                constructSpawnPoint(prop as SpawnPoint, mapOutput);
            }
        }

        private function constructMeshProp(prop:MeshProp, mapOutput:BattleMap, atlases:Vector.<AltasBuilder>) : void
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

            if(prop.textureName != InvisibleTexture.TEXTURE_NAME && prop.bitmaps != null)
            {
                var propData:PropData = new PropData();

                propData.groupName = prop.groupName;
                propData.libraryName = prop.libraryName;
                propData.name = prop.name;
                propData.id = mapOutput.staticGeometry.props.length;
                propData.position = new Vector3D(prop.x, prop.y, prop.z);

                if(prop.rotationX != 0 || prop.rotationY != 0 || prop.rotationZ != 0)
                {
                    propData.rotation = new Vector3D(prop.rotationX, prop.rotationY, prop.rotationZ);
                }
                if(prop.scaleX != 1 || prop.scaleY != 1 || prop.scaleZ != 1)
                {
                    propData.scale = new Vector3D(prop.scaleX, prop.scaleY, prop.scaleZ);
                }

                propData.materialId = getMaterialIndex(prop, propData.id, atlases);

                mapOutput.staticGeometry.props.push(propData);
            }
        }

        private function getMaterialIndex(prop:MeshProp, propIndex:int, atlases:Vector.<AltasBuilder>) : int
        {
            for each(var atlas:AltasBuilder in atlases)
            {
                var index:int = atlas.tryAddMeshProp(prop, propIndex);
                if(index != -1)
                {
                    return index;
                }
            }

            atlas = new AltasBuilder(atlases.length);
            atlases.push(atlas);

            return atlas.tryAddMeshProp(prop, propIndex);
        }

        private function constructSpawnPoint(prop:SpawnPoint, mapOutput:BattleMap) : void
        {
            mapOutput.spawnPoints.push(new SpawnPointData(
                new Vector3D(prop.x, prop.y, prop.z),
                new Vector3D(prop.rotationX, prop.rotationY, prop.rotationZ),
                SpawnPointType.fromString(prop.name)
            ));
        }

    }
}

import alternativa.editor.mapexport.binary.types.BattleMap;
import flash.utils.Dictionary;
import alternativa.editor.mapexport.binary.MapExtraData;

class ExportedMapData
{
    public var map:BattleMap;

    public var atlasFiles:Dictionary;

    public var extra:MapExtraData;
}