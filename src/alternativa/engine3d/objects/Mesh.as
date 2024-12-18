package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Face;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Wrapper;
    import flash.utils.Dictionary;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.objects.Mesh;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Mesh extends Object3D 
    {

        public var clipping:int = 2;
        public var sorting:int = 1;
        public var threshold:Number = 0.01;
        alternativa3d var vertexList:Vertex;
        public var faceList:Face;
        alternativa3d var vertexBuffer:VertexBufferResource;
        alternativa3d var indexBuffer:IndexBufferResource;
        alternativa3d var numOpaqueTriangles:int;
        alternativa3d var numTriangles:int;
        protected var opaqueMaterials:Vector.<Material> = new Vector.<Material>();
        protected var opaqueBegins:Vector.<int> = new Vector.<int>();
        protected var opaqueNums:Vector.<int> = new Vector.<int>();
        protected var opaqueLength:int = 0;
        private var transparentList:Face;


        public override function destroy() : void
        {
            

            super.destroy();
        }

        public static function calculateVerticesNormalsBySmoothingGroupsForMeshList(_arg_1:Vector.<Object3D>, _arg_2:Number=0):void
        {
            var _local_3:int;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:*;
            var _local_8:Mesh;
            var _local_9:Face;
            var _local_10:Vertex;
            var _local_11:Wrapper;
            var _local_16:Object3D;
            var _local_17:Vertex;
            var _local_18:Number;
            var _local_19:Face;
            var _local_12:Dictionary = new Dictionary();
            var _local_13:int = _arg_1.length;
            _local_3 = 0;
            while (_local_3 < _local_13)
            {
                _local_8 = (_arg_1[_local_3] as Mesh);
                if (_local_8 != null)
                {
                    _local_8.deleteResources();
                    _local_8.composeMatrix();
                    _local_16 = _local_8;
                    while (_local_16._parent != null)
                    {
                        _local_16 = _local_16._parent;
                        _local_16.composeMatrix();
                        _local_8.appendMatrix(_local_16);
                    };
                    _local_10 = _local_8.vertexList;
                    while (_local_10 != null)
                    {
                        _local_4 = _local_10.x;
                        _local_5 = _local_10.y;
                        _local_6 = _local_10.z;
                        _local_10.x = ((((_local_8.ma * _local_4) + (_local_8.mb * _local_5)) + (_local_8.mc * _local_6)) + _local_8.md);
                        _local_10.y = ((((_local_8.me * _local_4) + (_local_8.mf * _local_5)) + (_local_8.mg * _local_6)) + _local_8.mh);
                        _local_10.z = ((((_local_8.mi * _local_4) + (_local_8.mj * _local_5)) + (_local_8.mk * _local_6)) + _local_8.ml);
                        _local_10 = _local_10.next;
                    };
                    _local_8.calculateNormalsAndRemoveDegenerateFaces();
                    _local_9 = _local_8.faceList;
                    while (_local_9 != null)
                    {
                        if (_local_9.smoothingGroups > 0)
                        {
                            _local_11 = _local_9.wrapper;
                            while (_local_11 != null)
                            {
                                _local_10 = _local_11.vertex;
                                if ((!(_local_12[_local_10])))
                                {
                                    _local_12[_local_10] = new Dictionary();
                                };
                                _local_12[_local_10][_local_9] = true;
                                _local_11 = _local_11.next;
                            };
                        };
                        _local_9 = _local_9.next;
                    };
                };
                _local_3++;
            };
            var _local_14:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_15:int;
            for (_local_7 in _local_12)
            {
                _local_14[_local_15] = _local_7;
                _local_15++;
            };
            if (_local_15 > 0)
            {
                shareFaces(_local_14, 0, _local_15, 0, _arg_2, new Vector.<int>(), _local_12);
            };
            _local_3 = 0;
            while (_local_3 < _local_13)
            {
                _local_8 = (_arg_1[_local_3] as Mesh);
                if (_local_8 != null)
                {
                    _local_8.vertexList = null;
                    _local_9 = _local_8.faceList;
                    while (_local_9 != null)
                    {
                        _local_11 = _local_9.wrapper;
                        while (_local_11 != null)
                        {
                            _local_10 = _local_11.vertex;
                            _local_17 = new Vertex();
                            _local_17.x = _local_10.x;
                            _local_17.y = _local_10.y;
                            _local_17.z = _local_10.z;
                            _local_17.u = _local_10.u;
                            _local_17.v = _local_10.v;
                            _local_17.id = _local_10.id;
                            _local_17.normalX = _local_9.normalX;
                            _local_17.normalY = _local_9.normalY;
                            _local_17.normalZ = _local_9.normalZ;
                            if (_local_9.smoothingGroups > 0)
                            {
                                for (_local_7 in _local_12[_local_10])
                                {
                                    _local_19 = _local_7;
                                    if (((!(_local_9 == _local_19)) && ((_local_9.smoothingGroups & _local_19.smoothingGroups) > 0)))
                                    {
                                        _local_17.normalX = (_local_17.normalX + _local_19.normalX);
                                        _local_17.normalY = (_local_17.normalY + _local_19.normalY);
                                        _local_17.normalZ = (_local_17.normalZ + _local_19.normalZ);
                                    };
                                };
                                _local_18 = (((_local_17.normalX * _local_17.normalX) + (_local_17.normalY * _local_17.normalY)) + (_local_17.normalZ * _local_17.normalZ));
                                if (_local_18 > 0.001)
                                {
                                    _local_18 = (1 / Math.sqrt(_local_18));
                                    _local_17.normalX = (_local_17.normalX * _local_18);
                                    _local_17.normalY = (_local_17.normalY * _local_18);
                                    _local_17.normalZ = (_local_17.normalZ * _local_18);
                                };
                            };
                            _local_11.vertex = _local_17;
                            _local_17.next = _local_8.vertexList;
                            _local_8.vertexList = _local_17;
                            _local_11 = _local_11.next;
                        };
                        _local_9 = _local_9.next;
                    };
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _local_13)
            {
                _local_8 = (_arg_1[_local_3] as Mesh);
                if (_local_8 != null)
                {
                    _local_8.invertMatrix();
                    _local_10 = _local_8.vertexList;
                    while (_local_10 != null)
                    {
                        _local_4 = _local_10.x;
                        _local_5 = _local_10.y;
                        _local_6 = _local_10.z;
                        _local_10.x = ((((_local_8.ma * _local_4) + (_local_8.mb * _local_5)) + (_local_8.mc * _local_6)) + _local_8.md);
                        _local_10.y = ((((_local_8.me * _local_4) + (_local_8.mf * _local_5)) + (_local_8.mg * _local_6)) + _local_8.mh);
                        _local_10.z = ((((_local_8.mi * _local_4) + (_local_8.mj * _local_5)) + (_local_8.mk * _local_6)) + _local_8.ml);
                        _local_4 = _local_10.normalX;
                        _local_5 = _local_10.normalY;
                        _local_6 = _local_10.normalZ;
                        _local_10.normalX = (((_local_8.ma * _local_4) + (_local_8.mb * _local_5)) + (_local_8.mc * _local_6));
                        _local_10.normalY = (((_local_8.me * _local_4) + (_local_8.mf * _local_5)) + (_local_8.mg * _local_6));
                        _local_10.normalZ = (((_local_8.mi * _local_4) + (_local_8.mj * _local_5)) + (_local_8.mk * _local_6));
                        _local_10 = _local_10.next;
                    };
                    _local_9 = _local_8.faceList;
                    while (_local_9 != null)
                    {
                        _local_4 = _local_9.normalX;
                        _local_5 = _local_9.normalY;
                        _local_6 = _local_9.normalZ;
                        _local_9.normalX = (((_local_8.ma * _local_4) + (_local_8.mb * _local_5)) + (_local_8.mc * _local_6));
                        _local_9.normalY = (((_local_8.me * _local_4) + (_local_8.mf * _local_5)) + (_local_8.mg * _local_6));
                        _local_9.normalZ = (((_local_8.mi * _local_4) + (_local_8.mj * _local_5)) + (_local_8.mk * _local_6));
                        _local_9.offset = (((_local_9.wrapper.vertex.x * _local_9.normalX) + (_local_9.wrapper.vertex.y * _local_9.normalY)) + (_local_9.wrapper.vertex.z * _local_9.normalZ));
                        _local_9 = _local_9.next;
                    };
                };
                _local_3++;
            };
        }

        private static function shareFaces(_arg_1:Vector.<Vertex>, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Vector.<int>, _arg_7:Dictionary):void
        {
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:Vertex;
            var _local_13:Vertex;
            var _local_14:int;
            var _local_15:int;
            var _local_16:Number;
            var _local_17:Vertex;
            var _local_18:Vertex;
            var _local_19:*;
            switch (_arg_4)
            {
                case 0:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_11 = _arg_1[_local_8];
                        _local_11.offset = _local_11.x;
                        _local_8++;
                    };
                    break;
                case 1:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_11 = _arg_1[_local_8];
                        _local_11.offset = _local_11.y;
                        _local_8++;
                    };
                    break;
                case 2:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_11 = _arg_1[_local_8];
                        _local_11.offset = _local_11.z;
                        _local_8++;
                    };
                    break;
            };
            _arg_6[0] = _arg_2;
            _arg_6[1] = (_arg_3 - 1);
            var _local_12:int = 2;
            while (_local_12 > 0)
            {
                _local_12--;
                _local_14 = _arg_6[_local_12];
                _local_9 = _local_14;
                _local_12--;
                _local_15 = _arg_6[_local_12];
                _local_8 = _local_15;
                _local_11 = _arg_1[((_local_14 + _local_15) >> 1)];
                _local_16 = _local_11.offset;
                while (_local_8 <= _local_9)
                {
                    _local_17 = _arg_1[_local_8];
                    while (_local_17.offset > _local_16)
                    {
                        _local_8++;
                        _local_17 = _arg_1[_local_8];
                    };
                    _local_18 = _arg_1[_local_9];
                    while (_local_18.offset < _local_16)
                    {
                        _local_9--;
                        _local_18 = _arg_1[_local_9];
                    };
                    if (_local_8 <= _local_9)
                    {
                        _arg_1[_local_8] = _local_18;
                        _arg_1[_local_9] = _local_17;
                        _local_8++;
                        _local_9--;
                    };
                };
                if (_local_15 < _local_9)
                {
                    _arg_6[_local_12] = _local_15;
                    _local_12++;
                    _arg_6[_local_12] = _local_9;
                    _local_12++;
                };
                if (_local_8 < _local_14)
                {
                    _arg_6[_local_12] = _local_8;
                    _local_12++;
                    _arg_6[_local_12] = _local_14;
                    _local_12++;
                };
            };
            _local_8 = _arg_2;
            _local_11 = _arg_1[_local_8];
            _local_9 = (_local_8 + 1);
            while (_local_9 <= _arg_3)
            {
                if (_local_9 < _arg_3)
                {
                    _local_13 = _arg_1[_local_9];
                };
                if (((_local_9 == _arg_3) || ((_local_11.offset - _local_13.offset) > _arg_5)))
                {
                    if ((_local_9 - _local_8) > 1)
                    {
                        if (_arg_4 < 2)
                        {
                            shareFaces(_arg_1, _local_8, _local_9, (_arg_4 + 1), _arg_5, _arg_6, _arg_7);
                        } else
                        {
                            _local_10 = (_local_8 + 1);
                            while (_local_10 < _local_9)
                            {
                                _local_13 = _arg_1[_local_10];
                                for (_local_19 in _arg_7[_local_13])
                                {
                                    _arg_7[_local_11][_local_19] = true;
                                };
                                _local_10++;
                            };
                            _local_10 = (_local_8 + 1);
                            while (_local_10 < _local_9)
                            {
                                _local_13 = _arg_1[_local_10];
                                for (_local_19 in _arg_7[_local_11])
                                {
                                    _arg_7[_local_13][_local_19] = true;
                                };
                                _local_10++;
                            };
                        };
                    };
                    if (_local_9 < _arg_3)
                    {
                        _local_8 = _local_9;
                        _local_11 = _arg_1[_local_8];
                    };
                };
                _local_9++;
            };
        }


        public function addVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number=0, _arg_5:Number=0, _arg_6:Object=null):Vertex
        {
            var _local_8:Vertex;
            this.deleteResources();
            var _local_7:Vertex = new Vertex();
            _local_7.x = _arg_1;
            _local_7.y = _arg_2;
            _local_7.z = _arg_3;
            _local_7.u = _arg_4;
            _local_7.v = _arg_5;
            _local_7.id = _arg_6;
            if (this.vertexList != null)
            {
                _local_8 = this.vertexList;
                while (_local_8.next != null)
                {
                    _local_8 = _local_8.next;
                };
                _local_8.next = _local_7;
            } else
            {
                this.vertexList = _local_7;
            };
            return (_local_7);
        }

        public function removeVertex(_arg_1:Vertex):Vertex
        {
            var _local_3:Vertex;
            var _local_5:Face;
            var _local_6:Face;
            var _local_7:Wrapper;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter vertex must be non-null."));
            };
            var _local_2:Vertex = this.vertexList;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    if (_local_3 != null)
                    {
                        _local_3.next = _local_2.next;
                    } else
                    {
                        this.vertexList = _local_2.next;
                    };
                    _local_2.next = null;
                    break;
                };
                _local_3 = _local_2;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                throw (new ArgumentError("Vertex not found."));
            };
            var _local_4:Face = this.faceList;
            while (_local_4 != null)
            {
                _local_6 = _local_4.next;
                _local_7 = _local_4.wrapper;
                while (_local_7 != null)
                {
                    if (_local_7.vertex == _local_2) break;
                    _local_7 = _local_7.next;
                };
                if (_local_7 != null)
                {
                    if (_local_5 != null)
                    {
                        _local_5.next = _local_6;
                    } else
                    {
                        this.faceList = _local_6;
                    };
                    _local_4.next = null;
                } else
                {
                    _local_5 = _local_4;
                };
                _local_4 = _local_6;
            };
            return (_local_2);
        }

        public function removeVertexById(_arg_1:Object):Vertex
        {
            var _local_3:Vertex;
            var _local_5:Face;
            var _local_6:Face;
            var _local_7:Wrapper;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Vertex = this.vertexList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    if (_local_3 != null)
                    {
                        _local_3.next = _local_2.next;
                    } else
                    {
                        this.vertexList = _local_2.next;
                    };
                    _local_2.next = null;
                    break;
                };
                _local_3 = _local_2;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                throw (new ArgumentError("Vertex not found."));
            };
            var _local_4:Face = this.faceList;
            while (_local_4 != null)
            {
                _local_6 = _local_4.next;
                _local_7 = _local_4.wrapper;
                while (_local_7 != null)
                {
                    if (_local_7.vertex == _local_2) break;
                    _local_7 = _local_7.next;
                };
                if (_local_7 != null)
                {
                    if (_local_5 != null)
                    {
                        _local_5.next = _local_6;
                    } else
                    {
                        this.faceList = _local_6;
                    };
                    _local_4.next = null;
                } else
                {
                    _local_5 = _local_4;
                };
                _local_4 = _local_6;
            };
            return (_local_2);
        }

        public function containsVertex(_arg_1:Vertex):Boolean
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter vertex must be non-null."));
            };
            var _local_2:Vertex = this.vertexList;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    return (true);
                };
                _local_2 = _local_2.next;
            };
            return (false);
        }

        public function containsVertexWithId(_arg_1:Object):Boolean
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Vertex = this.vertexList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    return (true);
                };
                _local_2 = _local_2.next;
            };
            return (false);
        }

        public function getVertexById(_arg_1:Object):Vertex
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Vertex = this.vertexList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
                _local_2 = _local_2.next;
            };
            return (null);
        }

        public function addFace(_arg_1:Vector.<Vertex>, _arg_2:Material=null, _arg_3:Object=null):Face
        {
            var _local_8:Wrapper;
            var _local_9:Vertex;
            var _local_10:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter vertices must be non-null."));
            };
            var _local_4:int = _arg_1.length;
            if (_local_4 < 3)
            {
                throw (new ArgumentError((_local_4 + " vertices not enough.")));
            };
            var _local_5:Face = new Face();
            _local_5.material = _arg_2;
            _local_5.id = _arg_3;
            var _local_6:Wrapper;
            var _local_7:int;
            while (_local_7 < _local_4)
            {
                _local_8 = new Wrapper();
                _local_9 = _arg_1[_local_7];
                if (_local_9 == null)
                {
                    throw (new ArgumentError("Null vertex in vector."));
                };
                if ((!(this.containsVertex(_local_9))))
                {
                    throw (new ArgumentError("Vertex not found."));
                };
                _local_8.vertex = _local_9;
                if (_local_6 != null)
                {
                    _local_6.next = _local_8;
                } else
                {
                    _local_5.wrapper = _local_8;
                };
                _local_6 = _local_8;
                _local_7++;
            };
            if (this.faceList != null)
            {
                _local_10 = this.faceList;
                while (_local_10.next != null)
                {
                    _local_10 = _local_10.next;
                };
                _local_10.next = _local_5;
            } else
            {
                this.faceList = _local_5;
            };
            return (_local_5);
        }

        public function addFaceByIds(_arg_1:Array, _arg_2:Material=null, _arg_3:Object=null):Face
        {
            var _local_8:Wrapper;
            var _local_9:Vertex;
            var _local_10:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter vertices must be non-null."));
            };
            var _local_4:int = _arg_1.length;
            if (_local_4 < 3)
            {
                throw (new ArgumentError((_local_4 + " vertices not enough.")));
            };
            var _local_5:Face = new Face();
            _local_5.material = _arg_2;
            _local_5.id = _arg_3;
            var _local_6:Wrapper;
            var _local_7:int;
            while (_local_7 < _local_4)
            {
                _local_8 = new Wrapper();
                _local_9 = this.getVertexById(_arg_1[_local_7]);
                if (_local_9 == null)
                {
                    throw (new ArgumentError("Vertex not found."));
                };
                _local_8.vertex = _local_9;
                if (_local_6 != null)
                {
                    _local_6.next = _local_8;
                } else
                {
                    _local_5.wrapper = _local_8;
                };
                _local_6 = _local_8;
                _local_7++;
            };
            if (this.faceList != null)
            {
                _local_10 = this.faceList;
                while (_local_10.next != null)
                {
                    _local_10 = _local_10.next;
                };
                _local_10.next = _local_5;
            } else
            {
                this.faceList = _local_5;
            };
            return (_local_5);
        }

        public function addTriFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Material=null, _arg_5:Object=null):Face
        {
            var _local_7:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter v1 must be non-null."));
            };
            if (_arg_2 == null)
            {
                throw (new TypeError("Parameter v2 must be non-null."));
            };
            if (_arg_3 == null)
            {
                throw (new TypeError("Parameter v3 must be non-null."));
            };
            if ((!(this.containsVertex(_arg_1))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            if ((!(this.containsVertex(_arg_2))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            if ((!(this.containsVertex(_arg_3))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            var _local_6:Face = new Face();
            _local_6.material = _arg_4;
            _local_6.id = _arg_5;
            _local_6.wrapper = new Wrapper();
            _local_6.wrapper.vertex = _arg_1;
            _local_6.wrapper.next = new Wrapper();
            _local_6.wrapper.next.vertex = _arg_2;
            _local_6.wrapper.next.next = new Wrapper();
            _local_6.wrapper.next.next.vertex = _arg_3;
            if (this.faceList != null)
            {
                _local_7 = this.faceList;
                while (_local_7.next != null)
                {
                    _local_7 = _local_7.next;
                };
                _local_7.next = _local_6;
            } else
            {
                this.faceList = _local_6;
            };
            return (_local_6);
        }

        public function addQuadFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Vertex, _arg_5:Material=null, _arg_6:Object=null):Face
        {
            var _local_8:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter v1 must be non-null."));
            };
            if (_arg_2 == null)
            {
                throw (new TypeError("Parameter v2 must be non-null."));
            };
            if (_arg_3 == null)
            {
                throw (new TypeError("Parameter v3 must be non-null."));
            };
            if (_arg_4 == null)
            {
                throw (new TypeError("Parameter v4 must be non-null."));
            };
            if ((!(this.containsVertex(_arg_1))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            if ((!(this.containsVertex(_arg_2))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            if ((!(this.containsVertex(_arg_3))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            if ((!(this.containsVertex(_arg_4))))
            {
                throw (new ArgumentError("Vertex not found."));
            };
            var _local_7:Face = new Face();
            _local_7.material = _arg_5;
            _local_7.id = _arg_6;
            _local_7.wrapper = new Wrapper();
            _local_7.wrapper.vertex = _arg_1;
            _local_7.wrapper.next = new Wrapper();
            _local_7.wrapper.next.vertex = _arg_2;
            _local_7.wrapper.next.next = new Wrapper();
            _local_7.wrapper.next.next.vertex = _arg_3;
            _local_7.wrapper.next.next.next = new Wrapper();
            _local_7.wrapper.next.next.next.vertex = _arg_4;
            if (this.faceList != null)
            {
                _local_8 = this.faceList;
                while (_local_8.next != null)
                {
                    _local_8 = _local_8.next;
                };
                _local_8.next = _local_7;
            } else
            {
                this.faceList = _local_7;
            };
            return (_local_7);
        }

        public function removeFace(_arg_1:Face):Face
        {
            var _local_3:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter face must be non-null."));
            };
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    if (_local_3 != null)
                    {
                        _local_3.next = _local_2.next;
                    } else
                    {
                        this.faceList = _local_2.next;
                    };
                    _local_2.next = null;
                    break;
                };
                _local_3 = _local_2;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                throw (new ArgumentError("Face not found."));
            };
            return (_local_2);
        }

        public function removeFaceById(_arg_1:Object):Face
        {
            var _local_3:Face;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    if (_local_3 != null)
                    {
                        _local_3.next = _local_2.next;
                    } else
                    {
                        this.faceList = _local_2.next;
                    };
                    _local_2.next = null;
                    break;
                };
                _local_3 = _local_2;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                throw (new ArgumentError("Face not found."));
            };
            return (_local_2);
        }

        public function containsFace(_arg_1:Face):Boolean
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter face must be non-null."));
            };
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    return (true);
                };
                _local_2 = _local_2.next;
            };
            return (false);
        }

        public function containsFaceWithId(_arg_1:Object):Boolean
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    return (true);
                };
                _local_2 = _local_2.next;
            };
            return (false);
        }

        public function getFaceById(_arg_1:Object):Face
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter id must be non-null."));
            };
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
                _local_2 = _local_2.next;
            };
            return (null);
        }

        public function addVerticesAndFaces(_arg_1:Vector.<Number>, _arg_2:Vector.<Number>, _arg_3:Vector.<int>, _arg_4:Boolean=false, _arg_5:Material=null):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_11:Vertex;
            var _local_13:Face;
            var _local_14:Face;
            var _local_15:Wrapper;
            var _local_16:int;
            var _local_17:int;
            var _local_18:Vertex;
            var _local_19:Wrapper;
            this.deleteResources();
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter vertices must be non-null."));
            };
            if (_arg_2 == null)
            {
                throw (new TypeError("Parameter uvs must be non-null."));
            };
            if (_arg_3 == null)
            {
                throw (new TypeError("Parameter indices must be non-null."));
            };
            var _local_9:int = int((_arg_1.length / 3));
            if (_local_9 != (_arg_2.length / 2))
            {
                throw (new ArgumentError("Vertices count and uvs count doesn't match."));
            };
            var _local_10:int = _arg_3.length;
            if (((!(_arg_4)) && (_local_10 % 3)))
            {
                throw (new ArgumentError("Incorrect indices."));
            };
            _local_6 = 0;
            _local_8 = 0;
            while (_local_6 < _local_10)
            {
                if (_local_6 == _local_8)
                {
                    _local_17 = ((_arg_4) ? _arg_3[_local_6] : 3);
                    if (_local_17 < 3)
                    {
                        throw (new ArgumentError((_local_17 + " vertices not enough.")));
                    };
                    _local_8 = ((_arg_4) ? (_local_17 + ++_local_6) : (_local_6 + _local_17));
                    if (_local_8 > _local_10)
                    {
                        throw (new ArgumentError("Incorrect indices."));
                    };
                };
                _local_16 = _arg_3[_local_6];
                if (((_local_16 < 0) || (_local_16 >= _local_9)))
                {
                    throw (new RangeError("Index is out of bounds."));
                };
                _local_6++;
            };
            if (this.vertexList != null)
            {
                _local_11 = this.vertexList;
                while (_local_11.next != null)
                {
                    _local_11 = _local_11.next;
                };
            };
            var _local_12:Vector.<Vertex> = new Vector.<Vertex>(_local_9);
            _local_6 = 0;
            _local_7 = 0;
            _local_8 = 0;
            while (_local_6 < _local_9)
            {
                _local_18 = new Vertex();
                _local_18.x = _arg_1[_local_7];
                _local_7++;
                _local_18.y = _arg_1[_local_7];
                _local_7++;
                _local_18.z = _arg_1[_local_7];
                _local_7++;
                _local_18.u = _arg_2[_local_8];
                _local_8++;
                _local_18.v = _arg_2[_local_8];
                _local_8++;
                _local_12[_local_6] = _local_18;
                if (_local_11 != null)
                {
                    _local_11.next = _local_18;
                } else
                {
                    this.vertexList = _local_18;
                };
                _local_11 = _local_18;
                _local_6++;
            };
            if (this.faceList != null)
            {
                _local_13 = this.faceList;
                while (_local_13.next != null)
                {
                    _local_13 = _local_13.next;
                };
            };
            _local_6 = 0;
            _local_8 = 0;
            while (_local_6 < _local_10)
            {
                if (_local_6 == _local_8)
                {
                    _local_8 = ((_arg_4) ? (_arg_3[_local_6] + ++_local_6) : (_local_6 + 3));
                    _local_15 = null;
                    _local_14 = new Face();
                    _local_14.material = _arg_5;
                    if (_local_13 != null)
                    {
                        _local_13.next = _local_14;
                    } else
                    {
                        this.faceList = _local_14;
                    };
                    _local_13 = _local_14;
                };
                _local_19 = new Wrapper();
                _local_19.vertex = _local_12[_arg_3[_local_6]];
                if (_local_15 != null)
                {
                    _local_15.next = _local_19;
                } else
                {
                    _local_14.wrapper = _local_19;
                };
                _local_15 = _local_19;
                _local_6++;
            };
        }

        public function get vertices():Vector.<Vertex>
        {
            var _local_1:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_2:int;
            var _local_3:Vertex = this.vertexList;
            while (_local_3 != null)
            {
                _local_1[_local_2] = _local_3;
                _local_2++;
                _local_3 = _local_3.next;
            };
            return (_local_1);
        }

        public function get faces():Vector.<Face>
        {
            var _local_1:Vector.<Face> = new Vector.<Face>();
            var _local_2:int;
            var _local_3:Face = this.faceList;
            while (_local_3 != null)
            {
                _local_1[_local_2] = _local_3;
                _local_2++;
                _local_3 = _local_3.next;
            };
            return (_local_1);
        }

        public function weldVertices(_arg_1:Number=0, _arg_2:Number=0):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_9:Wrapper;
            this.deleteResources();
            var _local_5:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_6:int;
            _local_3 = this.vertexList;
            while (_local_3 != null)
            {
                _local_4 = _local_3.next;
                _local_3.next = null;
                _local_5[_local_6] = _local_3;
                _local_6++;
                _local_3 = _local_4;
            };
            this.vertexList = null;
            this.group(_local_5, 0, _local_6, 0, _arg_1, _arg_2, new Vector.<int>());
            var _local_7:Face = this.faceList;
            while (_local_7 != null)
            {
                _local_9 = _local_7.wrapper;
                while (_local_9 != null)
                {
                    if (_local_9.vertex.value != null)
                    {
                        _local_9.vertex = _local_9.vertex.value;
                    };
                    _local_9 = _local_9.next;
                };
                _local_7 = _local_7.next;
            };
            var _local_8:int;
            while (_local_8 < _local_6)
            {
                _local_3 = _local_5[_local_8];
                if (_local_3.value == null)
                {
                    _local_3.next = this.vertexList;
                    this.vertexList = _local_3;
                };
                _local_8++;
            };
        }

        public function weldFaces(_arg_1:Number=0, _arg_2:Number=0, _arg_3:Number=0, _arg_4:Boolean=false):void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:*;
            var _local_8:Face;
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Wrapper;
            var _local_12:Wrapper;
            var _local_13:Wrapper;
            var _local_14:Wrapper;
            var _local_15:Wrapper;
            var _local_16:Wrapper;
            var _local_17:Wrapper;
            var _local_18:Wrapper;
            var _local_19:Vertex;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Vertex;
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
            var _local_33:Number;
            var _local_34:Number;
            var _local_35:Number;
            var _local_36:Number;
            var _local_37:Dictionary;
            var _local_44:int;
            var _local_45:Number;
            var _local_46:Number;
            var _local_47:Number;
            var _local_48:Number;
            var _local_49:Number;
            var _local_50:Number;
            var _local_51:Number;
            var _local_52:Number;
            var _local_53:Number;
            var _local_54:Number;
            var _local_55:Number;
            var _local_56:Number;
            var _local_57:Number;
            var _local_58:Number;
            var _local_59:Number;
            var _local_60:Number;
            var _local_61:Number;
            var _local_62:Number;
            var _local_63:Number;
            var _local_64:Boolean;
            var _local_65:Face;
            this.deleteResources();
            var _local_38:Number = 0.001;
            _arg_1 = (Math.cos(_arg_1) - _local_38);
            _arg_2 = (_arg_2 + _local_38);
            _arg_3 = (Math.cos((Math.PI - _arg_3)) - _local_38);
            var _local_39:Dictionary = new Dictionary();
            var _local_40:Dictionary = new Dictionary();
            _local_9 = this.faceList;
            while (_local_9 != null)
            {
                _local_10 = _local_9.next;
                _local_9.next = null;
                _local_20 = _local_9.wrapper.vertex;
                _local_21 = _local_9.wrapper.next.vertex;
                _local_22 = _local_9.wrapper.next.next.vertex;
                _local_23 = (_local_21.x - _local_20.x);
                _local_24 = (_local_21.y - _local_20.y);
                _local_25 = (_local_21.z - _local_20.z);
                _local_28 = (_local_22.x - _local_20.x);
                _local_29 = (_local_22.y - _local_20.y);
                _local_30 = (_local_22.z - _local_20.z);
                _local_33 = ((_local_30 * _local_24) - (_local_29 * _local_25));
                _local_34 = ((_local_28 * _local_25) - (_local_30 * _local_23));
                _local_35 = ((_local_29 * _local_23) - (_local_28 * _local_24));
                _local_36 = (((_local_33 * _local_33) + (_local_34 * _local_34)) + (_local_35 * _local_35));
                if (_local_36 > _local_38)
                {
                    _local_36 = (1 / Math.sqrt(_local_36));
                    _local_33 = (_local_33 * _local_36);
                    _local_34 = (_local_34 * _local_36);
                    _local_35 = (_local_35 * _local_36);
                    _local_9.normalX = _local_33;
                    _local_9.normalY = _local_34;
                    _local_9.normalZ = _local_35;
                    _local_9.offset = (((_local_20.x * _local_33) + (_local_20.y * _local_34)) + (_local_20.z * _local_35));
                    _local_39[_local_9] = true;
                    _local_15 = _local_9.wrapper;
                    while (_local_15 != null)
                    {
                        _local_19 = _local_15.vertex;
                        _local_37 = _local_40[_local_19];
                        if (_local_37 == null)
                        {
                            _local_37 = new Dictionary();
                            _local_40[_local_19] = _local_37;
                        };
                        _local_37[_local_9] = true;
                        _local_15 = _local_15.next;
                    };
                };
                _local_9 = _local_10;
            };
            this.faceList = null;
            var _local_41:Vector.<Face> = new Vector.<Face>();
            var _local_42:Dictionary = new Dictionary();
            var _local_43:Dictionary = new Dictionary();
            while (true)
            {
                _local_9 = null;
                for (_local_7 in _local_39)
                {
                    _local_9 = _local_7;
                    delete _local_39[_local_7];
                    break;
                };
                if (_local_9 == null) break;
                _local_44 = 0;
                _local_41[_local_44] = _local_9;
                _local_44++;
                _local_20 = _local_9.wrapper.vertex;
                _local_21 = _local_9.wrapper.next.vertex;
                _local_22 = _local_9.wrapper.next.next.vertex;
                _local_23 = (_local_21.x - _local_20.x);
                _local_24 = (_local_21.y - _local_20.y);
                _local_25 = (_local_21.z - _local_20.z);
                _local_26 = (_local_21.u - _local_20.u);
                _local_27 = (_local_21.v - _local_20.v);
                _local_28 = (_local_22.x - _local_20.x);
                _local_29 = (_local_22.y - _local_20.y);
                _local_30 = (_local_22.z - _local_20.z);
                _local_31 = (_local_22.u - _local_20.u);
                _local_32 = (_local_22.v - _local_20.v);
                _local_33 = _local_9.normalX;
                _local_34 = _local_9.normalY;
                _local_35 = _local_9.normalZ;
                _local_45 = (((((((-(_local_33) * _local_29) * _local_25) + ((_local_28 * _local_34) * _local_25)) + ((_local_33 * _local_24) * _local_30)) - ((_local_23 * _local_34) * _local_30)) - ((_local_28 * _local_24) * _local_35)) + ((_local_23 * _local_29) * _local_35));
                _local_46 = (((-(_local_34) * _local_30) + (_local_29 * _local_35)) / _local_45);
                _local_47 = (((_local_33 * _local_30) - (_local_28 * _local_35)) / _local_45);
                _local_48 = (((-(_local_33) * _local_29) + (_local_28 * _local_34)) / _local_45);
                _local_49 = ((((((((_local_20.x * _local_34) * _local_30) - ((_local_33 * _local_20.y) * _local_30)) - ((_local_20.x * _local_29) * _local_35)) + ((_local_28 * _local_20.y) * _local_35)) + ((_local_33 * _local_29) * _local_20.z)) - ((_local_28 * _local_34) * _local_20.z)) / _local_45);
                _local_50 = (((_local_34 * _local_25) - (_local_24 * _local_35)) / _local_45);
                _local_51 = (((-(_local_33) * _local_25) + (_local_23 * _local_35)) / _local_45);
                _local_52 = (((_local_33 * _local_24) - (_local_23 * _local_34)) / _local_45);
                _local_53 = ((((((((_local_33 * _local_20.y) * _local_25) - ((_local_20.x * _local_34) * _local_25)) + ((_local_20.x * _local_24) * _local_35)) - ((_local_23 * _local_20.y) * _local_35)) - ((_local_33 * _local_24) * _local_20.z)) + ((_local_23 * _local_34) * _local_20.z)) / _local_45);
                _local_54 = ((_local_26 * _local_46) + (_local_31 * _local_50));
                _local_55 = ((_local_26 * _local_47) + (_local_31 * _local_51));
                _local_56 = ((_local_26 * _local_48) + (_local_31 * _local_52));
                _local_57 = (((_local_26 * _local_49) + (_local_31 * _local_53)) + _local_20.u);
                _local_58 = ((_local_27 * _local_46) + (_local_32 * _local_50));
                _local_59 = ((_local_27 * _local_47) + (_local_32 * _local_51));
                _local_60 = ((_local_27 * _local_48) + (_local_32 * _local_52));
                _local_61 = (((_local_27 * _local_49) + (_local_32 * _local_53)) + _local_20.v);
                for (_local_7 in _local_43)
                {
                    delete _local_43[_local_7];
                };
                _local_5 = 0;
                while (_local_5 < _local_44)
                {
                    _local_9 = _local_41[_local_5];
                    for (_local_7 in _local_42)
                    {
                        delete _local_42[_local_7];
                    };
                    _local_13 = _local_9.wrapper;
                    while (_local_13 != null)
                    {
                        for (_local_7 in _local_40[_local_13.vertex])
                        {
                            if (((_local_39[_local_7]) && (!(_local_43[_local_7]))))
                            {
                                _local_42[_local_7] = true;
                            };
                        };
                        _local_13 = _local_13.next;
                    };
                    for (_local_7 in _local_42)
                    {
                        _local_8 = _local_7;
                        if ((((_local_33 * _local_8.normalX) + (_local_34 * _local_8.normalY)) + (_local_35 * _local_8.normalZ)) >= _arg_1)
                        {
                            _local_14 = _local_8.wrapper;
                            while (_local_14 != null)
                            {
                                _local_19 = _local_14.vertex;
                                _local_62 = (((((_local_54 * _local_19.x) + (_local_55 * _local_19.y)) + (_local_56 * _local_19.z)) + _local_57) - _local_19.u);
                                _local_63 = (((((_local_58 * _local_19.x) + (_local_59 * _local_19.y)) + (_local_60 * _local_19.z)) + _local_61) - _local_19.v);
                                if (((((_local_62 > _arg_2) || (_local_62 < -(_arg_2))) || (_local_63 > _arg_2)) || (_local_63 < -(_arg_2)))) break;
                                _local_14 = _local_14.next;
                            };
                            if (_local_14 == null)
                            {
                                _local_13 = _local_9.wrapper;
                                while (_local_13 != null)
                                {
                                    _local_15 = ((_local_13.next != null) ? _local_13.next : _local_9.wrapper);
                                    _local_14 = _local_8.wrapper;
                                    while (_local_14 != null)
                                    {
                                        _local_16 = ((_local_14.next != null) ? _local_14.next : _local_8.wrapper);
                                        if (((_local_13.vertex == _local_16.vertex) && (_local_15.vertex == _local_14.vertex))) break;
                                        _local_14 = _local_14.next;
                                    };
                                    if (_local_14 != null) break;
                                    _local_13 = _local_13.next;
                                };
                                if (_local_13 != null)
                                {
                                    _local_41[_local_44] = _local_8;
                                    _local_44++;
                                    delete _local_39[_local_8];
                                };
                            } else
                            {
                                _local_43[_local_8] = true;
                            };
                        } else
                        {
                            _local_43[_local_8] = true;
                        };
                    };
                    _local_5++;
                };
                if (_local_44 == 1)
                {
                    _local_9 = _local_41[0];
                    _local_9.next = this.faceList;
                    this.faceList = _local_9;
                } else
                {
                    while (true)
                    {
                        _local_64 = false;
                        _local_5 = 0;
                        while (_local_5 < (_local_44 - 1))
                        {
                            _local_9 = _local_41[_local_5];
                            if (_local_9 != null)
                            {
                                _local_6 = 1;
                                for (;_local_6 < _local_44;_local_6++)
                                {
                                    _local_8 = _local_41[_local_6];
                                    if (_local_8 != null)
                                    {
                                        _local_13 = _local_9.wrapper;
                                        while (_local_13 != null)
                                        {
                                            _local_15 = ((_local_13.next != null) ? _local_13.next : _local_9.wrapper);
                                            _local_14 = _local_8.wrapper;
                                            while (_local_14 != null)
                                            {
                                                _local_16 = ((_local_14.next != null) ? _local_14.next : _local_8.wrapper);
                                                if (((_local_13.vertex == _local_16.vertex) && (_local_15.vertex == _local_14.vertex))) break;
                                                _local_14 = _local_14.next;
                                            };
                                            if (_local_14 != null) break;
                                            _local_13 = _local_13.next;
                                        };
                                        if (_local_13 != null)
                                        {
                                            while (true)
                                            {
                                                _local_17 = ((_local_15.next != null) ? _local_15.next : _local_9.wrapper);
                                                _local_12 = _local_8.wrapper;
                                                while (((!(_local_12.next == _local_14)) && (!(_local_12.next == null))))
                                                {
                                                    _local_12 = _local_12.next;
                                                };
                                                if (_local_17.vertex == _local_12.vertex)
                                                {
                                                    _local_15 = _local_17;
                                                    _local_14 = _local_12;
                                                } else
                                                {
                                                    break;
                                                };
                                            };
                                            while (true)
                                            {
                                                _local_11 = _local_9.wrapper;
                                                while (((!(_local_11.next == _local_13)) && (!(_local_11.next == null))))
                                                {
                                                    _local_11 = _local_11.next;
                                                };
                                                _local_18 = ((_local_16.next != null) ? _local_16.next : _local_8.wrapper);
                                                if (_local_11.vertex == _local_18.vertex)
                                                {
                                                    _local_13 = _local_11;
                                                    _local_16 = _local_18;
                                                } else
                                                {
                                                    break;
                                                };
                                            };
                                            _local_20 = _local_13.vertex;
                                            _local_21 = _local_18.vertex;
                                            _local_22 = _local_11.vertex;
                                            _local_23 = (_local_21.x - _local_20.x);
                                            _local_24 = (_local_21.y - _local_20.y);
                                            _local_25 = (_local_21.z - _local_20.z);
                                            _local_28 = (_local_22.x - _local_20.x);
                                            _local_29 = (_local_22.y - _local_20.y);
                                            _local_30 = (_local_22.z - _local_20.z);
                                            _local_33 = ((_local_30 * _local_24) - (_local_29 * _local_25));
                                            _local_34 = ((_local_28 * _local_25) - (_local_30 * _local_23));
                                            _local_35 = ((_local_29 * _local_23) - (_local_28 * _local_24));
                                            if (((((((_local_33 < _local_38) && (_local_33 > -(_local_38))) && (_local_34 < _local_38)) && (_local_34 > -(_local_38))) && (_local_35 < _local_38)) && (_local_35 > -(_local_38))))
                                            {
                                                if ((((_local_23 * _local_28) + (_local_24 * _local_29)) + (_local_25 * _local_30)) > 0) continue;
                                            } else
                                            {
                                                if ((((_local_9.normalX * _local_33) + (_local_9.normalY * _local_34)) + (_local_9.normalZ * _local_35)) < 0) continue;
                                            };
                                            _local_36 = (1 / Math.sqrt((((_local_23 * _local_23) + (_local_24 * _local_24)) + (_local_25 * _local_25))));
                                            _local_23 = (_local_23 * _local_36);
                                            _local_24 = (_local_24 * _local_36);
                                            _local_25 = (_local_25 * _local_36);
                                            _local_36 = (1 / Math.sqrt((((_local_28 * _local_28) + (_local_29 * _local_29)) + (_local_30 * _local_30))));
                                            _local_28 = (_local_28 * _local_36);
                                            _local_29 = (_local_29 * _local_36);
                                            _local_30 = (_local_30 * _local_36);
                                            if ((((_local_23 * _local_28) + (_local_24 * _local_29)) + (_local_25 * _local_30)) >= _arg_3)
                                            {
                                                _local_20 = _local_14.vertex;
                                                _local_21 = _local_17.vertex;
                                                _local_22 = _local_12.vertex;
                                                _local_23 = (_local_21.x - _local_20.x);
                                                _local_24 = (_local_21.y - _local_20.y);
                                                _local_25 = (_local_21.z - _local_20.z);
                                                _local_28 = (_local_22.x - _local_20.x);
                                                _local_29 = (_local_22.y - _local_20.y);
                                                _local_30 = (_local_22.z - _local_20.z);
                                                _local_33 = ((_local_30 * _local_24) - (_local_29 * _local_25));
                                                _local_34 = ((_local_28 * _local_25) - (_local_30 * _local_23));
                                                _local_35 = ((_local_29 * _local_23) - (_local_28 * _local_24));
                                                if (((((((_local_33 < _local_38) && (_local_33 > -(_local_38))) && (_local_34 < _local_38)) && (_local_34 > -(_local_38))) && (_local_35 < _local_38)) && (_local_35 > -(_local_38))))
                                                {
                                                    if ((((_local_23 * _local_28) + (_local_24 * _local_29)) + (_local_25 * _local_30)) > 0) continue;
                                                } else
                                                {
                                                    if ((((_local_9.normalX * _local_33) + (_local_9.normalY * _local_34)) + (_local_9.normalZ * _local_35)) < 0) continue;
                                                };
                                                _local_36 = (1 / Math.sqrt((((_local_23 * _local_23) + (_local_24 * _local_24)) + (_local_25 * _local_25))));
                                                _local_23 = (_local_23 * _local_36);
                                                _local_24 = (_local_24 * _local_36);
                                                _local_25 = (_local_25 * _local_36);
                                                _local_36 = (1 / Math.sqrt((((_local_28 * _local_28) + (_local_29 * _local_29)) + (_local_30 * _local_30))));
                                                _local_28 = (_local_28 * _local_36);
                                                _local_29 = (_local_29 * _local_36);
                                                _local_30 = (_local_30 * _local_36);
                                                if ((((_local_23 * _local_28) + (_local_24 * _local_29)) + (_local_25 * _local_30)) >= _arg_3)
                                                {
                                                    _local_64 = true;
                                                    _local_65 = new Face();
                                                    _local_65.material = _local_9.material;
                                                    _local_65.smoothingGroups = _local_9.smoothingGroups;
                                                    _local_65.normalX = _local_9.normalX;
                                                    _local_65.normalY = _local_9.normalY;
                                                    _local_65.normalZ = _local_9.normalZ;
                                                    _local_65.offset = _local_9.offset;
                                                    _local_65.id = _local_9.id;
                                                    _local_17 = null;
                                                    while (_local_15 != _local_13)
                                                    {
                                                        _local_18 = new Wrapper();
                                                        _local_18.vertex = _local_15.vertex;
                                                        if (_local_17 != null)
                                                        {
                                                            _local_17.next = _local_18;
                                                        } else
                                                        {
                                                            _local_65.wrapper = _local_18;
                                                        };
                                                        _local_17 = _local_18;
                                                        _local_15 = ((_local_15.next != null) ? _local_15.next : _local_9.wrapper);
                                                    };
                                                    while (_local_16 != _local_14)
                                                    {
                                                        _local_18 = new Wrapper();
                                                        _local_18.vertex = _local_16.vertex;
                                                        if (_local_17 != null)
                                                        {
                                                            _local_17.next = _local_18;
                                                        } else
                                                        {
                                                            _local_65.wrapper = _local_18;
                                                        };
                                                        _local_17 = _local_18;
                                                        _local_16 = ((_local_16.next != null) ? _local_16.next : _local_8.wrapper);
                                                    };
                                                    _local_41[_local_5] = _local_65;
                                                    _local_41[_local_6] = null;
                                                    _local_9 = _local_65;
                                                    if (_arg_4) break;
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                            _local_5++;
                        };
                        if ((!(_local_64))) break;
                    };
                    _local_5 = 0;
                    while (_local_5 < _local_44)
                    {
                        _local_9 = _local_41[_local_5];
                        if (_local_9 != null)
                        {
                            _local_9.calculateBestSequenceAndNormal();
                            _local_9.next = this.faceList;
                            this.faceList = _local_9;
                        };
                        _local_5++;
                    };
                };
            };
        }

        private function group(_arg_1:Vector.<Vertex>, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Number, _arg_7:Vector.<int>):void
        {
            var _local_8:int;
            var _local_9:int;
            var _local_10:Vertex;
            var _local_11:Number;
            var _local_13:Vertex;
            var _local_14:int;
            var _local_15:int;
            var _local_16:Number;
            var _local_17:Vertex;
            var _local_18:Vertex;
            switch (_arg_4)
            {
                case 0:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_8];
                        _local_10.offset = _local_10.x;
                        _local_8++;
                    };
                    _local_11 = _arg_5;
                    break;
                case 1:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_8];
                        _local_10.offset = _local_10.y;
                        _local_8++;
                    };
                    _local_11 = _arg_5;
                    break;
                case 2:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_8];
                        _local_10.offset = _local_10.z;
                        _local_8++;
                    };
                    _local_11 = _arg_5;
                    break;
                case 3:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_8];
                        _local_10.offset = _local_10.u;
                        _local_8++;
                    };
                    _local_11 = _arg_6;
                    break;
                case 4:
                    _local_8 = _arg_2;
                    while (_local_8 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_8];
                        _local_10.offset = _local_10.v;
                        _local_8++;
                    };
                    _local_11 = _arg_6;
                    break;
            };
            _arg_7[0] = _arg_2;
            _arg_7[1] = (_arg_3 - 1);
            var _local_12:int = 2;
            while (_local_12 > 0)
            {
                _local_12--;
                _local_14 = _arg_7[_local_12];
                _local_9 = _local_14;
                _local_12--;
                _local_15 = _arg_7[_local_12];
                _local_8 = _local_15;
                _local_10 = _arg_1[((_local_14 + _local_15) >> 1)];
                _local_16 = _local_10.offset;
                while (_local_8 <= _local_9)
                {
                    _local_17 = _arg_1[_local_8];
                    while (_local_17.offset > _local_16)
                    {
                        _local_8++;
                        _local_17 = _arg_1[_local_8];
                    };
                    _local_18 = _arg_1[_local_9];
                    while (_local_18.offset < _local_16)
                    {
                        _local_9--;
                        _local_18 = _arg_1[_local_9];
                    };
                    if (_local_8 <= _local_9)
                    {
                        _arg_1[_local_8] = _local_18;
                        _arg_1[_local_9] = _local_17;
                        _local_8++;
                        _local_9--;
                    };
                };
                if (_local_15 < _local_9)
                {
                    _arg_7[_local_12] = _local_15;
                    _local_12++;
                    _arg_7[_local_12] = _local_9;
                    _local_12++;
                };
                if (_local_8 < _local_14)
                {
                    _arg_7[_local_12] = _local_8;
                    _local_12++;
                    _arg_7[_local_12] = _local_14;
                    _local_12++;
                };
            };
            _local_8 = _arg_2;
            _local_10 = _arg_1[_local_8];
            _local_9 = (_local_8 + 1);
            while (_local_9 <= _arg_3)
            {
                if (_local_9 < _arg_3)
                {
                    _local_13 = _arg_1[_local_9];
                };
                if (((_local_9 == _arg_3) || ((_local_10.offset - _local_13.offset) > _local_11)))
                {
                    if (((_arg_4 < 4) && ((_local_9 - _local_8) > 1)))
                    {
                        this.group(_arg_1, _local_8, _local_9, (_arg_4 + 1), _arg_5, _arg_6, _arg_7);
                    };
                    if (_local_9 < _arg_3)
                    {
                        _local_8 = _local_9;
                        _local_10 = _arg_1[_local_8];
                    };
                } else
                {
                    if (_arg_4 == 4)
                    {
                        _local_13.value = _local_10;
                    };
                };
                _local_9++;
            };
        }

        public function setMaterialToAllFaces(_arg_1:Material):void
        {
            this.deleteResources();
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                _local_2.material = _arg_1;
                _local_2 = _local_2.next;
            };
        }

        public function calculateFacesNormals(_arg_1:Boolean=true):void
        {
            var _local_3:Wrapper;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            this.deleteResources();
            var _local_2:Face = this.faceList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.wrapper;
                _local_4 = _local_3.vertex;
                _local_3 = _local_3.next;
                _local_5 = _local_3.vertex;
                _local_3 = _local_3.next;
                _local_6 = _local_3.vertex;
                _local_7 = (_local_5.x - _local_4.x);
                _local_8 = (_local_5.y - _local_4.y);
                _local_9 = (_local_5.z - _local_4.z);
                _local_10 = (_local_6.x - _local_4.x);
                _local_11 = (_local_6.y - _local_4.y);
                _local_12 = (_local_6.z - _local_4.z);
                _local_13 = ((_local_12 * _local_8) - (_local_11 * _local_9));
                _local_14 = ((_local_10 * _local_9) - (_local_12 * _local_7));
                _local_15 = ((_local_11 * _local_7) - (_local_10 * _local_8));
                if (_arg_1)
                {
                    _local_16 = (((_local_13 * _local_13) + (_local_14 * _local_14)) + (_local_15 * _local_15));
                    if (_local_16 > 0.001)
                    {
                        _local_16 = (1 / Math.sqrt(_local_16));
                        _local_13 = (_local_13 * _local_16);
                        _local_14 = (_local_14 * _local_16);
                        _local_15 = (_local_15 * _local_16);
                    };
                };
                _local_2.normalX = _local_13;
                _local_2.normalY = _local_14;
                _local_2.normalZ = _local_15;
                _local_2.offset = (((_local_4.x * _local_13) + (_local_4.y * _local_14)) + (_local_4.z * _local_15));
                _local_2 = _local_2.next;
            };
        }

        public function calculateVerticesNormals(_arg_1:Boolean=false, _arg_2:Number=0):void
        {
            var _local_3:Vertex;
            var _local_4:Number;
            var _local_6:Wrapper;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Vertex;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Vector.<Vertex>;
            this.deleteResources();
            _local_3 = this.vertexList;
            while (_local_3 != null)
            {
                _local_3.normalX = 0;
                _local_3.normalY = 0;
                _local_3.normalZ = 0;
                _local_3 = _local_3.next;
            };
            var _local_5:Face = this.faceList;
            while (_local_5 != null)
            {
                _local_6 = _local_5.wrapper;
                _local_7 = _local_6.vertex;
                _local_6 = _local_6.next;
                _local_8 = _local_6.vertex;
                _local_6 = _local_6.next;
                _local_9 = _local_6.vertex;
                _local_10 = (_local_8.x - _local_7.x);
                _local_11 = (_local_8.y - _local_7.y);
                _local_12 = (_local_8.z - _local_7.z);
                _local_13 = (_local_9.x - _local_7.x);
                _local_14 = (_local_9.y - _local_7.y);
                _local_15 = (_local_9.z - _local_7.z);
                _local_16 = ((_local_15 * _local_11) - (_local_14 * _local_12));
                _local_17 = ((_local_13 * _local_12) - (_local_15 * _local_10));
                _local_18 = ((_local_14 * _local_10) - (_local_13 * _local_11));
                _local_4 = (((_local_16 * _local_16) + (_local_17 * _local_17)) + (_local_18 * _local_18));
                if (_local_4 > 0.001)
                {
                    _local_4 = (1 / Math.sqrt(_local_4));
                    _local_16 = (_local_16 * _local_4);
                    _local_17 = (_local_17 * _local_4);
                    _local_18 = (_local_18 * _local_4);
                };
                _local_6 = _local_5.wrapper;
                while (_local_6 != null)
                {
                    _local_3 = _local_6.vertex;
                    _local_3.normalX = (_local_3.normalX + _local_16);
                    _local_3.normalY = (_local_3.normalY + _local_17);
                    _local_3.normalZ = (_local_3.normalZ + _local_18);
                    _local_6 = _local_6.next;
                };
                _local_5 = _local_5.next;
            };
            if (_arg_1)
            {
                _local_19 = this.vertices;
                this.weldNormals(_local_19, 0, _local_19.length, 0, _arg_2, new Vector.<int>());
            };
            _local_3 = this.vertexList;
            while (_local_3 != null)
            {
                _local_4 = (((_local_3.normalX * _local_3.normalX) + (_local_3.normalY * _local_3.normalY)) + (_local_3.normalZ * _local_3.normalZ));
                if (_local_4 > 0.001)
                {
                    _local_4 = (1 / Math.sqrt(_local_4));
                    _local_3.normalX = (_local_3.normalX * _local_4);
                    _local_3.normalY = (_local_3.normalY * _local_4);
                    _local_3.normalZ = (_local_3.normalZ * _local_4);
                };
                _local_3 = _local_3.next;
            };
        }

        alternativa3d function weldNormals(_arg_1:Vector.<Vertex>, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Vector.<int>):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Vertex;
            var _local_12:Vertex;
            var _local_13:int;
            var _local_14:int;
            var _local_15:Number;
            var _local_16:Vertex;
            var _local_17:Vertex;
            switch (_arg_4)
            {
                case 0:
                    _local_7 = _arg_2;
                    while (_local_7 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_7];
                        _local_10.offset = _local_10.x;
                        _local_7++;
                    };
                    break;
                case 1:
                    _local_7 = _arg_2;
                    while (_local_7 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_7];
                        _local_10.offset = _local_10.y;
                        _local_7++;
                    };
                    break;
                case 2:
                    _local_7 = _arg_2;
                    while (_local_7 < _arg_3)
                    {
                        _local_10 = _arg_1[_local_7];
                        _local_10.offset = _local_10.z;
                        _local_7++;
                    };
                    break;
            };
            _arg_6[0] = _arg_2;
            _arg_6[1] = (_arg_3 - 1);
            var _local_11:int = 2;
            while (_local_11 > 0)
            {
                _local_11--;
                _local_13 = _arg_6[_local_11];
                _local_8 = _local_13;
                _local_11--;
                _local_14 = _arg_6[_local_11];
                _local_7 = _local_14;
                _local_10 = _arg_1[((_local_13 + _local_14) >> 1)];
                _local_15 = _local_10.offset;
                while (_local_7 <= _local_8)
                {
                    _local_16 = _arg_1[_local_7];
                    while (_local_16.offset > _local_15)
                    {
                        _local_7++;
                        _local_16 = _arg_1[_local_7];
                    };
                    _local_17 = _arg_1[_local_8];
                    while (_local_17.offset < _local_15)
                    {
                        _local_8--;
                        _local_17 = _arg_1[_local_8];
                    };
                    if (_local_7 <= _local_8)
                    {
                        _arg_1[_local_7] = _local_17;
                        _arg_1[_local_8] = _local_16;
                        _local_7++;
                        _local_8--;
                    };
                };
                if (_local_14 < _local_8)
                {
                    _arg_6[_local_11] = _local_14;
                    _local_11++;
                    _arg_6[_local_11] = _local_8;
                    _local_11++;
                };
                if (_local_7 < _local_13)
                {
                    _arg_6[_local_11] = _local_7;
                    _local_11++;
                    _arg_6[_local_11] = _local_13;
                    _local_11++;
                };
            };
            _local_7 = _arg_2;
            _local_10 = _arg_1[_local_7];
            _local_8 = (_local_7 + 1);
            while (_local_8 <= _arg_3)
            {
                if (_local_8 < _arg_3)
                {
                    _local_12 = _arg_1[_local_8];
                };
                if (((_local_8 == _arg_3) || ((_local_10.offset - _local_12.offset) > _arg_5)))
                {
                    if ((_local_8 - _local_7) > 1)
                    {
                        if (_arg_4 < 2)
                        {
                            this.weldNormals(_arg_1, _local_7, _local_8, (_arg_4 + 1), _arg_5, _arg_6);
                        } else
                        {
                            _local_9 = (_local_7 + 1);
                            while (_local_9 < _local_8)
                            {
                                _local_12 = _arg_1[_local_9];
                                _local_10.normalX = (_local_10.normalX + _local_12.normalX);
                                _local_10.normalY = (_local_10.normalY + _local_12.normalY);
                                _local_10.normalZ = (_local_10.normalZ + _local_12.normalZ);
                                _local_9++;
                            };
                            _local_9 = (_local_7 + 1);
                            while (_local_9 < _local_8)
                            {
                                _local_12 = _arg_1[_local_9];
                                _local_12.normalX = _local_10.normalX;
                                _local_12.normalY = _local_10.normalY;
                                _local_12.normalZ = _local_10.normalZ;
                                _local_9++;
                            };
                        };
                    };
                    if (_local_8 < _arg_3)
                    {
                        _local_7 = _local_8;
                        _local_10 = _arg_1[_local_7];
                    };
                };
                _local_8++;
            };
        }

        public function calculateVerticesNormalsByAngle(_arg_1:Number, _arg_2:Number=0):void
        {
            var _local_3:Face;
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_8:Vertex;
            var _local_9:*;
            var _local_10:Number;
            var _local_11:Face;
            this.deleteResources();
            this.calculateNormalsAndRemoveDegenerateFaces();
            var _local_6:Dictionary = new Dictionary();
            _local_5 = this.vertexList;
            while (_local_5 != null)
            {
                _local_6[_local_5] = new Dictionary();
                _local_5 = _local_5.next;
            };
            _local_3 = this.faceList;
            while (_local_3 != null)
            {
                _local_4 = _local_3.wrapper;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.vertex;
                    _local_6[_local_5][_local_3] = true;
                    _local_4 = _local_4.next;
                };
                _local_3 = _local_3.next;
            };
            var _local_7:Vector.<Vertex> = this.vertices;
            shareFaces(_local_7, 0, _local_7.length, 0, _arg_2, new Vector.<int>(), _local_6);
            this.vertexList = null;
            _arg_1 = Math.cos(_arg_1);
            _local_3 = this.faceList;
            while (_local_3 != null)
            {
                _local_4 = _local_3.wrapper;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.vertex;
                    _local_8 = new Vertex();
                    _local_8.x = _local_5.x;
                    _local_8.y = _local_5.y;
                    _local_8.z = _local_5.z;
                    _local_8.u = _local_5.u;
                    _local_8.v = _local_5.v;
                    _local_8.id = _local_5.id;
                    _local_8.normalX = _local_3.normalX;
                    _local_8.normalY = _local_3.normalY;
                    _local_8.normalZ = _local_3.normalZ;
                    for (_local_9 in _local_6[_local_5])
                    {
                        _local_11 = _local_9;
                        if (((!(_local_3 == _local_11)) && ((((_local_3.normalX * _local_11.normalX) + (_local_3.normalY * _local_11.normalY)) + (_local_3.normalZ * _local_11.normalZ)) >= _arg_1)))
                        {
                            _local_8.normalX = (_local_8.normalX + _local_11.normalX);
                            _local_8.normalY = (_local_8.normalY + _local_11.normalY);
                            _local_8.normalZ = (_local_8.normalZ + _local_11.normalZ);
                        };
                    };
                    _local_10 = (((_local_8.normalX * _local_8.normalX) + (_local_8.normalY * _local_8.normalY)) + (_local_8.normalZ * _local_8.normalZ));
                    if (_local_10 > 0.001)
                    {
                        _local_10 = (1 / Math.sqrt(_local_10));
                        _local_8.normalX = (_local_8.normalX * _local_10);
                        _local_8.normalY = (_local_8.normalY * _local_10);
                        _local_8.normalZ = (_local_8.normalZ * _local_10);
                    };
                    _local_4.vertex = _local_8;
                    _local_8.next = this.vertexList;
                    this.vertexList = _local_8;
                    _local_4 = _local_4.next;
                };
                _local_3 = _local_3.next;
            };
        }

        public function calculateVerticesNormalsBySmoothingGroups(_arg_1:Number=0):void
        {
            var _local_2:*;
            var _local_3:Face;
            var _local_4:Vertex;
            var _local_5:Wrapper;
            var _local_9:Vertex;
            var _local_10:Number;
            var _local_11:Face;
            this.deleteResources();
            this.calculateNormalsAndRemoveDegenerateFaces();
            var _local_6:Dictionary = new Dictionary();
            _local_3 = this.faceList;
            while (_local_3 != null)
            {
                if (_local_3.smoothingGroups > 0)
                {
                    _local_5 = _local_3.wrapper;
                    while (_local_5 != null)
                    {
                        _local_4 = _local_5.vertex;
                        if ((!(_local_6[_local_4])))
                        {
                            _local_6[_local_4] = new Dictionary();
                        };
                        _local_6[_local_4][_local_3] = true;
                        _local_5 = _local_5.next;
                    };
                };
                _local_3 = _local_3.next;
            };
            var _local_7:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_8:int;
            for (_local_2 in _local_6)
            {
                _local_7[_local_8] = _local_2;
                _local_8++;
            };
            if (_local_8 > 0)
            {
                shareFaces(_local_7, 0, _local_8, 0, _arg_1, new Vector.<int>(), _local_6);
            };
            this.vertexList = null;
            _local_3 = this.faceList;
            while (_local_3 != null)
            {
                _local_5 = _local_3.wrapper;
                while (_local_5 != null)
                {
                    _local_4 = _local_5.vertex;
                    _local_9 = new Vertex();
                    _local_9.x = _local_4.x;
                    _local_9.y = _local_4.y;
                    _local_9.z = _local_4.z;
                    _local_9.u = _local_4.u;
                    _local_9.v = _local_4.v;
                    _local_9.id = _local_4.id;
                    _local_9.normalX = _local_3.normalX;
                    _local_9.normalY = _local_3.normalY;
                    _local_9.normalZ = _local_3.normalZ;
                    if (_local_3.smoothingGroups > 0)
                    {
                        for (_local_2 in _local_6[_local_4])
                        {
                            _local_11 = _local_2;
                            if (((!(_local_3 == _local_11)) && ((_local_3.smoothingGroups & _local_11.smoothingGroups) > 0)))
                            {
                                _local_9.normalX = (_local_9.normalX + _local_11.normalX);
                                _local_9.normalY = (_local_9.normalY + _local_11.normalY);
                                _local_9.normalZ = (_local_9.normalZ + _local_11.normalZ);
                            };
                        };
                        _local_10 = (((_local_9.normalX * _local_9.normalX) + (_local_9.normalY * _local_9.normalY)) + (_local_9.normalZ * _local_9.normalZ));
                        if (_local_10 > 0.001)
                        {
                            _local_10 = (1 / Math.sqrt(_local_10));
                            _local_9.normalX = (_local_9.normalX * _local_10);
                            _local_9.normalY = (_local_9.normalY * _local_10);
                            _local_9.normalZ = (_local_9.normalZ * _local_10);
                        };
                    };
                    _local_5.vertex = _local_9;
                    _local_9.next = this.vertexList;
                    this.vertexList = _local_9;
                    _local_5 = _local_5.next;
                };
                _local_3 = _local_3.next;
            };
        }

        private function calculateNormalsAndRemoveDegenerateFaces():void
        {
            var _local_2:Face;
            var _local_3:Wrapper;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_1:Face = this.faceList;
            this.faceList = null;
            while (_local_1 != null)
            {
                _local_2 = _local_1.next;
                _local_3 = _local_1.wrapper;
                _local_4 = _local_3.vertex;
                _local_3 = _local_3.next;
                _local_5 = _local_3.vertex;
                _local_3 = _local_3.next;
                _local_6 = _local_3.vertex;
                _local_7 = (_local_5.x - _local_4.x);
                _local_8 = (_local_5.y - _local_4.y);
                _local_9 = (_local_5.z - _local_4.z);
                _local_10 = (_local_6.x - _local_4.x);
                _local_11 = (_local_6.y - _local_4.y);
                _local_12 = (_local_6.z - _local_4.z);
                _local_1.normalX = ((_local_12 * _local_8) - (_local_11 * _local_9));
                _local_1.normalY = ((_local_10 * _local_9) - (_local_12 * _local_7));
                _local_1.normalZ = ((_local_11 * _local_7) - (_local_10 * _local_8));
                _local_13 = (((_local_1.normalX * _local_1.normalX) + (_local_1.normalY * _local_1.normalY)) + (_local_1.normalZ * _local_1.normalZ));
                if (_local_13 > 0.001)
                {
                    _local_13 = (1 / Math.sqrt(_local_13));
                    _local_1.normalX = (_local_1.normalX * _local_13);
                    _local_1.normalY = (_local_1.normalY * _local_13);
                    _local_1.normalZ = (_local_1.normalZ * _local_13);
                    _local_1.offset = (((_local_4.x * _local_1.normalX) + (_local_4.y * _local_1.normalY)) + (_local_4.z * _local_1.normalZ));
                    _local_1.next = this.faceList;
                    this.faceList = _local_1;
                } else
                {
                    _local_1.next = null;
                };
                _local_1 = _local_2;
            };
        }

        public function optimizeForDynamicBSP(_arg_1:int=1):void
        {
            var _local_3:Face;
            var _local_5:Face;
            var _local_6:Face;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:int;
            var _local_14:Face;
            var _local_15:Wrapper;
            var _local_16:Vertex;
            var _local_17:Vertex;
            var _local_18:Vertex;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Boolean;
            var _local_23:Boolean;
            var _local_24:Vertex;
            var _local_25:Number;
            this.deleteResources();
            var _local_2:Face = this.faceList;
            var _local_4:int;
            while (_local_4 < _arg_1)
            {
                _local_5 = null;
                _local_6 = _local_2;
                while (_local_6 != null)
                {
                    _local_7 = _local_6.normalX;
                    _local_8 = _local_6.normalY;
                    _local_9 = _local_6.normalZ;
                    _local_10 = _local_6.offset;
                    _local_11 = (_local_10 - this.threshold);
                    _local_12 = (_local_10 + this.threshold);
                    _local_13 = 0;
                    _local_14 = _local_2;
                    while (_local_14 != null)
                    {
                        if (_local_14 != _local_6)
                        {
                            _local_15 = _local_14.wrapper;
                            _local_16 = _local_15.vertex;
                            _local_15 = _local_15.next;
                            _local_17 = _local_15.vertex;
                            _local_15 = _local_15.next;
                            _local_18 = _local_15.vertex;
                            _local_15 = _local_15.next;
                            _local_19 = (((_local_16.x * _local_7) + (_local_16.y * _local_8)) + (_local_16.z * _local_9));
                            _local_20 = (((_local_17.x * _local_7) + (_local_17.y * _local_8)) + (_local_17.z * _local_9));
                            _local_21 = (((_local_18.x * _local_7) + (_local_18.y * _local_8)) + (_local_18.z * _local_9));
                            _local_22 = (((_local_19 < _local_11) || (_local_20 < _local_11)) || (_local_21 < _local_11));
                            _local_23 = (((_local_19 > _local_12) || (_local_20 > _local_12)) || (_local_21 > _local_12));
                            while (_local_15 != null)
                            {
                                _local_24 = _local_15.vertex;
                                _local_25 = (((_local_24.x * _local_7) + (_local_24.y * _local_8)) + (_local_24.z * _local_9));
                                if (_local_25 < _local_11)
                                {
                                    _local_22 = true;
                                    if (_local_23) break;
                                } else
                                {
                                    if (_local_25 > _local_12)
                                    {
                                        _local_23 = true;
                                        if (_local_22) break;
                                    };
                                };
                                _local_15 = _local_15.next;
                            };
                            if (((_local_23) && (_local_22)))
                            {
                                _local_13++;
                                if (_local_13 > _local_4) break;
                            };
                        };
                        _local_14 = _local_14.next;
                    };
                    if (_local_14 == null)
                    {
                        if (_local_5 != null)
                        {
                            _local_5.next = _local_6.next;
                        } else
                        {
                            _local_2 = _local_6.next;
                        };
                        if (_local_3 != null)
                        {
                            _local_3.next = _local_6;
                        } else
                        {
                            this.faceList = _local_6;
                        };
                        _local_3 = _local_6;
                    } else
                    {
                        _local_5 = _local_6;
                    };
                    _local_6 = _local_6.next;
                };
                if (_local_2 == null) break;
                _local_4++;
            };
            if (_local_3 != null)
            {
                _local_3.next = _local_2;
            };
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            var _local_11:Vector3D;
            var _local_12:Face;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Wrapper;
            var _local_25:Vertex;
            var _local_26:Vertex;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:RayIntersectionData;
            if (((!(_arg_3 == null)) && (_arg_3[this])))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            var _local_5:Number = _arg_1.x;
            var _local_6:Number = _arg_1.y;
            var _local_7:Number = _arg_1.z;
            var _local_8:Number = _arg_2.x;
            var _local_9:Number = _arg_2.y;
            var _local_10:Number = _arg_2.z;
            var _local_13:Number = 1E22;
            var _local_14:Face = this.faceList;
            while (_local_14 != null)
            {
                _local_15 = _local_14.normalX;
                _local_16 = _local_14.normalY;
                _local_17 = _local_14.normalZ;
                _local_18 = (((_local_8 * _local_15) + (_local_9 * _local_16)) + (_local_10 * _local_17));
                if (_local_18 < 0)
                {
                    _local_19 = ((((_local_5 * _local_15) + (_local_6 * _local_16)) + (_local_7 * _local_17)) - _local_14.offset);
                    if (_local_19 > 0)
                    {
                        _local_20 = (-(_local_19) / _local_18);
                        if (((_local_11 == null) || (_local_20 < _local_13)))
                        {
                            _local_21 = (_local_5 + (_local_8 * _local_20));
                            _local_22 = (_local_6 + (_local_9 * _local_20));
                            _local_23 = (_local_7 + (_local_10 * _local_20));
                            _local_24 = _local_14.wrapper;
                            while (_local_24 != null)
                            {
                                _local_25 = _local_24.vertex;
                                _local_26 = ((_local_24.next != null) ? _local_24.next.vertex : _local_14.wrapper.vertex);
                                _local_27 = (_local_26.x - _local_25.x);
                                _local_28 = (_local_26.y - _local_25.y);
                                _local_29 = (_local_26.z - _local_25.z);
                                _local_30 = (_local_21 - _local_25.x);
                                _local_31 = (_local_22 - _local_25.y);
                                _local_32 = (_local_23 - _local_25.z);
                                if ((((((_local_32 * _local_28) - (_local_31 * _local_29)) * _local_15) + (((_local_30 * _local_29) - (_local_32 * _local_27)) * _local_16)) + (((_local_31 * _local_27) - (_local_30 * _local_28)) * _local_17)) < 0) break;
                                _local_24 = _local_24.next;
                            };
                            if (_local_24 == null)
                            {
                                if (_local_20 < _local_13)
                                {
                                    _local_13 = _local_20;
                                    if (_local_11 == null)
                                    {
                                        _local_11 = new Vector3D();
                                    };
                                    _local_11.x = _local_21;
                                    _local_11.y = _local_22;
                                    _local_11.z = _local_23;
                                    _local_12 = _local_14;
                                };
                            };
                        };
                    };
                };
                _local_14 = _local_14.next;
            };
            if (_local_11 != null)
            {
                _local_33 = new RayIntersectionData();
                _local_33.object = this;
                _local_33.face = _local_12;
                _local_33.point = _local_11;
                _local_33.uv = _local_12.getUV(_local_11);
                _local_33.time = _local_13;
                return (_local_33);
            };
            return (null);
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Wrapper;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_9:Face = this.faceList;
            while (_local_9 != null)
            {
                _local_10 = _local_9.normalX;
                _local_11 = _local_9.normalY;
                _local_12 = _local_9.normalZ;
                _local_13 = (((_arg_4 * _local_10) + (_arg_5 * _local_11)) + (_arg_6 * _local_12));
                if (_local_13 < 0)
                {
                    _local_14 = ((((_arg_1 * _local_10) + (_arg_2 * _local_11)) + (_arg_3 * _local_12)) - _local_9.offset);
                    if (_local_14 > 0)
                    {
                        _local_15 = (-(_local_14) / _local_13);
                        if (_local_15 < _arg_7)
                        {
                            _local_16 = (_arg_1 + (_arg_4 * _local_15));
                            _local_17 = (_arg_2 + (_arg_5 * _local_15));
                            _local_18 = (_arg_3 + (_arg_6 * _local_15));
                            _local_19 = _local_9.wrapper;
                            while (_local_19 != null)
                            {
                                _local_20 = _local_19.vertex;
                                _local_21 = ((_local_19.next != null) ? _local_19.next.vertex : _local_9.wrapper.vertex);
                                _local_22 = (_local_21.x - _local_20.x);
                                _local_23 = (_local_21.y - _local_20.y);
                                _local_24 = (_local_21.z - _local_20.z);
                                _local_25 = (_local_16 - _local_20.x);
                                _local_26 = (_local_17 - _local_20.y);
                                _local_27 = (_local_18 - _local_20.z);
                                if ((((((_local_27 * _local_23) - (_local_26 * _local_24)) * _local_10) + (((_local_25 * _local_24) - (_local_27 * _local_22)) * _local_11)) + (((_local_26 * _local_22) - (_local_25 * _local_23)) * _local_12)) < 0) break;
                                _local_19 = _local_19.next;
                            };
                            if (_local_19 == null)
                            {
                                return (true);
                            };
                        };
                    };
                };
                _local_9 = _local_9.next;
            };
            return (false);
        }

        override alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
            var _local_9:Vertex;
            var _local_11:Number;
            var _local_12:Wrapper;
            if (((!(_arg_7 == null)) && (_arg_7[this])))
            {
                return;
            };
            var _local_8:Vector3D = calculateSphere(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if ((!(boundIntersectSphere(_local_8, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return;
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_9 = this.vertexList;
                while (_local_9 != null)
                {
                    _local_9.transformId = 0;
                    _local_9 = _local_9.next;
                };
            };
            transformId++;
            var _local_10:Face = this.faceList;
            while (_local_10 != null)
            {
                _local_11 = ((((_local_8.x * _local_10.normalX) + (_local_8.y * _local_10.normalY)) + (_local_8.z * _local_10.normalZ)) - _local_10.offset);
                if (((_local_11 < _local_8.w) && (_local_11 > -(_local_8.w))))
                {
                    _local_12 = _local_10.wrapper;
                    while (_local_12 != null)
                    {
                        _local_9 = _local_12.vertex;
                        if (_local_9.transformId != transformId)
                        {
                            _local_9.cameraX = ((((ma * _local_9.x) + (mb * _local_9.y)) + (mc * _local_9.z)) + md);
                            _local_9.cameraY = ((((me * _local_9.x) + (mf * _local_9.y)) + (mg * _local_9.z)) + mh);
                            _local_9.cameraZ = ((((mi * _local_9.x) + (mj * _local_9.y)) + (mk * _local_9.z)) + ml);
                            _local_9.transformId = transformId;
                        };
                        _local_12 = _local_12.next;
                    };
                    _arg_6.push(_local_10);
                };
                _local_10 = _local_10.next;
            };
        }

        override public function clone():Object3D
        {
            var _local_1:Mesh = new Mesh();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Face;
            var _local_7:Vertex;
            var _local_8:Face;
            var _local_9:Wrapper;
            var _local_10:Wrapper;
            var _local_11:Wrapper;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Mesh = (_arg_1 as Mesh);
            this.clipping = _local_2.clipping;
            this.sorting = _local_2.sorting;
            this.threshold = _local_2.threshold;
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_7 = new Vertex();
                _local_7.x = _local_3.x;
                _local_7.y = _local_3.y;
                _local_7.z = _local_3.z;
                _local_7.u = _local_3.u;
                _local_7.v = _local_3.v;
                _local_7.normalX = _local_3.normalX;
                _local_7.normalY = _local_3.normalY;
                _local_7.normalZ = _local_3.normalZ;
                _local_7.offset = _local_3.offset;
                _local_7.id = _local_3.id;
                _local_3.value = _local_7;
                if (_local_4 != null)
                {
                    _local_4.next = _local_7;
                } else
                {
                    this.vertexList = _local_7;
                };
                _local_4 = _local_7;
                _local_3 = _local_3.next;
            };
            var _local_6:Face = _local_2.faceList;
            while (_local_6 != null)
            {
                _local_8 = new Face();
                _local_8.material = _local_6.material;
                _local_8.smoothingGroups = _local_6.smoothingGroups;
                _local_8.id = _local_6.id;
                _local_8.normalX = _local_6.normalX;
                _local_8.normalY = _local_6.normalY;
                _local_8.normalZ = _local_6.normalZ;
                _local_8.offset = _local_6.offset;
                _local_9 = null;
                _local_10 = _local_6.wrapper;
                while (_local_10 != null)
                {
                    _local_11 = new Wrapper();
                    _local_11.vertex = _local_10.vertex.value;
                    if (_local_9 != null)
                    {
                        _local_9.next = _local_11;
                    } else
                    {
                        _local_8.wrapper = _local_11;
                    };
                    _local_9 = _local_11;
                    _local_10 = _local_10.next;
                };
                if (_local_5 != null)
                {
                    _local_5.next = _local_8;
                } else
                {
                    this.faceList = _local_8;
                };
                _local_5 = _local_8;
                _local_6 = _local_6.next;
            };
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_3.value = null;
                _local_3 = _local_3.next;
            };
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:Face;
            var _local_4:Vertex;
            if (this.faceList == null)
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
            if (((concatenatedAlpha >= 1) && (concatenatedBlendMode == "normal")))
            {
                this.addOpaque(_arg_1);
                _local_2 = this.transparentList;
            } else
            {
                _local_2 = this.faceList;
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
            var _local_3:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_3 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
            if (_local_2 == null)
            {
                return;
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_4 = this.vertexList;
                while (_local_4 != null)
                {
                    _local_4.transformId = 0;
                    _local_4 = _local_4.next;
                };
            };
            transformId++;
            calculateInverseMatrix();
            _local_2 = this.prepareFaces(_arg_1, _local_2);
            if (_local_2 == null)
            {
                return;
            };
            if (culling > 0)
            {
                if (this.clipping == 1)
                {
                    _local_2 = _arg_1.cull(_local_2, culling);
                } else
                {
                    _local_2 = _arg_1.clip(_local_2, culling);
                };
                if (_local_2 == null)
                {
                    return;
                };
            };
            if (_local_2.processNext != null)
            {
                if (this.sorting == 1)
                {
                    _local_2 = _arg_1.sortByAverageZ(_local_2);
                } else
                {
                    if (this.sorting == 2)
                    {
                        _local_2 = _arg_1.sortByDynamicBSP(_local_2, this.threshold);
                    };
                };
            };
            if ((_local_3 & Debug.EDGES))
            {
                Debug.drawEdges(_arg_1, _local_2, 0xFFFFFF);
            };
            this.drawFaces(_arg_1, _local_2);
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_2:Face;
            var _local_4:Vertex;
            if (this.faceList == null)
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
            if (((concatenatedAlpha >= 1) && (concatenatedBlendMode == "normal")))
            {
                this.addOpaque(_arg_1);
                _local_2 = this.transparentList;
            } else
            {
                _local_2 = this.faceList;
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
            var _local_3:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_3 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
            if (_local_2 == null)
            {
                return (null);
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_4 = this.vertexList;
                while (_local_4 != null)
                {
                    _local_4.transformId = 0;
                    _local_4 = _local_4.next;
                };
            };
            transformId++;
            calculateInverseMatrix();
            _local_2 = this.prepareFaces(_arg_1, _local_2);
            if (_local_2 == null)
            {
                return (null);
            };
            if (culling > 0)
            {
                if (this.clipping == 1)
                {
                    _local_2 = _arg_1.cull(_local_2, culling);
                } else
                {
                    _local_2 = _arg_1.clip(_local_2, culling);
                };
                if (_local_2 == null)
                {
                    return (null);
                };
            };
            return (VG.create(this, _local_2, this.sorting, _local_3, false));
        }

        alternativa3d function prepareResources():void
        {
            var _local_1:Vector.<Number>;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Vertex;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Face;
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Wrapper;
            var _local_12:Dictionary;
            var _local_13:Vector.<uint>;
            var _local_14:int;
            var _local_15:*;
            var _local_16:Face;
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
                if (_local_3 > 0)
                {
                    this.vertexBuffer = new VertexBufferResource(_local_1, 8);
                };
                _local_12 = new Dictionary();
                _local_8 = this.faceList;
                while (_local_8 != null)
                {
                    _local_9 = _local_8.next;
                    _local_8.next = null;
                    if (((!(_local_8.material == null)) && ((!(_local_8.material.transparent)) || (_local_8.material.alphaTestThreshold > 0))))
                    {
                        _local_8.next = _local_12[_local_8.material];
                        _local_12[_local_8.material] = _local_8;
                    } else
                    {
                        if (_local_10 != null)
                        {
                            _local_10.next = _local_8;
                        } else
                        {
                            this.transparentList = _local_8;
                        };
                        _local_10 = _local_8;
                    };
                    _local_8 = _local_9;
                };
                this.faceList = this.transparentList;
                _local_13 = new Vector.<uint>();
                _local_14 = 0;
                for (_local_15 in _local_12)
                {
                    _local_16 = _local_12[_local_15];
                    this.opaqueMaterials[this.opaqueLength] = _local_16.material;
                    this.opaqueBegins[this.opaqueLength] = (this.numTriangles * 3);
                    _local_8 = _local_16;
                    while (_local_8 != null)
                    {
                        _local_11 = _local_8.wrapper;
                        _local_5 = _local_11.vertex.index;
                        _local_11 = _local_11.next;
                        _local_6 = _local_11.vertex.index;
                        _local_11 = _local_11.next;
                        while (_local_11 != null)
                        {
                            _local_7 = _local_11.vertex.index;
                            _local_13[_local_14] = _local_5;
                            _local_14++;
                            _local_13[_local_14] = _local_6;
                            _local_14++;
                            _local_13[_local_14] = _local_7;
                            _local_14++;
                            _local_6 = _local_7;
                            this.numTriangles++;
                            _local_11 = _local_11.next;
                        };
                        if (_local_8.next == null)
                        {
                            _local_10 = _local_8;
                        };
                        _local_8 = _local_8.next;
                    };
                    this.opaqueNums[this.opaqueLength] = (this.numTriangles - (this.opaqueBegins[this.opaqueLength] / 3));
                    this.opaqueLength++;
                    _local_10.next = this.faceList;
                    this.faceList = _local_16;
                };
                this.numOpaqueTriangles = this.numTriangles;
                _local_8 = this.transparentList;
                while (_local_8 != null)
                {
                    _local_11 = _local_8.wrapper;
                    _local_5 = _local_11.vertex.index;
                    _local_11 = _local_11.next;
                    _local_6 = _local_11.vertex.index;
                    _local_11 = _local_11.next;
                    while (_local_11 != null)
                    {
                        _local_7 = _local_11.vertex.index;
                        _local_13[_local_14] = _local_5;
                        _local_14++;
                        _local_13[_local_14] = _local_6;
                        _local_14++;
                        _local_13[_local_14] = _local_7;
                        _local_14++;
                        _local_6 = _local_7;
                        this.numTriangles++;
                        _local_11 = _local_11.next;
                    };
                    _local_8 = _local_8.next;
                };
                if (_local_14 > 0)
                {
                    this.indexBuffer = new IndexBufferResource(_local_13);
                };
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
                this.numOpaqueTriangles = 0;
                this.opaqueMaterials.length = 0;
                this.opaqueBegins.length = 0;
                this.opaqueNums.length = 0;
                this.opaqueLength = 0;
                this.transparentList = null;
            };
        }

        alternativa3d function addOpaque(_arg_1:Camera3D):void
        {
            var _local_2:int;
            while (_local_2 < this.opaqueLength)
            {
                _arg_1.addOpaque(this.opaqueMaterials[_local_2], this.vertexBuffer, this.indexBuffer, this.opaqueBegins[_local_2], this.opaqueNums[_local_2], this);
                _local_2++;
            };
        }

        alternativa3d function prepareFaces(_arg_1:Camera3D, _arg_2:Face):Face
        {
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:Face;
            var _local_6:Wrapper;
            var _local_7:Vertex;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            _local_5 = _arg_2;
            while (_local_5 != null)
            {
                if ((((_local_5.normalX * imd) + (_local_5.normalY * imh)) + (_local_5.normalZ * iml)) > _local_5.offset)
                {
                    _local_6 = _local_5.wrapper;
                    while (_local_6 != null)
                    {
                        _local_7 = _local_6.vertex;
                        if (_local_7.transformId != transformId)
                        {
                            _local_8 = _local_7.x;
                            _local_9 = _local_7.y;
                            _local_10 = _local_7.z;
                            _local_7.cameraX = ((((ma * _local_8) + (mb * _local_9)) + (mc * _local_10)) + md);
                            _local_7.cameraY = ((((me * _local_8) + (mf * _local_9)) + (mg * _local_10)) + mh);
                            _local_7.cameraZ = ((((mi * _local_8) + (mj * _local_9)) + (mk * _local_10)) + ml);
                            _local_7.transformId = transformId;
                            _local_7.drawId = 0;
                        };
                        _local_6 = _local_6.next;
                    };
                    if (_local_3 != null)
                    {
                        _local_4.processNext = _local_5;
                    } else
                    {
                        _local_3 = _local_5;
                    };
                    _local_4 = _local_5;
                };
                _local_5 = _local_5.next;
            };
            if (_local_4 != null)
            {
                _local_4.processNext = null;
            };
            return (_local_3);
        }

        alternativa3d function drawFaces(_arg_1:Camera3D, _arg_2:Face):void
        {
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:Face;
            _local_5 = _arg_2;
            while (_local_5 != null)
            {
                _local_3 = _local_5.processNext;
                if (((_local_3 == null) || (!(_local_3.material == _arg_2.material))))
                {
                    _local_5.processNext = null;
                    if (_arg_2.material != null)
                    {
                        _arg_2.processNegative = _local_4;
                        _local_4 = _arg_2;
                    } else
                    {
                        while (_arg_2 != null)
                        {
                            _local_5 = _arg_2.processNext;
                            _arg_2.processNext = null;
                            _arg_2 = _local_5;
                        };
                    };
                    _arg_2 = _local_3;
                };
                _local_5 = _local_3;
            };
            _arg_2 = _local_4;
            while (_arg_2 != null)
            {
                _local_3 = _arg_2.processNegative;
                _arg_2.processNegative = null;
                _arg_1.addTransparent(_arg_2, this);
                _arg_2 = _local_3;
            };
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            var _local_3:Vertex;
            _local_3 = this.vertexList;
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
            var _local_5:Vector.<Object3D>;
            var _local_6:Vector3D;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Vertex;
            var _local_10:Vertex;
            var _local_11:Face;
            var _local_12:Mesh;
            var _local_13:Mesh;
            var _local_14:Face;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Face;
            var _local_18:Wrapper;
            var _local_19:Vertex;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Boolean;
            var _local_23:Boolean;
            var _local_24:Face;
            var _local_25:Face;
            var _local_26:Wrapper;
            var _local_27:Wrapper;
            var _local_28:Wrapper;
            var _local_29:Number;
            var _local_30:Vertex;
            this.deleteResources();
            _local_5 = new Vector.<Object3D>(2);
            _local_6 = calculatePlane(_arg_1, _arg_2, _arg_3);
            _local_7 = (_local_6.w - _arg_4);
            _local_8 = (_local_6.w + _arg_4);
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
            _local_11 = this.faceList;
            this.faceList = null;
            _local_12 = (this.clone() as Mesh);
            _local_13 = (this.clone() as Mesh);
            _local_16 = _local_11;
            while (_local_16 != null)
            {
                _local_17 = _local_16.next;
                _local_18 = _local_16.wrapper;
                _local_19 = _local_18.vertex;
                _local_18 = _local_18.next;
                _local_20 = _local_18.vertex;
                _local_18 = _local_18.next;
                _local_21 = _local_18.vertex;
                _local_22 = (((_local_19.offset < _local_7) || (_local_20.offset < _local_7)) || (_local_21.offset < _local_7));
                _local_23 = (((_local_19.offset > _local_8) || (_local_20.offset > _local_8)) || (_local_21.offset > _local_8));
                _local_18 = _local_18.next;
                while (_local_18 != null)
                {
                    _local_9 = _local_18.vertex;
                    if (_local_9.offset < _local_7)
                    {
                        _local_22 = true;
                    } else
                    {
                        if (_local_9.offset > _local_8)
                        {
                            _local_23 = true;
                        };
                    };
                    _local_18 = _local_18.next;
                };
                if ((!(_local_22)))
                {
                    if (_local_15 != null)
                    {
                        _local_15.next = _local_16;
                    } else
                    {
                        _local_13.faceList = _local_16;
                    };
                    _local_15 = _local_16;
                } else
                {
                    if ((!(_local_23)))
                    {
                        if (_local_14 != null)
                        {
                            _local_14.next = _local_16;
                        } else
                        {
                            _local_12.faceList = _local_16;
                        };
                        _local_14 = _local_16;
                        _local_18 = _local_16.wrapper;
                        while (_local_18 != null)
                        {
                            if (_local_18.vertex.value != null)
                            {
                                _local_18.vertex = _local_18.vertex.value;
                            };
                            _local_18 = _local_18.next;
                        };
                    } else
                    {
                        _local_24 = new Face();
                        _local_25 = new Face();
                        _local_26 = null;
                        _local_27 = null;
                        _local_18 = _local_16.wrapper.next.next;
                        while (_local_18.next != null)
                        {
                            _local_18 = _local_18.next;
                        };
                        _local_19 = _local_18.vertex;
                        _local_18 = _local_16.wrapper;
                        while (_local_18 != null)
                        {
                            _local_20 = _local_18.vertex;
                            if ((((_local_19.offset < _local_7) && (_local_20.offset > _local_8)) || ((_local_19.offset > _local_8) && (_local_20.offset < _local_7))))
                            {
                                _local_29 = ((_local_6.w - _local_19.offset) / (_local_20.offset - _local_19.offset));
                                _local_9 = new Vertex();
                                _local_9.x = (_local_19.x + ((_local_20.x - _local_19.x) * _local_29));
                                _local_9.y = (_local_19.y + ((_local_20.y - _local_19.y) * _local_29));
                                _local_9.z = (_local_19.z + ((_local_20.z - _local_19.z) * _local_29));
                                _local_9.u = (_local_19.u + ((_local_20.u - _local_19.u) * _local_29));
                                _local_9.v = (_local_19.v + ((_local_20.v - _local_19.v) * _local_29));
                                _local_9.normalX = (_local_19.normalX + ((_local_20.normalX - _local_19.normalX) * _local_29));
                                _local_9.normalY = (_local_19.normalY + ((_local_20.normalY - _local_19.normalY) * _local_29));
                                _local_9.normalZ = (_local_19.normalZ + ((_local_20.normalZ - _local_19.normalZ) * _local_29));
                                _local_28 = new Wrapper();
                                _local_28.vertex = _local_9;
                                if (_local_26 != null)
                                {
                                    _local_26.next = _local_28;
                                } else
                                {
                                    _local_24.wrapper = _local_28;
                                };
                                _local_26 = _local_28;
                                _local_30 = new Vertex();
                                _local_30.x = _local_9.x;
                                _local_30.y = _local_9.y;
                                _local_30.z = _local_9.z;
                                _local_30.u = _local_9.u;
                                _local_30.v = _local_9.v;
                                _local_30.normalX = _local_9.normalX;
                                _local_30.normalY = _local_9.normalY;
                                _local_30.normalZ = _local_9.normalZ;
                                _local_28 = new Wrapper();
                                _local_28.vertex = _local_30;
                                if (_local_27 != null)
                                {
                                    _local_27.next = _local_28;
                                } else
                                {
                                    _local_25.wrapper = _local_28;
                                };
                                _local_27 = _local_28;
                            };
                            if (_local_20.offset < _local_7)
                            {
                                _local_28 = _local_18.create();
                                _local_28.vertex = _local_20;
                                if (_local_26 != null)
                                {
                                    _local_26.next = _local_28;
                                } else
                                {
                                    _local_24.wrapper = _local_28;
                                };
                                _local_26 = _local_28;
                            } else
                            {
                                if (_local_20.offset > _local_8)
                                {
                                    _local_28 = _local_18.create();
                                    _local_28.vertex = _local_20;
                                    if (_local_27 != null)
                                    {
                                        _local_27.next = _local_28;
                                    } else
                                    {
                                        _local_25.wrapper = _local_28;
                                    };
                                    _local_27 = _local_28;
                                } else
                                {
                                    _local_28 = _local_18.create();
                                    _local_28.vertex = _local_20.value;
                                    if (_local_26 != null)
                                    {
                                        _local_26.next = _local_28;
                                    } else
                                    {
                                        _local_24.wrapper = _local_28;
                                    };
                                    _local_26 = _local_28;
                                    _local_28 = _local_18.create();
                                    _local_28.vertex = _local_20;
                                    if (_local_27 != null)
                                    {
                                        _local_27.next = _local_28;
                                    } else
                                    {
                                        _local_25.wrapper = _local_28;
                                    };
                                    _local_27 = _local_28;
                                };
                            };
                            _local_19 = _local_20;
                            _local_18 = _local_18.next;
                        };
                        _local_24.material = _local_16.material;
                        _local_24.calculateBestSequenceAndNormal();
                        if (_local_14 != null)
                        {
                            _local_14.next = _local_24;
                        } else
                        {
                            _local_12.faceList = _local_24;
                        };
                        _local_14 = _local_24;
                        _local_25.material = _local_16.material;
                        _local_25.calculateBestSequenceAndNormal();
                        if (_local_15 != null)
                        {
                            _local_15.next = _local_25;
                        } else
                        {
                            _local_13.faceList = _local_25;
                        };
                        _local_15 = _local_25;
                    };
                };
                _local_16 = _local_17;
            };
            if (_local_14 != null)
            {
                _local_14.next = null;
                _local_12.transformId++;
                _local_12.collectVertices();
                _local_12.calculateBounds();
                _local_5[0] = _local_12;
            };
            if (_local_15 != null)
            {
                _local_15.next = null;
                _local_13.transformId++;
                _local_13.collectVertices();
                _local_13.calculateBounds();
                _local_5[1] = _local_13;
            };
            return (_local_5);
        }

        private function collectVertices():void
        {
            var _local_1:Face;
            var _local_2:Wrapper;
            var _local_3:Vertex;
            _local_1 = this.faceList;
            while (_local_1 != null)
            {
                _local_2 = _local_1.wrapper;
                while (_local_2 != null)
                {
                    _local_3 = _local_2.vertex;
                    if (_local_3.transformId != transformId)
                    {
                        _local_3.next = this.vertexList;
                        this.vertexList = _local_3;
                        _local_3.transformId = transformId;
                        _local_3.value = null;
                    };
                    _local_2 = _local_2.next;
                };
                _local_1 = _local_1.next;
            };
        }


    }
}//package alternativa.engine3d.objects