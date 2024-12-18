package alternativa.engine3d.containers
{
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.objects.Mesh;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.RayIntersectionData;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.core.Debug;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class BSPContainer extends ConflictContainer 
    {

        private static const treeSphere:Vector3D = new Vector3D();

        public var clipping:int = 2;
        public var debugAlphaFade:Number = 0.8;
        alternativa3d var root:BSPNode;
        alternativa3d var vertexList:Vertex;
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
        private var directionX:Number;
        private var directionY:Number;
        private var directionZ:Number;
        private var viewAngle:Number;


        public function createTree(_arg_1:Vector.<Mesh>, _arg_2:Vector.<Mesh>=null, _arg_3:Boolean=false, _arg_4:Vector.<Object3D>=null):void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:Face;
            var _local_8:Face;
            var _local_9:Object3D;
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:Object3D;
            this.destroyTree();
            if (_arg_2 != null)
            {
                _local_6 = _arg_2.length;
                _local_5 = (_local_6 - 1);
                while (_local_5 >= 0)
                {
                    _local_7 = this.calculateFaceList(((_arg_3) ? _arg_2[_local_5] : Mesh(_arg_2[_local_5].clone())), false, _local_7);
                    _local_5--;
                };
            };
            _local_6 = _arg_1.length;
            _local_5 = (_local_6 - 1);
            while (_local_5 >= 0)
            {
                _local_8 = this.calculateFaceList(((_arg_3) ? _arg_1[_local_5] : Mesh(_arg_1[_local_5].clone())), true, _local_8);
                _local_5--;
            };
            if (_arg_4 != null)
            {
                _local_6 = _arg_4.length;
                _local_5 = 0;
                while (_local_5 < _local_6)
                {
                    _local_11 = _arg_4[_local_5];
                    _local_11 = _local_11.clone();
                    _local_11.setParent(this);
                    this.calculateObjectBounds(_local_11);
                    _local_12 = this.createObjectBounds(_local_11);
                    if (_local_12.boundMinX <= _local_12.boundMaxX)
                    {
                        _local_11.next = _local_9;
                        _local_9 = _local_11;
                        _local_12.next = _local_10;
                        _local_10 = _local_12;
                    };
                    _local_5++;
                };
            };
            if ((((!(_local_8 == null)) || (!(_local_9 == null))) || (!(_local_7 == null))))
            {
                this.root = this.createNode(_local_7, _local_8, _local_9, _local_10, new Vector.<Face>(3), new Vector.<Object3D>(4));
            };
        }

        public function destroyTree():void
        {
            if (this.root != null)
            {
                this.vertexList = null;
                this.destroyNode(this.root);
                this.root = null;
            };
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

        private function intersectRayNode(_arg_1:BSPNode, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Dictionary, _arg_5:Camera3D):RayIntersectionData
        {
            var _local_6:RayIntersectionData;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Face;
            var _local_17:Wrapper;
            var _local_18:Vertex;
            var _local_19:Vertex;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Vector3D;
            var _local_27:Vector3D;
            var _local_28:Number;
            var _local_29:RayIntersectionData;
            var _local_30:Object3D;
            if (_arg_1.objectList == null)
            {
                _local_7 = _arg_1.normalX;
                _local_8 = _arg_1.normalY;
                _local_9 = _arg_1.normalZ;
                _local_10 = ((((_local_7 * _arg_2.x) + (_local_8 * _arg_2.y)) + (_local_9 * _arg_2.z)) - _arg_1.offset);
                if (_local_10 > 0)
                {
                    if (((!(_arg_1.positive == null)) && (boundIntersectRay(_arg_2, _arg_3, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))))
                    {
                        _local_6 = this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5);
                        if (_local_6 != null)
                        {
                            return (_local_6);
                        };
                    };
                    _local_11 = (((_arg_3.x * _local_7) + (_arg_3.y * _local_8)) + (_arg_3.z * _local_9));
                    if (_local_11 < 0)
                    {
                        _local_12 = (-(_local_10) / _local_11);
                        _local_13 = (_arg_2.x + (_arg_3.x * _local_12));
                        _local_14 = (_arg_2.y + (_arg_3.y * _local_12));
                        _local_15 = (_arg_2.z + (_arg_3.z * _local_12));
                        _local_16 = _arg_1.faceList;
                        while (_local_16 != null)
                        {
                            _local_17 = _local_16.wrapper;
                            while (_local_17 != null)
                            {
                                _local_18 = _local_17.vertex;
                                _local_19 = ((_local_17.next != null) ? _local_17.next.vertex : _local_16.wrapper.vertex);
                                _local_20 = (_local_19.x - _local_18.x);
                                _local_21 = (_local_19.y - _local_18.y);
                                _local_22 = (_local_19.z - _local_18.z);
                                _local_23 = (_local_13 - _local_18.x);
                                _local_24 = (_local_14 - _local_18.y);
                                _local_25 = (_local_15 - _local_18.z);
                                if ((((((_local_25 * _local_21) - (_local_24 * _local_22)) * _local_7) + (((_local_23 * _local_22) - (_local_25 * _local_20)) * _local_8)) + (((_local_24 * _local_20) - (_local_23 * _local_21)) * _local_9)) < 0) break;
                                _local_17 = _local_17.next;
                            };
                            if (_local_17 == null)
                            {
                                _local_6 = new RayIntersectionData();
                                _local_6.object = this;
                                _local_6.face = _local_16;
                                _local_6.point = new Vector3D(_local_13, _local_14, _local_15);
                                _local_6.uv = _local_16.getUV(_local_6.point);
                                _local_6.time = _local_12;
                                return (_local_6);
                            };
                            _local_16 = _local_16.next;
                        };
                        if (((!(_arg_1.negative == null)) && (boundIntersectRay(_arg_2, _arg_3, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))))
                        {
                            return (this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5));
                        };
                    };
                } else
                {
                    if (((!(_arg_1.negative == null)) && (boundIntersectRay(_arg_2, _arg_3, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))))
                    {
                        _local_6 = this.intersectRayNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5);
                        if (_local_6 != null)
                        {
                            return (_local_6);
                        };
                    };
                    if ((((!(_arg_1.positive == null)) && ((((_arg_3.x * _local_7) + (_arg_3.y * _local_8)) + (_arg_3.z * _local_9)) > 0)) && (boundIntersectRay(_arg_2, _arg_3, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))))
                    {
                        return (this.intersectRayNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5));
                    };
                };
            } else
            {
                _local_28 = 1E22;
                _local_30 = _arg_1.objectList;
                while (_local_30 != null)
                {
                    _local_30.composeMatrix();
                    _local_30.invertMatrix();
                    if (_local_26 == null)
                    {
                        _local_26 = new Vector3D();
                        _local_27 = new Vector3D();
                    };
                    _local_26.x = ((((_local_30.ma * _arg_2.x) + (_local_30.mb * _arg_2.y)) + (_local_30.mc * _arg_2.z)) + _local_30.md);
                    _local_26.y = ((((_local_30.me * _arg_2.x) + (_local_30.mf * _arg_2.y)) + (_local_30.mg * _arg_2.z)) + _local_30.mh);
                    _local_26.z = ((((_local_30.mi * _arg_2.x) + (_local_30.mj * _arg_2.y)) + (_local_30.mk * _arg_2.z)) + _local_30.ml);
                    _local_27.x = (((_local_30.ma * _arg_3.x) + (_local_30.mb * _arg_3.y)) + (_local_30.mc * _arg_3.z));
                    _local_27.y = (((_local_30.me * _arg_3.x) + (_local_30.mf * _arg_3.y)) + (_local_30.mg * _arg_3.z));
                    _local_27.z = (((_local_30.mi * _arg_3.x) + (_local_30.mj * _arg_3.y)) + (_local_30.mk * _arg_3.z));
                    _local_6 = _local_30.intersectRay(_local_26, _local_27, _arg_4, _arg_5);
                    if (((!(_local_6 == null)) && (_local_6.time < _local_28)))
                    {
                        _local_28 = _local_6.time;
                        _local_29 = _local_6;
                    };
                    _local_30 = _local_30.next;
                };
                return (_local_29);
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

        private function checkIntersectionNode(_arg_1:BSPNode, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Dictionary):Boolean
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
            var _local_19:Face;
            var _local_20:Wrapper;
            var _local_21:Vertex;
            var _local_22:Vertex;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Object3D;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Number;
            var _local_34:Number;
            var _local_35:Number;
            if (_arg_1.objectList == null)
            {
                _local_11 = _arg_1.normalX;
                _local_12 = _arg_1.normalY;
                _local_13 = _arg_1.normalZ;
                _local_14 = ((((_local_11 * _arg_2) + (_local_12 * _arg_3)) + (_local_13 * _arg_4)) - _arg_1.offset);
                if (_local_14 > 0)
                {
                    _local_10 = (((_arg_5 * _local_11) + (_arg_6 * _local_12)) + (_arg_7 * _local_13));
                    if (_local_10 < 0)
                    {
                        _local_15 = (-(_local_14) / _local_10);
                        if (_local_15 < _arg_8)
                        {
                            _local_16 = (_arg_2 + (_arg_5 * _local_15));
                            _local_17 = (_arg_3 + (_arg_6 * _local_15));
                            _local_18 = (_arg_4 + (_arg_7 * _local_15));
                            _local_19 = _arg_1.faceList;
                            while (_local_19 != null)
                            {
                                _local_20 = _local_19.wrapper;
                                while (_local_20 != null)
                                {
                                    _local_21 = _local_20.vertex;
                                    _local_22 = ((_local_20.next != null) ? _local_20.next.vertex : _local_19.wrapper.vertex);
                                    _local_23 = (_local_22.x - _local_21.x);
                                    _local_24 = (_local_22.y - _local_21.y);
                                    _local_25 = (_local_22.z - _local_21.z);
                                    _local_26 = (_local_16 - _local_21.x);
                                    _local_27 = (_local_17 - _local_21.y);
                                    _local_28 = (_local_18 - _local_21.z);
                                    if ((((((_local_28 * _local_24) - (_local_27 * _local_25)) * _local_11) + (((_local_26 * _local_25) - (_local_28 * _local_23)) * _local_12)) + (((_local_27 * _local_23) - (_local_26 * _local_24)) * _local_13)) < 0) break;
                                    _local_20 = _local_20.next;
                                };
                                if (_local_20 == null)
                                {
                                    return (true);
                                };
                                _local_19 = _local_19.next;
                            };
                            if ((((!(_arg_1.negative == null)) && (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9))))
                            {
                                return (true);
                            };
                        };
                    };
                    return (((!(_arg_1.positive == null)) && (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9)));
                };
                if ((((!(_arg_1.negative == null)) && (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))) && (this.checkIntersectionNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9))))
                {
                    return (true);
                };
                if (_arg_1.positive != null)
                {
                    _local_10 = (((_arg_5 * _local_11) + (_arg_6 * _local_12)) + (_arg_7 * _local_13));
                    return ((((_local_10 > 0) && ((-(_local_14) / _local_10) < _arg_8)) && (boundCheckIntersection(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))) && (this.checkIntersectionNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9)));
                };
            } else
            {
                _local_29 = _arg_1.objectList;
                while (_local_29 != null)
                {
                    _local_29.composeMatrix();
                    _local_29.invertMatrix();
                    _local_30 = ((((_local_29.ma * _arg_2) + (_local_29.mb * _arg_3)) + (_local_29.mc * _arg_4)) + _local_29.md);
                    _local_31 = ((((_local_29.me * _arg_2) + (_local_29.mf * _arg_3)) + (_local_29.mg * _arg_4)) + _local_29.mh);
                    _local_32 = ((((_local_29.mi * _arg_2) + (_local_29.mj * _arg_3)) + (_local_29.mk * _arg_4)) + _local_29.ml);
                    _local_33 = (((_local_29.ma * _arg_5) + (_local_29.mb * _arg_6)) + (_local_29.mc * _arg_7));
                    _local_34 = (((_local_29.me * _arg_5) + (_local_29.mf * _arg_6)) + (_local_29.mg * _arg_7));
                    _local_35 = (((_local_29.mi * _arg_5) + (_local_29.mj * _arg_6)) + (_local_29.mk * _arg_7));
                    if (_local_29.checkIntersection(_local_30, _local_31, _local_32, _local_33, _local_34, _local_35, _arg_8, _arg_9))
                    {
                        return (true);
                    };
                    _local_29 = _local_29.next;
                };
            };
            return (false);
        }

        override alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
            var _local_10:Vertex;
            if (((!(_arg_7 == null)) && (_arg_7[this])))
            {
                return;
            };
            var _local_8:Vector3D = calculateSphere(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, treeSphere);
            if ((!(boundIntersectSphere(_local_8, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return;
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_10 = this.vertexList;
                while (_local_10 != null)
                {
                    _local_10.transformId = 0;
                    _local_10 = _local_10.next;
                };
            };
            transformId++;
            var _local_9:Object3D = childrenList;
            while (_local_9 != null)
            {
                _local_9.composeAndAppend(this);
                _local_9.collectPlanes(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                _local_9 = _local_9.next;
            };
            if (((!(this.root == null)) && (boundIntersectSphere(_local_8, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ))))
            {
                this.collectPlanesNode(this.root, _local_8, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        private function collectPlanesNode(_arg_1:BSPNode, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector3D, _arg_7:Vector3D, _arg_8:Vector.<Face>, _arg_9:Dictionary=null):void
        {
            var _local_10:Number;
            var _local_11:Face;
            var _local_12:Wrapper;
            var _local_13:Vertex;
            var _local_14:Object3D;
            if (_arg_1.objectList == null)
            {
                _local_10 = ((((_arg_1.normalX * _arg_2.x) + (_arg_1.normalY * _arg_2.y)) + (_arg_1.normalZ * _arg_2.z)) - _arg_1.offset);
                if (_local_10 >= _arg_2.w)
                {
                    if (((!(_arg_1.positive == null)) && (boundIntersectSphere(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))))
                    {
                        this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                    };
                } else
                {
                    if (_local_10 <= -(_arg_2.w))
                    {
                        if (((!(_arg_1.negative == null)) && (boundIntersectSphere(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))))
                        {
                            this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                    } else
                    {
                        _local_11 = _arg_1.faceList;
                        while (_local_11 != null)
                        {
                            _local_12 = _local_11.wrapper;
                            while (_local_12 != null)
                            {
                                _local_13 = _local_12.vertex;
                                if (_local_13.transformId != transformId)
                                {
                                    _local_13.cameraX = ((((ma * _local_13.x) + (mb * _local_13.y)) + (mc * _local_13.z)) + md);
                                    _local_13.cameraY = ((((me * _local_13.x) + (mf * _local_13.y)) + (mg * _local_13.z)) + mh);
                                    _local_13.cameraZ = ((((mi * _local_13.x) + (mj * _local_13.y)) + (mk * _local_13.z)) + ml);
                                    _local_13.transformId = transformId;
                                };
                                _local_12 = _local_12.next;
                            };
                            _arg_8.push(_local_11);
                            _local_11 = _local_11.next;
                        };
                        if (((!(_arg_1.positive == null)) && (boundIntersectSphere(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ))))
                        {
                            this.collectPlanesNode(_arg_1.positive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                        if (((!(_arg_1.negative == null)) && (boundIntersectSphere(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ))))
                        {
                            this.collectPlanesNode(_arg_1.negative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                        };
                    };
                };
            } else
            {
                _local_14 = _arg_1.objectList;
                while (_local_14 != null)
                {
                    _local_14.composeAndAppend(this);
                    _local_14.collectPlanes(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                    _local_14 = _local_14.next;
                };
            };
        }

        override public function clone():Object3D
        {
            var _local_1:BSPContainer = new BSPContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Vertex;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:BSPContainer = (_arg_1 as BSPContainer);
            this.clipping = _local_2.clipping;
            this.debugAlphaFade = _local_2.debugAlphaFade;
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_5 = new Vertex();
                _local_5.x = _local_3.x;
                _local_5.y = _local_3.y;
                _local_5.z = _local_3.z;
                _local_5.u = _local_3.u;
                _local_5.v = _local_3.v;
                _local_5.normalX = _local_3.normalX;
                _local_5.normalY = _local_3.normalY;
                _local_5.normalZ = _local_3.normalZ;
                _local_3.value = _local_5;
                if (_local_4 != null)
                {
                    _local_4.next = _local_5;
                } else
                {
                    this.vertexList = _local_5;
                };
                _local_4 = _local_5;
                _local_3 = _local_3.next;
            };
            if (_local_2.root != null)
            {
                this.root = _local_2.cloneNode(_local_2.root, this);
            };
            _local_3 = _local_2.vertexList;
            while (_local_3 != null)
            {
                _local_3.value = null;
                _local_3 = _local_3.next;
            };
        }

        private function cloneNode(_arg_1:BSPNode, _arg_2:Object3DContainer):BSPNode
        {
            var _local_4:Face;
            var _local_6:Object3D;
            var _local_7:Object3D;
            var _local_8:Object3D;
            var _local_9:Face;
            var _local_10:Wrapper;
            var _local_11:Wrapper;
            var _local_12:Wrapper;
            var _local_3:BSPNode = new BSPNode();
            _local_3.normalX = _arg_1.normalX;
            _local_3.normalY = _arg_1.normalY;
            _local_3.normalZ = _arg_1.normalZ;
            _local_3.offset = _arg_1.offset;
            _local_3.boundMinX = _arg_1.boundMinX;
            _local_3.boundMinY = _arg_1.boundMinY;
            _local_3.boundMinZ = _arg_1.boundMinZ;
            _local_3.boundMaxX = _arg_1.boundMaxX;
            _local_3.boundMaxY = _arg_1.boundMaxY;
            _local_3.boundMaxZ = _arg_1.boundMaxZ;
            var _local_5:Face = _arg_1.faceList;
            while (_local_5 != null)
            {
                _local_9 = new Face();
                _local_9.material = _local_5.material;
                _local_9.normalX = _local_5.normalX;
                _local_9.normalY = _local_5.normalY;
                _local_9.normalZ = _local_5.normalZ;
                _local_9.offset = _local_5.offset;
                _local_10 = null;
                _local_11 = _local_5.wrapper;
                while (_local_11 != null)
                {
                    _local_12 = new Wrapper();
                    _local_12.vertex = _local_11.vertex.value;
                    if (_local_10 != null)
                    {
                        _local_10.next = _local_12;
                    } else
                    {
                        _local_9.wrapper = _local_12;
                    };
                    _local_10 = _local_12;
                    _local_11 = _local_11.next;
                };
                if (_local_3.faceList != null)
                {
                    _local_4.next = _local_9;
                } else
                {
                    _local_3.faceList = _local_9;
                };
                _local_4 = _local_9;
                _local_5 = _local_5.next;
            };
            _local_6 = _arg_1.objectList;
            _local_7 = null;
            while (_local_6 != null)
            {
                _local_8 = _local_6.clone();
                if (_local_3.objectList != null)
                {
                    _local_7.next = _local_8;
                } else
                {
                    _local_3.objectList = _local_8;
                };
                _local_7 = _local_8;
                _local_8.setParent(_arg_2);
                _local_6 = _local_6.next;
            };
            _local_6 = _arg_1.boundList;
            _local_7 = null;
            while (_local_6 != null)
            {
                _local_8 = _local_6.clone();
                if (_local_3.boundList != null)
                {
                    _local_7.next = _local_8;
                } else
                {
                    _local_3.boundList = _local_8;
                };
                _local_7 = _local_8;
                _local_6 = _local_6.next;
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
            var _local_3:int;
            var _local_4:Vertex;
            var _local_5:VG;
            var _local_6:VG;
            var _local_7:Face;
            if (this.root != null)
            {
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
                this.calculateCameraPlanes(_arg_1.nearClipping, _arg_1.farClipping);
                _local_3 = this.cullingInContainer(culling, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ);
                if (_local_3 >= 0)
                {
                    if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                    {
                        if ((_local_2 & Debug.NODES))
                        {
                            this.debugNode(this.root, _local_3, _arg_1, 1);
                        };
                        if ((_local_2 & Debug.BOUNDS))
                        {
                            Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                        };
                    };
                    _local_5 = super.getVG(_arg_1);
                    _local_6 = _local_5;
                    while (_local_6 != null)
                    {
                        _local_6.calculateAABB(ima, imb, imc, imd, ime, imf, img, imh, imi, imj, imk, iml);
                        _local_6 = _local_6.next;
                    };
                    _local_7 = this.drawNode(this.root, _local_3, _arg_1, _local_5);
                    if (_local_7 != null)
                    {
                        this.drawFaces(_arg_1, _local_7);
                    };
                } else
                {
                    super.draw(_arg_1);
                };
            } else
            {
                super.draw(_arg_1);
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_3:int;
            var _local_4:Vertex;
            var _local_2:VG = super.getVG(_arg_1);
            if (this.root != null)
            {
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
                this.calculateCameraPlanes(_arg_1.nearClipping, _arg_1.farClipping);
                _local_3 = this.cullingInContainer(culling, this.root.boundMinX, this.root.boundMinY, this.root.boundMinZ, this.root.boundMaxX, this.root.boundMaxY, this.root.boundMaxZ);
                if (_local_3 >= 0)
                {
                    _local_2 = this.collectVGNode(this.root, _local_3, _arg_1, _local_2);
                };
            };
            return (_local_2);
        }

        private function collectVGNode(_arg_1:BSPNode, _arg_2:int, _arg_3:Camera3D, _arg_4:VG=null):VG
        {
            var _local_5:VG;
            var _local_6:VG;
            var _local_9:VG;
            var _local_10:int;
            var _local_11:int;
            var _local_7:Object3D = _arg_1.objectList;
            var _local_8:Object3D = _arg_1.boundList;
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
                if (_local_10 >= 0)
                {
                    _arg_4 = this.collectVGNode(_arg_1.negative, _local_10, _arg_3, _arg_4);
                };
            };
            if (_arg_1.positive != null)
            {
                _local_11 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                if (_local_11 >= 0)
                {
                    _arg_4 = this.collectVGNode(_arg_1.positive, _local_11, _arg_3, _arg_4);
                };
            };
            return (_arg_4);
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            super.updateBounds(_arg_1, _arg_2);
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
            if (this.root != null)
            {
                this.updateBoundsNode(this.root, _arg_1, _arg_2);
            };
        }

        private function updateBoundsNode(_arg_1:BSPNode, _arg_2:Object3D, _arg_3:Object3D):void
        {
            var _local_4:Object3D;
            if (_arg_1.objectList == null)
            {
                if (_arg_1.negative != null)
                {
                    this.updateBoundsNode(_arg_1.negative, _arg_2, _arg_3);
                };
                if (_arg_1.positive != null)
                {
                    this.updateBoundsNode(_arg_1.positive, _arg_2, _arg_3);
                };
            } else
            {
                _local_4 = _arg_1.objectList;
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
            };
        }

        private function debugNode(_arg_1:BSPNode, _arg_2:int, _arg_3:Camera3D, _arg_4:Number):void
        {
            var _local_5:int;
            var _local_6:int;
            if (_arg_1 != null)
            {
                _local_5 = -1;
                _local_6 = -1;
                if (_arg_1.negative != null)
                {
                    _local_5 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                };
                if (_arg_1.positive != null)
                {
                    _local_6 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                };
                if (_local_5 >= 0)
                {
                    this.debugNode(_arg_1.negative, _local_5, _arg_3, (_arg_4 * this.debugAlphaFade));
                };
                Debug.drawBounds(_arg_3, this, _arg_1.boundMinX, _arg_1.boundMinY, _arg_1.boundMinZ, _arg_1.boundMaxX, _arg_1.boundMaxY, _arg_1.boundMaxZ, 14496733, _arg_4);
                if (_local_6 >= 0)
                {
                    this.debugNode(_arg_1.positive, _local_6, _arg_3, (_arg_4 * this.debugAlphaFade));
                };
            };
        }

        private function drawNode(_arg_1:BSPNode, _arg_2:int, _arg_3:Camera3D, _arg_4:VG, _arg_5:Face=null):Face
        {
            var _local_6:VG;
            var _local_7:VG;
            var _local_8:VG;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Face;
            var _local_17:Face;
            var _local_18:Wrapper;
            var _local_19:Vertex;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Object3D;
            var _local_24:Object3D;
            var _local_25:VG;
            if (_arg_1.objectList == null)
            {
                _local_10 = -1;
                _local_11 = -1;
                _local_12 = _arg_1.normalX;
                _local_13 = _arg_1.normalY;
                _local_14 = _arg_1.normalZ;
                _local_15 = _arg_1.offset;
                if ((((imd * _local_12) + (imh * _local_13)) + (iml * _local_14)) > _local_15)
                {
                    if ((((this.directionX * _local_12) + (this.directionY * _local_13)) + (this.directionZ * _local_14)) < this.viewAngle)
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            _local_9 = this.checkBounds(_local_12, _local_13, _local_14, _local_15, _arg_4.boundMinX, _arg_4.boundMinY, _arg_4.boundMinZ, _arg_4.boundMaxX, _arg_4.boundMaxY, _arg_4.boundMaxZ, true);
                            if (_local_9 < 0)
                            {
                                _arg_4.next = _local_7;
                                _local_7 = _arg_4;
                            } else
                            {
                                if (_local_9 > 0)
                                {
                                    _arg_4.next = _local_8;
                                    _local_8 = _arg_4;
                                } else
                                {
                                    _arg_4.split(_arg_3, _local_12, _local_13, _local_14, _local_15, threshold);
                                    if (_arg_4.next != null)
                                    {
                                        _arg_4.next.next = _local_7;
                                        _local_7 = _arg_4.next;
                                    };
                                    if (_arg_4.faceStruct != null)
                                    {
                                        _arg_4.next = _local_8;
                                        _local_8 = _arg_4;
                                    } else
                                    {
                                        _arg_4.destroy();
                                    };
                                };
                            };
                            _arg_4 = _local_6;
                        };
                        if (_arg_1.positive != null)
                        {
                            _local_11 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                        };
                        if (_local_11 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.positive, _local_11, _arg_3, _local_8, _arg_5);
                        } else
                        {
                            if (_local_8 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
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
                        };
                        _local_17 = _arg_1.faceList;
                        while (_local_17 != null)
                        {
                            _local_18 = _local_17.wrapper;
                            while (_local_18 != null)
                            {
                                _local_19 = _local_18.vertex;
                                if (_local_19.transformId != transformId)
                                {
                                    _local_20 = _local_19.x;
                                    _local_21 = _local_19.y;
                                    _local_22 = _local_19.z;
                                    _local_19.cameraX = ((((ma * _local_20) + (mb * _local_21)) + (mc * _local_22)) + md);
                                    _local_19.cameraY = ((((me * _local_20) + (mf * _local_21)) + (mg * _local_22)) + mh);
                                    _local_19.cameraZ = ((((mi * _local_20) + (mj * _local_21)) + (mk * _local_22)) + ml);
                                    _local_19.transformId = transformId;
                                    _local_19.drawId = 0;
                                };
                                _local_18 = _local_18.next;
                            };
                            _local_17.processNext = _local_16;
                            _local_16 = _local_17;
                            _local_17 = _local_17.next;
                        };
                        if (_local_16 != null)
                        {
                            if (_arg_2 > 0)
                            {
                                if (this.clipping == 2)
                                {
                                    _local_16 = _arg_3.clip(_local_16, _arg_2);
                                } else
                                {
                                    _local_16 = _arg_3.cull(_local_16, _arg_2);
                                };
                                if (_local_16 != null)
                                {
                                    _local_17 = _local_16;
                                    while (_local_17.processNext != null)
                                    {
                                        _local_17 = _local_17.processNext;
                                    };
                                    _local_17.processNext = _arg_5;
                                    _arg_5 = _local_16;
                                };
                            } else
                            {
                                _local_17 = _local_16;
                                while (_local_17.processNext != null)
                                {
                                    _local_17 = _local_17.processNext;
                                };
                                _local_17.processNext = _arg_5;
                                _arg_5 = _local_16;
                            };
                        };
                        if (_arg_1.negative != null)
                        {
                            _local_10 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                        };
                        if (_local_10 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.negative, _local_10, _arg_3, _local_7, _arg_5);
                        } else
                        {
                            if (_local_7 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
                                if (_local_7.next != null)
                                {
                                    if (resolveByAABB)
                                    {
                                        drawAABBGeometry(_arg_3, _local_7);
                                    } else
                                    {
                                        if (resolveByOOBB)
                                        {
                                            _arg_4 = _local_7;
                                            while (_arg_4 != null)
                                            {
                                                _arg_4.calculateOOBB(this);
                                                _arg_4 = _arg_4.next;
                                            };
                                            drawOOBBGeometry(_arg_3, _local_7);
                                        } else
                                        {
                                            drawConflictGeometry(_arg_3, _local_7);
                                        };
                                    };
                                } else
                                {
                                    _local_7.draw(_arg_3, threshold, this);
                                    _local_7.destroy();
                                };
                            };
                        };
                    } else
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            _local_9 = this.checkBounds(_local_12, _local_13, _local_14, _local_15, _arg_4.boundMinX, _arg_4.boundMinY, _arg_4.boundMinZ, _arg_4.boundMaxX, _arg_4.boundMaxY, _arg_4.boundMaxZ, true);
                            if (_local_9 < 0)
                            {
                                _arg_4.destroy();
                            } else
                            {
                                if (_local_9 > 0)
                                {
                                    _arg_4.next = _local_8;
                                    _local_8 = _arg_4;
                                } else
                                {
                                    _arg_4.crop(_arg_3, _local_12, _local_13, _local_14, _local_15, threshold);
                                    if (_arg_4.faceStruct != null)
                                    {
                                        _arg_4.next = _local_8;
                                        _local_8 = _arg_4;
                                    } else
                                    {
                                        _arg_4.destroy();
                                    };
                                };
                            };
                            _arg_4 = _local_6;
                        };
                        if (_arg_1.positive != null)
                        {
                            _local_11 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                        };
                        if (_local_11 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.positive, _local_11, _arg_3, _local_8, _arg_5);
                        } else
                        {
                            if (_local_8 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
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
                        };
                    };
                } else
                {
                    if ((((this.directionX * _local_12) + (this.directionY * _local_13)) + (this.directionZ * _local_14)) > -(this.viewAngle))
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            _local_9 = this.checkBounds(_local_12, _local_13, _local_14, _local_15, _arg_4.boundMinX, _arg_4.boundMinY, _arg_4.boundMinZ, _arg_4.boundMaxX, _arg_4.boundMaxY, _arg_4.boundMaxZ, false);
                            if (_local_9 < 0)
                            {
                                _arg_4.next = _local_7;
                                _local_7 = _arg_4;
                            } else
                            {
                                if (_local_9 > 0)
                                {
                                    _arg_4.next = _local_8;
                                    _local_8 = _arg_4;
                                } else
                                {
                                    _arg_4.split(_arg_3, _local_12, _local_13, _local_14, _local_15, threshold);
                                    if (_arg_4.next != null)
                                    {
                                        _arg_4.next.next = _local_7;
                                        _local_7 = _arg_4.next;
                                    };
                                    if (_arg_4.faceStruct != null)
                                    {
                                        _arg_4.next = _local_8;
                                        _local_8 = _arg_4;
                                    } else
                                    {
                                        _arg_4.destroy();
                                    };
                                };
                            };
                            _arg_4 = _local_6;
                        };
                        if (_arg_1.negative != null)
                        {
                            _local_10 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                        };
                        if (_local_10 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.negative, _local_10, _arg_3, _local_7, _arg_5);
                        } else
                        {
                            if (_local_7 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
                                if (_local_7.next != null)
                                {
                                    if (resolveByAABB)
                                    {
                                        drawAABBGeometry(_arg_3, _local_7);
                                    } else
                                    {
                                        if (resolveByOOBB)
                                        {
                                            _arg_4 = _local_7;
                                            while (_arg_4 != null)
                                            {
                                                _arg_4.calculateOOBB(this);
                                                _arg_4 = _arg_4.next;
                                            };
                                            drawOOBBGeometry(_arg_3, _local_7);
                                        } else
                                        {
                                            drawConflictGeometry(_arg_3, _local_7);
                                        };
                                    };
                                } else
                                {
                                    _local_7.draw(_arg_3, threshold, this);
                                    _local_7.destroy();
                                };
                            };
                        };
                        if (_arg_1.positive != null)
                        {
                            _local_11 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.positive.boundMinX, _arg_1.positive.boundMinY, _arg_1.positive.boundMinZ, _arg_1.positive.boundMaxX, _arg_1.positive.boundMaxY, _arg_1.positive.boundMaxZ) : 0);
                        };
                        if (_local_11 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.positive, _local_11, _arg_3, _local_8, _arg_5);
                        } else
                        {
                            if (_local_8 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
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
                        };
                    } else
                    {
                        while (_arg_4 != null)
                        {
                            _local_6 = _arg_4.next;
                            _local_9 = this.checkBounds(_local_12, _local_13, _local_14, _local_15, _arg_4.boundMinX, _arg_4.boundMinY, _arg_4.boundMinZ, _arg_4.boundMaxX, _arg_4.boundMaxY, _arg_4.boundMaxZ, false);
                            if (_local_9 < 0)
                            {
                                _arg_4.next = _local_7;
                                _local_7 = _arg_4;
                            } else
                            {
                                if (_local_9 > 0)
                                {
                                    _arg_4.destroy();
                                } else
                                {
                                    _arg_4.crop(_arg_3, -(_local_12), -(_local_13), -(_local_14), -(_local_15), threshold);
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
                            _arg_4 = _local_6;
                        };
                        if (_arg_1.negative != null)
                        {
                            _local_10 = ((_arg_2 > 0) ? this.cullingInContainer(_arg_2, _arg_1.negative.boundMinX, _arg_1.negative.boundMinY, _arg_1.negative.boundMinZ, _arg_1.negative.boundMaxX, _arg_1.negative.boundMaxY, _arg_1.negative.boundMaxZ) : 0);
                        };
                        if (_local_10 >= 0)
                        {
                            _arg_5 = this.drawNode(_arg_1.negative, _local_10, _arg_3, _local_7, _arg_5);
                        } else
                        {
                            if (_local_7 != null)
                            {
                                if (_arg_5 != null)
                                {
                                    this.drawFaces(_arg_3, _arg_5);
                                    _arg_5 = null;
                                };
                                if (_local_7.next != null)
                                {
                                    if (resolveByAABB)
                                    {
                                        drawAABBGeometry(_arg_3, _local_7);
                                    } else
                                    {
                                        if (resolveByOOBB)
                                        {
                                            _arg_4 = _local_7;
                                            while (_arg_4 != null)
                                            {
                                                _arg_4.calculateOOBB(this);
                                                _arg_4 = _arg_4.next;
                                            };
                                            drawOOBBGeometry(_arg_3, _local_7);
                                        } else
                                        {
                                            drawConflictGeometry(_arg_3, _local_7);
                                        };
                                    };
                                } else
                                {
                                    _local_7.draw(_arg_3, threshold, this);
                                    _local_7.destroy();
                                };
                            };
                        };
                    };
                };
            } else
            {
                if (_arg_5 != null)
                {
                    this.drawFaces(_arg_3, _arg_5);
                    _arg_5 = null;
                };
                if (((!(_arg_1.objectList.next == null)) || (!(_arg_4 == null))))
                {
                    _local_23 = _arg_1.objectList;
                    _local_24 = _arg_1.boundList;
                    while (_local_23 != null)
                    {
                        if (((_local_23.visible) && (((_local_23.culling = _arg_2) == 0) || ((_local_23.culling = this.cullingInContainer(_arg_2, _local_24.boundMinX, _local_24.boundMinY, _local_24.boundMinZ, _local_24.boundMaxX, _local_24.boundMaxY, _local_24.boundMaxZ)) >= 0))))
                        {
                            _local_23.composeAndAppend(this);
                            _local_23.concat(this);
                            _local_25 = _local_23.getVG(_arg_3);
                            while (_local_25 != null)
                            {
                                _local_6 = _local_25.next;
                                _local_25.next = _arg_4;
                                _arg_4 = _local_25;
                                if (resolveByAABB)
                                {
                                    _local_25.calculateAABB(ima, imb, imc, imd, ime, imf, img, imh, imi, imj, imk, iml);
                                };
                                _local_25 = _local_6;
                            };
                        };
                        _local_23 = _local_23.next;
                        _local_24 = _local_24.next;
                    };
                    if (_arg_4 != null)
                    {
                        if (_arg_4.next != null)
                        {
                            drawConflictGeometry(_arg_3, _arg_4);
                        } else
                        {
                            _arg_4.draw(_arg_3, threshold, this);
                            _arg_4.destroy();
                        };
                    };
                } else
                {
                    _local_23 = _arg_1.objectList;
                    if (_local_23.visible)
                    {
                        _local_23.composeAndAppend(this);
                        _local_23.culling = _arg_2;
                        _local_23.concat(this);
                        _local_23.draw(_arg_3);
                    };
                };
            };
            return (_arg_5);
        }

        private function drawFaces(_arg_1:Camera3D, _arg_2:Face):void
        {
            var _local_4:Face;
            if (((_arg_1.debug) && (_arg_1.checkInDebug(this) & Debug.EDGES)))
            {
                Debug.drawEdges(_arg_1, _arg_2, 0xFFFFFF);
            };
            var _local_3:Face = _arg_2;
            while (_local_3 != null)
            {
                _local_4 = _local_3.processNext;
                if (((_local_4 == null) || (!(_local_4.material == _arg_2.material))))
                {
                    _local_3.processNext = null;
                    if (_arg_2.material == null)
                    {
                        while (_arg_2 != null)
                        {
                            _local_3 = _arg_2.processNext;
                            _arg_2.processNext = null;
                            _arg_2 = _local_3;
                        };
                    };
                    _arg_2 = _local_4;
                };
                _local_3 = _local_4;
            };
        }

        private function checkBounds(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Boolean):int
        {
            if (_arg_11)
            {
                if (_arg_1 >= 0)
                {
                    if (_arg_2 >= 0)
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        } else
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        };
                    } else
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        } else
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        };
                    };
                } else
                {
                    if (_arg_2 >= 0)
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        } else
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        };
                    } else
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        } else
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                        };
                    };
                };
            } else
            {
                if (_arg_1 >= 0)
                {
                    if (_arg_2 >= 0)
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        } else
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        };
                    } else
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        } else
                        {
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        };
                    };
                } else
                {
                    if (_arg_2 >= 0)
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        } else
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        };
                    } else
                    {
                        if (_arg_3 >= 0)
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_10 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_7 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        } else
                        {
                            if ((((_arg_5 * _arg_1) + (_arg_6 * _arg_2)) + (_arg_7 * _arg_3)) <= (_arg_4 + threshold))
                            {
                                return (-1);
                            };
                            if ((((_arg_8 * _arg_1) + (_arg_9 * _arg_2)) + (_arg_10 * _arg_3)) >= (_arg_4 - threshold))
                            {
                                return (1);
                            };
                        };
                    };
                };
            };
            return (0);
        }

        private function calculateCameraPlanes(_arg_1:Number, _arg_2:Number):void
        {
            this.directionX = imc;
            this.directionY = img;
            this.directionZ = imk;
            var _local_3:Number = (1 / Math.sqrt((((this.directionX * this.directionX) + (this.directionY * this.directionY)) + (this.directionZ * this.directionZ))));
            this.directionX = (this.directionX * _local_3);
            this.directionY = (this.directionY * _local_3);
            this.directionZ = (this.directionZ * _local_3);
            this.nearPlaneX = imc;
            this.nearPlaneY = img;
            this.nearPlaneZ = imk;
            this.nearPlaneOffset = (((((imc * _arg_1) + imd) * this.nearPlaneX) + (((img * _arg_1) + imh) * this.nearPlaneY)) + (((imk * _arg_1) + iml) * this.nearPlaneZ));
            this.farPlaneX = -(imc);
            this.farPlaneY = -(img);
            this.farPlaneZ = -(imk);
            this.farPlaneOffset = (((((imc * _arg_2) + imd) * this.farPlaneX) + (((img * _arg_2) + imh) * this.farPlaneY)) + (((imk * _arg_2) + iml) * this.farPlaneZ));
            var _local_4:Number = ((-(ima) - imb) + imc);
            var _local_5:Number = ((-(ime) - imf) + img);
            var _local_6:Number = ((-(imi) - imj) + imk);
            var _local_7:Number = ((ima - imb) + imc);
            var _local_8:Number = ((ime - imf) + img);
            var _local_9:Number = ((imi - imj) + imk);
            this.topPlaneX = ((_local_9 * _local_5) - (_local_8 * _local_6));
            this.topPlaneY = ((_local_7 * _local_6) - (_local_9 * _local_4));
            this.topPlaneZ = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.topPlaneOffset = (((imd * this.topPlaneX) + (imh * this.topPlaneY)) + (iml * this.topPlaneZ));
            _local_3 = (1 / Math.sqrt((((_local_4 * _local_4) + (_local_5 * _local_5)) + (_local_6 * _local_6))));
            _local_4 = (_local_4 * _local_3);
            _local_5 = (_local_5 * _local_3);
            _local_6 = (_local_6 * _local_3);
            var _local_10:Number = (((_local_4 * this.directionX) + (_local_5 * this.directionY)) + (_local_6 * this.directionZ));
            this.viewAngle = _local_10;
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = _local_9;
            _local_7 = ((ima + imb) + imc);
            _local_8 = ((ime + imf) + img);
            _local_9 = ((imi + imj) + imk);
            this.rightPlaneX = ((_local_9 * _local_5) - (_local_8 * _local_6));
            this.rightPlaneY = ((_local_7 * _local_6) - (_local_9 * _local_4));
            this.rightPlaneZ = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.rightPlaneOffset = (((imd * this.rightPlaneX) + (imh * this.rightPlaneY)) + (iml * this.rightPlaneZ));
            _local_3 = (1 / Math.sqrt((((_local_4 * _local_4) + (_local_5 * _local_5)) + (_local_6 * _local_6))));
            _local_4 = (_local_4 * _local_3);
            _local_5 = (_local_5 * _local_3);
            _local_6 = (_local_6 * _local_3);
            _local_10 = (((_local_4 * this.directionX) + (_local_5 * this.directionY)) + (_local_6 * this.directionZ));
            if (_local_10 < this.viewAngle)
            {
                this.viewAngle = _local_10;
            };
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = _local_9;
            _local_7 = ((-(ima) + imb) + imc);
            _local_8 = ((-(ime) + imf) + img);
            _local_9 = ((-(imi) + imj) + imk);
            this.bottomPlaneX = ((_local_9 * _local_5) - (_local_8 * _local_6));
            this.bottomPlaneY = ((_local_7 * _local_6) - (_local_9 * _local_4));
            this.bottomPlaneZ = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.bottomPlaneOffset = (((imd * this.bottomPlaneX) + (imh * this.bottomPlaneY)) + (iml * this.bottomPlaneZ));
            _local_3 = (1 / Math.sqrt((((_local_4 * _local_4) + (_local_5 * _local_5)) + (_local_6 * _local_6))));
            _local_4 = (_local_4 * _local_3);
            _local_5 = (_local_5 * _local_3);
            _local_6 = (_local_6 * _local_3);
            _local_10 = (((_local_4 * this.directionX) + (_local_5 * this.directionY)) + (_local_6 * this.directionZ));
            if (_local_10 < this.viewAngle)
            {
                this.viewAngle = _local_10;
            };
            _local_4 = _local_7;
            _local_5 = _local_8;
            _local_6 = _local_9;
            _local_7 = ((-(ima) - imb) + imc);
            _local_8 = ((-(ime) - imf) + img);
            _local_9 = ((-(imi) - imj) + imk);
            this.leftPlaneX = ((_local_9 * _local_5) - (_local_8 * _local_6));
            this.leftPlaneY = ((_local_7 * _local_6) - (_local_9 * _local_4));
            this.leftPlaneZ = ((_local_8 * _local_4) - (_local_7 * _local_5));
            this.leftPlaneOffset = (((imd * this.leftPlaneX) + (imh * this.leftPlaneY)) + (iml * this.leftPlaneZ));
            _local_3 = (1 / Math.sqrt((((_local_4 * _local_4) + (_local_5 * _local_5)) + (_local_6 * _local_6))));
            _local_4 = (_local_4 * _local_3);
            _local_5 = (_local_5 * _local_3);
            _local_6 = (_local_6 * _local_3);
            _local_10 = (((_local_4 * this.directionX) + (_local_5 * this.directionY)) + (_local_6 * this.directionZ));
            if (_local_10 < this.viewAngle)
            {
                this.viewAngle = _local_10;
            };
            this.viewAngle = Math.sin(Math.acos(this.viewAngle));
        }

        private function cullingInContainer(_arg_1:int, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number):int
        {
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
            return (_arg_1);
        }

        private function calculateFaceList(_arg_1:Mesh, _arg_2:Boolean, _arg_3:Face=null):Face
        {
            var _local_4:Vertex;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Face;
            _arg_1.composeMatrix();
            _local_4 = _arg_1.vertexList;
            while (_local_4.next != null)
            {
                _local_4.transformId = 0;
                _local_4.id = null;
                _local_5 = _local_4.x;
                _local_6 = _local_4.y;
                _local_7 = _local_4.z;
                _local_4.x = ((((_arg_1.ma * _local_5) + (_arg_1.mb * _local_6)) + (_arg_1.mc * _local_7)) + _arg_1.md);
                _local_4.y = ((((_arg_1.me * _local_5) + (_arg_1.mf * _local_6)) + (_arg_1.mg * _local_7)) + _arg_1.mh);
                _local_4.z = ((((_arg_1.mi * _local_5) + (_arg_1.mj * _local_6)) + (_arg_1.mk * _local_7)) + _arg_1.ml);
                _local_4 = _local_4.next;
            };
            _local_4.transformId = 0;
            _local_4.id = null;
            _local_5 = _local_4.x;
            _local_6 = _local_4.y;
            _local_7 = _local_4.z;
            _local_4.x = ((((_arg_1.ma * _local_5) + (_arg_1.mb * _local_6)) + (_arg_1.mc * _local_7)) + _arg_1.md);
            _local_4.y = ((((_arg_1.me * _local_5) + (_arg_1.mf * _local_6)) + (_arg_1.mg * _local_7)) + _arg_1.mh);
            _local_4.z = ((((_arg_1.mi * _local_5) + (_arg_1.mj * _local_6)) + (_arg_1.mk * _local_7)) + _arg_1.ml);
            if (_arg_2)
            {
                _local_4.next = this.vertexList;
                this.vertexList = _arg_1.vertexList;
            };
            _arg_1.vertexList = null;
            _local_8 = _arg_1.faceList;
            while (_local_8.next != null)
            {
                _local_8.calculateBestSequenceAndNormal();
                _local_8.id = null;
                _local_8 = _local_8.next;
            };
            _local_8.calculateBestSequenceAndNormal();
            _local_8.id = null;
            _local_8.next = _arg_3;
            _arg_3 = _arg_1.faceList;
            _arg_1.faceList = null;
            return (_arg_3);
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
            return (_local_2);
        }

        private function calculateObjectBounds(_arg_1:Object3D):void
        {
            var _local_2:Object3D;
            _arg_1.calculateBounds();
            if ((_arg_1 is Object3DContainer))
            {
                _local_2 = Object3DContainer(_arg_1).childrenList;
                while (_local_2 != null)
                {
                    this.calculateObjectBounds(_local_2);
                    _local_2 = _local_2.next;
                };
            };
        }

        private function createNode(_arg_1:Face, _arg_2:Face, _arg_3:Object3D, _arg_4:Object3D, _arg_5:Vector.<Face>, _arg_6:Vector.<Object3D>, _arg_7:Face=null):BSPNode
        {
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Face;
            var _local_12:Face;
            var _local_13:Face;
            var _local_14:Object3D;
            var _local_15:Object3D;
            var _local_16:Object3D;
            var _local_17:Object3D;
            var _local_18:Face;
            var _local_19:Face;
            var _local_20:Face;
            var _local_8:BSPNode = new BSPNode();
            this.calculateNodeBounds(_local_8, _arg_2, _arg_4);
            if (_arg_1 != null)
            {
                _local_9 = ((_arg_1.next != null) ? this.findSplitter(_arg_1) : _arg_1);
            } else
            {
                if (_arg_3 != null)
                {
                    _local_19 = this.createBoundFaces(_arg_4);
                    _local_18 = _arg_7;
                    while (_local_18 != null)
                    {
                        _local_19 = this.cropBoundFaceList(_local_19, _local_18.normalX, _local_18.normalY, _local_18.normalZ, _local_18.offset);
                        if (_local_19 == null) break;
                        _local_18 = _local_18.next;
                    };
                };
                if (_local_19 != null)
                {
                    _local_18 = _local_19;
                    while (_local_18.next != null)
                    {
                        _local_18 = _local_18.next;
                    };
                    _local_18.next = _arg_2;
                    _local_9 = ((_local_19.next != null) ? this.findSplitter(_local_19) : _local_19);
                } else
                {
                    if (_arg_2 != null)
                    {
                        _local_9 = ((_arg_2.next != null) ? this.findSplitter(_arg_2) : _arg_2);
                    };
                };
            };
            if (_local_9 != null)
            {
                _local_8.normalX = _local_9.normalX;
                _local_8.normalY = _local_9.normalY;
                _local_8.normalZ = _local_9.normalZ;
                _local_8.offset = _local_9.offset;
                if (_arg_1 != null)
                {
                    this.splitFaceList(_local_9, _arg_1, false, _arg_5);
                    _local_10 = _arg_5[0];
                    _local_11 = _arg_5[2];
                };
                if (_arg_2 != null)
                {
                    this.splitFaceList(_local_9, _arg_2, true, _arg_5);
                    _local_12 = _arg_5[0];
                    _local_8.faceList = _arg_5[1];
                    _local_13 = _arg_5[2];
                };
                if (_arg_3 != null)
                {
                    this.splitObjectList(_local_9, _arg_3, _arg_4, _arg_6);
                    _local_14 = _arg_6[0];
                    _local_16 = _arg_6[1];
                    _local_15 = _arg_6[2];
                    _local_17 = _arg_6[3];
                };
                _local_20 = new Face();
                _local_20.next = _arg_7;
                if (((!(_local_12 == null)) || (!(_local_14 == null))))
                {
                    _local_20.normalX = -(_local_8.normalX);
                    _local_20.normalY = -(_local_8.normalY);
                    _local_20.normalZ = -(_local_8.normalZ);
                    _local_20.offset = -(_local_8.offset);
                    _local_8.negative = this.createNode(_local_10, _local_12, _local_14, _local_16, _arg_5, _arg_6, _local_20);
                };
                if (((!(_local_13 == null)) || (!(_local_15 == null))))
                {
                    _local_20.normalX = _local_8.normalX;
                    _local_20.normalY = _local_8.normalY;
                    _local_20.normalZ = _local_8.normalZ;
                    _local_20.offset = _local_8.offset;
                    _local_8.positive = this.createNode(_local_11, _local_13, _local_15, _local_17, _arg_5, _arg_6, _local_20);
                };
            } else
            {
                _local_8.objectList = _arg_3;
                _local_8.boundList = _arg_4;
            };
            return (_local_8);
        }

        private function calculateNodeBounds(_arg_1:BSPNode, _arg_2:Face, _arg_3:Object3D):void
        {
            var _local_6:Wrapper;
            var _local_7:Vertex;
            _arg_1.boundMinX = 1E22;
            _arg_1.boundMinY = 1E22;
            _arg_1.boundMinZ = 1E22;
            _arg_1.boundMaxX = -1E22;
            _arg_1.boundMaxY = -1E22;
            _arg_1.boundMaxZ = -1E22;
            var _local_4:Object3D = _arg_3;
            while (_local_4 != null)
            {
                if (_local_4.boundMinX < _arg_1.boundMinX)
                {
                    _arg_1.boundMinX = _local_4.boundMinX;
                };
                if (_local_4.boundMaxX > _arg_1.boundMaxX)
                {
                    _arg_1.boundMaxX = _local_4.boundMaxX;
                };
                if (_local_4.boundMinY < _arg_1.boundMinY)
                {
                    _arg_1.boundMinY = _local_4.boundMinY;
                };
                if (_local_4.boundMaxY > _arg_1.boundMaxY)
                {
                    _arg_1.boundMaxY = _local_4.boundMaxY;
                };
                if (_local_4.boundMinZ < _arg_1.boundMinZ)
                {
                    _arg_1.boundMinZ = _local_4.boundMinZ;
                };
                if (_local_4.boundMaxZ > _arg_1.boundMaxZ)
                {
                    _arg_1.boundMaxZ = _local_4.boundMaxZ;
                };
                _local_4 = _local_4.next;
            };
            var _local_5:Face = _arg_2;
            while (_local_5 != null)
            {
                _local_6 = _local_5.wrapper;
                while (_local_6 != null)
                {
                    _local_7 = _local_6.vertex;
                    if (_local_7.x < _arg_1.boundMinX)
                    {
                        _arg_1.boundMinX = _local_7.x;
                    };
                    if (_local_7.x > _arg_1.boundMaxX)
                    {
                        _arg_1.boundMaxX = _local_7.x;
                    };
                    if (_local_7.y < _arg_1.boundMinY)
                    {
                        _arg_1.boundMinY = _local_7.y;
                    };
                    if (_local_7.y > _arg_1.boundMaxY)
                    {
                        _arg_1.boundMaxY = _local_7.y;
                    };
                    if (_local_7.z < _arg_1.boundMinZ)
                    {
                        _arg_1.boundMinZ = _local_7.z;
                    };
                    if (_local_7.z > _arg_1.boundMaxZ)
                    {
                        _arg_1.boundMaxZ = _local_7.z;
                    };
                    _local_6 = _local_6.next;
                };
                _local_5 = _local_5.next;
            };
        }

        private function findSplitter(_arg_1:Face):Face
        {
            var _local_2:Face;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:int;
            var _local_12:Face;
            var _local_13:Wrapper;
            var _local_14:Vertex;
            var _local_15:Vertex;
            var _local_16:Vertex;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Boolean;
            var _local_21:Boolean;
            var _local_22:Vertex;
            var _local_23:Number;
            var _local_3:int = 2147483647;
            var _local_4:Face = _arg_1;
            while (_local_4 != null)
            {
                _local_5 = _local_4.normalX;
                _local_6 = _local_4.normalY;
                _local_7 = _local_4.normalZ;
                _local_8 = _local_4.offset;
                _local_9 = (_local_8 - threshold);
                _local_10 = (_local_8 + threshold);
                _local_11 = 0;
                _local_12 = _arg_1;
                while (_local_12 != null)
                {
                    if (_local_12 != _local_4)
                    {
                        _local_13 = _local_12.wrapper;
                        _local_14 = _local_13.vertex;
                        _local_13 = _local_13.next;
                        _local_15 = _local_13.vertex;
                        _local_13 = _local_13.next;
                        _local_16 = _local_13.vertex;
                        _local_17 = (((_local_14.x * _local_5) + (_local_14.y * _local_6)) + (_local_14.z * _local_7));
                        _local_18 = (((_local_15.x * _local_5) + (_local_15.y * _local_6)) + (_local_15.z * _local_7));
                        _local_19 = (((_local_16.x * _local_5) + (_local_16.y * _local_6)) + (_local_16.z * _local_7));
                        _local_20 = (((_local_17 < _local_9) || (_local_18 < _local_9)) || (_local_19 < _local_9));
                        _local_21 = (((_local_17 > _local_10) || (_local_18 > _local_10)) || (_local_19 > _local_10));
                        _local_13 = _local_13.next;
                        while (_local_13 != null)
                        {
                            _local_22 = _local_13.vertex;
                            _local_23 = (((_local_22.x * _local_5) + (_local_22.y * _local_6)) + (_local_22.z * _local_7));
                            if (_local_23 < _local_9)
                            {
                                _local_20 = true;
                                if (_local_21) break;
                            } else
                            {
                                if (_local_23 > _local_10)
                                {
                                    _local_21 = true;
                                    if (_local_20) break;
                                };
                            };
                            _local_13 = _local_13.next;
                        };
                        if (((_local_21) && (_local_20)))
                        {
                            _local_11++;
                            if (_local_11 >= _local_3) break;
                        };
                    };
                    _local_12 = _local_12.next;
                };
                if (_local_11 < _local_3)
                {
                    _local_2 = _local_4;
                    _local_3 = _local_11;
                    if (_local_3 == 0) break;
                };
                _local_4 = _local_4.next;
            };
            return (_local_2);
        }

        private function createBoundFaces(_arg_1:Object3D):Face
        {
            var _local_2:Face;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Vertex;
            var _local_10:Vertex;
            var _local_11:Vertex;
            var _local_12:Face;
            var _local_3:Object3D = _arg_1;
            while (_local_3 != null)
            {
                _local_4 = new Vertex();
                _local_4.x = _local_3.boundMinX;
                _local_4.y = _local_3.boundMinY;
                _local_4.z = _local_3.boundMinZ;
                _local_5 = new Vertex();
                _local_5.x = _local_3.boundMaxX;
                _local_5.y = _local_3.boundMinY;
                _local_5.z = _local_3.boundMinZ;
                _local_6 = new Vertex();
                _local_6.x = _local_3.boundMinX;
                _local_6.y = _local_3.boundMaxY;
                _local_6.z = _local_3.boundMinZ;
                _local_7 = new Vertex();
                _local_7.x = _local_3.boundMaxX;
                _local_7.y = _local_3.boundMaxY;
                _local_7.z = _local_3.boundMinZ;
                _local_8 = new Vertex();
                _local_8.x = _local_3.boundMinX;
                _local_8.y = _local_3.boundMinY;
                _local_8.z = _local_3.boundMaxZ;
                _local_9 = new Vertex();
                _local_9.x = _local_3.boundMaxX;
                _local_9.y = _local_3.boundMinY;
                _local_9.z = _local_3.boundMaxZ;
                _local_10 = new Vertex();
                _local_10.x = _local_3.boundMinX;
                _local_10.y = _local_3.boundMaxY;
                _local_10.z = _local_3.boundMaxZ;
                _local_11 = new Vertex();
                _local_11.x = _local_3.boundMaxX;
                _local_11.y = _local_3.boundMaxY;
                _local_11.z = _local_3.boundMaxZ;
                _local_12 = new Face();
                _local_12.normalX = -1;
                _local_12.normalY = 0;
                _local_12.normalZ = 0;
                _local_12.offset = -(_local_3.boundMinX);
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_4;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_8;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_10;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_6;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_12 = new Face();
                _local_12.normalX = 1;
                _local_12.normalY = 0;
                _local_12.normalZ = 0;
                _local_12.offset = _local_3.boundMaxX;
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_5;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_7;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_11;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_9;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_12 = new Face();
                _local_12.normalX = 0;
                _local_12.normalY = -1;
                _local_12.normalZ = 0;
                _local_12.offset = -(_local_3.boundMinY);
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_4;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_5;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_9;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_8;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_12 = new Face();
                _local_12.normalX = 0;
                _local_12.normalY = 1;
                _local_12.normalZ = 0;
                _local_12.offset = _local_3.boundMaxY;
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_6;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_10;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_11;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_7;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_12 = new Face();
                _local_12.normalX = 0;
                _local_12.normalY = 0;
                _local_12.normalZ = -1;
                _local_12.offset = -(_local_3.boundMinZ);
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_4;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_6;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_7;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_5;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_12 = new Face();
                _local_12.normalX = 0;
                _local_12.normalY = 0;
                _local_12.normalZ = 1;
                _local_12.offset = _local_3.boundMaxZ;
                _local_12.wrapper = new Wrapper();
                _local_12.wrapper.vertex = _local_8;
                _local_12.wrapper.next = new Wrapper();
                _local_12.wrapper.next.vertex = _local_9;
                _local_12.wrapper.next.next = new Wrapper();
                _local_12.wrapper.next.next.vertex = _local_11;
                _local_12.wrapper.next.next.next = new Wrapper();
                _local_12.wrapper.next.next.next.vertex = _local_10;
                _local_12.next = _local_2;
                _local_2 = _local_12;
                _local_3 = _local_3.next;
            };
            return (_local_2);
        }

        private function cropBoundFaceList(_arg_1:Face, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Face
        {
            var _local_6:Face;
            var _local_10:Face;
            var _local_11:Vertex;
            var _local_12:Wrapper;
            var _local_13:Vertex;
            var _local_14:Vertex;
            var _local_15:Vertex;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Boolean;
            var _local_20:Boolean;
            var _local_21:Number;
            var _local_22:Wrapper;
            var _local_23:Wrapper;
            var _local_24:Number;
            var _local_7:Number = (_arg_5 - threshold);
            var _local_8:Number = (_arg_5 + threshold);
            var _local_9:Face = _arg_1;
            while (_local_9 != null)
            {
                _local_10 = _local_9.next;
                _local_9.next = null;
                _local_12 = _local_9.wrapper;
                _local_13 = _local_12.vertex;
                _local_12 = _local_12.next;
                _local_14 = _local_12.vertex;
                _local_12 = _local_12.next;
                _local_15 = _local_12.vertex;
                _local_12 = _local_12.next;
                _local_16 = (((_local_13.x * _arg_2) + (_local_13.y * _arg_3)) + (_local_13.z * _arg_4));
                _local_17 = (((_local_14.x * _arg_2) + (_local_14.y * _arg_3)) + (_local_14.z * _arg_4));
                _local_18 = (((_local_15.x * _arg_2) + (_local_15.y * _arg_3)) + (_local_15.z * _arg_4));
                _local_19 = (((_local_16 < _local_7) || (_local_17 < _local_7)) || (_local_18 < _local_7));
                _local_20 = (((_local_16 > _local_8) || (_local_17 > _local_8)) || (_local_18 > _local_8));
                while (_local_12 != null)
                {
                    _local_11 = _local_12.vertex;
                    _local_21 = (((_local_11.x * _arg_2) + (_local_11.y * _arg_3)) + (_local_11.z * _arg_4));
                    if (_local_21 < _local_7)
                    {
                        _local_19 = true;
                    } else
                    {
                        if (_local_21 > _local_8)
                        {
                            _local_20 = true;
                        };
                    };
                    _local_11.offset = _local_21;
                    _local_12 = _local_12.next;
                };
                if (_local_20)
                {
                    if ((!(_local_19)))
                    {
                        _local_9.next = _local_6;
                        _local_6 = _local_9;
                    } else
                    {
                        _local_13.offset = _local_16;
                        _local_14.offset = _local_17;
                        _local_15.offset = _local_18;
                        _local_22 = null;
                        _local_12 = _local_9.wrapper.next.next;
                        while (_local_12.next != null)
                        {
                            _local_12 = _local_12.next;
                        };
                        _local_13 = _local_12.vertex;
                        _local_16 = _local_13.offset;
                        _local_12 = _local_9.wrapper;
                        _local_9.wrapper = null;
                        while (_local_12 != null)
                        {
                            _local_14 = _local_12.vertex;
                            _local_17 = _local_14.offset;
                            if ((((_local_16 < _local_7) && (_local_17 > _local_8)) || ((_local_16 > _local_8) && (_local_17 < _local_7))))
                            {
                                _local_24 = ((_arg_5 - _local_16) / (_local_17 - _local_16));
                                _local_11 = new Vertex();
                                _local_11.x = (_local_13.x + ((_local_14.x - _local_13.x) * _local_24));
                                _local_11.y = (_local_13.y + ((_local_14.y - _local_13.y) * _local_24));
                                _local_11.z = (_local_13.z + ((_local_14.z - _local_13.z) * _local_24));
                                _local_23 = _local_12.create();
                                _local_23.vertex = _local_11;
                                if (_local_22 != null)
                                {
                                    _local_22.next = _local_23;
                                } else
                                {
                                    _local_9.wrapper = _local_23;
                                };
                                _local_22 = _local_23;
                            };
                            if (_local_17 >= _local_7)
                            {
                                _local_23 = _local_12.create();
                                _local_23.vertex = _local_14;
                                if (_local_22 != null)
                                {
                                    _local_22.next = _local_23;
                                } else
                                {
                                    _local_9.wrapper = _local_23;
                                };
                                _local_22 = _local_23;
                            };
                            _local_13 = _local_14;
                            _local_16 = _local_17;
                            _local_12 = _local_12.next;
                        };
                        _local_9.next = _local_6;
                        _local_6 = _local_9;
                    };
                };
                _local_9 = _local_10;
            };
            return (_local_6);
        }

        private function splitFaceList(_arg_1:Face, _arg_2:Face, _arg_3:Boolean, _arg_4:Vector.<Face>):void
        {
            var _local_11:Face;
            var _local_12:Face;
            var _local_13:Face;
            var _local_14:Face;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Face;
            var _local_18:Wrapper;
            var _local_19:Vertex;
            var _local_20:Vertex;
            var _local_21:Vertex;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Boolean;
            var _local_26:Boolean;
            var _local_27:Vertex;
            var _local_28:Number;
            var _local_29:Face;
            var _local_30:Face;
            var _local_31:Wrapper;
            var _local_32:Wrapper;
            var _local_33:Wrapper;
            var _local_34:Number;
            var _local_5:Number = _arg_1.normalX;
            var _local_6:Number = _arg_1.normalY;
            var _local_7:Number = _arg_1.normalZ;
            var _local_8:Number = _arg_1.offset;
            var _local_9:Number = (_local_8 - threshold);
            var _local_10:Number = (_local_8 + threshold);
            while (_arg_2 != null)
            {
                _local_17 = _arg_2.next;
                _arg_2.next = null;
                if (_arg_2 == _arg_1)
                {
                    if (_local_13 != null)
                    {
                        _local_14.next = _arg_2;
                    } else
                    {
                        _local_13 = _arg_2;
                    };
                    _local_14 = _arg_2;
                    _arg_2 = _local_17;
                } else
                {
                    _local_18 = _arg_2.wrapper;
                    _local_19 = _local_18.vertex;
                    _local_18 = _local_18.next;
                    _local_20 = _local_18.vertex;
                    _local_18 = _local_18.next;
                    _local_21 = _local_18.vertex;
                    _local_22 = (((_local_19.x * _local_5) + (_local_19.y * _local_6)) + (_local_19.z * _local_7));
                    _local_23 = (((_local_20.x * _local_5) + (_local_20.y * _local_6)) + (_local_20.z * _local_7));
                    _local_24 = (((_local_21.x * _local_5) + (_local_21.y * _local_6)) + (_local_21.z * _local_7));
                    _local_25 = (((_local_22 < _local_9) || (_local_23 < _local_9)) || (_local_24 < _local_9));
                    _local_26 = (((_local_22 > _local_10) || (_local_23 > _local_10)) || (_local_24 > _local_10));
                    _local_18 = _local_18.next;
                    while (_local_18 != null)
                    {
                        _local_27 = _local_18.vertex;
                        _local_28 = (((_local_27.x * _local_5) + (_local_27.y * _local_6)) + (_local_27.z * _local_7));
                        if (_local_28 < _local_9)
                        {
                            _local_25 = true;
                        } else
                        {
                            if (_local_28 > _local_10)
                            {
                                _local_26 = true;
                            };
                        };
                        _local_27.offset = _local_28;
                        _local_18 = _local_18.next;
                    };
                    if ((!(_local_25)))
                    {
                        if ((!(_local_26)))
                        {
                            if ((((_arg_2.normalX * _local_5) + (_arg_2.normalY * _local_6)) + (_arg_2.normalZ * _local_7)) > 0)
                            {
                                if (_local_13 != null)
                                {
                                    _local_14.next = _arg_2;
                                } else
                                {
                                    _local_13 = _arg_2;
                                };
                                _local_14 = _arg_2;
                            } else
                            {
                                if (_local_11 != null)
                                {
                                    _local_12.next = _arg_2;
                                } else
                                {
                                    _local_11 = _arg_2;
                                };
                                _local_12 = _arg_2;
                            };
                        } else
                        {
                            if (_local_15 != null)
                            {
                                _local_16.next = _arg_2;
                            } else
                            {
                                _local_15 = _arg_2;
                            };
                            _local_16 = _arg_2;
                        };
                    } else
                    {
                        if ((!(_local_26)))
                        {
                            if (_local_11 != null)
                            {
                                _local_12.next = _arg_2;
                            } else
                            {
                                _local_11 = _arg_2;
                            };
                            _local_12 = _arg_2;
                        } else
                        {
                            _local_19.offset = _local_22;
                            _local_20.offset = _local_23;
                            _local_21.offset = _local_24;
                            _local_29 = new Face();
                            _local_30 = new Face();
                            _local_31 = null;
                            _local_32 = null;
                            _local_18 = _arg_2.wrapper.next.next;
                            while (_local_18.next != null)
                            {
                                _local_18 = _local_18.next;
                            };
                            _local_19 = _local_18.vertex;
                            _local_22 = _local_19.offset;
                            _local_18 = _arg_2.wrapper;
                            while (_local_18 != null)
                            {
                                _local_20 = _local_18.vertex;
                                _local_23 = _local_20.offset;
                                if ((((_local_22 < _local_9) && (_local_23 > _local_10)) || ((_local_22 > _local_10) && (_local_23 < _local_9))))
                                {
                                    _local_34 = ((_local_8 - _local_22) / (_local_23 - _local_22));
                                    _local_27 = new Vertex();
                                    if (_arg_3)
                                    {
                                        _local_27.next = this.vertexList;
                                        this.vertexList = _local_27;
                                    };
                                    _local_27.x = (_local_19.x + ((_local_20.x - _local_19.x) * _local_34));
                                    _local_27.y = (_local_19.y + ((_local_20.y - _local_19.y) * _local_34));
                                    _local_27.z = (_local_19.z + ((_local_20.z - _local_19.z) * _local_34));
                                    _local_27.u = (_local_19.u + ((_local_20.u - _local_19.u) * _local_34));
                                    _local_27.v = (_local_19.v + ((_local_20.v - _local_19.v) * _local_34));
                                    _local_27.normalX = (_local_19.normalX + ((_local_20.normalX - _local_19.normalX) * _local_34));
                                    _local_27.normalY = (_local_19.normalY + ((_local_20.normalY - _local_19.normalY) * _local_34));
                                    _local_27.normalZ = (_local_19.normalZ + ((_local_20.normalZ - _local_19.normalZ) * _local_34));
                                    _local_33 = new Wrapper();
                                    _local_33.vertex = _local_27;
                                    if (_local_31 != null)
                                    {
                                        _local_31.next = _local_33;
                                    } else
                                    {
                                        _local_29.wrapper = _local_33;
                                    };
                                    _local_31 = _local_33;
                                    _local_33 = new Wrapper();
                                    _local_33.vertex = _local_27;
                                    if (_local_32 != null)
                                    {
                                        _local_32.next = _local_33;
                                    } else
                                    {
                                        _local_30.wrapper = _local_33;
                                    };
                                    _local_32 = _local_33;
                                };
                                if (_local_23 <= _local_10)
                                {
                                    _local_33 = new Wrapper();
                                    _local_33.vertex = _local_20;
                                    if (_local_31 != null)
                                    {
                                        _local_31.next = _local_33;
                                    } else
                                    {
                                        _local_29.wrapper = _local_33;
                                    };
                                    _local_31 = _local_33;
                                };
                                if (_local_23 >= _local_9)
                                {
                                    _local_33 = new Wrapper();
                                    _local_33.vertex = _local_20;
                                    if (_local_32 != null)
                                    {
                                        _local_32.next = _local_33;
                                    } else
                                    {
                                        _local_30.wrapper = _local_33;
                                    };
                                    _local_32 = _local_33;
                                };
                                _local_19 = _local_20;
                                _local_22 = _local_23;
                                _local_18 = _local_18.next;
                            };
                            _local_29.material = _arg_2.material;
                            _local_29.calculateBestSequenceAndNormal();
                            if (_local_11 != null)
                            {
                                _local_12.next = _local_29;
                            } else
                            {
                                _local_11 = _local_29;
                            };
                            _local_12 = _local_29;
                            _local_30.material = _arg_2.material;
                            _local_30.calculateBestSequenceAndNormal();
                            if (_local_15 != null)
                            {
                                _local_16.next = _local_30;
                            } else
                            {
                                _local_15 = _local_30;
                            };
                            _local_16 = _local_30;
                        };
                    };
                    _arg_2 = _local_17;
                };
            };
            _arg_4[0] = _local_11;
            _arg_4[1] = _local_13;
            _arg_4[2] = _local_15;
        }

        private function splitObjectList(_arg_1:Face, _arg_2:Object3D, _arg_3:Object3D, _arg_4:Vector.<Object3D>):void
        {
            var _local_5:Object3D;
            var _local_6:Object3D;
            var _local_7:Object3D;
            var _local_8:Object3D;
            var _local_9:Object3D;
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_12:Object3D;
            var _local_13:int;
            var _local_14:Vertex;
            var _local_15:Vector3D;
            var _local_16:Vector3D;
            var _local_17:Vector3D;
            var _local_18:int;
            var _local_19:Vector.<Object3D>;
            _local_9 = _arg_2;
            _local_10 = _arg_3;
            while (_local_9 != null)
            {
                _local_11 = _local_9.next;
                _local_12 = _local_10.next;
                _local_9.next = null;
                _local_10.next = null;
                _local_13 = this.checkBounds(_arg_1.normalX, _arg_1.normalY, _arg_1.normalZ, _arg_1.offset, _local_10.boundMinX, _local_10.boundMinY, _local_10.boundMinZ, _local_10.boundMaxX, _local_10.boundMaxY, _local_10.boundMaxZ, true);
                if (_local_13 < 0)
                {
                    _local_9.next = _local_5;
                    _local_5 = _local_9;
                    _local_10.next = _local_6;
                    _local_6 = _local_10;
                } else
                {
                    if (_local_13 > 0)
                    {
                        _local_9.next = _local_7;
                        _local_7 = _local_9;
                        _local_10.next = _local_8;
                        _local_8 = _local_10;
                    } else
                    {
                        _local_9.composeMatrix();
                        _local_9.calculateInverseMatrix();
                        _local_14 = _arg_1.wrapper.vertex;
                        _local_15 = new Vector3D(((((_local_9.ima * _local_14.x) + (_local_9.imb * _local_14.y)) + (_local_9.imc * _local_14.z)) + _local_9.imd), ((((_local_9.ime * _local_14.x) + (_local_9.imf * _local_14.y)) + (_local_9.img * _local_14.z)) + _local_9.imh), ((((_local_9.imi * _local_14.x) + (_local_9.imj * _local_14.y)) + (_local_9.imk * _local_14.z)) + _local_9.iml));
                        _local_14 = _arg_1.wrapper.next.vertex;
                        _local_16 = new Vector3D(((((_local_9.ima * _local_14.x) + (_local_9.imb * _local_14.y)) + (_local_9.imc * _local_14.z)) + _local_9.imd), ((((_local_9.ime * _local_14.x) + (_local_9.imf * _local_14.y)) + (_local_9.img * _local_14.z)) + _local_9.imh), ((((_local_9.imi * _local_14.x) + (_local_9.imj * _local_14.y)) + (_local_9.imk * _local_14.z)) + _local_9.iml));
                        _local_14 = _arg_1.wrapper.next.next.vertex;
                        _local_17 = new Vector3D(((((_local_9.ima * _local_14.x) + (_local_9.imb * _local_14.y)) + (_local_9.imc * _local_14.z)) + _local_9.imd), ((((_local_9.ime * _local_14.x) + (_local_9.imf * _local_14.y)) + (_local_9.img * _local_14.z)) + _local_9.imh), ((((_local_9.imi * _local_14.x) + (_local_9.imj * _local_14.y)) + (_local_9.imk * _local_14.z)) + _local_9.iml));
                        _local_18 = _local_9.testSplit(_local_15, _local_16, _local_17, threshold);
                        if (_local_18 < 0)
                        {
                            _local_9.next = _local_5;
                            _local_5 = _local_9;
                            _local_10.next = _local_6;
                            _local_6 = _local_10;
                        } else
                        {
                            if (_local_18 > 0)
                            {
                                _local_9.next = _local_7;
                                _local_7 = _local_9;
                                _local_10.next = _local_8;
                                _local_8 = _local_10;
                            } else
                            {
                                _local_19 = _local_9.split(_local_15, _local_16, _local_17, threshold);
                                if (_local_19[0] != null)
                                {
                                    _local_9 = _local_19[0];
                                    _local_9.setParent(this);
                                    _local_9.next = _local_5;
                                    _local_5 = _local_9;
                                    _local_10 = this.createObjectBounds(_local_9);
                                    _local_10.next = _local_6;
                                    _local_6 = _local_10;
                                };
                                if (_local_19[1] != null)
                                {
                                    _local_9 = _local_19[1];
                                    _local_9.setParent(this);
                                    _local_9.next = _local_7;
                                    _local_7 = _local_9;
                                    _local_10 = this.createObjectBounds(_local_9);
                                    _local_10.next = _local_8;
                                    _local_8 = _local_10;
                                };
                            };
                        };
                    };
                };
                _local_9 = _local_11;
                _local_10 = _local_12;
            };
            _arg_4[0] = _local_5;
            _arg_4[1] = _local_6;
            _arg_4[2] = _local_7;
            _arg_4[3] = _local_8;
        }

        private function destroyNode(_arg_1:BSPNode):void
        {
            var _local_3:Object3D;
            var _local_4:Object3D;
            var _local_5:Face;
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
                _local_5 = _local_2.next;
                _local_2.next = null;
                _local_2 = _local_5;
            };
            _local_3 = _arg_1.objectList;
            while (_local_3 != null)
            {
                _local_4 = _local_3.next;
                _local_3.setParent(null);
                _local_3.next = null;
                _local_3 = _local_4;
            };
            _local_3 = _arg_1.boundList;
            while (_local_3 != null)
            {
                _local_4 = _local_3.next;
                _local_3.next = null;
                _local_3 = _local_4;
            };
            _arg_1.faceList = null;
            _arg_1.objectList = null;
            _arg_1.boundList = null;
        }


    }
}//package alternativa.engine3d.containers

import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Object3D;

class BSPNode 
{

    public var faceList:Face;
    public var negative:BSPNode;
    public var positive:BSPNode;
    public var normalX:Number;
    public var normalY:Number;
    public var normalZ:Number;
    public var offset:Number;
    public var boundMinX:Number;
    public var boundMinY:Number;
    public var boundMinZ:Number;
    public var boundMaxX:Number;
    public var boundMaxY:Number;
    public var boundMaxZ:Number;
    public var objectList:Object3D;
    public var boundList:Object3D;


}
