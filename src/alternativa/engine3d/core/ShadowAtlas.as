package alternativa.engine3d.core
{
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import __AS3__.vec.Vector;
    import alternativa.gfx.core.RenderTargetTextureResource;
    import alternativa.gfx.core.Device;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.Context3DProgramType;
    import flash.utils.ByteArray;
    import alternativa.gfx.core.ProgramResource;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class ShadowAtlas 
    {

        alternativa3d static const sizeLimit:int = 0x0400;
        private static var blurPrograms:Array = new Array();
        private static var blurVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([-1, 1, 0, 0, 0, -1, -1, 0, 0, 1, 1, -1, 0, 1, 1, 1, 1, 0, 1, 0]), 5);
        private static var blurIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0, 1, 3, 2, 3, 1]));
        private static var blurConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);

        alternativa3d var shadows:Vector.<Shadow> = new Vector.<Shadow>();
        alternativa3d var shadowsCount:int = 0;
        private var mapSize:int;
        private var blur:int;
        private var maps:Array = new Array();
        private var map1:RenderTargetTextureResource;
        private var map2:RenderTargetTextureResource;

        public function ShadowAtlas(_arg_1:int, _arg_2:int)
        {
            this.mapSize = _arg_1;
            this.blur = _arg_2;
        }

        alternativa3d function renderCasters(_arg_1:Camera3D):void
        {
            var _local_9:Shadow;
            var _local_2:Device = _arg_1.device;
            var _local_3:int = int((sizeLimit / this.mapSize));
            var _local_4:int = int(Math.ceil((this.shadowsCount / _local_3)));
            var _local_5:int = ((this.shadowsCount > _local_3) ? _local_3 : this.shadowsCount);
            _local_4 = int((1 << Math.ceil((Math.log(_local_4) / Math.LN2))));
            _local_5 = int((1 << Math.ceil((Math.log(_local_5) / Math.LN2))));
            if (_local_4 > _local_3)
            {
                _local_4 = _local_3;
                this.shadowsCount = (_local_4 * _local_5);
            };
            var _local_6:int = ((_local_4 << 8) | _local_5);
            this.map1 = this.maps[_local_6];
            var _local_7:int = ((1 << 16) | _local_6);
            this.map2 = this.maps[_local_7];
            if (this.map1 == null)
            {
                this.map1 = new RenderTargetTextureResource((_local_5 * this.mapSize), (_local_4 * this.mapSize));
                this.map2 = new RenderTargetTextureResource((_local_5 * this.mapSize), (_local_4 * this.mapSize));
                this.maps[_local_6] = this.map1;
                this.maps[_local_7] = this.map2;
            };
            _local_2.setRenderToTexture(this.map1, true);
            _local_2.clear(0, 0, 0, 0, 0);
            var _local_8:int;
            while (_local_8 < this.shadowsCount)
            {
                _local_9 = this.shadows[_local_8];
                _local_9.texture = this.map1;
                _local_9.textureScaleU = (1 / _local_5);
                _local_9.textureScaleV = (1 / _local_4);
                _local_9.textureOffsetU = ((_local_8 % _local_5) / _local_5);
                _local_9.textureOffsetV = (int((_local_8 / _local_5)) / _local_4);
                _local_9.renderCasters(_arg_1);
                _local_8++;
            };
        }

        alternativa3d function renderBlur(_arg_1:Camera3D):void
        {
            var _local_2:Device = _arg_1.device;
            if (this.blur > 0)
            {
                _local_2.setVertexBufferAt(0, blurVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
                _local_2.setVertexBufferAt(1, blurVertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
                blurConst[0] = (1 / this.map1.width);
                blurConst[1] = (1 / this.map1.height);
                blurConst[3] = ((1 + this.blur) + this.blur);
                blurConst[4] = (this.blur / this.map1.width);
                blurConst[5] = (this.blur / this.map1.height);
                _local_2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, blurConst, 2);
                _local_2.setRenderToTexture(this.map2, false);
                _local_2.clear(0, 0, 0, 0);
                _local_2.setProgram(this.getBlurProgram(1, this.blur));
                _local_2.setTextureAt(0, this.map1);
                _local_2.drawTriangles(blurIndexBuffer, 0, 2);
                _local_2.setRenderToTexture(this.map1, false);
                _local_2.clear(0, 0, 0, 0);
                _local_2.setProgram(this.getBlurProgram(2, this.blur));
                _local_2.setTextureAt(0, this.map2);
                _local_2.drawTriangles(blurIndexBuffer, 0, 2);
            };
        }

        alternativa3d function clear():void
        {
            var _local_2:Shadow;
            var _local_1:int;
            while (_local_1 < this.shadowsCount)
            {
                _local_2 = this.shadows[_local_1];
                _local_2.texture = null;
                _local_1++;
            };
            this.shadows.length = 0;
            this.shadowsCount = 0;
        }

        private function getBlurProgram(_arg_1:int, _arg_2:int):ProgramResource
        {
            var _local_5:ByteArray;
            var _local_6:ByteArray;
            var _local_3:int = ((_arg_1 << 16) + _arg_2);
            var _local_4:ProgramResource = blurPrograms[_local_3];
            if (_local_4 == null)
            {
                _local_5 = new ShadowAtlasVertexShader().agalcode;
                _local_6 = new ShadowAtlasFragmentShader(_arg_2, (_arg_1 == 1)).agalcode;
                _local_4 = new ProgramResource(_local_5, _local_6);
                blurPrograms[_local_3] = _local_4;
            };
            return (_local_4);
        }


    }
}//package alternativa.engine3d.core