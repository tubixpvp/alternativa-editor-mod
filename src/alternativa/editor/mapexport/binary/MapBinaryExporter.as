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
    import alternativa.editor.prop.FreeBonusRegion;
    import alternativa.editor.prop.CTFFlagBase;
    import alternativa.editor.prop.ControlPoint;
    import alternativa.editor.prop.KillBox;

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

            archive.addFileFromString("extra.json", JSON.stringify(mapData.extra, null, 4));

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

            var cache:MapExportCache = new MapExportCache();

            var children:Vector.<Object3D> = sceneRoot.children;
            for each(var propObj:Object3D in children)
            {
                var prop:Prop = propObj as Prop;
                if(prop == null)
                    continue;

                constructPropData(prop, map, mapExtra, atlases, cache);
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

        private function constructPropData(prop:Prop, mapOutput:BattleMap, extraOutput:MapExtraData, atlases:Vector.<AltasBuilder>, cache:MapExportCache) : void
        {
            if(prop.type == Prop.TILE)
            {
                addMeshProp(prop as MeshProp, mapOutput, atlases);
            }
            else if(prop.type == Prop.SPAWN)
            {
                addSpawnPoint(prop as SpawnPoint, mapOutput, false);
            }
            else if(prop.type == Prop.BONUS)
            {
                addBonusRegion(prop as FreeBonusRegion, extraOutput);
            }
            else if(prop.type == Prop.FLAG)
            {
                addFlagBase(prop as CTFFlagBase, extraOutput);
            }
            else if(prop.type == Prop.DOMINATION_CONTROL_POINT)
            {
                addDominationPoint(prop as ControlPoint, mapOutput, extraOutput, cache);
            }
            else if(prop.type == Prop.KILL_GEOMETRY)
            {
                addSpecialGeometry(prop as KillBox, extraOutput);
            }
        }

        private function addMeshProp(prop:MeshProp, mapOutput:BattleMap, atlases:Vector.<AltasBuilder>) : void
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

        private function addSpawnPoint(prop:SpawnPoint, mapOutput:BattleMap, linkedToDominationPoint:Boolean) : void
        {
            mapOutput.spawnPoints.push(new SpawnPointData(
                new Vector3D(prop.x, prop.y, prop.z),
                new Vector3D(prop.rotationX, prop.rotationY, prop.rotationZ),
                SpawnPointType.fromString(prop.name, linkedToDominationPoint)
            ));
        }

        private function addBonusRegion(prop:FreeBonusRegion, extraOutput:MapExtraData) : void
        {
            if(prop.typeNames.isEmpty() || prop.gameModes.isEmpty())
                return;

            var region:BonusRegionData = new BonusRegionData();

            region.bonusTypes = prop.typeNames.toArray();
            region.gameModes = prop.gameModes.toArray();
            region.spawnOnGround = !prop.parachute;

            extraOutput.bonusRegions.push(region);
        }

        private function addFlagBase(prop:CTFFlagBase, extraOutput:MapExtraData) : void
        {
            var flagTeam:String = (prop.name == "red_flag" ? "RED" : prop.name == "blue_flag" ? "BLUE" : "NONE");

            var flagsInGameMode:Vector.<FlagData> = extraOutput.flags[prop.gameMode];

            if(flagsInGameMode == null)
            {
                flagsInGameMode = extraOutput.flags[prop.gameMode] = new Vector.<FlagData>();
            }

            flagsInGameMode.push(new FlagData(flagTeam, new Vector3D(prop.x, prop.y, prop.z)));
        }

        private function addDominationPoint(prop:ControlPoint, mapOutput:BattleMap, extraOutput:MapExtraData, cache:MapExportCache) : void
        {
            var bindedSpawns:Vector.<int> = new Vector.<int>();

            var spawnPoints:Vector.<SpawnPoint> = prop.getSpawnPoints();
            for each(var spawnPoint:SpawnPoint in spawnPoints)
            {
                addSpawnPoint(spawnPoint, mapOutput, true);

                bindedSpawns.push(cache.dominationLinkedSpawnsCounter++);
            }

            var pointsInGameMode:Vector.<DominationPointData> = extraOutput.dominationControlPoints[prop.gameMode];

            if(pointsInGameMode == null)
            {
                pointsInGameMode = extraOutput.dominationControlPoints[prop.gameMode] = new Vector.<DominationPointData>();
            }

            var position:Vector3D = new Vector3D(prop.x, prop.y, prop.z);

            pointsInGameMode.push(new DominationPointData(prop.controlPointName, bindedSpawns, position));
        }

        private function addSpecialGeometry(prop:KillBox, extraOutput:MapExtraData) : void
        {
            var data:SpecialGeometryData = new SpecialGeometryData();

            data.boundMin = new Vector3D(prop.minX, prop.minY, prop.minZ);
            data.boundMax = new Vector3D(prop.maxx, prop.maxy, prop.maxz);
            data.action = prop.action;

            extraOutput.specialGeometry.push(data);
        }

    }
}

class SpecialGeometryData
{
    public var boundMin:Vector3D;
    public var boundMax:Vector3D;
    public var action:String;
}

class DominationPointData
{
    /**
     * Letter of the point (A/B/C/D/E/F/G...)
     */
    public var name:String;

    /**
     * Indices of DOM-related spawns that are linked to this point.
     * To get actual spawn points, you have to collect all DOM spawns (SpawnPointType.DOM/SpawnPointType.DOM_TEAM_A/SpawnPointType.DOM_TEAM_B) from common spawns list into array and use this indices on it.
     */
    public var bindedSpawns:Vector.<int>;

    public var position:Vector3D;

    public function DominationPointData(name:String, bindedSpawns:Vector.<int>, position:Vector3D)
    {
        this.name = name;
        this.bindedSpawns = bindedSpawns;
        this.position = position;
    }
}

class FlagData
{
    public var team:String;

    public var position:Vector3D;


    public function FlagData(team:String, position:Vector3D)
    {
        this.team = team;
        this.position = position;
    }
}

class BonusRegionData
{
    public var bonusTypes:Array;

    public var gameModes:Array;

    public var spawnOnGround:Boolean;
}

class MapExtraData
{
    /**
     * Version of 'extra.json' file format
     */
    public const version:int = 1;

    public const bonusRegions:Vector.<BonusRegionData> = new Vector.<BonusRegionData>();

    /**
     * Flags: { mode -> FlagData[] }
     */
    public const flags:Object = {};

    /**
     * Control Points { mode -> DominationPointData[] }
     */
    public const dominationControlPoints:Object = {};

    public const specialGeometry:Vector.<SpecialGeometryData> = new Vector.<SpecialGeometryData>();
}

import alternativa.editor.mapexport.binary.types.BattleMap;
import flash.utils.Dictionary;
import alternativa.editor.mapexport.binary.types.Vector3D;

class ExportedMapData
{
    public var map:BattleMap;

    public var atlasFiles:Dictionary;

    public var extra:MapExtraData;
}

class MapExportCache
{
    public var dominationLinkedSpawnsCounter:int = 0;
}