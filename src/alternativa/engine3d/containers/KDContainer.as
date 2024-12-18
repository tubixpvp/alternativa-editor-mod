package alternativa.engine3d.containers
{
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Vertex;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.Object3D;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.objects.BSP;
    import alternativa.engine3d.objects.Occluder;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.objects.Decal;
    import flash.geom.Matrix3D;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.core.ShadowAtlas;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.gfx.core.Device;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class KDContainer extends ConflictContainer 
    {

        private static const treeSphere:Vector3D = new Vector3D();
        private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
        private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
        private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();

        public var debugAlphaFade:Number = 0.8;
        public var ignoreChildrenInCollider:Boolean = false;
        alternativa3d var root:KDNode;
        private var nearPlaneX:Number;
        private var nearPlaneY:Number;
        private var nearPlaneZ:Number;
        private var nearPlaneOffset:Number;
        private var farPlaneX:Number;
        private var farPlaneY:Number;
        private var farPlaneZ:Number;
        private var farPlaneOffset:Number;
        private var leftPlaneX:Number;
        private var leftPlaneY:Number;
        private var leftPlaneZ:Number;
        private var leftPlaneOffset:Number;
        private var rightPlaneX:Number;
        private var rightPlaneY:Number;
        private var rightPlaneZ:Number;
        private var rightPlaneOffset:Number;
        private var topPlaneX:Number;
        private var topPlaneY:Number;
        private var topPlaneZ:Number;
        private var topPlaneOffset:Number;
        private var bottomPlaneX:Number;
        private var bottomPlaneY:Number;
        private var bottomPlaneZ:Number;
        private var bottomPlaneOffset:Number;
        private var occluders:Vector.<Vertex> = new Vector.<Vertex>();
        private var numOccluders:int;
        private var materials:Dictionary = new Dictionary();
        private var opaqueList:Object3D;
        private var transparent:Vector.<Object3D> = new Vector.<Object3D>();
        private var transparentLength:int = 0;
        private var receiversVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
        private var receiversIndexBuffers:Vector.<IndexBufferResource> = new Vector.<IndexBufferResource>();
        private var isCreated:Boolean = false;
        public var batched:Boolean = true;


        public function createTree(_arg_1:Vector.<Object3D>, _arg_2:Vector.<Occluder>=null):void
        {
            var _local_3:int;
            var _local_4:Object3D;
            var _local_5:Object3D;
            var _local_8:Object3D;
            var _local_9:Object3D;
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:Material;
            var _local_14:Number;
            var _local_15:Number;
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
            var _local_26:Vertex;
            var _local_27:Face;
            var _local_28:Vertex;
            var _local_29:Mesh;
            var _local_30:Mesh;
            var _local_31:BSP;
            var _local_32:Vector.<Vector.<Number>>;
            var _local_33:Vector.<Vector.<uint>>;
            this.destroyTree();
            var _local_6:int = _arg_1.length;
            var _local_7:int = ((_arg_2 != null) ? _arg_2.length : 0);
            var _local_13:Dictionary = new Dictionary();
            _local_3 = 0;
            while (_local_3 < _local_6)
            {
                _local_4 = _arg_1[_local_3];
                _local_12 = ((_local_4 is Mesh) ? (_local_4 as Mesh).faceList.material : ((_local_4 is BSP) ? (_local_4 as BSP).faces[0].material : null));
                if (_local_12 != null)
                {
                    this.materials[_local_12] = true;
                    if (_local_12.transparent)
                    {
                        this.transparent[this.transparentLength] = _local_4;
                        this.transparentLength++;
                    } else
                    {
                        _local_29 = _local_13[_local_12];
                        if (_local_29 == null)
                        {
                            _local_29 = new Mesh();
                            _local_13[_local_12] = _local_29;
                            _local_29.next = this.opaqueList;
                            this.opaqueList = _local_29;
                            _local_29.setParent(this);
                        };
                        _local_4 = _local_4.clone();
                        _local_4.composeMatrix();
                        if ((_local_4 is Mesh))
                        {
                            _local_30 = (_local_4 as Mesh);
                            if (_local_30.faceList != null)
                            {
                                _local_26 = _local_30.vertexList;
                                while (_local_26 != null)
                                {
                                    _local_20 = _local_26.x;
                                    _local_21 = _local_26.y;
                                    _local_22 = _local_26.z;
                                    _local_26.x = ((((_local_4.ma * _local_20) + (_local_4.mb * _local_21)) + (_local_4.mc * _local_22)) + _local_4.md);
                                    _local_26.y = ((((_local_4.me * _local_20) + (_local_4.mf * _local_21)) + (_local_4.mg * _local_22)) + _local_4.mh);
                                    _local_26.z = ((((_local_4.mi * _local_20) + (_local_4.mj * _local_21)) + (_local_4.mk * _local_22)) + _local_4.ml);
                                    _local_23 = _local_26.normalX;
                                    _local_24 = _local_26.normalY;
                                    _local_25 = _local_26.normalZ;
                                    _local_26.normalX = (((_local_4.ma * _local_23) + (_local_4.mb * _local_24)) + (_local_4.mc * _local_25));
                                    _local_26.normalY = (((_local_4.me * _local_23) + (_local_4.mf * _local_24)) + (_local_4.mg * _local_25));
                                    _local_26.normalZ = (((_local_4.mi * _local_23) + (_local_4.mj * _local_24)) + (_local_4.mk * _local_25));
                                    _local_26.transformId = 0;
                                    if (_local_26.next == null)
                                    {
                                        _local_28 = _local_26;
                                    };
                                    _local_26 = _local_26.next;
                                };
                                _local_28.next = _local_29.vertexList;
                                _local_29.vertexList = _local_30.vertexList;
                                _local_30.vertexList = null;
                                _local_27 = _local_30.faceList;
                                while (_local_27.next != null)
                                {
                                    _local_27 = _local_27.next;
                                };
                                _local_27.next = _local_29.faceList;
                                _local_29.faceList = _local_30.faceList;
                                _local_30.faceList = null;
                            };
                        } else
                        {
                            if ((_local_4 is BSP))
                            {
                                _local_31 = (_local_4 as BSP);
                                if (_local_31.root != null)
                                {
                                    _local_26 = _local_31.vertexList;
                                    while (_local_26 != null)
                                    {
                                        _local_20 = _local_26.x;
                                        _local_21 = _local_26.y;
                                        _local_22 = _local_26.z;
                                        _local_26.x = ((((_local_4.ma * _local_20) + (_local_4.mb * _local_21)) + (_local_4.mc * _local_22)) + _local_4.md);
                                        _local_26.y = ((((_local_4.me * _local_20) + (_local_4.mf * _local_21)) + (_local_4.mg * _local_22)) + _local_4.mh);
                                        _local_26.z = ((((_local_4.mi * _local_20) + (_local_4.mj * _local_21)) + (_local_4.mk * _local_22)) + _local_4.ml);
                                        _local_23 = _local_26.normalX;
                                        _local_24 = _local_26.normalY;
                                        _local_25 = _local_26.normalZ;
                                        _local_26.normalX = (((_local_4.ma * _local_23) + (_local_4.mb * _local_24)) + (_local_4.mc * _local_25));
                                        _local_26.normalY = (((_local_4.me * _local_23) + (_local_4.mf * _local_24)) + (_local_4.mg * _local_25));
                                        _local_26.normalZ = (((_local_4.mi * _local_23) + (_local_4.mj * _local_24)) + (_local_4.mk * _local_25));
                                        _local_26.transformId = 0;
                                        if (_local_26.next == null)
                                        {
                                            _local_28 = _local_26;
                                        };
                                        _local_26 = _local_26.next;
                                    };
                                    _local_28.next = _local_29.vertexList;
                                    _local_29.vertexList = _local_31.vertexList;
                                    _local_31.vertexList = null;
                                    for each (_local_27 in _local_31.faces)
                                    {
                                        _local_27.next = _local_29.faceList;
                                        _local_29.faceList = _local_27;
                                    };
                                    _local_31.faces.length = 0;
                                    _local_31.root = null;
                                };
                            };
                        };
                    };
                };
                _local_3++;
            };
            for each (_local_29 in _local_13)
            {
                _local_29.calculateFacesNormals(true);
                _local_29.calculateBounds();
            };
            _local_14 = 1E22;
            _local_15 = 1E22;
            _local_16 = 1E22;
            _local_17 = -1E22;
            _local_18 = -1E22;
            _local_19 = -1E22;
            _local_3 = 0;
            while (_local_3 < _local_6)
            {
                _local_4 = _arg_1[_local_3];
                _local_5 = this.createObjectBounds(_local_4);
                if (_local_5.boundMinX <= _local_5.boundMaxX)
                {
                    if (_local_4._parent != null)
                    {
                        _local_4._parent.removeChild(_local_4);
                    };
                    _local_4.setParent(this);
                    _local_4.next = _local_8;
                    _local_8 = _local_4;
                    _local_5.next = _local_9;
                    _local_9 = _local_5;
                    if (_local_5.boundMinX < _local_14)
                    {
                        _local_14 = _local_5.boundMinX;
                    };
                    if (_local_5.boundMaxX > _local_17)
                    {
                        _local_17 = _local_5.boundMaxX;
                    };
                    if (_local_5.boundMinY < _local_15)
                    {
                        _local_15 = _local_5.boundMinY;
                    };
                    if (_local_5.boundMaxY > _local_18)
                    {
                        _local_18 = _local_5.boundMaxY;
                    };
                    if (_local_5.boundMinZ < _local_16)
                    {
                        _local_16 = _local_5.boundMinZ;
                    };
                    if (_local_5.boundMaxZ > _local_19)
                    {
                        _local_19 = _local_5.boundMaxZ;
                    };
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _local_7)
            {
                _local_4 = _arg_2[_local_3];
                _local_5 = this.createObjectBounds(_local_4);
                if (_local_5.boundMinX <= _local_5.boundMaxX)
                {
                    if (!((((((_local_5.boundMinX < _local_14) || (_local_5.boundMaxX > _local_17)) || (_local_5.boundMinY < _local_15)) || (_local_5.boundMaxY > _local_18)) || (_local_5.boundMinZ < _local_16)) || (_local_5.boundMaxZ > _local_19)))
                    {
                        if (_local_4._parent != null)
                        {
                            _local_4._parent.removeChild(_local_4);
                        };
                        _local_4.setParent(this);
                        _local_4.next = _local_10;
                        _local_10 = _local_4;
                        _local_5.next = _local_11;
                        _local_11 = _local_5;
                    };
                };
                _local_3++;
            };
            if (_local_8 != null)
            {
                this.root = this.createNode(_local_8, _local_9, _local_10, _local_11, _local_14, _local_15, _local_16, _local_17, _local_18, _local_19);
                _local_32 = new Vector.<Vector.<Number>>();
                _local_33 = new Vector.<Vector.<uint>>();
                _local_32[0] = new Vector.<Number>();
                _local_33[0] = new Vector.<uint>();
                this.root.createReceivers(_local_32, _local_33);
                _local_3 = 0;
                while (_local_3 < _local_32.length)
                {
                    this.receiversVertexBuffers[_local_3] = new VertexBufferResource(_local_32[_local_3], 3);
                    this.receiversIndexBuffers[_local_3] = new IndexBufferResource(_local_33[_local_3]);
                    _local_3++;
                };
            };
        }

        public function destroyTree():void
        {
            var _local_1:int;
            var _local_2:*;
            var _local_3:Object3D;
            var _local_4:Mesh;
            var _local_5:BSP;
            var _local_6:TextureMaterial;
            for (_local_2 in this.materials)
            {
                _local_6 = (_local_2 as TextureMaterial);
                if (_local_6.texture != null)
                {
                    _local_6.textureResource.reset();
                };
                if (_local_6._textureATF != null)
                {
                    _local_6.textureATFResource.reset();
                };
                if (_local_6._textureATFAlpha != null)
                {
                    _local_6.textureATFAlphaResource.reset();
                };
            };
            _local_3 = this.opaqueList;
            while (_local_3 != null)
            {
                if ((_local_3 is Mesh))
                {
                    _local_4 = (_local_3 as Mesh);
                    if (_local_4.vertexBuffer != null)
                    {
                        _local_4.vertexBuffer.reset();
                    };
                    if (_local_4.indexBuffer != null)
                    {
                        _local_4.indexBuffer.reset();
                    };
                } else
                {
                    if ((_local_3 is BSP))
                    {
                        _local_5 = (_local_3 as BSP);
                        if (_local_5.vertexBuffer != null)
                        {
                            _local_5.vertexBuffer.reset();
                        };
                        if (_local_5.indexBuffer != null)
                        {
                            _local_5.indexBuffer.reset();
                        };
                    };
                };
                _local_3 = _local_3.next;
            };
            _local_1 = 0;
            while (_local_1 < this.transparentLength)
            {
                _local_3 = this.transparent[_local_1];
                if ((_local_3 is Mesh))
                {
                    _local_4 = (_local_3 as Mesh);
                    if (_local_4.vertexBuffer != null)
                    {
                        _local_4.vertexBuffer.reset();
                    };
                    if (_local_4.indexBuffer != null)
                    {
                        _local_4.indexBuffer.reset();
                    };
                } else
                {
                    if ((_local_3 is BSP))
                    {
                        _local_5 = (_local_3 as BSP);
                        if (_local_5.vertexBuffer != null)
                        {
                            _local_5.vertexBuffer.reset();
                        };
                        if (_local_5.indexBuffer != null)
                        {
                            _local_5.indexBuffer.reset();
                        };
                    };
                };
                _local_1++;
            };
            this.materials = new Dictionary();
            this.opaqueList = null;
            this.transparent.length = 0;
            this.transparentLength = 0;
            if (this.root != null)
            {
                this.destroyNode(this.root);
                this.root = null;
            };
            _local_1 = 0;
            while (_local_1 < this.receiversVertexBuffers.length)
            {
                VertexBufferResource(this.receiversVertexBuffers[_local_1]).dispose();
                IndexBufferResource(this.receiversIndexBuffers[_local_1]).dispose();
                _local_1++;
            };
            this.receiversVertexBuffers.length = 0;
            this.receiversIndexBuffers.length = 0;
            this.isCreated = false;
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            var _local_6:RayIntersectionData;
            if (((!(_arg_3 == null)) && (_arg_3[this])))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            var _local_5:RayIntersectionData = super.intersectRay(_arg_1, _arg_2, _arg_3, _arg_4);
            if (((!(this.root == null)) && (boundIntersectRay(_arg_1, _arg_2, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ))))
            {
                _local_6 = this.intersectRayNode(this.root, _arg_1, _arg_2, _arg_3, _arg_4);
                if (((!(_local_6 == null)) && ((_local_5 == null) || (_local_6.time < _local_5.time))))
                {
                    _local_5 = _local_6;
                };
            };
            return (_local_5);
        }

        private function intersectRayNode(_arg_1:KDNode, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Dictionary, _arg_5:Camera3D):RayIntersectionData
        {
            var _local_6:RayIntersectionData;
            var _local_7:Number;
            var _local_8:Object3D;
            var _local_9:Object3D;
            var _local_10:Vector3D;
            var _local_11:Vector3D;
            var _local_12:Boolean;
            var _local_13:Boolean;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:RayIntersectionData;
            if (_arg_1.negative != null)
            {
                _local_12 = (_arg_1.axis == 0);
                _local_13 = (_arg_1.axis == 1);
                _local_14 = (((_local_12) ? _arg_2.x : ((_local_13) ? _arg_2.y : _arg_2.z)) - _arg_1.coord);
                if (_local_14 > 0)
                {
                    if (boundIntersectRay(_arg_2, _arg_3, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))
                    {
                        _local_6 = this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5);
                        if (_local_6 != null)
                        {
                            return (_local_6);
                        };
                    };
                    _local_7 = ((_local_12) ? _arg_3.x : ((_local_13) ? _arg_3.y : _arg_3.z));
                    if (_local_7 < 0)
                    {
                        _local_8 = _arg_1.objectList;
                        _local_9 = _arg_1.objectBoundList;
                        while (_local_8 != null)
                        {
                            if (boundIntersectRay(_arg_2, _arg_3, _local_9.boundMinX, _local_9.boundMinY, _local_9.boundMinZ, _local_9.boundMaxX, _local_9.boundMaxY, _local_9.boundMaxZ))
                            {
                                _local_8.composeMatrix();
                                _local_8.invertMatrix();
                                if (_local_10 == null)
                                {
                                    _local_10 = new Vector3D();
                                    _local_11 = new Vector3D();
                                };
                                _local_10.x = ((((_local_8.ma * _arg_2.x) + (_local_8.mb * _arg_2.y)) + (_local_8.mc * _arg_2.z)) + _local_8.md);
                                _local_10.y = ((((_local_8.me * _arg_2.x) + (_local_8.mf * _arg_2.y)) + (_local_8.mg * _arg_2.z)) + _local_8.mh);
                                _local_10.z = ((((_local_8.mi * _arg_2.x) + (_local_8.mj * _arg_2.y)) + (_local_8.mk * _arg_2.z)) + _local_8.ml);
                                _local_11.x = (((_local_8.ma * _arg_3.x) + (_local_8.mb * _arg_3.y)) + (_local_8.mc * _arg_3.z));
                                _local_11.y = (((_local_8.me * _arg_3.x) + (_local_8.mf * _arg_3.y)) + (_local_8.mg * _arg_3.z));
                                _local_11.z = (((_local_8.mi * _arg_3.x) + (_local_8.mj * _arg_3.y)) + (_local_8.mk * _arg_3.z));
                                _local_6 = _local_8.intersectRay(_local_10, _local_11, _arg_4, _arg_5);
                                if (_local_6 != null)
                                {
                                    return (_local_6);
                                };
                            };
                            _local_8 = _local_8.next;
                            _local_9 = _local_9.next;
                        };
                        if (boundIntersectRay(_arg_2, _arg_3, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))
                        {
                            return (this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5));
                        };
                    };
                } else
                {
                    if (boundIntersectRay(_arg_2, _arg_3, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))
                    {
                        _local_6 = this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5);
                        if (_local_6 != null)
                        {
                            return (_local_6);
                        };
                    };
                    _local_7 = ((_local_12) ? _arg_3.x : ((_local_13) ? _arg_3.y : _arg_3.z));
                    if (_local_7 > 0)
                    {
                        _local_8 = _arg_1.objectList;
                        _local_9 = _arg_1.objectBoundList;
                        while (_local_8 != null)
                        {
                            if (boundIntersectRay(_arg_2, _arg_3, _local_9.boundMinX, _local_9.boundMinY, _local_9.boundMinZ, _local_9.boundMaxX, _local_9.boundMaxY, _local_9.boundMaxZ))
                            {
                                _local_8.composeMatrix();
                                _local_8.invertMatrix();
                                if (_local_10 == null)
                                {
                                    _local_10 = new Vector3D();
                                    _local_11 = new Vector3D();
                                };
                                _local_10.x = ((((_local_8.ma * _arg_2.x) + (_local_8.mb * _arg_2.y)) + (_local_8.mc * _arg_2.z)) + _local_8.md);
                                _local_10.y = ((((_local_8.me * _arg_2.x) + (_local_8.mf * _arg_2.y)) + (_local_8.mg * _arg_2.z)) + _local_8.mh);
                                _local_10.z = ((((_local_8.mi * _arg_2.x) + (_local_8.mj * _arg_2.y)) + (_local_8.mk * _arg_2.z)) + _local_8.ml);
                                _local_11.x = (((_local_8.ma * _arg_3.x) + (_local_8.mb * _arg_3.y)) + (_local_8.mc * _arg_3.z));
                                _local_11.y = (((_local_8.me * _arg_3.x) + (_local_8.mf * _arg_3.y)) + (_local_8.mg * _arg_3.z));
                                _local_11.z = (((_local_8.mi * _arg_3.x) + (_local_8.mj * _arg_3.y)) + (_local_8.mk * _arg_3.z));
                                _local_6 = _local_8.intersectRay(_local_10, _local_11, _arg_4, _arg_5);
                                if (_local_6 != null)
                                {
                                    return (_local_6);
                                };
                            };
                            _local_8 = _local_8.next;
                            _local_9 = _local_9.next;
                        };
                        if (boundIntersectRay(_arg_2, _arg_3, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))
                        {
                            return (this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5));
                        };
                    };
                };
            } else
            {
                _local_15 = 1E22;
                _local_8 = _arg_1.objectList;
                while (_local_8 != null)
                {
                    _local_8.composeMatrix();
                    _local_8.invertMatrix();
                    if (_local_10 == null)
                    {
                        _local_10 = new Vector3D();
                        _local_11 = new Vector3D();
                    };
                    _local_10.x = ((((_local_8.ma * _arg_2.x) + (_local_8.mb * _arg_2.y)) + (_local_8.mc * _arg_2.z)) + _local_8.md);
                    _local_10.y = ((((_local_8.me * _arg_2.x) + (_local_8.mf * _arg_2.y)) + (_local_8.mg * _arg_2.z)) + _local_8.mh);
                    _local_10.z = ((((_local_8.mi * _arg_2.x) + (_local_8.mj * _arg_2.y)) + (_local_8.mk * _arg_2.z)) + _local_8.ml);
                    _local_11.x = (((_local_8.ma * _arg_3.x) + (_local_8.mb * _arg_3.y)) + (_local_8.mc * _arg_3.z));
                    _local_11.y = (((_local_8.me * _arg_3.x) + (_local_8.mf * _arg_3.y)) + (_local_8.mg * _arg_3.z));
                    _local_11.z = (((_local_8.mi * _arg_3.x) + (_local_8.mj * _arg_3.y)) + (_local_8.mk * _arg_3.z));
                    _local_6 = _local_8.intersectRay(_local_10, _local_11, _arg_4, _arg_5);
                    if (((!(_local_6 == null)) && (_local_6.time < _local_15)))
                    {
                        _local_15 = _local_6.time;
                        _local_16 = _local_6;
                    };
                    _local_8 = _local_8.next;
                };
                return (_local_16);
            };
            return (null);
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            if (super.checkIntersection(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8))
            {
                return (true);
            };
            if (((!(this.root == null)) && (boundCheckIntersection(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ))))
            {
                return (this.checkIntersectionNode(this.root, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8));
            };
            return (false);
        }

        private function checkIntersectionNode(_arg_1:KDNode, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Dictionary):Boolean
        {
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Boolean;
            var _local_20:Boolean;
            var _local_21:Number;
            var _local_22:Number;
            if (_arg_1.negative != null)
            {
                _local_19 = (_arg_1.axis == 0);
                _local_20 = (_arg_1.axis == 1);
                _local_21 = (((_local_19) ? _arg_2 : ((_local_20) ? _arg_3 : _arg_4)) - _arg_1.coord);
                _local_22 = ((_local_19) ? _arg_5 : ((_local_20) ? _arg_6 : _arg_7));
                if (_local_21 > 0)
                {
                    if (_local_22 < 0)
                    {
                        _local_18 = (-(_local_21) / _local_22);
                        if (_local_18 < _arg_8)
                        {
                            _local_10 = _arg_1.objectList;
                            _local_11 = _arg_1.objectBoundList;
                            while (_local_10 != null)
                            {
                                if (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ))
                                {
                                    _local_10.composeMatrix();
                                    _local_10.invertMatrix();
                                    _local_12 = ((((_local_10.ma * _arg_2) + (_local_10.mb * _arg_3)) + (_local_10.mc * _arg_4)) + _local_10.md);
                                    _local_13 = ((((_local_10.me * _arg_2) + (_local_10.mf * _arg_3)) + (_local_10.mg * _arg_4)) + _local_10.mh);
                                    _local_14 = ((((_local_10.mi * _arg_2) + (_local_10.mj * _arg_3)) + (_local_10.mk * _arg_4)) + _local_10.ml);
                                    _local_15 = (((_local_10.ma * _arg_5) + (_local_10.mb * _arg_6)) + (_local_10.mc * _arg_7));
                                    _local_16 = (((_local_10.me * _arg_5) + (_local_10.mf * _arg_6)) + (_local_10.mg * _arg_7));
                                    _local_17 = (((_local_10.mi * _arg_5) + (_local_10.mj * _arg_6)) + (_local_10.mk * _arg_7));
                                    if (_local_10.checkIntersection(_local_12, _local_13, _local_14, _local_15, _local_16, _local_17, _arg_8, _arg_9))
                                    {
                                        return (true);
                                    };
                                };
                                _local_10 = _local_10.next;
                                _local_11 = _local_11.next;
                            };
                            if (((boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ)) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9))))
                            {
                                return (true);
                            };
                        };
                    };
                    return ((boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ)) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9)));
                };
                if (_local_22 > 0)
                {
                    _local_18 = (-(_local_21) / _local_22);
                    if (_local_18 < _arg_8)
                    {
                        _local_10 = _arg_1.objectList;
                        _local_11 = _arg_1.objectBoundList;
                        while (_local_10 != null)
                        {
                            if (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ))
                            {
                                _local_10.composeMatrix();
                                _local_10.invertMatrix();
                                _local_12 = ((((_local_10.ma * _arg_2) + (_local_10.mb * _arg_3)) + (_local_10.mc * _arg_4)) + _local_10.md);
                                _local_13 = ((((_local_10.me * _arg_2) + (_local_10.mf * _arg_3)) + (_local_10.mg * _arg_4)) + _local_10.mh);
                                _local_14 = ((((_local_10.mi * _arg_2) + (_local_10.mj * _arg_3)) + (_local_10.mk * _arg_4)) + _local_10.ml);
                                _local_15 = (((_local_10.ma * _arg_5) + (_local_10.mb * _arg_6)) + (_local_10.mc * _arg_7));
                                _local_16 = (((_local_10.me * _arg_5) + (_local_10.mf * _arg_6)) + (_local_10.mg * _arg_7));
                                _local_17 = (((_local_10.mi * _arg_5) + (_local_10.mj * _arg_6)) + (_local_10.mk * _arg_7));
                                if (_local_10.checkIntersection(_local_12, _local_13, _local_14, _local_15, _local_16, _local_17, _arg_8, _arg_9))
                                {
                                    return (true);
                                };
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        if (((boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ)) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9))))
                        {
                            return (true);
                        };
                    };
                };
                return ((boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ)) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9)));
            };
            _local_10 = _arg_1.objectList;
            while (_local_10 != null)
            {
                _local_10.composeMatrix();
                _local_10.invertMatrix();
                _local_12 = ((((_local_10.ma * _arg_2) + (_local_10.mb * _arg_3)) + (_local_10.mc * _arg_4)) + _local_10.md);
                _local_13 = ((((_local_10.me * _arg_2) + (_local_10.mf * _arg_3)) + (_local_10.mg * _arg_4)) + _local_10.mh);
                _local_14 = ((((_local_10.mi * _arg_2) + (_local_10.mj * _arg_3)) + (_local_10.mk * _arg_4)) + _local_10.ml);
                _local_15 = (((_local_10.ma * _arg_5) + (_local_10.mb * _arg_6)) + (_local_10.mc * _arg_7));
                _local_16 = (((_local_10.me * _arg_5) + (_local_10.mf * _arg_6)) + (_local_10.mg * _arg_7));
                _local_17 = (((_local_10.mi * _arg_5) + (_local_10.mj * _arg_6)) + (_local_10.mk * _arg_7));
                if (_local_10.checkIntersection(_local_12, _local_13, _local_14, _local_15, _local_16, _local_17, _arg_8, _arg_9))
                {
                    return (true);
                };
                _local_10 = _local_10.next;
            };
            return (false);
        }

        override alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
            var _local_9:Object3D;
            if (((!(_arg_7 == null)) && (_arg_7[this])))
            {
                return;
            };
            var _local_8:Vector3D = calculateSphere(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, treeSphere);
            if ((!(this.ignoreChildrenInCollider)))
            {
                if ((!(boundIntersectSphere(_local_8, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
                {
                    return;
                };
                _local_9 = childrenList;
                while (_local_9 != null)
                {
                    _local_9.composeAndAppend(this);
                    _local_9.collectPlanes(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                    _local_9 = _local_9.next;
                };
            };
            if (((!(this.root == null)) && (boundIntersectSphere(_local_8, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ))))
            {
                this.collectPlanesNode(this.root, _local_8, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        private function collectPlanesNode(_arg_1:KDNode, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector3D, _arg_7:Vector3D, _arg_8:Vector.<Face>, _arg_9:Dictionary=null):void
        {
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:Boolean;
            var _local_13:Boolean;
            var _local_14:Number;
            if (_arg_1.negative != null)
            {
                _local_12 = (_arg_1.axis == 0);
                _local_13 = (_arg_1.axis == 1);
                _local_14 = (((_local_12) ? _arg_2.x : ((_local_13) ? _arg_2.y : _arg_2.z)) - _arg_1.coord);
                if (_local_14 >= _arg_2.w)
                {
                    if (boundIntersectSphere(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))
                    {
                        this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                    };
                } else
                {
                    if (_local_14 <= -(_arg_2.w))
                    {
                        if (boundIntersectSphere(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))
                        {
                            this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                    } else
                    {
                        _local_10 = _arg_1.objectList;
                        _local_11 = _arg_1.objectBoundList;
                        while (_local_10 != null)
                        {
                            if (boundIntersectSphere(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ))
                            {
                                _local_10.composeAndAppend(this);
                                _local_10.collectPlanes(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        if (boundIntersectSphere(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))
                        {
                            this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                        if (boundIntersectSphere(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))
                        {
                            this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                    };
                };
            } else
            {
                _local_10 = _arg_1.objectList;
                while (_local_10 != null)
                {
                    _local_10.composeAndAppend(this);
                    _local_10.collectPlanes(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                    _local_10 = _local_10.next;
                };
            };
        }

        public function createDecal(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Material):Decal
        {
            var _local_8:Decal = new Decal();
            _local_8.attenuation = _arg_6;
            var _local_9:Matrix3D = new Matrix3D();
            _local_9.appendRotation(((_arg_4 * 180) / Math.PI), Vector3D.Z_AXIS);
            _local_9.appendRotation((((Math.atan2(-(_arg_2.z), Math.sqrt(((_arg_2.x * _arg_2.x) + (_arg_2.y * _arg_2.y)))) * 180) / Math.PI) - 90), Vector3D.X_AXIS);
            _local_9.appendRotation(((-(Math.atan2(-(_arg_2.x), -(_arg_2.y))) * 180) / Math.PI), Vector3D.Z_AXIS);
            _local_9.appendTranslation(_arg_1.x, _arg_1.y, _arg_1.z);
            _local_8.matrix = _local_9;
            _local_8.composeMatrix();
            _local_8.boundMinX = -(_arg_3);
            _local_8.boundMaxX = _arg_3;
            _local_8.boundMinY = -(_arg_3);
            _local_8.boundMaxY = _arg_3;
            _local_8.boundMinZ = -(_arg_6);
            _local_8.boundMaxZ = _arg_6;
            var _local_10:Number = 1E22;
            var _local_11:Number = 1E22;
            var _local_12:Number = 1E22;
            var _local_13:Number = -1E22;
            var _local_14:Number = -1E22;
            var _local_15:Number = -1E22;
            var _local_16:Vertex = boundVertexList;
            _local_16.x = _local_8.boundMinX;
            _local_16.y = _local_8.boundMinY;
            _local_16.z = _local_8.boundMinZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMaxX;
            _local_16.y = _local_8.boundMinY;
            _local_16.z = _local_8.boundMinZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMinX;
            _local_16.y = _local_8.boundMaxY;
            _local_16.z = _local_8.boundMinZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMaxX;
            _local_16.y = _local_8.boundMaxY;
            _local_16.z = _local_8.boundMinZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMinX;
            _local_16.y = _local_8.boundMinY;
            _local_16.z = _local_8.boundMaxZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMaxX;
            _local_16.y = _local_8.boundMinY;
            _local_16.z = _local_8.boundMaxZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMinX;
            _local_16.y = _local_8.boundMaxY;
            _local_16.z = _local_8.boundMaxZ;
            _local_16 = _local_16.next;
            _local_16.x = _local_8.boundMaxX;
            _local_16.y = _local_8.boundMaxY;
            _local_16.z = _local_8.boundMaxZ;
            _local_16 = boundVertexList;
            while (_local_16 != null)
            {
                _local_16.cameraX = ((((_local_8.ma * _local_16.x) + (_local_8.mb * _local_16.y)) + (_local_8.mc * _local_16.z)) + _local_8.md);
                _local_16.cameraY = ((((_local_8.me * _local_16.x) + (_local_8.mf * _local_16.y)) + (_local_8.mg * _local_16.z)) + _local_8.mh);
                _local_16.cameraZ = ((((_local_8.mi * _local_16.x) + (_local_8.mj * _local_16.y)) + (_local_8.mk * _local_16.z)) + _local_8.ml);
                if (_local_16.cameraX < _local_10)
                {
                    _local_10 = _local_16.cameraX;
                };
                if (_local_16.cameraX > _local_13)
                {
                    _local_13 = _local_16.cameraX;
                };
                if (_local_16.cameraY < _local_11)
                {
                    _local_11 = _local_16.cameraY;
                };
                if (_local_16.cameraY > _local_14)
                {
                    _local_14 = _local_16.cameraY;
                };
                if (_local_16.cameraZ < _local_12)
                {
                    _local_12 = _local_16.cameraZ;
                };
                if (_local_16.cameraZ > _local_15)
                {
                    _local_15 = _local_16.cameraZ;
                };
                _local_16 = _local_16.next;
            };
            _local_8.invertMatrix();
            if (_arg_5 > (Math.PI / 2))
            {
                _arg_5 = (Math.PI / 2);
            };
            if (this.root != null)
            {
                this.root.collectPolygons(_local_8, Math.sqrt((((_arg_3 * _arg_3) + (_arg_3 * _arg_3)) + (_arg_6 * _arg_6))), (Math.cos(_arg_5) - 0.001), _local_10, _local_13, _local_11, _local_14, _local_12, _local_15);
            };
            if (_local_8.faceList != null)
            {
                _local_8.calculateBounds();
            } else
            {
                _local_8.boundMinX = -1;
                _local_8.boundMinY = -1;
                _local_8.boundMinZ = -1;
                _local_8.boundMaxX = 1;
                _local_8.boundMaxY = 1;
                _local_8.boundMaxZ = 1;
            };
            _local_8.setMaterialToAllFaces(_arg_7);
            return (_local_8);
        }

        override public function clone():Object3D
        {
            var _local_1:KDContainer = new KDContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:KDContainer = (_arg_1 as KDContainer);
            this.debugAlphaFade = _local_2.debugAlphaFade;
            if (_local_2.root != null)
            {
                this.root = _local_2.cloneNode(_local_2.root, this);
            };
        }

        private function cloneNode(_arg_1:KDNode, _arg_2:Object3DContainer):KDNode
        {
            var _local_4:Object3D;
            var _local_5:Object3D;
            var _local_6:Object3D;
            var _local_3:KDNode = new KDNode();
            _local_3.axis = _arg_1.axis;
            _local_3.coord = _arg_1.coord;
            _local_3.minCoord = _arg_1.minCoord;
            _local_3.maxCoord = _arg_1.maxCoord;
            _local_3.boundMinX = _arg_1.boundMinX;
            _local_3.boundMinY = _arg_1.boundMinY;
            _local_3.boundMinZ = _arg_1.boundMinZ;
            _local_3.boundMaxX = _arg_1.boundMaxX;
            _local_3.boundMaxY = _arg_1.boundMaxY;
            _local_3.boundMaxZ = _arg_1.boundMaxZ;
            _local_4 = _arg_1.objectList;
            _local_5 = null;
            while (_local_4 != null)
            {
                _local_6 = _local_4.clone();
                if (_local_3.objectList != null)
                {
                    _local_5.next = _local_6;
                } else
                {
                    _local_3.objectList = _local_6;
                };
                _local_5 = _local_6;
                _local_6.setParent(_arg_2);
                _local_4 = _local_4.next;
            };
            _local_4 = _arg_1.objectBoundList;
            _local_5 = null;
            while (_local_4 != null)
            {
                _local_6 = _local_4.clone();
                if (_local_3.objectBoundList != null)
                {
                    _local_5.next = _local_6;
                } else
                {
                    _local_3.objectBoundList = _local_6;
                };
                _local_5 = _local_6;
                _local_4 = _local_4.next;
            };
            _local_4 = _arg_1.occluderList;
            _local_5 = null;
            while (_local_4 != null)
            {
                _local_6 = _local_4.clone();
                if (_local_3.occluderList != null)
                {
                    _local_5.next = _local_6;
                } else
                {
                    _local_3.occluderList = _local_6;
                };
                _local_5 = _local_6;
                _local_6.setParent(_arg_2);
                _local_4 = _local_4.next;
            };
            _local_4 = _arg_1.occluderBoundList;
            _local_5 = null;
            while (_local_4 != null)
            {
                _local_6 = _local_4.clone();
                if (_local_3.occluderBoundList != null)
                {
                    _local_5.next = _local_6;
                } else
                {
                    _local_3.occluderBoundList = _local_6;
                };
                _local_5 = _local_6;
                _local_4 = _local_4.next;
            };
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

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:int;
            var _local_3:Object3D;
            var _local_4:VG;
            var _local_5:VG;
            var _local_7:Boolean;
            var _local_8:Object3D;
            var _local_9:VG;
            var _local_10:int;
            var _local_11:Vertex;
            var _local_12:Vertex;
            var _local_13:ShadowAtlas;
            this.uploadResources(_arg_1.device);
            calculateInverseMatrix();
            var _local_6:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_6 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
            if (this.batched)
            {
                _local_7 = _arg_1.debug;
                if (((_local_6) && (_local_6 & Debug.NODES)))
                {
                    _arg_1.debug = false;
                };
                _local_3 = this.opaqueList;
                while (_local_3 != null)
                {
                    _local_3.ma = ma;
                    _local_3.mb = mb;
                    _local_3.mc = mc;
                    _local_3.md = md;
                    _local_3.me = me;
                    _local_3.mf = mf;
                    _local_3.mg = mg;
                    _local_3.mh = mh;
                    _local_3.mi = mi;
                    _local_3.mj = mj;
                    _local_3.mk = mk;
                    _local_3.ml = ml;
                    _local_3.concat(this);
                    _local_3.draw(_arg_1);
                    if (((((!(_arg_1.view.constrained)) && (!(_arg_1.shadowMap == null))) && (_arg_1.shadowMapStrength > 0)) && (_local_3.concatenatedAlpha >= _local_3.shadowMapAlphaThreshold)))
                    {
                        _arg_1.casterObjects[_arg_1.casterCount] = _local_3;
                        _arg_1.casterCount++;
                    };
                    _local_3 = _local_3.next;
                };
                _arg_1.debug = _local_7;
                _local_5 = super.getVG(_arg_1);
                if ((((!(_arg_1.view.constrained)) && (!(_arg_1.shadowMap == null))) && (_arg_1.shadowMapStrength > 0)))
                {
                    _local_3 = childrenList;
                    while (_local_3 != null)
                    {
                        if (_local_3.visible)
                        {
                            if ((((_local_3 is Mesh) || (_local_3 is BSP)) || (_local_3 is Sprite3D)))
                            {
                                if (_local_3.concatenatedAlpha >= _local_3.shadowMapAlphaThreshold)
                                {
                                    _arg_1.casterObjects[_arg_1.casterCount] = _local_3;
                                    _arg_1.casterCount++;
                                };
                            } else
                            {
                                if ((_local_3 is Object3DContainer))
                                {
                                    _local_8 = Object3DContainer(_local_3).childrenList;
                                    while (_local_8 != null)
                                    {
                                        if (((((_local_8 is Mesh) || (_local_8 is BSP)) || (_local_8 is Sprite3D)) && (_local_8.concatenatedAlpha >= _local_8.shadowMapAlphaThreshold)))
                                        {
                                            _arg_1.casterObjects[_arg_1.casterCount] = _local_8;
                                            _arg_1.casterCount++;
                                        };
                                        _local_8 = _local_8.next;
                                    };
                                };
                            };
                        };
                        _local_3 = _local_3.next;
                    };
                };
                _local_2 = 0;
                while (_local_2 < this.transparentLength)
                {
                    _local_3 = this.transparent[_local_2];
                    _local_3.composeAndAppend(this);
                    if (_local_3.cullingInCamera(_arg_1, culling) >= 0)
                    {
                        _local_3.concat(this);
                        _local_9 = _local_3.getVG(_arg_1);
                        if (_local_9 != null)
                        {
                            _local_9.next = _local_5;
                            _local_5 = _local_9;
                        };
                    };
                    if (((((!(_arg_1.view.constrained)) && (!(_arg_1.shadowMap == null))) && (_arg_1.shadowMapStrength > 0)) && (_local_3.concatenatedAlpha >= _local_3.shadowMapAlphaThreshold)))
                    {
                        _arg_1.casterObjects[_arg_1.casterCount] = _local_3;
                        _arg_1.casterCount++;
                    };
                    _local_2++;
                };
                if (_local_5 != null)
                {
                    if (_local_5.next != null)
                    {
                        if (resolveByAABB)
                        {
                            _local_4 = _local_5;
                            while (_local_4 != null)
                            {
                                _local_4.calculateAABB(ima, imb, imc, imd, ime, imf, img, imh, imi, imj, imk, iml);
                                _local_4 = _local_4.next;
                            };
                            drawAABBGeometry(_arg_1, _local_5);
                        } else
                        {
                            if (resolveByOOBB)
                            {
                                _local_4 = _local_5;
                                while (_local_4 != null)
                                {
                                    _local_4.calculateOOBB(this);
                                    _local_4 = _local_4.next;
                                };
                                drawOOBBGeometry(_arg_1, _local_5);
                            } else
                            {
                                drawConflictGeometry(_arg_1, _local_5);
                            };
                        };
                    } else
                    {
                        _local_5.draw(_arg_1, threshold, this);
                        _local_5.destroy();
                    };
                };
            } else
            {
                if (this.root != null)
                {
                    this.calculateCameraPlanes(_arg_1.nearClipping, _arg_1.farClipping);
                    _local_10 = this.cullingInContainer(culling, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ);
                    if (_local_10 >= 0)
                    {
                        this.numOccluders = 0;
                        if (_arg_1.numOccluders > 0)
                        {
                            this.updateOccluders(_arg_1);
                        };
                        _local_5 = super.getVG(_arg_1);
                        _local_4 = _local_5;
                        while (_local_4 != null)
                        {
                            _local_4.calculateAABB(ima, imb, imc, imd, ime, imf, img, imh, imi, imj, imk, iml);
                            _local_4 = _local_4.next;
                        };
                        this.drawNode(this.root, _local_10, _arg_1, _local_5);
                        _local_2 = 0;
                        while (_local_2 < this.numOccluders)
                        {
                            _local_11 = this.occluders[_local_2];
                            _local_12 = _local_11;
                            while (_local_12.next != null)
                            {
                                _local_12 = _local_12.next;
                            };
                            _local_12.next = Vertex.collector;
                            Vertex.collector = _local_11;
                            this.occluders[_local_2] = null;
                            _local_2++;
                        };
                        this.numOccluders = 0;
                    } else
                    {
                        super.draw(_arg_1);
                    };
                } else
                {
                    super.draw(_arg_1);
                };
            };
            if (((!(this.root == null)) && (_local_6 & Debug.NODES)))
            {
                this.debugNode(this.root, _local_10, _arg_1, 1);
                Debug.drawBounds(_arg_1, this, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ, 14496733);
            };
            if (this.root != null)
            {
                _arg_1.receiversVertexBuffers = this.receiversVertexBuffers;
                _arg_1.receiversIndexBuffers = this.receiversIndexBuffers;
                for each (_local_13 in _arg_1.shadowAtlases)
                {
                    _local_2 = 0;
                    while (_local_2 < _local_13.shadowsCount)
                    {
                        this.root.collectReceivers(_local_13.shadows[_local_2]);
                        _local_2++;
                    };
                };
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_3:int;
            var _local_2:VG = super.getVG(_arg_1);
            if (this.root != null)
            {
                this.numOccluders = 0;
                calculateInverseMatrix();
                this.calculateCameraPlanes(_arg_1.nearClipping, _arg_1.farClipping);
                _local_3 = this.cullingInContainer(culling, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ);
                if (_local_3 >= 0)
                {
                    _local_2 = this.collectVGNode(this.root, _local_3, _arg_1, _local_2);
                };
            };
            return (_local_2);
        }

        private function collectVGNode(_arg_1:KDNode, _arg_2:int, _arg_3:Camera3D, _arg_4:VG=null):VG
        {
            var _local_5:VG;
            var _local_6:VG;
            var _local_9:VG;
            var _local_10:int;
            var _local_11:int;
            var _local_7:Object3D = _arg_1.objectList;
            var _local_8:Object3D = _arg_1.objectBoundList;
            while (_local_7 != null)
            {
                if (((_local_7.visible) && (((_local_7.culling = _arg_2) == 0) || ((_local_7.culling = this.cullingInContainer(_arg_2, _local_8.boundMinX, _local_8.boundMinY, _local_8.boundMinZ, _local_8.boundMaxX, _local_8.boundMaxY, _local_8.boundMaxZ)) >= 0))))
                {
                    _local_7.composeAndAppend(this);
                    _local_7.concat(this);
                    _local_9 = _local_7.getVG(_arg_3);
                    if (_local_9 != null)
                    {
                        if (_local_5 != null)
                        {
                            _local_6.next = _local_9;
                        } else
                        {
                            _local_5 = _local_9;
                            _local_6 = _local_9;
                        };
                        while (_local_6.next != null)
                        {
                            _local_6 = _local_6.next;
                        };
                    };
                };
                _local_7 = _local_7.next;
                _local_8 = _local_8.next;
            };
            if (_local_5 != null)
            {
                _local_6.next = _arg_4;
                _arg_4 = _local_5;
            };
            if (_arg_1.negative != null)
            {
                _local_10 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                _local_11 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                if (_local_10 >= 0)
                {
                    _arg_4 = this.collectVGNode(_arg_1.negative, _local_10, _arg_3, _arg_4);
                };
                if (_local_11 >= 0)
                {
                    _arg_4 = this.collectVGNode(_arg_1.positive, _local_11, _arg_3, _arg_4);
                };
            };
            return (_arg_4);
        }

        private function uploadResources(_arg_1:Device):void
        {
            var _local_2:*;
            var _local_3:Object3D;
            var _local_4:Mesh;
            var _local_5:BSP;
            var _local_7:TextureMaterial;
            if (this.isCreated)
            {
                return;
            };
            this.isCreated = true;
            for (_local_2 in this.materials)
            {
                _local_7 = (_local_2 as TextureMaterial);
                if (_local_7.texture != null)
                {
                    _arg_1.uploadResource(_local_7.textureResource);
                };
                if (_local_7._textureATF != null)
                {
                    _arg_1.uploadResource(_local_7.textureATFResource);
                };
                if (_local_7._textureATFAlpha != null)
                {
                    _arg_1.uploadResource(_local_7.textureATFAlphaResource);
                };
            };
            _local_3 = this.opaqueList;
            while (_local_3 != null)
            {
                if ((_local_3 is Mesh))
                {
                    _local_4 = (_local_3 as Mesh);
                    _local_4.prepareResources();
                    _arg_1.uploadResource(_local_4.vertexBuffer);
                    _arg_1.uploadResource(_local_4.indexBuffer);
                } else
                {
                    if ((_local_3 is BSP))
                    {
                        _local_5 = (_local_3 as BSP);
                        _local_5.prepareResources();
                        _arg_1.uploadResource(_local_5.vertexBuffer);
                        _arg_1.uploadResource(_local_5.indexBuffer);
                    };
                };
                _local_3 = _local_3.next;
            };
            var _local_6:int;
            while (_local_6 < this.transparentLength)
            {
                _local_3 = this.transparent[_local_6];
                if ((_local_3 is Mesh))
                {
                    _local_4 = (_local_3 as Mesh);
                    _local_4.prepareResources();
                    _arg_1.uploadResource(_local_4.vertexBuffer);
                    _arg_1.uploadResource(_local_4.indexBuffer);
                } else
                {
                    if ((_local_3 is BSP))
                    {
                        _local_5 = (_local_3 as BSP);
                        _local_5.prepareResources();
                        _arg_1.uploadResource(_local_5.vertexBuffer);
                        _arg_1.uploadResource(_local_5.indexBuffer);
                    };
                };
                _local_6++;
            };
            _local_6 = 0;
            while (_local_6 < this.receiversVertexBuffers.length)
            {
                _arg_1.uploadResource(this.receiversVertexBuffers[_local_6]);
                _arg_1.uploadResource(this.receiversIndexBuffers[_local_6]);
                _local_6++;
            };
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            super.updateBounds(_arg_1, _arg_2);
            if (this.root != null)
            {
                if (_arg_2 != null)
                {
                    this.updateBoundsNode(this.root, _arg_1, _arg_2);
                } else
                {
                    if (this.root.boundMinX < _arg_1.boundMinX)
                    {
                        _arg_1.boundMinX = this.root.boundMinX;
                    };
                    if (this.root.boundMaxX > _arg_1.boundMaxX)
                    {
                        _arg_1.boundMaxX = this.root.boundMaxX;
                    };
                    if (this.root.boundMinY < _arg_1.boundMinY)
                    {
                        _arg_1.boundMinY = this.root.boundMinY;
                    };
                    if (this.root.boundMaxY > _arg_1.boundMaxY)
                    {
                        _arg_1.boundMaxY = this.root.boundMaxY;
                    };
                    if (this.root.boundMinZ < _arg_1.boundMinZ)
                    {
                        _arg_1.boundMinZ = this.root.boundMinZ;
                    };
                    if (this.root.boundMaxZ > _arg_1.boundMaxZ)
                    {
                        _arg_1.boundMaxZ = this.root.boundMaxZ;
                    };
                };
            };
        }

        private function updateBoundsNode(_arg_1:KDNode, _arg_2:Object3D, _arg_3:Object3D):void
        {
            var _local_4:Object3D = _arg_1.objectList;
            while (_local_4 != null)
            {
                if (_arg_3 != null)
                {
                    _local_4.composeAndAppend(_arg_3);
                } else
                {
                    _local_4.composeMatrix();
                };
                _local_4.updateBounds(_arg_2, _local_4);
                _local_4 = _local_4.next;
            };
            if (_arg_1.negative != null)
            {
                this.updateBoundsNode(_arg_1.negative, _arg_2, _arg_3);
                this.updateBoundsNode(_arg_1.positive, _arg_2, _arg_3);
            };
        }

        private function debugNode(_arg_1:KDNode, _arg_2:int, _arg_3:Camera3D, _arg_4:Number):void
        {
            var _local_5:int;
            var _local_6:int;
            if (((!(_arg_1 == null)) && (!(_arg_1.negative == null))))
            {
                _local_5 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                _local_6 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                if (_local_5 >= 0)
                {
                    this.debugNode(_arg_1.negative, _local_5, _arg_3, (_arg_4 * this.debugAlphaFade));
                };
                Debug.drawKDNode(_arg_3, this, _arg_1.axis, _arg_1.coord, _arg_1.boundMinX, _arg_1.boundMinY, _arg_1.boundMinZ, _arg_1.boundMaxX, _arg_1.boundMaxY, _arg_1.boundMaxZ, _arg_4);
                if (_local_6 >= 0)
                {
                    this.debugNode(_arg_1.positive, _local_6, _arg_3, (_arg_4 * this.debugAlphaFade));
                };
            };
        }

        private function drawNode(_arg_1:KDNode, _arg_2:int, _arg_3:Camera3D, _arg_4:VG):void
        {
            var _local_5:int;
            var _local_6:VG;
            var _local_7:VG;
            var _local_8:VG;
            var _local_9:VG;
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:int;
            var _local_13:int;
            var _local_14:Boolean;
            var _local_15:Boolean;
            var _local_16:Number;
            var _local_17:Number;
            if (_arg_3.occludedAll)
            {
                while (_arg_4 != null)
                {
                    _local_6 = _arg_4.next;
                    _arg_4.destroy();
                    _arg_4 = _local_6;
                };
                return;
            };
            if (_arg_1.negative != null)
            {
                _local_12 = (((_arg_2 > 0) || (this.numOccluders > 0)) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                _local_13 = (((_arg_2 > 0) || (this.numOccluders > 0)) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                _local_14 = (_arg_1.axis == 0);
                _local_15 = (_arg_1.axis == 1);
                if (((_local_12 >= 0) && (_local_13 >= 0)))
                {
                    while (_arg_4 != null)
                    {
                        _local_6 = _arg_4.next;
                        if (((_arg_4.numOccluders < this.numOccluders) && (this.occludeGeometry(_arg_3, _arg_4))))
                        {
                            _arg_4.destroy();
                        } else
                        {
                            _local_16 = ((_local_14) ? _arg_4.boundMinX : ((_local_15) ? _arg_4.boundMinY : _arg_4.boundMinZ));
                            _local_17 = ((_local_14) ? _arg_4.boundMaxX : ((_local_15) ? _arg_4.boundMaxY : _arg_4.boundMaxZ));
                            if (_local_17 <= _arg_1.maxCoord)
                            {
                                if (_local_16 < _arg_1.minCoord)
                                {
                                    _arg_4.next = _local_7;
                                    _local_7 = _arg_4;
                                } else
                                {
                                    _arg_4.next = _local_8;
                                    _local_8 = _arg_4;
                                };
                            } else
                            {
                                if (_local_16 >= _arg_1.minCoord)
                                {
                                    _arg_4.next = _local_9;
                                    _local_9 = _arg_4;
                                } else
                                {
                                    _arg_4.split(_arg_3, ((_arg_1.axis == 0) ? 1 : 0), ((_arg_1.axis == 1) ? 1 : 0), ((_arg_1.axis == 2) ? 1 : 0), _arg_1.coord, threshold);
                                    if (_arg_4.next != null)
                                    {
                                        _arg_4.next.next = _local_7;
                                        _local_7 = _arg_4.next;
                                    };
                                    if (_arg_4.faceStruct != null)
                                    {
                                        _arg_4.next = _local_9;
                                        _local_9 = _arg_4;
                                    } else
                                    {
                                        _arg_4.destroy();
                                    };
                                };
                            };
                        };
                        _arg_4 = _local_6;
                    };
                    if (((((_local_14) && (imd > _arg_1.coord)) || ((_local_15) && (imh > _arg_1.coord))) || (((!(_local_14)) && (!(_local_15))) && (iml > _arg_1.coord))))
                    {
                        this.drawNode(_arg_1.positive, _local_13, _arg_3, _local_9);
                        while (_local_8 != null)
                        {
                            _local_6 = _local_8.next;
                            if (((_local_8.numOccluders >= this.numOccluders) || (!(this.occludeGeometry(_arg_3, _local_8)))))
                            {
                                _local_8.draw(_arg_3, threshold, this);
                            };
                            _local_8.destroy();
                            _local_8 = _local_6;
                        };
                        _local_10 = _arg_1.objectList;
                        _local_11 = _arg_1.objectBoundList;
                        while (_local_10 != null)
                        {
                            if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                            {
                                _local_10.copyAndAppend(_local_11, this);
                                _local_10.concat(this);
                                _local_10.draw(_arg_3);
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        _local_10 = _arg_1.occluderList;
                        _local_11 = _arg_1.occluderBoundList;
                        while (_local_10 != null)
                        {
                            if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                            {
                                _local_10.copyAndAppend(_local_11, this);
                                _local_10.concat(this);
                                _local_10.draw(_arg_3);
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        if (_arg_1.occluderList != null)
                        {
                            this.updateOccluders(_arg_3);
                        };
                        this.drawNode(_arg_1.negative, _local_12, _arg_3, _local_7);
                    } else
                    {
                        this.drawNode(_arg_1.negative, _local_12, _arg_3, _local_7);
                        while (_local_8 != null)
                        {
                            _local_6 = _local_8.next;
                            if (((_local_8.numOccluders >= this.numOccluders) || (!(this.occludeGeometry(_arg_3, _local_8)))))
                            {
                                _local_8.draw(_arg_3, threshold, this);
                            };
                            _local_8.destroy();
                            _local_8 = _local_6;
                        };
                        _local_10 = _arg_1.objectList;
                        _local_11 = _arg_1.objectBoundList;
                        while (_local_10 != null)
                        {
                            if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                            {
                                _local_10.copyAndAppend(_local_11, this);
                                _local_10.concat(this);
                                _local_10.draw(_arg_3);
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        _local_10 = _arg_1.occluderList;
                        _local_11 = _arg_1.occluderBoundList;
                        while (_local_10 != null)
                        {
                            if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                            {
                                _local_10.copyAndAppend(_local_11, this);
                                _local_10.concat(this);
                                _local_10.draw(_arg_3);
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        if (_arg_1.occluderList != null)
                        {
                            this.updateOccluders(_arg_3);
                        };
                        this.drawNode(_arg_1.positive, _local_13, _arg_3, _local_9);
                    };
                } else
                {
                    if (_local_12 >= 0)
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            if (((_arg_4.numOccluders < this.numOccluders) && (this.occludeGeometry(_arg_3, _arg_4))))
                            {
                                _arg_4.destroy();
                            } else
                            {
                                _local_16 = ((_local_14) ? _arg_4.boundMinX : ((_local_15) ? _arg_4.boundMinY : _arg_4.boundMinZ));
                                _local_17 = ((_local_14) ? _arg_4.boundMaxX : ((_local_15) ? _arg_4.boundMaxY : _arg_4.boundMaxZ));
                                if (_local_17 <= _arg_1.maxCoord)
                                {
                                    _arg_4.next = _local_7;
                                    _local_7 = _arg_4;
                                } else
                                {
                                    if (_local_16 >= _arg_1.minCoord)
                                    {
                                        _arg_4.destroy();
                                    } else
                                    {
                                        _arg_4.crop(_arg_3, ((_arg_1.axis == 0) ? -1 : 0), ((_arg_1.axis == 1) ? -1 : 0), ((_arg_1.axis == 2) ? -1 : 0), -(_arg_1.coord), threshold);
                                        if (_arg_4.faceStruct != null)
                                        {
                                            _arg_4.next = _local_7;
                                            _local_7 = _arg_4;
                                        } else
                                        {
                                            _arg_4.destroy();
                                        };
                                    };
                                };
                            };
                            _arg_4 = _local_6;
                        };
                        this.drawNode(_arg_1.negative, _local_12, _arg_3, _local_7);
                    } else
                    {
                        if (_local_13 >= 0)
                        {
                            while (_arg_4 != null)
                            {
                                _local_6 = _arg_4.next;
                                if (((_arg_4.numOccluders < this.numOccluders) && (this.occludeGeometry(_arg_3, _arg_4))))
                                {
                                    _arg_4.destroy();
                                } else
                                {
                                    _local_16 = ((_local_14) ? _arg_4.boundMinX : ((_local_15) ? _arg_4.boundMinY : _arg_4.boundMinZ));
                                    _local_17 = ((_local_14) ? _arg_4.boundMaxX : ((_local_15) ? _arg_4.boundMaxY : _arg_4.boundMaxZ));
                                    if (_local_17 <= _arg_1.maxCoord)
                                    {
                                        _arg_4.destroy();
                                    } else
                                    {
                                        if (_local_16 >= _arg_1.minCoord)
                                        {
                                            _arg_4.next = _local_9;
                                            _local_9 = _arg_4;
                                        } else
                                        {
                                            _arg_4.crop(_arg_3, ((_arg_1.axis == 0) ? 1 : 0), ((_arg_1.axis == 1) ? 1 : 0), ((_arg_1.axis == 2) ? 1 : 0), _arg_1.coord, threshold);
                                            if (_arg_4.faceStruct != null)
                                            {
                                                _arg_4.next = _local_9;
                                                _local_9 = _arg_4;
                                            } else
                                            {
                                                _arg_4.destroy();
                                            };
                                        };
                                    };
                                };
                                _arg_4 = _local_6;
                            };
                            this.drawNode(_arg_1.positive, _local_13, _arg_3, _local_9);
                        } else
                        {
                            while (_arg_4 != null)
                            {
                                _local_6 = _arg_4.next;
                                _arg_4.destroy();
                                _arg_4 = _local_6;
                            };
                        };
                    };
                };
            } else
            {
                if (_arg_1.objectList != null)
                {
                    if (((!(_arg_1.objectList.next == null)) || (!(_arg_4 == null))))
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            if (((_arg_4.numOccluders < this.numOccluders) && (this.occludeGeometry(_arg_3, _arg_4))))
                            {
                                _arg_4.destroy();
                            } else
                            {
                                _arg_4.next = _local_8;
                                _local_8 = _arg_4;
                            };
                            _arg_4 = _local_6;
                        };
                        _local_10 = _arg_1.objectList;
                        _local_11 = _arg_1.objectBoundList;
                        while (_local_10 != null)
                        {
                            if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                            {
                                _local_10.copyAndAppend(_local_11, this);
                                _local_10.concat(this);
                                _arg_4 = _local_10.getVG(_arg_3);
                                while (_arg_4 != null)
                                {
                                    _local_6 = _arg_4.next;
                                    _arg_4.next = _local_8;
                                    _local_8 = _arg_4;
                                    _arg_4 = _local_6;
                                };
                            };
                            _local_10 = _local_10.next;
                            _local_11 = _local_11.next;
                        };
                        if (_local_8 != null)
                        {
                            if (_local_8.next != null)
                            {
                                drawConflictGeometry(_arg_3, _local_8);
                            } else
                            {
                                _local_8.draw(_arg_3, threshold, this);
                                _local_8.destroy();
                            };
                        };
                    } else
                    {
                        _local_10 = _arg_1.objectList;
                        if (_local_10.visible)
                        {
                            _local_10.copyAndAppend(_arg_1.objectBoundList, this);
                            _local_10.culling = _arg_2;
                            _local_10.concat(this);
                            _local_10.draw(_arg_3);
                        };
                    };
                } else
                {
                    if (_arg_4 != null)
                    {
                        if (_arg_4.next != null)
                        {
                            if (this.numOccluders > 0)
                            {
                                while (_arg_4 != null)
                                {
                                    _local_6 = _arg_4.next;
                                    if (((_arg_4.numOccluders < this.numOccluders) && (this.occludeGeometry(_arg_3, _arg_4))))
                                    {
                                        _arg_4.destroy();
                                    } else
                                    {
                                        _arg_4.next = _local_8;
                                        _local_8 = _arg_4;
                                    };
                                    _arg_4 = _local_6;
                                };
                                if (_local_8 != null)
                                {
                                    if (_local_8.next != null)
                                    {
                                        if (resolveByAABB)
                                        {
                                            drawAABBGeometry(_arg_3, _local_8);
                                        } else
                                        {
                                            if (resolveByOOBB)
                                            {
                                                _arg_4 = _local_8;
                                                while (_arg_4 != null)
                                                {
                                                    _arg_4.calculateOOBB(this);
                                                    _arg_4 = _arg_4.next;
                                                };
                                                drawOOBBGeometry(_arg_3, _local_8);
                                            } else
                                            {
                                                drawConflictGeometry(_arg_3, _local_8);
                                            };
                                        };
                                    } else
                                    {
                                        _local_8.draw(_arg_3, threshold, this);
                                        _local_8.destroy();
                                    };
                                };
                            } else
                            {
                                _local_8 = _arg_4;
                                if (resolveByAABB)
                                {
                                    drawAABBGeometry(_arg_3, _local_8);
                                } else
                                {
                                    if (resolveByOOBB)
                                    {
                                        _arg_4 = _local_8;
                                        while (_arg_4 != null)
                                        {
                                            _arg_4.calculateOOBB(this);
                                            _arg_4 = _arg_4.next;
                                        };
                                        drawOOBBGeometry(_arg_3, _local_8);
                                    } else
                                    {
                                        drawConflictGeometry(_arg_3, _local_8);
                                    };
                                };
                            };
                        } else
                        {
                            if (((_arg_4.numOccluders >= this.numOccluders) || (!(this.occludeGeometry(_arg_3, _arg_4)))))
                            {
                                _arg_4.draw(_arg_3, threshold, this);
                            };
                            _arg_4.destroy();
                        };
                    };
                };
                _local_10 = _arg_1.occluderList;
                _local_11 = _arg_1.occluderBoundList;
                while (_local_10 != null)
                {
                    if (((_local_10.visible) && ((((_local_10.culling = _arg_2) == 0) && (this.numOccluders == 0)) || ((_local_10.culling = this.cullingInContainer(_arg_2, _local_11.boundMinX, _local_11.boundMinY, _local_11.boundMinZ, _local_11.boundMaxX, _local_11.boundMaxY, _local_11.boundMaxZ)) >= 0))))
                    {
                        _local_10.copyAndAppend(_local_11, this);
                        _local_10.concat(this);
                        _local_10.draw(_arg_3);
                    };
                    _local_10 = _local_10.next;
                    _local_11 = _local_11.next;
                };
                if (_arg_1.occluderList != null)
                {
                    this.updateOccluders(_arg_3);
                };
            };
        }

        private function createObjectBounds(_arg_1:Object3D):Object3D
        {
            var _local_2:Object3D = new Object3D();
            _local_2.boundMinX = 1E22;
            _local_2.boundMinY = 1E22;
            _local_2.boundMinZ = 1E22;
            _local_2.boundMaxX = -1E22;
            _local_2.boundMaxY = -1E22;
            _local_2.boundMaxZ = -1E22;
            _arg_1.composeMatrix();
            _arg_1.updateBounds(_local_2, _arg_1);
            _local_2.ma = _arg_1.ma;
            _local_2.mb = _arg_1.mb;
            _local_2.mc = _arg_1.mc;
            _local_2.md = _arg_1.md;
            _local_2.me = _arg_1.me;
            _local_2.mf = _arg_1.mf;
            _local_2.mg = _arg_1.mg;
            _local_2.mh = _arg_1.mh;
            _local_2.mi = _arg_1.mi;
            _local_2.mj = _arg_1.mj;
            _local_2.mk = _arg_1.mk;
            _local_2.ml = _arg_1.ml;
            return (_local_2);
        }

        private function createNode(_arg_1:Object3D, _arg_2:Object3D, _arg_3:Object3D, _arg_4:Object3D, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number):KDNode
        {
            var _local_12:int;
            var _local_13:int;
            var _local_14:Object3D;
            var _local_15:Object3D;
            var _local_16:Number;
            var _local_21:Number;
            var _local_23:int;
            var _local_24:int;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Object3D;
            var _local_30:Object3D;
            var _local_31:Object3D;
            var _local_32:Object3D;
            var _local_33:Object3D;
            var _local_34:Object3D;
            var _local_35:Object3D;
            var _local_36:Object3D;
            var _local_37:Number;
            var _local_38:Number;
            var _local_39:Object3D;
            var _local_40:Object3D;
            var _local_41:Number;
            var _local_42:Number;
            var _local_43:Number;
            var _local_44:Number;
            var _local_45:Number;
            var _local_46:Number;
            var _local_47:Number;
            var _local_48:Number;
            var _local_49:Number;
            var _local_50:Number;
            var _local_51:Number;
            var _local_52:Number;
            var _local_11:KDNode = new KDNode();
            _local_11.boundMinX = _arg_5;
            _local_11.boundMinY = _arg_6;
            _local_11.boundMinZ = _arg_7;
            _local_11.boundMaxX = _arg_8;
            _local_11.boundMaxY = _arg_9;
            _local_11.boundMaxZ = _arg_10;
            if (_arg_1 == null)
            {
                if (_arg_3 != null)
                {
                };
                return (_local_11);
            };
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            _local_15 = _arg_2;
            while (_local_15 != null)
            {
                if (_local_15.boundMinX > (_arg_5 + threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_17)
                    {
                        if (((_local_15.boundMinX >= (splitCoordsX[_local_13] - threshold)) && (_local_15.boundMinX <= (splitCoordsX[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_17)
                    {
                        var _local_53:* = _local_17++;
                        splitCoordsX[_local_53] = _local_15.boundMinX;
                    };
                };
                if (_local_15.boundMaxX < (_arg_8 - threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_17)
                    {
                        if (((_local_15.boundMaxX >= (splitCoordsX[_local_13] - threshold)) && (_local_15.boundMaxX <= (splitCoordsX[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_17)
                    {
                        _local_53 = _local_17++;
                        splitCoordsX[_local_53] = _local_15.boundMaxX;
                    };
                };
                if (_local_15.boundMinY > (_arg_6 + threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_18)
                    {
                        if (((_local_15.boundMinY >= (splitCoordsY[_local_13] - threshold)) && (_local_15.boundMinY <= (splitCoordsY[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_18)
                    {
                        _local_53 = _local_18++;
                        splitCoordsY[_local_53] = _local_15.boundMinY;
                    };
                };
                if (_local_15.boundMaxY < (_arg_9 - threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_18)
                    {
                        if (((_local_15.boundMaxY >= (splitCoordsY[_local_13] - threshold)) && (_local_15.boundMaxY <= (splitCoordsY[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_18)
                    {
                        _local_53 = _local_18++;
                        splitCoordsY[_local_53] = _local_15.boundMaxY;
                    };
                };
                if (_local_15.boundMinZ > (_arg_7 + threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_19)
                    {
                        if (((_local_15.boundMinZ >= (splitCoordsZ[_local_13] - threshold)) && (_local_15.boundMinZ <= (splitCoordsZ[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_19)
                    {
                        _local_53 = _local_19++;
                        splitCoordsZ[_local_53] = _local_15.boundMinZ;
                    };
                };
                if (_local_15.boundMaxZ < (_arg_10 - threshold))
                {
                    _local_13 = 0;
                    while (_local_13 < _local_19)
                    {
                        if (((_local_15.boundMaxZ >= (splitCoordsZ[_local_13] - threshold)) && (_local_15.boundMaxZ <= (splitCoordsZ[_local_13] + threshold)))) break;
                        _local_13++;
                    };
                    if (_local_13 == _local_19)
                    {
                        _local_53 = _local_19++;
                        splitCoordsZ[_local_53] = _local_15.boundMaxZ;
                    };
                };
                _local_15 = _local_15.next;
            };
            var _local_20:int = -1;
            var _local_22:Number = 1E22;
            _local_25 = ((_arg_9 - _arg_6) * (_arg_10 - _arg_7));
            _local_12 = 0;
            while (_local_12 < _local_17)
            {
                _local_16 = splitCoordsX[_local_12];
                _local_26 = (_local_25 * (_local_16 - _arg_5));
                _local_27 = (_local_25 * (_arg_8 - _local_16));
                _local_23 = 0;
                _local_24 = 0;
                _local_15 = _arg_2;
                while (_local_15 != null)
                {
                    if (_local_15.boundMaxX <= (_local_16 + threshold))
                    {
                        if (_local_15.boundMinX < (_local_16 - threshold))
                        {
                            _local_23++;
                        };
                    } else
                    {
                        if (_local_15.boundMinX >= (_local_16 - threshold))
                        {
                            _local_24++;
                        } else
                        {
                            break;
                        };
                    };
                    _local_15 = _local_15.next;
                };
                if (_local_15 == null)
                {
                    _local_28 = ((_local_26 * _local_23) + (_local_27 * _local_24));
                    if (_local_28 < _local_22)
                    {
                        _local_22 = _local_28;
                        _local_20 = 0;
                        _local_21 = _local_16;
                    };
                };
                _local_12++;
            };
            _local_25 = ((_arg_8 - _arg_5) * (_arg_10 - _arg_7));
            _local_12 = 0;
            while (_local_12 < _local_18)
            {
                _local_16 = splitCoordsY[_local_12];
                _local_26 = (_local_25 * (_local_16 - _arg_6));
                _local_27 = (_local_25 * (_arg_9 - _local_16));
                _local_23 = 0;
                _local_24 = 0;
                _local_15 = _arg_2;
                while (_local_15 != null)
                {
                    if (_local_15.boundMaxY <= (_local_16 + threshold))
                    {
                        if (_local_15.boundMinY < (_local_16 - threshold))
                        {
                            _local_23++;
                        };
                    } else
                    {
                        if (_local_15.boundMinY >= (_local_16 - threshold))
                        {
                            _local_24++;
                        } else
                        {
                            break;
                        };
                    };
                    _local_15 = _local_15.next;
                };
                if (_local_15 == null)
                {
                    _local_28 = ((_local_26 * _local_23) + (_local_27 * _local_24));
                    if (_local_28 < _local_22)
                    {
                        _local_22 = _local_28;
                        _local_20 = 1;
                        _local_21 = _local_16;
                    };
                };
                _local_12++;
            };
            _local_25 = ((_arg_8 - _arg_5) * (_arg_9 - _arg_6));
            _local_12 = 0;
            while (_local_12 < _local_19)
            {
                _local_16 = splitCoordsZ[_local_12];
                _local_26 = (_local_25 * (_local_16 - _arg_7));
                _local_27 = (_local_25 * (_arg_10 - _local_16));
                _local_23 = 0;
                _local_24 = 0;
                _local_15 = _arg_2;
                while (_local_15 != null)
                {
                    if (_local_15.boundMaxZ <= (_local_16 + threshold))
                    {
                        if (_local_15.boundMinZ < (_local_16 - threshold))
                        {
                            _local_23++;
                        };
                    } else
                    {
                        if (_local_15.boundMinZ >= (_local_16 - threshold))
                        {
                            _local_24++;
                        } else
                        {
                            break;
                        };
                    };
                    _local_15 = _local_15.next;
                };
                if (_local_15 == null)
                {
                    _local_28 = ((_local_26 * _local_23) + (_local_27 * _local_24));
                    if (_local_28 < _local_22)
                    {
                        _local_22 = _local_28;
                        _local_20 = 2;
                        _local_21 = _local_16;
                    };
                };
                _local_12++;
            };
            if (_local_20 < 0)
            {
                _local_11.objectList = _arg_1;
                _local_11.objectBoundList = _arg_2;
                _local_11.occluderList = _arg_3;
                _local_11.occluderBoundList = _arg_4;
            } else
            {
                _local_11.axis = _local_20;
                _local_11.coord = _local_21;
                _local_11.minCoord = (_local_21 - threshold);
                _local_11.maxCoord = (_local_21 + threshold);
                _local_14 = _arg_1;
                _local_15 = _arg_2;
                while (_local_14 != null)
                {
                    _local_39 = _local_14.next;
                    _local_40 = _local_15.next;
                    _local_14.next = null;
                    _local_15.next = null;
                    _local_37 = ((_local_20 == 0) ? _local_15.boundMinX : ((_local_20 == 1) ? _local_15.boundMinY : _local_15.boundMinZ));
                    _local_38 = ((_local_20 == 0) ? _local_15.boundMaxX : ((_local_20 == 1) ? _local_15.boundMaxY : _local_15.boundMaxZ));
                    if (_local_38 <= (_local_21 + threshold))
                    {
                        if (_local_37 < (_local_21 - threshold))
                        {
                            _local_14.next = _local_29;
                            _local_29 = _local_14;
                            _local_15.next = _local_30;
                            _local_30 = _local_15;
                        } else
                        {
                            _local_14.next = _local_11.objectList;
                            _local_11.objectList = _local_14;
                            _local_15.next = _local_11.objectBoundList;
                            _local_11.objectBoundList = _local_15;
                        };
                    } else
                    {
                        if (_local_37 >= (_local_21 - threshold))
                        {
                            _local_14.next = _local_33;
                            _local_33 = _local_14;
                            _local_15.next = _local_34;
                            _local_34 = _local_15;
                        };
                    };
                    _local_14 = _local_39;
                    _local_15 = _local_40;
                };
                _local_14 = _arg_3;
                _local_15 = _arg_4;
                while (_local_14 != null)
                {
                    _local_39 = _local_14.next;
                    _local_40 = _local_15.next;
                    _local_14.next = null;
                    _local_15.next = null;
                    _local_37 = ((_local_20 == 0) ? _local_15.boundMinX : ((_local_20 == 1) ? _local_15.boundMinY : _local_15.boundMinZ));
                    _local_38 = ((_local_20 == 0) ? _local_15.boundMaxX : ((_local_20 == 1) ? _local_15.boundMaxY : _local_15.boundMaxZ));
                    if (_local_38 <= (_local_21 + threshold))
                    {
                        if (_local_37 < (_local_21 - threshold))
                        {
                            _local_14.next = _local_31;
                            _local_31 = _local_14;
                            _local_15.next = _local_32;
                            _local_32 = _local_15;
                        } else
                        {
                            _local_14.next = _local_11.occluderList;
                            _local_11.occluderList = _local_14;
                            _local_15.next = _local_11.occluderBoundList;
                            _local_11.occluderBoundList = _local_15;
                        };
                    } else
                    {
                        if (_local_37 >= (_local_21 - threshold))
                        {
                            _local_14.next = _local_35;
                            _local_35 = _local_14;
                            _local_15.next = _local_36;
                            _local_36 = _local_15;
                        };
                    };
                    _local_14 = _local_39;
                    _local_15 = _local_40;
                };
                _local_41 = _local_11.boundMinX;
                _local_42 = _local_11.boundMinY;
                _local_43 = _local_11.boundMinZ;
                _local_44 = _local_11.boundMaxX;
                _local_45 = _local_11.boundMaxY;
                _local_46 = _local_11.boundMaxZ;
                _local_47 = _local_11.boundMinX;
                _local_48 = _local_11.boundMinY;
                _local_49 = _local_11.boundMinZ;
                _local_50 = _local_11.boundMaxX;
                _local_51 = _local_11.boundMaxY;
                _local_52 = _local_11.boundMaxZ;
                if (_local_20 == 0)
                {
                    _local_44 = _local_21;
                    _local_47 = _local_21;
                } else
                {
                    if (_local_20 == 1)
                    {
                        _local_45 = _local_21;
                        _local_48 = _local_21;
                    } else
                    {
                        _local_46 = _local_21;
                        _local_49 = _local_21;
                    };
                };
                _local_11.negative = this.createNode(_local_29, _local_30, _local_31, _local_32, _local_41, _local_42, _local_43, _local_44, _local_45, _local_46);
                _local_11.positive = this.createNode(_local_33, _local_34, _local_35, _local_36, _local_47, _local_48, _local_49, _local_50, _local_51, _local_52);
            };
            return (_local_11);
        }

        private function destroyNode(_arg_1:KDNode):void
        {
            var _local_2:Object3D;
            var _local_3:Object3D;
            var _local_5:Receiver;
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
            _local_2 = _arg_1.objectList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.next;
                _local_2.setParent(null);
                _local_2.next = null;
                _local_2 = _local_3;
            };
            _local_2 = _arg_1.objectBoundList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.next;
                _local_2.next = null;
                _local_2 = _local_3;
            };
            _local_2 = _arg_1.occluderList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.next;
                _local_2.setParent(null);
                _local_2.next = null;
                _local_2 = _local_3;
            };
            _local_2 = _arg_1.occluderBoundList;
            while (_local_2 != null)
            {
                _local_3 = _local_2.next;
                _local_2.next = null;
                _local_2 = _local_3;
            };
            var _local_4:Receiver = _arg_1.receiverList;
            while (_local_4 != null)
            {
                _local_5 = _local_4.next;
                _local_4.next = null;
                _local_4 = _local_5;
            };
            _arg_1.objectList = null;
            _arg_1.objectBoundList = null;
            _arg_1.occluderList = null;
            _arg_1.occluderBoundList = null;
            _arg_1.receiverList = null;
        }

        private function calculateCameraPlanes(_arg_1:Number, _arg_2:Number):void
        {
            this.nearPlaneX = imc;
            this.nearPlaneY = img;
            this.nearPlaneZ = imk;
            this.nearPlaneOffset = (((((imc * _arg_1) + imd) * this.nearPlaneX) + (((img * _arg_1) + imh) * this.nearPlaneY)) + (((imk * _arg_1) + iml) * this.nearPlaneZ));
            this.farPlaneX = -(imc);
            this.farPlaneY = -(img);
            this.farPlaneZ = -(imk);
            this.farPlaneOffset = (((((imc * _arg_2) + imd) * this.farPlaneX) + (((img * _arg_2) + imh) * this.farPlaneY)) + (((imk * _arg_2) + iml) * this.farPlaneZ));
            var _local_3:Number = ((-(ima) - imb) + imc);
            var _local_4:Number = ((-(ime) - imf) + img);
            var _local_5:Number = ((-(imi) - imj) + imk);
            var _local_6:Number = ((ima - imb) + imc);
            var _local_7:Number = ((ime - imf) + img);
            var _local_8:Number = ((imi - imj) + imk);
            this.topPlaneX = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.topPlaneY = ((_local_6 * _local_5) - (_local_8 * _local_3));
            this.topPlaneZ = ((_local_7 * _local_3) - (_local_6 * _local_4));
            this.topPlaneOffset = (((imd * this.topPlaneX) + (imh * this.topPlaneY)) + (iml * this.topPlaneZ));
            _local_3 = _local_6;
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = ((ima + imb) + imc);
            _local_7 = ((ime + imf) + img);
            _local_8 = ((imi + imj) + imk);
            this.rightPlaneX = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.rightPlaneY = ((_local_6 * _local_5) - (_local_8 * _local_3));
            this.rightPlaneZ = ((_local_7 * _local_3) - (_local_6 * _local_4));
            this.rightPlaneOffset = (((imd * this.rightPlaneX) + (imh * this.rightPlaneY)) + (iml * this.rightPlaneZ));
            _local_3 = _local_6;
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = ((-(ima) + imb) + imc);
            _local_7 = ((-(ime) + imf) + img);
            _local_8 = ((-(imi) + imj) + imk);
            this.bottomPlaneX = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.bottomPlaneY = ((_local_6 * _local_5) - (_local_8 * _local_3));
            this.bottomPlaneZ = ((_local_7 * _local_3) - (_local_6 * _local_4));
            this.bottomPlaneOffset = (((imd * this.bottomPlaneX) + (imh * this.bottomPlaneY)) + (iml * this.bottomPlaneZ));
            _local_3 = _local_6;
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = ((-(ima) - imb) + imc);
            _local_7 = ((-(ime) - imf) + img);
            _local_8 = ((-(imi) - imj) + imk);
            this.leftPlaneX = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.leftPlaneY = ((_local_6 * _local_5) - (_local_8 * _local_3));
            this.leftPlaneZ = ((_local_7 * _local_3) - (_local_6 * _local_4));
            this.leftPlaneOffset = (((imd * this.leftPlaneX) + (imh * this.leftPlaneY)) + (iml * this.leftPlaneZ));
        }

        private function updateOccluders(_arg_1:Camera3D):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_2:int = this.numOccluders;
            while (_local_2 < _arg_1.numOccluders)
            {
                _local_3 = null;
                _local_4 = _arg_1.occluders[_local_2];
                while (_local_4 != null)
                {
                    _local_5 = _local_4.create();
                    _local_5.next = _local_3;
                    _local_3 = _local_5;
                    _local_6 = (((ima * _local_4.x) + (imb * _local_4.y)) + (imc * _local_4.z));
                    _local_7 = (((ime * _local_4.x) + (imf * _local_4.y)) + (img * _local_4.z));
                    _local_8 = (((imi * _local_4.x) + (imj * _local_4.y)) + (imk * _local_4.z));
                    _local_9 = (((ima * _local_4.u) + (imb * _local_4.v)) + (imc * _local_4.offset));
                    _local_10 = (((ime * _local_4.u) + (imf * _local_4.v)) + (img * _local_4.offset));
                    _local_11 = (((imi * _local_4.u) + (imj * _local_4.v)) + (imk * _local_4.offset));
                    _local_3.x = ((_local_11 * _local_7) - (_local_10 * _local_8));
                    _local_3.y = ((_local_9 * _local_8) - (_local_11 * _local_6));
                    _local_3.z = ((_local_10 * _local_6) - (_local_9 * _local_7));
                    _local_3.offset = (((imd * _local_3.x) + (imh * _local_3.y)) + (iml * _local_3.z));
                    _local_4 = _local_4.next;
                };
                this.occluders[this.numOccluders] = _local_3;
                this.numOccluders++;
                _local_2++;
            };
        }

        private function cullingInContainer(_arg_1:int, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number):int
        {
            var _local_9:Vertex;
            if (_arg_1 > 0)
            {
                if ((_arg_1 & 0x01))
                {
                    if (this.nearPlaneX >= 0)
                    {
                        if (this.nearPlaneY >= 0)
                        {
                            if (this.nearPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            };
                        } else
                        {
                            if (this.nearPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            };
                        };
                    } else
                    {
                        if (this.nearPlaneY >= 0)
                        {
                            if (this.nearPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            };
                        } else
                        {
                            if (this.nearPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.nearPlaneX) + (_arg_3 * this.nearPlaneY)) + (_arg_4 * this.nearPlaneZ)) <= this.nearPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.nearPlaneX) + (_arg_6 * this.nearPlaneY)) + (_arg_7 * this.nearPlaneZ)) > this.nearPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3E);
                                };
                            };
                        };
                    };
                };
                if ((_arg_1 & 0x02))
                {
                    if (this.farPlaneX >= 0)
                    {
                        if (this.farPlaneY >= 0)
                        {
                            if (this.farPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            };
                        } else
                        {
                            if (this.farPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            };
                        };
                    } else
                    {
                        if (this.farPlaneY >= 0)
                        {
                            if (this.farPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            };
                        } else
                        {
                            if (this.farPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.farPlaneX) + (_arg_3 * this.farPlaneY)) + (_arg_4 * this.farPlaneZ)) <= this.farPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.farPlaneX) + (_arg_6 * this.farPlaneY)) + (_arg_7 * this.farPlaneZ)) > this.farPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3D);
                                };
                            };
                        };
                    };
                };
                if ((_arg_1 & 0x04))
                {
                    if (this.leftPlaneX >= 0)
                    {
                        if (this.leftPlaneY >= 0)
                        {
                            if (this.leftPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            };
                        } else
                        {
                            if (this.leftPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            };
                        };
                    } else
                    {
                        if (this.leftPlaneY >= 0)
                        {
                            if (this.leftPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            };
                        } else
                        {
                            if (this.leftPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.leftPlaneX) + (_arg_3 * this.leftPlaneY)) + (_arg_4 * this.leftPlaneZ)) <= this.leftPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.leftPlaneX) + (_arg_6 * this.leftPlaneY)) + (_arg_7 * this.leftPlaneZ)) > this.leftPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x3B);
                                };
                            };
                        };
                    };
                };
                if ((_arg_1 & 0x08))
                {
                    if (this.rightPlaneX >= 0)
                    {
                        if (this.rightPlaneY >= 0)
                        {
                            if (this.rightPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            };
                        } else
                        {
                            if (this.rightPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            };
                        };
                    } else
                    {
                        if (this.rightPlaneY >= 0)
                        {
                            if (this.rightPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            };
                        } else
                        {
                            if (this.rightPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.rightPlaneX) + (_arg_3 * this.rightPlaneY)) + (_arg_4 * this.rightPlaneZ)) <= this.rightPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.rightPlaneX) + (_arg_6 * this.rightPlaneY)) + (_arg_7 * this.rightPlaneZ)) > this.rightPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x37);
                                };
                            };
                        };
                    };
                };
                if ((_arg_1 & 0x10))
                {
                    if (this.topPlaneX >= 0)
                    {
                        if (this.topPlaneY >= 0)
                        {
                            if (this.topPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            };
                        } else
                        {
                            if (this.topPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            };
                        };
                    } else
                    {
                        if (this.topPlaneY >= 0)
                        {
                            if (this.topPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            };
                        } else
                        {
                            if (this.topPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.topPlaneX) + (_arg_3 * this.topPlaneY)) + (_arg_4 * this.topPlaneZ)) <= this.topPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.topPlaneX) + (_arg_6 * this.topPlaneY)) + (_arg_7 * this.topPlaneZ)) > this.topPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x2F);
                                };
                            };
                        };
                    };
                };
                if ((_arg_1 & 0x20))
                {
                    if (this.bottomPlaneX >= 0)
                    {
                        if (this.bottomPlaneY >= 0)
                        {
                            if (this.bottomPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            };
                        } else
                        {
                            if (this.bottomPlaneZ >= 0)
                            {
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            } else
                            {
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            };
                        };
                    } else
                    {
                        if (this.bottomPlaneY >= 0)
                        {
                            if (this.bottomPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            };
                        } else
                        {
                            if (this.bottomPlaneZ >= 0)
                            {
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            } else
                            {
                                if ((((_arg_2 * this.bottomPlaneX) + (_arg_3 * this.bottomPlaneY)) + (_arg_4 * this.bottomPlaneZ)) <= this.bottomPlaneOffset)
                                {
                                    return (-1);
                                };
                                if ((((_arg_5 * this.bottomPlaneX) + (_arg_6 * this.bottomPlaneY)) + (_arg_7 * this.bottomPlaneZ)) > this.bottomPlaneOffset)
                                {
                                    _arg_1 = (_arg_1 & 0x1F);
                                };
                            };
                        };
                    };
                };
            };
            var _local_8:int;
            while (_local_8 < this.numOccluders)
            {
                _local_9 = this.occluders[_local_8];
                while (_local_9 != null)
                {
                    if (_local_9.x >= 0)
                    {
                        if (_local_9.y >= 0)
                        {
                            if (_local_9.z >= 0)
                            {
                                if ((((_arg_5 * _local_9.x) + (_arg_6 * _local_9.y)) + (_arg_7 * _local_9.z)) > _local_9.offset) break;
                            } else
                            {
                                if ((((_arg_5 * _local_9.x) + (_arg_6 * _local_9.y)) + (_arg_4 * _local_9.z)) > _local_9.offset) break;
                            };
                        } else
                        {
                            if (_local_9.z >= 0)
                            {
                                if ((((_arg_5 * _local_9.x) + (_arg_3 * _local_9.y)) + (_arg_7 * _local_9.z)) > _local_9.offset) break;
                            } else
                            {
                                if ((((_arg_5 * _local_9.x) + (_arg_3 * _local_9.y)) + (_arg_4 * _local_9.z)) > _local_9.offset) break;
                            };
                        };
                    } else
                    {
                        if (_local_9.y >= 0)
                        {
                            if (_local_9.z >= 0)
                            {
                                if ((((_arg_2 * _local_9.x) + (_arg_6 * _local_9.y)) + (_arg_7 * _local_9.z)) > _local_9.offset) break;
                            } else
                            {
                                if ((((_arg_2 * _local_9.x) + (_arg_6 * _local_9.y)) + (_arg_4 * _local_9.z)) > _local_9.offset) break;
                            };
                        } else
                        {
                            if (_local_9.z >= 0)
                            {
                                if ((((_arg_2 * _local_9.x) + (_arg_3 * _local_9.y)) + (_arg_7 * _local_9.z)) > _local_9.offset) break;
                            } else
                            {
                                if ((((_arg_2 * _local_9.x) + (_arg_3 * _local_9.y)) + (_arg_4 * _local_9.z)) > _local_9.offset) break;
                            };
                        };
                    };
                    _local_9 = _local_9.next;
                };
                if (_local_9 == null)
                {
                    return (-1);
                };
                _local_8++;
            };
            return (_arg_1);
        }

        private function occludeGeometry(_arg_1:Camera3D, _arg_2:VG):Boolean
        {
            var _local_4:Vertex;
            var _local_3:int = _arg_2.numOccluders;
            while (_local_3 < this.numOccluders)
            {
                _local_4 = this.occluders[_local_3];
                while (_local_4 != null)
                {
                    if (_local_4.x >= 0)
                    {
                        if (_local_4.y >= 0)
                        {
                            if (_local_4.z >= 0)
                            {
                                if ((((_arg_2.boundMaxX * _local_4.x) + (_arg_2.boundMaxY * _local_4.y)) + (_arg_2.boundMaxZ * _local_4.z)) > _local_4.offset) break;
                            } else
                            {
                                if ((((_arg_2.boundMaxX * _local_4.x) + (_arg_2.boundMaxY * _local_4.y)) + (_arg_2.boundMinZ * _local_4.z)) > _local_4.offset) break;
                            };
                        } else
                        {
                            if (_local_4.z >= 0)
                            {
                                if ((((_arg_2.boundMaxX * _local_4.x) + (_arg_2.boundMinY * _local_4.y)) + (_arg_2.boundMaxZ * _local_4.z)) > _local_4.offset) break;
                            } else
                            {
                                if ((((_arg_2.boundMaxX * _local_4.x) + (_arg_2.boundMinY * _local_4.y)) + (_arg_2.boundMinZ * _local_4.z)) > _local_4.offset) break;
                            };
                        };
                    } else
                    {
                        if (_local_4.y >= 0)
                        {
                            if (_local_4.z >= 0)
                            {
                                if ((((_arg_2.boundMinX * _local_4.x) + (_arg_2.boundMaxY * _local_4.y)) + (_arg_2.boundMaxZ * _local_4.z)) > _local_4.offset) break;
                            } else
                            {
                                if ((((_arg_2.boundMinX * _local_4.x) + (_arg_2.boundMaxY * _local_4.y)) + (_arg_2.boundMinZ * _local_4.z)) > _local_4.offset) break;
                            };
                        } else
                        {
                            if (_local_4.z >= 0)
                            {
                                if ((((_arg_2.boundMinX * _local_4.x) + (_arg_2.boundMinY * _local_4.y)) + (_arg_2.boundMaxZ * _local_4.z)) > _local_4.offset) break;
                            } else
                            {
                                if ((((_arg_2.boundMinX * _local_4.x) + (_arg_2.boundMinY * _local_4.y)) + (_arg_2.boundMinZ * _local_4.z)) > _local_4.offset) break;
                            };
                        };
                    };
                    _local_4 = _local_4.next;
                };
                if (_local_4 == null)
                {
                    return (true);
                };
                _local_3++;
            };
            _arg_2.numOccluders = this.numOccluders;
            return (false);
        }


    }
}//package alternativa.engine3d.containers

