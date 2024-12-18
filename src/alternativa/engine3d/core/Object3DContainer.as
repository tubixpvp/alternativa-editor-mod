package alternativa.engine3d.core
{
    import __AS3__.vec.Vector;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Object3DContainer extends Object3D 
    {

        public var mouseChildren:Boolean = true;
        public var childrenList:Object3D;
        alternativa3d var lightList:Light3D;
        alternativa3d var visibleChildren:Vector.<Object3D> = new Vector.<Object3D>();
        alternativa3d var numVisibleChildren:int = 0;


        public function get children() : Vector.<Object3D>
        {
            var objects:Vector.<Object3D> = new Vector.<Object3D>();
            
            var child:Object3D = childrenList;

            while(child != null)
            {
                objects.push(child);

                child = child.next;
            }

            return objects;
        }

        public function addChild(_arg_1:Object3D):Object3D
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
            if (_arg_1._parent != null)
            {
                _arg_1._parent.removeChild(_arg_1);
            };
            this.addToList(_arg_1);
            return (_arg_1);
        }

        public function removeChild(_arg_1:Object3D):Object3D
        {
            var _local_2:Object3D;
            var _local_3:Object3D;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parent != this)
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            _local_3 = this.childrenList;
            while (_local_3 != null)
            {
                if (_local_3 == _arg_1)
                {
                    if (_local_2 != null)
                    {
                        _local_2.next = _local_3.next;
                    } else
                    {
                        this.childrenList = _local_3.next;
                    };
                    _local_3.next = null;
                    _local_3.setParent(null);
                    return (_arg_1);
                };
                _local_2 = _local_3;
                _local_3 = _local_3.next;
            };
            throw (new ArgumentError("Cannot remove child."));
        }

        public function addChildAt(_arg_1:Object3D, _arg_2:int):Object3D
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
            var _local_4:Object3D = this.childrenList;
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
            if (_arg_1._parent != null)
            {
                _arg_1._parent.removeChild(_arg_1);
            };
            this.addToList(_arg_1, _local_4);
            return (_arg_1);
        }

        public function removeChildAt(_arg_1:int):Object3D
        {
            if (_arg_1 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_2:Object3D = this.childrenList;
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                if (_local_2 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_2 = _local_2.next;
                _local_3++;
            };
            if (_local_2 == null)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            this.removeChild(_local_2);
            return (_local_2);
        }

        public function getChildAt(_arg_1:int):Object3D
        {
            if (_arg_1 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_2:Object3D = this.childrenList;
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                if (_local_2 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_2 = _local_2.next;
                _local_3++;
            };
            if (_local_2 == null)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            return (_local_2);
        }

        public function getChildIndex(_arg_1:Object3D):int
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parent != this)
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            var _local_2:int;
            var _local_3:Object3D = this.childrenList;
            while (_local_3 != null)
            {
                if (_local_3 == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
                _local_3 = _local_3.next;
            };
            throw (new ArgumentError("Cannot get child index."));
        }

        public function setChildIndex(_arg_1:Object3D, _arg_2:int):void
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parent != this)
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            if (_arg_2 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_3:Object3D = this.childrenList;
            var _local_4:int;
            while (_local_4 < _arg_2)
            {
                if (_local_3 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_3 = _local_3.next;
                _local_4++;
            };
            this.removeChild(_arg_1);
            this.addToList(_arg_1, _local_3);
        }

        public function swapChildren(_arg_1:Object3D, _arg_2:Object3D):void
        {
            var _local_3:Object3D;
            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (((!(_arg_1._parent == this)) || (!(_arg_2._parent == this))))
            {
                throw (new ArgumentError("The supplied Object3D must be a child of the caller."));
            };
            if (_arg_1 != _arg_2)
            {
                if (_arg_1.next == _arg_2)
                {
                    this.removeChild(_arg_2);
                    this.addToList(_arg_2, _arg_1);
                } else
                {
                    if (_arg_2.next == _arg_1)
                    {
                        this.removeChild(_arg_1);
                        this.addToList(_arg_1, _arg_2);
                    } else
                    {
                        _local_3 = _arg_1.next;
                        this.removeChild(_arg_1);
                        this.addToList(_arg_1, _arg_2);
                        this.removeChild(_arg_2);
                        this.addToList(_arg_2, _local_3);
                    };
                };
            };
        }

        public function swapChildrenAt(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:Object3D;
            var _local_5:Object3D;
            var _local_6:Object3D;
            if (((_arg_1 < 0) || (_arg_2 < 0)))
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            if (_arg_1 != _arg_2)
            {
                _local_4 = this.childrenList;
                _local_3 = 0;
                while (_local_3 < _arg_1)
                {
                    if (_local_4 == null)
                    {
                        throw (new RangeError("The supplied index is out of bounds."));
                    };
                    _local_4 = _local_4.next;
                    _local_3++;
                };
                if (_local_4 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                _local_5 = this.childrenList;
                _local_3 = 0;
                while (_local_3 < _arg_2)
                {
                    if (_local_5 == null)
                    {
                        throw (new RangeError("The supplied index is out of bounds."));
                    };
                    _local_5 = _local_5.next;
                    _local_3++;
                };
                if (_local_5 == null)
                {
                    throw (new RangeError("The supplied index is out of bounds."));
                };
                if (_local_4 != _local_5)
                {
                    if (_local_4.next == _local_5)
                    {
                        this.removeChild(_local_5);
                        this.addToList(_local_5, _local_4);
                    } else
                    {
                        if (_local_5.next == _local_4)
                        {
                            this.removeChild(_local_4);
                            this.addToList(_local_4, _local_5);
                        } else
                        {
                            _local_6 = _local_4.next;
                            this.removeChild(_local_4);
                            this.addToList(_local_4, _local_5);
                            this.removeChild(_local_5);
                            this.addToList(_local_5, _local_6);
                        };
                    };
                };
            };
        }

        public function getChildByName(_arg_1:String):Object3D
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter name must be non-null."));
            };
            var _local_2:Object3D = this.childrenList;
            while (_local_2 != null)
            {
                if (_local_2.name == _arg_1)
                {
                    return (_local_2);
                };
                _local_2 = _local_2.next;
            };
            return (null);
        }

        public function contains(_arg_1:Object3D):Boolean
        {
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1 == this)
            {
                return (true);
            };
            var _local_2:Object3D = this.childrenList;
            while (_local_2 != null)
            {
                if ((_local_2 is Object3DContainer))
                {
                    if ((_local_2 as Object3DContainer).contains(_arg_1))
                    {
                        return (true);
                    };
                } else
                {
                    if (_local_2 == _arg_1)
                    {
                        return (true);
                    };
                };
                _local_2 = _local_2.next;
            };
            return (false);
        }

        public function get numChildren():int
        {
            var _local_1:int;
            var _local_2:Object3D = this.childrenList;
            while (_local_2 != null)
            {
                _local_1++;
                _local_2 = _local_2.next;
            };
            return (_local_1);
        }

        override public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            var _local_5:Vector3D;
            var _local_6:Vector3D;
            var _local_7:RayIntersectionData;
            var _local_10:RayIntersectionData;
            if (((!(_arg_3 == null)) && (_arg_3[this])))
            {
                return (null);
            };
            if ((!(boundIntersectRay(_arg_1, _arg_2, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ))))
            {
                return (null);
            };
            var _local_8:Number = 1E22;
            var _local_9:Object3D = this.childrenList;
            while (_local_9 != null)
            {
                _local_9.composeMatrix();
                _local_9.invertMatrix();
                if (_local_5 == null)
                {
                    _local_5 = new Vector3D();
                    _local_6 = new Vector3D();
                };
                _local_5.x = ((((_local_9.ma * _arg_1.x) + (_local_9.mb * _arg_1.y)) + (_local_9.mc * _arg_1.z)) + _local_9.md);
                _local_5.y = ((((_local_9.me * _arg_1.x) + (_local_9.mf * _arg_1.y)) + (_local_9.mg * _arg_1.z)) + _local_9.mh);
                _local_5.z = ((((_local_9.mi * _arg_1.x) + (_local_9.mj * _arg_1.y)) + (_local_9.mk * _arg_1.z)) + _local_9.ml);
                _local_6.x = (((_local_9.ma * _arg_2.x) + (_local_9.mb * _arg_2.y)) + (_local_9.mc * _arg_2.z));
                _local_6.y = (((_local_9.me * _arg_2.x) + (_local_9.mf * _arg_2.y)) + (_local_9.mg * _arg_2.z));
                _local_6.z = (((_local_9.mi * _arg_2.x) + (_local_9.mj * _arg_2.y)) + (_local_9.mk * _arg_2.z));
                _local_10 = _local_9.intersectRay(_local_5, _local_6, _arg_3, _arg_4);
                if (((!(_local_10 == null)) && (_local_10.time < _local_8)))
                {
                    _local_8 = _local_10.time;
                    _local_7 = _local_10;
                };
                _local_9 = _local_9.next;
            };
            return (_local_7);
        }

        override alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_9:Object3D = this.childrenList;
            while (_local_9 != null)
            {
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
                    if (((boundCheckIntersection(_local_10, _local_11, _local_12, _local_13, _local_14, _local_15, _arg_7, _local_9.boundMinX, _local_9.boundMinY, _local_9.boundMinZ, _local_9.boundMaxX, _local_9.boundMaxY, _local_9.boundMaxZ)) && (_local_9.checkIntersection(_local_10, _local_11, _local_12, _local_13, _local_14, _local_15, _arg_7, _arg_8))))
                    {
                        return (true);
                    };
                };
                _local_9 = _local_9.next;
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
            var _local_9:Object3D = this.childrenList;
            while (_local_9 != null)
            {
                _local_9.composeAndAppend(this);
                _local_9.collectPlanes(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
                _local_9 = _local_9.next;
            };
        }

        override public function clone():Object3D
        {
            var _local_1:Object3DContainer = new Object3DContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_4:Object3D;
            var _local_5:Object3D;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Object3DContainer = (_arg_1 as Object3DContainer);
            this.mouseChildren = _local_2.mouseChildren;
            var _local_3:Object3D = _local_2.childrenList;
            while (_local_3 != null)
            {
                _local_5 = _local_3.clone();
                if (this.childrenList != null)
                {
                    _local_4.next = _local_5;
                } else
                {
                    this.childrenList = _local_5;
                };
                _local_4 = _local_5;
                _local_5.setParent(this);
                _local_3 = _local_3.next;
            };
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:int;
            this.numVisibleChildren = 0;
            var _local_3:Object3D = this.childrenList;
            while (_local_3 != null)
            {
                if (_local_3.visible)
                {
                    _local_3.composeAndAppend(this);
                    if (_local_3.cullingInCamera(_arg_1, culling) >= 0)
                    {
                        _local_3.concat(this);
                        this.visibleChildren[this.numVisibleChildren] = _local_3;
                        this.numVisibleChildren++;
                    };
                };
                _local_3 = _local_3.next;
            };
            if (this.numVisibleChildren > 0)
            {
                if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                {
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
                this.drawVisibleChildren(_arg_1);
            };
        }

        alternativa3d function drawVisibleChildren(_arg_1:Camera3D):void
        {
            var _local_3:Object3D;
            var _local_2:int = (this.numVisibleChildren - 1);
            while (_local_2 >= 0)
            {
                _local_3 = this.visibleChildren[_local_2];
                _local_3.draw(_arg_1);
                this.visibleChildren[_local_2] = null;
                _local_2--;
            };
        }

        override alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            var _local_2:VG;
            var _local_3:VG;
            var _local_5:VG;
            var _local_4:Object3D = this.childrenList;
            while (_local_4 != null)
            {
                if (_local_4.visible)
                {
                    _local_4.composeAndAppend(this);
                    if (_local_4.cullingInCamera(_arg_1, culling) >= 0)
                    {
                        _local_4.concat(this);
                        _local_5 = _local_4.getVG(_arg_1);
                        if (_local_5 != null)
                        {
                            if (_local_2 != null)
                            {
                                _local_3.next = _local_5;
                            } else
                            {
                                _local_2 = _local_5;
                                _local_3 = _local_5;
                            };
                            while (_local_3.next != null)
                            {
                                _local_3 = _local_3.next;
                            };
                        };
                    };
                };
                _local_4 = _local_4.next;
            };
            return (_local_2);
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            var _local_3:Object3D = this.childrenList;
            while (_local_3 != null)
            {
                if (_arg_2 != null)
                {
                    _local_3.composeAndAppend(_arg_2);
                } else
                {
                    _local_3.composeMatrix();
                };
                _local_3.updateBounds(_arg_1, _local_3);
                _local_3 = _local_3.next;
            };
        }

        override alternativa3d function split(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):Vector.<Object3D>
        {
            var _local_10:Object3D;
            var _local_11:Object3D;
            var _local_13:Object3D;
            var _local_14:Vector3D;
            var _local_15:Vector3D;
            var _local_16:Vector3D;
            var _local_17:int;
            var _local_18:Vector.<Object3D>;
            var _local_19:Number;
            var _local_5:Vector.<Object3D> = new Vector.<Object3D>(2);
            var _local_6:Vector3D = calculatePlane(_arg_1, _arg_2, _arg_3);
            var _local_7:Object3D = this.childrenList;
            this.childrenList = null;
            var _local_8:Object3DContainer = (this.clone() as Object3DContainer);
            var _local_9:Object3DContainer = (this.clone() as Object3DContainer);
            var _local_12:Object3D = _local_7;
            while (_local_12 != null)
            {
                _local_13 = _local_12.next;
                _local_12.next = null;
                _local_12.setParent(null);
                _local_12.composeMatrix();
                _local_12.calculateInverseMatrix();
                _local_14 = new Vector3D(((((_local_12.ima * _arg_1.x) + (_local_12.imb * _arg_1.y)) + (_local_12.imc * _arg_1.z)) + _local_12.imd), ((((_local_12.ime * _arg_1.x) + (_local_12.imf * _arg_1.y)) + (_local_12.img * _arg_1.z)) + _local_12.imh), ((((_local_12.imi * _arg_1.x) + (_local_12.imj * _arg_1.y)) + (_local_12.imk * _arg_1.z)) + _local_12.iml));
                _local_15 = new Vector3D(((((_local_12.ima * _arg_2.x) + (_local_12.imb * _arg_2.y)) + (_local_12.imc * _arg_2.z)) + _local_12.imd), ((((_local_12.ime * _arg_2.x) + (_local_12.imf * _arg_2.y)) + (_local_12.img * _arg_2.z)) + _local_12.imh), ((((_local_12.imi * _arg_2.x) + (_local_12.imj * _arg_2.y)) + (_local_12.imk * _arg_2.z)) + _local_12.iml));
                _local_16 = new Vector3D(((((_local_12.ima * _arg_3.x) + (_local_12.imb * _arg_3.y)) + (_local_12.imc * _arg_3.z)) + _local_12.imd), ((((_local_12.ime * _arg_3.x) + (_local_12.imf * _arg_3.y)) + (_local_12.img * _arg_3.z)) + _local_12.imh), ((((_local_12.imi * _arg_3.x) + (_local_12.imj * _arg_3.y)) + (_local_12.imk * _arg_3.z)) + _local_12.iml));
                _local_17 = _local_12.testSplit(_local_14, _local_15, _local_16, _arg_4);
                if (_local_17 < 0)
                {
                    if (_local_10 != null)
                    {
                        _local_10.next = _local_12;
                    } else
                    {
                        _local_8.childrenList = _local_12;
                    };
                    _local_10 = _local_12;
                    _local_12.setParent(_local_8);
                } else
                {
                    if (_local_17 > 0)
                    {
                        if (_local_11 != null)
                        {
                            _local_11.next = _local_12;
                        } else
                        {
                            _local_9.childrenList = _local_12;
                        };
                        _local_11 = _local_12;
                        _local_12.setParent(_local_9);
                    } else
                    {
                        _local_18 = _local_12.split(_local_14, _local_15, _local_16, _arg_4);
                        _local_19 = _local_12.distance;
                        if (_local_18[0] != null)
                        {
                            _local_12 = _local_18[0];
                            if (_local_10 != null)
                            {
                                _local_10.next = _local_12;
                            } else
                            {
                                _local_8.childrenList = _local_12;
                            };
                            _local_10 = _local_12;
                            _local_12.setParent(_local_8);
                            _local_12.distance = _local_19;
                        };
                        if (_local_18[1] != null)
                        {
                            _local_12 = _local_18[1];
                            if (_local_11 != null)
                            {
                                _local_11.next = _local_12;
                            } else
                            {
                                _local_9.childrenList = _local_12;
                            };
                            _local_11 = _local_12;
                            _local_12.setParent(_local_9);
                            _local_12.distance = _local_19;
                        };
                    };
                };
                _local_12 = _local_13;
            };
            if (_local_10 != null)
            {
                _local_8.calculateBounds();
                _local_5[0] = _local_8;
            };
            if (_local_11 != null)
            {
                _local_9.calculateBounds();
                _local_5[1] = _local_9;
            };
            return (_local_5);
        }

        alternativa3d function addToList(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            var _local_3:Object3D;
            _arg_1.next = _arg_2;
            _arg_1.setParent(this);
            if (_arg_2 == this.childrenList)
            {
                this.childrenList = _arg_1;
            } else
            {
                _local_3 = this.childrenList;
                while (_local_3 != null)
                {
                    if (_local_3.next == _arg_2)
                    {
                        _local_3.next = _arg_1;
                        return;
                    };
                    _local_3 = _local_3.next;
                };
            };
        }

        override alternativa3d function setParent(_arg_1:Object3DContainer):void
        {
            var _local_2:Object3DContainer;
            var _local_3:Light3D;
            if (_arg_1 == null)
            {
                _local_2 = _parent;
                while (_local_2._parent != null)
                {
                    _local_2 = _local_2._parent;
                };
                if (_local_2.lightList != null)
                {
                    this.transferLights(_local_2, this);
                };
            } else
            {
                if (this.lightList != null)
                {
                    _local_2 = _arg_1;
                    while (_local_2._parent != null)
                    {
                        _local_2 = _local_2._parent;
                    };
                    _local_3 = this.lightList;
                    while (_local_3.nextLight != null)
                    {
                        _local_3 = _local_3.nextLight;
                    };
                    _local_3.nextLight = _local_2.lightList;
                    _local_2.lightList = this.lightList;
                    this.lightList = null;
                };
            };
            _parent = _arg_1;
        }

        private function transferLights(_arg_1:Object3DContainer, _arg_2:Object3DContainer):void
        {
            var _local_4:Light3D;
            var _local_5:Light3D;
            var _local_6:Light3D;
            var _local_3:Object3D = this.childrenList;
            while (_local_3 != null)
            {
                if ((_local_3 is Light3D))
                {
                    _local_4 = (_local_3 as Light3D);
                    _local_5 = null;
                    _local_6 = _arg_1.lightList;
                    while (_local_6 != null)
                    {
                        if (_local_6 == _local_4)
                        {
                            if (_local_5 != null)
                            {
                                _local_5.nextLight = _local_6.nextLight;
                            } else
                            {
                                _arg_1.lightList = _local_6.nextLight;
                            };
                            _local_6.nextLight = _arg_2.lightList;
                            _arg_2.lightList = _local_6;
                            break;
                        };
                        _local_5 = _local_6;
                        _local_6 = _local_6.nextLight;
                    };
                } else
                {
                    if ((_local_3 is Object3DContainer))
                    {
                        (_local_3 as Object3DContainer).transferLights(_arg_1, _arg_2);
                    };
                };
                if (_arg_1.lightList == null) break;
                _local_3 = _local_3.next;
            };
        }


    }
}//package alternativa.engine3d.core