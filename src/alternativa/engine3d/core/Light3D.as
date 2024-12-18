package alternativa.engine3d.core
{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Light3D extends Object3D 
    {

        public var color:uint;
        public var intensity:Number = 1;
        alternativa3d var localWeight:Number;
        alternativa3d var localRed:Number;
        alternativa3d var localGreen:Number;
        alternativa3d var localBlue:Number;
        alternativa3d var cma:Number;
        alternativa3d var cmb:Number;
        alternativa3d var cmc:Number;
        alternativa3d var cmd:Number;
        alternativa3d var cme:Number;
        alternativa3d var cmf:Number;
        alternativa3d var cmg:Number;
        alternativa3d var cmh:Number;
        alternativa3d var cmi:Number;
        alternativa3d var cmj:Number;
        alternativa3d var cmk:Number;
        alternativa3d var cml:Number;
        alternativa3d var oma:Number;
        alternativa3d var omb:Number;
        alternativa3d var omc:Number;
        alternativa3d var omd:Number;
        alternativa3d var ome:Number;
        alternativa3d var omf:Number;
        alternativa3d var omg:Number;
        alternativa3d var omh:Number;
        alternativa3d var omi:Number;
        alternativa3d var omj:Number;
        alternativa3d var omk:Number;
        alternativa3d var oml:Number;
        alternativa3d var nextLight:Light3D;


        override public function clone():Object3D
        {
            var _local_1:Light3D = new Light3D();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Light3D = (_arg_1 as Light3D);
            this.color = _local_2.color;
            this.intensity = _local_2.intensity;
        }

        alternativa3d function calculateCameraMatrix(_arg_1:Camera3D):void
        {
            composeMatrix();
            var _local_2:Object3D = this;
            while (_local_2._parent != null)
            {
                _local_2 = _local_2._parent;
                _local_2.composeMatrix();
                appendMatrix(_local_2);
            };
            appendMatrix(_arg_1);
            this.cma = ma;
            this.cmb = mb;
            this.cmc = mc;
            this.cmd = md;
            this.cme = me;
            this.cmf = mf;
            this.cmg = mg;
            this.cmh = mh;
            this.cmi = mi;
            this.cmj = mj;
            this.cmk = mk;
            this.cml = ml;
        }

        alternativa3d function calculateObjectMatrix(_arg_1:Object3D):void
        {
            this.oma = (((_arg_1.ima * this.cma) + (_arg_1.imb * this.cme)) + (_arg_1.imc * this.cmi));
            this.omb = (((_arg_1.ima * this.cmb) + (_arg_1.imb * this.cmf)) + (_arg_1.imc * this.cmj));
            this.omc = (((_arg_1.ima * this.cmc) + (_arg_1.imb * this.cmg)) + (_arg_1.imc * this.cmk));
            this.omd = ((((_arg_1.ima * this.cmd) + (_arg_1.imb * this.cmh)) + (_arg_1.imc * this.cml)) + _arg_1.imd);
            this.ome = (((_arg_1.ime * this.cma) + (_arg_1.imf * this.cme)) + (_arg_1.img * this.cmi));
            this.omf = (((_arg_1.ime * this.cmb) + (_arg_1.imf * this.cmf)) + (_arg_1.img * this.cmj));
            this.omg = (((_arg_1.ime * this.cmc) + (_arg_1.imf * this.cmg)) + (_arg_1.img * this.cmk));
            this.omh = ((((_arg_1.ime * this.cmd) + (_arg_1.imf * this.cmh)) + (_arg_1.img * this.cml)) + _arg_1.imh);
            this.omi = (((_arg_1.imi * this.cma) + (_arg_1.imj * this.cme)) + (_arg_1.imk * this.cmi));
            this.omj = (((_arg_1.imi * this.cmb) + (_arg_1.imj * this.cmf)) + (_arg_1.imk * this.cmj));
            this.omk = (((_arg_1.imi * this.cmc) + (_arg_1.imj * this.cmg)) + (_arg_1.imk * this.cmk));
            this.oml = ((((_arg_1.imi * this.cmd) + (_arg_1.imj * this.cmh)) + (_arg_1.imk * this.cml)) + _arg_1.iml);
        }

        override alternativa3d function setParent(_arg_1:Object3DContainer):void
        {
            var _local_2:Object3DContainer;
            var _local_3:Light3D;
            var _local_4:Light3D;
            if (_arg_1 == null)
            {
                _local_2 = _parent;
                while (_local_2._parent != null)
                {
                    _local_2 = _local_2._parent;
                };
                _local_4 = _local_2.lightList;
                while (_local_4 != null)
                {
                    if (_local_4 == this)
                    {
                        if (_local_3 != null)
                        {
                            _local_3.nextLight = this.nextLight;
                        }
                        else
                        {
                            _local_2.lightList = this.nextLight;
                        };
                        this.nextLight = null;
                        break;
                    };
                    _local_3 = _local_4;
                    _local_4 = _local_4.nextLight;
                };
            }
            else
            {
                _local_2 = _arg_1;
                while (_local_2._parent != null)
                {
                    _local_2 = _local_2._parent;
                };
                this.nextLight = _local_2.lightList;
                _local_2.lightList = this;
            };
            _parent = _arg_1;
        }

        alternativa3d function drawDebug(_arg_1:Camera3D):void
        {
        }

        override alternativa3d function updateBounds(_arg_1:Object3D, _arg_2:Object3D=null):void
        {
            _arg_1.boundMinX = -1E22;
            _arg_1.boundMinY = -1E22;
            _arg_1.boundMinZ = -1E22;
            _arg_1.boundMaxX = 1E22;
            _arg_1.boundMaxY = 1E22;
            _arg_1.boundMaxZ = 1E22;
        }

        override alternativa3d function cullingInCamera(_arg_1:Camera3D, _arg_2:int):int
        {
            return (-1);
        }

        alternativa3d function checkFrustumCulling(_arg_1:Camera3D):Boolean
        {
            var _local_2:Vertex = boundVertexList;
            _local_2.x = boundMinX;
            _local_2.y = boundMinY;
            _local_2.z = boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMaxX;
            _local_2.y = boundMinY;
            _local_2.z = boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMinX;
            _local_2.y = boundMaxY;
            _local_2.z = boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMaxX;
            _local_2.y = boundMaxY;
            _local_2.z = boundMinZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMinX;
            _local_2.y = boundMinY;
            _local_2.z = boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMaxX;
            _local_2.y = boundMinY;
            _local_2.z = boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMinX;
            _local_2.y = boundMaxY;
            _local_2.z = boundMaxZ;
            _local_2 = _local_2.next;
            _local_2.x = boundMaxX;
            _local_2.y = boundMaxY;
            _local_2.z = boundMaxZ;
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                _local_2.cameraX = ((((ma * _local_2.x) + (mb * _local_2.y)) + (mc * _local_2.z)) + md);
                _local_2.cameraY = ((((me * _local_2.x) + (mf * _local_2.y)) + (mg * _local_2.z)) + mh);
                _local_2.cameraZ = ((((mi * _local_2.x) + (mj * _local_2.y)) + (mk * _local_2.z)) + ml);
                _local_2 = _local_2.next;
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (_local_2.cameraZ > _arg_1.nearClipping) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (_local_2.cameraZ < _arg_1.farClipping) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (-(_local_2.cameraX) < _local_2.cameraZ) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (_local_2.cameraX < _local_2.cameraZ) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (-(_local_2.cameraY) < _local_2.cameraZ) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2 = boundVertexList;
            while (_local_2 != null)
            {
                if (_local_2.cameraY < _local_2.cameraZ) break;
                _local_2 = _local_2.next;
            };
            if (_local_2 == null)
            {
                return (false);
            };
            return (true);
        }

        alternativa3d function checkBoundsIntersection(_arg_1:Object3D):Boolean
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number = ((boundMaxX - boundMinX) * 0.5);
            var _local_5:Number = ((boundMaxY - boundMinY) * 0.5);
            var _local_6:Number = ((boundMaxZ - boundMinZ) * 0.5);
            var _local_7:Number = (this.oma * _local_4);
            var _local_8:Number = (this.ome * _local_4);
            var _local_9:Number = (this.omi * _local_4);
            var _local_10:Number = (this.omb * _local_5);
            var _local_11:Number = (this.omf * _local_5);
            var _local_12:Number = (this.omj * _local_5);
            var _local_13:Number = (this.omc * _local_6);
            var _local_14:Number = (this.omg * _local_6);
            var _local_15:Number = (this.omk * _local_6);
            var _local_16:Number = ((_arg_1.boundMaxX - _arg_1.boundMinX) * 0.5);
            var _local_17:Number = ((_arg_1.boundMaxY - _arg_1.boundMinY) * 0.5);
            var _local_18:Number = ((_arg_1.boundMaxZ - _arg_1.boundMinZ) * 0.5);
            var _local_19:Number = ((((((this.oma * (boundMinX + _local_4)) + (this.omb * (boundMinY + _local_5))) + (this.omc * (boundMinZ + _local_6))) + this.omd) - _arg_1.boundMinX) - _local_16);
            var _local_20:Number = ((((((this.ome * (boundMinX + _local_4)) + (this.omf * (boundMinY + _local_5))) + (this.omg * (boundMinZ + _local_6))) + this.omh) - _arg_1.boundMinY) - _local_17);
            var _local_21:Number = ((((((this.omi * (boundMinX + _local_4)) + (this.omj * (boundMinY + _local_5))) + (this.omk * (boundMinZ + _local_6))) + this.oml) - _arg_1.boundMinZ) - _local_18);
            _local_2 = 0;
            _local_3 = ((_local_7 >= 0) ? _local_7 : -(_local_7));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_10 >= 0) ? _local_10 : -(_local_10));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_13 >= 0) ? _local_13 : -(_local_13));
            _local_2 = (_local_2 + _local_3);
            _local_2 = (_local_2 + _local_16);
            _local_3 = ((_local_19 >= 0) ? _local_19 : -(_local_19));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            _local_2 = 0;
            _local_3 = ((_local_8 >= 0) ? _local_8 : -(_local_8));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_11 >= 0) ? _local_11 : -(_local_11));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_14 >= 0) ? _local_14 : -(_local_14));
            _local_2 = (_local_2 + _local_3);
            _local_2 = (_local_2 + _local_17);
            _local_3 = ((_local_20 >= 0) ? _local_20 : -(_local_20));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            _local_2 = 0;
            _local_3 = ((_local_9 >= 0) ? _local_9 : -(_local_9));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_12 >= 0) ? _local_12 : -(_local_12));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((_local_15 >= 0) ? _local_15 : -(_local_15));
            _local_2 = (_local_2 + _local_3);
            _local_2 = (_local_2 + _local_17);
            _local_3 = ((_local_21 >= 0) ? _local_21 : -(_local_21));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            _local_2 = 0;
            _local_3 = (((this.oma * _local_7) + (this.ome * _local_8)) + (this.omi * _local_9));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.oma * _local_10) + (this.ome * _local_11)) + (this.omi * _local_12));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.oma * _local_13) + (this.ome * _local_14)) + (this.omi * _local_15));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.oma >= 0) ? (this.oma * _local_16) : (-(this.oma) * _local_16));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.ome >= 0) ? (this.ome * _local_17) : (-(this.ome) * _local_17));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omi >= 0) ? (this.omi * _local_18) : (-(this.omi) * _local_18));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.oma * _local_19) + (this.ome * _local_20)) + (this.omi * _local_21));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            _local_2 = 0;
            _local_3 = (((this.omb * _local_7) + (this.omf * _local_8)) + (this.omj * _local_9));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omb * _local_10) + (this.omf * _local_11)) + (this.omj * _local_12));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omb * _local_13) + (this.omf * _local_14)) + (this.omj * _local_15));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omb >= 0) ? (this.omb * _local_16) : (-(this.omb) * _local_16));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omf >= 0) ? (this.omf * _local_17) : (-(this.omf) * _local_17));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omj >= 0) ? (this.omj * _local_18) : (-(this.omj) * _local_18));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omb * _local_19) + (this.omf * _local_20)) + (this.omj * _local_21));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            _local_2 = 0;
            _local_3 = (((this.omc * _local_7) + (this.omg * _local_8)) + (this.omk * _local_9));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omc * _local_10) + (this.omg * _local_11)) + (this.omk * _local_12));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omc * _local_13) + (this.omg * _local_14)) + (this.omk * _local_15));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omc >= 0) ? (this.omc * _local_16) : (-(this.omc) * _local_16));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omg >= 0) ? (this.omg * _local_17) : (-(this.omg) * _local_17));
            _local_2 = (_local_2 + _local_3);
            _local_3 = ((this.omk >= 0) ? (this.omk * _local_18) : (-(this.omk) * _local_18));
            _local_2 = (_local_2 + _local_3);
            _local_3 = (((this.omc * _local_19) + (this.omg * _local_20)) + (this.omk * _local_21));
            _local_3 = ((_local_3 >= 0) ? _local_3 : -(_local_3));
            _local_2 = (_local_2 - _local_3);
            if (_local_2 <= 0)
            {
                return (false);
            };
            return (true);
        }


    }
}//package alternativa.engine3d.core