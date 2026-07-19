package mod.textures
{
    import alternativa.editor.prop.Prop_redClass;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import flash.geom.Matrix;
    import flash.display.BlendMode;
    import alternativa.editor.scene.CursorScene_redClass;
    import alternativa.editor.scene.CursorScene_greenClass;

    public class ConvertedBitmapsRegistry
    {
        private static const selectionMask:BitmapData = new Prop_redClass().bitmapData;

        private static const cursorConflictMask:BitmapData = new CursorScene_redClass().bitmapData;
        private static const cursorAcceptMask:BitmapData = new CursorScene_greenClass().bitmapData;


        [Embed(source="no_collision_texture.png")]
        private static const NO_COLLISION_TEXTURE_MASK_Class:Class;

        private static const NO_COLLISION_TEXTURE_Bitmap:BitmapData = new NO_COLLISION_TEXTURE_MASK_Class().bitmapData;


        private static const _matrix:Matrix = new Matrix();
        //private static const _mirrorMatrix:Matrix = new Matrix(-1);


        private static const _selectedBitmaps:Dictionary = new Dictionary();
        private static const _noCollisionBitmaps:Dictionary = new Dictionary();

        private static const _cursorAcceptedBitmaps:Dictionary = new Dictionary();
        private static const _cursorConflictBitmaps:Dictionary = new Dictionary();

        //private static const _normalBitmapsToMirrored:Dictionary = new Dictionary();
        //private static const _mirroredBitmapsToNormal:Dictionary = new Dictionary();

        
        public static function getSelectedBitmap(bitmap:BitmapData) : BitmapData
        {
            var selectedBitmap:BitmapData = _selectedBitmaps[bitmap];
            if (selectedBitmap == null)
            {
                selectedBitmap = _selectedBitmaps[bitmap] = bitmap.clone();
                _matrix.a = _matrix.d = (bitmap.width / selectionMask.width);
                selectedBitmap.draw(selectionMask, _matrix, null, BlendMode.MULTIPLY);
            }
            return selectedBitmap;
        }
        
        public static function getNoCollisionBitmap(bitmap:BitmapData) : BitmapData
        {
            var noCollisionBitmap:BitmapData = _noCollisionBitmaps[bitmap];
            if (noCollisionBitmap == null)
            {
                noCollisionBitmap = _noCollisionBitmaps[bitmap] = bitmap.clone();
                _matrix.a = bitmap.width / NO_COLLISION_TEXTURE_Bitmap.width;
                _matrix.d = bitmap.height / NO_COLLISION_TEXTURE_Bitmap.height;
                noCollisionBitmap.draw(NO_COLLISION_TEXTURE_Bitmap, _matrix);
            }
            return noCollisionBitmap;
        }

        public static function getCursorConflictBitmap(bitmap:BitmapData, accepted:Boolean) : BitmapData
        {
            var registry:Dictionary = (accepted ? _cursorAcceptedBitmaps : _cursorConflictBitmaps);
            var conflictBitmap:BitmapData = registry[bitmap];
            if (conflictBitmap == null)
            {
                conflictBitmap = registry[bitmap] = bitmap.clone();
                var mask:BitmapData = (accepted ? cursorAcceptMask : cursorConflictMask);
                _matrix.a = _matrix.d = (bitmap.width / mask.width);
                conflictBitmap.draw(mask, _matrix, null, BlendMode.HARDLIGHT);
            }
            return conflictBitmap;
        }

        /*public static function getMirroredBitmap(bitmap:BitmapData) : BitmapData
        {
            var mirroredBitmap:BitmapData = _mirroredBitmapsToNormal[bitmap];
            if (mirroredBitmap != null)
                return mirroredBitmap;
            mirroredBitmap = _normalBitmapsToMirrored[bitmap];
            if (mirroredBitmap == null)
            {
                mirroredBitmap = new BitmapData(bitmap.width, bitmap.height);
                _mirrorMatrix.tx = bitmap.width;
                mirroredBitmap.draw(bitmap, _mirrorMatrix);

                _normalBitmapsToMirrored[bitmap] = mirroredBitmap;
                _mirroredBitmapsToNormal[mirroredBitmap] = bitmap;
            }
            return mirroredBitmap;
        }*/


        // TODO: call when clearing the library?
        public static function dispose() : void
        {
            disposeRegistry(_selectedBitmaps);
            disposeRegistry(_noCollisionBitmaps);
            disposeRegistry(_cursorAcceptedBitmaps);
            disposeRegistry(_cursorConflictBitmaps);
            /*for (key in _normalBitmapsToMirrored)
            {
                value = _normalBitmapsToMirrored[key];
                delete _mirroredBitmapsToNormal[value];
                value.dispose();
                delete _normalBitmapsToMirrored[key];
            }*/
        }
        private static function disposeRegistry(registry:Dictionary) : void
        {
            for(var key:* in registry)
            {
                (registry[key] as BitmapData).dispose();
                delete registry[key];
            }
        }

    }
}