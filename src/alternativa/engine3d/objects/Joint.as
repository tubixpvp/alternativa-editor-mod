package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Vertex;
    import flash.geom.Matrix3D;
    import __AS3__.vec.Vector;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Joint extends Object3D 
    {

        alternativa3d var vertexBindingList:VertexBinding;
        alternativa3d var bma:Number;
        alternativa3d var bmb:Number;
        alternativa3d var bmc:Number;
        alternativa3d var bmd:Number;
        alternativa3d var bme:Number;
        alternativa3d var bmf:Number;
        alternativa3d var bmg:Number;
        alternativa3d var bmh:Number;
        alternativa3d var bmi:Number;
        alternativa3d var bmj:Number;
        alternativa3d var bmk:Number;
        alternativa3d var bml:Number;
        alternativa3d var _parentJoint:Joint;
        alternativa3d var _skin:Skin;
        alternativa3d var nextJoint:Joint;
        alternativa3d var childrenList:Joint;


        public function addChild(_arg_1:Joint):Joint
        {
            var _local_3:Joint;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1 == this)
            {
                throw (new ArgumentError("A joint cannot be added as a child of itself."));
            };
            var _local_2:Joint = this._parentJoint;
            while (_local_2 != null)
            {
                if (_local_2 == _arg_1)
                {
                    throw (new ArgumentError("A joint cannot be added as a child to one of it's children (or children's children, etc.)."));
                };
                _local_2 = _local_2._parentJoint;
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
            _arg_1._parentJoint = this;
            _arg_1.setSkin(this._skin);
            if (this.childrenList == null)
            {
                this.childrenList = _arg_1;
            } else
            {
                _local_3 = this.childrenList;
                while (_local_3 != null)
                {
                    if (_local_3.nextJoint == null)
                    {
                        _local_3.nextJoint = _arg_1;
                        break;
                    };
                    _local_3 = _local_3.nextJoint;
                };
            };
            return (_arg_1);
        }

        alternativa3d function addChildFast(_arg_1:Joint):Joint
        {
            var _local_2:Joint;
            _arg_1._parentJoint = this;
            _arg_1.setSkinFast(this._skin);
            if (this.childrenList == null)
            {
                this.childrenList = _arg_1;
            } else
            {
                _local_2 = this.childrenList;
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

        public function removeChild(_arg_1:Joint):Joint
        {
            var _local_2:Joint;
            var _local_3:Joint;
            if (_arg_1 == null)
            {
                throw (new TypeError("Parameter child must be non-null."));
            };
            if (_arg_1._parentJoint != this)
            {
                throw (new ArgumentError("The supplied Joint must be a child of the caller."));
            };
            _local_3 = this.childrenList;
            while (_local_3 != null)
            {
                if (_local_3 == _arg_1)
                {
                    if (_local_2 != null)
                    {
                        _local_2.nextJoint = _local_3.nextJoint;
                    } else
                    {
                        this.childrenList = _local_3.nextJoint;
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

        public function getChildAt(_arg_1:int):Joint
        {
            if (_arg_1 < 0)
            {
                throw (new RangeError("The supplied index is out of bounds."));
            };
            var _local_2:Joint = this.childrenList;
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

        public function get numChildren():int
        {
            var _local_1:int;
            var _local_2:Joint = this.childrenList;
            while (_local_2 != null)
            {
                _local_1++;
                _local_2 = _local_2.nextJoint;
            };
            return (_local_1);
        }

        public function get skin():Skin
        {
            return (this._skin);
        }

        public function get parentJoint():Joint
        {
            return (this._parentJoint);
        }

        public function bindVertex(_arg_1:Vertex, _arg_2:Number):void
        {
            var _local_4:Vertex;
            var _local_5:VertexBinding;
            if (this._skin != null)
            {
                _local_4 = this._skin.vertexList;
                while (_local_4 != null)
                {
                    if (_local_4 == _arg_1) break;
                    _local_4 = _local_4.next;
                };
                if (_local_4 == null)
                {
                    throw (new ArgumentError("Vertex not found"));
                };
            } else
            {
                throw (new ArgumentError("Vertex not found"));
            };
            var _local_3:VertexBinding = this.vertexBindingList;
            while (_local_3 != null)
            {
                if (_local_3.vertex == _arg_1) break;
                _local_3 = _local_3.next;
            };
            if (_local_3 != null)
            {
                _local_3.weight = _arg_2;
            } else
            {
                _local_5 = new VertexBinding();
                _local_5.next = this.vertexBindingList;
                this.vertexBindingList = _local_5;
                _local_5.vertex = _arg_1;
                _local_5.weight = _arg_2;
            };
        }

        public function unbindVertex(_arg_1:Vertex):void
        {
            var _local_2:VertexBinding;
            var _local_3:VertexBinding;
            _local_3 = this.vertexBindingList;
            while (_local_3 != null)
            {
                if (_local_3.vertex == _arg_1)
                {
                    if (_local_2 != null)
                    {
                        _local_2.next = _local_3.next;
                    } else
                    {
                        this.vertexBindingList = _local_3.next;
                    };
                    _local_3.next = null;
                    return;
                };
                _local_2 = _local_3;
                _local_3 = _local_3.next;
            };
        }

        alternativa3d function calculateBindingMatrix(_arg_1:Object3D):void
        {
            composeAndAppend(_arg_1);
            var _local_2:Number = (1 / (((((((-(mc) * mf) * mi) + ((mb * mg) * mi)) + ((mc * me) * mj)) - ((ma * mg) * mj)) - ((mb * me) * mk)) + ((ma * mf) * mk)));
            this.bma = (((-(mg) * mj) + (mf * mk)) * _local_2);
            this.bmb = (((mc * mj) - (mb * mk)) * _local_2);
            this.bmc = (((-(mc) * mf) + (mb * mg)) * _local_2);
            this.bmd = ((((((((md * mg) * mj) - ((mc * mh) * mj)) - ((md * mf) * mk)) + ((mb * mh) * mk)) + ((mc * mf) * ml)) - ((mb * mg) * ml)) * _local_2);
            this.bme = (((mg * mi) - (me * mk)) * _local_2);
            this.bmf = (((-(mc) * mi) + (ma * mk)) * _local_2);
            this.bmg = (((mc * me) - (ma * mg)) * _local_2);
            this.bmh = ((((((((mc * mh) * mi) - ((md * mg) * mi)) + ((md * me) * mk)) - ((ma * mh) * mk)) - ((mc * me) * ml)) + ((ma * mg) * ml)) * _local_2);
            this.bmi = (((-(mf) * mi) + (me * mj)) * _local_2);
            this.bmj = (((mb * mi) - (ma * mj)) * _local_2);
            this.bmk = (((-(mb) * me) + (ma * mf)) * _local_2);
            this.bml = ((((((((md * mf) * mi) - ((mb * mh) * mi)) - ((md * me) * mj)) + ((ma * mh) * mj)) + ((mb * me) * ml)) - ((ma * mf) * ml)) * _local_2);
            var _local_3:Joint = this.childrenList;
            while (_local_3 != null)
            {
                _local_3.calculateBindingMatrix(this);
                _local_3 = _local_3.nextJoint;
            };
        }

        override public function get matrix():Matrix3D
        {
            return (super.matrix);
        }

        override public function set matrix(_arg_1:Matrix3D):void
        {
            var _local_2:Vector.<Vector3D> = _arg_1.decompose();
            var _local_3:Vector3D = _local_2[0];
            var _local_4:Vector3D = _local_2[1];
            var _local_5:Vector3D = _local_2[2];
            x = _local_3.x;
            y = _local_3.y;
            z = _local_3.z;
            rotationX = _local_4.x;
            rotationY = _local_4.y;
            rotationZ = _local_4.z;
            scaleX = _local_5.x;
            scaleY = _local_5.y;
            scaleZ = _local_5.z;
        }

        override public function get concatenatedMatrix():Matrix3D
        {
            var _local_2:Object3D;
            tA.composeMatrixFromSource(this);
            var _local_1:Joint = this;
            while (_local_1._parentJoint != null)
            {
                _local_1 = _local_1._parentJoint;
                tB.composeMatrixFromSource(_local_1);
                tA.appendMatrix(tB);
            };
            if (this._skin != null)
            {
                tB.composeMatrixFromSource(this._skin);
                tA.appendMatrix(tB);
                _local_2 = this._skin;
                while (_local_2._parent != null)
                {
                    _local_2 = _local_2._parent;
                    tB.composeMatrixFromSource(_local_2);
                    tA.appendMatrix(tB);
                };
            };
            return (new Matrix3D(Vector.<Number>([tA.ma, tA.me, tA.mi, 0, tA.mb, tA.mf, tA.mj, 0, tA.mc, tA.mg, tA.mk, 0, tA.md, tA.mh, tA.ml, 1])));
        }

        override public function localToGlobal(_arg_1:Vector3D):Vector3D
        {
            var _local_4:Object3D;
            tA.composeMatrixFromSource(this);
            var _local_2:Joint = this;
            while (_local_2._parentJoint != null)
            {
                _local_2 = _local_2._parentJoint;
                tB.composeMatrixFromSource(_local_2);
                tA.appendMatrix(tB);
            };
            if (this._skin != null)
            {
                tB.composeMatrixFromSource(this._skin);
                tA.appendMatrix(tB);
                _local_4 = this._skin;
                while (_local_4._parent != null)
                {
                    _local_4 = _local_4._parent;
                    tB.composeMatrixFromSource(_local_4);
                    tA.appendMatrix(tB);
                };
            };
            var _local_3:Vector3D = new Vector3D();
            _local_3.x = ((((tA.ma * _arg_1.x) + (tA.mb * _arg_1.y)) + (tA.mc * _arg_1.z)) + tA.md);
            _local_3.y = ((((tA.me * _arg_1.x) + (tA.mf * _arg_1.y)) + (tA.mg * _arg_1.z)) + tA.mh);
            _local_3.z = ((((tA.mi * _arg_1.x) + (tA.mj * _arg_1.y)) + (tA.mk * _arg_1.z)) + tA.ml);
            return (_local_3);
        }

        override public function globalToLocal(_arg_1:Vector3D):Vector3D
        {
            var _local_4:Object3D;
            tA.composeMatrixFromSource(this);
            var _local_2:Joint = this;
            while (_local_2._parentJoint != null)
            {
                _local_2 = _local_2._parentJoint;
                tB.composeMatrixFromSource(_local_2);
                tA.appendMatrix(tB);
            };
            if (this._skin != null)
            {
                tB.composeMatrixFromSource(this._skin);
                tA.appendMatrix(tB);
                _local_4 = this._skin;
                while (_local_4._parent != null)
                {
                    _local_4 = _local_4._parent;
                    tB.composeMatrixFromSource(_local_4);
                    tA.appendMatrix(tB);
                };
            };
            tA.invertMatrix();
            var _local_3:Vector3D = new Vector3D();
            _local_3.x = ((((tA.ma * _arg_1.x) + (tA.mb * _arg_1.y)) + (tA.mc * _arg_1.z)) + tA.md);
            _local_3.y = ((((tA.me * _arg_1.x) + (tA.mf * _arg_1.y)) + (tA.mg * _arg_1.z)) + tA.mh);
            _local_3.z = ((((tA.mi * _arg_1.x) + (tA.mj * _arg_1.y)) + (tA.mk * _arg_1.z)) + tA.ml);
            return (_local_3);
        }

        public function get bindingMatrix():Matrix3D
        {
            return (new Matrix3D(Vector.<Number>([this.bma, this.bme, this.bmi, 0, this.bmb, this.bmf, this.bmj, 0, this.bmc, this.bmg, this.bmk, 0, this.bmd, this.bmh, this.bml, 1])));
        }

        public function set bindingMatrix(_arg_1:Matrix3D):void
        {
            var _local_2:Vector.<Number> = _arg_1.rawData;
            this.bma = _local_2[0];
            this.bmb = _local_2[4];
            this.bmc = _local_2[8];
            this.bmd = _local_2[12];
            this.bme = _local_2[1];
            this.bmf = _local_2[5];
            this.bmg = _local_2[9];
            this.bmh = _local_2[13];
            this.bmi = _local_2[2];
            this.bmj = _local_2[6];
            this.bmk = _local_2[10];
            this.bml = _local_2[14];
        }

        alternativa3d function addWeights():void
        {
            var _local_1:VertexBinding = this.vertexBindingList;
            while (_local_1 != null)
            {
                _local_1.vertex.offset = (_local_1.vertex.offset + _local_1.weight);
                _local_1 = _local_1.next;
            };
            var _local_2:Joint = this.childrenList;
            while (_local_2 != null)
            {
                _local_2.addWeights();
                _local_2 = _local_2.nextJoint;
            };
        }

        alternativa3d function normalizeWeights():void
        {
            var _local_1:VertexBinding = this.vertexBindingList;
            while (_local_1 != null)
            {
                _local_1.weight = (_local_1.weight / _local_1.vertex.offset);
                _local_1 = _local_1.next;
            };
            var _local_2:Joint = this.childrenList;
            while (_local_2 != null)
            {
                _local_2.normalizeWeights();
                _local_2 = _local_2.nextJoint;
            };
        }

        alternativa3d function drawDebug(_arg_1:Camera3D):void
        {
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            appendMatrix(this._skin);
            var _local_2:Number = ((md * _arg_1.viewSizeX) / ml);
            var _local_3:Number = ((mh * _arg_1.viewSizeY) / ml);
            var _local_8:Number = (_arg_1.focalLength / _arg_1.viewSizeX);
            var _local_9:Number = (_arg_1.focalLength / _arg_1.viewSizeY);
            var _local_10:Joint = this.childrenList;
            while (_local_10 != null)
            {
                _local_4 = ((((mi * _local_10.x) + (mj * _local_10.y)) + (mk * _local_10.z)) + ml);
                _local_5 = ((((((ma * _local_10.x) + (mb * _local_10.y)) + (mc * _local_10.z)) + md) * _arg_1.viewSizeX) / _local_4);
                _local_6 = ((((((me * _local_10.x) + (mf * _local_10.y)) + (mg * _local_10.z)) + mh) * _arg_1.viewSizeY) / _local_4);
                _local_11 = ((((ma * _local_10.x) + (mb * _local_10.y)) + (mc * _local_10.z)) / _local_8);
                _local_12 = ((((me * _local_10.x) + (mf * _local_10.y)) + (mg * _local_10.z)) / _local_9);
                _local_13 = (((mi * _local_10.x) + (mj * _local_10.y)) + (mk * _local_10.z));
                _local_7 = Math.sqrt((((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_13 * _local_13)));
                if (((ml > 0) && (_local_4 > 0)))
                {
                    Debug.drawBone(_arg_1, _local_2, _local_3, _local_5, _local_6, (((_local_7 / 10) * _arg_1.focalLength) / ml), 0xFF);
                };
                _local_10.drawDebug(_arg_1);
                _local_10 = _local_10.nextJoint;
            };
        }

        alternativa3d function calculateVertices(_arg_1:Boolean, _arg_2:Boolean):void
        {
            var _local_15:VertexBinding;
            var _local_16:Vertex;
            var _local_17:Number;
            var _local_18:Vertex;
            var _local_19:Joint;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Number;
            var _local_29:Number;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_3:Number = (((ma * this.bma) + (mb * this.bme)) + (mc * this.bmi));
            var _local_4:Number = (((ma * this.bmb) + (mb * this.bmf)) + (mc * this.bmj));
            var _local_5:Number = (((ma * this.bmc) + (mb * this.bmg)) + (mc * this.bmk));
            var _local_6:Number = ((((ma * this.bmd) + (mb * this.bmh)) + (mc * this.bml)) + md);
            var _local_7:Number = (((me * this.bma) + (mf * this.bme)) + (mg * this.bmi));
            var _local_8:Number = (((me * this.bmb) + (mf * this.bmf)) + (mg * this.bmj));
            var _local_9:Number = (((me * this.bmc) + (mf * this.bmg)) + (mg * this.bmk));
            var _local_10:Number = ((((me * this.bmd) + (mf * this.bmh)) + (mg * this.bml)) + mh);
            var _local_11:Number = (((mi * this.bma) + (mj * this.bme)) + (mk * this.bmi));
            var _local_12:Number = (((mi * this.bmb) + (mj * this.bmf)) + (mk * this.bmj));
            var _local_13:Number = (((mi * this.bmc) + (mj * this.bmg)) + (mk * this.bmk));
            var _local_14:Number = ((((mi * this.bmd) + (mj * this.bmh)) + (mk * this.bml)) + ml);
            if (_arg_1)
            {
                _arg_2 = ((_arg_2) || (((!(scaleX == 1)) || (!(scaleY == 1))) || (!(scaleZ == 1))));
                if (_arg_2)
                {
                    _local_20 = (1 / (((((((-(_local_5) * _local_8) * _local_11) + ((_local_4 * _local_9) * _local_11)) + ((_local_5 * _local_7) * _local_12)) - ((_local_3 * _local_9) * _local_12)) - ((_local_4 * _local_7) * _local_13)) + ((_local_3 * _local_8) * _local_13)));
                    _local_21 = (((-(_local_9) * _local_12) + (_local_8 * _local_13)) * _local_20);
                    _local_22 = (((_local_5 * _local_12) - (_local_4 * _local_13)) * _local_20);
                    _local_23 = (((-(_local_5) * _local_8) + (_local_4 * _local_9)) * _local_20);
                    _local_24 = ((((((((_local_6 * _local_9) * _local_12) - ((_local_5 * _local_10) * _local_12)) - ((_local_6 * _local_8) * _local_13)) + ((_local_4 * _local_10) * _local_13)) + ((_local_5 * _local_8) * _local_14)) - ((_local_4 * _local_9) * _local_14)) * _local_20);
                    _local_25 = (((_local_9 * _local_11) - (_local_7 * _local_13)) * _local_20);
                    _local_26 = (((-(_local_5) * _local_11) + (_local_3 * _local_13)) * _local_20);
                    _local_27 = (((_local_5 * _local_7) - (_local_3 * _local_9)) * _local_20);
                    _local_28 = ((((((((_local_5 * _local_10) * _local_11) - ((_local_6 * _local_9) * _local_11)) + ((_local_6 * _local_7) * _local_13)) - ((_local_3 * _local_10) * _local_13)) - ((_local_5 * _local_7) * _local_14)) + ((_local_3 * _local_9) * _local_14)) * _local_20);
                    _local_29 = (((-(_local_8) * _local_11) + (_local_7 * _local_12)) * _local_20);
                    _local_30 = (((_local_4 * _local_11) - (_local_3 * _local_12)) * _local_20);
                    _local_31 = (((-(_local_4) * _local_7) + (_local_3 * _local_8)) * _local_20);
                    _local_32 = ((((((((_local_6 * _local_8) * _local_11) - ((_local_4 * _local_10) * _local_11)) - ((_local_6 * _local_7) * _local_12)) + ((_local_3 * _local_10) * _local_12)) + ((_local_4 * _local_7) * _local_14)) - ((_local_3 * _local_8) * _local_14)) * _local_20);
                    _local_15 = this.vertexBindingList;
                    while (_local_15 != null)
                    {
                        _local_16 = _local_15.vertex;
                        _local_17 = _local_15.weight;
                        _local_18 = _local_16.value;
                        _local_18.x = (_local_18.x + (((((_local_3 * _local_16.x) + (_local_4 * _local_16.y)) + (_local_5 * _local_16.z)) + _local_6) * _local_17));
                        _local_18.y = (_local_18.y + (((((_local_7 * _local_16.x) + (_local_8 * _local_16.y)) + (_local_9 * _local_16.z)) + _local_10) * _local_17));
                        _local_18.z = (_local_18.z + (((((_local_11 * _local_16.x) + (_local_12 * _local_16.y)) + (_local_13 * _local_16.z)) + _local_14) * _local_17));
                        _local_18.normalX = (_local_18.normalX + ((((_local_21 * _local_16.normalX) + (_local_25 * _local_16.normalY)) + (_local_29 * _local_16.normalZ)) * _local_17));
                        _local_18.normalY = (_local_18.normalY + ((((_local_22 * _local_16.normalX) + (_local_26 * _local_16.normalY)) + (_local_30 * _local_16.normalZ)) * _local_17));
                        _local_18.normalZ = (_local_18.normalZ + ((((_local_23 * _local_16.normalX) + (_local_27 * _local_16.normalY)) + (_local_31 * _local_16.normalZ)) * _local_17));
                        _local_15 = _local_15.next;
                    };
                } else
                {
                    _local_15 = this.vertexBindingList;
                    while (_local_15 != null)
                    {
                        _local_16 = _local_15.vertex;
                        _local_17 = _local_15.weight;
                        _local_18 = _local_16.value;
                        _local_18.x = (_local_18.x + (((((_local_3 * _local_16.x) + (_local_4 * _local_16.y)) + (_local_5 * _local_16.z)) + _local_6) * _local_17));
                        _local_18.y = (_local_18.y + (((((_local_7 * _local_16.x) + (_local_8 * _local_16.y)) + (_local_9 * _local_16.z)) + _local_10) * _local_17));
                        _local_18.z = (_local_18.z + (((((_local_11 * _local_16.x) + (_local_12 * _local_16.y)) + (_local_13 * _local_16.z)) + _local_14) * _local_17));
                        _local_18.normalX = (_local_18.normalX + ((((_local_3 * _local_16.normalX) + (_local_4 * _local_16.normalY)) + (_local_5 * _local_16.normalZ)) * _local_17));
                        _local_18.normalY = (_local_18.normalY + ((((_local_7 * _local_16.normalX) + (_local_8 * _local_16.normalY)) + (_local_9 * _local_16.normalZ)) * _local_17));
                        _local_18.normalZ = (_local_18.normalZ + ((((_local_11 * _local_16.normalX) + (_local_12 * _local_16.normalY)) + (_local_13 * _local_16.normalZ)) * _local_17));
                        _local_15 = _local_15.next;
                    };
                };
            } else
            {
                _local_15 = this.vertexBindingList;
                while (_local_15 != null)
                {
                    _local_16 = _local_15.vertex;
                    _local_17 = _local_15.weight;
                    _local_18 = _local_16.value;
                    _local_18.x = (_local_18.x + (((((_local_3 * _local_16.x) + (_local_4 * _local_16.y)) + (_local_5 * _local_16.z)) + _local_6) * _local_17));
                    _local_18.y = (_local_18.y + (((((_local_7 * _local_16.x) + (_local_8 * _local_16.y)) + (_local_9 * _local_16.z)) + _local_10) * _local_17));
                    _local_18.z = (_local_18.z + (((((_local_11 * _local_16.x) + (_local_12 * _local_16.y)) + (_local_13 * _local_16.z)) + _local_14) * _local_17));
                    _local_15 = _local_15.next;
                };
            };
            _local_19 = this.childrenList;
            while (_local_19 != null)
            {
                _local_19.composeAndAppend(this);
                _local_19.calculateVertices(_arg_1, _arg_2);
                _local_19 = _local_19.nextJoint;
            };
        }

        alternativa3d function setSkin(_arg_1:Skin):void
        {
            this.vertexBindingList = null;
            this._skin = _arg_1;
            var _local_2:Joint = this.childrenList;
            while (_local_2 != null)
            {
                _local_2.setSkin(_arg_1);
                _local_2 = _local_2.nextJoint;
            };
        }

        alternativa3d function setSkinFast(_arg_1:Skin):void
        {
            this._skin = _arg_1;
            var _local_2:Joint = this.childrenList;
            while (_local_2 != null)
            {
                _local_2.setSkinFast(_arg_1);
                _local_2 = _local_2.nextJoint;
            };
        }


    }
}//package alternativa.engine3d.objects