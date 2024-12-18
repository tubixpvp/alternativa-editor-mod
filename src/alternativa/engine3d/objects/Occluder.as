package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Wrapper;
    import flash.display.Sprite;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Occluder extends Object3D 
    {

        alternativa3d var faceList:Face;
        alternativa3d var edgeList:Edge;
        alternativa3d var vertexList:Vertex;
        public var minSize:Number = 0;


        public function createForm(_arg_1:Mesh, _arg_2:Boolean=false):void
        {
            this.destroyForm();
            if ((!(_arg_2)))
            {
                _arg_1 = (_arg_1.clone() as Mesh);
            };
            this.faceList = _arg_1.faceList;
            this.vertexList = _arg_1.vertexList;
            _arg_1.faceList = null;
            _arg_1.vertexList = null;
            var _local_3:Vertex = this.vertexList;
            while (_local_3 != null)
            {
                _local_3.transformId = 0;
                _local_3.id = null;
                _local_3 = _local_3.next;
            };
            var _local_4:Face = this.faceList;
            while (_local_4 != null)
            {
                _local_4.id = null;
                _local_4 = _local_4.next;
            };
            var _local_5:String = this.calculateEdges();
            if (_local_5 != null)
            {
                this.destroyForm();
                throw (new ArgumentError(_local_5));
            };
            calculateBounds();
        }

        public function destroyForm():void
        {
            this.faceList = null;
            this.edgeList = null;
            this.vertexList = null;
        }

        override public function clone():Object3D
        {
            var _local_1:Occluder = new Occluder();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:Vertex;
            var _local_4:Face;
            var _local_5:Vertex;
            var _local_6:Face;
            var _local_7:Edge;
            var _local_9:Vertex;
            var _local_10:Face;
            var _local_11:Wrapper;
            var _local_12:Wrapper;
            var _local_13:Wrapper;
            var _local_14:Edge;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Occluder = (_arg_1 as Occluder);
            this.minSize = _local_2.minSize;
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_9 = new Vertex();
                _local_9.x = _local_3.x;
                _local_9.y = _local_3.y;
                _local_9.z = _local_3.z;
                _local_9.u = _local_3.u;
                _local_9.v = _local_3.v;
                _local_9.normalX = _local_3.normalX;
                _local_9.normalY = _local_3.normalY;
                _local_9.normalZ = _local_3.normalZ;
                _local_3.value = _local_9;
                if (_local_5 != null)
                {
                    _local_5.next = _local_9;
                } else
                {
                    this.vertexList = _local_9;
                };
                _local_5 = _local_9;
                _local_3 = _local_3.next;
            };
            _local_4 = _local_2.faceList;
            while (_local_4 != null)
            {
                _local_10 = new Face();
                _local_10.material = _local_4.material;
                _local_10.normalX = _local_4.normalX;
                _local_10.normalY = _local_4.normalY;
                _local_10.normalZ = _local_4.normalZ;
                _local_10.offset = _local_4.offset;
                _local_4.processNext = _local_10;
                _local_11 = null;
                _local_12 = _local_4.wrapper;
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
                if (_local_6 != null)
                {
                    _local_6.next = _local_10;
                } else
                {
                    this.faceList = _local_10;
                };
                _local_6 = _local_10;
                _local_4 = _local_4.next;
            };
            var _local_8:Edge = _local_2.edgeList;
            while (_local_8 != null)
            {
                _local_14 = new Edge();
                _local_14.a = _local_8.a.value;
                _local_14.b = _local_8.b.value;
                _local_14.left = _local_8.left.processNext;
                _local_14.right = _local_8.right.processNext;
                if (_local_7 != null)
                {
                    _local_7.next = _local_14;
                } else
                {
                    this.edgeList = _local_14;
                };
                _local_7 = _local_14;
                _local_8 = _local_8.next;
            };
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_3.value = null;
                _local_3 = _local_3.next;
            };
            _local_4 = _local_2.faceList;
            while (_local_4 != null)
            {
                _local_4.processNext = null;
                _local_4 = _local_4.next;
            };
        }

        private function calculateEdges():String
        {
            var _local_1:Face;
            var _local_2:Wrapper;
            var _local_3:Edge;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            _local_1 = this.faceList;
            while (_local_1 != null)
            {
                _local_1.calculateBestSequenceAndNormal();
                _local_2 = _local_1.wrapper;
                while (_local_2 != null)
                {
                    _local_4 = _local_2.vertex;
                    _local_5 = ((_local_2.next != null) ? _local_2.next.vertex : _local_1.wrapper.vertex);
                    _local_3 = this.edgeList;
                    while (_local_3 != null)
                    {
                        if (((_local_3.a == _local_4) && (_local_3.b == _local_5)))
                        {
                            return ("The supplied geometry is not valid.");
                        };
                        if (((_local_3.a == _local_5) && (_local_3.b == _local_4))) break;
                        _local_3 = _local_3.next;
                    };
                    if (_local_3 != null)
                    {
                        _local_3.right = _local_1;
                    } else
                    {
                        _local_3 = new Edge();
                        _local_3.a = _local_4;
                        _local_3.b = _local_5;
                        _local_3.left = _local_1;
                        _local_3.next = this.edgeList;
                        this.edgeList = _local_3;
                    };
                    _local_2 = _local_2.next;
                    _local_4 = _local_5;
                };
                _local_1 = _local_1.next;
            };
            _local_3 = this.edgeList;
            while (_local_3 != null)
            {
                if (((_local_3.left == null) || (_local_3.right == null)))
                {
                    return ("The supplied geometry is non whole.");
                };
                _local_6 = (_local_3.b.x - _local_3.a.x);
                _local_7 = (_local_3.b.y - _local_3.a.y);
                _local_8 = (_local_3.b.z - _local_3.a.z);
                _local_9 = ((_local_3.right.normalZ * _local_3.left.normalY) - (_local_3.right.normalY * _local_3.left.normalZ));
                _local_10 = ((_local_3.right.normalX * _local_3.left.normalZ) - (_local_3.right.normalZ * _local_3.left.normalX));
                _local_11 = ((_local_3.right.normalY * _local_3.left.normalX) - (_local_3.right.normalX * _local_3.left.normalY));
                if ((((_local_6 * _local_9) + (_local_7 * _local_10)) + (_local_8 * _local_11)) < 0)
                {
                };
                _local_3 = _local_3.next;
            };
            return (null);
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:int;
            var _local_3:Sprite;
            var _local_6:Vertex;
            var _local_11:Vertex;
            var _local_12:Vertex;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_21:Vertex;
            var _local_22:Vertex;
            var _local_23:Number;
            if (((this.faceList == null) || (this.edgeList == null)))
            {
                return;
            };
            calculateInverseMatrix();
            var _local_4:Boolean = true;
            var _local_5:Face = this.faceList;
            while (_local_5 != null)
            {
                if ((((_local_5.normalX * imd) + (_local_5.normalY * imh)) + (_local_5.normalZ * iml)) > _local_5.offset)
                {
                    _local_5.distance = 1;
                    _local_4 = false;
                } else
                {
                    _local_5.distance = 0;
                };
                _local_5 = _local_5.next;
            };
            if (_local_4)
            {
                return;
            };
            var _local_7:int;
            var _local_8:Boolean = true;
            var _local_9:Number = _arg_1.viewSizeX;
            var _local_10:Number = _arg_1.viewSizeY;
            var _local_20:Edge = this.edgeList;
            for (;_local_20 != null;(_local_20 = _local_20.next))
            {
                if (_local_20.left.distance != _local_20.right.distance)
                {
                    if (_local_20.left.distance > 0)
                    {
                        _local_11 = _local_20.a;
                        _local_12 = _local_20.b;
                    } else
                    {
                        _local_11 = _local_20.b;
                        _local_12 = _local_20.a;
                    };
                    _local_13 = ((((ma * _local_11.x) + (mb * _local_11.y)) + (mc * _local_11.z)) + md);
                    _local_14 = ((((me * _local_11.x) + (mf * _local_11.y)) + (mg * _local_11.z)) + mh);
                    _local_15 = ((((mi * _local_11.x) + (mj * _local_11.y)) + (mk * _local_11.z)) + ml);
                    _local_16 = ((((ma * _local_12.x) + (mb * _local_12.y)) + (mc * _local_12.z)) + md);
                    _local_17 = ((((me * _local_12.x) + (mf * _local_12.y)) + (mg * _local_12.z)) + mh);
                    _local_18 = ((((mi * _local_12.x) + (mj * _local_12.y)) + (mk * _local_12.z)) + ml);
                    if (culling > 0)
                    {
                        if (((_local_15 <= -(_local_13)) && (_local_18 <= -(_local_16))))
                        {
                            if (((_local_8) && (((_local_17 * _local_13) - (_local_16 * _local_14)) > 0)))
                            {
                                _local_8 = false;
                            };
                            continue;
                        };
                        if (((_local_18 > -(_local_16)) && (_local_15 <= -(_local_13))))
                        {
                            _local_19 = ((_local_13 + _local_15) / (((_local_13 + _local_15) - _local_16) - _local_18));
                            _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                            _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                            _local_15 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                        } else
                        {
                            if (((_local_18 <= -(_local_16)) && (_local_15 > -(_local_13))))
                            {
                                _local_19 = ((_local_13 + _local_15) / (((_local_13 + _local_15) - _local_16) - _local_18));
                                _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                _local_18 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                            };
                        };
                        if (((_local_15 <= _local_13) && (_local_18 <= _local_16)))
                        {
                            if (((_local_8) && (((_local_17 * _local_13) - (_local_16 * _local_14)) > 0)))
                            {
                                _local_8 = false;
                            };
                            continue;
                        };
                        if (((_local_18 > _local_16) && (_local_15 <= _local_13)))
                        {
                            _local_19 = ((_local_15 - _local_13) / (((_local_15 - _local_13) + _local_16) - _local_18));
                            _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                            _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                            _local_15 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                        } else
                        {
                            if (((_local_18 <= _local_16) && (_local_15 > _local_13)))
                            {
                                _local_19 = ((_local_15 - _local_13) / (((_local_15 - _local_13) + _local_16) - _local_18));
                                _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                _local_18 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                            };
                        };
                        if (((_local_15 <= -(_local_14)) && (_local_18 <= -(_local_17))))
                        {
                            if (((_local_8) && (((_local_17 * _local_13) - (_local_16 * _local_14)) > 0)))
                            {
                                _local_8 = false;
                            };
                            continue;
                        };
                        if (((_local_18 > -(_local_17)) && (_local_15 <= -(_local_14))))
                        {
                            _local_19 = ((_local_14 + _local_15) / (((_local_14 + _local_15) - _local_17) - _local_18));
                            _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                            _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                            _local_15 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                        } else
                        {
                            if (((_local_18 <= -(_local_17)) && (_local_15 > -(_local_14))))
                            {
                                _local_19 = ((_local_14 + _local_15) / (((_local_14 + _local_15) - _local_17) - _local_18));
                                _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                _local_18 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                            };
                        };
                        if (((_local_15 <= _local_14) && (_local_18 <= _local_17)))
                        {
                            if (((_local_8) && (((_local_17 * _local_13) - (_local_16 * _local_14)) > 0)))
                            {
                                _local_8 = false;
                            };
                            continue;
                        };
                        if (((_local_18 > _local_17) && (_local_15 <= _local_14)))
                        {
                            _local_19 = ((_local_15 - _local_14) / (((_local_15 - _local_14) + _local_17) - _local_18));
                            _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                            _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                            _local_15 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                        } else
                        {
                            if (((_local_18 <= _local_17) && (_local_15 > _local_14)))
                            {
                                _local_19 = ((_local_15 - _local_14) / (((_local_15 - _local_14) + _local_17) - _local_18));
                                _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                _local_18 = (_local_15 + ((_local_18 - _local_15) * _local_19));
                            };
                        };
                        _local_8 = false;
                    };
                    _local_11 = _local_11.create();
                    _local_11.next = _local_6;
                    _local_7++;
                    _local_6 = _local_11;
                    _local_6.cameraX = ((_local_18 * _local_14) - (_local_17 * _local_15));
                    _local_6.cameraY = ((_local_16 * _local_15) - (_local_18 * _local_13));
                    _local_6.cameraZ = ((_local_17 * _local_13) - (_local_16 * _local_14));
                    _local_6.x = _local_13;
                    _local_6.y = _local_14;
                    _local_6.z = _local_15;
                    _local_6.u = _local_16;
                    _local_6.v = _local_17;
                    _local_6.offset = _local_18;
                };
            };
            if (_local_6 != null)
            {
                if (this.minSize > 0)
                {
                    _local_21 = Vertex.createList(_local_7);
                    _local_11 = _local_6;
                    _local_12 = _local_21;
                    while (_local_11 != null)
                    {
                        _local_12.x = ((_local_11.x * _local_9) / _local_11.z);
                        _local_12.y = ((_local_11.y * _local_10) / _local_11.z);
                        _local_12.u = ((_local_11.u * _local_9) / _local_11.offset);
                        _local_12.v = ((_local_11.v * _local_10) / _local_11.offset);
                        _local_12.cameraX = (_local_12.y - _local_12.v);
                        _local_12.cameraY = (_local_12.u - _local_12.x);
                        _local_12.offset = ((_local_12.cameraX * _local_12.x) + (_local_12.cameraY * _local_12.y));
                        _local_11 = _local_11.next;
                        _local_12 = _local_12.next;
                    };
                    if (culling > 0)
                    {
                        if ((culling & 0x04))
                        {
                            _local_13 = -(_arg_1.viewSizeX);
                            _local_14 = -(_arg_1.viewSizeY);
                            _local_16 = -(_arg_1.viewSizeX);
                            _local_17 = _arg_1.viewSizeY;
                            _local_11 = _local_21;
                            while (_local_11 != null)
                            {
                                _local_15 = (((_local_13 * _local_11.cameraX) + (_local_14 * _local_11.cameraY)) - _local_11.offset);
                                _local_18 = (((_local_16 * _local_11.cameraX) + (_local_17 * _local_11.cameraY)) - _local_11.offset);
                                if (((_local_15 < 0) || (_local_18 < 0)))
                                {
                                    if (((_local_15 >= 0) && (_local_18 < 0)))
                                    {
                                        _local_19 = (_local_15 / (_local_15 - _local_18));
                                        _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                        _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                    } else
                                    {
                                        if (((_local_15 < 0) && (_local_18 >= 0)))
                                        {
                                            _local_19 = (_local_15 / (_local_15 - _local_18));
                                            _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                            _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                        };
                                    };
                                } else
                                {
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                            if (_local_11 == null)
                            {
                                _local_12 = _local_6.create();
                                _local_12.next = _local_22;
                                _local_22 = _local_12;
                                _local_22.x = _local_13;
                                _local_22.y = _local_14;
                                _local_22.u = _local_16;
                                _local_22.v = _local_17;
                            };
                        };
                        if ((culling & 0x08))
                        {
                            _local_13 = _arg_1.viewSizeX;
                            _local_14 = _arg_1.viewSizeY;
                            _local_16 = _arg_1.viewSizeX;
                            _local_17 = -(_arg_1.viewSizeY);
                            _local_11 = _local_21;
                            while (_local_11 != null)
                            {
                                _local_15 = (((_local_13 * _local_11.cameraX) + (_local_14 * _local_11.cameraY)) - _local_11.offset);
                                _local_18 = (((_local_16 * _local_11.cameraX) + (_local_17 * _local_11.cameraY)) - _local_11.offset);
                                if (((_local_15 < 0) || (_local_18 < 0)))
                                {
                                    if (((_local_15 >= 0) && (_local_18 < 0)))
                                    {
                                        _local_19 = (_local_15 / (_local_15 - _local_18));
                                        _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                        _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                    } else
                                    {
                                        if (((_local_15 < 0) && (_local_18 >= 0)))
                                        {
                                            _local_19 = (_local_15 / (_local_15 - _local_18));
                                            _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                            _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                        };
                                    };
                                } else
                                {
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                            if (_local_11 == null)
                            {
                                _local_12 = _local_6.create();
                                _local_12.next = _local_22;
                                _local_22 = _local_12;
                                _local_22.x = _local_13;
                                _local_22.y = _local_14;
                                _local_22.u = _local_16;
                                _local_22.v = _local_17;
                            };
                        };
                        if ((culling & 0x10))
                        {
                            _local_13 = _arg_1.viewSizeX;
                            _local_14 = -(_arg_1.viewSizeY);
                            _local_16 = -(_arg_1.viewSizeX);
                            _local_17 = -(_arg_1.viewSizeY);
                            _local_11 = _local_21;
                            while (_local_11 != null)
                            {
                                _local_15 = (((_local_13 * _local_11.cameraX) + (_local_14 * _local_11.cameraY)) - _local_11.offset);
                                _local_18 = (((_local_16 * _local_11.cameraX) + (_local_17 * _local_11.cameraY)) - _local_11.offset);
                                if (((_local_15 < 0) || (_local_18 < 0)))
                                {
                                    if (((_local_15 >= 0) && (_local_18 < 0)))
                                    {
                                        _local_19 = (_local_15 / (_local_15 - _local_18));
                                        _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                        _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                    } else
                                    {
                                        if (((_local_15 < 0) && (_local_18 >= 0)))
                                        {
                                            _local_19 = (_local_15 / (_local_15 - _local_18));
                                            _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                            _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                        };
                                    };
                                } else
                                {
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                            if (_local_11 == null)
                            {
                                _local_12 = _local_6.create();
                                _local_12.next = _local_22;
                                _local_22 = _local_12;
                                _local_22.x = _local_13;
                                _local_22.y = _local_14;
                                _local_22.u = _local_16;
                                _local_22.v = _local_17;
                            };
                        };
                        if ((culling & 0x20))
                        {
                            _local_13 = -(_arg_1.viewSizeX);
                            _local_14 = _arg_1.viewSizeY;
                            _local_16 = _arg_1.viewSizeX;
                            _local_17 = _arg_1.viewSizeY;
                            _local_11 = _local_21;
                            while (_local_11 != null)
                            {
                                _local_15 = (((_local_13 * _local_11.cameraX) + (_local_14 * _local_11.cameraY)) - _local_11.offset);
                                _local_18 = (((_local_16 * _local_11.cameraX) + (_local_17 * _local_11.cameraY)) - _local_11.offset);
                                if (((_local_15 < 0) || (_local_18 < 0)))
                                {
                                    if (((_local_15 >= 0) && (_local_18 < 0)))
                                    {
                                        _local_19 = (_local_15 / (_local_15 - _local_18));
                                        _local_13 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                        _local_14 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                    } else
                                    {
                                        if (((_local_15 < 0) && (_local_18 >= 0)))
                                        {
                                            _local_19 = (_local_15 / (_local_15 - _local_18));
                                            _local_16 = (_local_13 + ((_local_16 - _local_13) * _local_19));
                                            _local_17 = (_local_14 + ((_local_17 - _local_14) * _local_19));
                                        };
                                    };
                                } else
                                {
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                            if (_local_11 == null)
                            {
                                _local_12 = _local_6.create();
                                _local_12.next = _local_22;
                                _local_22 = _local_12;
                                _local_22.x = _local_13;
                                _local_22.y = _local_14;
                                _local_22.u = _local_16;
                                _local_22.v = _local_17;
                            };
                        };
                    };
                    _local_23 = 0;
                    _local_15 = _local_21.x;
                    _local_18 = _local_21.y;
                    _local_11 = _local_21;
                    while (_local_11.next != null)
                    {
                        _local_11 = _local_11.next;
                    };
                    _local_11.next = _local_22;
                    _local_11 = _local_21;
                    while (_local_11 != null)
                    {
                        _local_23 = (_local_23 + (((_local_11.u - _local_15) * (_local_11.y - _local_18)) - ((_local_11.v - _local_18) * (_local_11.x - _local_15))));
                        if (_local_11.next == null) break;
                        _local_11 = _local_11.next;
                    };
                    _local_11.next = Vertex.collector;
                    Vertex.collector = _local_21;
                    if ((_local_23 / ((_arg_1.viewSizeX * _arg_1.viewSizeY) * 8)) < this.minSize)
                    {
                        _local_11 = _local_6;
                        while (_local_11.next != null)
                        {
                            _local_11 = _local_11.next;
                        };
                        _local_11.next = Vertex.collector;
                        Vertex.collector = _local_6;
                        return;
                    };
                };
                if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                {
                    if ((_local_2 & Debug.EDGES))
                    {
                        _local_11 = _local_6;
                        while (_local_11 != null)
                        {
                            _local_13 = ((_local_11.x * _local_9) / _local_11.z);
                            _local_14 = ((_local_11.y * _local_10) / _local_11.z);
                            _local_16 = ((_local_11.u * _local_9) / _local_11.offset);
                            _local_17 = ((_local_11.v * _local_10) / _local_11.offset);
                            _local_3 = _arg_1.view.canvas;
                            _local_3.graphics.moveTo(_local_13, _local_14);
                            _local_3.graphics.lineStyle(3, 0xFF);
                            _local_3.graphics.lineTo((_local_13 + ((_local_16 - _local_13) * 0.8)), (_local_14 + ((_local_17 - _local_14) * 0.8)));
                            _local_3.graphics.lineStyle(3, 0xFF0000);
                            _local_3.graphics.lineTo(_local_16, _local_17);
                            _local_11 = _local_11.next;
                        };
                    };
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
                _arg_1.occluders[_arg_1.numOccluders] = _local_6;
                _arg_1.numOccluders++;
            } else
            {
                if (_local_8)
                {
                    if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                    {
                        if ((_local_2 & Debug.EDGES))
                        {
                            _local_19 = 1.5;
                            _local_3 = _arg_1.view.canvas;
                            _local_3.graphics.moveTo((-(_local_9) + _local_19), (-(_local_10) + _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF);
                            _local_3.graphics.lineTo((-(_local_9) + _local_19), (_local_10 * 0.6));
                            _local_3.graphics.lineStyle(3, 0xFF0000);
                            _local_3.graphics.lineTo((-(_local_9) + _local_19), (_local_10 - _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF);
                            _local_3.graphics.lineTo((_local_9 * 0.6), (_local_10 - _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF0000);
                            _local_3.graphics.lineTo((_local_9 - _local_19), (_local_10 - _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF);
                            _local_3.graphics.lineTo((_local_9 - _local_19), (-(_local_10) * 0.6));
                            _local_3.graphics.lineStyle(3, 0xFF0000);
                            _local_3.graphics.lineTo((_local_9 - _local_19), (-(_local_10) + _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF);
                            _local_3.graphics.lineTo((-(_local_9) * 0.6), (-(_local_10) + _local_19));
                            _local_3.graphics.lineStyle(3, 0xFF0000);
                            _local_3.graphics.lineTo((-(_local_9) + _local_19), (-(_local_10) + _local_19));
                        };
                        if ((_local_2 & Debug.BOUNDS))
                        {
                            Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                        };
                    };
                    _arg_1.clearOccluders();
                    _arg_1.occludedAll = true;
                };
            };
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


    }
}//package alternativa.engine3d.objects

import alternativa.engine3d.core.Vertex;
import alternativa.engine3d.core.Face;

class Edge 
{

    public var next:Edge;
    public var a:Vertex;
    public var b:Vertex;
    public var left:Face;
    public var right:Face;


}
