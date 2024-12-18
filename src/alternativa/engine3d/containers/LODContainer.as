package alternativa.engine3d.containers
{
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.Object3D;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.RayIntersectionData;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class LODContainer extends Object3DContainer 
    {


        public function getChildDistance(_arg_1:Object3D):Number
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parent != this)
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            return (_arg_1.distance);
        }

        public function setChildDistance(_arg_1:Object3D, _arg_2:Number):void
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parent != this)
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            _arg_1.distance = _arg_2;
        }

        public function addLOD(_arg_1:Object3D, _arg_2:Number):Object3D
        {
            this.addChild(_arg_1);
            _arg_1.distance = _arg_2;
            return (_arg_1);
        }

        override public function addChild(_arg_1:Object3D):Object3D
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1 == this)
            {
                throw (new ArgumentError("An object cannot be added as a child of itself."));
            };
            var _local_2:Object3DContainer = _parent;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    throw (new ArgumentError("An object cannot be added as a child to one of it's children (or children's children, etc.)."));
                };
                _local_2 = _local_2._parent;
            };
            if (_arg_1._parent != this)
            {
                _arg_1.distance = 0;
            };
            if (_arg_1._parent != null)
            {
                _arg_1._parent.removeChild(_arg_1);
            };
            addToList(_arg_1);
            return (_arg_1);
        }

        override public function addChildAt(_arg_1:Object3D, _arg_2:int):Object3D
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1 == this)
            {
                throw (new ArgumentError("An object cannot be added as a child of itself."));
            };
            if (_arg_2 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_3:Object3DContainer = _parent;
            while (_local_3 != null)
            {
                if (_local_3 == _arg_1)
                {
                    throw (new ArgumentError("An object cannot be added as a child to one of it's children (or children's children, etc.)."));
                };
                _local_3 = _local_3._parent;
            };
            var _local_4:Object3D = childrenList;
            var _local_5:int;
            while (_local_5 < _arg_2)
            {
                if (_local_4 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_4 = _local_4.next;
                _local_5++;
            };
            if (_arg_1._parent != this)
            {
                _arg_1.distance = 0;
            };
            if (_arg_1._parent != null)
            {
                _arg_1._parent.removeChild(_arg_1);
            };
            addToList(_arg_1, _local_4);
            return (_arg_1);
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            if (((!(_arg_3 == null)) && (_arg_3[this])))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            var _local_5:Object3D = childrenList;
            _local_5.composeMatrix();
            _local_5.invertMatrix();
            var _local_6:Vector3D = new Vector3D();
            var _local_7:Vector3D = new Vector3D();
            _local_6.x = ((((_local_5.ma * _arg_1.x) + (_local_5.mb * _arg_1.y)) + (_local_5.mc * _arg_1.z)) + _local_5.md);
            _local_6.y = ((((_local_5.me * _arg_1.x) + (_local_5.mf * _arg_1.y)) + (_local_5.mg * _arg_1.z)) + _local_5.mh);
            _local_6.z = ((((_local_5.mi * _arg_1.x) + (_local_5.mj * _arg_1.y)) + (_local_5.mk * _arg_1.z)) + _local_5.ml);
            _local_7.x = (((_local_5.ma * _arg_2.x) + (_local_5.mb * _arg_2.y)) + (_local_5.mc * _arg_2.z));
            _local_7.y = (((_local_5.me * _arg_2.x) + (_local_5.mf * _arg_2.y)) + (_local_5.mg * _arg_2.z));
            _local_7.z = (((_local_5.mi * _arg_2.x) + (_local_5.mj * _arg_2.y)) + (_local_5.mk * _arg_2.z));
            return (_local_5.intersectRay(_local_6, _local_7, _arg_3, _arg_4));
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_9:Object3D = childrenList;
            if (((!(_arg_8 == null)) && (!(_arg_8[_local_9]))))
            {
                _local_9.composeMatrix();
                _local_9.invertMatrix();
                _local_10 = ((((_local_9.ma * _arg_1) + (_local_9.mb * _arg_2)) + (_local_9.mc * _arg_3)) + _local_9.md);
                _local_11 = ((((_local_9.me * _arg_1) + (_local_9.mf * _arg_2)) + (_local_9.mg * _arg_3)) + _local_9.mh);
                _local_12 = ((((_local_9.mi * _arg_1) + (_local_9.mj * _arg_2)) + (_local_9.mk * _arg_3)) + _local_9.ml);
                _local_13 = (((_local_9.ma * _arg_4) + (_local_9.mb * _arg_5)) + (_local_9.mc * _arg_6));
                _local_14 = (((_local_9.me * _arg_4) + (_local_9.mf * _arg_5)) + (_local_9.mg * _arg_6));
                _local_15 = (((_local_9.mi * _arg_4) + (_local_9.mj * _arg_5)) + (_local_9.mk * _arg_6));
                return ((boundCheckIntersection(_local_10, _local_11, _local_12, _local_13, _local_14, _local_15, _arg_7, _local_9.boundMinX, _local_9.boundMinY, _local_9.boundMinZ, _local_9.boundMaxX, _local_9.boundMaxY, _local_9.boundMaxZ)) && (_local_9.checkIntersection(_local_10, _local_11, _local_12, _local_13, _local_14, _local_15, _arg_7, _arg_8)));
            };
            return (false);
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
            var _local_9:Object3D = childrenList;
            _local_9.composeAndAppend(this);
            _local_9.collectPlanes(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        override public function clone():Object3D
        {
            var _local_1:LODContainer = new LODContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_3:int;
            var _local_2:Object3D = this.getLODObject(_arg_1);
            if (((!(_local_2 == null)) && (_local_2.visible)))
            {
                _local_2.composeAndAppend(this);
                if (_local_2.cullingInCamera(_arg_1, culling) >= 0)
                {
                    if (((_arg_1.debug) && ((_local_3 = _arg_1.checkInDebug(this)) > 0)))
                    {
                        if ((_local_3 & Debug.BOUNDS))
                        {
                            Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                        };
                    };
                    _local_2.draw(_arg_1);
                };
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_2:Object3D = this.getLODObject(_arg_1);
            if (((!(_local_2 == null)) && (_local_2.visible)))
            {
                _local_2.composeAndAppend(this);
                if (_local_2.cullingInCamera(_arg_1, culling) >= 0)
                {
                    _local_2.concat(this);
                    return (_local_2.getVG(_arg_1));
                };
            };
            return (null);
        }

        private function getLODObject(_arg_1:Camera3D):Object3D
        {
            var _local_6:Object3D;
            var _local_8:Number;
            var _local_2:Number = ((md * _arg_1.viewSizeX) / _arg_1.focalLength);
            var _local_3:Number = ((mh * _arg_1.viewSizeY) / _arg_1.focalLength);
            var _local_4:Number = Math.sqrt((((_local_2 * _local_2) + (_local_3 * _local_3)) + (ml * ml)));
            var _local_5:Number = 1E22;
            var _local_7:Object3D = childrenList;
            while (_local_7 != null)
            {
                _local_8 = (_local_7.distance - _local_4);
                if (((_local_8 > 0) && (_local_8 < _local_5)))
                {
                    _local_5 = _local_8;
                    _local_6 = _local_7;
                };
                _local_7 = _local_7.next;
            };
            return (_local_6);
        }


    }
}//package alternativa.engine3d.containers