import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Vertex;
import __AS3__.vec.Vector;
import alternativa.engine3d.core.Face;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.core.Wrapper;
import alternativa.engine3d.objects.Mesh;
import alternativa.engine3d.objects.BSP;
import alternativa.engine3d.core.Shadow;
import alternativa.engine3d.objects.Decal;
import __AS3__.vec.*;
import alternativa.engine3d.alternativa3d; 

use namespace alternativa3d;

class KDNode 
{

    public var negative:KDNode;
    public var positive:KDNode;
    public var axis:int;
    public var coord:Number;
    public var minCoord:Number;
    public var maxCoord:Number;
    public var boundMinX:Number;
    public var boundMinY:Number;
    public var boundMinZ:Number;
    public var boundMaxX:Number;
    public var boundMaxY:Number;
    public var boundMaxZ:Number;
    public var objectList:Object3D;
    public var objectBoundList:Object3D;
    public var occluderList:Object3D;
    public var occluderBoundList:Object3D;
    public var receiverList:Receiver;


    public function createReceivers(_arg_1:Vector.<Vector.<Number>>, _arg_2:Vector.<Vector.<uint>>):void
    {
        var _local_3:Receiver;
        var _local_5:Receiver;
        var _local_6:Vertex;
        var _local_7:Vertex;
        var _local_8:Vector.<Face>;
        var _local_9:int;
        var _local_10:TextureMaterial;
        var _local_11:int;
        var _local_12:int;
        var _local_13:Vector.<Number>;
        var _local_14:Vector.<uint>;
        var _local_15:int;
        var _local_16:int;
        var _local_17:int;
        var _local_18:int;
        var _local_19:Face;
        var _local_20:Wrapper;
        var _local_21:uint;
        var _local_22:uint;
        var _local_23:uint;
        this.receiverList = null;
        var _local_4:Object3D = this.objectList;
        while (_local_4 != null)
        {
            _local_4.composeMatrix();
            _local_5 = new Receiver();
            if (_local_3 != null)
            {
                _local_3.next = _local_5;
            } else
            {
                this.receiverList = _local_5;
            };
            _local_3 = _local_5;
            if ((_local_4 is Mesh))
            {
                _local_7 = (_local_4 as Mesh).vertexList;
                _local_8 = (_local_4 as Mesh).faces;
            } else
            {
                if ((_local_4 is BSP))
                {
                    _local_7 = (_local_4 as BSP).vertexList;
                    _local_8 = (_local_4 as BSP).faces;
                };
            };
            _local_9 = _local_8.length;
            _local_10 = (_local_8[0].material as TextureMaterial);
            if (((_local_9 > 0) && (!(_local_10 == null))))
            {
                _local_11 = 0;
                _local_6 = _local_7;
                while (_local_6 != null)
                {
                    _local_11++;
                    _local_6 = _local_6.next;
                };
                _local_12 = (_arg_1.length - 1);
                _local_13 = _arg_1[_local_12];
                if (((_local_13.length / 3) + _local_11) > 0xFFFF)
                {
                    _local_12++;
                    _arg_1[_local_12] = new Vector.<Number>();
                    _arg_2[_local_12] = new Vector.<uint>();
                    _local_13 = _arg_1[_local_12];
                };
                _local_14 = _arg_2[_local_12];
                _local_15 = _local_13.length;
                _local_16 = int((_local_15 / 3));
                _local_17 = _local_14.length;
                _local_5.buffer = _local_12;
                _local_5.firstIndex = _local_17;
                _local_5.transparent = _local_10.transparent;
                _local_6 = _local_7;
                while (_local_6 != null)
                {
                    _local_13[_local_15] = ((((_local_6.x * _local_4.ma) + (_local_6.y * _local_4.mb)) + (_local_6.z * _local_4.mc)) + _local_4.md);
                    _local_15++;
                    _local_13[_local_15] = ((((_local_6.x * _local_4.me) + (_local_6.y * _local_4.mf)) + (_local_6.z * _local_4.mg)) + _local_4.mh);
                    _local_15++;
                    _local_13[_local_15] = ((((_local_6.x * _local_4.mi) + (_local_6.y * _local_4.mj)) + (_local_6.z * _local_4.mk)) + _local_4.ml);
                    _local_15++;
                    _local_6.index = _local_16;
                    _local_16++;
                    _local_6 = _local_6.next;
                };
                _local_18 = 0;
                while (_local_18 < _local_9)
                {
                    _local_19 = _local_8[_local_18];
                    if ((((_local_19.normalX * _local_4.mi) + (_local_19.normalY * _local_4.mj)) + (_local_19.normalZ * _local_4.mk)) >= -0.5)
                    {
                        _local_20 = _local_19.wrapper;
                        _local_21 = _local_20.vertex.index;
                        _local_20 = _local_20.next;
                        _local_22 = _local_20.vertex.index;
                        _local_20 = _local_20.next;
                        while (_local_20 != null)
                        {
                            _local_23 = _local_20.vertex.index;
                            _local_14[_local_17] = _local_21;
                            _local_17++;
                            _local_14[_local_17] = _local_22;
                            _local_17++;
                            _local_14[_local_17] = _local_23;
                            _local_17++;
                            _local_5.numTriangles++;
                            _local_22 = _local_23;
                            _local_20 = _local_20.next;
                        };
                    };
                    _local_18++;
                };
            };
            _local_4 = _local_4.next;
        };
        if (this.negative != null)
        {
            this.negative.createReceivers(_arg_1, _arg_2);
        };
        if (this.positive != null)
        {
            this.positive.createReceivers(_arg_1, _arg_2);
        };
    }

