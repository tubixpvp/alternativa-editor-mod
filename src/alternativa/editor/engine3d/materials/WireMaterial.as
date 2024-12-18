package alternativa.editor.engine3d.materials
{
    import alternativa.engine3d.materials.TextureMaterial;
    import flash.display.BitmapData;
    import alternativa.engine3d.alternativa3d;
    import alternativa.engine3d.materials.Material;
    import flash.display.Shape;
    import flash.display.Graphics;

    use namespace alternativa3d;

    public class WireMaterial extends TextureMaterial
    {
        private static const shape:Shape = new Shape();

        private var _color:uint;
        private var _thickness:int;
        private var _width:int;
        private var _height:int;
        private var _segments:int;

        public function WireMaterial(thickness:int, width:int, height:int, segments:int = 5, color:uint = 0x0)
        {
            _color = color;
            _thickness = thickness;
            _width = width;
            _height = height;
            _segments = segments;

            _hardwareMipMaps = true;
            _mipMapping = 1;
            super(createWireTexture());
        }

        override public function clone():Material
        {
            var _local_1:WireMaterial = new WireMaterial(_color, _thickness, _width, _height, _segments);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        private function createWireTexture() : BitmapData
        {
            var ctx:Graphics = shape.graphics;
            ctx.clear();
            shape.width = _width;
            shape.height = _height;

            var offsetPerNumX:Number = _width / _segments;
            var offsetPerNumY:Number = _height / _segments;

            ctx.lineStyle(_thickness, _color);

            var num:int;
            var pos:Number;
            for(num = 0; num < _segments; num++)
            {
                pos = num * offsetPerNumX;
                ctx.moveTo(pos, 0);
                ctx.lineTo(pos, _height);
            }
            for(num = 0; num < _segments; num++)
            {
                pos = num * offsetPerNumY;
                ctx.moveTo(0, pos);
                ctx.lineTo(_width, pos);
            }

            var bitmap:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
            bitmap.draw(shape);
            return bitmap;
        }
    }
}