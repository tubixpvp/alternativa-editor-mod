package alternativa.editor.mapexport.binary.atlasBuilder
{
    import alternativa.editor.mapexport.binary.types.Atlas;
    import alternativa.editor.mapexport.binary.types.Batch;
    import alternativa.editor.mapexport.binary.types.MaterialData;
    import flash.display.BitmapData;
    import alternativa.editor.mapexport.binary.types.AtlasRect;
    import alternativa.editor.mapexport.binary.types.Vector3D;
    import alternativa.editor.mapexport.binary.types.ScalarParameter;
    import alternativa.editor.prop.MeshProp;
    import flash.utils.Dictionary;
    import alternativa.editor.mapexport.binary.types.TextureParameter;
    import alternativa.editor.prop.Prop;
    import flash.geom.Matrix;
    import alternativa.editor.mapexport.binary.types.BattleMap;
    import alternativa.editor.propslib.TextureDiffuseMapsRegistry;

    public class AltasBuilder
    {
        private static const BATCH_KEY:String = "batch";

        private static const DEFAULT_SHADER:String = "TankiOnline/SingleTextureShader";


        public var atlas:Atlas;

        private const batches:Vector.<BatchInfo> = new Vector.<BatchInfo>();
        
        private const texturesData:Dictionary = new Dictionary();

        private const materialsOutput:Vector.<MaterialData> = new Vector.<MaterialData>();


        public function AltasBuilder(id:int)
        {
            atlas = new Atlas();
            atlas.height = 0;
            atlas.width = 0;
            atlas.name = "atlas_" + id + ".png";
            atlas.padding = 0;
            atlas.rects = new Vector.<AtlasRect>();
        }

        private function createMaterial(name:String, libraryName:String, diffuseName:String, shader:String) : MaterialData
        {
            var material:MaterialData = new MaterialData();
            
            material.id = materialsOutput.length;
            material.name = name;
            material.shader = shader;
            
            material.scalarParameters = new Vector.<ScalarParameter>();
            material.scalarParameters.push(new ScalarParameter("_FogMax", 1.0));

            material.textureParameters = new Vector.<TextureParameter>();
            material.textureParameters.push(new TextureParameter(libraryName, "_MainTex", diffuseName));

            materialsOutput.push(material);

            return material;
        }

        private function createBatch(name:String, material:MaterialData) : Batch
        {
            var batch:Batch = new Batch();

            batch.materialId = material.id;
            batch.name = name;
            batch.position = new Vector3D(0,0,0);
            batch.propsIds = "";

            var batchInfo:BatchInfo = new BatchInfo();
            batchInfo.batch = batch;
            batchInfo.material = material;

            batches.push(batchInfo);

            return batch;
        }

        /**
         * Returns: material id
         */
        public function tryAddMeshProp(prop:MeshProp, propIndex:int) : int
        {
            var diffuseName:String = TextureDiffuseMapsRegistry.getDiffuseName(prop.libraryName, prop.groupName, prop.textureName);

            var textureData:TextureData = texturesData[diffuseName];

            if(textureData == null)
            {
                var shader:String = "TankiOnline/SingleTextureShader";

                textureData = new TextureData();

                texturesData[diffuseName] = textureData;

                textureData.material = createMaterial(diffuseName, prop.libraryName, diffuseName, shader);

                textureData.batchIndex = getBatchIndexByShader(shader);

                var texture:BitmapData = prop.bitmaps[prop.textureName];
                if(texture == null)
                {
                    texture = prop.bitmaps["DEFAULT"];
                }

                textureData.texture = texture;

                textureData.atlasRectIndex = atlas.rects.length;
                atlas.rects.push(createAtlasRect(texture, diffuseName, prop));
            }

            var batch:BatchInfo = batches[textureData.batchIndex];
            batch.batch.propsIds += propIndex + ',';

            return textureData.material.id;
            
            //TODO: deny (return -1) if atlas is too big
        }

        private function createAtlasRect(texture:BitmapData, textureDiffuseName:String, prop:Prop) : AtlasRect
        {
            var rect:AtlasRect = new AtlasRect();

            rect.height = texture.height;
            rect.width = texture.width;
            rect.libraryName = prop.libraryName;
            rect.name = textureDiffuseName;

            //test:
            rect.y = 0;
            rect.x = atlas.width;

            atlas.height = Math.max(atlas.height, rect.height);
            atlas.width += rect.width;

            return rect;
        }

        private function getBatchIndexByShader(shader:String) : int
        {
            for(var i:int = 0, l:int = batches.length; i < l; i++)
            {
                if(batches[i].material.shader == shader)
                {
                    return i;
                }
            }

            i = batches.length;

            var name:String = "batch" + i;

            var material:MaterialData = createMaterial(name, null, atlas.name, shader);
            var batch:Batch = createBatch(name, material);

            return i;
        }


        public function createAtlasBitmap() : BitmapData
        {
            var bitmap:BitmapData = new BitmapData(atlas.width, atlas.height, true, 0x00000000);

            var matrix:Matrix = new Matrix();

            for each(var textureData:TextureData in texturesData)
            {
                var rect:AtlasRect = atlas.rects[textureData.atlasRectIndex];

                matrix.tx = rect.x;
                matrix.ty = rect.y;

                bitmap.draw(textureData.texture, matrix);
            }

            return bitmap;
        }

        public function addAllBatchesAndMaterials(map:BattleMap) : void
        {
            for each(var batch:BatchInfo in batches)
            {
                map.batches.push(batch.batch);
            }
            for each(var material:MaterialData in materialsOutput)
            {
                map.materials.push(material);
            }
        }

    }
}

import alternativa.editor.mapexport.binary.types.Batch;
import alternativa.editor.mapexport.binary.types.MaterialData;
import flash.display.BitmapData;

class TextureData
{
    public var batchIndex:int;

    public var atlasRectIndex:int;

    public var material:MaterialData;

    public var texture:BitmapData;
}
class BatchInfo
{
    public var batch:Batch;

    public var material:MaterialData;
}