    public function collectReceivers(_arg_1:Shadow):void
    {
        var _local_2:Object3D;
        var _local_3:Object3D;
        var _local_4:Receiver;
        var _local_5:Boolean;
        var _local_6:Boolean;
        var _local_7:Number;
        var _local_8:Number;
        if (this.negative != null)
        {
            _local_5 = (this.axis == 0);
            _local_6 = (this.axis == 1);
            _local_7 = ((_local_5) ? _arg_1.boundMinX : ((_local_6) ? _arg_1.boundMinY : _arg_1.boundMinZ));
            _local_8 = ((_local_5) ? _arg_1.boundMaxX : ((_local_6) ? _arg_1.boundMaxY : _arg_1.boundMaxZ));
            if (_local_8 <= this.maxCoord)
            {
                this.negative.collectReceivers(_arg_1);
            } else
            {
                if (_local_7 >= this.minCoord)
                {
                    this.positive.collectReceivers(_arg_1);
                } else
                {
                    if (_local_5)
                    {
                        _local_3 = this.objectBoundList;
                        _local_2 = this.objectList;
                        _local_4 = this.receiverList;
                        while (_local_3 != null)
                        {
                            if ((((((_local_4.numTriangles > 0) && (_arg_1.boundMinY < _local_3.boundMaxY)) && (_arg_1.boundMaxY > _local_3.boundMinY)) && (_arg_1.boundMinZ < _local_3.boundMaxZ)) && (_arg_1.boundMaxZ > _local_3.boundMinZ)))
                            {
                                if ((!(_local_4.transparent)))
                                {
                                    _arg_1.receiversBuffers[_arg_1.receiversCount] = _local_4.buffer;
                                    _arg_1.receiversFirstIndexes[_arg_1.receiversCount] = _local_4.firstIndex;
                                    _arg_1.receiversNumsTriangles[_arg_1.receiversCount] = _local_4.numTriangles;
                                    _arg_1.receiversCount++;
                                };
                            };
                            _local_3 = _local_3.next;
                            _local_2 = _local_2.next;
                            _local_4 = _local_4.next;
                        };
                    } else
                    {
                        if (_local_6)
                        {
                            _local_3 = this.objectBoundList;
                            _local_2 = this.objectList;
                            _local_4 = this.receiverList;
                            while (_local_3 != null)
                            {
                                if ((((((_local_4.numTriangles > 0) && (_arg_1.boundMinX < _local_3.boundMaxX)) && (_arg_1.boundMaxX > _local_3.boundMinX)) && (_arg_1.boundMinZ < _local_3.boundMaxZ)) && (_arg_1.boundMaxZ > _local_3.boundMinZ)))
                                {
                                    if ((!(_local_4.transparent)))
                                    {
                                        _arg_1.receiversBuffers[_arg_1.receiversCount] = _local_4.buffer;
                                        _arg_1.receiversFirstIndexes[_arg_1.receiversCount] = _local_4.firstIndex;
                                        _arg_1.receiversNumsTriangles[_arg_1.receiversCount] = _local_4.numTriangles;
                                        _arg_1.receiversCount++;
                                    };
                                };
                                _local_3 = _local_3.next;
                                _local_2 = _local_2.next;
                                _local_4 = _local_4.next;
                            };
                        } else
                        {
                            _local_3 = this.objectBoundList;
                            _local_2 = this.objectList;
                            _local_4 = this.receiverList;
                            while (_local_3 != null)
                            {
                                if ((((((_local_4.numTriangles > 0) && (_arg_1.boundMinX < _local_3.boundMaxX)) && (_arg_1.boundMaxX > _local_3.boundMinX)) && (_arg_1.boundMinY < _local_3.boundMaxY)) && (_arg_1.boundMaxY > _local_3.boundMinY)))
                                {
                                    if ((!(_local_4.transparent)))
                                    {
                                        _arg_1.receiversBuffers[_arg_1.receiversCount] = _local_4.buffer;
                                        _arg_1.receiversFirstIndexes[_arg_1.receiversCount] = _local_4.firstIndex;
                                        _arg_1.receiversNumsTriangles[_arg_1.receiversCount] = _local_4.numTriangles;
                                        _arg_1.receiversCount++;
                                    };
                                };
                                _local_3 = _local_3.next;
                                _local_2 = _local_2.next;
                                _local_4 = _local_4.next;
                            };
                        };
                    };
                    this.negative.collectReceivers(_arg_1);
                    this.positive.collectReceivers(_arg_1);
                };
            };
        } else
        {
            _local_2 = this.objectList;
            _local_4 = this.receiverList;
            while (_local_4 != null)
            {
                if (_local_4.numTriangles > 0)
                {
                    if ((!(_local_4.transparent)))
                    {
                        _arg_1.receiversBuffers[_arg_1.receiversCount] = _local_4.buffer;
                        _arg_1.receiversFirstIndexes[_arg_1.receiversCount] = _local_4.firstIndex;
                        _arg_1.receiversNumsTriangles[_arg_1.receiversCount] = _local_4.numTriangles;
                        _arg_1.receiversCount++;
                    };
                };
                _local_2 = _local_2.next;
                _local_4 = _local_4.next;
            };
        };
    }

