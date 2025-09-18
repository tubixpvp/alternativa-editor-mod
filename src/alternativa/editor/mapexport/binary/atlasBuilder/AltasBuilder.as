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
    import alternativa.editor.prop.Sprite3DProp;

    public class AltasBuilder
    {
        private static const LOG_2:Number = Math.log(2);

        private static const BATCH_KEY:String = "batch";

        private static const DEFAULT_SHADER:String = "TankiOnline/SingleTextureShader";

        private static const MAX_ATLAS_SIZE:int = 4096;

        private static const TEXTURE_OUTER_BUFFER_SIZE:int = 16;


        public var atlas:Atlas;

        private const batches:Vector.<BatchInfo> = new Vector.<BatchInfo>();
        
        private const texturesData:Dictionary = new Dictionary();

        private const materialsOutput:Vector.<MaterialData> = new Vector.<MaterialData>();


        private var _atlasIndex:int;


        private var _atlasLayerWidth:int = 0;
        private var _atlasLayerHeight:int = 0;
        private var _atlasLayerY:int = TEXTURE_OUTER_BUFFER_SIZE;


        public function AltasBuilder(id:int)
        {
            _atlasIndex = id;

            atlas = new Atlas();
            atlas.height = 0;
            atlas.width = 0;
            atlas.name = createAtlasName(id);
            atlas.padding = 0;
            atlas.rects = new Vector.<AtlasRect>();
        }

        private static function createAtlasName(index:int) : String
        {
            if(index == 0)
                return "atlas";
            return "atlas" + (index+1);
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
         * Returns: material id, unique for each texture, or -1 if failed to add to the atlas
         */
        public function tryAddMeshProp(prop:MeshProp, propIndex:int) : int
        {
            var textureData:TextureData = tryGetOrCreateTextureData(prop, propIndex);

            if(textureData == null)
                return -1;

            if(!(prop is Sprite3DProp))
            {
                var batch:BatchInfo = batches[textureData.batchIndex];
                batch.batch.propsIds += propIndex + ',';
            }

            return textureData.material.id;
        }

        private function tryGetOrCreateTextureData(prop:MeshProp, propIndex:int) : TextureData
        {
            var diffuseName:String = TextureDiffuseMapsRegistry.getDiffuseName(prop.libraryName, prop.groupName, prop.name, prop.textureName);

            var textureData:TextureData = texturesData[diffuseName];

            if(textureData == null)
            {
                var texture:BitmapData = prop.bitmaps[prop.textureName];
                if(texture == null)
                {
                    texture = prop.bitmaps["DEFAULT"];
                }
                
                var rect:AtlasRect = createAtlasRect(texture, diffuseName, prop);

                if(rect == null)
                    return null;

                var atlasRectIndex:int = atlas.rects.length;

                atlas.rects.push(rect);

                var shader:String = "TankiOnline/SingleTextureShader";

                textureData = new TextureData();

                texturesData[diffuseName] = textureData;

                textureData.material = createMaterial(diffuseName, prop.libraryName, diffuseName, shader);

                textureData.batchIndex = getBatchIndexByShader(shader);
                textureData.atlasRectIndex = atlasRectIndex;

                textureData.texture = texture;
            }

            return textureData;
        }

        private function createAtlasRect(texture:BitmapData, textureDiffuseName:String, prop:Prop) : AtlasRect
        {
            var texHeight:int = texture.height + TEXTURE_OUTER_BUFFER_SIZE*2;
            var texWidth:int = texture.width + TEXTURE_OUTER_BUFFER_SIZE*2;
            var rectX:int = 0;

            if(_atlasLayerWidth + texWidth > MAX_ATLAS_SIZE)
            {
                if(atlas.height + texHeight > MAX_ATLAS_SIZE)
                {
                    atlas.height = MAX_ATLAS_SIZE;
                    return null; // max size of atlas is reached
                }

                _atlasLayerWidth = texWidth;
                rectX = TEXTURE_OUTER_BUFFER_SIZE;

                atlas.width = MAX_ATLAS_SIZE;

                _atlasLayerY += _atlasLayerHeight;
                _atlasLayerHeight = texHeight;
            }
            else
            {
                rectX = _atlasLayerWidth + TEXTURE_OUTER_BUFFER_SIZE;

                _atlasLayerWidth += texWidth;
                _atlasLayerHeight = Math.max(_atlasLayerHeight, texHeight);
                
                atlas.width = Math.max(atlas.width, _atlasLayerWidth);
            }

            atlas.height = _atlasLayerY + _atlasLayerHeight;

            var rect:AtlasRect = new AtlasRect();

            rect.height = texture.height;
            rect.width = texture.width;
            rect.libraryName = prop.libraryName;
            rect.name = textureDiffuseName;
            rect.x = rectX;
            rect.y = _atlasLayerY;

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

            var name:String = "batch" + i + "_" + _atlasIndex;

            var material:MaterialData = createMaterial(name, null, atlas.name, shader);
            var batch:Batch = createBatch(name, material);

            return i;
        }


        public function createAtlasBitmap() : BitmapData
        {
            atlas.width = toPowerOf2(atlas.width);
            atlas.height = toPowerOf2(atlas.height);

            var bitmap:BitmapData = new BitmapData(atlas.width, atlas.height, true, 0x00000000);

            var matrix:Matrix = new Matrix();

            for each(var textureData:TextureData in texturesData)
            {
                var rect:AtlasRect = atlas.rects[textureData.atlasRectIndex];

                matrix.tx = rect.x;
                matrix.ty = rect.y;

                var texture:BitmapData = textureData.texture;

                bitmap.draw(texture, matrix);

                for(var x:int = 0; x < rect.width; x++)
                {
                    for(var y:int = 0; y < TEXTURE_OUTER_BUFFER_SIZE; y++)
                    {
                        bitmap.setPixel32(rect.x + x, rect.y - y - 1, texture.getPixel32(x,0));
                        bitmap.setPixel32(rect.x + x, rect.y+rect.height + y, texture.getPixel32(x, rect.height-1));
                    }
                }
                for(y = 0; y < rect.height; y++)
                {
                    for(x = 0; x < TEXTURE_OUTER_BUFFER_SIZE; x++)
                    {
                        bitmap.setPixel32(rect.x - x - 1, rect.y + y, texture.getPixel32(0, y));
                        bitmap.setPixel32(rect.x + x+rect.width, rect.y + y, texture.getPixel32(rect.width-1, y));
                    }
                }

                //corners
                var colors:Array = [
                    texture.getPixel32(0,0),
                    texture.getPixel32(rect.width-1, 0),
                    texture.getPixel32(0, rect.height-1),
                    texture.getPixel32(rect.width-1, rect.height-1)
                ];
                var coords:Array = [
                    rect.x-TEXTURE_OUTER_BUFFER_SIZE, rect.y - TEXTURE_OUTER_BUFFER_SIZE,
                    rect.x+rect.width, rect.y - TEXTURE_OUTER_BUFFER_SIZE,
                    rect.x-TEXTURE_OUTER_BUFFER_SIZE, rect.y+rect.height,
                    rect.x+rect.width, rect.y+rect.height
                ];
                for(var i:int = 0; i < 4; i++)
                {
                    var color:uint = colors[i];
                    var startX:int = coords[i*2];
                    var startY:int = coords[i*2+1];

                    for(y = 0; y < TEXTURE_OUTER_BUFFER_SIZE; y++)
                    {
                        for(x = 0; x < TEXTURE_OUTER_BUFFER_SIZE; x++)
                        {
                            bitmap.setPixel32(startX+x, startY+y, color);
                        }
                    }
                }
            }

            return bitmap;
        }

        private function toPowerOf2(size:int) : int
        {
            var nextPower:int = Math.ceil(Math.log(size) / LOG_2);

            return Math.min(Math.pow(2, nextPower), MAX_ATLAS_SIZE);
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