package alternativa.engine3d.core{
    import __AS3__.vec.Vector;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class EllipsoidCollider {

        public var radiusX:Number;
        public var radiusY:Number;
        public var radiusZ:Number;
        public var threshold:Number = 0.001;
        private var matrix:Object3D = new Object3D();
        private var faces:Vector.<Face> = new Vector.<Face>();
        private var facesLength:int;
        private var radius:Number;
        private var src:Vector3D = new Vector3D();
        private var displ:Vector3D = new Vector3D();
        private var dest:Vector3D = new Vector3D();
        private var collisionPoint:Vector3D = new Vector3D();
        private var collisionPlane:Vector3D = new Vector3D();
        private var vCenter:Vector3D = new Vector3D();
        private var vA:Vector3D = new Vector3D();
        private var vB:Vector3D = new Vector3D();
        private var vC:Vector3D = new Vector3D();
        private var vD:Vector3D = new Vector3D();

        public function EllipsoidCollider(_arg_1:Number, _arg_2:Number, _arg_3:Number){
            this.radiusX = _arg_1;
            this.radiusY = _arg_2;
            this.radiusZ = _arg_3;
        }

        private function prepare(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Object3D, _arg_4:Dictionary, _arg_5:Boolean):void{
            var _local_6:Number;
            this.radius = this.radiusX;
            if (this.radiusY > this.radius)
            {
                this.radius = this.radiusY;
            };
            if (this.radiusZ > this.radius)
            {
                this.radius = this.radiusZ;
            };
            this.matrix.scaleX = (this.radiusX / this.radius);
            this.matrix.scaleY = (this.radiusY / this.radius);
            this.matrix.scaleZ = (this.radiusZ / this.radius);
            this.matrix.x = _arg_1.x;
            this.matrix.y = _arg_1.y;
            this.matrix.z = _arg_1.z;
            this.matrix.composeMatrix();
            this.matrix.invertMatrix();
            this.src.x = 0;
            this.src.y = 0;
            this.src.z = 0;
            this.displ.x = (((this.matrix.ma * _arg_2.x) + (this.matrix.mb * _arg_2.y)) + (this.matrix.mc * _arg_2.z));
            this.displ.y = (((this.matrix.me * _arg_2.x) + (this.matrix.mf * _arg_2.y)) + (this.matrix.mg * _arg_2.z));
            this.displ.z = (((this.matrix.mi * _arg_2.x) + (this.matrix.mj * _arg_2.y)) + (this.matrix.mk * _arg_2.z));
            this.dest.x = (this.src.x + this.displ.x);
            this.dest.y = (this.src.y + this.displ.y);
            this.dest.z = (this.src.z + this.displ.z);
            if (_arg_5)
            {
                this.vCenter.x = (this.displ.x / 2);
                this.vCenter.y = (this.displ.y / 2);
                this.vCenter.z = (this.displ.z / 2);
                _local_6 = (this.radius + (this.displ.length / 2));
            }
            else
            {
                this.vCenter.x = 0;
                this.vCenter.y = 0;
                this.vCenter.z = 0;
                _local_6 = (this.radius + this.displ.length);
            };
            this.vA.x = -(_local_6);
            this.vA.y = -(_local_6);
            this.vA.z = -(_local_6);
            this.vB.x = _local_6;
            this.vB.y = -(_local_6);
            this.vB.z = -(_local_6);
            this.vC.x = _local_6;
            this.vC.y = _local_6;
            this.vC.z = -(_local_6);
            this.vD.x = -(_local_6);
            this.vD.y = _local_6;
            this.vD.z = -(_local_6);
            _arg_3.composeAndAppend(this.matrix);
            _arg_3.collectPlanes(this.vCenter, this.vA, this.vB, this.vC, this.vD, this.faces, _arg_4);
            this.facesLength = this.faces.length;
        }

        public function calculateDestination(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Object3D, _arg_4:Dictionary=null):Vector3D{
            var _local_5:int;
            var _local_6:int;
            var _local_7:Number;
            if (_arg_2.length <= this.threshold)
            {
                return (_arg_1.clone());
            };
            this.prepare(_arg_1, _arg_2, _arg_3, _arg_4, false);
            if (this.facesLength > 0)
            {
                _local_5 = 50;
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    if (this.checkCollision())
                    {
                        _local_7 = (((((this.radius + this.threshold) + this.collisionPlane.w) - (this.dest.x * this.collisionPlane.x)) - (this.dest.y * this.collisionPlane.y)) - (this.dest.z * this.collisionPlane.z));
                        this.dest.x = (this.dest.x + (this.collisionPlane.x * _local_7));
                        this.dest.y = (this.dest.y + (this.collisionPlane.y * _local_7));
                        this.dest.z = (this.dest.z + (this.collisionPlane.z * _local_7));
                        this.src.x = (this.collisionPoint.x + (this.collisionPlane.x * (this.radius + this.threshold)));
                        this.src.y = (this.collisionPoint.y + (this.collisionPlane.y * (this.radius + this.threshold)));
                        this.src.z = (this.collisionPoint.z + (this.collisionPlane.z * (this.radius + this.threshold)));
                        this.displ.x = (this.dest.x - this.src.x);
                        this.displ.y = (this.dest.y - this.src.y);
                        this.displ.z = (this.dest.z - this.src.z);
                        if (this.displ.length < this.threshold) break;
                    }
                    else
                    {
                        break;
                    };
                    _local_6++;
                };
                this.faces.length = 0;
                this.matrix.composeMatrix();
                return (new Vector3D(((((this.matrix.ma * this.dest.x) + (this.matrix.mb * this.dest.y)) + (this.matrix.mc * this.dest.z)) + this.matrix.md), ((((this.matrix.me * this.dest.x) + (this.matrix.mf * this.dest.y)) + (this.matrix.mg * this.dest.z)) + this.matrix.mh), ((((this.matrix.mi * this.dest.x) + (this.matrix.mj * this.dest.y)) + (this.matrix.mk * this.dest.z)) + this.matrix.ml)));
            };
            return (new Vector3D((_arg_1.x + _arg_2.x), (_arg_1.y + _arg_2.y), (_arg_1.z + _arg_2.z)));
        }

        public function getCollision(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Object3D, _arg_6:Dictionary=null):Boolean{
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            if (_arg_2.length <= this.threshold)
            {
                return (false);
            };
            this.prepare(_arg_1, _arg_2, _arg_5, _arg_6, true);
            if (this.facesLength > 0)
            {
                if (this.checkCollision())
                {
                    this.matrix.composeMatrix();
                    _arg_3.x = ((((this.matrix.ma * this.collisionPoint.x) + (this.matrix.mb * this.collisionPoint.y)) + (this.matrix.mc * this.collisionPoint.z)) + this.matrix.md);
                    _arg_3.y = ((((this.matrix.me * this.collisionPoint.x) + (this.matrix.mf * this.collisionPoint.y)) + (this.matrix.mg * this.collisionPoint.z)) + this.matrix.mh);
                    _arg_3.z = ((((this.matrix.mi * this.collisionPoint.x) + (this.matrix.mj * this.collisionPoint.y)) + (this.matrix.mk * this.collisionPoint.z)) + this.matrix.ml);
                    if (this.collisionPlane.x < this.collisionPlane.y)
                    {
                        if (this.collisionPlane.x < this.collisionPlane.z)
                        {
                            _local_7 = 0;
                            _local_8 = -(this.collisionPlane.z);
                            _local_9 = this.collisionPlane.y;
                        }
                        else
                        {
                            _local_7 = -(this.collisionPlane.y);
                            _local_8 = this.collisionPlane.x;
                            _local_9 = 0;
                        };
                    }
                    else
                    {
                        if (this.collisionPlane.y < this.collisionPlane.z)
                        {
                            _local_7 = this.collisionPlane.z;
                            _local_8 = 0;
                            _local_9 = -(this.collisionPlane.x);
                        }
                        else
                        {
                            _local_7 = -(this.collisionPlane.y);
                            _local_8 = this.collisionPlane.x;
                            _local_9 = 0;
                        };
                    };
                    _local_10 = ((this.collisionPlane.z * _local_8) - (this.collisionPlane.y * _local_9));
                    _local_11 = ((this.collisionPlane.x * _local_9) - (this.collisionPlane.z * _local_7));
                    _local_12 = ((this.collisionPlane.y * _local_7) - (this.collisionPlane.x * _local_8));
                    _local_13 = (((this.matrix.ma * _local_7) + (this.matrix.mb * _local_8)) + (this.matrix.mc * _local_9));
                    _local_14 = (((this.matrix.me * _local_7) + (this.matrix.mf * _local_8)) + (this.matrix.mg * _local_9));
                    _local_15 = (((this.matrix.mi * _local_7) + (this.matrix.mj * _local_8)) + (this.matrix.mk * _local_9));
                    _local_16 = (((this.matrix.ma * _local_10) + (this.matrix.mb * _local_11)) + (this.matrix.mc * _local_12));
                    _local_17 = (((this.matrix.me * _local_10) + (this.matrix.mf * _local_11)) + (this.matrix.mg * _local_12));
                    _local_18 = (((this.matrix.mi * _local_10) + (this.matrix.mj * _local_11)) + (this.matrix.mk * _local_12));
                    _arg_4.x = ((_local_15 * _local_17) - (_local_14 * _local_18));
                    _arg_4.y = ((_local_13 * _local_18) - (_local_15 * _local_16));
                    _arg_4.z = ((_local_14 * _local_16) - (_local_13 * _local_17));
                    _arg_4.normalize();
                    _arg_4.w = (((_arg_3.x * _arg_4.x) + (_arg_3.y * _arg_4.y)) + (_arg_3.z * _arg_4.z));
                    this.faces.length = 0;
                    return (true);
                };
                this.faces.length = 0;
                return (false);
            };
            return (false);
        }

        private function checkCollision():Boolean{
            var _local_4:Face;
            var _local_5:Wrapper;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
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
            var _local_26:Number;
            var _local_27:Number;
            var _local_28:Boolean;
            var _local_29:Wrapper;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Number;
            var _local_34:Number;
            var _local_35:Number;
            var _local_36:Number;
            var _local_37:Number;
            var _local_38:Number;
            var _local_39:Number;
            var _local_40:Number;
            var _local_41:Number;
            var _local_42:Number;
            var _local_43:Number;
            var _local_44:Number;
            var _local_45:Number;
            var _local_46:Number;
            var _local_1:Number = 1;
            var _local_2:Number = this.displ.length;
            var _local_3:int;
            for (;_local_3 < this.facesLength;_local_3++)
            {
                _local_4 = this.faces[_local_3];
                _local_5 = _local_4.wrapper;
                _local_6 = _local_5.vertex;
                _local_5 = _local_5.next;
                _local_7 = _local_5.vertex;
                _local_5 = _local_5.next;
                _local_8 = _local_5.vertex;
                _local_9 = (_local_7.cameraX - _local_6.cameraX);
                _local_10 = (_local_7.cameraY - _local_6.cameraY);
                _local_11 = (_local_7.cameraZ - _local_6.cameraZ);
                _local_12 = (_local_8.cameraX - _local_6.cameraX);
                _local_13 = (_local_8.cameraY - _local_6.cameraY);
                _local_14 = (_local_8.cameraZ - _local_6.cameraZ);
                _local_15 = ((_local_14 * _local_10) - (_local_13 * _local_11));
                _local_16 = ((_local_12 * _local_11) - (_local_14 * _local_9));
                _local_17 = ((_local_13 * _local_9) - (_local_12 * _local_10));
                _local_18 = (((_local_15 * _local_15) + (_local_16 * _local_16)) + (_local_17 * _local_17));
                if (_local_18 > 0.001)
                {
                    _local_18 = (1 / Math.sqrt(_local_18));
                    _local_15 = (_local_15 * _local_18);
                    _local_16 = (_local_16 * _local_18);
                    _local_17 = (_local_17 * _local_18);
                }
                else
                {
                    continue;
                };
                _local_19 = (((_local_6.cameraX * _local_15) + (_local_6.cameraY * _local_16)) + (_local_6.cameraZ * _local_17));
                _local_20 = ((((this.src.x * _local_15) + (this.src.y * _local_16)) + (this.src.z * _local_17)) - _local_19);
                if (_local_20 < this.radius)
                {
                    _local_21 = (this.src.x - (_local_15 * _local_20));
                    _local_22 = (this.src.y - (_local_16 * _local_20));
                    _local_23 = (this.src.z - (_local_17 * _local_20));
                }
                else
                {
                    _local_33 = ((_local_20 - this.radius) / ((((_local_20 - (this.dest.x * _local_15)) - (this.dest.y * _local_16)) - (this.dest.z * _local_17)) + _local_19));
                    _local_21 = ((this.src.x + (this.displ.x * _local_33)) - (_local_15 * this.radius));
                    _local_22 = ((this.src.y + (this.displ.y * _local_33)) - (_local_16 * this.radius));
                    _local_23 = ((this.src.z + (this.displ.z * _local_33)) - (_local_17 * this.radius));
                };
                _local_27 = 1E22;
                _local_28 = true;
                _local_29 = _local_4.wrapper;
                while (_local_29 != null)
                {
                    _local_6 = _local_29.vertex;
                    _local_7 = ((_local_29.next != null) ? _local_29.next.vertex : _local_4.wrapper.vertex);
                    _local_9 = (_local_7.cameraX - _local_6.cameraX);
                    _local_10 = (_local_7.cameraY - _local_6.cameraY);
                    _local_11 = (_local_7.cameraZ - _local_6.cameraZ);
                    _local_12 = (_local_21 - _local_6.cameraX);
                    _local_13 = (_local_22 - _local_6.cameraY);
                    _local_14 = (_local_23 - _local_6.cameraZ);
                    _local_34 = ((_local_14 * _local_10) - (_local_13 * _local_11));
                    _local_35 = ((_local_12 * _local_11) - (_local_14 * _local_9));
                    _local_36 = ((_local_13 * _local_9) - (_local_12 * _local_10));
                    if ((((_local_34 * _local_15) + (_local_35 * _local_16)) + (_local_36 * _local_17)) < 0)
                    {
                        _local_37 = (((_local_9 * _local_9) + (_local_10 * _local_10)) + (_local_11 * _local_11));
                        _local_38 = ((((_local_34 * _local_34) + (_local_35 * _local_35)) + (_local_36 * _local_36)) / _local_37);
                        if (_local_38 < _local_27)
                        {
                            _local_37 = Math.sqrt(_local_37);
                            _local_9 = (_local_9 / _local_37);
                            _local_10 = (_local_10 / _local_37);
                            _local_11 = (_local_11 / _local_37);
                            _local_33 = (((_local_9 * _local_12) + (_local_10 * _local_13)) + (_local_11 * _local_14));
                            if (_local_33 < 0)
                            {
                                _local_39 = (((_local_12 * _local_12) + (_local_13 * _local_13)) + (_local_14 * _local_14));
                                if (_local_39 < _local_27)
                                {
                                    _local_27 = _local_39;
                                    _local_24 = _local_6.cameraX;
                                    _local_25 = _local_6.cameraY;
                                    _local_26 = _local_6.cameraZ;
                                };
                            }
                            else
                            {
                                if (_local_33 > _local_37)
                                {
                                    _local_12 = (_local_21 - _local_7.cameraX);
                                    _local_13 = (_local_22 - _local_7.cameraY);
                                    _local_14 = (_local_23 - _local_7.cameraZ);
                                    _local_39 = (((_local_12 * _local_12) + (_local_13 * _local_13)) + (_local_14 * _local_14));
                                    if (_local_39 < _local_27)
                                    {
                                        _local_27 = _local_39;
                                        _local_24 = _local_7.cameraX;
                                        _local_25 = _local_7.cameraY;
                                        _local_26 = _local_7.cameraZ;
                                    };
                                }
                                else
                                {
                                    _local_27 = _local_38;
                                    _local_24 = (_local_6.cameraX + (_local_9 * _local_33));
                                    _local_25 = (_local_6.cameraY + (_local_10 * _local_33));
                                    _local_26 = (_local_6.cameraZ + (_local_11 * _local_33));
                                };
                            };
                        };
                        _local_28 = false;
                    };
                    _local_29 = _local_29.next;
                };
                if (_local_28)
                {
                    _local_24 = _local_21;
                    _local_25 = _local_22;
                    _local_26 = _local_23;
                };
                _local_30 = (this.src.x - _local_24);
                _local_31 = (this.src.y - _local_25);
                _local_32 = (this.src.z - _local_26);
                if ((((_local_30 * this.displ.x) + (_local_31 * this.displ.y)) + (_local_32 * this.displ.z)) <= 0)
                {
                    _local_40 = (-(this.displ.x) / _local_2);
                    _local_41 = (-(this.displ.y) / _local_2);
                    _local_42 = (-(this.displ.z) / _local_2);
                    _local_43 = (((_local_30 * _local_30) + (_local_31 * _local_31)) + (_local_32 * _local_32));
                    _local_44 = (((_local_30 * _local_40) + (_local_31 * _local_41)) + (_local_32 * _local_42));
                    _local_45 = (((this.radius * this.radius) - _local_43) + (_local_44 * _local_44));
                    if (_local_45 > 0)
                    {
                        _local_46 = ((_local_44 - Math.sqrt(_local_45)) / _local_2);
                        if (_local_46 < _local_1)
                        {
                            _local_1 = _local_46;
                            this.collisionPoint.x = _local_24;
                            this.collisionPoint.y = _local_25;
                            this.collisionPoint.z = _local_26;
                            if (_local_28)
                            {
                                this.collisionPlane.x = _local_15;
                                this.collisionPlane.y = _local_16;
                                this.collisionPlane.z = _local_17;
                                this.collisionPlane.w = _local_19;
                            }
                            else
                            {
                                _local_43 = Math.sqrt(_local_43);
                                this.collisionPlane.x = (_local_30 / _local_43);
                                this.collisionPlane.y = (_local_31 / _local_43);
                                this.collisionPlane.z = (_local_32 / _local_43);
                                this.collisionPlane.w = (((this.collisionPoint.x * this.collisionPlane.x) + (this.collisionPoint.y * this.collisionPlane.y)) + (this.collisionPoint.z * this.collisionPlane.z));
                            };
                        };
                    };
                };
            };
            return (_local_1 < 1);
        }


    }
}//package alternativa.engine3d.core