    public function collectPolygons(_arg_1:Decal, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number):void
    {
        var _local_10:Object3D;
        var _local_11:Object3D;
        var _local_12:Boolean;
        var _local_13:Boolean;
        var _local_14:Number;
        var _local_15:Number;
        if (this.negative != null)
        {
            _local_12 = (this.axis == 0);
            _local_13 = (this.axis == 1);
            _local_14 = ((_local_12) ? _arg_4 : ((_local_13) ? _arg_6 : _arg_8));
            _local_15 = ((_local_12) ? _arg_5 : ((_local_13) ? _arg_7 : _arg_9));
            if (_local_15 <= this.maxCoord)
            {
                this.negative.collectPolygons(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
            } else
            {
                if (_local_14 >= this.minCoord)
                {
                    this.positive.collectPolygons(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                } else
                {
                    _local_11 = this.objectBoundList;
                    _local_10 = this.objectList;
                    while (_local_11 != null)
                    {
                        if (_local_12)
                        {
                            if (((((_arg_6 < _local_11.boundMaxY) && (_arg_7 > _local_11.boundMinY)) && (_arg_8 < _local_11.boundMaxZ)) && (_arg_9 > _local_11.boundMinZ)))
                            {
                                this.clip(_arg_1, _arg_2, _arg_3, _local_10);
                            };
                        } else
                        {
                            if (_local_13)
                            {
                                if (((((_arg_4 < _local_11.boundMaxX) && (_arg_5 > _local_11.boundMinX)) && (_arg_8 < _local_11.boundMaxZ)) && (_arg_9 > _local_11.boundMinZ)))
                                {
                                    this.clip(_arg_1, _arg_2, _arg_3, _local_10);
                                };
                            } else
                            {
                                if (((((_arg_4 < _local_11.boundMaxX) && (_arg_5 > _local_11.boundMinX)) && (_arg_6 < _local_11.boundMaxY)) && (_arg_7 > _local_11.boundMinY)))
                                {
                                    this.clip(_arg_1, _arg_2, _arg_3, _local_10);
                                };
                            };
                        };
                        _local_11 = _local_11.next;
                        _local_10 = _local_10.next;
                    };
                    this.negative.collectPolygons(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                    this.positive.collectPolygons(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                };
            };
        } else
        {
            _local_10 = this.objectList;
            while (_local_10 != null)
            {
                this.clip(_arg_1, _arg_2, _arg_3, _local_10);
                _local_10 = _local_10.next;
            };
        };
    }

    private function clip(_arg_1:Decal, _arg_2:Number, _arg_3:Number, _arg_4:Object3D):void
    {
        var _local_5:Face;
        var _local_6:Vertex;
        var _local_7:Wrapper;
        var _local_8:Vertex;
        var _local_9:Vector.<Face>;
        var _local_10:int;
        var _local_11:int;
        var _local_12:Number;
        var _local_13:Number;
        var _local_14:Vertex;
        var _local_15:Vertex;
        var _local_16:Vertex;
        var _local_17:Vertex;
        var _local_18:Vertex;
        var _local_19:Vertex;
        var _local_20:Wrapper;
        if ((_arg_4 is Mesh))
        {
            _local_8 = Mesh(_arg_4).vertexList;
            _local_5 = Mesh(_arg_4).faceList;
            if (((_local_5.material == null) || (_local_5.material.transparent)))
            {
                return;
            };
            _local_9 = Mesh(_arg_4).faces;
        } else
        {
            if ((_arg_4 is BSP))
            {
                _local_8 = BSP(_arg_4).vertexList;
                _local_9 = BSP(_arg_4).faces;
                _local_5 = _local_9[0];
                if (((_local_5.material == null) || (_local_5.material.transparent)))
                {
                    return;
                };
            };
        };
        _arg_4.composeAndAppend(_arg_1);
        _arg_4.calculateInverseMatrix();
        _arg_4.transformId++;
        _local_10 = _local_9.length;
        _local_11 = 0;
        while (_local_11 < _local_10)
        {
            _local_5 = _local_9[_local_11];
            if ((((-(_local_5.normalX) * _arg_4.imc) - (_local_5.normalY * _arg_4.img)) - (_local_5.normalZ * _arg_4.imk)) >= _arg_3)
            {
                _local_12 = (((_local_5.normalX * _arg_4.imd) + (_local_5.normalY * _arg_4.imh)) + (_local_5.normalZ * _arg_4.iml));
                if (!((_local_12 <= (_local_5.offset - _arg_2)) || (_local_12 >= (_local_5.offset + _arg_2))))
                {
                    _local_7 = _local_5.wrapper;
                    while (_local_7 != null)
                    {
                        _local_6 = _local_7.vertex;
                        if (_local_6.transformId != _arg_4.transformId)
                        {
                            _local_6.cameraX = ((((_arg_4.ma * _local_6.x) + (_arg_4.mb * _local_6.y)) + (_arg_4.mc * _local_6.z)) + _arg_4.md);
                            _local_6.cameraY = ((((_arg_4.me * _local_6.x) + (_arg_4.mf * _local_6.y)) + (_arg_4.mg * _local_6.z)) + _arg_4.mh);
                            _local_6.cameraZ = ((((_arg_4.mi * _local_6.x) + (_arg_4.mj * _local_6.y)) + (_arg_4.mk * _local_6.z)) + _arg_4.ml);
                            _local_6.transformId = _arg_4.transformId;
                        };
                        _local_7 = _local_7.next;
                    };
                    _local_7 = _local_5.wrapper;
                    while (_local_7 != null)
                    {
                        if (_local_7.vertex.cameraX > _arg_1.boundMinX) break;
                        _local_7 = _local_7.next;
                    };
                    if (_local_7 != null)
                    {
                        _local_7 = _local_5.wrapper;
                        while (_local_7 != null)
                        {
                            if (_local_7.vertex.cameraX < _arg_1.boundMaxX) break;
                            _local_7 = _local_7.next;
                        };
                        if (_local_7 != null)
                        {
                            _local_7 = _local_5.wrapper;
                            while (_local_7 != null)
                            {
                                if (_local_7.vertex.cameraY > _arg_1.boundMinY) break;
                                _local_7 = _local_7.next;
                            };
                            if (_local_7 != null)
                            {
                                _local_7 = _local_5.wrapper;
                                while (_local_7 != null)
                                {
                                    if (_local_7.vertex.cameraY < _arg_1.boundMaxY) break;
                                    _local_7 = _local_7.next;
                                };
                                if (_local_7 != null)
                                {
                                    _local_7 = _local_5.wrapper;
                                    while (_local_7 != null)
                                    {
                                        if (_local_7.vertex.cameraZ > _arg_1.boundMinZ) break;
                                        _local_7 = _local_7.next;
                                    };
                                    if (_local_7 != null)
                                    {
                                        _local_7 = _local_5.wrapper;
                                        while (_local_7 != null)
                                        {
                                            if (_local_7.vertex.cameraZ < _arg_1.boundMaxZ) break;
                                            _local_7 = _local_7.next;
                                        };
                                        if (_local_7 != null)
                                        {
                                            _local_18 = null;
                                            _local_19 = null;
                                            _local_7 = _local_5.wrapper;
                                            while (_local_7 != null)
                                            {
                                                _local_6 = _local_7.vertex;
                                                _local_16 = new Vertex();
                                                _local_16.x = _local_6.cameraX;
                                                _local_16.y = _local_6.cameraY;
                                                _local_16.z = _local_6.cameraZ;
                                                _local_16.normalX = (((_arg_4.ma * _local_6.normalX) + (_arg_4.mb * _local_6.normalY)) + (_arg_4.mc * _local_6.normalZ));
                                                _local_16.normalY = (((_arg_4.me * _local_6.normalX) + (_arg_4.mf * _local_6.normalY)) + (_arg_4.mg * _local_6.normalZ));
                                                _local_16.normalZ = (((_arg_4.mi * _local_6.normalX) + (_arg_4.mj * _local_6.normalY)) + (_arg_4.mk * _local_6.normalZ));
                                                if (_local_19 != null)
                                                {
                                                    _local_19.next = _local_16;
                                                } else
                                                {
                                                    _local_18 = _local_16;
                                                };
                                                _local_19 = _local_16;
                                                _local_7 = _local_7.next;
                                            };
                                            _local_14 = _local_19;
                                            _local_15 = _local_18;
                                            _local_18 = null;
                                            _local_19 = null;
                                            while (_local_15 != null)
                                            {
                                                _local_17 = _local_15.next;
                                                _local_15.next = null;
                                                if ((((_local_15.z > _arg_1.boundMinZ) && (_local_14.z <= _arg_1.boundMinZ)) || ((_local_15.z <= _arg_1.boundMinZ) && (_local_14.z > _arg_1.boundMinZ))))
                                                {
                                                    _local_13 = ((_arg_1.boundMinZ - _local_14.z) / (_local_15.z - _local_14.z));
                                                    _local_16 = new Vertex();
                                                    _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                    _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                    _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                    _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                    _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                    _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                    if (_local_19 != null)
                                                    {
                                                        _local_19.next = _local_16;
                                                    } else
                                                    {
                                                        _local_18 = _local_16;
                                                    };
                                                    _local_19 = _local_16;
                                                };
                                                if (_local_15.z > _arg_1.boundMinZ)
                                                {
                                                    if (_local_19 != null)
                                                    {
                                                        _local_19.next = _local_15;
                                                    } else
                                                    {
                                                        _local_18 = _local_15;
                                                    };
                                                    _local_19 = _local_15;
                                                };
                                                _local_14 = _local_15;
                                                _local_15 = _local_17;
                                            };
                                            if (_local_18 != null)
                                            {
                                                _local_14 = _local_19;
                                                _local_15 = _local_18;
                                                _local_18 = null;
                                                _local_19 = null;
                                                while (_local_15 != null)
                                                {
                                                    _local_17 = _local_15.next;
                                                    _local_15.next = null;
                                                    if ((((_local_15.z < _arg_1.boundMaxZ) && (_local_14.z >= _arg_1.boundMaxZ)) || ((_local_15.z >= _arg_1.boundMaxZ) && (_local_14.z < _arg_1.boundMaxZ))))
                                                    {
                                                        _local_13 = ((_arg_1.boundMaxZ - _local_14.z) / (_local_15.z - _local_14.z));
                                                        _local_16 = new Vertex();
                                                        _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                        _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                        _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                        _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                        _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                        _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                        if (_local_19 != null)
                                                        {
                                                            _local_19.next = _local_16;
                                                        } else
                                                        {
                                                            _local_18 = _local_16;
                                                        };
                                                        _local_19 = _local_16;
                                                    };
                                                    if (_local_15.z < _arg_1.boundMaxZ)
                                                    {
                                                        if (_local_19 != null)
                                                        {
                                                            _local_19.next = _local_15;
                                                        } else
                                                        {
                                                            _local_18 = _local_15;
                                                        };
                                                        _local_19 = _local_15;
                                                    };
                                                    _local_14 = _local_15;
                                                    _local_15 = _local_17;
                                                };
                                                if (_local_18 != null)
                                                {
                                                    _local_14 = _local_19;
                                                    _local_15 = _local_18;
                                                    _local_18 = null;
                                                    _local_19 = null;
                                                    while (_local_15 != null)
                                                    {
                                                        _local_17 = _local_15.next;
                                                        _local_15.next = null;
                                                        if ((((_local_15.x > _arg_1.boundMinX) && (_local_14.x <= _arg_1.boundMinX)) || ((_local_15.x <= _arg_1.boundMinX) && (_local_14.x > _arg_1.boundMinX))))
                                                        {
                                                            _local_13 = ((_arg_1.boundMinX - _local_14.x) / (_local_15.x - _local_14.x));
                                                            _local_16 = new Vertex();
                                                            _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                            _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                            _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                            _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                            _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                            _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                            if (_local_19 != null)
                                                            {
                                                                _local_19.next = _local_16;
                                                            } else
                                                            {
                                                                _local_18 = _local_16;
                                                            };
                                                            _local_19 = _local_16;
                                                        };
                                                        if (_local_15.x > _arg_1.boundMinX)
                                                        {
                                                            if (_local_19 != null)
                                                            {
                                                                _local_19.next = _local_15;
                                                            } else
                                                            {
                                                                _local_18 = _local_15;
                                                            };
                                                            _local_19 = _local_15;
                                                        };
                                                        _local_14 = _local_15;
                                                        _local_15 = _local_17;
                                                    };
                                                    if (_local_18 != null)
                                                    {
                                                        _local_14 = _local_19;
                                                        _local_15 = _local_18;
                                                        _local_18 = null;
                                                        _local_19 = null;
                                                        while (_local_15 != null)
                                                        {
                                                            _local_17 = _local_15.next;
                                                            _local_15.next = null;
                                                            if ((((_local_15.x < _arg_1.boundMaxX) && (_local_14.x >= _arg_1.boundMaxX)) || ((_local_15.x >= _arg_1.boundMaxX) && (_local_14.x < _arg_1.boundMaxX))))
                                                            {
                                                                _local_13 = ((_arg_1.boundMaxX - _local_14.x) / (_local_15.x - _local_14.x));
                                                                _local_16 = new Vertex();
                                                                _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                                _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                                _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                                _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                                _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                                _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                                if (_local_19 != null)
                                                                {
                                                                    _local_19.next = _local_16;
                                                                } else
                                                                {
                                                                    _local_18 = _local_16;
                                                                };
                                                                _local_19 = _local_16;
                                                            };
                                                            if (_local_15.x < _arg_1.boundMaxX)
                                                            {
                                                                if (_local_19 != null)
                                                                {
                                                                    _local_19.next = _local_15;
                                                                } else
                                                                {
                                                                    _local_18 = _local_15;
                                                                };
                                                                _local_19 = _local_15;
                                                            };
                                                            _local_14 = _local_15;
                                                            _local_15 = _local_17;
                                                        };
                                                        if (_local_18 != null)
                                                        {
                                                            _local_14 = _local_19;
                                                            _local_15 = _local_18;
                                                            _local_18 = null;
                                                            _local_19 = null;
                                                            while (_local_15 != null)
                                                            {
                                                                _local_17 = _local_15.next;
                                                                _local_15.next = null;
                                                                if ((((_local_15.y > _arg_1.boundMinY) && (_local_14.y <= _arg_1.boundMinY)) || ((_local_15.y <= _arg_1.boundMinY) && (_local_14.y > _arg_1.boundMinY))))
                                                                {
                                                                    _local_13 = ((_arg_1.boundMinY - _local_14.y) / (_local_15.y - _local_14.y));
                                                                    _local_16 = new Vertex();
                                                                    _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                                    _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                                    _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                                    _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                                    _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                                    _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                                    if (_local_19 != null)
                                                                    {
                                                                        _local_19.next = _local_16;
                                                                    } else
                                                                    {
                                                                        _local_18 = _local_16;
                                                                    };
                                                                    _local_19 = _local_16;
                                                                };
                                                                if (_local_15.y > _arg_1.boundMinY)
                                                                {
                                                                    if (_local_19 != null)
                                                                    {
                                                                        _local_19.next = _local_15;
                                                                    } else
                                                                    {
                                                                        _local_18 = _local_15;
                                                                    };
                                                                    _local_19 = _local_15;
                                                                };
                                                                _local_14 = _local_15;
                                                                _local_15 = _local_17;
                                                            };
                                                            if (_local_18 != null)
                                                            {
                                                                _local_14 = _local_19;
                                                                _local_15 = _local_18;
                                                                _local_18 = null;
                                                                _local_19 = null;
                                                                while (_local_15 != null)
                                                                {
                                                                    _local_17 = _local_15.next;
                                                                    _local_15.next = null;
                                                                    if ((((_local_15.y < _arg_1.boundMaxY) && (_local_14.y >= _arg_1.boundMaxY)) || ((_local_15.y >= _arg_1.boundMaxY) && (_local_14.y < _arg_1.boundMaxY))))
                                                                    {
                                                                        _local_13 = ((_arg_1.boundMaxY - _local_14.y) / (_local_15.y - _local_14.y));
                                                                        _local_16 = new Vertex();
                                                                        _local_16.x = (_local_14.x + ((_local_15.x - _local_14.x) * _local_13));
                                                                        _local_16.y = (_local_14.y + ((_local_15.y - _local_14.y) * _local_13));
                                                                        _local_16.z = (_local_14.z + ((_local_15.z - _local_14.z) * _local_13));
                                                                        _local_16.normalX = (_local_14.normalX + ((_local_15.normalX - _local_14.normalX) * _local_13));
                                                                        _local_16.normalY = (_local_14.normalY + ((_local_15.normalY - _local_14.normalY) * _local_13));
                                                                        _local_16.normalZ = (_local_14.normalZ + ((_local_15.normalZ - _local_14.normalZ) * _local_13));
                                                                        if (_local_19 != null)
                                                                        {
                                                                            _local_19.next = _local_16;
                                                                        } else
                                                                        {
                                                                            _local_18 = _local_16;
                                                                        };
                                                                        _local_19 = _local_16;
                                                                    };
                                                                    if (_local_15.y < _arg_1.boundMaxY)
                                                                    {
                                                                        if (_local_19 != null)
                                                                        {
                                                                            _local_19.next = _local_15;
                                                                        } else
                                                                        {
                                                                            _local_18 = _local_15;
                                                                        };
                                                                        _local_19 = _local_15;
                                                                    };
                                                                    _local_14 = _local_15;
                                                                    _local_15 = _local_17;
                                                                };
                                                                if (_local_18 != null)
                                                                {
                                                                    _local_5 = new Face();
                                                                    _local_20 = null;
                                                                    _local_6 = _local_18;
                                                                    while (_local_6 != null)
                                                                    {
                                                                        _local_17 = _local_6.next;
                                                                        _local_6.next = _arg_1.vertexList;
                                                                        _arg_1.vertexList = _local_6;
                                                                        _local_6.u = ((_local_6.x - _arg_1.boundMinX) / (_arg_1.boundMaxX - _arg_1.boundMinX));
                                                                        _local_6.v = ((_local_6.y - _arg_1.boundMinY) / (_arg_1.boundMaxY - _arg_1.boundMinY));
                                                                        if (_local_20 != null)
                                                                        {
                                                                            _local_20.next = new Wrapper();
                                                                            _local_20 = _local_20.next;
                                                                        } else
                                                                        {
                                                                            _local_5.wrapper = new Wrapper();
                                                                            _local_20 = _local_5.wrapper;
                                                                        };
                                                                        _local_20.vertex = _local_6;
                                                                        _local_6 = _local_17;
                                                                    };
                                                                    _local_5.calculateBestSequenceAndNormal();
                                                                    _local_5.next = _arg_1.faceList;
                                                                    _arg_1.faceList = _local_5;
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _local_11++;
        };
    }


}

class Receiver 
{

    public var next:Receiver;
    public var transparent:Boolean = false;
    public var buffer:int = -1;
    public var firstIndex:int = -1;
    public var numTriangles:int = 0;


}
