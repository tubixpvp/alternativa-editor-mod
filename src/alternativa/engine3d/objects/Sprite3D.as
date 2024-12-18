package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.Material;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.engine3d.core.Vertex;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Wrapper;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.lights.OmniLight;
    import alternativa.engine3d.lights.SpotLight;
    import alternativa.engine3d.lights.TubeLight;
    import flash.display.BitmapData;
    import alternativa.engine3d.materials.TextureMaterial;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Sprite3D extends Object3D 
    {

        public var material:Material;
        public var originX:Number = 0.5;
        public var originY:Number = 0.5;
        public var sorting:int = 0;
        public var clipping:int = 2;
        public var rotation:Number = 0;
        public var autoSize:Boolean = false;
        public var width:Number;
        public var height:Number;
        public var perspectiveScale:Boolean = true;
        public var topLeftU:Number = 0;
        public var topLeftV:Number = 0;
        public var bottomRightU:Number = 1;
        public var bottomRightV:Number = 1;
        public var depthTest:Boolean = true;
        alternativa3d var lightConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        alternativa3d var lighted:Boolean;

        public function Sprite3D(_arg_1:Number, _arg_2:Number, _arg_3:Material=null)
        {
            this.width = _arg_1;
            this.height = _arg_2;
            this.material = _arg_3;
            shadowMapAlphaThreshold = 100;
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            var _local_5:RayIntersectionData;
            var _local_24:Vertex;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Vector3D;
            if (((_arg_4 == null) || ((!(_arg_3 == null)) && (_arg_3[this]))))
            {
                return (null);
            };
            _arg_4.composeCameraMatrix();
            var _local_6:Object3D = _arg_4;
            while (_local_6._parent != null)
            {
                _local_6 = _local_6._parent;
                _local_6.composeMatrix();
                _arg_4.appendMatrix(_local_6);
            };
            _arg_4.invertMatrix();
            composeMatrix();
            _local_6 = this;
            while (_local_6._parent != null)
            {
                _local_6 = _local_6._parent;
                _local_6.composeMatrix();
                appendMatrix(_local_6);
            };
            appendMatrix(_arg_4);
            calculateInverseMatrix();
            var _local_7:Number = _arg_4.nearClipping;
            var _local_8:Number = _arg_4.farClipping;
            _arg_4.nearClipping = -(Number.MAX_VALUE);
            _arg_4.farClipping = Number.MAX_VALUE;
            culling = 0;
            var _local_9:Face = this.calculateFace(_arg_4);
            _arg_4.nearClipping = _local_7;
            _arg_4.farClipping = _local_8;
            var _local_10:Wrapper = _local_9.wrapper;
            while (_local_10 != null)
            {
                _local_24 = _local_10.vertex;
                _local_24.x = ((((ima * _local_24.cameraX) + (imb * _local_24.cameraY)) + (imc * _local_24.cameraZ)) + imd);
                _local_24.y = ((((ime * _local_24.cameraX) + (imf * _local_24.cameraY)) + (img * _local_24.cameraZ)) + imh);
                _local_24.z = ((((imi * _local_24.cameraX) + (imj * _local_24.cameraY)) + (imk * _local_24.cameraZ)) + iml);
                _local_10 = _local_10.next;
            };
            var _local_11:Wrapper = _local_9.wrapper;
            var _local_12:Vertex = _local_11.vertex;
            _local_11 = _local_11.next;
            var _local_13:Vertex = _local_11.vertex;
            _local_11 = _local_11.next;
            var _local_14:Vertex = _local_11.vertex;
            _local_11 = _local_11.next;
            var _local_15:Vertex = _local_11.vertex;
            _local_12.u = this.topLeftU;
            _local_12.v = this.topLeftV;
            _local_13.u = this.topLeftU;
            _local_13.v = this.bottomRightV;
            _local_14.u = this.bottomRightU;
            _local_14.v = this.bottomRightV;
            _local_15.u = this.bottomRightU;
            _local_15.v = this.topLeftV;
            var _local_16:Number = (_local_13.x - _local_12.x);
            var _local_17:Number = (_local_13.y - _local_12.y);
            var _local_18:Number = (_local_13.z - _local_12.z);
            var _local_19:Number = (_local_14.x - _local_12.x);
            var _local_20:Number = (_local_14.y - _local_12.y);
            var _local_21:Number = (_local_14.z - _local_12.z);
            _local_9.normalX = ((_local_21 * _local_17) - (_local_20 * _local_18));
            _local_9.normalY = ((_local_19 * _local_18) - (_local_21 * _local_16));
            _local_9.normalZ = ((_local_20 * _local_16) - (_local_19 * _local_17));
            var _local_22:Number = (1 / Math.sqrt((((_local_9.normalX * _local_9.normalX) + (_local_9.normalY * _local_9.normalY)) + (_local_9.normalZ * _local_9.normalZ))));
            _local_9.normalX = (_local_9.normalX * _local_22);
            _local_9.normalY = (_local_9.normalY * _local_22);
            _local_9.normalZ = (_local_9.normalZ * _local_22);
            _local_9.offset = (((_local_12.x * _local_9.normalX) + (_local_12.y * _local_9.normalY)) + (_local_12.z * _local_9.normalZ));
            var _local_23:Number = (((_arg_2.x * _local_9.normalX) + (_arg_2.y * _local_9.normalY)) + (_arg_2.z * _local_9.normalZ));
            if (_local_23 < 0)
            {
                _local_25 = ((((_arg_1.x * _local_9.normalX) + (_arg_1.y * _local_9.normalY)) + (_arg_1.z * _local_9.normalZ)) - _local_9.offset);
                if (_local_25 > 0)
                {
                    _local_26 = (-(_local_25) / _local_23);
                    _local_27 = (_arg_1.x + (_arg_2.x * _local_26));
                    _local_28 = (_arg_1.y + (_arg_2.y * _local_26));
                    _local_29 = (_arg_1.z + (_arg_2.z * _local_26));
                    _local_10 = _local_9.wrapper;
                    while (_local_10 != null)
                    {
                        _local_12 = _local_10.vertex;
                        _local_13 = ((_local_10.next != null) ? _local_10.next.vertex : _local_9.wrapper.vertex);
                        _local_16 = (_local_13.x - _local_12.x);
                        _local_17 = (_local_13.y - _local_12.y);
                        _local_18 = (_local_13.z - _local_12.z);
                        _local_19 = (_local_27 - _local_12.x);
                        _local_20 = (_local_28 - _local_12.y);
                        _local_21 = (_local_29 - _local_12.z);
                        if ((((((_local_21 * _local_17) - (_local_20 * _local_18)) * _local_9.normalX) + (((_local_19 * _local_18) - (_local_21 * _local_16)) * _local_9.normalY)) + (((_local_20 * _local_16) - (_local_19 * _local_17)) * _local_9.normalZ)) < 0) break;
                        _local_10 = _local_10.next;
                    };
                    if (_local_10 == null)
                    {
                        _local_30 = new Vector3D(_local_27, _local_28, _local_29);
                        _local_5 = new RayIntersectionData();
                        _local_5.object = this;
                        _local_5.face = null;
                        _local_5.point = _local_30;
                        _local_5.uv = _local_9.getUV(_local_30);
                        _local_5.time = _local_26;
                    };
                };
            };
            _arg_4.deferredDestroy();
            return (_local_5);
        }

        override public function clone():Object3D
        {
            var _local_1:Sprite3D = new Sprite3D(this.width, this.height);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Sprite3D = (_arg_1 as Sprite3D);
            this.width = _local_2.width;
            this.height = _local_2.height;
            this.autoSize = _local_2.autoSize;
            this.material = _local_2.material;
            this.clipping = _local_2.clipping;
            this.sorting = _local_2.sorting;
            this.originX = _local_2.originX;
            this.originY = _local_2.originY;
            this.topLeftU = _local_2.topLeftU;
            this.topLeftV = _local_2.topLeftV;
            this.bottomRightU = _local_2.bottomRightU;
            this.bottomRightV = _local_2.bottomRightV;
            this.rotation = _local_2.rotation;
            this.perspectiveScale = _local_2.perspectiveScale;
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:int;
            if (this.material == null)
            {
                return;
            };
            var _local_3:Face = this.calculateFace(_arg_1);
            if (_local_3 != null)
            {
                this.lighted = false;
                if (((((useLight) && (!(_arg_1.view.constrained))) && (_arg_1.deferredLighting)) && (_arg_1.deferredLightingStrength > 0)))
                {
                    this.calculateLight(_arg_1);
                };
                if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                {
                    if ((_local_2 & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, _local_3, 0xFFFFFF);
                    };
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
                _arg_1.addTransparent(_local_3, this);
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            if (this.material == null)
            {
                return (null);
            };
            var _local_2:Face = this.calculateFace(_arg_1);
            if (_local_2 != null)
            {
                this.lighted = false;
                if (((((useLight) && (!(_arg_1.view.constrained))) && (_arg_1.deferredLighting)) && (_arg_1.deferredLightingStrength > 0)))
                {
                    this.calculateLight(_arg_1);
                };
                _local_2.normalX = 0;
                _local_2.normalY = 0;
                _local_2.normalZ = -1;
                _local_2.offset = -(ml);
                return (VG.create(this, _local_2, this.sorting, ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0), true));
            };
            return (null);
        }

        private function calculateLight(_arg_1:Camera3D):void
        {
            var _local_4:int;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_20:OmniLight;
            var _local_21:SpotLight;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:TubeLight;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_2:Number = (_arg_1.viewSizeX / _arg_1.focalLength);
            var _local_3:Number = (_arg_1.viewSizeY / _arg_1.focalLength);
            if (((!(_arg_1.view.constrained)) && (((!(_arg_1.directionalLight == null)) && (_arg_1.directionalLightStrength > 0)) || ((!(_arg_1.shadowMap == null)) && (_arg_1.shadowMapStrength > 0)))))
            {
                this.lightConst[0] = 0;
                this.lightConst[1] = 0;
                this.lightConst[2] = 0;
            } else
            {
                this.lightConst[0] = 1;
                this.lightConst[1] = 1;
                this.lightConst[2] = 1;
            };
            var _local_13:Number = (md * _local_2);
            var _local_14:Number = (mh * _local_3);
            var _local_15:Number = ml;
            var _local_16:Number = Math.sqrt((((_local_13 * _local_13) + (_local_14 * _local_14)) + (_local_15 * _local_15)));
            var _local_17:Number = (-(_local_13) / _local_16);
            var _local_18:Number = (-(_local_14) / _local_16);
            var _local_19:Number = (-(_local_15) / _local_16);
            _local_4 = 0;
            while (_local_4 < _arg_1.omniesCount)
            {
                _local_20 = _arg_1.omnies[_local_4];
                _local_5 = (_local_20.cmd * _local_2);
                _local_6 = (_local_20.cmh * _local_3);
                _local_7 = _local_20.cml;
                _local_8 = _local_20.attenuationEnd;
                if ((((((((_local_5 - _local_8) < _local_13) && ((_local_5 + _local_8) > _local_13)) && ((_local_6 - _local_8) < _local_14)) && ((_local_6 + _local_8) > _local_14)) && ((_local_7 - _local_8) < _local_15)) && ((_local_7 + _local_8) > _local_15)))
                {
                    _local_5 = (_local_5 - _local_13);
                    _local_6 = (_local_6 - _local_14);
                    _local_7 = (_local_7 - _local_15);
                    _local_16 = Math.sqrt((((_local_5 * _local_5) + (_local_6 * _local_6)) + (_local_7 * _local_7)));
                    if (((_local_16 > 0) && (_local_16 < _local_8)))
                    {
                        _local_5 = (_local_5 / _local_16);
                        _local_6 = (_local_6 / _local_16);
                        _local_7 = (_local_7 / _local_16);
                        _local_9 = ((_local_8 - _local_16) / (_local_20.attenuationEnd - _local_20.attenuationBegin));
                        if (_local_9 > 1)
                        {
                            _local_9 = 1;
                        };
                        if (_local_9 < 0)
                        {
                            _local_9 = 0;
                        };
                        _local_9 = (_local_9 * _local_9);
                        _local_11 = (((_local_5 * _local_17) + (_local_6 * _local_18)) + (_local_7 * _local_19));
                        _local_11 = (_local_11 * 0.5);
                        _local_11 = (_local_11 + 0.5);
                        _local_12 = ((((_local_9 * _local_11) * _local_20.intensity) * 2) * _arg_1.deferredLightingStrength);
                        this.lightConst[0] = (this.lightConst[0] + ((_local_12 * ((_local_20.color >> 16) & 0xFF)) / 0xFF));
                        this.lightConst[1] = (this.lightConst[1] + ((_local_12 * ((_local_20.color >> 8) & 0xFF)) / 0xFF));
                        this.lightConst[2] = (this.lightConst[2] + ((_local_12 * (_local_20.color & 0xFF)) / 0xFF));
                        this.lighted = true;
                    };
                };
                _local_4++;
            };
            _local_4 = 0;
            while (_local_4 < _arg_1.spotsCount)
            {
                _local_21 = _arg_1.spots[_local_4];
                _local_5 = (_local_21.cmd * _local_2);
                _local_6 = (_local_21.cmh * _local_3);
                _local_7 = _local_21.cml;
                _local_8 = _local_21.attenuationEnd;
                if ((((((((_local_5 - _local_8) < _local_13) && ((_local_5 + _local_8) > _local_13)) && ((_local_6 - _local_8) < _local_14)) && ((_local_6 + _local_8) > _local_14)) && ((_local_7 - _local_8) < _local_15)) && ((_local_7 + _local_8) > _local_15)))
                {
                    _local_5 = (_local_5 - _local_13);
                    _local_6 = (_local_6 - _local_14);
                    _local_7 = (_local_7 - _local_15);
                    _local_16 = Math.sqrt((((_local_5 * _local_5) + (_local_6 * _local_6)) + (_local_7 * _local_7)));
                    if (((_local_16 > 0) && (_local_16 < _local_8)))
                    {
                        _local_5 = (_local_5 / _local_16);
                        _local_6 = (_local_6 / _local_16);
                        _local_7 = (_local_7 / _local_16);
                        _local_22 = ((((-(_local_5) * _local_21.cmc) * _local_2) - ((_local_6 * _local_21.cmg) * _local_3)) - (_local_7 * _local_21.cmk));
                        _local_23 = Math.cos((_local_21.falloff * 0.5));
                        if (_local_22 > _local_23)
                        {
                            _local_11 = (((_local_5 * _local_17) + (_local_6 * _local_18)) + (_local_7 * _local_19));
                            _local_11 = (_local_11 * 0.5);
                            _local_11 = (_local_11 + 0.5);
                            _local_9 = ((_local_8 - _local_16) / (_local_21.attenuationEnd - _local_21.attenuationBegin));
                            if (_local_9 > 1)
                            {
                                _local_9 = 1;
                            };
                            if (_local_9 < 0)
                            {
                                _local_9 = 0;
                            };
                            _local_9 = (_local_9 * _local_9);
                            _local_10 = ((_local_22 - _local_23) / (Math.cos((_local_21.hotspot * 0.5)) - _local_23));
                            if (_local_10 > 1)
                            {
                                _local_10 = 1;
                            };
                            if (_local_10 < 0)
                            {
                                _local_10 = 0;
                            };
                            _local_10 = (_local_10 * _local_10);
                            _local_12 = (((((_local_9 * _local_10) * _local_11) * _local_21.intensity) * 2) * _arg_1.deferredLightingStrength);
                            this.lightConst[0] = (this.lightConst[0] + ((_local_12 * ((_local_21.color >> 16) & 0xFF)) / 0xFF));
                            this.lightConst[1] = (this.lightConst[1] + ((_local_12 * ((_local_21.color >> 8) & 0xFF)) / 0xFF));
                            this.lightConst[2] = (this.lightConst[2] + ((_local_12 * (_local_21.color & 0xFF)) / 0xFF));
                            this.lighted = true;
                        };
                    };
                };
                _local_4++;
            };
            _local_4 = 0;
            while (_local_4 < _arg_1.tubesCount)
            {
                _local_24 = _arg_1.tubes[_local_4];
                _local_25 = (_local_24.length * 0.5);
                _local_26 = (_local_25 + _local_24.falloff);
                _local_27 = (_local_24.cmc * _local_2);
                _local_28 = (_local_24.cmg * _local_2);
                _local_29 = _local_24.cmk;
                _local_5 = ((_local_24.cmd * _local_2) + (_local_27 * _local_25));
                _local_6 = ((_local_24.cmh * _local_3) + (_local_28 * _local_25));
                _local_7 = (_local_24.cml + (_local_29 * _local_25));
                _local_30 = (((_local_27 * (_local_13 - _local_5)) + (_local_28 * (_local_14 - _local_6))) + (_local_29 * (_local_15 - _local_7)));
                if (((_local_30 > -(_local_26)) && (_local_30 < _local_26)))
                {
                    _local_5 = (_local_5 + ((_local_27 * _local_30) - _local_13));
                    _local_6 = (_local_6 + ((_local_28 * _local_30) - _local_14));
                    _local_7 = (_local_7 + ((_local_29 * _local_30) - _local_15));
                    _local_16 = Math.sqrt((((_local_5 * _local_5) + (_local_6 * _local_6)) + (_local_7 * _local_7)));
                    if (((_local_16 > 0) && (_local_16 < _local_24.attenuationEnd)))
                    {
                        _local_5 = (_local_5 / _local_16);
                        _local_6 = (_local_6 / _local_16);
                        _local_7 = (_local_7 / _local_16);
                        _local_11 = (((_local_5 * _local_17) + (_local_6 * _local_18)) + (_local_7 * _local_19));
                        _local_11 = (_local_11 * 0.5);
                        _local_11 = (_local_11 + 0.5);
                        _local_9 = ((_local_24.attenuationEnd - _local_16) / (_local_24.attenuationEnd - _local_24.attenuationBegin));
                        if (_local_9 > 1)
                        {
                            _local_9 = 1;
                        };
                        if (_local_9 < 0)
                        {
                            _local_9 = 0;
                        };
                        _local_9 = (_local_9 * _local_9);
                        if (_local_30 < 0)
                        {
                            _local_30 = -(_local_30);
                        };
                        _local_10 = ((_local_26 - _local_30) / (_local_26 - _local_25));
                        if (_local_10 > 1)
                        {
                            _local_10 = 1;
                        };
                        if (_local_10 < 0)
                        {
                            _local_10 = 0;
                        };
                        _local_10 = (_local_10 * _local_10);
                        _local_12 = (((((_local_9 * _local_10) * _local_11) * _local_24.intensity) * 2) * _arg_1.deferredLightingStrength);
                        this.lightConst[0] = (this.lightConst[0] + ((_local_12 * ((_local_24.color >> 16) & 0xFF)) / 0xFF));
                        this.lightConst[1] = (this.lightConst[1] + ((_local_12 * ((_local_24.color >> 8) & 0xFF)) / 0xFF));
                        this.lightConst[2] = (this.lightConst[2] + ((_local_12 * (_local_24.color & 0xFF)) / 0xFF));
                        this.lighted = true;
                    };
                };
                _local_4++;
            };
        }

        private function calculateFace(_arg_1:Camera3D):Face
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Vertex;
            var _local_12:Vertex;
            var _local_22:Number;
            var _local_25:BitmapData;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Number;
            culling = (culling & 0x3C);
            var _local_2:Number = ml;
            if (((_local_2 <= _arg_1.nearClipping) || (_local_2 >= _arg_1.farClipping)))
            {
                return (null);
            };
            var _local_13:Number = this.width;
            var _local_14:Number = this.height;
            var _local_15:Number = (this.bottomRightU - this.topLeftU);
            var _local_16:Number = (this.bottomRightV - this.topLeftV);
            if (((this.autoSize) && (this.material is TextureMaterial)))
            {
                _local_25 = (this.material as TextureMaterial).texture;
                if (_local_25 != null)
                {
                    _local_13 = (_local_25.width * _local_15);
                    _local_14 = (_local_25.height * _local_16);
                };
            };
            var _local_17:Number = (_arg_1.viewSizeX / _local_2);
            var _local_18:Number = (_arg_1.viewSizeY / _local_2);
            var _local_19:Number = (_arg_1.focalLength / _local_2);
            var _local_20:Number = (_arg_1.focalLength / _arg_1.viewSizeX);
            var _local_21:Number = (_arg_1.focalLength / _arg_1.viewSizeY);
            _local_3 = (ma / _local_20);
            _local_4 = (me / _local_21);
            _local_22 = Math.sqrt((((_local_3 * _local_3) + (_local_4 * _local_4)) + (mi * mi)));
            _local_3 = (mb / _local_20);
            _local_4 = (mf / _local_21);
            _local_22 = (_local_22 + Math.sqrt((((_local_3 * _local_3) + (_local_4 * _local_4)) + (mj * mj))));
            _local_3 = (mc / _local_20);
            _local_4 = (mg / _local_21);
            _local_22 = (_local_22 + Math.sqrt((((_local_3 * _local_3) + (_local_4 * _local_4)) + (mk * mk))));
            _local_22 = (_local_22 / 3);
            if ((!(this.perspectiveScale)))
            {
                _local_22 = (_local_22 / _local_19);
            };
            if (this.rotation == 0)
            {
                _local_26 = ((_local_22 * _local_13) * _local_20);
                _local_27 = ((_local_22 * _local_14) * _local_21);
                _local_3 = (md - (this.originX * _local_26));
                _local_4 = (mh - (this.originY * _local_27));
                _local_7 = (_local_3 + _local_26);
                _local_8 = (_local_4 + _local_27);
                if (((culling > 0) && ((((_local_3 > _local_2) || (_local_4 > _local_2)) || (_local_7 < -(_local_2))) || (_local_8 < -(_local_2)))))
                {
                    return (null);
                };
                _local_11 = Vertex.createList(4);
                _local_12 = _local_11;
                _local_12.cameraX = _local_3;
                _local_12.cameraY = _local_4;
                _local_12.cameraZ = _local_2;
                _local_12.u = this.topLeftU;
                _local_12.v = this.topLeftV;
                _local_12 = _local_12.next;
                _local_12.cameraX = _local_3;
                _local_12.cameraY = _local_8;
                _local_12.cameraZ = _local_2;
                _local_12.u = this.topLeftU;
                _local_12.v = this.bottomRightV;
                _local_12 = _local_12.next;
                _local_12.cameraX = _local_7;
                _local_12.cameraY = _local_8;
                _local_12.cameraZ = _local_2;
                _local_12.u = this.bottomRightU;
                _local_12.v = this.bottomRightV;
                _local_12 = _local_12.next;
                _local_12.cameraX = _local_7;
                _local_12.cameraY = _local_4;
                _local_12.cameraZ = _local_2;
                _local_12.u = this.bottomRightU;
                _local_12.v = this.topLeftV;
            } else
            {
                _local_28 = (-(Math.sin(this.rotation)) * _local_22);
                _local_29 = (Math.cos(this.rotation) * _local_22);
                _local_30 = ((_local_29 * _local_13) * _local_20);
                _local_31 = ((-(_local_28) * _local_13) * _local_21);
                _local_32 = ((_local_28 * _local_14) * _local_20);
                _local_33 = ((_local_29 * _local_14) * _local_21);
                _local_3 = ((md - (this.originX * _local_30)) - (this.originY * _local_32));
                _local_4 = ((mh - (this.originX * _local_31)) - (this.originY * _local_33));
                _local_5 = (_local_3 + _local_32);
                _local_6 = (_local_4 + _local_33);
                _local_7 = ((_local_3 + _local_30) + _local_32);
                _local_8 = ((_local_4 + _local_31) + _local_33);
                _local_9 = (_local_3 + _local_30);
                _local_10 = (_local_4 + _local_31);
                if (culling > 0)
                {
                    if (this.clipping == 1)
                    {
                        if ((((((culling & 0x04) && (_local_2 <= -(_local_3))) && (_local_2 <= -(_local_5))) && (_local_2 <= -(_local_7))) && (_local_2 <= -(_local_9))))
                        {
                            return (null);
                        };
                        if ((((((culling & 0x08) && (_local_2 <= _local_3)) && (_local_2 <= _local_5)) && (_local_2 <= _local_7)) && (_local_2 <= _local_9)))
                        {
                            return (null);
                        };
                        if ((((((culling & 0x10) && (_local_2 <= -(_local_4))) && (_local_2 <= -(_local_6))) && (_local_2 <= -(_local_8))) && (_local_2 <= -(_local_10))))
                        {
                            return (null);
                        };
                        if ((((((culling & 0x20) && (_local_2 <= _local_4)) && (_local_2 <= _local_6)) && (_local_2 <= _local_8)) && (_local_2 <= _local_10)))
                        {
                            return (null);
                        };
                        _local_11 = Vertex.createList(4);
                        _local_12 = _local_11;
                        _local_12.cameraX = _local_3;
                        _local_12.cameraY = _local_4;
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.topLeftU;
                        _local_12.v = this.topLeftV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = (_local_3 + _local_32);
                        _local_12.cameraY = (_local_4 + _local_33);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.topLeftU;
                        _local_12.v = this.bottomRightV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = ((_local_3 + _local_30) + _local_32);
                        _local_12.cameraY = ((_local_4 + _local_31) + _local_33);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.bottomRightU;
                        _local_12.v = this.bottomRightV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = (_local_3 + _local_30);
                        _local_12.cameraY = (_local_4 + _local_31);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.bottomRightU;
                        _local_12.v = this.topLeftV;
                    } else
                    {
                        if ((culling & 0x04))
                        {
                            if (((((_local_2 <= -(_local_3)) && (_local_2 <= -(_local_5))) && (_local_2 <= -(_local_7))) && (_local_2 <= -(_local_9))))
                            {
                                return (null);
                            };
                            if (((((_local_2 > -(_local_3)) && (_local_2 > -(_local_5))) && (_local_2 > -(_local_7))) && (_local_2 > -(_local_9))))
                            {
                                culling = (culling & 0x3B);
                            };
                        };
                        if ((culling & 0x08))
                        {
                            if (((((_local_2 <= _local_3) && (_local_2 <= _local_5)) && (_local_2 <= _local_7)) && (_local_2 <= _local_9)))
                            {
                                return (null);
                            };
                            if (((((_local_2 > _local_3) && (_local_2 > _local_5)) && (_local_2 > _local_7)) && (_local_2 > _local_9)))
                            {
                                culling = (culling & 0x37);
                            };
                        };
                        if ((culling & 0x10))
                        {
                            if (((((_local_2 <= -(_local_4)) && (_local_2 <= -(_local_6))) && (_local_2 <= -(_local_8))) && (_local_2 <= -(_local_10))))
                            {
                                return (null);
                            };
                            if (((((_local_2 > -(_local_4)) && (_local_2 > -(_local_6))) && (_local_2 > -(_local_8))) && (_local_2 > -(_local_10))))
                            {
                                culling = (culling & 0x2F);
                            };
                        };
                        if ((culling & 0x20))
                        {
                            if (((((_local_2 <= _local_4) && (_local_2 <= _local_6)) && (_local_2 <= _local_8)) && (_local_2 <= _local_10)))
                            {
                                return (null);
                            };
                            if (((((_local_2 > _local_4) && (_local_2 > _local_6)) && (_local_2 > _local_8)) && (_local_2 > _local_10)))
                            {
                                culling = (culling & 0x1F);
                            };
                        };
                        _local_11 = Vertex.createList(4);
                        _local_12 = _local_11;
                        _local_12.cameraX = _local_3;
                        _local_12.cameraY = _local_4;
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.topLeftU;
                        _local_12.v = this.topLeftV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = (_local_3 + _local_32);
                        _local_12.cameraY = (_local_4 + _local_33);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.topLeftU;
                        _local_12.v = this.bottomRightV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = ((_local_3 + _local_30) + _local_32);
                        _local_12.cameraY = ((_local_4 + _local_31) + _local_33);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.bottomRightU;
                        _local_12.v = this.bottomRightV;
                        _local_12 = _local_12.next;
                        _local_12.cameraX = (_local_3 + _local_30);
                        _local_12.cameraY = (_local_4 + _local_31);
                        _local_12.cameraZ = _local_2;
                        _local_12.u = this.bottomRightU;
                        _local_12.v = this.topLeftV;
                    };
                } else
                {
                    _local_11 = Vertex.createList(4);
                    _local_12 = _local_11;
                    _local_12.cameraX = _local_3;
                    _local_12.cameraY = _local_4;
                    _local_12.cameraZ = _local_2;
                    _local_12.u = this.topLeftU;
                    _local_12.v = this.topLeftV;
                    _local_12 = _local_12.next;
                    _local_12.cameraX = (_local_3 + _local_32);
                    _local_12.cameraY = (_local_4 + _local_33);
                    _local_12.cameraZ = _local_2;
                    _local_12.u = this.topLeftU;
                    _local_12.v = this.bottomRightV;
                    _local_12 = _local_12.next;
                    _local_12.cameraX = ((_local_3 + _local_30) + _local_32);
                    _local_12.cameraY = ((_local_4 + _local_31) + _local_33);
                    _local_12.cameraZ = _local_2;
                    _local_12.u = this.bottomRightU;
                    _local_12.v = this.bottomRightV;
                    _local_12 = _local_12.next;
                    _local_12.cameraX = (_local_3 + _local_30);
                    _local_12.cameraY = (_local_4 + _local_31);
                    _local_12.cameraZ = _local_2;
                    _local_12.u = this.bottomRightU;
                    _local_12.v = this.topLeftV;
                };
            };
            _arg_1.lastVertex.next = _local_11;
            _arg_1.lastVertex = _local_12;
            var _local_23:Face = Face.create();
            _local_23.material = this.material;
            _arg_1.lastFace.next = _local_23;
            _arg_1.lastFace = _local_23;
            var _local_24:Wrapper = Wrapper.create();
            _local_23.wrapper = _local_24;
            _local_24.vertex = _local_11;
            _local_11 = _local_11.next;
            while (_local_11 != null)
            {
                _local_24.next = _local_24.create();
                _local_24 = _local_24.next;
                _local_24.vertex = _local_11;
                _local_11 = _local_11.next;
            };
            return (_local_23);
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            var _local_11:BitmapData;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_3:Number = this.width;
            var _local_4:Number = this.height;
            if (((this.autoSize) && (this.material is TextureMaterial)))
            {
                _local_11 = (this.material as TextureMaterial).texture;
                if (_local_11 != null)
                {
                    _local_3 = (_local_11.width * (this.bottomRightU - this.topLeftU));
                    _local_4 = (_local_11.height * (this.bottomRightV - this.topLeftV));
                };
            };
            var _local_5:Number = (((this.originX >= 0.5) ? this.originX : (1 - this.originX)) * _local_3);
            var _local_6:Number = (((this.originY >= 0.5) ? this.originY : (1 - this.originY)) * _local_4);
            var _local_7:Number = Math.sqrt(((_local_5 * _local_5) + (_local_6 * _local_6)));
            var _local_8:Number = 0;
            var _local_9:Number = 0;
            var _local_10:Number = 0;
            if (_arg_2 != null)
            {
                _local_12 = _arg_2.ma;
                _local_13 = _arg_2.me;
                _local_14 = _arg_2.mi;
                _local_15 = Math.sqrt((((_local_12 * _local_12) + (_local_13 * _local_13)) + (_local_14 * _local_14)));
                _local_12 = _arg_2.mb;
                _local_13 = _arg_2.mf;
                _local_14 = _arg_2.mj;
                _local_15 = (_local_15 + Math.sqrt((((_local_12 * _local_12) + (_local_13 * _local_13)) + (_local_14 * _local_14))));
                _local_12 = _arg_2.mc;
                _local_13 = _arg_2.mg;
                _local_14 = _arg_2.mk;
                _local_15 = (_local_15 + Math.sqrt((((_local_12 * _local_12) + (_local_13 * _local_13)) + (_local_14 * _local_14))));
                _local_7 = (_local_7 * (_local_15 / 3));
                _local_8 = _arg_2.md;
                _local_9 = _arg_2.mh;
                _local_10 = _arg_2.ml;
            };
            if ((_local_8 - _local_7) < _arg_1.boundMinX)
            {
                _arg_1.boundMinX = (_local_8 - _local_7);
            };
            if ((_local_8 + _local_7) > _arg_1.boundMaxX)
            {
                _arg_1.boundMaxX = (_local_8 + _local_7);
            };
            if ((_local_9 - _local_7) < _arg_1.boundMinY)
            {
                _arg_1.boundMinY = (_local_9 - _local_7);
            };
            if ((_local_9 + _local_7) > _arg_1.boundMaxY)
            {
                _arg_1.boundMaxY = (_local_9 + _local_7);
            };
            if ((_local_10 - _local_7) < _arg_1.boundMinZ)
            {
                _arg_1.boundMinZ = (_local_10 - _local_7);
            };
            if ((_local_10 + _local_7) > _arg_1.boundMaxZ)
            {
                _arg_1.boundMaxZ = (_local_10 + _local_7);
            };
        }


    }
}//package alternativa.engine3d.objects