package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Vertex;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Face;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.materials.Material;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.objects.BSP;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class BSP extends Object3D 
    {

        public var clipping:int = 2;
        public var threshold:Number = 0.01;
        public var splitAnalysis:Boolean = true;
        alternativa3d var vertexList:Vertex;
        alternativa3d var root:Node;
        alternativa3d var faces:Vector.<Face> = new Vector.<Face>();
        alternativa3d var vertexBuffer:VertexBufferResource;
        alternativa3d var indexBuffer:IndexBufferResource;
        alternativa3d var numTriangles:int;


        public function createTree(_arg_1:Mesh, _arg_2:Boolean=false):void
        {
            this.destroyTree();
            if ((!(_arg_2)))
            {
                _arg_1 = (_arg_1.clone() as Mesh);
            };
            var _local_3:Face = _arg_1.faceList;
            this.vertexList = _arg_1.vertexList;
            _arg_1.faceList = null;
            _arg_1.vertexList = null;
            var _local_4:Vertex = this.vertexList;
            while (_local_4 != null)
            {
                _local_4.transformId = 0;
                _local_4.id = null;
                _local_4 = _local_4.next;
            };
            var _local_5:int;
            var _local_6:Face = _local_3;
            while (_local_6 != null)
            {
                _local_6.calculateBestSequenceAndNormal();
                _local_6.id = null;
                this.faces[_local_5] = _local_6;
                _local_5++;
                _local_6 = _local_6.next;
            };
            if (_local_3 != null)
            {
                this.root = this.createNode(_local_3);
            };
            calculateBounds();
        }

        public function destroyTree():void
        {
            this.deleteResources();
            this.vertexList = null;
            if (this.root != null)
            {
                this.destroyNode(this.root);
                this.root = null;
            };
            this.faces.length = 0;
        }

        public function setMaterialToAllFaces(_arg_1:Material):void
        {
            var _local_4:Face;
            this.deleteResources();
            var _local_2:int = this.faces.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = this.faces[_local_3];
                _local_4.material = _arg_1;
                _local_3++;
            };
            if (this.root != null)
            {
                this.setMaterialToNode(this.root, _arg_1);
            };
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            if ((((!(_arg_3 == null)) && (_arg_3[this])) || (this.root == null)))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            return (this.intersectRayNode(this.root, _arg_1.x, _arg_1.y, _arg_1.z, _arg_2.x, _arg_2.y, _arg_2.z));
        }

        private function intersectRayNode(_arg_1:Node, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number):RayIntersectionData
        {
            var _local_8:RayIntersectionData;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Face;
            var _local_19:Wrapper;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_9:Number = _arg_1.normalX;
            var _local_10:Number = _arg_1.normalY;
            var _local_11:Number = _arg_1.normalZ;
            var _local_12:Number = ((((_local_9 * _arg_2) + (_local_10 * _arg_3)) + (_local_11 * _arg_4)) - _arg_1.offset);
            if (_local_12 > 0)
            {
                if (_arg_1.positive != null)
                {
                    _local_8 = this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                    if (_local_8 != null)
                    {
                        return (_local_8);
                    };
                };
                _local_13 = (((_arg_5 * _local_9) + (_arg_6 * _local_10)) + (_arg_7 * _local_11));
                if (_local_13 < 0)
                {
                    _local_14 = (-(_local_12) / _local_13);
                    _local_15 = (_arg_2 + (_arg_5 * _local_14));
                    _local_16 = (_arg_3 + (_arg_6 * _local_14));
                    _local_17 = (_arg_4 + (_arg_7 * _local_14));
                    _local_18 = _arg_1.faceList;
                    while (_local_18 != null)
                    {
                        _local_19 = _local_18.wrapper;
                        while (_local_19 != null)
                        {
                            _local_20 = _local_19.vertex;
                            _local_21 = ((_local_19.next != null) ? _local_19.next.vertex : _local_18.wrapper.vertex);
                            _local_22 = (_local_21.x - _local_20.x);
                            _local_23 = (_local_21.y - _local_20.y);
                            _local_24 = (_local_21.z - _local_20.z);
                            _local_25 = (_local_15 - _local_20.x);
                            _local_26 = (_local_16 - _local_20.y);
                            _local_27 = (_local_17 - _local_20.z);
                            if ((((((_local_27 * _local_23) - (_local_26 * _local_24)) * _local_9) + (((_local_25 * _local_24) - (_local_27 * _local_22)) * _local_10)) + (((_local_26 * _local_22) - (_local_25 * _local_23)) * _local_11)) < 0) break;
                            _local_19 = _local_19.next;
                        };
                        if (_local_19 == null)
                        {
                            _local_8 = new RayIntersectionData();
                            _local_8.object = this;
                            _local_8.face = _local_18;
                            _local_8.point = new Vector3D(_local_15, _local_16, _local_17);
                            _local_8.uv = _local_18.getUV(_local_8.point);
                            _local_8.time = _local_14;
                            return (_local_8);
                        };
                        _local_18 = _local_18.next;
                    };
                    if (_arg_1.negative != null)
                    {
                        return (this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
                    };
                };
            } else
            {
                if (_arg_1.negative != null)
                {
                    _local_8 = this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                    if (_local_8 != null)
                    {
                        return (_local_8);
                    };
                };
                if (((!(_arg_1.positive == null)) && ((((_arg_5 * _local_9) + (_arg_6 * _local_10)) + (_arg_7 * _local_11)) > 0)))
                {
                    return (this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
                };
            };
            return (null);
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            return ((this.root != null) ? this.checkIntersectionNode(this.root, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7) : false);
        }

        private function checkIntersectionNode(_arg_1:Node, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Boolean
        {
            var _local_9:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Face;
            var _local_19:Wrapper;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_10:Number = _arg_1.normalX;
            var _local_11:Number = _arg_1.normalY;
            var _local_12:Number = _arg_1.normalZ;
            var _local_13:Number = ((((_local_10 * _arg_2) + (_local_11 * _arg_3)) + (_local_12 * _arg_4)) - _arg_1.offset);
            if (_local_13 > 0)
            {
                _local_9 = (((_arg_5 * _local_10) + (_arg_6 * _local_11)) + (_arg_7 * _local_12));
                if (_local_9 < 0)
                {
                    _local_14 = (-(_local_13) / _local_9);
                    if (_local_14 < _arg_8)
                    {
                        _local_15 = (_arg_2 + (_arg_5 * _local_14));
                        _local_16 = (_arg_3 + (_arg_6 * _local_14));
                        _local_17 = (_arg_4 + (_arg_7 * _local_14));
                        _local_18 = _arg_1.faceList;
                        while (_local_18 != null)
                        {
                            _local_19 = _local_18.wrapper;
                            while (_local_19 != null)
                            {
                                _local_20 = _local_19.vertex;
                                _local_21 = ((_local_19.next != null) ? _local_19.next.vertex : _local_18.wrapper.vertex);
                                _local_22 = (_local_21.x - _local_20.x);
                                _local_23 = (_local_21.y - _local_20.y);
                                _local_24 = (_local_21.z - _local_20.z);
                                _local_25 = (_local_15 - _local_20.x);
                                _local_26 = (_local_16 - _local_20.y);
                                _local_27 = (_local_17 - _local_20.z);
                                if ((((((_local_27 * _local_23) - (_local_26 * _local_24)) * _local_10) + (((_local_25 * _local_24) - (_local_27 * _local_22)) * _local_11)) + (((_local_26 * _local_22) - (_local_25 * _local_23)) * _local_12)) < 0) break;
                                _local_19 = _local_19.next;
                            };
                            if (_local_19 == null)
                            {
                                return (true);
                            };
                            _local_18 = _local_18.next;
                        };
                        if (((!(_arg_1.negative == null)) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8))))
                        {
                            return (true);
                        };
                    };
                };
                return ((!(_arg_1.positive == null)) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8)));
            };
            if (((!(_arg_1.negative == null)) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8))))
            {
                return (true);
            };
            if (_arg_1.positive != null)
            {
                _local_9 = (((_arg_5 * _local_10) + (_arg_6 * _local_11)) + (_arg_7 * _local_12));
                return (((_local_9 > 0) && ((-(_local_13) / _local_9) < _arg_8)) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8)));
            };
            return (false);
        }

        override alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
            if ((((!(_arg_7 == null)) && (_arg_7[this])) || (this.root == null)))
            {
                return;
            };
            var _local_8:Vector3D = calculateSphere(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if ((!(boundIntersectSphere(_local_8, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return;
            };
            this.collectPlanesNode(this.root, _local_8, _arg_6);
        }

        private function collectPlanesNode(_arg_1:Node, _arg_2:Vector3D, _arg_3:Vector.<Face>):void
        {
            var _local_5:Face;
            var _local_6:Wrapper;
            var _local_7:Vertex;
            var _local_4:Number = ((((_arg_1.normalX * _arg_2.x) + (_arg_1.normalY * _arg_2.y)) + (_arg_1.normalZ * _arg_2.z)) - _arg_1.offset);
            if (_local_4 >= _arg_2.w)
            {
                if (_arg_1.positive != null)
                {
                    this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3);
                };
            } else
            {
                if (_local_4 <= -(_arg_2.w))
                {
                    if (_arg_1.negative != null)
                    {
                        this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3);
                    };
                } else
                {
                    _local_5 = _arg_1.faceList;
                    while (_local_5 != null)
                    {
                        _local_6 = _local_5.wrapper;
                        while (_local_6 != null)
                        {
                            _local_7 = _local_6.vertex;
                            _local_7.cameraX = ((((ma * _local_7.x) + (mb * _local_7.y)) + (mc * _local_7.z)) + md);
                            _local_7.cameraY = ((((me * _local_7.x) + (mf * _local_7.y)) + (mg * _local_7.z)) + mh);
                            _local_7.cameraZ = ((((mi * _local_7.x) + (mj * _local_7.y)) + (mk * _local_7.z)) + ml);
                            _local_6 = _local_6.next;
                        };
                        _arg_3.push(_local_5);
                        _local_5 = _local_5.next;
                    };
                    if (_arg_1.positive != null)
                    {
                        this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3);
                    };
                    if (_arg_1.negative != null)
                    {
                        this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3);
                    };
                };
            };
        }

        override public function clone():Object3D
        {
            var _local_1:BSP = new BSP();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_8:Vertex;
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Wrapper;
            var _local_12:Wrapper;
            var _local_13:Wrapper;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:BSP = (_arg_1 as BSP);
            this.clipping = _local_2.clipping;
            this.threshold = _local_2.threshold;
            this.splitAnalysis = _local_2.splitAnalysis;
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_8 = new Vertex();
                _local_8.x = _local_3.x;
                _local_8.y = _local_3.y;
                _local_8.z = _local_3.z;
                _local_8.u = _local_3.u;
                _local_8.v = _local_3.v;
                _local_8.normalX = _local_3.normalX;
                _local_8.normalY = _local_3.normalY;
                _local_8.normalZ = _local_3.normalZ;
                _local_3.value = _local_8;
                if (_local_4 != null)
                {
                    _local_4.next = _local_8;
                } else
                {
                    this.vertexList = _local_8;
                };
                _local_4 = _local_8;
                _local_3 = _local_3.next;
            };
            var _local_5:Dictionary = new Dictionary();
            var _local_6:int = _local_2.faces.length;
            var _local_7:int;
            while (_local_7 < _local_6)
            {
                _local_9 = _local_2.faces[_local_7];
                _local_10 = new Face();
                _local_10.material = _local_9.material;
                _local_10.smoothingGroups = _local_9.smoothingGroups;
                _local_10.normalX = _local_9.normalX;
                _local_10.normalY = _local_9.normalY;
                _local_10.normalZ = _local_9.normalZ;
                _local_10.offset = _local_9.offset;
                _local_11 = null;
                _local_12 = _local_9.wrapper;
                while (_local_12 != null)
                {
                    _local_13 = new Wrapper();
                    _local_13.vertex = _local_12.vertex.value;
                    if (_local_11 != null)
                    {
                        _local_11.next = _local_13;
                    } else
                    {
                        _local_10.wrapper = _local_13;
                    };
                    _local_11 = _local_13;
                    _local_12 = _local_12.next;
                };
                this.faces[_local_7] = _local_10;
                _local_5[_local_9] = _local_10;
                _local_7++;
            };
            if (_local_2.root != null)
            {
                this.root = _local_2.cloneNode(_local_2.root, _local_5);
            };
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_3.value = null;
                _local_3 = _local_3.next;
            };
        }

        private function cloneNode(_arg_1:Node, _arg_2:Dictionary):Node
        {
            var _local_4:Face;
            var _local_6:Face;
            var _local_7:Wrapper;
            var _local_8:Wrapper;
            var _local_9:Wrapper;
            var _local_3:Node = new Node();
            var _local_5:Face = _arg_1.faceList;
            while (_local_5 != null)
            {
                _local_6 = _arg_2[_local_5];
                if (_local_6 == null)
                {
                    _local_6 = new Face();
                    _local_6.material = _local_5.material;
                    _local_6.normalX = _local_5.normalX;
                    _local_6.normalY = _local_5.normalY;
                    _local_6.normalZ = _local_5.normalZ;
                    _local_6.offset = _local_5.offset;
                    _local_7 = null;
                    _local_8 = _local_5.wrapper;
                    while (_local_8 != null)
                    {
                        _local_9 = new Wrapper();
                        _local_9.vertex = _local_8.vertex.value;
                        if (_local_7 != null)
                        {
                            _local_7.next = _local_9;
                        } else
                        {
                            _local_6.wrapper = _local_9;
                        };
                        _local_7 = _local_9;
                        _local_8 = _local_8.next;
                    };
                };
                if (_local_3.faceList != null)
                {
                    _local_4.next = _local_6;
                } else
                {
                    _local_3.faceList = _local_6;
                };
                _local_4 = _local_6;
                _local_5 = _local_5.next;
            };
            _local_3.normalX = _arg_1.normalX;
            _local_3.normalY = _arg_1.normalY;
            _local_3.normalZ = _arg_1.normalZ;
            _local_3.offset = _arg_1.offset;
            if (_arg_1.negative != null)
            {
                _local_3.negative = this.cloneNode(_arg_1.negative, _arg_2);
            };
            if (_arg_1.positive != null)
            {
                _local_3.positive = this.cloneNode(_arg_1.positive, _arg_2);
            };
            return (_local_3);
        }

        private function setMaterialToNode(_arg_1:Node, _arg_2:Material):void
        {
            var _local_3:Face = _arg_1.faceList;
            while (_local_3 != null)
            {
                _local_3.material = _arg_2;
                _local_3 = _local_3.next;
            };
            if (_arg_1.negative != null)
            {
                this.setMaterialToNode(_arg_1.negative, _arg_2);
            };
            if (_arg_1.positive != null)
            {
                this.setMaterialToNode(_arg_1.positive, _arg_2);
            };
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_4:Face;
            var _local_5:Face;
            var _local_6:Face;
            var _local_7:Face;
            var _local_8:Vertex;
            if (this.root == null)
            {
                return;
            };
            if (this.clipping == 0)
            {
                if ((culling & 0x01))
                {
                    return;
                };
                culling = 0;
            };
            this.prepareResources();
            if ((useDepth = (((!(_arg_1.view.constrained)) && ((((_arg_1.softTransparency) && (_arg_1.softTransparencyStrength > 0)) || ((_arg_1.ssao) && (_arg_1.ssaoStrength > 0))) || ((_arg_1.deferredLighting) && (_arg_1.deferredLightingStrength > 0)))) && (concatenatedAlpha >= depthMapAlphaThreshold))))
            {
                _arg_1.depthObjects[_arg_1.depthCount] = this;
                _arg_1.depthCount++;
            };
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            var _local_3:Face = this.faces[0];
            if (((((concatenatedAlpha >= 1) && (concatenatedBlendMode == "normal")) && (!(_local_3.material == null))) && ((!(_local_3.material.transparent)) || (_local_3.material.alphaTestThreshold > 0))))
            {
                _arg_1.addOpaque(_local_3.material, this.vertexBuffer, this.indexBuffer, 0, this.numTriangles, this);
                if (_local_2 > 0)
                {
                    if ((_local_2 & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, null, 0xFFFFFF);
                    };
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
            } else
            {
                if (transformId > 0x1DCD6500)
                {
                    transformId = 0;
                    _local_8 = this.vertexList;
                    while (_local_8 != null)
                    {
                        _local_8.transformId = 0;
                        _local_8 = _local_8.next;
                    };
                };
                transformId++;
                calculateInverseMatrix();
                _local_4 = this.collectNode(this.root);
                if (_local_4 == null)
                {
                    return;
                };
                if (culling > 0)
                {
                    if (this.clipping == 1)
                    {
                        _local_4 = _arg_1.cull(_local_4, culling);
                    } else
                    {
                        _local_4 = _arg_1.clip(_local_4, culling);
                    };
                    if (_local_4 == null)
                    {
                        return;
                    };
                };
                if (_local_2 > 0)
                {
                    if ((_local_2 & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, _local_4, 0xFFFFFF);
                    };
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
                _local_7 = _local_4;
                while (_local_7 != null)
                {
                    _local_5 = _local_7.processNext;
                    if (((_local_5 == null) || (!(_local_5.material == _local_4.material))))
                    {
                        _local_7.processNext = null;
                        if (_local_4.material != null)
                        {
                            _local_4.processNegative = _local_6;
                            _local_6 = _local_4;
                        } else
                        {
                            while (_local_4 != null)
                            {
                                _local_7 = _local_4.processNext;
                                _local_4.processNext = null;
                                _local_4 = _local_7;
                            };
                        };
                        _local_4 = _local_5;
                    };
                    _local_7 = _local_5;
                };
                _local_4 = _local_6;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.processNegative;
                    _local_4.processNegative = null;
                    _arg_1.addTransparent(_local_4, this);
                    _local_4 = _local_5;
                };
            };
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
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_4:Face;
            var _local_5:Vertex;
            if (this.root == null)
            {
                return (null);
            };
            if (this.clipping == 0)
            {
                if ((culling & 0x01))
                {
                    return (null);
                };
                culling = 0;
            };
            this.prepareResources();
            if ((useDepth = (((!(_arg_1.view.constrained)) && ((((_arg_1.softTransparency) && (_arg_1.softTransparencyStrength > 0)) || ((_arg_1.ssao) && (_arg_1.ssaoStrength > 0))) || ((_arg_1.deferredLighting) && (_arg_1.deferredLightingStrength > 0)))) && (concatenatedAlpha >= depthMapAlphaThreshold))))
            {
                _arg_1.depthObjects[_arg_1.depthCount] = this;
                _arg_1.depthCount++;
            };
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            var _local_3:Face = this.faces[0];
            if (((((concatenatedAlpha >= 1) && (concatenatedBlendMode == "normal")) && (!(_local_3.material == null))) && ((!(_local_3.material.transparent)) || (_local_3.material.alphaTestThreshold > 0))))
            {
                _arg_1.addOpaque(_local_3.material, this.vertexBuffer, this.indexBuffer, 0, this.numTriangles, this);
                if (_local_2 > 0)
                {
                    if ((_local_2 & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, null, 0xFFFFFF);
                    };
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
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
                return (null);
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_5 = this.vertexList;
                while (_local_5 != null)
                {
                    _local_5.transformId = 0;
                    _local_5 = _local_5.next;
                };
            };
            transformId++;
            calculateInverseMatrix();
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
            _local_4 = this.prepareNode(this.root, culling, _arg_1);
            if (_local_4 != null)
            {
                return (VG.create(this, _local_4, 3, _local_2, false));
            };
            return (null);
        }

        alternativa3d function prepareResources():void
        {
            var _local_1:Vector.<Number>;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Vertex;
            var _local_5:Vector.<uint>;
            var _local_6:int;
            var _local_7:Face;
            var _local_8:Wrapper;
            var _local_9:uint;
            var _local_10:uint;
            var _local_11:uint;
            if (this.vertexBuffer == null)
            {
                _local_1 = new Vector.<Number>();
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = this.vertexList;
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
                this.vertexBuffer = new VertexBufferResource(_local_1, 8);
                _local_5 = new Vector.<uint>();
                _local_6 = 0;
                this.numTriangles = 0;
                for each (_local_7 in this.faces)
                {
                    _local_8 = _local_7.wrapper;
                    _local_9 = _local_8.vertex.index;
                    _local_8 = _local_8.next;
                    _local_10 = _local_8.vertex.index;
                    _local_8 = _local_8.next;
                    while (_local_8 != null)
                    {
                        _local_11 = _local_8.vertex.index;
                        _local_5[_local_6] = _local_9;
                        _local_6++;
                        _local_5[_local_6] = _local_10;
                        _local_6++;
                        _local_5[_local_6] = _local_11;
                        _local_6++;
                        _local_10 = _local_11;
                        this.numTriangles++;
                        _local_8 = _local_8.next;
                    };
                };
                this.indexBuffer = new IndexBufferResource(_local_5);
            };
        }

        alternativa3d function deleteResources():void
        {
            if (this.vertexBuffer != null)
            {
                this.vertexBuffer.dispose();
                this.vertexBuffer = null;
                this.indexBuffer.dispose();
                this.indexBuffer = null;
                this.numTriangles = 0;
            };
        }

        private function collectNode(_arg_1:Node, _arg_2:Face=null):Face
        {
            var _local_3:Face;
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            if ((((_arg_1.normalX * imd) + (_arg_1.normalY * imh)) + (_arg_1.normalZ * iml)) > _arg_1.offset)
            {
                if (_arg_1.positive != null)
                {
                    _arg_2 = this.collectNode(_arg_1.positive, _arg_2);
                };
                _local_3 = _arg_1.faceList;
                while (_local_3 != null)
                {
                    _local_4 = _local_3.wrapper;
                    while (_local_4 != null)
                    {
                        _local_5 = _local_4.vertex;
                        if (_local_5.transformId != transformId)
                        {
                            _local_6 = _local_5.x;
                            _local_7 = _local_5.y;
                            _local_8 = _local_5.z;
                            _local_5.cameraX = ((((ma * _local_6) + (mb * _local_7)) + (mc * _local_8)) + md);
                            _local_5.cameraY = ((((me * _local_6) + (mf * _local_7)) + (mg * _local_8)) + mh);
                            _local_5.cameraZ = ((((mi * _local_6) + (mj * _local_7)) + (mk * _local_8)) + ml);
                            _local_5.transformId = transformId;
                            _local_5.drawId = 0;
                        };
                        _local_4 = _local_4.next;
                    };
                    _local_3.processNext = _arg_2;
                    _arg_2 = _local_3;
                    _local_3 = _local_3.next;
                };
                if (_arg_1.negative != null)
                {
                    _arg_2 = this.collectNode(_arg_1.negative, _arg_2);
                };
            } else
            {
                if (_arg_1.negative != null)
                {
                    _arg_2 = this.collectNode(_arg_1.negative, _arg_2);
                };
                if (_arg_1.positive != null)
                {
                    _arg_2 = this.collectNode(_arg_1.positive, _arg_2);
                };
            };
            return (_arg_2);
        }

        private function prepareNode(_arg_1:Node, _arg_2:int, _arg_3:Camera3D):Face
        {
            var _local_4:Face;
            var _local_5:Wrapper;
            var _local_8:Face;
            var _local_9:Vertex;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Vertex;
            var _local_14:Vertex;
            var _local_15:Vertex;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            if ((((imd * _arg_1.normalX) + (imh * _arg_1.normalY)) + (iml * _arg_1.normalZ)) > _arg_1.offset)
            {
                _local_4 = _arg_1.faceList;
                _local_8 = _local_4;
                while (_local_8 != null)
                {
                    _local_5 = _local_8.wrapper;
                    while (_local_5 != null)
                    {
                        _local_9 = _local_5.vertex;
                        if (_local_9.transformId != transformId)
                        {
                            _local_10 = _local_9.x;
                            _local_11 = _local_9.y;
                            _local_12 = _local_9.z;
                            _local_9.cameraX = ((((ma * _local_10) + (mb * _local_11)) + (mc * _local_12)) + md);
                            _local_9.cameraY = ((((me * _local_10) + (mf * _local_11)) + (mg * _local_12)) + mh);
                            _local_9.cameraZ = ((((mi * _local_10) + (mj * _local_11)) + (mk * _local_12)) + ml);
                            _local_9.transformId = transformId;
                            _local_9.drawId = 0;
                        };
                        _local_5 = _local_5.next;
                    };
                    _local_8.processNext = _local_8.next;
                    _local_8 = _local_8.next;
                };
                if (_arg_2 > 0)
                {
                    if (this.clipping == 1)
                    {
                        _local_4 = _arg_3.cull(_local_4, _arg_2);
                    } else
                    {
                        _local_4 = _arg_3.clip(_local_4, _arg_2);
                    };
                };
            };
            var _local_6:Face = ((_arg_1.negative != null) ? this.prepareNode(_arg_1.negative, _arg_2, _arg_3) : null);
            var _local_7:Face = ((_arg_1.positive != null) ? this.prepareNode(_arg_1.positive, _arg_2, _arg_3) : null);
            if (((!(_local_4 == null)) || ((!(_local_6 == null)) && (!(_local_7 == null)))))
            {
                if (_local_4 == null)
                {
                    _local_4 = _arg_1.faceList.create();
                    _arg_3.lastFace.next = _local_4;
                    _arg_3.lastFace = _local_4;
                };
                _local_5 = _arg_1.faceList.wrapper;
                _local_13 = _local_5.vertex;
                _local_5 = _local_5.next;
                _local_14 = _local_5.vertex;
                _local_5 = _local_5.next;
                _local_15 = _local_5.vertex;
                if (_local_13.transformId != transformId)
                {
                    _local_13.cameraX = ((((ma * _local_13.x) + (mb * _local_13.y)) + (mc * _local_13.z)) + md);
                    _local_13.cameraY = ((((me * _local_13.x) + (mf * _local_13.y)) + (mg * _local_13.z)) + mh);
                    _local_13.cameraZ = ((((mi * _local_13.x) + (mj * _local_13.y)) + (mk * _local_13.z)) + ml);
                    _local_13.transformId = transformId;
                    _local_13.drawId = 0;
                };
                if (_local_14.transformId != transformId)
                {
                    _local_14.cameraX = ((((ma * _local_14.x) + (mb * _local_14.y)) + (mc * _local_14.z)) + md);
                    _local_14.cameraY = ((((me * _local_14.x) + (mf * _local_14.y)) + (mg * _local_14.z)) + mh);
                    _local_14.cameraZ = ((((mi * _local_14.x) + (mj * _local_14.y)) + (mk * _local_14.z)) + ml);
                    _local_14.transformId = transformId;
                    _local_14.drawId = 0;
                };
                if (_local_15.transformId != transformId)
                {
                    _local_15.cameraX = ((((ma * _local_15.x) + (mb * _local_15.y)) + (mc * _local_15.z)) + md);
                    _local_15.cameraY = ((((me * _local_15.x) + (mf * _local_15.y)) + (mg * _local_15.z)) + mh);
                    _local_15.cameraZ = ((((mi * _local_15.x) + (mj * _local_15.y)) + (mk * _local_15.z)) + ml);
                    _local_15.transformId = transformId;
                    _local_15.drawId = 0;
                };
                _local_16 = (_local_14.cameraX - _local_13.cameraX);
                _local_17 = (_local_14.cameraY - _local_13.cameraY);
                _local_18 = (_local_14.cameraZ - _local_13.cameraZ);
                _local_19 = (_local_15.cameraX - _local_13.cameraX);
                _local_20 = (_local_15.cameraY - _local_13.cameraY);
                _local_21 = (_local_15.cameraZ - _local_13.cameraZ);
                _local_22 = ((_local_21 * _local_17) - (_local_20 * _local_18));
                _local_23 = ((_local_19 * _local_18) - (_local_21 * _local_16));
                _local_24 = ((_local_20 * _local_16) - (_local_19 * _local_17));
                _local_25 = (((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24));
                if (_local_25 > 0)
                {
                    _local_25 = (1 / Math.sqrt(length));
                    _local_22 = (_local_22 * _local_25);
                    _local_23 = (_local_23 * _local_25);
                    _local_24 = (_local_24 * _local_25);
                };
                _local_4.normalX = _local_22;
                _local_4.normalY = _local_23;
                _local_4.normalZ = _local_24;
                _local_4.offset = (((_local_13.cameraX * _local_22) + (_local_13.cameraY * _local_23)) + (_local_13.cameraZ * _local_24));
                _local_4.processNegative = _local_6;
                _local_4.processPositive = _local_7;
            } else
            {
                _local_4 = ((_local_6 != null) ? _local_6 : _local_7);
            };
            return (_local_4);
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            var _local_3:Vertex = this.vertexList;
            while (_local_3 != null)
            {
                if (_arg_2 != null)
                {
                    _local_3.cameraX = ((((_arg_2.ma * _local_3.x) + (_arg_2.mb * _local_3.y)) + (_arg_2.mc * _local_3.z)) + _arg_2.md);
                    _local_3.cameraY = ((((_arg_2.me * _local_3.x) + (_arg_2.mf * _local_3.y)) + (_arg_2.mg * _local_3.z)) + _arg_2.mh);
                    _local_3.cameraZ = ((((_arg_2.mi * _local_3.x) + (_arg_2.mj * _local_3.y)) + (_arg_2.mk * _local_3.z)) + _arg_2.ml);
                } else
                {
                    _local_3.cameraX = _local_3.x;
                    _local_3.cameraY = _local_3.y;
                    _local_3.cameraZ = _local_3.z;
                };
                if (_local_3.cameraX < _arg_1.boundMinX)
                {
                    _arg_1.boundMinX = _local_3.cameraX;
                };
                if (_local_3.cameraX > _arg_1.boundMaxX)
                {
                    _arg_1.boundMaxX = _local_3.cameraX;
                };
                if (_local_3.cameraY < _arg_1.boundMinY)
                {
                    _arg_1.boundMinY = _local_3.cameraY;
                };
                if (_local_3.cameraY > _arg_1.boundMaxY)
                {
                    _arg_1.boundMaxY = _local_3.cameraY;
                };
                if (_local_3.cameraZ < _arg_1.boundMinZ)
                {
                    _arg_1.boundMinZ = _local_3.cameraZ;
                };
                if (_local_3.cameraZ > _arg_1.boundMaxZ)
                {
                    _arg_1.boundMaxZ = _local_3.cameraZ;
                };
                _local_3 = _local_3.next;
            };
        }

        override alternativa3d function split(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):Vector.<Object3D>
        {
            var _local_9:Vertex;
            var _local_10:Vertex;
            var _local_14:Face;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Face;
            var _local_22:Face;
            var _local_23:Face;
            var _local_24:Wrapper;
            var _local_25:Vertex;
            var _local_26:Vertex;
            var _local_27:Vertex;
            var _local_28:Boolean;
            var _local_29:Boolean;
            var _local_30:Face;
            var _local_31:Face;
            var _local_32:Wrapper;
            var _local_33:Wrapper;
            var _local_34:Wrapper;
            var _local_35:Number;
            var _local_36:Vertex;
            var _local_5:Vector.<Object3D> = new Vector.<Object3D>(2);
            var _local_6:Vector3D = calculatePlane(_arg_1, _arg_2, _arg_3);
            var _local_7:Number = (_local_6.w - _arg_4);
            var _local_8:Number = (_local_6.w + _arg_4);
            _local_9 = this.vertexList;
            while (_local_9 != null)
            {
                _local_10 = _local_9.next;
                _local_9.next = null;
                _local_9.offset = (((_local_9.x * _local_6.x) + (_local_9.y * _local_6.y)) + (_local_9.z * _local_6.z));
                if (((_local_9.offset >= _local_7) && (_local_9.offset <= _local_8)))
                {
                    _local_9.value = new Vertex();
                    _local_9.value.x = _local_9.x;
                    _local_9.value.y = _local_9.y;
                    _local_9.value.z = _local_9.z;
                    _local_9.value.u = _local_9.u;
                    _local_9.value.v = _local_9.v;
                    _local_9.value.normalX = _local_9.normalX;
                    _local_9.value.normalY = _local_9.normalY;
                    _local_9.value.normalZ = _local_9.normalZ;
                };
                _local_9.transformId = 0;
                _local_9 = _local_10;
            };
            this.vertexList = null;
            if (this.root != null)
            {
                this.destroyNode(this.root);
                this.root = null;
            };
            var _local_11:Vector.<Face> = this.faces;
            this.faces = new Vector.<Face>();
            var _local_12:BSP = (this.clone() as BSP);
            var _local_13:BSP = (this.clone() as BSP);
            var _local_18:int;
            var _local_19:int;
            var _local_20:int = _local_11.length;
            var _local_21:int;
            while (_local_21 < _local_20)
            {
                _local_22 = _local_11[_local_21];
                _local_23 = _local_22.next;
                _local_24 = _local_22.wrapper;
                _local_25 = _local_24.vertex;
                _local_24 = _local_24.next;
                _local_26 = _local_24.vertex;
                _local_24 = _local_24.next;
                _local_27 = _local_24.vertex;
                _local_28 = (((_local_25.offset < _local_7) || (_local_26.offset < _local_7)) || (_local_27.offset < _local_7));
                _local_29 = (((_local_25.offset > _local_8) || (_local_26.offset > _local_8)) || (_local_27.offset > _local_8));
                _local_24 = _local_24.next;
                while (_local_24 != null)
                {
                    _local_9 = _local_24.vertex;
                    if (_local_9.offset < _local_7)
                    {
                        _local_28 = true;
                    } else
                    {
                        if (_local_9.offset > _local_8)
                        {
                            _local_29 = true;
                        };
                    };
                    _local_24 = _local_24.next;
                };
                if ((!(_local_28)))
                {
                    if (_local_17 != null)
                    {
                        _local_17.next = _local_22;
                    } else
                    {
                        _local_16 = _local_22;
                    };
                    _local_17 = _local_22;
                    _local_13.faces[_local_19] = _local_22;
                    _local_19++;
                } else
                {
                    if ((!(_local_29)))
                    {
                        if (_local_15 != null)
                        {
                            _local_15.next = _local_22;
                        } else
                        {
                            _local_14 = _local_22;
                        };
                        _local_15 = _local_22;
                        _local_12.faces[_local_18] = _local_22;
                        _local_18++;
                        _local_24 = _local_22.wrapper;
                        while (_local_24 != null)
                        {
                            if (_local_24.vertex.value != null)
                            {
                                _local_24.vertex = _local_24.vertex.value;
                            };
                            _local_24 = _local_24.next;
                        };
                    } else
                    {
                        _local_30 = new Face();
                        _local_31 = new Face();
                        _local_32 = null;
                        _local_33 = null;
                        _local_24 = _local_22.wrapper.next.next;
                        while (_local_24.next != null)
                        {
                            _local_24 = _local_24.next;
                        };
                        _local_25 = _local_24.vertex;
                        _local_24 = _local_22.wrapper;
                        while (_local_24 != null)
                        {
                            _local_26 = _local_24.vertex;
                            if ((((_local_25.offset < _local_7) && (_local_26.offset > _local_8)) || ((_local_25.offset > _local_8) && (_local_26.offset < _local_7))))
                            {
                                _local_35 = ((_local_6.w - _local_25.offset) / (_local_26.offset - _local_25.offset));
                                _local_9 = new Vertex();
                                _local_9.x = (_local_25.x + ((_local_26.x - _local_25.x) * _local_35));
                                _local_9.y = (_local_25.y + ((_local_26.y - _local_25.y) * _local_35));
                                _local_9.z = (_local_25.z + ((_local_26.z - _local_25.z) * _local_35));
                                _local_9.u = (_local_25.u + ((_local_26.u - _local_25.u) * _local_35));
                                _local_9.v = (_local_25.v + ((_local_26.v - _local_25.v) * _local_35));
                                _local_9.normalX = (_local_25.normalX + ((_local_26.normalX - _local_25.normalX) * _local_35));
                                _local_9.normalY = (_local_25.normalY + ((_local_26.normalY - _local_25.normalY) * _local_35));
                                _local_9.normalZ = (_local_25.normalZ + ((_local_26.normalZ - _local_25.normalZ) * _local_35));
                                _local_34 = new Wrapper();
                                _local_34.vertex = _local_9;
                                if (_local_32 != null)
                                {
                                    _local_32.next = _local_34;
                                } else
                                {
                                    _local_30.wrapper = _local_34;
                                };
                                _local_32 = _local_34;
                                _local_36 = new Vertex();
                                _local_36.x = _local_9.x;
                                _local_36.y = _local_9.y;
                                _local_36.z = _local_9.z;
                                _local_36.u = _local_9.u;
                                _local_36.v = _local_9.v;
                                _local_36.normalX = _local_9.normalX;
                                _local_36.normalY = _local_9.normalY;
                                _local_36.normalZ = _local_9.normalZ;
                                _local_34 = new Wrapper();
                                _local_34.vertex = _local_36;
                                if (_local_33 != null)
                                {
                                    _local_33.next = _local_34;
                                } else
                                {
                                    _local_31.wrapper = _local_34;
                                };
                                _local_33 = _local_34;
                            };
                            if (_local_26.offset < _local_7)
                            {
                                _local_34 = _local_24.create();
                                _local_34.vertex = _local_26;
                                if (_local_32 != null)
                                {
                                    _local_32.next = _local_34;
                                } else
                                {
                                    _local_30.wrapper = _local_34;
                                };
                                _local_32 = _local_34;
                            } else
                            {
                                if (_local_26.offset > _local_8)
                                {
                                    _local_34 = _local_24.create();
                                    _local_34.vertex = _local_26;
                                    if (_local_33 != null)
                                    {
                                        _local_33.next = _local_34;
                                    } else
                                    {
                                        _local_31.wrapper = _local_34;
                                    };
                                    _local_33 = _local_34;
                                } else
                                {
                                    _local_34 = _local_24.create();
                                    _local_34.vertex = _local_26.value;
                                    if (_local_32 != null)
                                    {
                                        _local_32.next = _local_34;
                                    } else
                                    {
                                        _local_30.wrapper = _local_34;
                                    };
                                    _local_32 = _local_34;
                                    _local_34 = _local_24.create();
                                    _local_34.vertex = _local_26;
                                    if (_local_33 != null)
                                    {
                                        _local_33.next = _local_34;
                                    } else
                                    {
                                        _local_31.wrapper = _local_34;
                                    };
                                    _local_33 = _local_34;
                                };
                            };
                            _local_25 = _local_26;
                            _local_24 = _local_24.next;
                        };
                        _local_30.material = _local_22.material;
                        _local_30.calculateBestSequenceAndNormal();
                        if (_local_15 != null)
                        {
                            _local_15.next = _local_30;
                        } else
                        {
                            _local_14 = _local_30;
                        };
                        _local_15 = _local_30;
                        _local_12.faces[_local_18] = _local_30;
                        _local_18++;
                        _local_31.material = _local_22.material;
                        _local_31.calculateBestSequenceAndNormal();
                        if (_local_17 != null)
                        {
                            _local_17.next = _local_31;
                        } else
                        {
                            _local_16 = _local_31;
                        };
                        _local_17 = _local_31;
                        _local_13.faces[_local_19] = _local_31;
                        _local_19++;
                    };
                };
                _local_21++;
            };
            if (_local_15 != null)
            {
                _local_15.next = null;
                _local_12.transformId++;
                _local_12.collectVertices();
                _local_12.root = _local_12.createNode(_local_14);
                _local_12.calculateBounds();
                _local_5[0] = _local_12;
            };
            if (_local_17 != null)
            {
                _local_17.next = null;
                _local_13.transformId++;
                _local_13.collectVertices();
                _local_13.root = _local_13.createNode(_local_16);
                _local_13.calculateBounds();
                _local_5[1] = _local_13;
            };
            return (_local_5);
        }

        private function collectVertices():void
        {
            var _local_3:Face;
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_1:int = this.faces.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                _local_3 = this.faces[_local_2];
                _local_4 = _local_3.wrapper;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.vertex;
                    if (_local_5.transformId != transformId)
                    {
                        _local_5.next = this.vertexList;
                        this.vertexList = _local_5;
                        _local_5.transformId = transformId;
                        _local_5.value = null;
                    };
                    _local_4 = _local_4.next;
                };
                _local_2++;
            };
        }

        private function createNode(_arg_1:Face):Node
        {
            var _local_3:Wrapper;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_21:Face;
            var _local_22:Face;
            var _local_25:Face;
            var _local_26:Face;
            var _local_27:int;
            var _local_28:Face;
            var _local_29:int;
            var _local_30:Face;
            var _local_31:Face;
            var _local_32:Face;
            var _local_33:Face;
            var _local_34:Wrapper;
            var _local_35:Wrapper;
            var _local_36:Wrapper;
            var _local_37:Number;
            var _local_2:Node = new Node();
            var _local_20:Face = _arg_1;
            if (((this.splitAnalysis) && (!(_arg_1.next == null))))
            {
                _local_27 = 2147483647;
                _local_28 = _arg_1;
                while (_local_28 != null)
                {
                    _local_14 = _local_28.normalX;
                    _local_15 = _local_28.normalY;
                    _local_16 = _local_28.normalZ;
                    _local_17 = _local_28.offset;
                    _local_18 = (_local_17 - this.threshold);
                    _local_19 = (_local_17 + this.threshold);
                    _local_29 = 0;
                    _local_30 = _arg_1;
                    while (_local_30 != null)
                    {
                        if (_local_30 != _local_28)
                        {
                            _local_3 = _local_30.wrapper;
                            _local_4 = _local_3.vertex;
                            _local_3 = _local_3.next;
                            _local_5 = _local_3.vertex;
                            _local_3 = _local_3.next;
                            _local_6 = _local_3.vertex;
                            _local_3 = _local_3.next;
                            _local_10 = (((_local_4.x * _local_14) + (_local_4.y * _local_15)) + (_local_4.z * _local_16));
                            _local_11 = (((_local_5.x * _local_14) + (_local_5.y * _local_15)) + (_local_5.z * _local_16));
                            _local_12 = (((_local_6.x * _local_14) + (_local_6.y * _local_15)) + (_local_6.z * _local_16));
                            _local_8 = (((_local_10 < _local_18) || (_local_11 < _local_18)) || (_local_12 < _local_18));
                            _local_9 = (((_local_10 > _local_19) || (_local_11 > _local_19)) || (_local_12 > _local_19));
                            while (_local_3 != null)
                            {
                                _local_7 = _local_3.vertex;
                                _local_13 = (((_local_7.x * _local_14) + (_local_7.y * _local_15)) + (_local_7.z * _local_16));
                                if (_local_13 < _local_18)
                                {
                                    _local_8 = true;
                                    if (_local_9) break;
                                } else
                                {
                                    if (_local_13 > _local_19)
                                    {
                                        _local_9 = true;
                                        if (_local_8) break;
                                    };
                                };
                                _local_3 = _local_3.next;
                            };
                            if (((_local_9) && (_local_8)))
                            {
                                _local_29++;
                                if (_local_29 >= _local_27) break;
                            };
                        };
                        _local_30 = _local_30.next;
                    };
                    if (_local_29 < _local_27)
                    {
                        _local_20 = _local_28;
                        _local_27 = _local_29;
                        if (_local_27 == 0) break;
                    };
                    _local_28 = _local_28.next;
                };
            };
            var _local_23:Face = _local_20;
            var _local_24:Face = _local_20.next;
            _local_14 = _local_20.normalX;
            _local_15 = _local_20.normalY;
            _local_16 = _local_20.normalZ;
            _local_17 = _local_20.offset;
            _local_18 = (_local_17 - this.threshold);
            _local_19 = (_local_17 + this.threshold);
            while (_arg_1 != null)
            {
                if (_arg_1 != _local_20)
                {
                    _local_31 = _arg_1.next;
                    _local_3 = _arg_1.wrapper;
                    _local_4 = _local_3.vertex;
                    _local_3 = _local_3.next;
                    _local_5 = _local_3.vertex;
                    _local_3 = _local_3.next;
                    _local_6 = _local_3.vertex;
                    _local_3 = _local_3.next;
                    _local_10 = (((_local_4.x * _local_14) + (_local_4.y * _local_15)) + (_local_4.z * _local_16));
                    _local_11 = (((_local_5.x * _local_14) + (_local_5.y * _local_15)) + (_local_5.z * _local_16));
                    _local_12 = (((_local_6.x * _local_14) + (_local_6.y * _local_15)) + (_local_6.z * _local_16));
                    _local_8 = (((_local_10 < _local_18) || (_local_11 < _local_18)) || (_local_12 < _local_18));
                    _local_9 = (((_local_10 > _local_19) || (_local_11 > _local_19)) || (_local_12 > _local_19));
                    while (_local_3 != null)
                    {
                        _local_7 = _local_3.vertex;
                        _local_13 = (((_local_7.x * _local_14) + (_local_7.y * _local_15)) + (_local_7.z * _local_16));
                        if (_local_13 < _local_18)
                        {
                            _local_8 = true;
                        } else
                        {
                            if (_local_13 > _local_19)
                            {
                                _local_9 = true;
                            };
                        };
                        _local_7.offset = _local_13;
                        _local_3 = _local_3.next;
                    };
                    if ((!(_local_8)))
                    {
                        if ((!(_local_9)))
                        {
                            if ((((_arg_1.normalX * _local_14) + (_arg_1.normalY * _local_15)) + (_arg_1.normalZ * _local_16)) > 0)
                            {
                                _local_23.next = _arg_1;
                                _local_23 = _arg_1;
                            } else
                            {
                                if (_local_21 != null)
                                {
                                    _local_22.next = _arg_1;
                                } else
                                {
                                    _local_21 = _arg_1;
                                };
                                _local_22 = _arg_1;
                            };
                        } else
                        {
                            if (_local_25 != null)
                            {
                                _local_26.next = _arg_1;
                            } else
                            {
                                _local_25 = _arg_1;
                            };
                            _local_26 = _arg_1;
                        };
                    } else
                    {
                        if ((!(_local_9)))
                        {
                            if (_local_21 != null)
                            {
                                _local_22.next = _arg_1;
                            } else
                            {
                                _local_21 = _arg_1;
                            };
                            _local_22 = _arg_1;
                        } else
                        {
                            _local_4.offset = _local_10;
                            _local_5.offset = _local_11;
                            _local_6.offset = _local_12;
                            _local_32 = new Face();
                            _local_33 = new Face();
                            _local_34 = null;
                            _local_35 = null;
                            _local_3 = _arg_1.wrapper.next.next;
                            while (_local_3.next != null)
                            {
                                _local_3 = _local_3.next;
                            };
                            _local_4 = _local_3.vertex;
                            _local_10 = _local_4.offset;
                            _local_3 = _arg_1.wrapper;
                            while (_local_3 != null)
                            {
                                _local_5 = _local_3.vertex;
                                _local_11 = _local_5.offset;
                                if ((((_local_10 < _local_18) && (_local_11 > _local_19)) || ((_local_10 > _local_19) && (_local_11 < _local_18))))
                                {
                                    _local_37 = ((_local_17 - _local_10) / (_local_11 - _local_10));
                                    _local_7 = new Vertex();
                                    _local_7.next = this.vertexList;
                                    this.vertexList = _local_7;
                                    _local_7.x = (_local_4.x + ((_local_5.x - _local_4.x) * _local_37));
                                    _local_7.y = (_local_4.y + ((_local_5.y - _local_4.y) * _local_37));
                                    _local_7.z = (_local_4.z + ((_local_5.z - _local_4.z) * _local_37));
                                    _local_7.u = (_local_4.u + ((_local_5.u - _local_4.u) * _local_37));
                                    _local_7.v = (_local_4.v + ((_local_5.v - _local_4.v) * _local_37));
                                    _local_7.normalX = (_local_4.normalX + ((_local_5.normalX - _local_4.normalX) * _local_37));
                                    _local_7.normalY = (_local_4.normalY + ((_local_5.normalY - _local_4.normalY) * _local_37));
                                    _local_7.normalZ = (_local_4.normalZ + ((_local_5.normalZ - _local_4.normalZ) * _local_37));
                                    _local_36 = new Wrapper();
                                    _local_36.vertex = _local_7;
                                    if (_local_34 != null)
                                    {
                                        _local_34.next = _local_36;
                                    } else
                                    {
                                        _local_32.wrapper = _local_36;
                                    };
                                    _local_34 = _local_36;
                                    _local_36 = new Wrapper();
                                    _local_36.vertex = _local_7;
                                    if (_local_35 != null)
                                    {
                                        _local_35.next = _local_36;
                                    } else
                                    {
                                        _local_33.wrapper = _local_36;
                                    };
                                    _local_35 = _local_36;
                                };
                                if (_local_11 <= _local_19)
                                {
                                    _local_36 = new Wrapper();
                                    _local_36.vertex = _local_5;
                                    if (_local_34 != null)
                                    {
                                        _local_34.next = _local_36;
                                    } else
                                    {
                                        _local_32.wrapper = _local_36;
                                    };
                                    _local_34 = _local_36;
                                };
                                if (_local_11 >= _local_18)
                                {
                                    _local_36 = new Wrapper();
                                    _local_36.vertex = _local_5;
                                    if (_local_35 != null)
                                    {
                                        _local_35.next = _local_36;
                                    } else
                                    {
                                        _local_33.wrapper = _local_36;
                                    };
                                    _local_35 = _local_36;
                                };
                                _local_4 = _local_5;
                                _local_10 = _local_11;
                                _local_3 = _local_3.next;
                            };
                            _local_32.material = _arg_1.material;
                            _local_32.smoothingGroups = _arg_1.smoothingGroups;
                            _local_32.calculateBestSequenceAndNormal();
                            if (_local_21 != null)
                            {
                                _local_22.next = _local_32;
                            } else
                            {
                                _local_21 = _local_32;
                            };
                            _local_22 = _local_32;
                            _local_33.material = _arg_1.material;
                            _local_33.smoothingGroups = _arg_1.smoothingGroups;
                            _local_33.calculateBestSequenceAndNormal();
                            if (_local_25 != null)
                            {
                                _local_26.next = _local_33;
                            } else
                            {
                                _local_25 = _local_33;
                            };
                            _local_26 = _local_33;
                        };
                    };
                    _arg_1 = _local_31;
                } else
                {
                    _arg_1 = _local_24;
                };
            };
            if (_local_21 != null)
            {
                _local_22.next = null;
                _local_2.negative = this.createNode(_local_21);
            };
            _local_23.next = null;
            _local_2.faceList = _local_20;
            _local_2.normalX = _local_14;
            _local_2.normalY = _local_15;
            _local_2.normalZ = _local_16;
            _local_2.offset = _local_17;
            if (_local_25 != null)
            {
                _local_26.next = null;
                _local_2.positive = this.createNode(_local_25);
            };
            return (_local_2);
        }

        private function destroyNode(_arg_1:Node):void
        {
            var _local_3:Face;
            if (_arg_1.negative != null)
            {
                this.destroyNode(_arg_1.negative);
                _arg_1.negative = null;
            };
            if (_arg_1.positive != null)
            {
                this.destroyNode(_arg_1.positive);
                _arg_1.positive = null;
            };
            var _local_2:Face = _arg_1.faceList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.next;
                _local_2.next = null;
                _local_2 = _local_3;
            };
        }


    }
}//package alternativa.engine3d.objects

import alternativa.engine3d.core.Face;

class Node 
{

    public var negative:Node;
    public var positive:Node;
    public var faceList:Face;
    public var normalX:Number;
    public var normalY:Number;
    public var normalZ:Number;
    public var offset:Number;


}
