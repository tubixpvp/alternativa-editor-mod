package alternativa.engine3d.primitives
{
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Sphere extends Mesh 
    {

        public function Sphere(_arg_1:Number=100, _arg_2:uint=8, _arg_3:uint=8, _arg_4:Boolean=false, _arg_5:Material=null)
        {
            var _local_9:uint;
            var _local_10:uint;
            var _local_12:Vertex;
            var _local_13:Vertex;
            var _local_14:Vertex;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            super();
            if (_arg_2 < 3)
            {
                throw (new ArgumentError((_arg_2 + " radial segments not enough.")));
            };
            if (_arg_3 < 2)
            {
                throw (new ArgumentError((_arg_3 + " height segments not enough.")));
            };
            _arg_1 = ((_arg_1 < 0) ? 0 : _arg_1);
            var _local_6:Object = new Object();
            var _local_7:Number = ((Math.PI * 2) / _arg_2);
            var _local_8:Number = ((Math.PI * 2) / (_arg_3 << 1));
            _local_10 = 0;
            while (_local_10 <= _arg_3)
            {
                _local_15 = (_local_8 * _local_10);
                _local_16 = (Math.sin(_local_15) * _arg_1);
                _local_17 = (Math.cos(_local_15) * _arg_1);
                _local_9 = 0;
                while (_local_9 <= _arg_2)
                {
                    _local_18 = (_local_7 * _local_9);
                    this.createVertex((-(Math.sin(_local_18)) * _local_16), (Math.cos(_local_18) * _local_16), _local_17, (_local_9 / _arg_2), (_local_10 / _arg_3), ((_local_9 + "_") + _local_10), _local_6);
                    _local_9++;
                };
                _local_10++;
            };
            var _local_11:uint;
            _local_9 = 1;
            while (_local_9 <= _arg_2)
            {
                _local_10 = 0;
                while (_local_10 < _arg_3)
                {
                    if (_local_10 < (_arg_3 - 1))
                    {
                        _local_12 = _local_6[((_local_11 + "_") + _local_10)];
                        _local_13 = _local_6[((_local_11 + "_") + (_local_10 + 1))];
                        _local_14 = _local_6[((_local_9 + "_") + (_local_10 + 1))];
                        if (_arg_4)
                        {
                            this.createFace(_local_12, _local_14, _local_13, _arg_5);
                        } else
                        {
                            this.createFace(_local_12, _local_13, _local_14, _arg_5);
                        };
                    };
                    if (_local_10 > 0)
                    {
                        _local_12 = _local_6[((_local_9 + "_") + (_local_10 + 1))];
                        _local_13 = _local_6[((_local_9 + "_") + _local_10)];
                        _local_14 = _local_6[((_local_11 + "_") + _local_10)];
                        if (_arg_4)
                        {
                            this.createFace(_local_12, _local_14, _local_13, _arg_5);
                        } else
                        {
                            this.createFace(_local_12, _local_13, _local_14, _arg_5);
                        };
                    };
                    _local_10++;
                };
                _local_11 = _local_9;
                _local_9++;
            };
            calculateFacesNormals(true);
            boundMinX = -(_arg_1);
            boundMinY = -(_arg_1);
            boundMinZ = -(_arg_1);
            boundMaxX = _arg_1;
            boundMaxY = _arg_1;
            boundMaxZ = _arg_1;
        }

        private function createVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:String, _arg_7:Object):Vertex
        {
            var _local_8:Vertex = new Vertex();
            _local_8.x = _arg_1;
            _local_8.y = _arg_2;
            _local_8.z = _arg_3;
            _local_8.u = _arg_4;
            _local_8.v = _arg_5;
            _local_8.next = vertexList;
            vertexList = _local_8;
            _arg_7[_arg_6] = _local_8;
            return (_local_8);
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

        override public function clone():Object3D
        {
            var _local_1:Sphere = new Sphere();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }


    }
}//package alternativa.engine3d.primitives