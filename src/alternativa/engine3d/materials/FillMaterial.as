package alternativa.engine3d.materials
{
    import flash.display.BitmapData;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class FillMaterial extends TextureMaterial 
    {

        public var color:int;
        public var alpha:Number;
        public var lineThickness:Number;
        public var lineColor:int;

        public function FillMaterial(_arg_1:int=0x7F7F7F, _arg_2:Number=1, _arg_3:Number=-1, _arg_4:int=0xFFFFFF)
        {
            this.color = _arg_1;
            this.alpha = _arg_2;
            this.lineThickness = _arg_3;
            this.lineColor = _arg_4;
            //_texture = new BitmapData(1,1,true,(alpha * 255 << 24) + color);
        }

        override alternativa3d function get transparent():Boolean
        {
            return (this.alpha < 1);
        }

        override public function clone():Material
        {
            var _local_1:FillMaterial = new FillMaterial(this.color, this.alpha, this.lineThickness, this.lineColor);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override alternativa3d function drawOpaque(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D):void
        {
            var _local_7:uint = (((this.alpha * 0xFF) << 24) + this.color);
            var _local_8:BitmapData = texture;
            if (_local_8 != null)
            {
                if (_local_7 != _local_8.getPixel32(0, 0))
                {
                    _local_8.setPixel32(0, 0, _local_7);
                };
                super.drawOpaque(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        override alternativa3d function drawTransparent(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D, _arg_7:Boolean=false):void
        {
            var _local_8:uint = (((this.alpha * 0xFF) << 24) + this.color);
            var _local_9:BitmapData = texture;
            if (_local_9 != null)
            {
                if (_local_8 != _local_9.getPixel32(0, 0))
                {
                    _local_9.setPixel32(0, 0, _local_8);
                };
                super.drawTransparent(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }


    }
}//package alternativa.engine3d.materials