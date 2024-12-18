package alternativa.gfx.core{
    import flash.events.EventDispatcher;
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.geom.Rectangle;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    [Event(name="context3DCreate", type="flash.events.Event")]
    public class Device extends EventDispatcher {

        private static const RESOURCE_NOT_AVAILABLE_ERROR:String = "Resource is not available.";

        private var _stage:Stage;
        private var _renderMode:String;
        private var _profile:String;
        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;
        private var _antiAlias:int;
        private var _enableDepthAndStencil:Boolean;
        private var _enableErrorChecking:Boolean;
        private var _stage3D:Stage3D;
        private var _available:Boolean = true;
        private var _renderState:RenderState = new RenderState();
        private var configured:Boolean = false;
        private var backBufferWidth:int = -1;
        private var backBufferHeight:int = -1;
        private var backBufferAntiAlias:int = -1;
        private var backBufferEnableDepthAndStencil:Boolean = false;
        private var resourcesToUpload:Dictionary = new Dictionary();

        public function Device(_arg_1:Stage, _arg_2:String="auto", _arg_3:String="baseline"){
            this._stage = _arg_1;
            this._renderMode = _arg_2;
            this._profile = _arg_3;
            this._stage3D = this._stage.stage3Ds[0];
            this._x = this._stage3D.x;
            this._y = this._stage3D.y;
            this._width = _arg_1.stageWidth;
            this._height = _arg_1.stageHeight;
            this._antiAlias = 0;
            this._enableDepthAndStencil = true;
            this._enableErrorChecking = false;
            this._stage3D.addEventListener(Event.CONTEXT3D_CREATE, this.onContext3DCreate);
            if (this._stage3D.requestContext3D.length > 1)
            {
                this._stage3D.requestContext3D(_arg_2, _arg_3);
            } else
            {
                this._stage3D.requestContext3D(_arg_2);
            };
        }

        private function onContext3DCreate(_arg_1:Event):void{
            var _local_3:*;
            var _local_5:TextureResource;
            var _local_6:VertexBufferResource;
            this.configured = false;
            this.backBufferWidth = -1;
            this.backBufferHeight = -1;
            this.backBufferAntiAlias = -1;
            this.backBufferEnableDepthAndStencil = false;
            var _local_2:Context3D = this._stage3D.context3D;
            _local_2.enableErrorChecking = this._enableErrorChecking;
            for (_local_3 in this.resourcesToUpload)
            {
                this.uploadResource(_local_3);
                delete this.resourcesToUpload[_local_3];
            };
            _local_2.setBlendFactors(this._renderState.blendSourceFactor, this._renderState.blendDestinationFactor);
            _local_2.setColorMask(this._renderState.colorMaskRed, this._renderState.colorMaskGreen, this._renderState.colorMaskBlue, this._renderState.colorMaskAlpha);
            _local_2.setCulling(this._renderState.culling);
            _local_2.setDepthTest(this._renderState.depthTestMask, this._renderState.depthTestPassCompareMode);
            if (this._renderState.program != null)
            {
                if ((!(this._renderState.program.available)))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this.prepareResource(_local_2, this._renderState.program);
                _local_2.setProgram(this._renderState.program.program);
            };
            if (this._renderState.renderTarget != null)
            {
                if ((!(this._renderState.renderTarget.available)))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this.prepareResource(_local_2, this._renderState.renderTarget);
                _local_2.setRenderToTexture(this._renderState.renderTarget.texture, this._renderState.renderTargetEnableDepthAndStencil, this._renderState.renderTargetAntiAlias, this._renderState.renderTargetSurfaceSelector);
            };
            if (this._renderState.scissor)
            {
                _local_2.setScissorRectangle(this._renderState.scissorRectangle);
            } else
            {
                _local_2.setScissorRectangle(null);
            };
            _local_2.setStencilActions(this._renderState.stencilActionTriangleFace, this._renderState.stencilActionCompareMode, this._renderState.stencilActionOnBothPass, this._renderState.stencilActionOnDepthFail, this._renderState.stencilActionOnDepthPassStencilFail);
            _local_2.setStencilReferenceValue(this._renderState.stencilReferenceValue, this._renderState.stencilReadMask, this._renderState.stencilWriteMask);
            var _local_4:int;
            while (_local_4 < 8)
            {
                _local_5 = this._renderState.textures[_local_4];
                if (_local_5 != null)
                {
                    if ((!(_local_5.available)))
                    {
                        throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                    };
                    this.prepareResource(_local_2, _local_5);
                    _local_2.setTextureAt(_local_4, _local_5.texture);
                };
                _local_6 = this._renderState.vertexBuffers[_local_4];
                if (_local_6 != null)
                {
                    if ((!(_local_6.available)))
                    {
                        throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                    };
                    this.prepareResource(_local_2, _local_6);
                    _local_2.setVertexBufferAt(_local_4, _local_6.buffer, this._renderState.vertexBuffersOffsets[_local_4], this._renderState.vertexBuffersFormats[_local_4]);
                };
                _local_4++;
            };
            _local_2.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, this._renderState.vertexConstants, 128);
            _local_2.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._renderState.fragmentConstants, 28);
            dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
        }

        public function dispose():void{
            var _local_1:*;
            this._stage3D.removeEventListener(Event.CONTEXT3D_CREATE, this.onContext3DCreate);
            if (this._stage3D.context3D != null)
            {
                this._stage3D.context3D.dispose();
            };
            for (_local_1 in this.resourcesToUpload)
            {
                delete this.resourcesToUpload[_local_1];
            };
            this._renderState = new RenderState();
            this._available = false;
        }

        public function reset():void{
            var _local_1:*;
            if (this._stage3D.context3D != null)
            {
                this._stage3D.context3D.dispose();
            } else
            {
                for (_local_1 in this.resourcesToUpload)
                {
                    delete this.resourcesToUpload[_local_1];
                };
            };
            this._renderState = new RenderState();
        }

        public function get available():Boolean{
            return (this._available);
        }

        public function get ready():Boolean{
            return (!(this._stage3D.context3D == null));
        }

        public function get stage():Stage{
            return (this._stage);
        }

        public function get stage3DIndex():int{
            return (0);
        }

        public function get renderMode():String{
            return (this._renderMode);
        }

        public function get profile():String{
            return (this._profile);
        }

        public function get x():int{
            return (this._x);
        }

        public function set x(_arg_1:int):void{
            this._x = _arg_1;
        }

        public function get y():int{
            return (this._y);
        }

        public function set y(_arg_1:int):void{
            this._y = _arg_1;
        }

        public function get width():int{
            return (this._width);
        }

        public function set width(_arg_1:int):void{
            this._width = _arg_1;
        }

        public function get height():int{
            return (this._height);
        }

        public function set height(_arg_1:int):void{
            this._height = _arg_1;
        }

        public function get antiAlias():int{
            return (this._antiAlias);
        }

        public function set antiAlias(_arg_1:int):void{
            if (((((!(_arg_1 == 0)) && (!(_arg_1 == 2))) && (!(_arg_1 == 4))) && (!(_arg_1 == 16))))
            {
                throw (new Error("Invalid antialiasing value."));
            };
            this._antiAlias = _arg_1;
        }

        public function get enableDepthAndStencil():Boolean{
            return (this._enableDepthAndStencil);
        }

        public function set enableDepthAndStencil(_arg_1:Boolean):void{
            this._enableDepthAndStencil = _arg_1;
        }

        public function get enableErrorChecking():Boolean{
            return (this._enableErrorChecking);
        }

        public function set enableErrorChecking(_arg_1:Boolean):void{
            this._enableErrorChecking = _arg_1;
            var _local_2:Context3D = this._stage3D.context3D;
            if (((!(_local_2 == null)) && (!(_local_2.enableErrorChecking == this._enableErrorChecking))))
            {
                _local_2.enableErrorChecking = this._enableErrorChecking;
            };
        }

        public function uploadResource(_arg_1:Resource):void{
            if ((!(_arg_1.available)))
            {
                throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
            };
            var _local_2:Context3D = this._stage3D.context3D;
            if (_local_2 != null)
            {
                if ((!(_arg_1.isCreated(_local_2))))
                {
                    _arg_1.create(_local_2);
                };
                _arg_1.upload();
            } else
            {
                this.resourcesToUpload[_arg_1] = true;
            };
        }

        private function prepareResource(_arg_1:Context3D, _arg_2:Resource):void{
            if ((!(_arg_2.isCreated(_arg_1))))
            {
                _arg_2.create(_arg_1);
                _arg_2.upload();
            };
        }

        public function setBlendFactors(_arg_1:String, _arg_2:String):void{
            var _local_3:Context3D;
            if (((!(_arg_1 == this._renderState.blendSourceFactor)) || (!(_arg_2 == this._renderState.blendDestinationFactor))))
            {
                this._renderState.blendSourceFactor = _arg_1;
                this._renderState.blendDestinationFactor = _arg_2;
                _local_3 = this._stage3D.context3D;
                if (_local_3 != null)
                {
                    _local_3.setBlendFactors(_arg_1, _arg_2);
                };
            };
        }

        public function setColorMask(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean):void{
            var _local_5:Context3D;
            if (((((!(_arg_1 == this._renderState.colorMaskRed)) || (!(_arg_2 == this._renderState.colorMaskGreen))) || (!(_arg_3 == this._renderState.colorMaskBlue))) || (!(_arg_4 == this._renderState.colorMaskAlpha))))
            {
                this._renderState.colorMaskRed = _arg_1;
                this._renderState.colorMaskGreen = _arg_2;
                this._renderState.colorMaskBlue = _arg_3;
                this._renderState.colorMaskAlpha = _arg_4;
                _local_5 = this._stage3D.context3D;
                if (_local_5 != null)
                {
                    _local_5.setColorMask(_arg_1, _arg_2, _arg_3, _arg_4);
                };
            };
        }

        public function setCulling(_arg_1:String):void{
            var _local_2:Context3D;
            if (_arg_1 != this._renderState.culling)
            {
                this._renderState.culling = _arg_1;
                _local_2 = this._stage3D.context3D;
                if (_local_2 != null)
                {
                    _local_2.setCulling(_arg_1);
                };
            };
        }

        public function setDepthTest(_arg_1:Boolean, _arg_2:String):void{
            var _local_3:Context3D;
            if (((!(_arg_1 == this._renderState.depthTestMask)) || (!(_arg_2 == this._renderState.depthTestPassCompareMode))))
            {
                this._renderState.depthTestMask = _arg_1;
                this._renderState.depthTestPassCompareMode = _arg_2;
                _local_3 = this._stage3D.context3D;
                if (_local_3 != null)
                {
                    _local_3.setDepthTest(_arg_1, _arg_2);
                };
            };
        }

        public function setProgram(_arg_1:ProgramResource):void{
            var _local_2:Context3D;
            if (_arg_1 != this._renderState.program)
            {
                if ((!(_arg_1.available)))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this._renderState.program = _arg_1;
                _local_2 = this._stage3D.context3D;
                if (_local_2 != null)
                {
                    this.prepareResource(_local_2, _arg_1);
                    _local_2.setProgram(_arg_1.program);
                };
            };
        }

        public function setRenderToBackBuffer():void{
            var _local_1:Context3D;
            if (this._renderState.renderTarget != null)
            {
                this._renderState.renderTarget = null;
                _local_1 = this._stage3D.context3D;
                if (_local_1 != null)
                {
                    _local_1.setRenderToBackBuffer();
                };
            };
        }

        public function setRenderToTexture(_arg_1:TextureResource, _arg_2:Boolean=false, _arg_3:int=0, _arg_4:int=0):void{
            var _local_5:Context3D;
            if (((((!(_arg_1 == this._renderState.renderTarget)) || (!(_arg_2 == this._renderState.renderTargetEnableDepthAndStencil))) || (!(_arg_3 == this._renderState.renderTargetAntiAlias))) || (!(_arg_4 == this._renderState.renderTargetSurfaceSelector))))
            {
                if (((!(_arg_1 == null)) && (!(_arg_1.available))))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this._renderState.renderTarget = _arg_1;
                this._renderState.renderTargetEnableDepthAndStencil = _arg_2;
                this._renderState.renderTargetAntiAlias = _arg_3;
                this._renderState.renderTargetSurfaceSelector = _arg_4;
                _local_5 = this._stage3D.context3D;
                if (_local_5 != null)
                {
                    if (_arg_1 != null)
                    {
                        this.prepareResource(_local_5, _arg_1);
                        _local_5.setRenderToTexture(_arg_1.texture, _arg_2, _arg_3, _arg_4);
                    } else
                    {
                        _local_5.setRenderToBackBuffer();
                    };
                };
            };
        }

        public function setScissorRectangle(_arg_1:Rectangle):void{
            var _local_2:Context3D = this._stage3D.context3D;
            if (_arg_1 != null)
            {
                if (this._renderState.scissor)
                {
                    if (((((!(_arg_1.x == this._renderState.scissorRectangle.x)) || (!(_arg_1.y == this._renderState.scissorRectangle.y))) || (!(_arg_1.width == this._renderState.scissorRectangle.width))) || (!(_arg_1.height == this._renderState.scissorRectangle.height))))
                    {
                        this._renderState.scissorRectangle.x = _arg_1.x;
                        this._renderState.scissorRectangle.y = _arg_1.y;
                        this._renderState.scissorRectangle.width = _arg_1.width;
                        this._renderState.scissorRectangle.height = _arg_1.height;
                        if (_local_2 != null)
                        {
                            _local_2.setScissorRectangle(_arg_1);
                        };
                    };
                } else
                {
                    this._renderState.scissor = true;
                    this._renderState.scissorRectangle.x = _arg_1.x;
                    this._renderState.scissorRectangle.y = _arg_1.y;
                    this._renderState.scissorRectangle.width = _arg_1.width;
                    this._renderState.scissorRectangle.height = _arg_1.height;
                    if (_local_2 != null)
                    {
                        _local_2.setScissorRectangle(_arg_1);
                    };
                };
            } else
            {
                this._renderState.scissor = false;
                if (_local_2 != null)
                {
                    _local_2.setScissorRectangle(null);
                };
            };
        }

        public function setStencilActions(_arg_1:String="frontAndBack", _arg_2:String="always", _arg_3:String="keep", _arg_4:String="keep", _arg_5:String="keep"):void{
            var _local_6:Context3D;
            if ((((((!(_arg_1 == this._renderState.stencilActionTriangleFace)) || (!(_arg_2 == this._renderState.stencilActionCompareMode))) || (!(_arg_3 == this._renderState.stencilActionOnBothPass))) || (!(_arg_4 == this._renderState.stencilActionOnDepthFail))) || (!(_arg_5 == this._renderState.stencilActionOnDepthPassStencilFail))))
            {
                this._renderState.stencilActionTriangleFace = _arg_1;
                this._renderState.stencilActionCompareMode = _arg_2;
                this._renderState.stencilActionOnBothPass = _arg_3;
                this._renderState.stencilActionOnDepthFail = _arg_4;
                this._renderState.stencilActionOnDepthPassStencilFail = _arg_5;
                _local_6 = this._stage3D.context3D;
                if (_local_6 != null)
                {
                    _local_6.setStencilActions(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
                };
            };
        }

        public function setStencilReferenceValue(_arg_1:uint, _arg_2:uint=0xFF, _arg_3:uint=0xFF):void{
            var _local_4:Context3D;
            if ((((!(_arg_1 == this._renderState.stencilReferenceValue)) || (!(_arg_2 == this._renderState.stencilReadMask))) || (!(_arg_3 == this._renderState.stencilWriteMask))))
            {
                this._renderState.stencilReferenceValue = _arg_1;
                this._renderState.stencilReadMask = _arg_2;
                this._renderState.stencilWriteMask = _arg_3;
                _local_4 = this._stage3D.context3D;
                if (_local_4 != null)
                {
                    _local_4.setStencilReferenceValue(_arg_1, _arg_2, _arg_3);
                };
            };
        }

        public function setTextureAt(_arg_1:int, _arg_2:TextureResource):void{
            var _local_3:Context3D;
            if (_arg_2 != this._renderState.textures[_arg_1])
            {
                if (((!(_arg_2 == null)) && (!(_arg_2.available))))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this._renderState.textures[_arg_1] = _arg_2;
                _local_3 = this._stage3D.context3D;
                if (_local_3 != null)
                {
                    if (_arg_2 != null)
                    {
                        this.prepareResource(_local_3, _arg_2);
                        _local_3.setTextureAt(_arg_1, _arg_2.texture);
                    } else
                    {
                        _local_3.setTextureAt(_arg_1, null);
                    };
                };
            };
        }

        public function setVertexBufferAt(_arg_1:int, _arg_2:VertexBufferResource, _arg_3:int=0, _arg_4:String="float4"):void{
            var _local_5:Context3D;
            if ((((!(_arg_2 == this._renderState.vertexBuffers[_arg_1])) || (!(_arg_3 == this._renderState.vertexBuffersOffsets[_arg_1]))) || (!(_arg_4 == this._renderState.vertexBuffersFormats[_arg_1]))))
            {
                if (((!(_arg_2 == null)) && (!(_arg_2.available))))
                {
                    throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
                };
                this._renderState.vertexBuffers[_arg_1] = _arg_2;
                this._renderState.vertexBuffersOffsets[_arg_1] = _arg_3;
                this._renderState.vertexBuffersFormats[_arg_1] = _arg_4;
                _local_5 = this._stage3D.context3D;
                if (_local_5 != null)
                {
                    if (_arg_2 != null)
                    {
                        this.prepareResource(_local_5, _arg_2);
                        _local_5.setVertexBufferAt(_arg_1, _arg_2.buffer, _arg_3, _arg_4);
                    } else
                    {
                        _local_5.setVertexBufferAt(_arg_1, null);
                    };
                };
            };
        }

        public function setProgramConstantsFromVector(_arg_1:String, _arg_2:int, _arg_3:Vector.<Number>, _arg_4:int=-1, _arg_5:Boolean=true):void{
            var _local_6:Context3D;
            var _local_11:Boolean;
            var _local_12:Number;
            var _local_7:int;
            var _local_8:int = (_arg_2 << 2);
            var _local_9:int = ((_arg_4 < 0) ? _arg_3.length : (_arg_4 << 2));
            var _local_10:Vector.<Number> = ((_arg_1 == "vertex") ? this._renderState.vertexConstants : this._renderState.fragmentConstants);
            if (_arg_5)
            {
                _local_11 = false;
                while (_local_7 < _local_9)
                {
                    _local_12 = _arg_3[_local_7];
                    if (_local_12 != _local_10[_local_8])
                    {
                        _local_10[_local_8] = _local_12;
                        _local_11 = true;
                    };
                    _local_7++;
                    _local_8++;
                };
                if (_local_11)
                {
                    _local_6 = this._stage3D.context3D;
                    if (_local_6 != null)
                    {
                        _local_6.setProgramConstantsFromVector(_arg_1, _arg_2, _arg_3, _arg_4);
                    };
                };
            } else
            {
                while (_local_7 < _local_9)
                {
                    _local_10[_local_8] = _arg_3[_local_7];
                    _local_7++;
                    _local_8++;
                };
                _local_6 = this._stage3D.context3D;
                if (_local_6 != null)
                {
                    _local_6.setProgramConstantsFromVector(_arg_1, _arg_2, _arg_3, _arg_4);
                };
            };
        }

        public function clear(_arg_1:Number=0, _arg_2:Number=0, _arg_3:Number=0, _arg_4:Number=1, _arg_5:Number=1, _arg_6:uint=0, _arg_7:uint=0xFFFFFFFF):void{
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_8:Context3D = this._stage3D.context3D;
            if (_local_8 != null)
            {
                if ((!(this.configured)))
                {
                    _local_9 = 50;
                    _local_10 = this._width;
                    _local_11 = this._height;
                    if (this._profile == "baselineConstrained")
                    {
                        _local_12 = this._x;
                        _local_13 = this._y;
                        if (_local_12 < 0)
                        {
                            _local_12 = 0;
                        };
                        if (_local_13 < 0)
                        {
                            _local_13 = 0;
                        };
                        if ((_local_12 + _local_10) > this.stage.stageWidth)
                        {
                            _local_10 = (this.stage.stageWidth - _local_12);
                        };
                        if ((_local_13 + _local_11) > this.stage.stageHeight)
                        {
                            _local_11 = (this.stage.stageHeight - _local_13);
                        };
                        if ((((((!(_local_12 == this._stage3D.x)) || (!(_local_13 == this._stage3D.y))) || (!(_local_10 == this.backBufferWidth))) || (!(_local_11 == this.backBufferHeight))) || (!(this._enableDepthAndStencil == this.backBufferEnableDepthAndStencil))))
                        {
                            _local_8.configureBackBuffer(_local_9, _local_9, 0, this._enableDepthAndStencil);
                            this._stage3D.x = _local_12;
                            this._stage3D.y = _local_13;
                            _local_8.configureBackBuffer(_local_10, _local_11, 0, this._enableDepthAndStencil);
                            this.backBufferWidth = _local_10;
                            this.backBufferHeight = _local_11;
                            this.backBufferAntiAlias = this._antiAlias;
                            this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                        };
                    } else
                    {
                        if (this._stage3D.x != this._x)
                        {
                            this._stage3D.x = this._x;
                        };
                        if (this._stage3D.y != this._y)
                        {
                            this._stage3D.y = this._y;
                        };
                        if (_local_10 < _local_9)
                        {
                            _local_10 = _local_9;
                        };
                        if (_local_11 < _local_9)
                        {
                            _local_11 = _local_9;
                        };
                        if (((((!(_local_10 == this.backBufferWidth)) || (!(_local_11 == this.backBufferHeight))) || (!(this._antiAlias == this.backBufferAntiAlias))) || (!(this._enableDepthAndStencil == this.backBufferEnableDepthAndStencil))))
                        {
                            _local_8.configureBackBuffer(_local_10, _local_11, this._antiAlias, this._enableDepthAndStencil);
                            this.backBufferWidth = _local_10;
                            this.backBufferHeight = _local_11;
                            this.backBufferAntiAlias = this._antiAlias;
                            this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                        };
                    };
                    this.configured = true;
                };
                _local_8.clear(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        public function drawToBitmapData(_arg_1:BitmapData):void{
            var _local_2:Context3D = this._stage3D.context3D;
            if (_local_2 != null)
            {
                _local_2.drawToBitmapData(_arg_1);
            };
        }

        public function drawTriangles(_arg_1:IndexBufferResource, _arg_2:int=0, _arg_3:int=-1):void{
            if ((!(_arg_1.available)))
            {
                throw (new Error(RESOURCE_NOT_AVAILABLE_ERROR));
            };
            var _local_4:Context3D = this._stage3D.context3D;
            if (_local_4 != null)
            {
                this.prepareResource(_local_4, _arg_1);
                try
                {
                    _local_4.drawTriangles(_arg_1.buffer, _arg_2, _arg_3);
                } catch(e:Error)
                {
                };
            };
        }

        public function present():void{
            this._renderState.renderTarget = null;
            var _local_1:Context3D = this._stage3D.context3D;
            if (_local_1 != null)
            {
                _local_1.present();
            };
            this.configured = false;
        }


    }
}//package alternativa.gfx.core