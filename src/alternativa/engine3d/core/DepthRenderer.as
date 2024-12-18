package alternativa.engine3d.core{
    import __AS3__.vec.Vector;
    import alternativa.gfx.core.ProgramResource;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.gfx.core.RenderTargetTextureResource;
    import flash.geom.Rectangle;
    import alternativa.gfx.core.BitmapTextureResource;
    import flash.display.BitmapData;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.objects.BSP;
    import alternativa.engine3d.lights.OmniLight;
    import alternativa.engine3d.lights.SpotLight;
    import alternativa.engine3d.lights.TubeLight;
    import alternativa.gfx.core.Device;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.Context3DBlendFactor;
    import flash.utils.ByteArray;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class DepthRenderer {

        private static const limit2const:int = 62;
        private static const limit5const:int = 24;

        private var depthPrograms:Array = new Array();
        private var correction:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0.5]);
        private var depthFragment:Vector.<Number> = Vector.<Number>([(1 / 0xFF), 0, 0, 1, 0.5, 0.5, 0, 1]);
        private var alphaTestConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var ssaoProgram:ProgramResource;
        private var ssaoVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([-1, 1, 0, 0, 0, -1, -1, 0, 0, 1, 1, -1, 0, 1, 1, 1, 1, 0, 1, 0]), 5);
        private var ssaoIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0, 1, 3, 2, 3, 1]));
        private var ssaoVertex:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1]);
        private var ssaoFragment:Vector.<Number> = Vector.<Number>([0, 0, 0, (Math.PI * 2), 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, (Math.PI * 2), (Math.PI * 2)]);
        private var blurProgram:ProgramResource;
        private var blurFragment:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);
        private var omniProgram:ProgramResource;
        private var spotProgram:ProgramResource;
        private var tubeProgram:ProgramResource;
        private var lightConst:Vector.<Number> = new Vector.<Number>();
        private var lightVertexBuffer:VertexBufferResource;
        private var lightIndexBuffer:IndexBufferResource;
        alternativa3d var depthBuffer:RenderTargetTextureResource;
        alternativa3d var lightBuffer:RenderTargetTextureResource;
        private var temporaryBuffer:RenderTargetTextureResource;
        private var scissor:Rectangle = new Rectangle();
        private var table:BitmapTextureResource;
        private var noise:BitmapTextureResource;
        private var bias:Number = 0.1;
        private var tableSize:int = 128;
        private var noiseSize:int = 4;
        private var blurSamples:int = 16;
        private var intensity:Number = 2.5;
        private var noiseRandom:Number = 0.2;
        private var samples:int = 6;
        private var noiseAngle:Number = ((Math.PI * 2) / samples);
        alternativa3d var correctionX:Number;
        alternativa3d var correctionY:Number;

        public function DepthRenderer(){
            var _local_1:int;
            var _local_2:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            super();
            var _local_3:int;
            var _local_4:int;
            var _local_5:Vector.<Number> = new Vector.<Number>();
            var _local_6:Vector.<uint> = new Vector.<uint>();
            _local_1 = 0;
            while (_local_1 < limit2const)
            {
                _local_11 = (4 + (_local_1 * 2));
                _local_12 = (4 + (_local_1 * 5));
                _local_13 = (_local_1 * 8);
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_14 = (_local_13 + 1);
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_15 = (_local_14 + 1);
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_16 = (_local_15 + 1);
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_17 = (_local_16 + 1);
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_18 = (_local_17 + 1);
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_19 = (_local_18 + 1);
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_20 = (_local_19 + 1);
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = -1;
                _local_3++;
                _local_5[_local_3] = 1;
                _local_3++;
                _local_5[_local_3] = _local_11;
                _local_3++;
                _local_5[_local_3] = _local_12;
                _local_3++;
                _local_6[_local_4] = _local_13;
                _local_4++;
                _local_6[_local_4] = _local_17;
                _local_4++;
                _local_6[_local_4] = _local_14;
                _local_4++;
                _local_6[_local_4] = _local_14;
                _local_4++;
                _local_6[_local_4] = _local_17;
                _local_4++;
                _local_6[_local_4] = _local_18;
                _local_4++;
                _local_6[_local_4] = _local_14;
                _local_4++;
                _local_6[_local_4] = _local_18;
                _local_4++;
                _local_6[_local_4] = _local_19;
                _local_4++;
                _local_6[_local_4] = _local_14;
                _local_4++;
                _local_6[_local_4] = _local_19;
                _local_4++;
                _local_6[_local_4] = _local_15;
                _local_4++;
                _local_6[_local_4] = _local_17;
                _local_4++;
                _local_6[_local_4] = _local_19;
                _local_4++;
                _local_6[_local_4] = _local_18;
                _local_4++;
                _local_6[_local_4] = _local_17;
                _local_4++;
                _local_6[_local_4] = _local_20;
                _local_4++;
                _local_6[_local_4] = _local_19;
                _local_4++;
                _local_6[_local_4] = _local_15;
                _local_4++;
                _local_6[_local_4] = _local_19;
                _local_4++;
                _local_6[_local_4] = _local_20;
                _local_4++;
                _local_6[_local_4] = _local_15;
                _local_4++;
                _local_6[_local_4] = _local_20;
                _local_4++;
                _local_6[_local_4] = _local_16;
                _local_4++;
                _local_6[_local_4] = _local_13;
                _local_4++;
                _local_6[_local_4] = _local_16;
                _local_4++;
                _local_6[_local_4] = _local_20;
                _local_4++;
                _local_6[_local_4] = _local_13;
                _local_4++;
                _local_6[_local_4] = _local_20;
                _local_4++;
                _local_6[_local_4] = _local_17;
                _local_4++;
                _local_6[_local_4] = _local_13;
                _local_4++;
                _local_6[_local_4] = _local_14;
                _local_4++;
                _local_6[_local_4] = _local_15;
                _local_4++;
                _local_6[_local_4] = _local_13;
                _local_4++;
                _local_6[_local_4] = _local_15;
                _local_4++;
                _local_6[_local_4] = _local_16;
                _local_4++;
                _local_1++;
            };
            this.lightVertexBuffer = new VertexBufferResource(_local_5, 5);
            this.lightIndexBuffer = new IndexBufferResource(_local_6);
            var _local_7:Vector.<uint> = new Vector.<uint>();
            var _local_8:int;
            var _local_9:Number = (Math.PI * 2);
            var _local_10:int = (this.tableSize - 1);
            _local_1 = 0;
            while (_local_1 < this.tableSize)
            {
                _local_21 = (((_local_1 / _local_10) - 0.5) * 2);
                _local_2 = 0;
                while (_local_2 < this.tableSize)
                {
                    _local_22 = (((_local_2 / _local_10) - 0.5) * 2);
                    _local_23 = Math.atan2(_local_21, _local_22);
                    if (_local_23 < 0)
                    {
                        _local_23 = (_local_23 + _local_9);
                    };
                    _local_7[_local_8] = Math.round(((0xFF * _local_23) / _local_9));
                    _local_8++;
                    _local_2++;
                };
                _local_1++;
            };
            this.table = new BitmapTextureResource(new BitmapData(this.tableSize, this.tableSize, false, 0), false);
            this.table.bitmapData.setVector(this.table.bitmapData.rect, _local_7);
            _local_7 = new Vector.<uint>();
            _local_8 = 0;
            _local_1 = 0;
            while (_local_1 < this.noiseSize)
            {
                _local_2 = 0;
                while (_local_2 < this.noiseSize)
                {
                    _local_24 = (Math.random() * this.noiseAngle);
                    _local_25 = (Math.sin(_local_24) * 0xFF);
                    _local_26 = (Math.cos(_local_24) * 0xFF);
                    _local_27 = ((this.noiseRandom + (Math.random() * (1 - this.noiseRandom))) * 0xFF);
                    _local_7[_local_8] = (((_local_25 << 16) | (_local_26 << 8)) | _local_27);
                    _local_8++;
                    _local_2++;
                };
                _local_1++;
            };
            this.noise = new BitmapTextureResource(new BitmapData(this.noiseSize, this.noiseSize, false, 0), false);
            this.noise.bitmapData.setVector(this.noise.bitmapData.rect, _local_7);
            this.depthBuffer = new RenderTargetTextureResource(1, 1);
            this.temporaryBuffer = new RenderTargetTextureResource(1, 1);
            this.lightBuffer = new RenderTargetTextureResource(1, 1);
        }

        alternativa3d function render(_arg_1:Camera3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Number, _arg_8:Vector.<Object3D>, _arg_9:int):void{
            var _local_10:int;
            var _local_14:Object3D;
            var _local_15:VertexBufferResource;
            var _local_16:IndexBufferResource;
            var _local_17:int;
            var _local_18:TextureMaterial;
            var _local_19:Mesh;
            var _local_20:BSP;
            var _local_21:int;
            var _local_22:int;
            var _local_23:OmniLight;
            var _local_24:SpotLight;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:TubeLight;
            var _local_11:Device = _arg_1.device;
            if (_arg_2 > 0x0800)
            {
                _arg_2 = 0x0800;
            };
            if (_arg_3 > 0x0800)
            {
                _arg_3 = 0x0800;
            };
            if (_arg_4 > 1)
            {
                _arg_4 = 1;
            };
            _arg_2 = Math.round((_arg_2 * _arg_4));
            _arg_3 = Math.round((_arg_3 * _arg_4));
            if (_arg_2 < 1)
            {
                _arg_2 = 1;
            };
            if (_arg_3 < 1)
            {
                _arg_3 = 1;
            };
            this.scissor.width = _arg_2;
            this.scissor.height = _arg_3;
            var _local_12:int = int((1 << Math.ceil((Math.log(_arg_2) / Math.LN2))));
            var _local_13:int = int((1 << Math.ceil((Math.log(_arg_3) / Math.LN2))));
            if (((!(_local_12 == this.depthBuffer.width)) || (!(_local_13 == this.depthBuffer.height))))
            {
                this.depthBuffer.dispose();
                this.depthBuffer = new RenderTargetTextureResource(_local_12, _local_13);
                this.temporaryBuffer.dispose();
                this.temporaryBuffer = new RenderTargetTextureResource(_local_12, _local_13);
                this.lightBuffer.dispose();
                this.lightBuffer = new RenderTargetTextureResource(_local_12, _local_13);
            };
            if ((!(_arg_5)))
            {
                this.noise.reset();
                this.temporaryBuffer.reset();
                this.ssaoVertexBuffer.reset();
                this.ssaoIndexBuffer.reset();
            };
            if ((!(_arg_6)))
            {
                this.lightBuffer.reset();
                this.lightVertexBuffer.reset();
                this.lightIndexBuffer.reset();
            };
            if (((!(_arg_5)) && (!(_arg_6))))
            {
                this.table.reset();
            };
            this.correctionX = (_arg_2 / this.depthBuffer.width);
            this.correctionY = (_arg_3 / this.depthBuffer.height);
            _local_11.setRenderToTexture(this.depthBuffer, true);
            _local_11.clear(1, 0, 0.25, 1);
            _local_11.setScissorRectangle(this.scissor);
            this.correction[0] = this.correctionX;
            this.correction[1] = this.correctionY;
            this.correction[2] = (0xFF / _arg_1.farClipping);
            this.correction[4] = (1 - this.correctionX);
            this.correction[5] = (1 - this.correctionY);
            this.correction[8] = _arg_1.correctionX;
            this.correction[9] = _arg_1.correctionY;
            _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 3, _arg_1.projection, 1, false);
            _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.correction, 3, false);
            if (((_arg_5) || (_arg_6)))
            {
                _local_11.setTextureAt(0, this.table);
            };
            _local_10 = 0;
            while (_local_10 < _arg_9)
            {
                _local_14 = _arg_8[_local_10];
                if ((_local_14 is Mesh))
                {
                    _local_19 = Mesh(_local_14);
                    _local_15 = _local_19.vertexBuffer;
                    _local_16 = _local_19.indexBuffer;
                    _local_17 = _local_19.numTriangles;
                    _local_18 = (_local_19.faceList.material as TextureMaterial);
                }
                else
                {
                    if ((_local_14 is BSP))
                    {
                        _local_20 = BSP(_local_14);
                        _local_15 = _local_20.vertexBuffer;
                        _local_16 = _local_20.indexBuffer;
                        _local_17 = _local_20.numTriangles;
                        _local_18 = (_local_20.faces[0].material as TextureMaterial);
                    };
                };
                if ((((!(_local_18 == null)) && (_local_18.alphaTestThreshold > 0)) && (_local_18.transparent)))
                {
                    _local_11.setProgram(this.getDepthProgram(((_arg_5) || (_arg_6)), true, _arg_1.view.quality, _local_18.repeat, (_local_18._mipMapping > 0), false, false));
                    _local_11.setVertexBufferAt(2, _local_15, 3, Context3DVertexBufferFormat.FLOAT_2);
                    _local_11.setTextureAt(1, _local_18.textureResource);
                    this.alphaTestConst[0] = _local_18.textureResource.correctionU;
                    this.alphaTestConst[1] = _local_18.textureResource.correctionV;
                    this.alphaTestConst[3] = _local_18.alphaTestThreshold;
                    _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this.alphaTestConst, 1);
                }
                else
                {
                    _local_11.setProgram(this.getDepthProgram(((_arg_5) || (_arg_6)), false));
                };
                _local_11.setVertexBufferAt(0, _local_15, 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, _local_14.transformConst, 3, false);
                _local_11.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.depthFragment, 2);
                if (((_arg_5) || (_arg_6)))
                {
                    _local_11.setVertexBufferAt(1, _local_15, 5, Context3DVertexBufferFormat.FLOAT_3);
                };
                _local_11.drawTriangles(_local_16, 0, _local_17);
                _local_11.setTextureAt(1, null);
                _local_11.setVertexBufferAt(2, null);
                _local_10++;
            };
            if (_arg_6)
            {
                _local_11.setRenderToTexture(this.lightBuffer, false);
                _local_11.clear(_arg_7, _arg_7, _arg_7, 0);
                _local_11.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
                _local_11.setTextureAt(0, this.depthBuffer);
                _local_11.setVertexBufferAt(0, this.lightVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_11.setVertexBufferAt(1, this.lightVertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
                _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, _arg_1.projection, 1, false);
                _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 1, this.correction, 3, false);
                this.ssaoFragment[0] = _arg_1.farClipping;
                this.ssaoFragment[1] = (_arg_1.farClipping / 0xFF);
                this.ssaoFragment[4] = (2 / this.correctionX);
                this.ssaoFragment[5] = (2 / this.correctionY);
                this.ssaoFragment[6] = 0;
                this.ssaoFragment[8] = 1;
                this.ssaoFragment[9] = 1;
                this.ssaoFragment[10] = 0.5;
                this.ssaoFragment[12] = _arg_1.correctionX;
                this.ssaoFragment[13] = _arg_1.correctionY;
                this.ssaoFragment[16] = 0.5;
                this.ssaoFragment[17] = 0.5;
                _local_11.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.ssaoFragment, 7, false);
                _local_11.setProgram(this.getOmniProgram());
                _local_21 = 0;
                _local_22 = 0;
                _local_10 = 0;
                while (_local_10 < _arg_1.omniesCount)
                {
                    _local_23 = _arg_1.omnies[_local_10];
                    this.lightConst[_local_21] = (_local_23.cmd * _arg_1.correctionX);
                    _local_21++;
                    this.lightConst[_local_21] = (_local_23.cmh * _arg_1.correctionY);
                    _local_21++;
                    this.lightConst[_local_21] = _local_23.cml;
                    _local_21++;
                    this.lightConst[_local_21] = _local_23.attenuationEnd;
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_23.intensity * _arg_1.deferredLightingStrength) * ((_local_23.color >> 16) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_23.intensity * _arg_1.deferredLightingStrength) * ((_local_23.color >> 8) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_23.intensity * _arg_1.deferredLightingStrength) * (_local_23.color & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (1 / (_local_23.attenuationEnd - _local_23.attenuationBegin));
                    _local_21++;
                    _local_22++;
                    if (((_local_22 == limit2const) || (_local_10 == (_arg_1.omniesCount - 1))))
                    {
                        _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.lightConst, (_local_22 * 2), false);
                        _local_11.drawTriangles(this.lightIndexBuffer, 0, ((_local_22 * 6) * 2));
                        _local_22 = 0;
                        _local_21 = 0;
                    };
                    _local_10++;
                };
                _local_11.setProgram(this.getSpotProgram());
                _local_21 = 0;
                _local_22 = 0;
                _local_10 = 0;
                while (_local_10 < _arg_1.spotsCount)
                {
                    _local_24 = _arg_1.spots[_local_10];
                    _local_25 = Math.cos((_local_24.hotspot * 0.5));
                    _local_26 = Math.cos((_local_24.falloff * 0.5));
                    this.lightConst[_local_21] = _local_24.cma;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmb;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmc;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmd;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cme;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmf;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmg;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmh;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmi;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmj;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cmk;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.cml;
                    _local_21++;
                    this.lightConst[_local_21] = _local_24.attenuationEnd;
                    _local_21++;
                    this.lightConst[_local_21] = (1 / (_local_24.attenuationEnd - _local_24.attenuationBegin));
                    _local_21++;
                    this.lightConst[_local_21] = _local_26;
                    _local_21++;
                    this.lightConst[_local_21] = (1 / (_local_25 - _local_26));
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_24.intensity * _arg_1.deferredLightingStrength) * ((_local_24.color >> 16) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_24.intensity * _arg_1.deferredLightingStrength) * ((_local_24.color >> 8) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_24.intensity * _arg_1.deferredLightingStrength) * (_local_24.color & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (Math.sin((_local_24.falloff * 0.5)) * _local_24.attenuationEnd);
                    _local_21++;
                    _local_22++;
                    if (((_local_22 == limit5const) || (_local_10 == (_arg_1.spotsCount - 1))))
                    {
                        _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.lightConst, (_local_22 * 5), false);
                        _local_11.drawTriangles(this.lightIndexBuffer, 0, ((_local_22 * 6) * 2));
                        _local_22 = 0;
                        _local_21 = 0;
                    };
                    _local_10++;
                };
                _local_11.setProgram(this.getTubeProgram());
                _local_21 = 0;
                _local_22 = 0;
                _local_10 = 0;
                while (_local_10 < _arg_1.tubesCount)
                {
                    _local_27 = _arg_1.tubes[_local_10];
                    this.lightConst[_local_21] = _local_27.cma;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmb;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmc;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmd;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cme;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmf;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmg;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmh;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmi;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmj;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cmk;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.cml;
                    _local_21++;
                    this.lightConst[_local_21] = _local_27.attenuationEnd;
                    _local_21++;
                    this.lightConst[_local_21] = (1 / (_local_27.attenuationEnd - _local_27.attenuationBegin));
                    _local_21++;
                    this.lightConst[_local_21] = ((_local_27.length * 0.5) + _local_27.falloff);
                    _local_21++;
                    this.lightConst[_local_21] = (1 / _local_27.falloff);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_27.intensity * _arg_1.deferredLightingStrength) * ((_local_27.color >> 16) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_27.intensity * _arg_1.deferredLightingStrength) * ((_local_27.color >> 8) & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (((_local_27.intensity * _arg_1.deferredLightingStrength) * (_local_27.color & 0xFF)) / 0xFF);
                    _local_21++;
                    this.lightConst[_local_21] = (_local_27.length * 0.5);
                    _local_21++;
                    _local_22++;
                    if (((_local_22 == limit5const) || (_local_10 == (_arg_1.tubesCount - 1))))
                    {
                        _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.lightConst, (_local_22 * 5), false);
                        _local_11.drawTriangles(this.lightIndexBuffer, 0, ((_local_22 * 6) * 2));
                        _local_22 = 0;
                        _local_21 = 0;
                    };
                    _local_10++;
                };
                _local_11.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            };
            if (_arg_5)
            {
                _local_11.setRenderToTexture(this.temporaryBuffer, false);
                _local_11.clear(0, 0, 0, 0);
                _local_11.setProgram(this.getSSAOProgram());
                _local_11.setTextureAt(0, this.depthBuffer);
                _local_11.setTextureAt(1, this.noise);
                _local_11.setVertexBufferAt(0, this.ssaoVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_11.setVertexBufferAt(1, this.ssaoVertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
                this.ssaoVertex[0] = (_local_12 / this.noiseSize);
                this.ssaoVertex[1] = (_local_13 / this.noiseSize);
                this.ssaoVertex[4] = (2 / this.correctionX);
                this.ssaoVertex[5] = (2 / this.correctionY);
                _local_11.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, this.ssaoVertex, 3, false);
                this.ssaoFragment[0] = _arg_1.farClipping;
                this.ssaoFragment[1] = (_arg_1.farClipping / 0xFF);
                this.ssaoFragment[4] = (2 / this.correctionX);
                this.ssaoFragment[5] = (2 / this.correctionY);
                this.ssaoFragment[6] = _arg_1.ssaoRadius;
                this.ssaoFragment[8] = 1;
                this.ssaoFragment[9] = 1;
                this.ssaoFragment[10] = this.bias;
                this.ssaoFragment[11] = ((this.intensity * 1) / this.samples);
                this.ssaoFragment[12] = _arg_1.correctionX;
                this.ssaoFragment[13] = _arg_1.correctionY;
                this.ssaoFragment[15] = (1 / _arg_1.ssaoRange);
                this.ssaoFragment[16] = Math.cos(this.noiseAngle);
                this.ssaoFragment[17] = Math.sin(this.noiseAngle);
                this.ssaoFragment[20] = -(Math.sin(this.noiseAngle));
                this.ssaoFragment[21] = Math.cos(this.noiseAngle);
                this.ssaoFragment[24] = (this.correctionX - (1 / _local_12));
                this.ssaoFragment[25] = (this.correctionY - (1 / _local_13));
                _local_11.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.ssaoFragment, 7, false);
                _local_11.drawTriangles(this.ssaoIndexBuffer, 0, 2);
                _local_11.setTextureAt(1, null);
                _local_11.setRenderToTexture(this.depthBuffer, false);
                _local_11.clear(0, 0, 0, 0);
                _local_11.setProgram(this.getBlurProgram());
                _local_11.setTextureAt(0, this.temporaryBuffer);
                this.blurFragment[0] = (1 / _local_12);
                this.blurFragment[1] = (1 / _local_13);
                this.blurFragment[3] = (1 / this.blurSamples);
                this.blurFragment[4] = (this.correctionX - (1 / _local_12));
                this.blurFragment[5] = (this.correctionY - (1 / _local_13));
                _local_11.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.blurFragment, 2, false);
                _local_11.drawTriangles(this.ssaoIndexBuffer, 0, 2);
            };
            _local_11.setVertexBufferAt(1, null);
            _local_11.setTextureAt(0, null);
            _local_11.setScissorRectangle(null);
        }

        alternativa3d function resetResources():void{
            this.noise.reset();
            this.table.reset();
            this.depthBuffer.reset();
            this.temporaryBuffer.reset();
            this.lightBuffer.reset();
            this.ssaoVertexBuffer.reset();
            this.ssaoIndexBuffer.reset();
            this.lightVertexBuffer.reset();
            this.lightIndexBuffer.reset();
        }

        private function getDepthProgram(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:Boolean=false):ProgramResource{
            var _local_10:ByteArray;
            var _local_11:ByteArray;
            var _local_8:int = ((((((int(_arg_1) | (int(_arg_2) << 1)) | (int(_arg_3) << 2)) | (int(_arg_4) << 3)) | (int(_arg_5) << 4)) | (int(_arg_6) << 5)) | (int(_arg_7) << 6));
            var _local_9:ProgramResource = this.depthPrograms[_local_8];
            if (_local_9 == null)
            {
                _local_10 = new DepthRendererDepthVertexShader(_arg_1, _arg_2).agalcode;
                _local_11 = new DepthRendererDepthFragmentShader(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5).agalcode;
                _local_9 = new ProgramResource(_local_10, _local_11);
                this.depthPrograms[_local_8] = _local_9;
            };
            return (_local_9);
        }

        private function getSSAOProgram():ProgramResource{
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            var _local_1:ProgramResource = this.ssaoProgram;
            if (_local_1 == null)
            {
                _local_2 = new DepthRendererSSAOVertexShader().agalcode;
                _local_3 = new DepthRendererSSAOFragmentShader(this.samples).agalcode;
                _local_1 = new ProgramResource(_local_2, _local_3);
                this.ssaoProgram = _local_1;
            };
            return (_local_1);
        }

        private function getBlurProgram():ProgramResource{
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            var _local_1:ProgramResource = this.blurProgram;
            if (_local_1 == null)
            {
                _local_2 = new DepthRendererBlurVertexShader().agalcode;
                _local_3 = new DepthRendererBlurFragmentShader().agalcode;
                _local_1 = new ProgramResource(_local_2, _local_3);
                this.blurProgram = _local_1;
            };
            return (_local_1);
        }

        private function getOmniProgram():ProgramResource{
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            var _local_1:ProgramResource = this.omniProgram;
            if (_local_1 == null)
            {
                _local_2 = new DepthRendererLightVertexShader(0).agalcode;
                _local_3 = new DepthRendererLightFragmentShader(0).agalcode;
                _local_1 = new ProgramResource(_local_2, _local_3);
                this.omniProgram = _local_1;
            };
            return (_local_1);
        }

        private function getSpotProgram():ProgramResource{
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            var _local_1:ProgramResource = this.spotProgram;
            if (_local_1 == null)
            {
                _local_2 = new DepthRendererLightVertexShader(1).agalcode;
                _local_3 = new DepthRendererLightFragmentShader(1).agalcode;
                _local_1 = new ProgramResource(_local_2, _local_3);
                this.spotProgram = _local_1;
            };
            return (_local_1);
        }

        private function getTubeProgram():ProgramResource{
            var _local_2:ByteArray;
            var _local_3:ByteArray;
            var _local_1:ProgramResource = this.tubeProgram;
            if (_local_1 == null)
            {
                _local_2 = new DepthRendererLightVertexShader(2).agalcode;
                _local_3 = new DepthRendererLightFragmentShader(2).agalcode;
                _local_1 = new ProgramResource(_local_2, _local_3);
                this.tubeProgram = _local_1;
            };
            return (_local_1);
        }


    }
}//package alternativa.engine3d.core