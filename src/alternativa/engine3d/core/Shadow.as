package alternativa.engine3d.core
{
    import alternativa.gfx.core.ProgramResource;
    import __AS3__.vec.Vector;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import flash.geom.Vector3D;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.lights.DirectionalLight;
    import alternativa.gfx.core.TextureResource;
    import flash.utils.ByteArray;
    import alternativa.gfx.agal.FragmentShader;
    import alternativa.gfx.agal.Shader;
    import alternativa.gfx.core.Device;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.Context3DProgramType;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Shadow 
    {

        private static var casterProgram:ProgramResource;
        private static var casterConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]);
        private static var volumeProgram:ProgramResource;
        private static var volumeVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1]), 3);
        private static var volumeIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0, 1, 3, 2, 3, 1, 7, 6, 4, 5, 4, 6, 4, 5, 0, 1, 0, 5, 3, 2, 7, 6, 7, 2, 0, 3, 4, 7, 4, 3, 5, 6, 1, 2, 1, 6]));
        private static var volumeTransformConst:Vector.<Number> = new Vector.<Number>(20);
        private static var volumeFragmentConst:Vector.<Number> = Vector.<Number>([1, 0, 1, 0.5]);
        private static var receiverPrograms:Array = new Array();

        public var mapSize:int;
        public var blur:int;
        public var attenuation:Number;
        public var nearDistance:Number;
        public var farDistance:Number;
        public var color:int;
        public var alpha:Number;
        public var direction:Vector3D = new Vector3D(0, 0, -1);
        public var offset:Number = 0;
        public var backFadeRange:Number = 0;
        private var casters:Vector.<Mesh> = new Vector.<Mesh>();
        private var castersCount:int = 0;
        alternativa3d var receiversBuffers:Vector.<int> = new Vector.<int>();
        alternativa3d var receiversFirstIndexes:Vector.<int> = new Vector.<int>();
        alternativa3d var receiversNumsTriangles:Vector.<int> = new Vector.<int>();
        alternativa3d var receiversCount:int = 0;
        private var dir:Vector3D = new Vector3D();
        private var light:DirectionalLight = new DirectionalLight(0);
        private var boundVertexList:Vertex = Vertex.createList(8);
        private var planeX:Number;
        private var planeY:Number;
        private var planeSize:Number;
        private var minZ:Number;
        alternativa3d var boundMinX:Number;
        alternativa3d var boundMinY:Number;
        alternativa3d var boundMinZ:Number;
        alternativa3d var boundMaxX:Number;
        alternativa3d var boundMaxY:Number;
        alternativa3d var boundMaxZ:Number;
        alternativa3d var cameraInside:Boolean;
        private var transformConst:Vector.<Number> = new Vector.<Number>(12);
        private var uvConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);
        private var colorConst:Vector.<Number> = new Vector.<Number>(12);
        private var clampConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        alternativa3d var texture:TextureResource;
        alternativa3d var textureScaleU:Number;
        alternativa3d var textureScaleV:Number;
        alternativa3d var textureOffsetU:Number;
        alternativa3d var textureOffsetV:Number;

        public function Shadow(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:int=0, _arg_7:Number=1)
        {
            if (_arg_1 > ShadowAtlas.sizeLimit)
            {
                throw (new Error("Value of mapSize too big."));
            };
            var _local_8:Number = (Math.log(_arg_1) / Math.LN2);
            if (_local_8 != int(_local_8))
            {
                throw (new Error("Value of mapSize must be power of 2."));
            };
            this.mapSize = _arg_1;
            this.blur = _arg_2;
            this.attenuation = _arg_3;
            this.nearDistance = _arg_4;
            this.farDistance = _arg_5;
            this.color = _arg_6;
            this.alpha = _arg_7;
        }

        alternativa3d static function getCasterProgram():ProgramResource
        {
            var _local_2:ByteArray;
            var _local_3:FragmentShader;
            var _local_1:ProgramResource = casterProgram;
            if (_local_1 == null)
            {
                _local_2 = new ShadowCasterVertexShader().agalcode;
                _local_3 = new FragmentShader();
                _local_3.mov(FragmentShader.oc, Shader.v0);
                _local_1 = new ProgramResource(_local_2, _local_3.agalcode);
                casterProgram = _local_1;
            };
            return (_local_1);
        }


        public function addCaster(_arg_1:Mesh):void
        {
            this.casters[this.castersCount] = _arg_1;
            this.castersCount++;
        }

        public function removeCaster(_arg_1:Mesh):void
        {
            var _local_2:int;
            while (_local_2 < this.castersCount)
            {
                if (this.casters[_local_2] == _arg_1)
                {
                    this.castersCount--;
                    while (_local_2 < this.castersCount)
                    {
                        this.casters[_local_2] = this.casters[int((_local_2 + 1))];
                        _local_2++;
                    };
                    this.casters.length = this.castersCount;
                    return;
                };
                _local_2++;
            };
        }

        public function removeAllCasters():void
        {
            this.castersCount = 0;
            this.casters.length = 0;
        }

        alternativa3d function checkVisibility(_arg_1:Camera3D):Boolean
        {
            var _local_24:Object3D;
            var _local_25:Object3D;
            var _local_26:Vertex;
            var _local_27:Number;
            if (this.castersCount == 0)
            {
                return (false);
            };
            if (this.direction != null)
            {
                this.dir.x = this.direction.x;
                this.dir.y = this.direction.y;
                this.dir.z = this.direction.z;
                this.dir.normalize();
            }
            else
            {
                this.dir.x = 0;
                this.dir.y = 0;
                this.dir.z = -1;
            };
            this.light.rotationX = (Math.atan2(this.dir.z, Math.sqrt(((this.dir.x * this.dir.x) + (this.dir.y * this.dir.y)))) - (Math.PI / 2));
            this.light.rotationY = 0;
            this.light.rotationZ = -(Math.atan2(this.dir.x, this.dir.y));
            this.light.composeMatrix();
            var _local_2:Number = this.light.ma;
            var _local_3:Number = this.light.mb;
            var _local_4:Number = this.light.mc;
            var _local_5:Number = this.light.md;
            var _local_6:Number = this.light.me;
            var _local_7:Number = this.light.mf;
            var _local_8:Number = this.light.mg;
            var _local_9:Number = this.light.mh;
            var _local_10:Number = this.light.mi;
            var _local_11:Number = this.light.mj;
            var _local_12:Number = this.light.mk;
            var _local_13:Number = this.light.ml;
            this.light.invertMatrix();
            this.light.ima = this.light.ma;
            this.light.imb = this.light.mb;
            this.light.imc = this.light.mc;
            this.light.imd = this.light.md;
            this.light.ime = this.light.me;
            this.light.imf = this.light.mf;
            this.light.img = this.light.mg;
            this.light.imh = this.light.mh;
            this.light.imi = this.light.mi;
            this.light.imj = this.light.mj;
            this.light.imk = this.light.mk;
            this.light.iml = this.light.ml;
            this.light.boundMinX = 1E22;
            this.light.boundMinY = 1E22;
            this.light.boundMinZ = 1E22;
            this.light.boundMaxX = -1E22;
            this.light.boundMaxY = -1E22;
            this.light.boundMaxZ = -1E22;
            var _local_14:int;
            while (_local_14 < this.castersCount)
            {
                _local_24 = this.casters[_local_14];
                _local_24.composeMatrix();
                _local_25 = _local_24._parent;
                while (_local_25 != null)
                {
                    Object3D.tA.composeMatrixFromSource(_local_25);
                    _local_24.appendMatrix(Object3D.tA);
                    _local_25 = _local_25._parent;
                };
                _local_24.appendMatrix(this.light);
                _local_26 = this.boundVertexList;
                _local_26.x = _local_24.boundMinX;
                _local_26.y = _local_24.boundMinY;
                _local_26.z = _local_24.boundMinZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMaxX;
                _local_26.y = _local_24.boundMinY;
                _local_26.z = _local_24.boundMinZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMinX;
                _local_26.y = _local_24.boundMaxY;
                _local_26.z = _local_24.boundMinZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMaxX;
                _local_26.y = _local_24.boundMaxY;
                _local_26.z = _local_24.boundMinZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMinX;
                _local_26.y = _local_24.boundMinY;
                _local_26.z = _local_24.boundMaxZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMaxX;
                _local_26.y = _local_24.boundMinY;
                _local_26.z = _local_24.boundMaxZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMinX;
                _local_26.y = _local_24.boundMaxY;
                _local_26.z = _local_24.boundMaxZ;
                _local_26 = _local_26.next;
                _local_26.x = _local_24.boundMaxX;
                _local_26.y = _local_24.boundMaxY;
                _local_26.z = _local_24.boundMaxZ;
                _local_26 = this.boundVertexList;
                while (_local_26 != null)
                {
                    _local_26.cameraX = ((((_local_24.ma * _local_26.x) + (_local_24.mb * _local_26.y)) + (_local_24.mc * _local_26.z)) + _local_24.md);
                    _local_26.cameraY = ((((_local_24.me * _local_26.x) + (_local_24.mf * _local_26.y)) + (_local_24.mg * _local_26.z)) + _local_24.mh);
                    _local_26.cameraZ = ((((_local_24.mi * _local_26.x) + (_local_24.mj * _local_26.y)) + (_local_24.mk * _local_26.z)) + _local_24.ml);
                    if (_local_26.cameraX < this.light.boundMinX)
                    {
                        this.light.boundMinX = _local_26.cameraX;
                    };
                    if (_local_26.cameraX > this.light.boundMaxX)
                    {
                        this.light.boundMaxX = _local_26.cameraX;
                    };
                    if (_local_26.cameraY < this.light.boundMinY)
                    {
                        this.light.boundMinY = _local_26.cameraY;
                    };
                    if (_local_26.cameraY > this.light.boundMaxY)
                    {
                        this.light.boundMaxY = _local_26.cameraY;
                    };
                    if (_local_26.cameraZ < this.light.boundMinZ)
                    {
                        this.light.boundMinZ = _local_26.cameraZ;
                    };
                    if (_local_26.cameraZ > this.light.boundMaxZ)
                    {
                        this.light.boundMaxZ = _local_26.cameraZ;
                    };
                    _local_26 = _local_26.next;
                };
                _local_14++;
            };
            var _local_15:int = ((((this.mapSize - 1) - 1) - this.blur) - this.blur);
            var _local_16:Number = (this.light.boundMaxX - this.light.boundMinX);
            var _local_17:Number = (this.light.boundMaxY - this.light.boundMinY);
            var _local_18:Number = ((_local_16 > _local_17) ? _local_16 : _local_17);
            var _local_19:Number = (_local_18 / _local_15);
            var _local_20:Number = ((1 + this.blur) * _local_19);
            var _local_21:Number = ((1 + this.blur) * _local_19);
            if (_local_16 > _local_17)
            {
                _local_21 = (_local_21 + (((Math.ceil(((_local_17 - 0.01) / (_local_19 + _local_19))) * (_local_19 + _local_19)) - _local_17) * 0.5));
            }
            else
            {
                _local_20 = (_local_20 + (((Math.ceil(((_local_16 - 0.01) / (_local_19 + _local_19))) * (_local_19 + _local_19)) - _local_16) * 0.5));
            };
            this.light.boundMinX = (this.light.boundMinX - _local_20);
            this.light.boundMaxX = (this.light.boundMaxX + _local_20);
            this.light.boundMinY = (this.light.boundMinY - _local_21);
            this.light.boundMaxY = (this.light.boundMaxY + _local_21);
            this.light.boundMinZ = (this.light.boundMinZ + this.offset);
            this.light.boundMaxZ = (this.light.boundMaxZ + this.attenuation);
            this.planeSize = ((_local_18 * this.mapSize) / _local_15);
            if (_local_16 > _local_17)
            {
                this.planeX = this.light.boundMinX;
                this.planeY = (this.light.boundMinY - (((this.light.boundMaxX - this.light.boundMinX) - (this.light.boundMaxY - this.light.boundMinY)) * 0.5));
            }
            else
            {
                this.planeX = (this.light.boundMinX - (((this.light.boundMaxY - this.light.boundMinY) - (this.light.boundMaxX - this.light.boundMinX)) * 0.5));
                this.planeY = this.light.boundMinY;
            };
            var _local_22:Number = _arg_1.farClipping;
            _arg_1.farClipping = (this.farDistance * _arg_1.shadowsDistanceMultiplier);
            this.light.ma = _local_2;
            this.light.mb = _local_3;
            this.light.mc = _local_4;
            this.light.md = _local_5;
            this.light.me = _local_6;
            this.light.mf = _local_7;
            this.light.mg = _local_8;
            this.light.mh = _local_9;
            this.light.mi = _local_10;
            this.light.mj = _local_11;
            this.light.mk = _local_12;
            this.light.ml = _local_13;
            this.light.appendMatrix(_arg_1);
            var _local_23:Boolean = this.cullingInCamera(_arg_1);
            _arg_1.farClipping = _local_22;
            if (_local_23)
            {
                if (((_arg_1.debug) && (_arg_1.checkInDebug(this.light) & Debug.BOUNDS)))
                {
                    Debug.drawBounds(_arg_1, this.light, this.light.boundMinX, this.light.boundMinY, this.light.boundMinZ, this.light.boundMaxX, this.light.boundMaxY, this.light.boundMaxZ, 0xFF00FF);
                };
                this.boundMinX = 1E22;
                this.boundMinY = 1E22;
                this.boundMinZ = 1E22;
                this.boundMaxX = -1E22;
                this.boundMaxY = -1E22;
                this.boundMaxZ = -1E22;
                _local_26 = this.boundVertexList;
                while (_local_26 != null)
                {
                    _local_26.cameraX = ((((_local_2 * _local_26.x) + (_local_3 * _local_26.y)) + (_local_4 * _local_26.z)) + _local_5);
                    _local_26.cameraY = ((((_local_6 * _local_26.x) + (_local_7 * _local_26.y)) + (_local_8 * _local_26.z)) + _local_9);
                    _local_26.cameraZ = ((((_local_10 * _local_26.x) + (_local_11 * _local_26.y)) + (_local_12 * _local_26.z)) + _local_13);
                    if (_local_26.cameraX < this.boundMinX)
                    {
                        this.boundMinX = _local_26.cameraX;
                    };
                    if (_local_26.cameraX > this.boundMaxX)
                    {
                        this.boundMaxX = _local_26.cameraX;
                    };
                    if (_local_26.cameraY < this.boundMinY)
                    {
                        this.boundMinY = _local_26.cameraY;
                    };
                    if (_local_26.cameraY > this.boundMaxY)
                    {
                        this.boundMaxY = _local_26.cameraY;
                    };
                    if (_local_26.cameraZ < this.boundMinZ)
                    {
                        this.boundMinZ = _local_26.cameraZ;
                    };
                    if (_local_26.cameraZ > this.boundMaxZ)
                    {
                        this.boundMaxZ = _local_26.cameraZ;
                    };
                    _local_26 = _local_26.next;
                };
                this.cameraInside = false;
                if (this.minZ <= _arg_1.nearClipping)
                {
                    _local_27 = ((((this.light.ima * _arg_1.gmd) + (this.light.imb * _arg_1.gmh)) + (this.light.imc * _arg_1.gml)) + this.light.imd);
                    if ((((_local_27 - _arg_1.nearClipping) <= this.light.boundMaxX) && ((_local_27 + _arg_1.nearClipping) >= this.light.boundMinX)))
                    {
                        _local_27 = ((((this.light.ime * _arg_1.gmd) + (this.light.imf * _arg_1.gmh)) + (this.light.img * _arg_1.gml)) + this.light.imh);
                        if ((((_local_27 - _arg_1.nearClipping) <= this.light.boundMaxY) && ((_local_27 + _arg_1.nearClipping) >= this.light.boundMinY)))
                        {
                            _local_27 = ((((this.light.imi * _arg_1.gmd) + (this.light.imj * _arg_1.gmh)) + (this.light.imk * _arg_1.gml)) + this.light.iml);
                            if ((((_local_27 - _arg_1.nearClipping) <= this.light.boundMaxZ) && ((_local_27 + _arg_1.nearClipping) >= this.light.boundMinZ)))
                            {
                                this.cameraInside = true;
                            };
                        };
                    };
                };
            };
            return (_local_23);
        }

        alternativa3d function renderCasters(_arg_1:Camera3D):void
        {
            var _local_10:Mesh;
            var _local_2:Device = _arg_1.device;
            var _local_3:Number = (2 / this.planeSize);
            var _local_4:Number = (-2 / this.planeSize);
            var _local_5:Number = (1 / ((this.light.boundMaxZ - this.attenuation) - (this.light.boundMinZ - this.offset)));
            var _local_6:Number = (-(this.light.boundMinZ - this.offset) * _local_5);
            var _local_7:Number = ((this.light.boundMinX + this.light.boundMaxX) * 0.5);
            var _local_8:Number = ((this.light.boundMinY + this.light.boundMaxY) * 0.5);
            var _local_9:int;
            while (_local_9 < this.castersCount)
            {
                _local_10 = this.casters[_local_9];
                _local_10.prepareResources();
                casterConst[0] = (_local_10.ma * _local_3);
                casterConst[1] = (_local_10.mb * _local_3);
                casterConst[2] = (_local_10.mc * _local_3);
                casterConst[3] = ((_local_10.md - _local_7) * _local_3);
                casterConst[4] = (_local_10.me * _local_4);
                casterConst[5] = (_local_10.mf * _local_4);
                casterConst[6] = (_local_10.mg * _local_4);
                casterConst[7] = ((_local_10.mh - _local_8) * _local_4);
                casterConst[8] = (_local_10.mi * _local_5);
                casterConst[9] = (_local_10.mj * _local_5);
                casterConst[10] = (_local_10.mk * _local_5);
                casterConst[11] = ((_local_10.ml * _local_5) + _local_6);
                casterConst[12] = this.textureScaleU;
                casterConst[13] = this.textureScaleV;
                casterConst[16] = (((2 * this.textureOffsetU) - 1) + this.textureScaleU);
                casterConst[17] = -(((2 * this.textureOffsetV) - 1) + this.textureScaleV);
                _local_2.setVertexBufferAt(0, _local_10.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, casterConst, 5, false);
                _local_2.drawTriangles(_local_10.indexBuffer, 0, _local_10.numTriangles);
                _local_9++;
            };
            this.clampConst[0] = this.textureOffsetU;
            this.clampConst[1] = this.textureOffsetV;
            this.clampConst[2] = (this.textureOffsetU + this.textureScaleU);
            this.clampConst[3] = (this.textureOffsetV + this.textureScaleV);
        }

        alternativa3d function renderVolume(_arg_1:Camera3D):void
        {
            var _local_2:Device = _arg_1.device;
            volumeTransformConst[0] = this.light.ma;
            volumeTransformConst[1] = this.light.mb;
            volumeTransformConst[2] = this.light.mc;
            volumeTransformConst[3] = this.light.md;
            volumeTransformConst[4] = this.light.me;
            volumeTransformConst[5] = this.light.mf;
            volumeTransformConst[6] = this.light.mg;
            volumeTransformConst[7] = this.light.mh;
            volumeTransformConst[8] = this.light.mi;
            volumeTransformConst[9] = this.light.mj;
            volumeTransformConst[10] = this.light.mk;
            volumeTransformConst[11] = this.light.ml;
            volumeTransformConst[12] = (this.light.boundMaxX - this.light.boundMinX);
            volumeTransformConst[13] = (this.light.boundMaxY - this.light.boundMinY);
            volumeTransformConst[14] = (this.light.boundMaxZ - this.light.boundMinZ);
            volumeTransformConst[15] = 1;
            volumeTransformConst[16] = this.light.boundMinX;
            volumeTransformConst[17] = this.light.boundMinY;
            volumeTransformConst[18] = this.light.boundMinZ;
            volumeTransformConst[19] = 1;
            _local_2.setProgram(this.getVolumeProgram());
            _local_2.setVertexBufferAt(0, volumeVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, volumeTransformConst, 5, false);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 16, _arg_1.projection, 1);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 17, _arg_1.correction, 1);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, volumeFragmentConst, 1);
            _local_2.drawTriangles(volumeIndexBuffer, 0, 12);
        }

        alternativa3d function renderReceivers(_arg_1:Camera3D):void
        {
            var _local_21:int;
            var _local_2:Device = _arg_1.device;
            var _local_3:Number = (this.light.boundMinZ - this.offset);
            var _local_4:Number = ((this.light.boundMaxZ - this.attenuation) - _local_3);
            var _local_5:Number = (this.light.ima / this.planeSize);
            var _local_6:Number = (this.light.imb / this.planeSize);
            var _local_7:Number = (this.light.imc / this.planeSize);
            var _local_8:Number = ((this.light.imd - this.planeX) / this.planeSize);
            var _local_9:Number = (this.light.ime / this.planeSize);
            var _local_10:Number = (this.light.imf / this.planeSize);
            var _local_11:Number = (this.light.img / this.planeSize);
            var _local_12:Number = ((this.light.imh - this.planeY) / this.planeSize);
            var _local_13:Number = (this.light.imi / _local_4);
            var _local_14:Number = (this.light.imj / _local_4);
            var _local_15:Number = (this.light.imk / _local_4);
            var _local_16:Number = ((this.light.iml - _local_3) / _local_4);
            this.transformConst[0] = (((_local_5 * _arg_1.gma) + (_local_6 * _arg_1.gme)) + (_local_7 * _arg_1.gmi));
            this.transformConst[1] = (((_local_5 * _arg_1.gmb) + (_local_6 * _arg_1.gmf)) + (_local_7 * _arg_1.gmj));
            this.transformConst[2] = (((_local_5 * _arg_1.gmc) + (_local_6 * _arg_1.gmg)) + (_local_7 * _arg_1.gmk));
            this.transformConst[3] = ((((_local_5 * _arg_1.gmd) + (_local_6 * _arg_1.gmh)) + (_local_7 * _arg_1.gml)) + _local_8);
            this.transformConst[4] = (((_local_9 * _arg_1.gma) + (_local_10 * _arg_1.gme)) + (_local_11 * _arg_1.gmi));
            this.transformConst[5] = (((_local_9 * _arg_1.gmb) + (_local_10 * _arg_1.gmf)) + (_local_11 * _arg_1.gmj));
            this.transformConst[6] = (((_local_9 * _arg_1.gmc) + (_local_10 * _arg_1.gmg)) + (_local_11 * _arg_1.gmk));
            this.transformConst[7] = ((((_local_9 * _arg_1.gmd) + (_local_10 * _arg_1.gmh)) + (_local_11 * _arg_1.gml)) + _local_12);
            this.transformConst[8] = (((_local_13 * _arg_1.gma) + (_local_14 * _arg_1.gme)) + (_local_15 * _arg_1.gmi));
            this.transformConst[9] = (((_local_13 * _arg_1.gmb) + (_local_14 * _arg_1.gmf)) + (_local_15 * _arg_1.gmj));
            this.transformConst[10] = (((_local_13 * _arg_1.gmc) + (_local_14 * _arg_1.gmg)) + (_local_15 * _arg_1.gmk));
            this.transformConst[11] = ((((_local_13 * _arg_1.gmd) + (_local_14 * _arg_1.gmh)) + (_local_15 * _arg_1.gml)) + _local_16);
            this.uvConst[0] = this.textureScaleU;
            this.uvConst[1] = this.textureScaleV;
            this.uvConst[4] = this.textureOffsetU;
            this.uvConst[5] = this.textureOffsetV;
            var _local_17:Number = (this.nearDistance * _arg_1.shadowsDistanceMultiplier);
            var _local_18:Number = (this.farDistance * _arg_1.shadowsDistanceMultiplier);
            var _local_19:Number = (1 - ((this.minZ - _local_17) / (_local_18 - _local_17)));
            if (_local_19 < 0)
            {
                _local_19 = 0;
            };
            if (_local_19 > 1)
            {
                _local_19 = 1;
            };
            this.colorConst[0] = 0;
            this.colorConst[1] = 0x0100;
            this.colorConst[2] = 1;
            this.colorConst[3] = (this.attenuation / _local_4);
            this.colorConst[4] = 0;
            this.colorConst[5] = (this.backFadeRange / _local_4);
            this.colorConst[6] = (this.offset / _local_4);
            this.colorConst[7] = 1;
            this.colorConst[8] = (((this.color >> 16) & 0xFF) / 0xFF);
            this.colorConst[9] = (((this.color >> 8) & 0xFF) / 0xFF);
            this.colorConst[10] = ((this.color & 0xFF) / 0xFF);
            this.colorConst[11] = ((this.alpha * _local_19) * _arg_1.shadowsStrength);
            _local_2.setProgram(this.getReceiverProgram(_arg_1.view.quality, this.cameraInside, _arg_1.view.correction));
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, _arg_1.transform, 3);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, _arg_1.projection, 1);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 15, this.transformConst, 3);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 18, _arg_1.correction, 1);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 19, this.uvConst, 2);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, this.colorConst, 3);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 16, this.clampConst, 1);
            var _local_20:int;
            while (_local_20 < this.receiversCount)
            {
                _local_21 = this.receiversBuffers[_local_20];
                _local_2.setVertexBufferAt(0, _arg_1.receiversVertexBuffers[_local_21], 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_2.drawTriangles(_arg_1.receiversIndexBuffers[_local_21], this.receiversFirstIndexes[_local_20], this.receiversNumsTriangles[_local_20]);
                _arg_1.numShadows++;
                _local_20++;
            };
            this.receiversCount = 0;
        }

        private function getVolumeProgram():ProgramResource
        {
            var _local_2:ByteArray;
            var _local_3:FragmentShader;
            var _local_1:ProgramResource = volumeProgram;
            if (_local_1 == null)
            {
                _local_2 = new ShadowVolumeVertexShader().agalcode;
                _local_3 = new FragmentShader();
                _local_3.mov(FragmentShader.oc, FragmentShader.fc[13]);
                _local_1 = new ProgramResource(_local_2, _local_3.agalcode);
                volumeProgram = _local_1;
            };
            return (_local_1);
        }

        private function getReceiverProgram(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean):ProgramResource
        {
            var _local_6:ByteArray;
            var _local_7:ByteArray;
            var _local_4:int = ((int(_arg_1) | (int(_arg_2) << 1)) | (int(_arg_3) << 2));
            var _local_5:ProgramResource = receiverPrograms[_local_4];
            if (_local_5 == null)
            {
                _local_6 = new ShadowReceiverVertexShader(_arg_3).agalcode;
                _local_7 = new ShadowReceiverFragmentShader(_arg_1, _arg_2).agalcode;
                _local_5 = new ProgramResource(_local_6, _local_7);
                receiverPrograms[_local_4] = _local_5;
            };
            return (_local_5);
        }

        private function cullingInCamera(_arg_1:Camera3D):Boolean
        {
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_2:Vertex = this.boundVertexList;
            _local_2.x = this.light.boundMinX;
            _local_2.y = this.light.boundMinY;
            _local_2.z = this.light.boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMaxX;
            _local_2.y = this.light.boundMinY;
            _local_2.z = this.light.boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMinX;
            _local_2.y = this.light.boundMaxY;
            _local_2.z = this.light.boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMaxX;
            _local_2.y = this.light.boundMaxY;
            _local_2.z = this.light.boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMinX;
            _local_2.y = this.light.boundMinY;
            _local_2.z = this.light.boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMaxX;
            _local_2.y = this.light.boundMinY;
            _local_2.z = this.light.boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMinX;
            _local_2.y = this.light.boundMaxY;
            _local_2.z = this.light.boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = this.light.boundMaxX;
            _local_2.y = this.light.boundMaxY;
            _local_2.z = this.light.boundMaxZ;
            this.minZ = 1E22;
            _local_2 = this.boundVertexList;
            while (_local_2 != null)
            {
                _local_2.cameraX = ((((this.light.ma * _local_2.x) + (this.light.mb * _local_2.y)) + (this.light.mc * _local_2.z)) + this.light.md);
                _local_2.cameraY = ((((this.light.me * _local_2.x) + (this.light.mf * _local_2.y)) + (this.light.mg * _local_2.z)) + this.light.mh);
                _local_2.cameraZ = ((((this.light.mi * _local_2.x) + (this.light.mj * _local_2.y)) + (this.light.mk * _local_2.z)) + this.light.ml);
                if (_local_2.cameraZ < this.minZ)
                {
                    this.minZ = _local_2.cameraZ;
                };
                _local_2 = _local_2.next;
            };
            var _local_5:Number = _arg_1.nearClipping;
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (_local_2.cameraZ > _local_5)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            var _local_6:Number = _arg_1.farClipping;
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (_local_2.cameraZ < _local_6)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (-(_local_2.cameraX) < _local_2.cameraZ)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (_local_2.cameraX < _local_2.cameraZ)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (-(_local_2.cameraY) < _local_2.cameraZ)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            _local_2 = this.boundVertexList;
            _local_3 = false;
            _local_4 = false;
            while (_local_2 != null)
            {
                if (_local_2.cameraY < _local_2.cameraZ)
                {
                    _local_3 = true;
                    if (_local_4) break;
                }
                else
                {
                    _local_4 = true;
                    if (_local_3) break;
                };
                _local_2 = _local_2.next;
            };
            if (((_local_4) && (!(_local_3))))
            {
                return (false);
            };
            return (true);
        }


    }
}//package alternativa.engine3d.core