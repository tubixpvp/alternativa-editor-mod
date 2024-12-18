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

    public class Plane extends Mesh 
    {

        public function Plane(_arg_1:Number=100, _arg_2:Number=100, _arg_3:uint=1, _arg_4:uint=1, _arg_5:Boolean=true, _arg_6:Boolean=false, _arg_7:Boolean=false, _arg_8:Material=null, _arg_9:Material=null)
        {
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            super();
            if (_arg_3 < 1)
            {
                throw (new ArgumentError((_arg_3 + " width segments not enough.")));
            };
            if (_arg_4 < 1)
            {
                throw (new ArgumentError((_arg_4 + " length segments not enough.")));
            };
            var _local_13:int = (_arg_3 + 1);
            var _local_14:int = (_arg_4 + 1);
            var _local_15:Number = (_arg_1 * 0.5);
            var _local_16:Number = (_arg_2 * 0.5);
            var _local_17:Number = (1 / _arg_3);
            var _local_18:Number = (1 / _arg_4);
            var _local_19:Number = (_arg_1 / _arg_3);
            var _local_20:Number = (_arg_2 / _arg_4);
            var _local_21:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_22:int;
            _local_10 = 0;
            while (_local_10 < _local_13)
            {
                _local_11 = 0;
                while (_local_11 < _local_14)
                {
                    var _local_23:* = _local_22++;
                    _local_21[_local_23] = this.createVertex(((_local_10 * _local_19) - _local_15), ((_local_11 * _local_20) - _local_16), 0, (_local_10 * _local_17), ((_arg_4 - _local_11) * _local_18));
                    _local_11++;
                };
                _local_10++;
            };
            _local_10 = 0;
            while (_local_10 < _local_13)
            {
                _local_11 = 0;
                while (_local_11 < _local_14)
                {
                    if (((_local_10 < _arg_3) && (_local_11 < _arg_4)))
                    {
                        this.createFace(_local_21[((_local_10 * _local_14) + _local_11)], _local_21[(((_local_10 + 1) * _local_14) + _local_11)], _local_21[((((_local_10 + 1) * _local_14) + _local_11) + 1)], _local_21[(((_local_10 * _local_14) + _local_11) + 1)], 0, 0, 1, 0, _arg_6, _arg_7, _arg_9);
                    };
                    _local_11++;
                };
                _local_10++;
            };
            if (_arg_5)
            {
                _local_22 = 0;
                _local_10 = 0;
                while (_local_10 < _local_13)
                {
                    _local_11 = 0;
                    while (_local_11 < _local_14)
                    {
                        _local_23 = _local_22++;
                        _local_21[_local_23] = this.createVertex(((_local_10 * _local_19) - _local_15), ((_local_11 * _local_20) - _local_16), 0, ((_arg_3 - _local_10) * _local_17), ((_arg_4 - _local_11) * _local_18));
                        _local_11++;
                    };
                    _local_10++;
                };
                _local_10 = 0;
                while (_local_10 < _local_13)
                {
                    _local_11 = 0;
                    while (_local_11 < _local_14)
                    {
                        if (((_local_10 < _arg_3) && (_local_11 < _arg_4)))
                        {
                            this.createFace(_local_21[((((_local_10 + 1) * _local_14) + _local_11) + 1)], _local_21[(((_local_10 + 1) * _local_14) + _local_11)], _local_21[((_local_10 * _local_14) + _local_11)], _local_21[(((_local_10 * _local_14) + _local_11) + 1)], 0, 0, -1, 0, _arg_6, _arg_7, _arg_8);
                        };
                        _local_11++;
                    };
                    _local_10++;
                };
            };
            boundMinX = -(_local_15);
            boundMinY = -(_local_16);
            boundMinZ = 0;
            boundMaxX = _local_15;
            boundMaxY = _local_16;
            boundMaxZ = 0;
        }

        private function createVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Vertex
        {
            var _local_6:Vertex = new Vertex();
            _local_6.x = _arg_1;
            _local_6.y = _arg_2;
            _local_6.z = _arg_3;
            _local_6.u = _arg_4;
            _local_6.v = _arg_5;
            _local_6.next = vertexList;
            vertexList = _local_6;
            return (_local_6);
        }

        private function createFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Vertex, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Boolean, _arg_10:Boolean, _arg_11:Material):void
        {
            var _local_12:Vertex;
            var _local_13:Face;
            if (_arg_9)
            {
                _arg_5 = -(_arg_5);
                _arg_6 = -(_arg_6);
                _arg_7 = -(_arg_7);
                _arg_8 = -(_arg_8);
                _local_12 = _arg_1;
                _arg_1 = _arg_4;
                _arg_4 = _local_12;
                _local_12 = _arg_2;
                _arg_2 = _arg_3;
                _arg_3 = _local_12;
            };
            if (_arg_10)
            {
                _local_13 = new Face();
                _local_13.material = _arg_11;
                _local_13.wrapper = new Wrapper();
                _local_13.wrapper.vertex = _arg_1;
                _local_13.wrapper.next = new Wrapper();
                _local_13.wrapper.next.vertex = _arg_2;
                _local_13.wrapper.next.next = new Wrapper();
                _local_13.wrapper.next.next.vertex = _arg_3;
                _local_13.normalX = _arg_5;
                _local_13.normalY = _arg_6;
                _local_13.normalZ = _arg_7;
                _local_13.offset = _arg_8;
                _local_13.next = faceList;
                faceList = _local_13;
                _local_13 = new Face();
                _local_13.material = _arg_11;
                _local_13.wrapper = new Wrapper();
                _local_13.wrapper.vertex = _arg_1;
                _local_13.wrapper.next = new Wrapper();
                _local_13.wrapper.next.vertex = _arg_3;
                _local_13.wrapper.next.next = new Wrapper();
                _local_13.wrapper.next.next.vertex = _arg_4;
                _local_13.normalX = _arg_5;
                _local_13.normalY = _arg_6;
                _local_13.normalZ = _arg_7;
                _local_13.offset = _arg_8;
                _local_13.next = faceList;
                faceList = _local_13;
            } else
            {
                _local_13 = new Face();
                _local_13.material = _arg_11;
                _local_13.wrapper = new Wrapper();
                _local_13.wrapper.vertex = _arg_1;
                _local_13.wrapper.next = new Wrapper();
                _local_13.wrapper.next.vertex = _arg_2;
                _local_13.wrapper.next.next = new Wrapper();
                _local_13.wrapper.next.next.vertex = _arg_3;
                _local_13.wrapper.next.next.next = new Wrapper();
                _local_13.wrapper.next.next.next.vertex = _arg_4;
                _local_13.normalX = _arg_5;
                _local_13.normalY = _arg_6;
                _local_13.normalZ = _arg_7;
                _local_13.offset = _arg_8;
                _local_13.next = faceList;
                faceList = _local_13;
            };
        }

        override public function clone():Object3D
        {
            var _local_1:Plane = new Plane();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }


    }
}//package alternativa.engine3d.primitives