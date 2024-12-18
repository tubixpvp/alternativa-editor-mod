package alternativa.engine3d.materials
{
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import alternativa.gfx.core.BitmapTextureResource;
    import alternativa.gfx.core.CompressedTextureResource;
    import flash.display.BitmapData;
    import alternativa.gfx.core.Device;
    import alternativa.engine3d.objects.Decal;
    import alternativa.engine3d.objects.SkyBox;
    import alternativa.engine3d.core.Camera3D;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.Context3DProgramType;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.gfx.core.ProgramResource;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class TextureMaterial extends Material 
    {

        protected static const skyFogConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        protected static const correctionConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);
        protected static const uvCorrection:Vector.<Number> = Vector.<Number>([1, 1, 0, 1]);
        protected static const fragmentConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private static var programs:Array = new Array();

        protected var uvTransformConst:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0]);
        public var diffuseMapURL:String;
        public var opacityMapURL:String;
        public var repeat:Boolean = false;
        public var smooth:Boolean = true;
        public var resolution:Number = 1;
        public var threshold:Number = 0.01;
        public var correctUV:Boolean = false;
        alternativa3d var _textureATF:ByteArray;
        alternativa3d var _textureATFAlpha:ByteArray;
        alternativa3d var _mipMapping:int = 0;
        alternativa3d var _hardwareMipMaps:Boolean = false;
        alternativa3d var textureResource:BitmapTextureResource;
        alternativa3d var textureATFResource:CompressedTextureResource;
        alternativa3d var textureATFAlphaResource:CompressedTextureResource;
        protected var bitmap:BitmapData;

        public function TextureMaterial(_arg_1:BitmapData=null, _arg_2:Boolean=false, _arg_3:Boolean=true, _arg_4:int=0, _arg_5:Number=1)
        {
            this.repeat = _arg_2;
            this.smooth = _arg_3;
            this._mipMapping = _arg_4;
            this.resolution = _arg_5;
            if (_arg_1 != null)
            {
                this.bitmap = _arg_1;
                this.textureResource = TextureResourcesRegistry.getTextureResource(_arg_1, (this._mipMapping > 0), _arg_2, this._hardwareMipMaps);
            };
        }

        public function get texture():BitmapData
        {
            if (this.textureResource != null)
            {
                return (this.textureResource.bitmapData);
            };
            return (null);
        }

        public function set texture(_arg_1:BitmapData):void
        {
            var _local_2:BitmapData = this.texture;
            if (_arg_1 != _local_2)
            {
                if (_local_2 != null)
                {
                    this.textureResource.dispose();
                    this.textureResource = null;
                };
                if (_arg_1 != null)
                {
                    this.textureResource = TextureResourcesRegistry.getTextureResource(_arg_1, (this._mipMapping > 0), this.repeat, this._hardwareMipMaps);
                };
            };
        }

        public function get textureATF():ByteArray
        {
            return (this._textureATF);
        }

        public function set textureATF(_arg_1:ByteArray):void
        {
            if (_arg_1 != this._textureATF)
            {
                if (this._textureATF != null)
                {
                    this.textureATFResource.dispose();
                    this.textureATFResource = null;
                };
                this._textureATF = _arg_1;
                if (this._textureATF != null)
                {
                    this.textureATFResource = new CompressedTextureResource(this._textureATF);
                };
            };
        }

        public function get textureATFAlpha():ByteArray
        {
            return (this._textureATFAlpha);
        }

        public function set textureATFAlpha(_arg_1:ByteArray):void
        {
            if (_arg_1 != this._textureATFAlpha)
            {
                if (this._textureATFAlpha != null)
                {
                    this.textureATFAlphaResource.dispose();
                    this.textureATFAlphaResource = null;
                };
                this._textureATFAlpha = _arg_1;
                if (this._textureATFAlpha != null)
                {
                    this.textureATFAlphaResource = new CompressedTextureResource(this._textureATFAlpha);
                };
            };
        }

        public function get mipMapping():int
        {
            return (this._mipMapping);
        }

        public function set mipMapping(_arg_1:int):void
        {
            this._mipMapping = _arg_1;
            if (this.bitmap != null)
            {
                this.textureResource = TextureResourcesRegistry.getTextureResource(this.bitmap, (this._mipMapping > 0), this.repeat, this._hardwareMipMaps);
            };
        }

        public function disposeResource():void
        {
            if (this.textureResource != null)
            {
                this.textureResource.dispose();
                this.textureResource = null;
            };
        }

        public function get hardwareMipMaps():Boolean
        {
            return (this._hardwareMipMaps);
        }

        public function set hardwareMipMaps(_arg_1:Boolean):void
        {
            if (_arg_1 != this._hardwareMipMaps)
            {
                this._hardwareMipMaps = _arg_1;
                if (this.texture != null)
                {
                    this.textureResource.calculateMipMapsUsingGPU = this._hardwareMipMaps;
                };
            };
        }

        override public function clone():Material
        {
            var _local_1:TextureMaterial = new TextureMaterial(this.texture, this.repeat, this.smooth, this._mipMapping, this.resolution);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Material):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:TextureMaterial = (_arg_1 as TextureMaterial);
            this.diffuseMapURL = _local_2.diffuseMapURL;
            this.opacityMapURL = _local_2.opacityMapURL;
            this.threshold = _local_2.threshold;
            this.correctUV = _local_2.correctUV;
            this.textureATF = _local_2.textureATF;
            this.textureATFAlpha = _local_2.textureATFAlpha;
            this.hardwareMipMaps = _local_2.hardwareMipMaps;
        }

        override alternativa3d function get transparent():Boolean
        {
            if (super.transparent)
            {
                return (true);
            };
            if (this.texture != null)
            {
                return (this.texture.transparent);
            };
            if (this._textureATF != null)
            {
                return (!(this._textureATFAlpha == null));
            };
            return (false);
        }

        override alternativa3d function drawOpaque(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D):void
        {
            var _local_7:BitmapData = this.texture;
            if (((_local_7 == null) && (this._textureATF == null)))
            {
                return;
            };
            var _local_8:Device = _arg_1.device;
            var _local_9:Boolean = (_arg_6 is Decal);
            var _local_10:Boolean = ((!(_local_9)) && (zOffset));
            var _local_11:Boolean = ((_arg_6 is SkyBox) && (SkyBox(_arg_6).autoSize));
            var _local_12:Boolean = ((_arg_1.fogAlpha > 0) && (_arg_1.fogStrength > 0));
            var _local_13:Boolean = (((((!(_arg_1.view.constrained)) && (_arg_1.ssao)) && (_arg_1.ssaoStrength > 0)) && (_arg_6.useDepth)) && (!(_local_11)));
            var _local_14:Boolean = (((((!(_arg_1.view.constrained)) && (!(_arg_1.directionalLight == null))) && (_arg_1.directionalLightStrength > 0)) && (_arg_6.useLight)) && (!(_local_11)));
            var _local_15:Boolean = ((((((!(_arg_1.view.constrained)) && (!(_arg_1.shadowMap == null))) && (_arg_1.shadowMapStrength > 0)) && (_arg_6.useLight)) && (_arg_6.useShadowMap)) && (!(_local_11)));
            var _local_16:Boolean = ((((((!(_arg_1.view.constrained)) && (_arg_1.deferredLighting)) && (_arg_1.deferredLightingStrength > 0)) && (_arg_6.useDepth)) && (_arg_6.useLight)) && (!(_local_11)));
            var _local_17:Boolean = ((alphaTestThreshold > 0) && (this.transparent));
            _local_8.setProgram(this.getProgram(((!(_local_9)) && (!(_local_17))), _local_11, ((_local_9) || (_local_10)), false, _arg_1.view.quality, this.repeat, (this._mipMapping > 0), (!(_arg_6.concatenatedColorTransform == null)), ((_local_9) && (_arg_6.concatenatedAlpha < 1)), _local_12, false, _local_13, _local_14, _local_15, (_local_7 == null), false, _local_16, false, _arg_1.view.correction, (!(_arg_6.concatenatedBlendMode == "normal")), _local_17, false));
            if (_local_7 != null)
            {
                if (((uploadEveryFrame) && (!(drawId == Camera3D.renderId))))
                {
                    _local_8.uploadResource(this.textureResource);
                    drawId = Camera3D.renderId;
                };
                _local_8.setTextureAt(0, this.textureResource);
                uvCorrection[0] = this.textureResource.correctionU;
                uvCorrection[1] = this.textureResource.correctionV;
            } else
            {
                _local_8.setTextureAt(0, this.textureATFResource);
                uvCorrection[0] = 1;
                uvCorrection[1] = 1;
            };
            if (_local_13)
            {
                _local_8.setTextureAt(1, _arg_1.depthMap);
            } else
            {
                _local_8.setTextureAt(1, null);
            };
            if (_local_15)
            {
                _local_8.setTextureAt(2, _arg_1.shadowMap.map);
                _local_8.setTextureAt(3, _arg_1.shadowMap.noise);
            } else
            {
                _local_8.setTextureAt(2, null);
                _local_8.setTextureAt(3, null);
            };
            _local_8.setTextureAt(4, null);
            _local_8.setTextureAt(6, null);
            if (_local_16)
            {
                _local_8.setTextureAt(5, _arg_1.lightMap);
            } else
            {
                _local_8.setTextureAt(5, null);
            };
            _local_8.setVertexBufferAt(0, _arg_2, 0, Context3DVertexBufferFormat.FLOAT_3);
            _local_8.setVertexBufferAt(1, _arg_2, 3, Context3DVertexBufferFormat.FLOAT_2);
            if (_local_14)
            {
                _local_8.setVertexBufferAt(2, _arg_2, 5, Context3DVertexBufferFormat.FLOAT_3);
            } else
            {
                _local_8.setVertexBufferAt(2, null);
            };
            _local_8.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, _arg_6.transformConst, 3, false);
            _local_8.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, uvCorrection, 1);
            if (_local_9)
            {
                correctionConst[0] = (_arg_6.md * _arg_1.correctionX);
                correctionConst[1] = (_arg_6.mh * _arg_1.correctionY);
                correctionConst[2] = _arg_6.ml;
                correctionConst[3] = _arg_1.correctionX;
                correctionConst[4] = ((_arg_6.mc * _arg_1.correctionX) / Decal(_arg_6).attenuation);
                correctionConst[5] = ((_arg_6.mg * _arg_1.correctionY) / Decal(_arg_6).attenuation);
                correctionConst[6] = (_arg_6.mk / Decal(_arg_6).attenuation);
                correctionConst[7] = _arg_1.correctionY;
                _local_8.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, correctionConst, 2, false);
            } else
            {
                if (_local_10)
                {
                    correctionConst[0] = 0;
                    correctionConst[1] = 0;
                    correctionConst[2] = 0;
                    correctionConst[3] = _arg_1.correctionX;
                    correctionConst[4] = 0;
                    correctionConst[5] = 0;
                    correctionConst[6] = 0;
                    correctionConst[7] = _arg_1.correctionY;
                    _local_8.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, correctionConst, 2, false);
                } else
                {
                    if (_local_11)
                    {
                        _local_8.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, SkyBox(_arg_6).reduceConst, 1);
                        if (_local_12)
                        {
                            skyFogConst[0] = (_arg_1.fogFragment[0] * _arg_1.fogFragment[3]);
                            skyFogConst[1] = (_arg_1.fogFragment[1] * _arg_1.fogFragment[3]);
                            skyFogConst[2] = (_arg_1.fogFragment[2] * _arg_1.fogFragment[3]);
                            skyFogConst[3] = (1 - _arg_1.fogFragment[3]);
                            _local_8.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, skyFogConst, 1);
                        };
                    };
                };
            };
            if (_arg_6.concatenatedColorTransform != null)
            {
                _local_8.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _arg_6.colorConst, 2, false);
            } else
            {
                if (((_local_9) && (_arg_6.concatenatedAlpha < 1)))
                {
                    _local_8.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _arg_6.colorConst, 1);
                };
            };
            if (_local_17)
            {
                fragmentConst[3] = alphaTestThreshold;
                _local_8.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 14, fragmentConst, 1, false);
            };
            _local_8.drawTriangles(_arg_3, _arg_4, _arg_5);
            _arg_1.numDraws++;
            _arg_1.numTriangles = (_arg_1.numTriangles + _arg_5);
        }

        override alternativa3d function drawTransparent(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D, _arg_7:Boolean=false):void
        {
            var _local_8:BitmapData = this.texture;
            if (((_local_8 == null) && (this._textureATF == null)))
            {
                return;
            };
            var _local_9:Device = _arg_1.device;
            var _local_10:Boolean = zOffset;
            var _local_11:Boolean = ((_arg_1.fogAlpha > 0) && (_arg_1.fogStrength > 0));
            var _local_12:Boolean = (_arg_6 is Sprite3D);
            var _local_13:Boolean = ((((!(_arg_1.view.constrained)) && (_arg_1.softTransparency)) && (_arg_1.softTransparencyStrength > 0)) && (_arg_6.softAttenuation > 0));
            var _local_14:Boolean = ((((!(_arg_1.view.constrained)) && (_arg_1.ssao)) && (_arg_1.ssaoStrength > 0)) && (_arg_6.useDepth));
            var _local_15:Boolean = ((((!(_arg_1.view.constrained)) && (!(_arg_1.directionalLight == null))) && (_arg_1.directionalLightStrength > 0)) && (_arg_6.useLight));
            var _local_16:Boolean = (((((!(_arg_1.view.constrained)) && (!(_arg_1.shadowMap == null))) && (_arg_1.shadowMapStrength > 0)) && (_arg_6.useLight)) && (_arg_6.useShadowMap));
            var _local_17:Boolean = (((!(_arg_1.view.constrained)) && (_arg_1.deferredLighting)) && (_arg_1.deferredLightingStrength > 0));
            var _local_18:Boolean = ((((_local_17) && (_arg_6.useDepth)) && (_arg_6.useLight)) && (!(_local_12)));
            var _local_19:Boolean = (((_local_17) && (_local_12)) && (_arg_6.useLight));
            _local_9.setProgram(this.getProgram(false, false, _local_10, _local_12, _arg_1.view.quality, this.repeat, (this._mipMapping > 0), (!(_arg_6.concatenatedColorTransform == null)), (_arg_6.concatenatedAlpha < 1), _local_11, _local_13, _local_14, _local_15, _local_16, (_local_8 == null), ((_local_8 == null) && (!(this._textureATFAlpha == null))), _local_18, _local_19, _arg_1.view.correction, (!(_arg_6.concatenatedBlendMode == "normal")), false, _arg_7));
            if (_local_8 != null)
            {
                if (((uploadEveryFrame) && (!(drawId == Camera3D.renderId))))
                {
                    _local_9.uploadResource(this.textureResource);
                    drawId = Camera3D.renderId;
                };
                _local_9.setTextureAt(0, this.textureResource);
                uvCorrection[0] = this.textureResource.correctionU;
                uvCorrection[1] = this.textureResource.correctionV;
            } else
            {
                _local_9.setTextureAt(0, this.textureATFResource);
                if (this._textureATFAlpha != null)
                {
                    _local_9.setTextureAt(4, this.textureATFAlphaResource);
                } else
                {
                    _local_9.setTextureAt(4, null);
                };
                uvCorrection[0] = 1;
                uvCorrection[1] = 1;
            };
            if (((_local_14) || (_local_13)))
            {
                _local_9.setTextureAt(1, _arg_1.depthMap);
            } else
            {
                _local_9.setTextureAt(1, null);
            };
            if (_local_16)
            {
                _local_9.setTextureAt(2, _arg_1.shadowMap.map);
                _local_9.setTextureAt(3, _arg_1.shadowMap.noise);
            } else
            {
                _local_9.setTextureAt(2, null);
                _local_9.setTextureAt(3, null);
            };
            _local_9.setTextureAt(4, null);
            _local_9.setTextureAt(6, null);
            if (_local_18)
            {
                _local_9.setTextureAt(5, _arg_1.lightMap);
            } else
            {
                _local_9.setTextureAt(5, null);
            };
            _local_9.setVertexBufferAt(0, _arg_2, 0, Context3DVertexBufferFormat.FLOAT_1);
            _local_9.setVertexBufferAt(1, null);
            _local_9.setVertexBufferAt(2, null);
            if ((!(_local_12)))
            {
                _local_9.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, _arg_6.transformConst, 3, false);
            };
            _local_9.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, uvCorrection, 1);
            if (_local_13)
            {
                fragmentConst[2] = _arg_6.softAttenuation;
                _local_9.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 14, fragmentConst, 1);
            };
            if (_local_10)
            {
                correctionConst[0] = 0;
                correctionConst[1] = 0;
                correctionConst[2] = 0;
                correctionConst[3] = _arg_1.correctionX;
                correctionConst[4] = 0;
                correctionConst[5] = 0;
                correctionConst[6] = 0;
                correctionConst[7] = _arg_1.correctionY;
                _local_9.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, correctionConst, 2, false);
            } else
            {
                if (_local_12)
                {
                    if (_local_15)
                    {
                        correctionConst[0] = _arg_1.correctionX;
                        correctionConst[1] = _arg_1.correctionY;
                        correctionConst[2] = 1;
                        correctionConst[3] = 0.5;
                        _local_9.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, correctionConst, 1, false);
                    };
                    if (_local_19)
                    {
                        _local_9.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, Sprite3D(_arg_6).lightConst, 1, false);
                    };
                };
            };
            if (_arg_6.concatenatedColorTransform != null)
            {
                _local_9.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _arg_6.colorConst, 2, false);
            } else
            {
                if (_arg_6.concatenatedAlpha < 1)
                {
                    _local_9.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _arg_6.colorConst, 1);
                };
            };
            _local_9.drawTriangles(_arg_3, _arg_4, _arg_5);
            _arg_1.numDraws++;
            _arg_1.numTriangles = (_arg_1.numTriangles + _arg_5);
        }

        protected function getProgram(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:Boolean, _arg_9:Boolean, _arg_10:Boolean, _arg_11:Boolean, _arg_12:Boolean, _arg_13:Boolean, _arg_14:Boolean, _arg_15:Boolean, _arg_16:Boolean, _arg_17:Boolean, _arg_18:Boolean, _arg_19:Boolean, _arg_20:Boolean, _arg_21:Boolean, _arg_22:Boolean):ProgramResource
        {
            var _local_25:ByteArray;
            var _local_26:ByteArray;
            var _local_23:int = (((((((((((((((((((((int(_arg_1) | (int(_arg_2) << 1)) | (int(_arg_3) << 2)) | (int(_arg_4) << 3)) | (int(_arg_5) << 4)) | (int(_arg_6) << 5)) | (int(_arg_7) << 6)) | (int(_arg_8) << 7)) | (int(_arg_9) << 8)) | (int(_arg_10) << 9)) | (int(_arg_11) << 10)) | (int(_arg_12) << 11)) | (int(_arg_13) << 12)) | (int(_arg_14) << 13)) | (int(_arg_15) << 14)) | (int(_arg_16) << 15)) | (int(_arg_17) << 16)) | (int(_arg_18) << 17)) | (int(_arg_19) << 18)) | (int(_arg_20) << 19)) | (int(_arg_21) << 20)) | (int(_arg_22) << 21));
            var _local_24:ProgramResource = programs[_local_23];
            if (_local_24 == null)
            {
                _local_25 = new TextureMaterialVertexShader((!(_arg_22)), ((((_arg_14) || (_arg_11)) || (_arg_12)) || (_arg_17)), _arg_13, _arg_4, _arg_14, _arg_10, _arg_2, _arg_3, _arg_3, _arg_19).agalcode;
                _local_26 = new TextureMaterialFragmentShader(_arg_6, _arg_5, _arg_7, _arg_15, _arg_16, _arg_21, (((!(_arg_1)) && (!(_arg_16))) && (!(_arg_15))), _arg_8, _arg_9, _arg_3, _arg_13, _arg_11, _arg_12, _arg_17, _arg_18, _arg_14, _arg_10, _arg_2, _arg_20).agalcode;
                _local_24 = new ProgramResource(_local_25, _local_26);
                programs[_local_23] = _local_24;
            };
            return (_local_24);
        }

        override public function dispose():void
        {
            this.disposeResource();
        }


    }
}//package alternativa.engine3d.materials