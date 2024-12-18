package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Face;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.materials.Material;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.RayIntersectionData;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.core.Wrapper;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Skin extends Mesh 
    {

        alternativa3d var jointList:Joint;
        alternativa3d var localList:Face;

        public function Skin()
        {
            shadowMapAlphaThreshold = 100;
        }

        public function addJoint(_arg_1:Joint):Joint
        {
            var _local_2:Joint;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter joint must be non-null."));
            };
            if (_arg_1._parentJoint != null)
            {
                _arg_1._parentJoint.removeChild(_arg_1);
            } else
            {
                if (_arg_1._skin != null)
                {
                    _arg_1._skin.removeJoint(_arg_1);
                };
            };
            _arg_1._parentJoint = null;
            _arg_1.setSkin(this);
            if (this.jointList == null)
            {
                this.jointList = _arg_1;
            } else
            {
                _local_2 = this.jointList;
                while (_local_2 != null)
                {
                    if (_local_2.nextJoint == null)
                    {
                        _local_2.nextJoint = _arg_1;
                        break;
                    };
                    _local_2 = _local_2.nextJoint;
                };
            };
            return (_arg_1);
        }

        public function removeJoint(_arg_1:Joint):Joint
        {
            var _local_2:Joint;
            var _local_3:Joint;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter joint must be non-null."));
            };
            if (((!(_arg_1._parentJoint == null)) || (!(_arg_1._skin == this))))
            {
                throw (new ArgumentError("The supplied Joint must be contained in the caller."));
            };
            _local_3 = this.jointList;
            while (_local_3 != null)
            {
                if (_local_3 == _arg_1)
                {
                    if (_local_2 != null)
                    {
                        _local_2.nextJoint = _local_3.nextJoint;
                    } else
                    {
                        this.jointList = _local_3.nextJoint;
                    };
                    _local_3.nextJoint = null;
                    _local_3._parentJoint = null;
                    _local_3.setSkin(null);
                    return (_arg_1);
                };
                _local_2 = _local_3;
                _local_3 = _local_3.nextJoint;
            };
            return (null);
        }

        public function getJointAt(_arg_1:int):Joint
        {
            if (_arg_1 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_2:Joint = this.jointList;
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                if (_local_2 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_2 = _local_2.nextJoint;
                _local_3++;
            };
            if (_local_2 == null)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            return (_local_2);
        }

        public function get numJoints():int
        {
            var _local_1:int;
            var _local_2:Joint = this.jointList;
            while (_local_2 != null)
            {
                _local_1++;
                _local_2 = _local_2.nextJoint;
            };
            return (_local_1);
        }

        public function getJointByName(_arg_1:String):Joint
        {
            var _local_4:Joint;
            var _local_6:int;
            var _local_7:Vector.<Joint>;
            var _local_8:Joint;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter name must be non-null."));
            };
            var _local_2:Vector.<Joint> = new Vector.<Joint>();
            var _local_3:Vector.<Joint> = new Vector.<Joint>();
            _local_4 = this.jointList;
            while (_local_4 != null)
            {
                if (_local_4.name == _arg_1)
                {
                    return (_local_4);
                };
                _local_2.push(_local_4);
                _local_4 = _local_4.nextJoint;
            };
            var _local_5:int = this.numJoints;
            while (_local_5 > 0)
            {
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_4 = _local_2[_local_6];
                    _local_8 = _local_4.childrenList;
                    while (_local_8 != null)
                    {
                        if (_local_8.name == _arg_1)
                        {
                            return (_local_8);
                        };
                        if (_local_8.childrenList != null)
                        {
                            _local_3.push(_local_8);
                        };
                        _local_8 = _local_8.nextJoint;
                    };
                    _local_6++;
                };
                _local_7 = _local_2;
                _local_2 = _local_3;
                _local_3 = _local_7;
                _local_3.length = 0;
                _local_5 = _local_2.length;
            };
            return (null);
        }

        override public function addVertex(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number=0, _arg_5:Number=0, _arg_6:Object=null):Vertex
        {
            this.clearLocal();
            return (super.addVertex(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6));
        }

        override public function removeVertex(_arg_1:Vertex):Vertex
        {
            this.clearLocal();
            var _local_2:Vertex = super.removeVertex(_arg_1);
            var _local_3:Joint = this.jointList;
            while (_local_3 != null)
            {
                this.unbindVertex(_local_3, _local_2);
                _local_3 = _local_3.nextJoint;
            };
            return (_local_2);
        }

        override public function removeVertexById(_arg_1:Object):Vertex
        {
            this.clearLocal();
            var _local_2:Vertex = super.removeVertexById(_arg_1);
            var _local_3:Joint = this.jointList;
            while (_local_3 != null)
            {
                this.unbindVertex(_local_3, _local_2);
                _local_3 = _local_3.nextJoint;
            };
            return (_local_2);
        }

        private function unbindVertex(_arg_1:Joint, _arg_2:Vertex):void
        {
            _arg_1.unbindVertex(_arg_2);
            var _local_3:Joint = _arg_1.childrenList;
            while (_local_3 != null)
            {
                this.unbindVertex(_local_3, _arg_2);
                _local_3 = _local_3.nextJoint;
            };
        }

        override public function addFace(_arg_1:Vector.<Vertex>, _arg_2:Material=null, _arg_3:Object=null):Face
        {
            this.clearLocal();
            return (super.addFace(_arg_1, _arg_2, _arg_3));
        }

        override public function addFaceByIds(_arg_1:Array, _arg_2:Material=null, _arg_3:Object=null):Face
        {
            this.clearLocal();
            return (super.addFaceByIds(_arg_1, _arg_2, _arg_3));
        }

        override public function addTriFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Material=null, _arg_5:Object=null):Face
        {
            this.clearLocal();
            return (super.addTriFace(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5));
        }

        override public function addQuadFace(_arg_1:Vertex, _arg_2:Vertex, _arg_3:Vertex, _arg_4:Vertex, _arg_5:Material=null, _arg_6:Object=null):Face
        {
            this.clearLocal();
            return (super.addQuadFace(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6));
        }

        override public function removeFace(_arg_1:Face):Face
        {
            this.clearLocal();
            return (super.removeFace(_arg_1));
        }

        override public function removeFaceById(_arg_1:Object):Face
        {
            this.clearLocal();
            return (super.removeFaceById(_arg_1));
        }

        override public function addVerticesAndFaces(_arg_1:Vector.<Number>, _arg_2:Vector.<Number>, _arg_3:Vector.<int>, _arg_4:Boolean=false, _arg_5:Material=null):void
        {
            this.clearLocal();
            super.addVerticesAndFaces(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        override public function weldVertices(_arg_1:Number=0, _arg_2:Number=0):void
        {
            var _local_3:Vertex;
            var _local_5:*;
            var _local_6:Joint;
            this.clearLocal();
            var _local_4:Dictionary = new Dictionary();
            _local_3 = vertexList;
            while (_local_3 != null)
            {
                _local_4[_local_3] = true;
                _local_3 = _local_3.next;
            };
            super.weldVertices(_arg_1, _arg_2);
            _local_3 = vertexList;
            while (_local_3 != null)
            {
                delete _local_4[_local_3];
                _local_3 = _local_3.next;
            };
            for (_local_5 in _local_4)
            {
                _local_3 = _local_5;
                _local_6 = this.jointList;
                while (_local_6 != null)
                {
                    this.unbindVertex(_local_6, _local_3);
                    _local_6 = _local_6.nextJoint;
                };
            };
        }

        override public function weldFaces(_arg_1:Number=0, _arg_2:Number=0, _arg_3:Number=0, _arg_4:Boolean=false):void
        {
            this.clearLocal();
            super.weldFaces(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function optimizeForDynamicBSP(_arg_1:int=1):void
        {
            this.clearLocal();
            super.optimizeForDynamicBSP(_arg_1);
        }

        public function calculateBindingMatrices():void
        {
            ma = 1;
            mb = 0;
            mc = 0;
            md = 0;
            me = 0;
            mf = 1;
            mg = 0;
            mh = 0;
            mi = 0;
            mj = 0;
            mk = 1;
            ml = 0;
            var _local_1:Joint = this.jointList;
            while (_local_1 != null)
            {
                _local_1.calculateBindingMatrix(this);
                _local_1 = _local_1.nextJoint;
            };
        }

        public function normalizeWeights():void
        {
            var _local_2:Joint;
            var _local_1:Vertex = vertexList;
            while (_local_1 != null)
            {
                _local_1.offset = 0;
                _local_1 = _local_1.next;
            };
            _local_2 = this.jointList;
            while (_local_2 != null)
            {
                _local_2.addWeights();
                _local_2 = _local_2.nextJoint;
            };
            _local_2 = this.jointList;
            while (_local_2 != null)
            {
                _local_2.normalizeWeights();
                _local_2 = _local_2.nextJoint;
            };
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            var _local_7:Face;
            var _local_8:Face;
            if (((!(_arg_3 == null)) && (_arg_3[this])))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            this.updateLocal();
            var _local_5:Face = faceList;
            faceList = this.localList;
            calculateFacesNormals(true);
            var _local_6:RayIntersectionData = super.intersectRay(_arg_1, _arg_2, _arg_3, _arg_4);
            faceList = _local_5;
            if (_local_6 != null)
            {
                _local_7 = faceList;
                _local_8 = this.localList;
                while (_local_7 != null)
                {
                    if (_local_8 == _local_6.face)
                    {
                        _local_6.face = _local_7;
                        break;
                    };
                    _local_7 = _local_7.next;
                    _local_8 = _local_8.next;
                };
            };
            return (_local_6);
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            this.updateLocal();
            var _local_9:Face = faceList;
            faceList = this.localList;
            calculateFacesNormals(true);
            var _local_10:Boolean = super.checkIntersection(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            faceList = _local_9;
            return (_local_10);
        }

        override alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
            if (((!(_arg_7 == null)) && (_arg_7[this])))
            {
                return;
            };
            var _local_8:Vector3D = calculateSphere(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if ((!(boundIntersectSphere(_local_8, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return;
            };
            var _local_9:Face = faceList;
            faceList = this.localList;
            calculateFacesNormals(true);
            super.collectPlanes(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            faceList = _local_9;
        }

        public function attach(_arg_1:Skin):void
        {
            var _local_3:Vertex;
            var _local_4:Face;
            var _local_5:Joint;
            this.clearLocal();
            _arg_1.clearLocal();
            if (vertexList == null)
            {
                vertexList = _arg_1.vertexList;
            } else
            {
                _local_3 = vertexList;
                while (_local_3.next != null)
                {
                    _local_3 = _local_3.next;
                };
                _local_3.next = _arg_1.vertexList;
            };
            _arg_1.vertexList = null;
            if (faceList == null)
            {
                faceList = _arg_1.faceList;
            } else
            {
                _local_4 = faceList;
                while (_local_4.next != null)
                {
                    _local_4 = _local_4.next;
                };
                _local_4.next = _arg_1.faceList;
            };
            _arg_1.faceList = null;
            var _local_2:Joint = _arg_1.jointList;
            while (_local_2 != null)
            {
                if (((_local_2.name == null) || (_local_2.name == "")))
                {
                    this.addJointFast(_local_2);
                } else
                {
                    _local_5 = this.getJointByName(_local_2.name);
                    if (_local_5 != null)
                    {
                        this.mergeJoints(_local_2, _local_5);
                    } else
                    {
                        this.addJointFast(_local_2);
                    };
                };
                _local_2 = _local_2.nextJoint;
            };
            _arg_1.jointList = null;
        }

        private function addJointFast(_arg_1:Joint):Joint
        {
            var _local_2:Joint;
            _arg_1._parentJoint = null;
            _arg_1.setSkinFast(this);
            if (this.jointList == null)
            {
                this.jointList = _arg_1;
            } else
            {
                _local_2 = this.jointList;
                while (_local_2 != null)
                {
                    if (_local_2.nextJoint == null)
                    {
                        _local_2.nextJoint = _arg_1;
                        break;
                    };
                    _local_2 = _local_2.nextJoint;
                };
            };
            return (_arg_1);
        }

        private function mergeJoints(_arg_1:Joint, _arg_2:Joint):void
        {
            var _local_5:Joint;
            var _local_3:VertexBinding = _arg_1.vertexBindingList;
            if (_local_3 != null)
            {
                while (_local_3.next != null)
                {
                    _local_3 = _local_3.next;
                };
                _local_3.next = _arg_2.vertexBindingList;
                _arg_2.vertexBindingList = _arg_1.vertexBindingList;
            };
            _arg_1.vertexBindingList = null;
            var _local_4:Joint = _arg_1.childrenList;
            while (_local_4 != null)
            {
                if (((_local_4.name == null) || (_local_4.name.length == 0)))
                {
                    _arg_2.addChildFast(_local_4);
                } else
                {
                    _local_5 = this.findJointChildByName(_local_4.name, _arg_2);
                    if (_local_5 != null)
                    {
                        this.mergeJoints(_local_4, _local_5);
                    } else
                    {
                        _arg_2.addChildFast(_local_4);
                    };
                };
                _local_4 = _local_4.nextJoint;
            };
            _arg_1.childrenList = null;
        }

        private function findJointChildByName(_arg_1:String, _arg_2:Joint):Joint
        {
            var _local_3:Joint = _arg_2.childrenList;
            while (_local_3 != null)
            {
                if (_local_3.name == _arg_1)
                {
                    return (_local_3);
                };
                _local_3 = _local_3.nextJoint;
            };
            return (null);
        }

        override public function clone():Object3D
        {
            this.clearLocal();
            var _local_1:Skin = new Skin();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_6:Joint;
            var _local_7:Joint;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Skin = (_arg_1 as Skin);
            _local_3 = _local_2.vertexList;
            _local_4 = vertexList;
            while (_local_3 != null)
            {
                _local_3.value = _local_4;
                _local_3 = _local_3.next;
                _local_4 = _local_4.next;
            };
            var _local_5:Joint = _local_2.jointList;
            while (_local_5 != null)
            {
                _local_7 = this.cloneJoint(_local_5);
                if (this.jointList != null)
                {
                    _local_6.nextJoint = _local_7;
                } else
                {
                    this.jointList = _local_7;
                };
                _local_6 = _local_7;
                _local_7._parentJoint = null;
                _local_7.setSkinFast(this);
                _local_5 = _local_5.nextJoint;
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
            var _local_4:Vertex;
            var _local_5:Joint;
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
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_2 & Debug.BOUNDS))
            {
                Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
            };
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
            var _local_3:Face = this.prepareFaces(_arg_1, this.localList);
            if (_local_3 == null)
            {
                return;
            };
            if (culling > 0)
            {
                if (clipping == 1)
                {
                    _local_3 = _arg_1.cull(_local_3, culling);
                } else
                {
                    _local_3 = _arg_1.clip(_local_3, culling);
                };
                if (_local_3 == null)
                {
                    return;
                };
            };
            if (_local_3.processNext != null)
            {
                if (sorting == 1)
                {
                    _local_3 = _arg_1.sortByAverageZ(_local_3);
                } else
                {
                    if (sorting == 2)
                    {
                        _local_3 = _arg_1.sortByDynamicBSP(_local_3, threshold);
                    };
                };
            };
            if ((_local_2 & Debug.BONES))
            {
                _local_5 = this.jointList;
                while (_local_5 != null)
                {
                    _local_5.drawDebug(_arg_1);
                    _local_5 = _local_5.nextJoint;
                };
            };
            if ((_local_2 & Debug.EDGES))
            {
                Debug.drawEdges(_arg_1, _local_3, 0xFFFFFF);
            };
            drawFaces(_arg_1, _local_3);
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_4:Joint;
            var _local_5:Vertex;
            var _local_6:Face;
            var _local_7:Face;
            var _local_8:Face;
            if (faceList == null)
            {
                return (null);
            };
            if (clipping == 0)
            {
                if ((culling & 0x01))
                {
                    return (null);
                };
                culling = 0;
            };
            var _local_2:int = ((_arg_1.debug) ? _arg_1.checkInDebug(this) : 0);
            if ((_local_2 & Debug.BONES))
            {
                _local_4 = this.jointList;
                while (_local_4 != null)
                {
                    _local_4.drawDebug(_arg_1);
                    _local_4 = _local_4.nextJoint;
                };
            };
            if (transformId > 0x1DCD6500)
            {
                transformId = 0;
                _local_5 = vertexList;
                while (_local_5 != null)
                {
                    _local_5.transformId = 0;
                    _local_5 = _local_5.next;
                };
            };
            transformId++;
            calculateInverseMatrix();
            var _local_3:Face = this.prepareFaces(_arg_1, this.localList);
            if (_local_3 == null)
            {
                return (null);
            };
            if (culling > 0)
            {
                if (clipping == 1)
                {
                    _local_3 = _arg_1.cull(_local_3, culling);
                } else
                {
                    _local_3 = _arg_1.clip(_local_3, culling);
                };
                if (_local_3 == null)
                {
                    return (null);
                };
            };
            if (((concatenatedAlpha >= 1) && (concatenatedBlendMode == "normal")))
            {
                _local_8 = null;
                _local_6 = _local_3;
                _local_3 = null;
                while (_local_6 != null)
                {
                    _local_7 = _local_6.processNext;
                    if (((!(_local_6.material == null)) && (!(_local_6.material.transparent))))
                    {
                        _local_6.processNext = _local_8;
                        _local_8 = _local_6;
                    } else
                    {
                        _local_6.processNext = _local_3;
                        _local_3 = _local_6;
                    };
                    _local_6 = _local_7;
                };
                _local_6 = _local_8;
                while (_local_6 != null)
                {
                    _local_7 = _local_6.processNext;
                    if (((_local_7 == null) || (!(_local_7.material == _local_8.material))))
                    {
                        _local_6.processNext = null;
                        _arg_1.addTransparentOpaque(_local_8, this);
                        _local_8 = _local_7;
                    };
                    _local_6 = _local_7;
                };
                if (_local_3 == null)
                {
                    return (null);
                };
            };
            return (VG.create(this, _local_3, sorting, _local_2, false));
        }

        override alternativa3d function prepareFaces(_arg_1:Camera3D, _arg_2:Face):Face
        {
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            this.updateLocal();
            var _local_3:Face = _arg_2;
            while (_local_3 != null)
            {
                _local_4 = _local_3.wrapper;
                _local_5 = _local_4.vertex;
                _local_4 = _local_4.next;
                _local_6 = _local_4.vertex;
                _local_4 = _local_4.next;
                _local_7 = _local_4.vertex;
                _local_8 = (_local_6.x - _local_5.x);
                _local_9 = (_local_6.y - _local_5.y);
                _local_10 = (_local_6.z - _local_5.z);
                _local_11 = (_local_7.x - _local_5.x);
                _local_12 = (_local_7.y - _local_5.y);
                _local_13 = (_local_7.z - _local_5.z);
                _local_14 = ((_local_13 * _local_9) - (_local_12 * _local_10));
                _local_15 = ((_local_11 * _local_10) - (_local_13 * _local_8));
                _local_16 = ((_local_12 * _local_8) - (_local_11 * _local_9));
                _local_3.normalX = _local_14;
                _local_3.normalY = _local_15;
                _local_3.normalZ = _local_16;
                _local_3.offset = (((_local_5.x * _local_14) + (_local_5.y * _local_15)) + (_local_5.z * _local_16));
                _local_3 = _local_3.next;
            };
            return (super.prepareFaces(_arg_1, _arg_2));
        }

        override alternativa3d function prepareResources():void
        {
        }

        override alternativa3d function deleteResources():void
        {
        }

        alternativa3d function updateLocal():void
        {
            var _local_1:Vertex;
            var _local_2:Face;
            var _local_3:Face;
            var _local_6:Face;
            var _local_7:Wrapper;
            var _local_8:Wrapper;
            var _local_9:Wrapper;
            var _local_10:Material;
            var _local_11:Vertex;
            if (this.localList == null)
            {
                _local_1 = vertexList;
                while (_local_1 != null)
                {
                    _local_1.value = new Vertex();
                    _local_1 = _local_1.next;
                };
                _local_2 = faceList;
                while (_local_2 != null)
                {
                    _local_3 = new Face();
                    _local_7 = null;
                    _local_8 = _local_2.wrapper;
                    while (_local_8 != null)
                    {
                        _local_9 = new Wrapper();
                        _local_9.vertex = _local_8.vertex.value;
                        if (_local_7 != null)
                        {
                            _local_7.next = _local_9;
                        } else
                        {
                            _local_3.wrapper = _local_9;
                        };
                        _local_7 = _local_9;
                        _local_8 = _local_8.next;
                    };
                    if (_local_6 != null)
                    {
                        _local_6.next = _local_3;
                    } else
                    {
                        this.localList = _local_3;
                    };
                    _local_6 = _local_3;
                    _local_2 = _local_2.next;
                };
            };
            var _local_4:Boolean;
            _local_2 = faceList;
            _local_3 = this.localList;
            while (_local_2 != null)
            {
                _local_10 = _local_2.material;
                _local_4 = ((_local_4) || ((!(_local_10 == null)) && (_local_10.useVerticesNormals)));
                _local_3.material = _local_2.material;
                _local_2 = _local_2.next;
                _local_3 = _local_3.next;
            };
            _local_1 = vertexList;
            while (_local_1 != null)
            {
                _local_11 = _local_1.value;
                _local_11.x = 0;
                _local_11.y = 0;
                _local_11.z = 0;
                _local_11.u = _local_1.u;
                _local_11.v = _local_1.v;
                _local_11.normalX = 0;
                _local_11.normalY = 0;
                _local_11.normalZ = 0;
                _local_11.drawId = 0;
                _local_1 = _local_1.next;
            };
            var _local_5:Joint = this.jointList;
            while (_local_5 != null)
            {
                _local_5.composeMatrix();
                _local_5.calculateVertices(_local_4, false);
                _local_5 = _local_5.nextJoint;
            };
        }

        alternativa3d function clearLocal():void
        {
            var _local_1:Vertex = vertexList;
            while (_local_1 != null)
            {
                _local_1.value = null;
                _local_1 = _local_1.next;
            };
            this.localList = null;
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            this.updateLocal();
            var _local_3:Face = faceList;
            faceList = this.localList;
            super.updateBounds(_arg_1, _arg_2);
            faceList = _local_3;
        }

        override alternativa3d function split(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):Vector.<Object3D>
        {
            return (new Vector.<Object3D>(2));
        }

        private function cloneJoint(_arg_1:Joint):Joint
        {
            var _local_3:VertexBinding;
            var _local_6:Joint;
            var _local_7:VertexBinding;
            var _local_8:Joint;
            var _local_2:Joint = new Joint();
            _local_2.name = _arg_1.name;
            _local_2.x = _arg_1.x;
            _local_2.y = _arg_1.y;
            _local_2.z = _arg_1.z;
            _local_2.rotationX = _arg_1.rotationX;
            _local_2.rotationY = _arg_1.rotationY;
            _local_2.rotationZ = _arg_1.rotationZ;
            _local_2.scaleX = _arg_1.scaleX;
            _local_2.scaleY = _arg_1.scaleY;
            _local_2.scaleZ = _arg_1.scaleZ;
            _local_2.bma = _arg_1.bma;
            _local_2.bmb = _arg_1.bmb;
            _local_2.bmc = _arg_1.bmc;
            _local_2.bmd = _arg_1.bmd;
            _local_2.bme = _arg_1.bme;
            _local_2.bmf = _arg_1.bmf;
            _local_2.bmg = _arg_1.bmg;
            _local_2.bmh = _arg_1.bmh;
            _local_2.bmi = _arg_1.bmi;
            _local_2.bmj = _arg_1.bmj;
            _local_2.bmk = _arg_1.bmk;
            _local_2.bml = _arg_1.bml;
            if ((_arg_1 is Bone))
            {
                Bone(_local_2).length = Bone(_arg_1).length;
                Bone(_local_2).distance = Bone(_arg_1).distance;
                Bone(_local_2).lx = Bone(_arg_1).lx;
                Bone(_local_2).ly = Bone(_arg_1).ly;
                Bone(_local_2).lz = Bone(_arg_1).lz;
                Bone(_local_2).ldot = Bone(_arg_1).ldot;
            };
            var _local_4:VertexBinding = _arg_1.vertexBindingList;
            while (_local_4 != null)
            {
                _local_7 = new VertexBinding();
                _local_7.vertex = _local_4.vertex.value;
                _local_7.weight = _local_4.weight;
                if (_local_3 != null)
                {
                    _local_3.next = _local_7;
                } else
                {
                    _local_2.vertexBindingList = _local_7;
                };
                _local_3 = _local_7;
                _local_4 = _local_4.next;
            };
            var _local_5:Joint = _arg_1.childrenList;
            while (_local_5 != null)
            {
                _local_8 = this.cloneJoint(_local_5);
                if (_local_2.childrenList != null)
                {
                    _local_6.nextJoint = _local_8;
                } else
                {
                    _local_2.childrenList = _local_8;
                };
                _local_6 = _local_8;
                _local_8._parentJoint = _local_2;
                _local_5 = _local_5.nextJoint;
            };
            return (_local_2);
        }


    }
}//package alternativa.engine3d.objects