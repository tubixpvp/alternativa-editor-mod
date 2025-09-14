package alternativa.editor.propslib
{
    public class TextureDiffuseMapsRegistry
    {
        private static const _registry:Object = {};

        public static function addTexture(libraryName:String, groupName:String, textureName:String, diffuseName:String) : void
        {
            diffuseName = diffuseName.substring(0, diffuseName.lastIndexOf("."));
            _registry[libraryName + "_" + groupName + "_" + textureName] = diffuseName;
        }

        public static function getDiffuseName(libraryName:String, groupName:String, textureName:String) : String
        {
            if(textureName == "")
                textureName = "DEFAULT";
            var diffuse:String = _registry[libraryName + "_" + groupName + "_" + textureName];
            if(diffuse == null)
                return textureName;
            return diffuse;
        }
    }
}