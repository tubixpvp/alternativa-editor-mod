package mod.textures
{
    import alternativa.engine3d.materials.TextureMaterial;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;

    public class MaterialsRegistry
    {

        private static const _textureMaterials:Dictionary = new Dictionary();


        public static function getTextureMaterial(bitmap:BitmapData) : TextureMaterial
        {
            var material:TextureMaterial = _textureMaterials[bitmap];
            if (material == null)
            {
                material = _textureMaterials[bitmap] = new TextureMaterial(bitmap);
            }
            material.usagesNum++;
            return material;
        }

        public static function releaseTextureMaterial(material:TextureMaterial) : void
        {
            var bitmap:BitmapData = material.texture;
            if (_textureMaterials[bitmap] == null)
                return;
            if ((--material.usagesNum) > 0)
                return;
            delete _textureMaterials[bitmap];
            material.dispose();
        }

    }
}