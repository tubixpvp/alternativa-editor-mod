package alternativa.engine3d.materials
{
    import flash.utils.Dictionary;
    import alternativa.gfx.core.BitmapTextureResource;
    import flash.display.BitmapData;

    public class TextureResourcesRegistry 
    {

        public static var texture2Resource:Dictionary = new Dictionary();


        public static function getTextureResource(_arg_1:BitmapData, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean):BitmapTextureResource
        {
            var _local_5:BitmapTextureResource;
            if ((_arg_1 in texture2Resource))
            {
                _local_5 = texture2Resource[_arg_1];
                _local_5.increaseReferencesCount();
                return (_local_5);
            };
            var _local_6:BitmapTextureResource = new BitmapTextureResource(_arg_1, _arg_2, _arg_3, _arg_4);
            texture2Resource[_arg_1] = _local_6;
            return (_local_6);
        }

        public static function releaseTextureResources():void
        {
            var _local_1:*;
            var _local_2:BitmapTextureResource;
            for (_local_1 in texture2Resource)
            {
                _local_2 = texture2Resource[_local_1];
                _local_2.forceDispose();
            };
        }

        public static function release(_arg_1:BitmapData):void
        {
            if ((_arg_1 in texture2Resource))
            {
                delete texture2Resource[_arg_1];
            };
        }


    }
}//package alternativa.engine3d.materials