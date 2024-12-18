package alternativa.gfx.core{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.display3D.textures.Texture;
    import flash.display3D.Context3D;
    import flash.display.BitmapData;
    import alternativa.engine3d.materials.TextureResourcesRegistry;
    import flash.display3D.Context3DTextureFormat;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class BitmapTextureResource extends TextureResource {

        private static const point:Point = new Point();
        private static const rectangle:Rectangle = new Rectangle();
        private static const matrix:Matrix = new Matrix();
        private static var nullTexture:Texture;
        private static var nullTextureContext:Context3D;

        private var referencesCount:int = 1;
        private var _bitmapData:BitmapData;
        private var _mipMapping:Boolean;
        private var _stretchNotPowerOf2Textures:Boolean;
        private var _calculateMipMapsUsingGPU:Boolean;
        private var _correctionU:Number = 1;
        private var _correctionV:Number = 1;
        private var correctedWidth:int;
        private var correctedHeight:int;

        public function BitmapTextureResource(_arg_1:BitmapData, _arg_2:Boolean, _arg_3:Boolean=false, _arg_4:Boolean=false){
            this._bitmapData = _arg_1;
            this._mipMapping = _arg_2;
            this._stretchNotPowerOf2Textures = _arg_3;
            this._calculateMipMapsUsingGPU = _arg_4;
            this.correctedWidth = Math.pow(2, Math.ceil((Math.log(this._bitmapData.width) / Math.LN2)));
            this.correctedHeight = Math.pow(2, Math.ceil((Math.log(this._bitmapData.height) / Math.LN2)));
            if (this.correctedWidth > 0x0800)
            {
                this.correctedWidth = 0x0800;
            };
            if (this.correctedHeight > 0x0800)
            {
                this.correctedHeight = 0x0800;
            };
            if ((((((!(this._bitmapData.width == this.correctedWidth)) || (!(this._bitmapData.height == this.correctedHeight))) && (!(this._stretchNotPowerOf2Textures))) && (this._bitmapData.width <= 0x0800)) && (this._bitmapData.height <= 0x0800)))
            {
                this._correctionU = (this._bitmapData.width / this.correctedWidth);
                this._correctionV = (this._bitmapData.height / this.correctedHeight);
            };
        }

        public function get bitmapData():BitmapData{
            return (this._bitmapData);
        }

        public function get mipMapping():Boolean{
            return (this._mipMapping);
        }

        public function get stretchNotPowerOf2Textures():Boolean{
            return (this._stretchNotPowerOf2Textures);
        }

        public function get correctionU():Number{
            return (this._correctionU);
        }

        public function get correctionV():Number{
            return (this._correctionV);
        }

        public function get calculateMipMapsUsingGPU():Boolean{
            return (this._calculateMipMapsUsingGPU);
        }

        public function set calculateMipMapsUsingGPU(_arg_1:Boolean):void{
            this._calculateMipMapsUsingGPU = _arg_1;
        }

        public function forceDispose():void{
            this.referencesCount = 1;
            this.dispose();
            this._bitmapData = null;
        }

        override public function dispose():void{
            if (this.referencesCount == 0)
            {
                return;
            };
            this.referencesCount--;
            if (this.referencesCount == 0)
            {
                TextureResourcesRegistry.release(this._bitmapData);
                this._bitmapData = null;
                super.dispose();
            };
        }

        override public function get available():Boolean{
            return (!(this._bitmapData == null));
        }

        override protected function getNullTexture():Texture{
            return (nullTexture);
        }

        private function freeMemory():void{
            useNullTexture = true;
            this._mipMapping = false;
            this.forceDispose();
        }

        override alternativagfx function create(context:Context3D):void{
            super.create(context);
            if (((nullTexture == null) || (!(nullTextureContext == context))))
            {
                nullTexture = context.createTexture(1, 1, Context3DTextureFormat.BGRA, false);
                nullTexture.uploadFromBitmapData(new BitmapData(1, 1, true, 1439485132));
                nullTextureContext = context;
            };
            if ((!(useNullTexture)))
            {
                try
                {
                    texture = context.createTexture(this.correctedWidth, this.correctedHeight, Context3DTextureFormat.BGRA, false);
                } catch(e:Error)
                {
                    freeMemory();
                };
            };
        }

        override alternativagfx function upload():void{
            var _local_1:BitmapData;
            var _local_2:BitmapData;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:BitmapData;
            if (useNullTexture)
            {
                return;
            };
            if (((this._bitmapData.width == this.correctedWidth) && (this._bitmapData.height == this.correctedHeight)))
            {
                _local_1 = this._bitmapData;
            } else
            {
                _local_1 = new BitmapData(this.correctedWidth, this.correctedHeight, this._bitmapData.transparent, 0);
                if ((((this._bitmapData.width <= 0x0800) && (this._bitmapData.height <= 0x0800)) && (!(this._stretchNotPowerOf2Textures))))
                {
                    _local_1.copyPixels(this._bitmapData, this._bitmapData.rect, point);
                    if (this._bitmapData.width < _local_1.width)
                    {
                        _local_2 = new BitmapData(1, this._bitmapData.height, this._bitmapData.transparent, 0);
                        rectangle.setTo((this._bitmapData.width - 1), 0, 1, this._bitmapData.height);
                        _local_2.copyPixels(this._bitmapData, rectangle, point);
                        matrix.setTo((_local_1.width - this._bitmapData.width), 0, 0, 1, this._bitmapData.width, 0);
                        _local_1.draw(_local_2, matrix, null, null, null, false);
                        _local_2.dispose();
                    };
                    if (this._bitmapData.height < _local_1.height)
                    {
                        _local_2 = new BitmapData(this._bitmapData.width, 1, this._bitmapData.transparent, 0);
                        rectangle.setTo(0, (this._bitmapData.height - 1), this._bitmapData.width, 1);
                        _local_2.copyPixels(this._bitmapData, rectangle, point);
                        matrix.setTo(1, 0, 0, (_local_1.height - this._bitmapData.height), 0, this._bitmapData.height);
                        _local_1.draw(_local_2, matrix, null, null, null, false);
                        _local_2.dispose();
                    };
                    if (((this._bitmapData.width < _local_1.width) && (this._bitmapData.height < _local_1.height)))
                    {
                        _local_2 = new BitmapData(1, 1, this._bitmapData.transparent, 0);
                        rectangle.setTo((this._bitmapData.width - 1), (this._bitmapData.height - 1), 1, 1);
                        _local_2.copyPixels(this._bitmapData, rectangle, point);
                        matrix.setTo((_local_1.width - this._bitmapData.width), 0, 0, (_local_1.height - this._bitmapData.height), this._bitmapData.width, this._bitmapData.height);
                        _local_1.draw(_local_2, matrix, null, null, null, false);
                        _local_2.dispose();
                    };
                } else
                {
                    matrix.setTo((this.correctedWidth / this._bitmapData.width), 0, 0, (this.correctedHeight / this._bitmapData.height), 0, 0);
                    _local_1.draw(this._bitmapData, matrix, null, null, null, true);
                };
            };
            if (this._mipMapping > 0)
            {
                this.uploadTexture(_local_1, 0);
                matrix.identity();
                _local_3 = 1;
                _local_4 = _local_1.width;
                _local_5 = _local_1.height;
                while ((((_local_4 % 2) == 0) || ((_local_5 % 2) == 0)))
                {
                    _local_4 = (_local_4 >> 1);
                    _local_5 = (_local_5 >> 1);
                    if (_local_4 == 0)
                    {
                        _local_4 = 1;
                    };
                    if (_local_5 == 0)
                    {
                        _local_5 = 1;
                    };
                    _local_6 = new BitmapData(_local_4, _local_5, _local_1.transparent, 0);
                    matrix.a = (_local_4 / _local_1.width);
                    matrix.d = (_local_5 / _local_1.height);
                    _local_6.draw(_local_1, matrix, null, null, null, false);
                    this.uploadTexture(_local_6, _local_3++);
                    _local_6.dispose();
                };
            } else
            {
                this.uploadTexture(_local_1, 0);
            };
            if (_local_1 != this._bitmapData)
            {
                _local_1.dispose();
            };
        }

        protected function uploadTexture(source:BitmapData, mipLevel:uint):void{
            try
            {
                if (texture != nullTexture)
                {
                    texture.uploadFromBitmapData(source, mipLevel);
                };
            } catch(e:Error)
            {
                freeMemory();
            };
        }

        public function increaseReferencesCount():void{
            this.referencesCount++;
        }


    }
}//package alternativa.gfx.core