package alternativa.editor.propslib
{
    public class TextureDiffuseMapsRegistry
    {
        private static const _registry:Object = {};

        public static function addTexture(libraryName:String, groupName:String, propName:String, textureName:String, diffuseName:String) : void
        {
            diffuseName = diffuseName.substring(0, diffuseName.lastIndexOf("."));
            _registry[libraryName + "_" + groupName + "_" + propName + "_" + textureName] = diffuseName;
        }

        public static function getDiffuseName(libraryName:String, groupName:String, propName:String, textureName:String) : String
        {
            var diffuse:String = _registry[libraryName + "_" + groupName + "_" + propName + "_" + textureName];
            if(diffuse == null)
                return textureName;
            return diffuse;
        }
    }
}