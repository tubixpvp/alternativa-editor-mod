package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Face;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Clipping;
    import alternativa.engine3d.core.Sorting;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Wrapper;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import flash.utils.Dictionary;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.core.VG;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class SkyBox extends Mesh 
    {

        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";
        public static const BACK:String = "back";
        public static const FRONT:String = "front";
        public static const BOTTOM:String = "bottom";
        public static const TOP:String = "top";

        private var leftFace:Face;
        private var rightFace:Face;
        private var backFace:Face;
        private var frontFace:Face;
        private var bottomFace:Face;
        private var topFace:Face;
        public var autoSize:Boolean = true;
        alternativa3d var reduceConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);

        public function SkyBox(_arg_1:Number, _arg_2:Material=null, _arg_3:Material=null, _arg_4:Material=null, _arg_5:Material=null, _arg_6:Material=null, _arg_7:Material=null, _arg_8:Number=0)
        {
            _arg_1 = (_arg_1 * 0.5);
            var _local_9:Vertex = this.createVertex(-(_arg_1), -(_arg_1), _arg_1, _arg_8, _arg_8);
            var _local_10:Vertex = this.createVertex(-(_arg_1), -(_arg_1), -(_arg_1), _arg_8, (1 - _arg_8));
            var _local_11:Vertex = this.createVertex(-(_arg_1), _arg_1, -(_arg_1), (1 - _arg_8), (1 - _arg_8));
            var _local_12:Vertex = this.createVertex(-(_arg_1), _arg_1, _arg_1, (1 - _arg_8), _arg_8);
            this.leftFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_2);
            _local_9 = this.createVertex(_arg_1, _arg_1, _arg_1, _arg_8, _arg_8);
            _local_10 = this.createVertex(_arg_1, _arg_1, -(_arg_1), _arg_8, (1 - _arg_8));
            _local_11 = this.createVertex(_arg_1, -(_arg_1), -(_arg_1), (1 - _arg_8), (1 - _arg_8));
            _local_12 = this.createVertex(_arg_1, -(_arg_1), _arg_1, (1 - _arg_8), _arg_8);
            this.rightFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_3);
            _local_9 = this.createVertex(_arg_1, -(_arg_1), _arg_1, _arg_8, _arg_8);
            _local_10 = this.createVertex(_arg_1, -(_arg_1), -(_arg_1), _arg_8, (1 - _arg_8));
            _local_11 = this.createVertex(-(_arg_1), -(_arg_1), -(_arg_1), (1 - _arg_8), (1 - _arg_8));
            _local_12 = this.createVertex(-(_arg_1), -(_arg_1), _arg_1, (1 - _arg_8), _arg_8);
            this.backFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_4);
            _local_9 = this.createVertex(-(_arg_1), _arg_1, _arg_1, _arg_8, _arg_8);
            _local_10 = this.createVertex(-(_arg_1), _arg_1, -(_arg_1), _arg_8, (1 - _arg_8));
            _local_11 = this.createVertex(_arg_1, _arg_1, -(_arg_1), (1 - _arg_8), (1 - _arg_8));
            _local_12 = this.createVertex(_arg_1, _arg_1, _arg_1, (1 - _arg_8), _arg_8);
            this.frontFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_5);
            _local_9 = this.createVertex(-(_arg_1), _arg_1, -(_arg_1), _arg_8, _arg_8);
            _local_10 = this.createVertex(-(_arg_1), -(_arg_1), -(_arg_1), _arg_8, (1 - _arg_8));
            _local_11 = this.createVertex(_arg_1, -(_arg_1), -(_arg_1), (1 - _arg_8), (1 - _arg_8));
            _local_12 = this.createVertex(_arg_1, _arg_1, -(_arg_1), (1 - _arg_8), _arg_8);
            this.bottomFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_6);
            _local_9 = this.createVertex(-(_arg_1), -(_arg_1), _arg_1, _arg_8, _arg_8);
            _local_10 = this.createVertex(-(_arg_1), _arg_1, _arg_1, _arg_8, (1 - _arg_8));
            _local_11 = this.createVertex(_arg_1, _arg_1, _arg_1, (1 - _arg_8), (1 - _arg_8));
            _local_12 = this.createVertex(_arg_1, -(_arg_1), _arg_1, (1 - _arg_8), _arg_8);
            this.topFace = this.createQuad(_local_9, _local_10, _local_11, _local_12, _arg_7);
            calculateBounds();
            calculateFacesNormals(true);
            clipping = Clipping.FACE_CLIPPING;
            sorting = Sorting.NONE;
            shadowMapAlphaThreshold = 100;
        }

        public function getSide(_arg_1:String):Face
        {
            switch (_arg_1)
            {
                case LEFT:
                    return (this.leftFace);
                case RIGHT:
                    return (this.rightFace);
                case BACK:
                    return (this.backFace);
                case FRONT:
                    return (this.frontFace);
                case BOTTOM:
                    return (this.bottomFace);
                case TOP:
                    return (this.topFace);
            };
            return (null);
        }

        public function transformUV(_arg_1:String, _arg_2:Matrix):void
        {
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_6:Point;
            var _local_3:Face = this.getSide(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = _local_3.wrapper;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.vertex;
                    _local_6 = _arg_2.transformPoint(new Point(_local_5.u, _local_5.v));
                    _local_5.u = _local_6.x;
                    _local_5.v = _local_6.y;
                    _local_4 = _local_4.next;
                };
            };
        }

        override public function clone():Object3D
        {
            var _local_1:SkyBox = new SkyBox(0);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:SkyBox = (_arg_1 as SkyBox);
            this.autoSize = _local_2.autoSize;
            var _local_3:Face = _local_2.faceList;
            var _local_4:Face = faceList;
            while (_local_3 != null)
            {
                if (_local_3 == _local_2.leftFace)
                {
                    this.leftFace = _local_4;
                } else
                {
                    if (_local_3 == _local_2.rightFace)
                    {
                        this.rightFace = _local_4;
                    } else
                    {
                        if (_local_3 == _local_2.backFace)
                        {
                            this.backFace = _local_4;
                        } else
                        {
                            if (_local_3 == _local_2.frontFace)
                            {
                                this.frontFace = _local_4;
                            } else
                            {
                                if (_local_3 == _local_2.bottomFace)
                                {
                                    this.bottomFace = _local_4;
                                } else
                                {
                                    if (_local_3 == _local_2.topFace)
                                    {
                                        this.topFace = _local_4;
                                    };
                                };
                            };
                        };
                    };
                };
                _local_3 = _local_3.next;
                _local_4 = _local_4.next;
            };
        }

        private function createVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Vertex
        {
            var _local_6:Vertex = new Vertex();
            _local_6.next = vertexList;
            vertexList = _local_6;
            _local_6.x = _arg_1;
            _local_6.y = _arg_2;
            _local_6.z = _arg_3;
            _local_6.u = _arg_4;
            _local_6.v = _arg_5;
            return (_local_6);
        }

        private function createQuad(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Vertex, _arg_5:Material):Face
        {
            var _local_6:Face = new Face();
            _local_6.material = _arg_5;
            _local_6.next = faceList;
            faceList = _local_6;
            _local_6.wrapper = new Wrapper();
            _local_6.wrapper.vertex = _arg_1;
            _local_6.wrapper.next = new Wrapper();
            _local_6.wrapper.next.vertex = _arg_2;
            _local_6.wrapper.next.next = new Wrapper();
            _local_6.wrapper.next.next.vertex = _arg_3;
            _local_6.wrapper.next.next.next = new Wrapper();
            _local_6.wrapper.next.next.next.vertex = _arg_4;
            return (_local_6);
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            if (faceList == null)
            {
                return;
            };
            if (this.autoSize)
            {
                this.calculateTransform(_arg_1);
            };
            if (clipping == 0)
            {
                if ((culling & 0x01))
                {
                    return;
                };
                culling = 0;
            };
            this.prepareResources();
            this.addOpaque(_arg_1);
            transformConst[0] = ma;
            transformConst[1] = mb;
            transformConst[2] = mc;
            transformConst[3] = md;
            transformConst[4] = me;
            transformConst[5] = mf;
            transformConst[6] = mg;
            transformConst[7] = mh;
            transformConst[8] = mi;
            transformConst[9] = mj;
            transformConst[10] = mk;
            transformConst[11] = ml;
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_2 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
        }

        override alternativa3d function prepareResources():void
        {
            var _local_1:Vector.<Number>;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Vertex;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Face;
            var _local_9:Array;
            var _local_10:Wrapper;
            var _local_11:Dictionary;
            var _local_12:Vector.<uint>;
            var _local_13:int;
            var _local_14:*;
            if (vertexBuffer == null)
            {
                _local_1 = new Vector.<Number>();
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = vertexList;
                while (_local_4 != null)
                {
                    _local_1[_local_2] = _local_4.x;
                    _local_2++;
                    _local_1[_local_2] = _local_4.y;
                    _local_2++;
                    _local_1[_local_2] = _local_4.z;
                    _local_2++;
                    _local_1[_local_2] = _local_4.u;
                    _local_2++;
                    _local_1[_local_2] = _local_4.v;
                    _local_2++;
                    _local_1[_local_2] = _local_4.normalX;
                    _local_2++;
                    _local_1[_local_2] = _local_4.normalY;
                    _local_2++;
                    _local_1[_local_2] = _local_4.normalZ;
                    _local_2++;
                    _local_4.index = _local_3;
                    _local_3++;
                    _local_4 = _local_4.next;
                };
                if (_local_3 > 0)
                {
                    vertexBuffer = new VertexBufferResource(_local_1, 8);
                };
                _local_11 = new Dictionary();
                _local_8 = faceList;
                while (_local_8 != null)
                {
                    if (_local_8.material != null)
                    {
                        _local_9 = _local_11[_local_8.material];
                        if (_local_9 == null)
                        {
                            _local_9 = new Array();
                            _local_11[_local_8.material] = _local_9;
                        };
                        _local_9.push(_local_8);
                    };
                    _local_8 = _local_8.next;
                };
                _local_12 = new Vector.<uint>();
                _local_13 = 0;
                for (_local_14 in _local_11)
                {
                    _local_9 = _local_11[_local_14];
                    opaqueMaterials[opaqueLength] = _local_14;
                    opaqueBegins[opaqueLength] = (numTriangles * 3);
                    for each (_local_8 in _local_9)
                    {
                        _local_10 = _local_8.wrapper;
                        _local_5 = _local_10.vertex.index;
                        _local_10 = _local_10.next;
                        _local_6 = _local_10.vertex.index;
                        _local_10 = _local_10.next;
                        while (_local_10 != null)
                        {
                            _local_7 = _local_10.vertex.index;
                            _local_12[_local_13] = _local_5;
                            _local_13++;
                            _local_12[_local_13] = _local_6;
                            _local_13++;
                            _local_12[_local_13] = _local_7;
                            _local_13++;
                            _local_6 = _local_7;
                            numTriangles++;
                            _local_10 = _local_10.next;
                        };
                    };
                    opaqueNums[opaqueLength] = (numTriangles - (opaqueBegins[opaqueLength] / 3));
                    opaqueLength++;
                };
                if (_local_13 > 0)
                {
                    indexBuffer = new IndexBufferResource(_local_12);
                };
            };
        }

        override alternativa3d function addOpaque(_arg_1:Camera3D):void
        {
            var _local_2:int;
            while (_local_2 < opaqueLength)
            {
                _arg_1.addSky(opaqueMaterials[_local_2], vertexBuffer, indexBuffer, opaqueBegins[_local_2], opaqueNums[_local_2], this);
                _local_2++;
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            this.draw(_arg_1);
            return (null);
        }

        override alternativa3d function cullingInCamera(_arg_1:Camera3D, _arg_2:int):int
        {
            return (super.cullingInCamera(_arg_1, (_arg_2 = (_arg_2 & (~(0x03))))));
        }

        private function calculateTransform(_arg_1:Camera3D):void
        {
            var _local_2:Number = ((((mi * boundMinX) + (mj * boundMinY)) + (mk * boundMinZ)) + ml);
            var _local_3:Number = _local_2;
            _local_2 = ((((mi * boundMaxX) + (mj * boundMinY)) + (mk * boundMinZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMaxX) + (mj * boundMaxY)) + (mk * boundMinZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMinX) + (mj * boundMaxY)) + (mk * boundMinZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMinX) + (mj * boundMinY)) + (mk * boundMaxZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMaxX) + (mj * boundMinY)) + (mk * boundMaxZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMaxX) + (mj * boundMaxY)) + (mk * boundMaxZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            _local_2 = ((((mi * boundMinX) + (mj * boundMaxY)) + (mk * boundMaxZ)) + ml);
            if (_local_2 > _local_3)
            {
                _local_3 = _local_2;
            };
            var _local_4:Number = 1;
            if (_local_3 > _arg_1.farClipping)
            {
                _local_4 = (_arg_1.farClipping / _local_3);
            };
            this.reduceConst[0] = _local_4;
            this.reduceConst[1] = _local_4;
            this.reduceConst[2] = _local_4;
        }


    }
}//package alternativa.engine3d.objects