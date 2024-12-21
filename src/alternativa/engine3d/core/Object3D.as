package alternativa.engine3d.core
{
    import flash.events.IEventDispatcher;
    import flash.geom.Vector3D;
    import flash.geom.ColorTransform;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix3D;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 
    import alternativa.types.Matrix4;

    use namespace alternativa3d;

    [Event(name="click", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="doubleClick", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseDown", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseUp", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseOver", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseOut", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="rollOver", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="rollOut", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseMove", type="alternativa.engine3d.core.MouseEvent3D")]
    [Event(name="mouseWheel", type="alternativa.engine3d.core.MouseEvent3D")]
    public class Object3D implements IEventDispatcher 
    {

        alternativa3d static const boundVertexList:Vertex = Vertex.createList(8);
        alternativa3d static const tA:Object3D = new (Object3D)();
        alternativa3d static const tB:Object3D = new (Object3D)();
        private static const staticSphere:Vector3D = new Vector3D();

        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _z:Number = 0;
        private var _rotationX:Number = 0;
        private var _rotationY:Number = 0;
        private var _rotationZ:Number = 0;
        private var _scaleX:Number = 1;
        private var _scaleY:Number = 1;
        private var _scaleZ:Number = 1;
        public var name:String;
        public var originalName:String;
        public var visible:Boolean = true;
        public var alpha:Number = 1;
        public var blendMode:String = "normal";
        public var colorTransform:ColorTransform = null;
        public var filters:Array = null;
        public var mouseEnabled:Boolean = true;
        public var doubleClickEnabled:Boolean = false;
        public var useHandCursor:Boolean = false;
        public var depthMapAlphaThreshold:Number = 1;
        public var shadowMapAlphaThreshold:Number = 1;
        public var softAttenuation:Number = 0;
        public var useShadowMap:Boolean = true;
        public var useLight:Boolean = true;
        public var boundMinX:Number = -1E22;
        public var boundMinY:Number = -1E22;
        public var boundMinZ:Number = -1E22;
        public var boundMaxX:Number = 1E22;
        public var boundMaxY:Number = 1E22;
        public var boundMaxZ:Number = 1E22;
        alternativa3d var ma:Number;
        alternativa3d var mb:Number;
        alternativa3d var mc:Number;
        alternativa3d var md:Number;
        alternativa3d var me:Number;
        alternativa3d var mf:Number;
        alternativa3d var mg:Number;
        alternativa3d var mh:Number;
        alternativa3d var mi:Number;
        alternativa3d var mj:Number;
        alternativa3d var mk:Number;
        alternativa3d var ml:Number;
        alternativa3d var ima:Number;
        alternativa3d var imb:Number;
        alternativa3d var imc:Number;
        alternativa3d var imd:Number;
        alternativa3d var ime:Number;
        alternativa3d var imf:Number;
        alternativa3d var img:Number;
        alternativa3d var imh:Number;
        alternativa3d var imi:Number;
        alternativa3d var imj:Number;
        alternativa3d var imk:Number;
        alternativa3d var iml:Number;
        alternativa3d var _parent:Object3DContainer;
        alternativa3d var next:Object3D;
        alternativa3d var culling:int = 0;
        alternativa3d var transformId:int = 0;
        alternativa3d var distance:Number;
        alternativa3d var concatenatedAlpha:Number = 1;
        alternativa3d var concatenatedBlendMode:String = "normal";
        alternativa3d var concatenatedColorTransform:ColorTransform = null;
        alternativa3d var bubbleListeners:Object;
        alternativa3d var captureListeners:Object;
        alternativa3d var useDepth:Boolean = false;
        alternativa3d var transformConst:Vector.<Number> = new Vector.<Number>(12);
        alternativa3d var colorConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);

		
		public function destroy() : void
		{
			name = null;
            colorTransform = null;
            _parent = null;
            next = null;
            concatenatedColorTransform = null;
            transformConst = null;
            colorConst = null;
		}

        public function get x() : Number
        {
            return this._x;
        }
        public function set x(val:Number) : void
        {
            this._x = val;
        }

        public function get y() : Number
        {
            return this._y;
        }
        public function set y(val:Number) : void
        {
            this._y = val;
        }

        public function get z() : Number
        {
            return this._z;
        }
        public function set z(val:Number) : void
        {
            this._z = val;
        }

        public function get rotationX() : Number
        {
            return this._rotationX;
        }
        public function set rotationX(val:Number) : void
        {
            this._rotationX = val;
        }

        public function get rotationY() : Number
        {
            return this._rotationY;
        }
        public function set rotationY(val:Number) : void
        {
            this._rotationY = val;
        }

        public function get rotationZ() : Number
        {
            return this._rotationZ;
        }
        public function set rotationZ(val:Number) : void
        {
            this._rotationZ = val;
        }

        public function get scaleX() : Number
        {
            return this._scaleX;
        }
        public function set scaleX(val:Number) : void
        {
            this._scaleX = val;
        }

        public function get scaleY() : Number
        {
            return this._scaleY;
        }
        public function set scaleY(val:Number) : void
        {
            this._scaleY = val;
        }

        public function get scaleZ() : Number
        {
            return this._scaleZ;
        }
        public function set scaleZ(val:Number) : void
        {
            this._scaleZ = val;
        }
		
		public function setPositionXYZ(x:Number, y:Number, z:Number) : void
		{
			this._x = x;
			this._y = y;
			this._z = z;
		}
		
		public function setRotationXYZ(x:Number, y:Number, z:Number) : void
		{
			this._rotationX = x;
			this._rotationY = y;
			this._rotationZ = z;
		}
		
		public function setPositionFromVector3(position:Vector3D) : void
		{
			this._x = position.x;
			this._y = position.y;
			this._z = position.z;
		}
		
		public function copyPositionTo(position:Vector3D) : void
		{
			position.setTo(this._x, this._y, this._z);
		}
		

        public function get matrix():Matrix3D
        {
            tA.composeMatrixFromSource(this);
            return (new Matrix3D(Vector.<Number>([tA.ma, tA.me, tA.mi, 0, tA.mb, tA.mf, tA.mj, 0, tA.mc, tA.mg, tA.mk, 0, tA.md, tA.mh, tA.ml, 1])));
        }
        public function get transformation() : Matrix4
        {
            tA.composeMatrixFromSource(this);
            var _local_1:Object3D = this;
            while (_local_1._parent != null)
            {
                _local_1 = _local_1._parent;
                tB.composeMatrixFromSource(_local_1);
                tA.appendMatrix(tB);
            };
            return new Matrix4(tA.ma, tA.mb, tA.mc, tA.md, tA.me, tA.mf, tA.mg, tA.mh, tA.mi, tA.mj, tA.mk, tA.ml);
        }

        public function set matrix(_arg_1:Matrix3D):void
        {
            var _local_2:Vector.<Vector3D> = _arg_1.decompose();
            var _local_3:Vector3D = _local_2[0];
            var _local_4:Vector3D = _local_2[1];
            var _local_5:Vector3D = _local_2[2];
            this._x = _local_3.x;
            this._y = _local_3.y;
            this._z = _local_3.z;
            this._rotationX = _local_4.x;
            this._rotationY = _local_4.y;
            this._rotationZ = _local_4.z;
            this._scaleX = _local_5.x;
            this._scaleY = _local_5.y;
            this._scaleZ = _local_5.z;
        }

        public function get concatenatedMatrix():Matrix3D
        {
            tA.composeMatrixFromSource(this);
            var _local_1:Object3D = this;
            while (_local_1._parent != null)
            {
                _local_1 = _local_1._parent;
                tB.composeMatrixFromSource(_local_1);
                tA.appendMatrix(tB);
            };
            return (new Matrix3D(Vector.<Number>([tA.ma, tA.me, tA.mi, 0, tA.mb, tA.mf, tA.mj, 0, tA.mc, tA.mg, tA.mk, 0, tA.md, tA.mh, tA.ml, 1])));
        }

        public function localToGlobal(_arg_1:Vector3D, vector:Boolean = false):Vector3D
        {
            tA.composeMatrixFromSource(this);
            var _local_2:Object3D = this;
            while (_local_2._parent != null)
            {
                _local_2 = _local_2._parent;
                tB.composeMatrixFromSource(_local_2);
                tA.appendMatrix(tB);
            };
            var _local_3:Vector3D = new Vector3D();
            _local_3.x = (((tA.ma * _arg_1.x) + (tA.mb * _arg_1.y)) + (tA.mc * _arg_1.z));
            _local_3.y = (((tA.me * _arg_1.x) + (tA.mf * _arg_1.y)) + (tA.mg * _arg_1.z));
            _local_3.z = (((tA.mi * _arg_1.x) + (tA.mj * _arg_1.y)) + (tA.mk * _arg_1.z));
            if(!vector)
            {
                _local_3.x += tA.md;
                _local_3.y += tA.mh;
                _local_3.z += tA.ml;
            }
            return (_local_3);
        }

        public function globalToLocal(_arg_1:Vector3D):Vector3D
        {
            tA.composeMatrixFromSource(this);
            var _local_2:Object3D = this;
            while (_local_2._parent != null)
            {
                _local_2 = _local_2._parent;
                tB.composeMatrixFromSource(_local_2);
                tA.appendMatrix(tB);
            };
            tA.invertMatrix();
            var _local_3:Vector3D = new Vector3D();
            _local_3.x = ((((tA.ma * _arg_1.x) + (tA.mb * _arg_1.y)) + (tA.mc * _arg_1.z)) + tA.md);
            _local_3.y = ((((tA.me * _arg_1.x) + (tA.mf * _arg_1.y)) + (tA.mg * _arg_1.z)) + tA.mh);
            _local_3.z = ((((tA.mi * _arg_1.x) + (tA.mj * _arg_1.y)) + (tA.mk * _arg_1.z)) + tA.ml);
            return (_local_3);
        }

        public function get parent():Object3DContainer
        {
            return (this._parent);
        }

        alternativa3d function setParent(_arg_1:Object3DContainer):void
        {
            this._parent = _arg_1;
        }

        public function calculateBounds():void
        {
            this.boundMinX = 1E22;
            this.boundMinY = 1E22;
            this.boundMinZ = 1E22;
            this.boundMaxX = -1E22;
            this.boundMaxY = -1E22;
            this.boundMaxZ = -1E22;
            this.updateBounds(this, null);
            if (this.boundMinX > this.boundMaxX)
            {
                this.boundMinX = -1E22;
                this.boundMinY = -1E22;
                this.boundMinZ = -1E22;
                this.boundMaxX = 1E22;
                this.boundMaxY = 1E22;
                this.boundMaxZ = 1E22;
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            var _local_6:Object;
            if (_arg_2 == null)
            {
                throw (new TypeError("Parameter listener must be non-null."));
            };
            if (_arg_3)
            {
                if (this.captureListeners == null)
                {
                    this.captureListeners = new Object();
                };
                _local_6 = this.captureListeners;
            } else
            {
                if (this.bubbleListeners == null)
                {
                    this.bubbleListeners = new Object();
                };
                _local_6 = this.bubbleListeners;
            };
            var _local_7:Vector.<Function> = _local_6[_arg_1];
            if (_local_7 == null)
            {
                _local_7 = new Vector.<Function>();
                _local_6[_arg_1] = _local_7;
            };
            if (_local_7.indexOf(_arg_2) < 0)
            {
                _local_7.push(_arg_2);
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            var _local_5:Vector.<Function>;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:*;
            if (_arg_2 == null)
            {
                throw (new TypeError("Parameter listener must be non-null."));
            };
            var _local_4:Object = ((_arg_3) ? this.captureListeners : this.bubbleListeners);
            if (_local_4 != null)
            {
                _local_5 = _local_4[_arg_1];
                if (_local_5 != null)
                {
                    _local_6 = _local_5.indexOf(_arg_2);
                    if (_local_6 >= 0)
                    {
                        _local_7 = _local_5.length;
                        _local_8 = (_local_6 + 1);
                        while (_local_8 < _local_7)
                        {
                            _local_5[_local_6] = _local_5[_local_8];
                            _local_8++;
                            _local_6++;
                        };
                        if (_local_7 > 1)
                        {
                            _local_5.length = (_local_7 - 1);
                        } else
                        {
                            delete _local_4[_arg_1];
                            for (_local_9 in _local_4)
                            {
                                break;
                            };
                            if ((!(_local_9)))
                            {
                                if (_local_4 == this.captureListeners)
                                {
                                    this.captureListeners = null;
                                } else
                                {
                                    this.bubbleListeners = null;
                                };
                            };
                        };
                    };
                };
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (((!(this.captureListeners == null)) && (this.captureListeners[_arg_1])) || ((!(this.bubbleListeners == null)) && (this.bubbleListeners[_arg_1])));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            var _local_2:Object3D = this;
            while (_local_2 != null)
            {
                if ((((!(_local_2.captureListeners == null)) && (_local_2.captureListeners[_arg_1])) || ((!(_local_2.bubbleListeners == null)) && (_local_2.bubbleListeners[_arg_1]))))
                {
                    return (true);
                };
                _local_2 = _local_2._parent;
            };
            return (false);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            var _local_4:Object3D;
            var _local_6:Vector.<Function>;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Vector.<Function>;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter event must be non-null."));
            };
            if ((_arg_1 is MouseEvent3D))
            {
                MouseEvent3D(_arg_1)._target = this;
            };
            var _local_2:Vector.<Object3D> = new Vector.<Object3D>();
            var _local_3:int;
            _local_4 = this;
            while (_local_4 != null)
            {
                _local_2[_local_3] = _local_4;
                _local_3++;
                _local_4 = _local_4._parent;
            };
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_4 = _local_2[_local_5];
                if ((_arg_1 is MouseEvent3D))
                {
                    MouseEvent3D(_arg_1)._currentTarget = _local_4;
                };
                if (this.bubbleListeners != null)
                {
                    _local_6 = this.bubbleListeners[_arg_1.type];
                    if (_local_6 != null)
                    {
                        _local_8 = _local_6.length;
                        _local_9 = new Vector.<Function>();
                        _local_7 = 0;
                        while (_local_7 < _local_8)
                        {
                            _local_9[_local_7] = _local_6[_local_7];
                            _local_7++;
                        };
                        _local_7 = 0;
                        while (_local_7 < _local_8)
                        {
                            (_local_9[_local_7] as Function).call(null, _arg_1);
                            _local_7++;
                        };
                    };
                };
                if ((!(_arg_1.bubbles))) break;
                _local_5++;
            };
            return (true);
        }

        public function calculateResolution(_arg_1:int, _arg_2:int, _arg_3:int=1, _arg_4:Matrix3D=null):Number
        {
            return (1);
        }

        public function intersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Dictionary=null, _arg_4:Camera3D=null):RayIntersectionData
        {
            return (null);
        }

        alternativa3d function checkIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Dictionary):Boolean
        {
            return (false);
        }

        alternativa3d function boundCheckIntersection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number, _arg_12:Number, _arg_13:Number):Boolean
        {
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_14:Number = (_arg_1 + (_arg_4 * _arg_7));
            var _local_15:Number = (_arg_2 + (_arg_5 * _arg_7));
            var _local_16:Number = (_arg_3 + (_arg_6 * _arg_7));
            if ((((((((_arg_1 >= _arg_8) && (_arg_1 <= _arg_11)) && (_arg_2 >= _arg_9)) && (_arg_2 <= _arg_12)) && (_arg_3 >= _arg_10)) && (_arg_3 <= _arg_13)) || ((((((_local_14 >= _arg_8) && (_local_14 <= _arg_11)) && (_local_15 >= _arg_9)) && (_local_15 <= _arg_12)) && (_local_16 >= _arg_10)) && (_local_16 <= _arg_13))))
            {
                return (true);
            };
            if ((((((((_arg_1 < _arg_8) && (_local_14 < _arg_8)) || ((_arg_1 > _arg_11) && (_local_14 > _arg_11))) || ((_arg_2 < _arg_9) && (_local_15 < _arg_9))) || ((_arg_2 > _arg_12) && (_local_15 > _arg_12))) || ((_arg_3 < _arg_10) && (_local_16 < _arg_10))) || ((_arg_3 > _arg_13) && (_local_16 > _arg_13))))
            {
                return (false);
            };
            var _local_21:Number = 1E-6;
            if (_arg_4 > _local_21)
            {
                _local_17 = ((_arg_8 - _arg_1) / _arg_4);
                _local_18 = ((_arg_11 - _arg_1) / _arg_4);
            } else
            {
                if (_arg_4 < -(_local_21))
                {
                    _local_17 = ((_arg_11 - _arg_1) / _arg_4);
                    _local_18 = ((_arg_8 - _arg_1) / _arg_4);
                } else
                {
                    _local_17 = 0;
                    _local_18 = _arg_7;
                };
            };
            if (_arg_5 > _local_21)
            {
                _local_19 = ((_arg_9 - _arg_2) / _arg_5);
                _local_20 = ((_arg_12 - _arg_2) / _arg_5);
            } else
            {
                if (_arg_5 < -(_local_21))
                {
                    _local_19 = ((_arg_12 - _arg_2) / _arg_5);
                    _local_20 = ((_arg_9 - _arg_2) / _arg_5);
                } else
                {
                    _local_19 = 0;
                    _local_20 = _arg_7;
                };
            };
            if (((_local_19 >= _local_18) || (_local_20 <= _local_17)))
            {
                return (false);
            };
            if (_local_19 < _local_17)
            {
                if (_local_20 < _local_18)
                {
                    _local_18 = _local_20;
                };
            } else
            {
                _local_17 = _local_19;
                if (_local_20 < _local_18)
                {
                    _local_18 = _local_20;
                };
            };
            if (_arg_6 > _local_21)
            {
                _local_19 = ((_arg_10 - _arg_3) / _arg_6);
                _local_20 = ((_arg_13 - _arg_3) / _arg_6);
            } else
            {
                if (_arg_6 < -(_local_21))
                {
                    _local_19 = ((_arg_13 - _arg_3) / _arg_6);
                    _local_20 = ((_arg_10 - _arg_3) / _arg_6);
                } else
                {
                    _local_19 = 0;
                    _local_20 = _arg_7;
                };
            };
            if (((_local_19 >= _local_18) || (_local_20 <= _local_17)))
            {
                return (false);
            };
            return (true);
        }

        public function clone():Object3D
        {
            var _local_1:Object3D = new Object3D();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            this.name = _arg_1.name;
            this.visible = _arg_1.visible;
            this.alpha = _arg_1.alpha;
            this.blendMode = _arg_1.blendMode;
            this.mouseEnabled = _arg_1.mouseEnabled;
            this.doubleClickEnabled = _arg_1.doubleClickEnabled;
            this.useHandCursor = _arg_1.useHandCursor;
            this.depthMapAlphaThreshold = _arg_1.depthMapAlphaThreshold;
            this.shadowMapAlphaThreshold = _arg_1.shadowMapAlphaThreshold;
            this.softAttenuation = _arg_1.softAttenuation;
            this.useShadowMap = _arg_1.useShadowMap;
            this.useLight = _arg_1.useLight;
            this.transformId = _arg_1.transformId;
            this.distance = _arg_1.distance;
            if (_arg_1.colorTransform != null)
            {
                this.colorTransform = new ColorTransform();
                this.colorTransform.concat(_arg_1.colorTransform);
            };
            if (_arg_1.filters != null)
            {
                this.filters = new Array().concat(_arg_1.filters);
            };
            this._x = _arg_1._x;
            this._y = _arg_1._y;
            this._z = _arg_1._z;
            this._rotationX = _arg_1._rotationX;
            this._rotationY = _arg_1._rotationY;
            this._rotationZ = _arg_1._rotationZ;
            this._scaleX = _arg_1._scaleX;
            this._scaleY = _arg_1._scaleY;
            this._scaleZ = _arg_1._scaleZ;
            this.boundMinX = _arg_1.boundMinX;
            this.boundMinY = _arg_1.boundMinY;
            this.boundMinZ = _arg_1.boundMinZ;
            this.boundMaxX = _arg_1.boundMaxX;
            this.boundMaxY = _arg_1.boundMaxY;
            this.boundMaxZ = _arg_1.boundMaxZ;
        }

        public function toString():String
        {
            var _local_1:String = getQualifiedClassName(this);
            return (((("[" + _local_1.substr((_local_1.indexOf("::") + 2))) + " ") + this.name) + "]");
        }

        alternativa3d function draw(_arg_1:Camera3D):void
        {
        }

        alternativa3d function getVG(_arg_1:Camera3D):VG
        {
            return (null);
        }

        alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
        }

        alternativa3d function concat(_arg_1:Object3DContainer):void
        {
            this.concatenatedAlpha = (_arg_1.concatenatedAlpha * this.alpha);
            this.concatenatedBlendMode = ((_arg_1.concatenatedBlendMode != "normal") ? _arg_1.concatenatedBlendMode : this.blendMode);
            if (_arg_1.concatenatedColorTransform != null)
            {
                if (this.colorTransform != null)
                {
                    this.concatenatedColorTransform = new ColorTransform();
                    this.concatenatedColorTransform.redMultiplier = _arg_1.concatenatedColorTransform.redMultiplier;
                    this.concatenatedColorTransform.greenMultiplier = _arg_1.concatenatedColorTransform.greenMultiplier;
                    this.concatenatedColorTransform.blueMultiplier = _arg_1.concatenatedColorTransform.blueMultiplier;
                    this.concatenatedColorTransform.redOffset = _arg_1.concatenatedColorTransform.redOffset;
                    this.concatenatedColorTransform.greenOffset = _arg_1.concatenatedColorTransform.greenOffset;
                    this.concatenatedColorTransform.blueOffset = _arg_1.concatenatedColorTransform.blueOffset;
                    this.concatenatedColorTransform.concat(this.colorTransform);
                } else
                {
                    this.concatenatedColorTransform = _arg_1.concatenatedColorTransform;
                };
            } else
            {
                this.concatenatedColorTransform = this.colorTransform;
            };
            if (this.concatenatedColorTransform != null)
            {
                this.colorConst[0] = this.concatenatedColorTransform.redMultiplier;
                this.colorConst[1] = this.concatenatedColorTransform.greenMultiplier;
                this.colorConst[2] = this.concatenatedColorTransform.blueMultiplier;
                this.colorConst[3] = this.concatenatedAlpha;
                this.colorConst[4] = (this.concatenatedColorTransform.redOffset / 0xFF);
                this.colorConst[5] = (this.concatenatedColorTransform.greenOffset / 0xFF);
                this.colorConst[6] = (this.concatenatedColorTransform.blueOffset / 0xFF);
            } else
            {
                this.colorConst[3] = this.concatenatedAlpha;
            };
        }

        alternativa3d function boundIntersectRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Boolean
        {
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            if (((((((_arg_1.x >= _arg_3) && (_arg_1.x <= _arg_6)) && (_arg_1.y >= _arg_4)) && (_arg_1.y <= _arg_7)) && (_arg_1.z >= _arg_5)) && (_arg_1.z <= _arg_8)))
            {
                return (true);
            };
            if ((((((((_arg_1.x < _arg_3) && (_arg_2.x <= 0)) || ((_arg_1.x > _arg_6) && (_arg_2.x >= 0))) || ((_arg_1.y < _arg_4) && (_arg_2.y <= 0))) || ((_arg_1.y > _arg_7) && (_arg_2.y >= 0))) || ((_arg_1.z < _arg_5) && (_arg_2.z <= 0))) || ((_arg_1.z > _arg_8) && (_arg_2.z >= 0))))
            {
                return (false);
            };
            var _local_13:Number = 1E-6;
            if (_arg_2.x > _local_13)
            {
                _local_9 = ((_arg_3 - _arg_1.x) / _arg_2.x);
                _local_10 = ((_arg_6 - _arg_1.x) / _arg_2.x);
            } else
            {
                if (_arg_2.x < -(_local_13))
                {
                    _local_9 = ((_arg_6 - _arg_1.x) / _arg_2.x);
                    _local_10 = ((_arg_3 - _arg_1.x) / _arg_2.x);
                } else
                {
                    _local_9 = 0;
                    _local_10 = 1E22;
                };
            };
            if (_arg_2.y > _local_13)
            {
                _local_11 = ((_arg_4 - _arg_1.y) / _arg_2.y);
                _local_12 = ((_arg_7 - _arg_1.y) / _arg_2.y);
            } else
            {
                if (_arg_2.y < -(_local_13))
                {
                    _local_11 = ((_arg_7 - _arg_1.y) / _arg_2.y);
                    _local_12 = ((_arg_4 - _arg_1.y) / _arg_2.y);
                } else
                {
                    _local_11 = 0;
                    _local_12 = 1E22;
                };
            };
            if (((_local_11 >= _local_10) || (_local_12 <= _local_9)))
            {
                return (false);
            };
            if (_local_11 < _local_9)
            {
                if (_local_12 < _local_10)
                {
                    _local_10 = _local_12;
                };
            } else
            {
                _local_9 = _local_11;
                if (_local_12 < _local_10)
                {
                    _local_10 = _local_12;
                };
            };
            if (_arg_2.z > _local_13)
            {
                _local_11 = ((_arg_5 - _arg_1.z) / _arg_2.z);
                _local_12 = ((_arg_8 - _arg_1.z) / _arg_2.z);
            } else
            {
                if (_arg_2.z < -(_local_13))
                {
                    _local_11 = ((_arg_8 - _arg_1.z) / _arg_2.z);
                    _local_12 = ((_arg_5 - _arg_1.z) / _arg_2.z);
                } else
                {
                    _local_11 = 0;
                    _local_12 = 1E22;
                };
            };
            if (((_local_11 >= _local_10) || (_local_12 <= _local_9)))
            {
                return (false);
            };
            return (true);
        }

        alternativa3d function collectPlanes(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector.<Face>, _arg_7:Dictionary=null):void
        {
        }

        alternativa3d function calculateSphere(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Vector3D, _arg_6:Vector3D=null):Vector3D
        {
            this.calculateInverseMatrix();
            var _local_7:Number = ((((this.ima * _arg_1.x) + (this.imb * _arg_1.y)) + (this.imc * _arg_1.z)) + this.imd);
            var _local_8:Number = ((((this.ime * _arg_1.x) + (this.imf * _arg_1.y)) + (this.img * _arg_1.z)) + this.imh);
            var _local_9:Number = ((((this.imi * _arg_1.x) + (this.imj * _arg_1.y)) + (this.imk * _arg_1.z)) + this.iml);
            var _local_10:Number = ((((this.ima * _arg_2.x) + (this.imb * _arg_2.y)) + (this.imc * _arg_2.z)) + this.imd);
            var _local_11:Number = ((((this.ime * _arg_2.x) + (this.imf * _arg_2.y)) + (this.img * _arg_2.z)) + this.imh);
            var _local_12:Number = ((((this.imi * _arg_2.x) + (this.imj * _arg_2.y)) + (this.imk * _arg_2.z)) + this.iml);
            var _local_13:Number = ((((this.ima * _arg_3.x) + (this.imb * _arg_3.y)) + (this.imc * _arg_3.z)) + this.imd);
            var _local_14:Number = ((((this.ime * _arg_3.x) + (this.imf * _arg_3.y)) + (this.img * _arg_3.z)) + this.imh);
            var _local_15:Number = ((((this.imi * _arg_3.x) + (this.imj * _arg_3.y)) + (this.imk * _arg_3.z)) + this.iml);
            var _local_16:Number = ((((this.ima * _arg_4.x) + (this.imb * _arg_4.y)) + (this.imc * _arg_4.z)) + this.imd);
            var _local_17:Number = ((((this.ime * _arg_4.x) + (this.imf * _arg_4.y)) + (this.img * _arg_4.z)) + this.imh);
            var _local_18:Number = ((((this.imi * _arg_4.x) + (this.imj * _arg_4.y)) + (this.imk * _arg_4.z)) + this.iml);
            var _local_19:Number = ((((this.ima * _arg_5.x) + (this.imb * _arg_5.y)) + (this.imc * _arg_5.z)) + this.imd);
            var _local_20:Number = ((((this.ime * _arg_5.x) + (this.imf * _arg_5.y)) + (this.img * _arg_5.z)) + this.imh);
            var _local_21:Number = ((((this.imi * _arg_5.x) + (this.imj * _arg_5.y)) + (this.imk * _arg_5.z)) + this.iml);
            var _local_22:Number = (_local_10 - _local_7);
            var _local_23:Number = (_local_11 - _local_8);
            var _local_24:Number = (_local_12 - _local_9);
            var _local_25:Number = (((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24));
            _local_22 = (_local_13 - _local_7);
            _local_23 = (_local_14 - _local_8);
            _local_24 = (_local_15 - _local_9);
            var _local_26:Number = (((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24));
            if (_local_26 > _local_25)
            {
                _local_25 = _local_26;
            };
            _local_22 = (_local_16 - _local_7);
            _local_23 = (_local_17 - _local_8);
            _local_24 = (_local_18 - _local_9);
            _local_26 = (((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24));
            if (_local_26 > _local_25)
            {
                _local_25 = _local_26;
            };
            _local_22 = (_local_19 - _local_7);
            _local_23 = (_local_20 - _local_8);
            _local_24 = (_local_21 - _local_9);
            _local_26 = (((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24));
            if (_local_26 > _local_25)
            {
                _local_25 = _local_26;
            };
            if (_arg_6 == null)
            {
                _arg_6 = staticSphere;
            };
            _arg_6.x = _local_7;
            _arg_6.y = _local_8;
            _arg_6.z = _local_9;
            _arg_6.w = Math.sqrt(_local_25);
            return (_arg_6);
        }

        alternativa3d function boundIntersectSphere(_arg_1:Vector3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number):Boolean
        {
            return (((((((_arg_1.x + _arg_1.w) > _arg_2) && ((_arg_1.x - _arg_1.w) < _arg_5)) && ((_arg_1.y + _arg_1.w) > _arg_3)) && ((_arg_1.y - _arg_1.w) < _arg_6)) && ((_arg_1.z + _arg_1.w) > _arg_4)) && ((_arg_1.z - _arg_1.w) < _arg_7));
        }

        alternativa3d function split(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):Vector.<Object3D>
        {
            return (new Vector.<Object3D>(2));
        }

        alternativa3d function testSplit(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):int
        {
            var _local_5:Vector3D = this.calculatePlane(_arg_1, _arg_2, _arg_3);
            if (_local_5.x >= 0)
            {
                if (_local_5.y >= 0)
                {
                    if (_local_5.z >= 0)
                    {
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMinX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMinZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    } else
                    {
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMinZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMinX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    };
                } else
                {
                    if (_local_5.z >= 0)
                    {
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMinX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMinZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    } else
                    {
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMinZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMinX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    };
                };
            } else
            {
                if (_local_5.y >= 0)
                {
                    if (_local_5.z >= 0)
                    {
                        if ((((this.boundMinX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMinZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    } else
                    {
                        if ((((this.boundMinX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMinZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    };
                } else
                {
                    if (_local_5.z >= 0)
                    {
                        if ((((this.boundMinX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMinZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    } else
                    {
                        if ((((this.boundMinX * _local_5.x) + (this.boundMinY * _local_5.y)) + (this.boundMinZ * _local_5.z)) <= (_local_5.w + _arg_4))
                        {
                            return (-1);
                        };
                        if ((((this.boundMaxX * _local_5.x) + (this.boundMaxY * _local_5.y)) + (this.boundMaxZ * _local_5.z)) >= (_local_5.w - _arg_4))
                        {
                            return (1);
                        };
                    };
                };
            };
            return (0);
        }

        alternativa3d function calculatePlane(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D):Vector3D
        {
            var _local_4:Vector3D = new Vector3D();
            var _local_5:Number = (_arg_2.x - _arg_1.x);
            var _local_6:Number = (_arg_2.y - _arg_1.y);
            var _local_7:Number = (_arg_2.z - _arg_1.z);
            var _local_8:Number = (_arg_3.x - _arg_1.x);
            var _local_9:Number = (_arg_3.y - _arg_1.y);
            var _local_10:Number = (_arg_3.z - _arg_1.z);
            _local_4.x = ((_local_10 * _local_6) - (_local_9 * _local_7));
            _local_4.y = ((_local_8 * _local_7) - (_local_10 * _local_5));
            _local_4.z = ((_local_9 * _local_5) - (_local_8 * _local_6));
            var _local_11:Number = (((_local_4.x * _local_4.x) + (_local_4.y * _local_4.y)) + (_local_4.z * _local_4.z));
            if (_local_11 > 0.0001)
            {
                _local_11 = Math.sqrt(_local_11);
                _local_4.x = (_local_4.x / _local_11);
                _local_4.y = (_local_4.y / _local_11);
                _local_4.z = (_local_4.z / _local_11);
            };
            _local_4.w = (((_arg_1.x * _local_4.x) + (_arg_1.y * _local_4.y)) + (_arg_1.z * _local_4.z));
            return (_local_4);
        }

        alternativa3d function composeMatrix():void
        {
            var _local_1:Number = Math.cos(this._rotationX);
            var _local_2:Number = Math.sin(this._rotationX);
            var _local_3:Number = Math.cos(this._rotationY);
            var _local_4:Number = Math.sin(this._rotationY);
            var _local_5:Number = Math.cos(this._rotationZ);
            var _local_6:Number = Math.sin(this._rotationZ);
            var _local_7:Number = (_local_5 * _local_4);
            var _local_8:Number = (_local_6 * _local_4);
            var _local_9:Number = (_local_3 * this._scaleX);
            var _local_10:Number = (_local_2 * this._scaleY);
            var _local_11:Number = (_local_1 * this._scaleY);
            var _local_12:Number = (_local_1 * this._scaleZ);
            var _local_13:Number = (_local_2 * this._scaleZ);
            this.ma = (_local_5 * _local_9);
            this.mb = ((_local_7 * _local_10) - (_local_6 * _local_11));
            this.mc = ((_local_7 * _local_12) + (_local_6 * _local_13));
            this.md = this._x;
            this.me = (_local_6 * _local_9);
            this.mf = ((_local_8 * _local_10) + (_local_5 * _local_11));
            this.mg = ((_local_8 * _local_12) - (_local_5 * _local_13));
            this.mh = this._y;
            this.mi = (-(_local_4) * this._scaleX);
            this.mj = (_local_3 * _local_10);
            this.mk = (_local_3 * _local_12);
            this.ml = this._z;
        }

        alternativa3d function composeMatrixFromSource(_arg_1:Object3D):void
        {
            var _local_2:Number = Math.cos(_arg_1.rotationX);
            var _local_3:Number = Math.sin(_arg_1.rotationX);
            var _local_4:Number = Math.cos(_arg_1.rotationY);
            var _local_5:Number = Math.sin(_arg_1.rotationY);
            var _local_6:Number = Math.cos(_arg_1.rotationZ);
            var _local_7:Number = Math.sin(_arg_1.rotationZ);
            var _local_8:Number = (_local_6 * _local_5);
            var _local_9:Number = (_local_7 * _local_5);
            var _local_10:Number = (_local_4 * _arg_1.scaleX);
            var _local_11:Number = (_local_3 * _arg_1.scaleY);
            var _local_12:Number = (_local_2 * _arg_1.scaleY);
            var _local_13:Number = (_local_2 * _arg_1.scaleZ);
            var _local_14:Number = (_local_3 * _arg_1.scaleZ);
            this.ma = (_local_6 * _local_10);
            this.mb = ((_local_8 * _local_11) - (_local_7 * _local_12));
            this.mc = ((_local_8 * _local_13) + (_local_7 * _local_14));
            this.md = _arg_1.x;
            this.me = (_local_7 * _local_10);
            this.mf = ((_local_9 * _local_11) + (_local_6 * _local_12));
            this.mg = ((_local_9 * _local_13) - (_local_6 * _local_14));
            this.mh = _arg_1.y;
            this.mi = (-(_local_5) * _arg_1.scaleX);
            this.mj = (_local_4 * _local_11);
            this.mk = (_local_4 * _local_13);
            this.ml = _arg_1.z;
        }

        alternativa3d function appendMatrix(_arg_1:Object3D):void
        {
            var _local_2:Number = this.ma;
            var _local_3:Number = this.mb;
            var _local_4:Number = this.mc;
            var _local_5:Number = this.md;
            var _local_6:Number = this.me;
            var _local_7:Number = this.mf;
            var _local_8:Number = this.mg;
            var _local_9:Number = this.mh;
            var _local_10:Number = this.mi;
            var _local_11:Number = this.mj;
            var _local_12:Number = this.mk;
            var _local_13:Number = this.ml;
            this.ma = (((_arg_1.ma * _local_2) + (_arg_1.mb * _local_6)) + (_arg_1.mc * _local_10));
            this.mb = (((_arg_1.ma * _local_3) + (_arg_1.mb * _local_7)) + (_arg_1.mc * _local_11));
            this.mc = (((_arg_1.ma * _local_4) + (_arg_1.mb * _local_8)) + (_arg_1.mc * _local_12));
            this.md = ((((_arg_1.ma * _local_5) + (_arg_1.mb * _local_9)) + (_arg_1.mc * _local_13)) + _arg_1.md);
            this.me = (((_arg_1.me * _local_2) + (_arg_1.mf * _local_6)) + (_arg_1.mg * _local_10));
            this.mf = (((_arg_1.me * _local_3) + (_arg_1.mf * _local_7)) + (_arg_1.mg * _local_11));
            this.mg = (((_arg_1.me * _local_4) + (_arg_1.mf * _local_8)) + (_arg_1.mg * _local_12));
            this.mh = ((((_arg_1.me * _local_5) + (_arg_1.mf * _local_9)) + (_arg_1.mg * _local_13)) + _arg_1.mh);
            this.mi = (((_arg_1.mi * _local_2) + (_arg_1.mj * _local_6)) + (_arg_1.mk * _local_10));
            this.mj = (((_arg_1.mi * _local_3) + (_arg_1.mj * _local_7)) + (_arg_1.mk * _local_11));
            this.mk = (((_arg_1.mi * _local_4) + (_arg_1.mj * _local_8)) + (_arg_1.mk * _local_12));
            this.ml = ((((_arg_1.mi * _local_5) + (_arg_1.mj * _local_9)) + (_arg_1.mk * _local_13)) + _arg_1.ml);
        }

        alternativa3d function composeAndAppend(_arg_1:Object3D):void
        {
            var _local_2:Number = Math.cos(this._rotationX);
            var _local_3:Number = Math.sin(this._rotationX);
            var _local_4:Number = Math.cos(this._rotationY);
            var _local_5:Number = Math.sin(this._rotationY);
            var _local_6:Number = Math.cos(this._rotationZ);
            var _local_7:Number = Math.sin(this._rotationZ);
            var _local_8:Number = (_local_6 * _local_5);
            var _local_9:Number = (_local_7 * _local_5);
            var _local_10:Number = (_local_4 * this._scaleX);
            var _local_11:Number = (_local_3 * this._scaleY);
            var _local_12:Number = (_local_2 * this._scaleY);
            var _local_13:Number = (_local_2 * this._scaleZ);
            var _local_14:Number = (_local_3 * this._scaleZ);
            var _local_15:Number = (_local_6 * _local_10);
            var _local_16:Number = ((_local_8 * _local_11) - (_local_7 * _local_12));
            var _local_17:Number = ((_local_8 * _local_13) + (_local_7 * _local_14));
            var _local_18:Number = this._x;
            var _local_19:Number = (_local_7 * _local_10);
            var _local_20:Number = ((_local_9 * _local_11) + (_local_6 * _local_12));
            var _local_21:Number = ((_local_9 * _local_13) - (_local_6 * _local_14));
            var _local_22:Number = this._y;
            var _local_23:Number = (-(_local_5) * this._scaleX);
            var _local_24:Number = (_local_4 * _local_11);
            var _local_25:Number = (_local_4 * _local_13);
            var _local_26:Number = this._z;
            this.ma = (((_arg_1.ma * _local_15) + (_arg_1.mb * _local_19)) + (_arg_1.mc * _local_23));
            this.mb = (((_arg_1.ma * _local_16) + (_arg_1.mb * _local_20)) + (_arg_1.mc * _local_24));
            this.mc = (((_arg_1.ma * _local_17) + (_arg_1.mb * _local_21)) + (_arg_1.mc * _local_25));
            this.md = ((((_arg_1.ma * _local_18) + (_arg_1.mb * _local_22)) + (_arg_1.mc * _local_26)) + _arg_1.md);
            this.me = (((_arg_1.me * _local_15) + (_arg_1.mf * _local_19)) + (_arg_1.mg * _local_23));
            this.mf = (((_arg_1.me * _local_16) + (_arg_1.mf * _local_20)) + (_arg_1.mg * _local_24));
            this.mg = (((_arg_1.me * _local_17) + (_arg_1.mf * _local_21)) + (_arg_1.mg * _local_25));
            this.mh = ((((_arg_1.me * _local_18) + (_arg_1.mf * _local_22)) + (_arg_1.mg * _local_26)) + _arg_1.mh);
            this.mi = (((_arg_1.mi * _local_15) + (_arg_1.mj * _local_19)) + (_arg_1.mk * _local_23));
            this.mj = (((_arg_1.mi * _local_16) + (_arg_1.mj * _local_20)) + (_arg_1.mk * _local_24));
            this.mk = (((_arg_1.mi * _local_17) + (_arg_1.mj * _local_21)) + (_arg_1.mk * _local_25));
            this.ml = ((((_arg_1.mi * _local_18) + (_arg_1.mj * _local_22)) + (_arg_1.mk * _local_26)) + _arg_1.ml);
        }

        alternativa3d function copyAndAppend(_arg_1:Object3D, _arg_2:Object3D):void
        {
            this.ma = (((_arg_2.ma * _arg_1.ma) + (_arg_2.mb * _arg_1.me)) + (_arg_2.mc * _arg_1.mi));
            this.mb = (((_arg_2.ma * _arg_1.mb) + (_arg_2.mb * _arg_1.mf)) + (_arg_2.mc * _arg_1.mj));
            this.mc = (((_arg_2.ma * _arg_1.mc) + (_arg_2.mb * _arg_1.mg)) + (_arg_2.mc * _arg_1.mk));
            this.md = ((((_arg_2.ma * _arg_1.md) + (_arg_2.mb * _arg_1.mh)) + (_arg_2.mc * _arg_1.ml)) + _arg_2.md);
            this.me = (((_arg_2.me * _arg_1.ma) + (_arg_2.mf * _arg_1.me)) + (_arg_2.mg * _arg_1.mi));
            this.mf = (((_arg_2.me * _arg_1.mb) + (_arg_2.mf * _arg_1.mf)) + (_arg_2.mg * _arg_1.mj));
            this.mg = (((_arg_2.me * _arg_1.mc) + (_arg_2.mf * _arg_1.mg)) + (_arg_2.mg * _arg_1.mk));
            this.mh = ((((_arg_2.me * _arg_1.md) + (_arg_2.mf * _arg_1.mh)) + (_arg_2.mg * _arg_1.ml)) + _arg_2.mh);
            this.mi = (((_arg_2.mi * _arg_1.ma) + (_arg_2.mj * _arg_1.me)) + (_arg_2.mk * _arg_1.mi));
            this.mj = (((_arg_2.mi * _arg_1.mb) + (_arg_2.mj * _arg_1.mf)) + (_arg_2.mk * _arg_1.mj));
            this.mk = (((_arg_2.mi * _arg_1.mc) + (_arg_2.mj * _arg_1.mg)) + (_arg_2.mk * _arg_1.mk));
            this.ml = ((((_arg_2.mi * _arg_1.md) + (_arg_2.mj * _arg_1.mh)) + (_arg_2.mk * _arg_1.ml)) + _arg_2.ml);
        }

        alternativa3d function invertMatrix():void
        {
            var _local_1:Number = this.ma;
            var _local_2:Number = this.mb;
            var _local_3:Number = this.mc;
            var _local_4:Number = this.md;
            var _local_5:Number = this.me;
            var _local_6:Number = this.mf;
            var _local_7:Number = this.mg;
            var _local_8:Number = this.mh;
            var _local_9:Number = this.mi;
            var _local_10:Number = this.mj;
            var _local_11:Number = this.mk;
            var _local_12:Number = this.ml;
            var _local_13:Number = (1 / (((((((-(_local_3) * _local_6) * _local_9) + ((_local_2 * _local_7) * _local_9)) + ((_local_3 * _local_5) * _local_10)) - ((_local_1 * _local_7) * _local_10)) - ((_local_2 * _local_5) * _local_11)) + ((_local_1 * _local_6) * _local_11)));
            this.ma = (((-(_local_7) * _local_10) + (_local_6 * _local_11)) * _local_13);
            this.mb = (((_local_3 * _local_10) - (_local_2 * _local_11)) * _local_13);
            this.mc = (((-(_local_3) * _local_6) + (_local_2 * _local_7)) * _local_13);
            this.md = ((((((((_local_4 * _local_7) * _local_10) - ((_local_3 * _local_8) * _local_10)) - ((_local_4 * _local_6) * _local_11)) + ((_local_2 * _local_8) * _local_11)) + ((_local_3 * _local_6) * _local_12)) - ((_local_2 * _local_7) * _local_12)) * _local_13);
            this.me = (((_local_7 * _local_9) - (_local_5 * _local_11)) * _local_13);
            this.mf = (((-(_local_3) * _local_9) + (_local_1 * _local_11)) * _local_13);
            this.mg = (((_local_3 * _local_5) - (_local_1 * _local_7)) * _local_13);
            this.mh = ((((((((_local_3 * _local_8) * _local_9) - ((_local_4 * _local_7) * _local_9)) + ((_local_4 * _local_5) * _local_11)) - ((_local_1 * _local_8) * _local_11)) - ((_local_3 * _local_5) * _local_12)) + ((_local_1 * _local_7) * _local_12)) * _local_13);
            this.mi = (((-(_local_6) * _local_9) + (_local_5 * _local_10)) * _local_13);
            this.mj = (((_local_2 * _local_9) - (_local_1 * _local_10)) * _local_13);
            this.mk = (((-(_local_2) * _local_5) + (_local_1 * _local_6)) * _local_13);
            this.ml = ((((((((_local_4 * _local_6) * _local_9) - ((_local_2 * _local_8) * _local_9)) - ((_local_4 * _local_5) * _local_10)) + ((_local_1 * _local_8) * _local_10)) + ((_local_2 * _local_5) * _local_12)) - ((_local_1 * _local_6) * _local_12)) * _local_13);
        }

        alternativa3d function calculateInverseMatrix():void
        {
            var _local_1:Number = (1 / (((((((-(this.mc) * this.mf) * this.mi) + ((this.mb * this.mg) * this.mi)) + ((this.mc * this.me) * this.mj)) - ((this.ma * this.mg) * this.mj)) - ((this.mb * this.me) * this.mk)) + ((this.ma * this.mf) * this.mk)));
            this.ima = (((-(this.mg) * this.mj) + (this.mf * this.mk)) * _local_1);
            this.imb = (((this.mc * this.mj) - (this.mb * this.mk)) * _local_1);
            this.imc = (((-(this.mc) * this.mf) + (this.mb * this.mg)) * _local_1);
            this.imd = ((((((((this.md * this.mg) * this.mj) - ((this.mc * this.mh) * this.mj)) - ((this.md * this.mf) * this.mk)) + ((this.mb * this.mh) * this.mk)) + ((this.mc * this.mf) * this.ml)) - ((this.mb * this.mg) * this.ml)) * _local_1);
            this.ime = (((this.mg * this.mi) - (this.me * this.mk)) * _local_1);
            this.imf = (((-(this.mc) * this.mi) + (this.ma * this.mk)) * _local_1);
            this.img = (((this.mc * this.me) - (this.ma * this.mg)) * _local_1);
            this.imh = ((((((((this.mc * this.mh) * this.mi) - ((this.md * this.mg) * this.mi)) + ((this.md * this.me) * this.mk)) - ((this.ma * this.mh) * this.mk)) - ((this.mc * this.me) * this.ml)) + ((this.ma * this.mg) * this.ml)) * _local_1);
            this.imi = (((-(this.mf) * this.mi) + (this.me * this.mj)) * _local_1);
            this.imj = (((this.mb * this.mi) - (this.ma * this.mj)) * _local_1);
            this.imk = (((-(this.mb) * this.me) + (this.ma * this.mf)) * _local_1);
            this.iml = ((((((((this.md * this.mf) * this.mi) - ((this.mb * this.mh) * this.mi)) - ((this.md * this.me) * this.mj)) + ((this.ma * this.mh) * this.mj)) + ((this.mb * this.me) * this.ml)) - ((this.ma * this.mf) * this.ml)) * _local_1);
        }

        alternativa3d function cullingInCamera(_arg_1:Camera3D, _arg_2:int):int
        {
            var _local_4:Vertex;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:int;
            var _local_13:Vertex;
            if (_arg_1.occludedAll)
            {
                return (-1);
            };
            var _local_3:int = _arg_1.numOccluders;
            if (((_arg_2 > 0) || (_local_3 > 0)))
            {
                _local_4 = boundVertexList;
                _local_4.x = this.boundMinX;
                _local_4.y = this.boundMinY;
                _local_4.z = this.boundMinZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMaxX;
                _local_4.y = this.boundMinY;
                _local_4.z = this.boundMinZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMinX;
                _local_4.y = this.boundMaxY;
                _local_4.z = this.boundMinZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMaxX;
                _local_4.y = this.boundMaxY;
                _local_4.z = this.boundMinZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMinX;
                _local_4.y = this.boundMinY;
                _local_4.z = this.boundMaxZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMaxX;
                _local_4.y = this.boundMinY;
                _local_4.z = this.boundMaxZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMinX;
                _local_4.y = this.boundMaxY;
                _local_4.z = this.boundMaxZ;
                _local_4 = _local_4.next;
                _local_4.x = this.boundMaxX;
                _local_4.y = this.boundMaxY;
                _local_4.z = this.boundMaxZ;
                _local_4 = boundVertexList;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.x;
                    _local_6 = _local_4.y;
                    _local_7 = _local_4.z;
                    _local_4.cameraX = ((((this.ma * _local_5) + (this.mb * _local_6)) + (this.mc * _local_7)) + this.md);
                    _local_4.cameraY = ((((this.me * _local_5) + (this.mf * _local_6)) + (this.mg * _local_7)) + this.mh);
                    _local_4.cameraZ = ((((this.mi * _local_5) + (this.mj * _local_6)) + (this.mk * _local_7)) + this.ml);
                    _local_4 = _local_4.next;
                };
            };
            if (_arg_2 > 0)
            {
                if ((_arg_2 & 0x01))
                {
                    _local_10 = _arg_1.nearClipping;
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (_local_4.cameraZ > _local_10)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x3E);
                    };
                };
                if ((_arg_2 & 0x02))
                {
                    _local_11 = _arg_1.farClipping;
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (_local_4.cameraZ < _local_11)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x3D);
                    };
                };
                if ((_arg_2 & 0x04))
                {
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (-(_local_4.cameraX) < _local_4.cameraZ)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x3B);
                    };
                };
                if ((_arg_2 & 0x08))
                {
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (_local_4.cameraX < _local_4.cameraZ)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x37);
                    };
                };
                if ((_arg_2 & 0x10))
                {
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (-(_local_4.cameraY) < _local_4.cameraZ)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x2F);
                    };
                };
                if ((_arg_2 & 0x20))
                {
                    _local_4 = boundVertexList;
                    _local_8 = false;
                    _local_9 = false;
                    while (_local_4 != null)
                    {
                        if (_local_4.cameraY < _local_4.cameraZ)
                        {
                            _local_8 = true;
                            if (_local_9) break;
                        } else
                        {
                            _local_9 = true;
                            if (_local_8) break;
                        };
                        _local_4 = _local_4.next;
                    };
                    if (_local_9)
                    {
                        if ((!(_local_8)))
                        {
                            return (-1);
                        };
                    } else
                    {
                        _arg_2 = (_arg_2 & 0x1F);
                    };
                };
            };
            if (_local_3 > 0)
            {
                _local_12 = 0;
                while (_local_12 < _local_3)
                {
                    _local_13 = _arg_1.occluders[_local_12];
                    while (_local_13 != null)
                    {
                        _local_4 = boundVertexList;
                        while (_local_4 != null)
                        {
                            if ((((_local_13.cameraX * _local_4.cameraX) + (_local_13.cameraY * _local_4.cameraY)) + (_local_13.cameraZ * _local_4.cameraZ)) >= 0) break;
                            _local_4 = _local_4.next;
                        };
                        if (_local_4 != null) break;
                        _local_13 = _local_13.next;
                    };
                    if (_local_13 == null)
                    {
                        return (-1);
                    };
                    _local_12++;
                };
            };
            this.culling = _arg_2;
            return (_arg_2);
        }

        alternativa3d function removeFromParent():void
        {
            if (this._parent != null)
            {
                this._parent.removeChild(this);
            };
        }


    }
}//package alternativa.engine3d.core