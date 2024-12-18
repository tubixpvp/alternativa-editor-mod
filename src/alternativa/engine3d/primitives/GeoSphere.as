package alternativa.engine3d.primitives
{
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.engine3d.core.Object3D;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class GeoSphere extends Mesh 
    {

        public function GeoSphere(_arg_1:Number=100, _arg_2:uint=2, _arg_3:Boolean=false, _arg_4:Material=null)
        {
            var _local_9:uint;
            var _local_10:uint;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_16:uint;
            var _local_17:uint;
            var _local_18:uint;
            var _local_19:uint;
            var _local_20:uint;
            var _local_21:Vertex;
            var _local_22:Vertex;
            var _local_23:Vertex;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            super();
            if (_arg_2 < 1)
            {
                throw (new ArgumentError((_arg_2 + " segments not enough.")));
            };
            _arg_1 = ((_arg_1 < 0) ? 0 : _arg_1);
            var _local_5:uint = 20;
            var _local_6:Number = Math.PI;
            var _local_7:Number = (Math.PI * 2);
            var _local_8:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_14:Number = (0.4472136 * _arg_1);
            var _local_15:Number = (2 * _local_14);
            _local_8.push(this.createVertex(0, 0, _arg_1));
            _local_9 = 0;
            while (_local_9 < 5)
            {
                _local_11 = ((_local_7 * _local_9) / 5);
                _local_12 = Math.sin(_local_11);
                _local_13 = Math.cos(_local_11);
                _local_8.push(this.createVertex((_local_15 * _local_13), (_local_15 * _local_12), _local_14));
                _local_9++;
            };
            _local_9 = 0;
            while (_local_9 < 5)
            {
                _local_11 = ((_local_6 * ((_local_9 << 1) + 1)) / 5);
                _local_12 = Math.sin(_local_11);
                _local_13 = Math.cos(_local_11);
                _local_8.push(this.createVertex((_local_15 * _local_13), (_local_15 * _local_12), -(_local_14)));
                _local_9++;
            };
            _local_8.push(this.createVertex(0, 0, -(_arg_1)));
            _local_9 = 1;
            while (_local_9 < 6)
            {
                this.interpolate(0, _local_9, _arg_2, _local_8);
                _local_9++;
            };
            _local_9 = 1;
            while (_local_9 < 6)
            {
                this.interpolate(_local_9, ((_local_9 % 5) + 1), _arg_2, _local_8);
                _local_9++;
            };
            _local_9 = 1;
            while (_local_9 < 6)
            {
                this.interpolate(_local_9, (_local_9 + 5), _arg_2, _local_8);
                _local_9++;
            };
            _local_9 = 1;
            while (_local_9 < 6)
            {
                this.interpolate(_local_9, (((_local_9 + 3) % 5) + 6), _arg_2, _local_8);
                _local_9++;
            };
            _local_9 = 1;
            while (_local_9 < 6)
            {
                this.interpolate((_local_9 + 5), ((_local_9 % 5) + 6), _arg_2, _local_8);
                _local_9++;
            };
            _local_9 = 6;
            while (_local_9 < 11)
            {
                this.interpolate(11, _local_9, _arg_2, _local_8);
                _local_9++;
            };
            _local_10 = 0;
            while (_local_10 < 5)
            {
                _local_9 = 1;
                while (_local_9 <= (_arg_2 - 2))
                {
                    this.interpolate(((12 + (_local_10 * (_arg_2 - 1))) + _local_9), ((12 + (((_local_10 + 1) % 5) * (_arg_2 - 1))) + _local_9), (_local_9 + 1), _local_8);
                    _local_9++;
                };
                _local_10++;
            };
            _local_10 = 0;
            while (_local_10 < 5)
            {
                _local_9 = 1;
                while (_local_9 <= (_arg_2 - 2))
                {
                    this.interpolate(((12 + ((_local_10 + 15) * (_arg_2 - 1))) + _local_9), ((12 + ((_local_10 + 10) * (_arg_2 - 1))) + _local_9), (_local_9 + 1), _local_8);
                    _local_9++;
                };
                _local_10++;
            };
            _local_10 = 0;
            while (_local_10 < 5)
            {
                _local_9 = 1;
                while (_local_9 <= (_arg_2 - 2))
                {
                    this.interpolate(((((12 + ((((_local_10 + 1) % 5) + 15) * (_arg_2 - 1))) + _arg_2) - 2) - _local_9), ((((12 + ((_local_10 + 10) * (_arg_2 - 1))) + _arg_2) - 2) - _local_9), (_local_9 + 1), _local_8);
                    _local_9++;
                };
                _local_10++;
            };
            _local_10 = 0;
            while (_local_10 < 5)
            {
                _local_9 = 1;
                while (_local_9 <= (_arg_2 - 2))
                {
                    this.interpolate(((12 + ((((_local_10 + 1) % 5) + 25) * (_arg_2 - 1))) + _local_9), ((12 + ((_local_10 + 25) * (_arg_2 - 1))) + _local_9), (_local_9 + 1), _local_8);
                    _local_9++;
                };
                _local_10++;
            };
            _local_10 = 0;
            while (_local_10 < _local_5)
            {
                _local_16 = 0;
                while (_local_16 < _arg_2)
                {
                    _local_17 = 0;
                    while (_local_17 <= _local_16)
                    {
                        _local_18 = this.findVertices(_arg_2, _local_10, _local_16, _local_17);
                        _local_19 = this.findVertices(_arg_2, _local_10, (_local_16 + 1), _local_17);
                        _local_20 = this.findVertices(_arg_2, _local_10, (_local_16 + 1), (_local_17 + 1));
                        _local_21 = _local_8[_local_18];
                        _local_22 = _local_8[_local_19];
                        _local_23 = _local_8[_local_20];
                        if ((((_local_21.y >= 0) && (_local_21.x < 0)) && ((_local_22.y < 0) || (_local_23.y < 0))))
                        {
                            _local_24 = ((Math.atan2(_local_21.y, _local_21.x) / _local_7) - 0.5);
                        } else
                        {
                            _local_24 = ((Math.atan2(_local_21.y, _local_21.x) / _local_7) + 0.5);
                        };
                        _local_25 = ((-(Math.asin((_local_21.z / _arg_1))) / _local_6) + 0.5);
                        if ((((_local_22.y >= 0) && (_local_22.x < 0)) && ((_local_21.y < 0) || (_local_23.y < 0))))
                        {
                            _local_26 = ((Math.atan2(_local_22.y, _local_22.x) / _local_7) - 0.5);
                        } else
                        {
                            _local_26 = ((Math.atan2(_local_22.y, _local_22.x) / _local_7) + 0.5);
                        };
                        _local_27 = ((-(Math.asin((_local_22.z / _arg_1))) / _local_6) + 0.5);
                        if ((((_local_23.y >= 0) && (_local_23.x < 0)) && ((_local_21.y < 0) || (_local_22.y < 0))))
                        {
                            _local_28 = ((Math.atan2(_local_23.y, _local_23.x) / _local_7) - 0.5);
                        } else
                        {
                            _local_28 = ((Math.atan2(_local_23.y, _local_23.x) / _local_7) + 0.5);
                        };
                        _local_29 = ((-(Math.asin((_local_23.z / _arg_1))) / _local_6) + 0.5);
                        if (((_local_18 == 0) || (_local_18 == 11)))
                        {
                            _local_24 = (_local_26 + ((_local_28 - _local_26) * 0.5));
                        };
                        if (((_local_19 == 0) || (_local_19 == 11)))
                        {
                            _local_26 = (_local_24 + ((_local_28 - _local_24) * 0.5));
                        };
                        if (((_local_20 == 0) || (_local_20 == 11)))
                        {
                            _local_28 = (_local_24 + ((_local_26 - _local_24) * 0.5));
                        };
                        if (((_local_21.offset > 0) && (!(_local_21.u == _local_24))))
                        {
                            _local_21 = this.createVertex(_local_21.x, _local_21.y, _local_21.z);
                        };
                        _local_21.u = _local_24;
                        _local_21.v = _local_25;
                        _local_21.offset = 1;
                        if (((_local_22.offset > 0) && (!(_local_22.u == _local_26))))
                        {
                            _local_22 = this.createVertex(_local_22.x, _local_22.y, _local_22.z);
                        };
                        _local_22.u = _local_26;
                        _local_22.v = _local_27;
                        _local_22.offset = 1;
                        if (((_local_23.offset > 0) && (!(_local_23.u == _local_28))))
                        {
                            _local_23 = this.createVertex(_local_23.x, _local_23.y, _local_23.z);
                        };
                        _local_23.u = _local_28;
                        _local_23.v = _local_29;
                        _local_23.offset = 1;
                        if (_arg_3)
                        {
                            this.createFace(_local_21, _local_23, _local_22, _arg_4);
                        } else
                        {
                            this.createFace(_local_21, _local_22, _local_23, _arg_4);
                        };
                        if (_local_17 < _local_16)
                        {
                            _local_19 = this.findVertices(_arg_2, _local_10, _local_16, (_local_17 + 1));
                            _local_22 = _local_8[_local_19];
                            if ((((_local_21.y >= 0) && (_local_21.x < 0)) && ((_local_22.y < 0) || (_local_23.y < 0))))
                            {
                                _local_24 = ((Math.atan2(_local_21.y, _local_21.x) / _local_7) - 0.5);
                            } else
                            {
                                _local_24 = ((Math.atan2(_local_21.y, _local_21.x) / _local_7) + 0.5);
                            };
                            _local_25 = ((-(Math.asin((_local_21.z / _arg_1))) / _local_6) + 0.5);
                            if ((((_local_22.y >= 0) && (_local_22.x < 0)) && ((_local_21.y < 0) || (_local_23.y < 0))))
                            {
                                _local_26 = ((Math.atan2(_local_22.y, _local_22.x) / _local_7) - 0.5);
                            } else
                            {
                                _local_26 = ((Math.atan2(_local_22.y, _local_22.x) / _local_7) + 0.5);
                            };
                            _local_27 = ((-(Math.asin((_local_22.z / _arg_1))) / _local_6) + 0.5);
                            if ((((_local_23.y >= 0) && (_local_23.x < 0)) && ((_local_21.y < 0) || (_local_22.y < 0))))
                            {
                                _local_28 = ((Math.atan2(_local_23.y, _local_23.x) / _local_7) - 0.5);
                            } else
                            {
                                _local_28 = ((Math.atan2(_local_23.y, _local_23.x) / _local_7) + 0.5);
                            };
                            _local_29 = ((-(Math.asin((_local_23.z / _arg_1))) / _local_6) + 0.5);
                            if (((_local_18 == 0) || (_local_18 == 11)))
                            {
                                _local_24 = (_local_26 + ((_local_28 - _local_26) * 0.5));
                            };
                            if (((_local_19 == 0) || (_local_19 == 11)))
                            {
                                _local_26 = (_local_24 + ((_local_28 - _local_24) * 0.5));
                            };
                            if (((_local_20 == 0) || (_local_20 == 11)))
                            {
                                _local_28 = (_local_24 + ((_local_26 - _local_24) * 0.5));
                            };
                            if (((_local_21.offset > 0) && (!(_local_21.u == _local_24))))
                            {
                                _local_21 = this.createVertex(_local_21.x, _local_21.y, _local_21.z);
                            };
                            _local_21.u = _local_24;
                            _local_21.v = _local_25;
                            _local_21.offset = 1;
                            if (((_local_22.offset > 0) && (!(_local_22.u == _local_26))))
                            {
                                _local_22 = this.createVertex(_local_22.x, _local_22.y, _local_22.z);
                            };
                            _local_22.u = _local_26;
                            _local_22.v = _local_27;
                            _local_22.offset = 1;
                            if (((_local_23.offset > 0) && (!(_local_23.u == _local_28))))
                            {
                                _local_23 = this.createVertex(_local_23.x, _local_23.y, _local_23.z);
                            };
                            _local_23.u = _local_28;
                            _local_23.v = _local_29;
                            _local_23.offset = 1;
                            if (_arg_3)
                            {
                                this.createFace(_local_21, _local_22, _local_23, _arg_4);
                            } else
                            {
                                this.createFace(_local_21, _local_23, _local_22, _arg_4);
                            };
                        };
                        _local_17++;
                    };
                    _local_16++;
                };
                _local_10++;
            };
            calculateFacesNormals(true);
            boundMinX = -(_arg_1);
            boundMinY = -(_arg_1);
            boundMinZ = -(_arg_1);
            boundMaxX = _arg_1;
            boundMaxY = _arg_1;
            boundMaxZ = _arg_1;
        }

        private function createVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number):Vertex
        {
            var _local_4:Vertex = new Vertex();
            _local_4.x = _arg_1;
            _local_4.y = _arg_2;
            _local_4.z = _arg_3;
            _local_4.offset = -1;
            _local_4.next = vertexList;
            vertexList = _local_4;
            return (_local_4);
        }

        private function createFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Material):void
        {
            var _local_5:Face = new Face();
            _local_5.material = _arg_4;
            _local_5.wrapper = new Wrapper();
            _local_5.wrapper.vertex = _arg_1;
            _local_5.wrapper.next = new Wrapper();
            _local_5.wrapper.next.vertex = _arg_2;
            _local_5.wrapper.next.next = new Wrapper();
            _local_5.wrapper.next.next.vertex = _arg_3;
            _local_5.next = faceList;
            faceList = _local_5;
        }

        private function interpolate(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:Vector.<Vertex>):void
        {
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            if (_arg_3 < 2)
            {
                return;
            };
            var _local_5:Vertex = Vertex(_arg_4[_arg_1]);
            var _local_6:Vertex = Vertex(_arg_4[_arg_2]);
            var _local_7:Number = ((((_local_5.x * _local_6.x) + (_local_5.y * _local_6.y)) + (_local_5.z * _local_6.z)) / (((_local_5.x * _local_5.x) + (_local_5.y * _local_5.y)) + (_local_5.z * _local_5.z)));
            _local_7 = ((_local_7 < -1) ? -1 : ((_local_7 > 1) ? 1 : _local_7));
            var _local_8:Number = Math.acos(_local_7);
            var _local_9:Number = Math.sin(_local_8);
            var _local_10:uint = 1;
            while (_local_10 < _arg_3)
            {
                _local_11 = ((_local_8 * _local_10) / _arg_3);
                _local_12 = ((_local_8 * (_arg_3 - _local_10)) / _arg_3);
                _local_13 = Math.sin(_local_11);
                _local_14 = Math.sin(_local_12);
                _arg_4.push(this.createVertex((((_local_5.x * _local_14) + (_local_6.x * _local_13)) / _local_9), (((_local_5.y * _local_14) + (_local_6.y * _local_13)) / _local_9), (((_local_5.z * _local_14) + (_local_6.z * _local_13)) / _local_9)));
                _local_10++;
            };
        }

        private function findVertices(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:uint):uint
        {
            if (_arg_3 == 0)
            {
                if (_arg_2 < 5)
                {
                    return (0);
                };
                if (_arg_2 > 14)
                {
                    return (11);
                };
                return (_arg_2 - 4);
            };
            if (((_arg_3 == _arg_1) && (_arg_4 == 0)))
            {
                if (_arg_2 < 5)
                {
                    return (_arg_2 + 1);
                };
                if (_arg_2 < 10)
                {
                    return (((_arg_2 + 4) % 5) + 6);
                };
                if (_arg_2 < 15)
                {
                    return (((_arg_2 + 1) % 5) + 1);
                };
                return (((_arg_2 + 1) % 5) + 6);
            };
            if (((_arg_3 == _arg_1) && (_arg_4 == _arg_1)))
            {
                if (_arg_2 < 5)
                {
                    return (((_arg_2 + 1) % 5) + 1);
                };
                if (_arg_2 < 10)
                {
                    return (_arg_2 + 1);
                };
                if (_arg_2 < 15)
                {
                    return (_arg_2 - 9);
                };
                return (_arg_2 - 9);
            };
            if (_arg_3 == _arg_1)
            {
                if (_arg_2 < 5)
                {
                    return (((12 + ((5 + _arg_2) * (_arg_1 - 1))) + _arg_4) - 1);
                };
                if (_arg_2 < 10)
                {
                    return (((12 + ((20 + ((_arg_2 + 4) % 5)) * (_arg_1 - 1))) + _arg_4) - 1);
                };
                if (_arg_2 < 15)
                {
                    return ((((12 + ((_arg_2 - 5) * (_arg_1 - 1))) + _arg_1) - 1) - _arg_4);
                };
                return ((((12 + ((5 + _arg_2) * (_arg_1 - 1))) + _arg_1) - 1) - _arg_4);
            };
            if (_arg_4 == 0)
            {
                if (_arg_2 < 5)
                {
                    return (((12 + (_arg_2 * (_arg_1 - 1))) + _arg_3) - 1);
                };
                if (_arg_2 < 10)
                {
                    return (((12 + (((_arg_2 % 5) + 15) * (_arg_1 - 1))) + _arg_3) - 1);
                };
                if (_arg_2 < 15)
                {
                    return ((((12 + ((((_arg_2 + 1) % 5) + 15) * (_arg_1 - 1))) + _arg_1) - 1) - _arg_3);
                };
                return (((12 + ((((_arg_2 + 1) % 5) + 25) * (_arg_1 - 1))) + _arg_3) - 1);
            };
            if (_arg_4 == _arg_3)
            {
                if (_arg_2 < 5)
                {
                    return (((12 + (((_arg_2 + 1) % 5) * (_arg_1 - 1))) + _arg_3) - 1);
                };
                if (_arg_2 < 10)
                {
                    return (((12 + (((_arg_2 % 5) + 10) * (_arg_1 - 1))) + _arg_3) - 1);
                };
                if (_arg_2 < 15)
                {
                    return ((((12 + (((_arg_2 % 5) + 10) * (_arg_1 - 1))) + _arg_1) - _arg_3) - 1);
                };
                return (((12 + (((_arg_2 % 5) + 25) * (_arg_1 - 1))) + _arg_3) - 1);
            };
            return (((((12 + (30 * (_arg_1 - 1))) + (((_arg_2 * (_arg_1 - 1)) * (_arg_1 - 2)) / 2)) + (((_arg_3 - 1) * (_arg_3 - 2)) / 2)) + _arg_4) - 1);
        }

        override public function clone():Object3D
        {
            var _local_1:GeoSphere = new GeoSphere();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }


    }
}//package alternativa.engine3d.primitives