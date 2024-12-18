package alternativa.engine3d.core
{
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import alternativa.gfx.core.RenderTargetTextureResource;
    import alternativa.gfx.core.BitmapTextureResource;
    import alternativa.engine3d.lights.DirectionalLight;
    import flash.display.BitmapData;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.objects.BSP;
    import alternativa.gfx.core.Device;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.Context3DProgramType;
    import flash.utils.ByteArray;
    import alternativa.gfx.core.ProgramResource;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class ShadowMap 
    {

        private static const sizeLimit:int = 0x0800;
        private static const bigValue:Number = 0x0800;
        public static const numSamples:int = 6;

        private var programs:Array = new Array();
        private var spriteVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([0, 2, 4, 6]), 1);
        private var spriteIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0, 1, 3, 1, 2, 3]));
        alternativa3d var transform:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]);
        alternativa3d var params:Vector.<Number> = Vector.<Number>([(-255 * bigValue), -(bigValue), bigValue, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]);
        private var coords:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, (1 / 0xFF), 1]);
        private var fragment:Vector.<Number> = Vector.<Number>([(1 / 0xFF), 0, 1, 1]);
        private var alphaTestConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var scissor:Rectangle = new Rectangle();
        alternativa3d var map:RenderTargetTextureResource;
        alternativa3d var noise:BitmapTextureResource;
        private var noiseSize:int = 64;
        private var noiseAngle:Number = 1.0471975511966;
        private var noiseRadius:Number = 1.3;
        private var noiseRandom:Number = 0.3;
        public var mapSize:int;
        public var nearDistance:Number;
        public var farDistance:Number;
        public var bias:Number = 0;
        public var biasMultiplier:Number = 30;
        public var additionalSpace:Number = 0;
        public var alphaThreshold:Number = 0.1;
        private var defaultLight:DirectionalLight = new DirectionalLight(0x7F7F7F);
        private var boundVertexList:Vertex = Vertex.createList(8);
        private var light:DirectionalLight;
        private var dirZ:Number;
        private var planeX:Number;
        private var planeY:Number;
        private var planeSize:Number;
        private var pixel:Number;
        alternativa3d var boundMinX:Number;
        alternativa3d var boundMinY:Number;
        alternativa3d var boundMinZ:Number;
        alternativa3d var boundMaxX:Number;
        alternativa3d var boundMaxY:Number;
        alternativa3d var boundMaxZ:Number;

        public function ShadowMap(_arg_1:int, _arg_2:Number, _arg_3:Number, _arg_4:Number=0, _arg_5:Number=0)
        {
            var _local_10:int;
            var _local_11:Number;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            super();
            if (_arg_1 > sizeLimit)
            {
                throw (new Error("Value of mapSize too big."));
            };
            var _local_6:Number = (Math.log(_arg_1) / Math.LN2);
            if (_local_6 != int(_local_6))
            {
                throw (new Error("Value of mapSize must be power of 2."));
            };
            this.mapSize = _arg_1;
            this.nearDistance = _arg_2;
            this.farDistance = _arg_3;
            this.bias = _arg_4;
            this.additionalSpace = _arg_5;
            this.defaultLight.rotationX = Math.PI;
            this.map = new RenderTargetTextureResource(_arg_1, _arg_1);
            var _local_7:Vector.<uint> = new Vector.<uint>();
            var _local_8:int;
            var _local_9:int;
            while (_local_9 < this.noiseSize)
            {
                _local_10 = 0;
                while (_local_10 < this.noiseSize)
                {
                    _local_11 = (Math.random() * this.noiseAngle);
                    _local_12 = (Math.sin(_local_11) * 0xFF);
                    _local_13 = (Math.cos(_local_11) * 0xFF);
                    _local_14 = ((this.noiseRandom + (Math.random() * (1 - this.noiseRandom))) * 0xFF);
                    _local_7[_local_8] = (((_local_12 << 16) | (_local_13 << 8)) | _local_14);
                    _local_8++;
                    _local_10++;
                };
                _local_9++;
            };
            this.noise = new BitmapTextureResource(new BitmapData(this.noiseSize, this.noiseSize, false, 0), false);
            this.noise.bitmapData.setVector(this.noise.bitmapData.rect, _local_7);
        }

        alternativa3d function calculateBounds(_arg_1:Camera3D):void
        {
            if (_arg_1.directionalLight != null)
            {
                this.light = _arg_1.directionalLight;
            }
            else
            {
                this.light = this.defaultLight;
            };
            this.light.composeMatrix();
            this.dirZ = this.light.mk;
            this.light.calculateInverseMatrix();
            var _local_2:Number = this.light.ima;
            var _local_3:Number = this.light.imb;
            var _local_4:Number = this.light.imc;
            var _local_5:Number = this.light.imd;
            var _local_6:Number = this.light.ime;
            var _local_7:Number = this.light.imf;
            var _local_8:Number = this.light.img;
            var _local_9:Number = this.light.imh;
            var _local_10:Number = this.light.imi;
            var _local_11:Number = this.light.imj;
            var _local_12:Number = this.light.imk;
            var _local_13:Number = this.light.iml;
            this.light.ima = (((_local_2 * _arg_1.gma) + (_local_3 * _arg_1.gme)) + (_local_4 * _arg_1.gmi));
            this.light.imb = (((_local_2 * _arg_1.gmb) + (_local_3 * _arg_1.gmf)) + (_local_4 * _arg_1.gmj));
            this.light.imc = (((_local_2 * _arg_1.gmc) + (_local_3 * _arg_1.gmg)) + (_local_4 * _arg_1.gmk));
            this.light.imd = ((((_local_2 * _arg_1.gmd) + (_local_3 * _arg_1.gmh)) + (_local_4 * _arg_1.gml)) + _local_5);
            this.light.ime = (((_local_6 * _arg_1.gma) + (_local_7 * _arg_1.gme)) + (_local_8 * _arg_1.gmi));
            this.light.imf = (((_local_6 * _arg_1.gmb) + (_local_7 * _arg_1.gmf)) + (_local_8 * _arg_1.gmj));
            this.light.img = (((_local_6 * _arg_1.gmc) + (_local_7 * _arg_1.gmg)) + (_local_8 * _arg_1.gmk));
            this.light.imh = ((((_local_6 * _arg_1.gmd) + (_local_7 * _arg_1.gmh)) + (_local_8 * _arg_1.gml)) + _local_9);
            this.light.imi = (((_local_10 * _arg_1.gma) + (_local_11 * _arg_1.gme)) + (_local_12 * _arg_1.gmi));
            this.light.imj = (((_local_10 * _arg_1.gmb) + (_local_11 * _arg_1.gmf)) + (_local_12 * _arg_1.gmj));
            this.light.imk = (((_local_10 * _arg_1.gmc) + (_local_11 * _arg_1.gmg)) + (_local_12 * _arg_1.gmk));
            this.light.iml = ((((_local_10 * _arg_1.gmd) + (_local_11 * _arg_1.gmh)) + (_local_12 * _arg_1.gml)) + _local_13);
            var _local_14:Vertex = this.boundVertexList;
            _local_14.x = -(_arg_1.nearClipping);
            _local_14.y = -(_arg_1.nearClipping);
            _local_14.z = _arg_1.nearClipping;
            _local_14 = _local_14.next;
            _local_14.x = -(_arg_1.nearClipping);
            _local_14.y = _arg_1.nearClipping;
            _local_14.z = _arg_1.nearClipping;
            _local_14 = _local_14.next;
            _local_14.x = _arg_1.nearClipping;
            _local_14.y = _arg_1.nearClipping;
            _local_14.z = _arg_1.nearClipping;
            _local_14 = _local_14.next;
            _local_14.x = _arg_1.nearClipping;
            _local_14.y = -(_arg_1.nearClipping);
            _local_14.z = _arg_1.nearClipping;
            _local_14 = _local_14.next;
            _local_14.x = -(this.farDistance);
            _local_14.y = -(this.farDistance);
            _local_14.z = this.farDistance;
            _local_14 = _local_14.next;
            _local_14.x = -(this.farDistance);
            _local_14.y = this.farDistance;
            _local_14.z = this.farDistance;
            _local_14 = _local_14.next;
            _local_14.x = this.farDistance;
            _local_14.y = this.farDistance;
            _local_14.z = this.farDistance;
            _local_14 = _local_14.next;
            _local_14.x = this.farDistance;
            _local_14.y = -(this.farDistance);
            _local_14.z = this.farDistance;
            this.light.boundMinX = 1E22;
            this.light.boundMinY = 1E22;
            this.light.boundMinZ = 1E22;
            this.light.boundMaxX = -1E22;
            this.light.boundMaxY = -1E22;
            this.light.boundMaxZ = -1E22;
            _local_14 = this.boundVertexList;
            while (_local_14 != null)
            {
                _local_14.cameraX = ((((this.light.ima * _local_14.x) + (this.light.imb * _local_14.y)) + (this.light.imc * _local_14.z)) + this.light.imd);
                _local_14.cameraY = ((((this.light.ime * _local_14.x) + (this.light.imf * _local_14.y)) + (this.light.img * _local_14.z)) + this.light.imh);
                _local_14.cameraZ = ((((this.light.imi * _local_14.x) + (this.light.imj * _local_14.y)) + (this.light.imk * _local_14.z)) + this.light.iml);
                if (_local_14.cameraX < this.light.boundMinX)
                {
                    this.light.boundMinX = _local_14.cameraX;
                };
                if (_local_14.cameraX > this.light.boundMaxX)
                {
                    this.light.boundMaxX = _local_14.cameraX;
                };
                if (_local_14.cameraY < this.light.boundMinY)
                {
                    this.light.boundMinY = _local_14.cameraY;
                };
                if (_local_14.cameraY > this.light.boundMaxY)
                {
                    this.light.boundMaxY = _local_14.cameraY;
                };
                if (_local_14.cameraZ < this.light.boundMinZ)
                {
                    this.light.boundMinZ = _local_14.cameraZ;
                };
                if (_local_14.cameraZ > this.light.boundMaxZ)
                {
                    this.light.boundMaxZ = _local_14.cameraZ;
                };
                _local_14 = _local_14.next;
            };
            var _local_15:Vertex = this.boundVertexList;
            var _local_16:Vertex = this.boundVertexList.next.next.next.next.next.next;
            var _local_17:Vertex = this.boundVertexList.next.next.next.next;
            var _local_18:Number = (_local_16.cameraX - _local_15.cameraX);
            var _local_19:Number = (_local_16.cameraY - _local_15.cameraY);
            var _local_20:Number = (_local_16.cameraZ - _local_15.cameraZ);
            var _local_21:Number = (_local_17.cameraX - _local_16.cameraX);
            var _local_22:Number = (_local_17.cameraY - _local_16.cameraY);
            var _local_23:Number = (_local_17.cameraZ - _local_16.cameraZ);
            var _local_24:Number = (((_local_18 * _local_18) + (_local_19 * _local_19)) + (_local_20 * _local_20));
            var _local_25:Number = (((_local_21 * _local_21) + (_local_22 * _local_22)) + (_local_23 * _local_23));
            var _local_26:int = Math.ceil(this.noiseRadius);
            this.planeSize = ((_local_24 > _local_25) ? Math.sqrt(_local_24) : Math.sqrt(_local_25));
            this.pixel = (this.planeSize / ((this.mapSize - 1) - this.noiseRadius));
            this.planeSize = (this.planeSize + ((_local_26 * this.pixel) * 2));
            this.light.boundMinX = (this.light.boundMinX - (_local_26 * this.pixel));
            this.light.boundMaxX = (this.light.boundMaxX + (_local_26 * this.pixel));
            this.light.boundMinY = (this.light.boundMinY - (_local_26 * this.pixel));
            this.light.boundMaxY = (this.light.boundMaxY + (_local_26 * this.pixel));
            this.light.boundMinZ = (this.light.boundMinZ - this.additionalSpace);
            _local_14 = this.boundVertexList;
            _local_14.x = this.light.boundMinX;
            _local_14.y = this.light.boundMinY;
            _local_14.z = this.light.boundMinZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMaxX;
            _local_14.y = this.light.boundMinY;
            _local_14.z = this.light.boundMinZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMinX;
            _local_14.y = this.light.boundMaxY;
            _local_14.z = this.light.boundMinZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMaxX;
            _local_14.y = this.light.boundMaxY;
            _local_14.z = this.light.boundMinZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMinX;
            _local_14.y = this.light.boundMinY;
            _local_14.z = this.light.boundMaxZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMaxX;
            _local_14.y = this.light.boundMinY;
            _local_14.z = this.light.boundMaxZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMinX;
            _local_14.y = this.light.boundMaxY;
            _local_14.z = this.light.boundMaxZ;
            _local_14 = _local_14.next;
            _local_14.x = this.light.boundMaxX;
            _local_14.y = this.light.boundMaxY;
            _local_14.z = this.light.boundMaxZ;
            this.boundMinX = 1E22;
            this.boundMinY = 1E22;
            this.boundMinZ = 1E22;
            this.boundMaxX = -1E22;
            this.boundMaxY = -1E22;
            this.boundMaxZ = -1E22;
            _local_14 = this.boundVertexList;
            while (_local_14 != null)
            {
                _local_14.cameraX = ((((this.light.ma * _local_14.x) + (this.light.mb * _local_14.y)) + (this.light.mc * _local_14.z)) + this.light.md);
                _local_14.cameraY = ((((this.light.me * _local_14.x) + (this.light.mf * _local_14.y)) + (this.light.mg * _local_14.z)) + this.light.mh);
                _local_14.cameraZ = ((((this.light.mi * _local_14.x) + (this.light.mj * _local_14.y)) + (this.light.mk * _local_14.z)) + this.light.ml);
                if (_local_14.cameraX < this.boundMinX)
                {
                    this.boundMinX = _local_14.cameraX;
                };
                if (_local_14.cameraX > this.boundMaxX)
                {
                    this.boundMaxX = _local_14.cameraX;
                };
                if (_local_14.cameraY < this.boundMinY)
                {
                    this.boundMinY = _local_14.cameraY;
                };
                if (_local_14.cameraY > this.boundMaxY)
                {
                    this.boundMaxY = _local_14.cameraY;
                };
                if (_local_14.cameraZ < this.boundMinZ)
                {
                    this.boundMinZ = _local_14.cameraZ;
                };
                if (_local_14.cameraZ > this.boundMaxZ)
                {
                    this.boundMaxZ = _local_14.cameraZ;
                };
                _local_14 = _local_14.next;
            };
        }

        alternativa3d function render(_arg_1:Camera3D, _arg_2:Vector.<Object3D>, _arg_3:int):void
        {
            var _local_12:Object3D;
            var _local_13:VertexBufferResource;
            var _local_14:IndexBufferResource;
            var _local_15:int;
            var _local_16:Boolean;
            var _local_17:TextureMaterial;
            var _local_18:Sprite3D;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Mesh;
            var _local_34:BSP;
            var _local_4:Device = _arg_1.device;
            this.planeX = (Math.floor((this.light.boundMinX / this.pixel)) * this.pixel);
            this.planeY = (Math.floor((this.light.boundMinY / this.pixel)) * this.pixel);
            this.scissor.width = (Math.ceil((this.light.boundMaxX / this.pixel)) - (this.planeX / this.pixel));
            this.scissor.height = (Math.ceil((this.light.boundMaxY / this.pixel)) - (this.planeY / this.pixel));
            var _local_5:Number = (2 / this.planeSize);
            var _local_6:Number = (-2 / this.planeSize);
            var _local_7:Number = (0xFF / (this.light.boundMaxZ - this.light.boundMinZ));
            var _local_8:Number = (-(this.planeX + (this.planeSize * 0.5)) * _local_5);
            var _local_9:Number = (-(this.planeY + (this.planeSize * 0.5)) * _local_6);
            var _local_10:Number = (-(this.light.boundMinZ) * _local_7);
            if (this.mapSize != this.map.width)
            {
                this.map.dispose();
                this.map = new RenderTargetTextureResource(this.mapSize, this.mapSize);
            };
            _local_4.setRenderToTexture(this.map, true);
            _local_4.clear(1, 0, 0);
            _local_4.setScissorRectangle(this.scissor);
            this.transform[14] = (1 / 0xFF);
            var _local_11:int;
            while (_local_11 < _arg_3)
            {
                _local_12 = _arg_2[_local_11];
                _local_13 = null;
                _local_14 = null;
                _local_16 = false;
                if ((_local_12 is Sprite3D))
                {
                    _local_18 = Sprite3D(_local_12);
                    _local_17 = TextureMaterial(_local_18.material);
                    _local_19 = _local_18.width;
                    _local_20 = _local_18.height;
                    if (_local_18.autoSize)
                    {
                        _local_31 = (_local_18.bottomRightU - _local_18.topLeftU);
                        _local_32 = (_local_18.bottomRightV - _local_18.topLeftV);
                        _local_19 = (_local_17.texture.width * _local_31);
                        _local_20 = (_local_17.texture.height * _local_32);
                    };
                    _local_21 = Math.tan(Math.asin(-(this.dirZ)));
                    _local_19 = (_local_19 * _local_18.scaleX);
                    _local_20 = (_local_20 * _local_18.scaleY);
                    _local_22 = ((((this.light.ima * _local_12.md) + (this.light.imb * _local_12.mh)) + (this.light.imc * _local_12.ml)) + this.light.imd);
                    _local_23 = ((((this.light.ime * _local_12.md) + (this.light.imf * _local_12.mh)) + (this.light.img * _local_12.ml)) + this.light.imh);
                    _local_24 = ((((this.light.imi * _local_12.md) + (this.light.imj * _local_12.mh)) + (this.light.imk * _local_12.ml)) + this.light.iml);
                    _local_23 = (_local_23 + ((Math.sin(-(this.dirZ)) * _local_20) / 4));
                    _local_24 = (_local_24 - ((Math.cos(-(this.dirZ)) * _local_20) / 4));
                    _local_25 = (-(_local_19) * _local_18.originX);
                    _local_26 = (-(_local_20) * _local_18.originY);
                    _local_27 = (-(_local_26) / _local_21);
                    _local_28 = (_local_25 + _local_19);
                    _local_29 = (_local_26 + _local_20);
                    _local_30 = (-(_local_29) / _local_21);
                    _local_25 = (((_local_25 + _local_22) * _local_5) + _local_8);
                    _local_26 = (((_local_26 + _local_23) * _local_6) + _local_9);
                    _local_27 = (((_local_27 + _local_24) * _local_7) + _local_10);
                    _local_28 = (((_local_28 + _local_22) * _local_5) + _local_8);
                    _local_29 = (((_local_29 + _local_23) * _local_6) + _local_9);
                    _local_30 = (((_local_30 + _local_24) * _local_7) + _local_10);
                    _local_27 = (_local_27 - (((this.bias * this.biasMultiplier) * _local_7) / _local_21));
                    _local_30 = (_local_30 - (((this.bias * this.biasMultiplier) * _local_7) / _local_21));
                    this.coords[0] = _local_25;
                    this.coords[1] = _local_26;
                    this.coords[2] = _local_27;
                    this.coords[4] = 0;
                    this.coords[5] = 0;
                    this.coords[8] = _local_25;
                    this.coords[9] = _local_29;
                    this.coords[10] = _local_30;
                    this.coords[12] = 0;
                    this.coords[13] = 1;
                    this.coords[16] = _local_28;
                    this.coords[17] = _local_29;
                    this.coords[18] = _local_30;
                    this.coords[20] = 1;
                    this.coords[21] = 1;
                    this.coords[24] = _local_28;
                    this.coords[25] = _local_26;
                    this.coords[26] = _local_27;
                    this.coords[28] = 1;
                    this.coords[29] = 0;
                    _local_13 = this.spriteVertexBuffer;
                    _local_14 = this.spriteIndexBuffer;
                    _local_15 = 2;
                    _local_16 = true;
                    _local_4.setProgram(this.getProgram(true, true));
                    _local_4.setVertexBufferAt(0, _local_13, 0, Context3DVertexBufferFormat.FLOAT_1);
                    _local_4.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, this.coords, 9, false);
                }
                else
                {
                    this.transform[0] = ((((this.light.ima * _local_12.ma) + (this.light.imb * _local_12.me)) + (this.light.imc * _local_12.mi)) * _local_5);
                    this.transform[1] = ((((this.light.ima * _local_12.mb) + (this.light.imb * _local_12.mf)) + (this.light.imc * _local_12.mj)) * _local_5);
                    this.transform[2] = ((((this.light.ima * _local_12.mc) + (this.light.imb * _local_12.mg)) + (this.light.imc * _local_12.mk)) * _local_5);
                    this.transform[3] = ((((((this.light.ima * _local_12.md) + (this.light.imb * _local_12.mh)) + (this.light.imc * _local_12.ml)) + this.light.imd) * _local_5) + _local_8);
                    this.transform[4] = ((((this.light.ime * _local_12.ma) + (this.light.imf * _local_12.me)) + (this.light.img * _local_12.mi)) * _local_6);
                    this.transform[5] = ((((this.light.ime * _local_12.mb) + (this.light.imf * _local_12.mf)) + (this.light.img * _local_12.mj)) * _local_6);
                    this.transform[6] = ((((this.light.ime * _local_12.mc) + (this.light.imf * _local_12.mg)) + (this.light.img * _local_12.mk)) * _local_6);
                    this.transform[7] = ((((((this.light.ime * _local_12.md) + (this.light.imf * _local_12.mh)) + (this.light.img * _local_12.ml)) + this.light.imh) * _local_6) + _local_9);
                    this.transform[8] = ((((this.light.imi * _local_12.ma) + (this.light.imj * _local_12.me)) + (this.light.imk * _local_12.mi)) * _local_7);
                    this.transform[9] = ((((this.light.imi * _local_12.mb) + (this.light.imj * _local_12.mf)) + (this.light.imk * _local_12.mj)) * _local_7);
                    this.transform[10] = ((((this.light.imi * _local_12.mc) + (this.light.imj * _local_12.mg)) + (this.light.imk * _local_12.mk)) * _local_7);
                    this.transform[11] = ((((((this.light.imi * _local_12.md) + (this.light.imj * _local_12.mh)) + (this.light.imk * _local_12.ml)) + this.light.iml) * _local_7) + _local_10);
                    if ((_local_12 is Mesh))
                    {
                        _local_33 = Mesh(_local_12);
                        _local_33.prepareResources();
                        _local_13 = _local_33.vertexBuffer;
                        _local_14 = _local_33.indexBuffer;
                        _local_15 = _local_33.numTriangles;
                        _local_17 = (_local_33.faceList.material as TextureMaterial);
                    }
                    else
                    {
                        if ((_local_12 is BSP))
                        {
                            _local_34 = BSP(_local_12);
                            _local_34.prepareResources();
                            _local_13 = _local_34.vertexBuffer;
                            _local_14 = _local_34.indexBuffer;
                            _local_15 = _local_34.numTriangles;
                            _local_17 = (_local_34.faces[0].material as TextureMaterial);
                        }
                        else
                        {
                            _local_17 = null;
                        };
                    };
                    if (((!(_local_17 == null)) && (_local_17.transparent)))
                    {
                        _local_16 = true;
                        _local_4.setProgram(this.getProgram(true, false));
                        _local_4.setVertexBufferAt(1, _local_13, 3, Context3DVertexBufferFormat.FLOAT_2);
                    }
                    else
                    {
                        _local_4.setProgram(this.getProgram(false, false));
                    };
                    _local_4.setVertexBufferAt(0, _local_13, 0, Context3DVertexBufferFormat.FLOAT_3);
                    _local_4.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, this.transform, 4, false);
                };
                if (((!(_local_13 == null)) && (!(_local_14 == null))))
                {
                    _local_4.setTextureAt(4, null);
                    _local_4.setTextureAt(6, null);
                    if (_local_16)
                    {
                        _local_4.setTextureAt(0, _local_17.textureResource);
                        this.alphaTestConst[0] = _local_17.textureResource.correctionU;
                        this.alphaTestConst[1] = _local_17.textureResource.correctionV;
                        this.alphaTestConst[3] = ((_local_12 is Sprite3D) ? 0.99 : this.alphaThreshold);
                        _local_4.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, this.alphaTestConst, 1);
                    };
                    _local_4.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fragment, 1);
                    _local_4.drawTriangles(_local_14, 0, _local_15);
                };
                if (_local_16)
                {
                    _local_4.setTextureAt(0, null);
                    _local_4.setVertexBufferAt(1, null);
                };
                _local_11++;
            };
            _local_4.setScissorRectangle(null);
            _local_5 = (1 / this.planeSize);
            _local_6 = (1 / this.planeSize);
            _local_8 = (-(this.planeX) * _local_5);
            _local_9 = (-(this.planeY) * _local_6);
            this.transform[0] = (this.light.ima * _local_5);
            this.transform[1] = (this.light.imb * _local_5);
            this.transform[2] = (this.light.imc * _local_5);
            this.transform[3] = ((this.light.imd * _local_5) + _local_8);
            this.transform[4] = (this.light.ime * _local_6);
            this.transform[5] = (this.light.imf * _local_6);
            this.transform[6] = (this.light.img * _local_6);
            this.transform[7] = ((this.light.imh * _local_6) + _local_9);
            this.transform[8] = (this.light.imi * _local_7);
            this.transform[9] = (this.light.imj * _local_7);
            this.transform[10] = (this.light.imk * _local_7);
            this.transform[11] = (((this.light.iml * _local_7) + _local_10) - ((this.bias * this.biasMultiplier) * _local_7));
            this.transform[12] = this.nearDistance;
            this.transform[13] = (this.farDistance - this.nearDistance);
            this.transform[14] = -(_local_7);
            this.params[4] = 0;
            this.params[5] = 0;
            this.params[6] = (this.noiseRadius / this.mapSize);
            this.params[7] = (1 / numSamples);
            this.params[8] = (_arg_1.view._width / this.noiseSize);
            this.params[9] = (_arg_1.view._height / this.noiseSize);
            this.params[11] = ((_arg_1.directionalLight != null) ? (_arg_1.directionalLightStrength * _arg_1.shadowMapStrength) : 0);
            this.params[12] = Math.cos(this.noiseAngle);
            this.params[13] = Math.sin(this.noiseAngle);
            this.params[16] = -(Math.sin(this.noiseAngle));
            this.params[17] = Math.cos(this.noiseAngle);
        }

        public function dispose():void
        {
            this.map.reset();
            this.noise.reset();
        }

        private function getProgram(_arg_1:Boolean, _arg_2:Boolean):ProgramResource
        {
            var _local_5:ByteArray;
            var _local_6:ByteArray;
            var _local_3:int = (int(_arg_1) | (int(_arg_2) << 1));
            var _local_4:ProgramResource = this.programs[_local_3];
            if (_local_4 == null)
            {
                _local_5 = new ShadowMapVertexShader(_arg_1, _arg_2).agalcode;
                _local_6 = new ShadowMapFragmentShader(_arg_1).agalcode;
                _local_4 = new ProgramResource(_local_5, _local_6);
                this.programs[_local_3] = _local_4;
            };
            return (_local_4);
        }


    }
}//package alternativa.engine3d.core