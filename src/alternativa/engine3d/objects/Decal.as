package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.VG;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Decal extends Mesh 
    {

        public var attenuation:Number = 1000000;

        public function Decal()
        {
            shadowMapAlphaThreshold = 100;
        }

        public function createGeometry(_arg_1:Mesh, _arg_2:Boolean=false):void
        {
            if ((!(_arg_2)))
            {
                _arg_1 = (_arg_1.clone() as Mesh);
            };
            faceList = _arg_1.faceList;
            vertexList = _arg_1.vertexList;
            _arg_1.faceList = null;
            _arg_1.vertexList = null;
            var _local_3:Vertex = vertexList;
            while (_local_3 != null)
            {
                _local_3.transformId = 0;
                _local_3.id = null;
                _local_3 = _local_3.next;
            };
            var _local_4:Face = faceList;
            while (_local_4 != null)
            {
                _local_4.id = null;
                _local_4 = _local_4.next;
            };
            calculateBounds();
        }

        override public function clone():Object3D
        {
            var _local_1:Decal = new Decal();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Decal = (_arg_1 as Decal);
            this.attenuation = _local_2.attenuation;
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_3:Face;
            var _local_4:Vertex;
            if (faceList == null)
            {
                return;
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
            useDepth = true;
            if (faceList.material != null)
            {
                _arg_1.addDecal(this);
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
            };
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_2 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
            if ((_local_2 & Debug.EDGES))
            {
                if (transformId > 0x1DCD6500)
                {
                    transformId = 0;
                    _local_4 = vertexList;
                    while (_local_4 != null)
                    {
                        _local_4.transformId = 0;
                        _local_4 = _local_4.next;
                    };
                };
                transformId++;
                calculateInverseMatrix();
                _local_3 = prepareFaces(_arg_1, faceList);
                if (_local_3 == null)
                {
                    return;
                };
                Debug.drawEdges(_arg_1, _local_3, 0xFFFFFF);
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            this.draw(_arg_1);
            return (null);
        }

        override alternativa3d function prepareResources():void
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
                vertexBuffer = new VertexBufferResource(_local_1, 8);
                _local_5 = new Vector.<uint>();
                _local_6 = 0;
                numTriangles = 0;
                _local_7 = faceList;
                while (_local_7 != null)
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
                        numTriangles++;
                        _local_8 = _local_8.next;
                    };
                    _local_7 = _local_7.next;
                };
                indexBuffer = new IndexBufferResource(_local_5);
            };
        }


    }
}//package alternativa.engine3d.objects