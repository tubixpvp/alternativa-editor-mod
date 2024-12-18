package alternativa.engine3d.core{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class VG {

        private static var collector:VG;

        alternativa3d var next:VG;
        alternativa3d var faceStruct:Face;
        alternativa3d var object:Object3D;
        alternativa3d var sorting:int;
        alternativa3d var debug:int = 0;
        alternativa3d var space:int = 0;
        alternativa3d var viewAligned:Boolean = false;
        alternativa3d var boundMinX:Number;
        alternativa3d var boundMinY:Number;
        alternativa3d var boundMinZ:Number;
        alternativa3d var boundMaxX:Number;
        alternativa3d var boundMaxY:Number;
        alternativa3d var boundMaxZ:Number;
        alternativa3d var boundMin:Number;
        alternativa3d var boundMax:Number;
        alternativa3d var boundVertexList:Vertex = Vertex.createList(8);
        alternativa3d var boundPlaneList:Vertex = Vertex.createList(6);
        alternativa3d var numOccluders:int;


        alternativa3d static function create(_arg_1:Object3D, _arg_2:Face, _arg_3:int, _arg_4:int, _arg_5:Boolean):VG{
            var _local_6:VG;
            if (collector != null)
            {
                _local_6 = collector;
                collector = collector.next;
                _local_6.next = null;
            }
            else
            {
                _local_6 = new (VG)();
            };
            _local_6.object = _arg_1;
            _local_6.faceStruct = _arg_2;
            _local_6.sorting = _arg_3;
            _local_6.debug = _arg_4;
            _local_6.viewAligned = _arg_5;
            return (_local_6);
        }


        alternativa3d function destroy():void{
            if (this.faceStruct != null)
            {
                this.destroyFaceStruct(this.faceStruct);
                this.faceStruct = null;
            };
            this.object = null;
            this.numOccluders = 0;
            this.debug = 0;
            this.space = 0;
            this.next = collector;
            collector = this;
        }

        private function destroyFaceStruct(_arg_1:Face):void{
            if (_arg_1.processNegative != null)
            {
                this.destroyFaceStruct(_arg_1.processNegative);
                _arg_1.processNegative = null;
            };
            if (_arg_1.processPositive != null)
            {
                this.destroyFaceStruct(_arg_1.processPositive);
                _arg_1.processPositive = null;
            };
            var _local_2:Face = _arg_1.processNext;
            while (_local_2 != null)
            {
                _arg_1.processNext = null;
                _arg_1 = _local_2;
                _local_2 = _arg_1.processNext;
            };
        }

        alternativa3d function calculateAABB(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number, _arg_12:Number):void{
            this.boundMinX = 1E22;
            this.boundMinY = 1E22;
            this.boundMinZ = 1E22;
            this.boundMaxX = -1E22;
            this.boundMaxY = -1E22;
            this.boundMaxZ = -1E22;
            this.calculateAABBStruct(this.faceStruct, ++this.object.transformId, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12);
            this.space = 1;
        }

        alternativa3d function calculateOOBB(_arg_1:Object3D):void{
            var _local_2:Vertex;
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Vertex;
            var _local_10:Vertex;
            var _local_11:Vertex;
            var _local_12:Vertex;
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
            var _local_26:Vertex;
            var _local_27:Vertex;
            var _local_28:Vertex;
            var _local_29:Vertex;
            if (this.space == 1)
            {
                this.transformStruct(this.faceStruct, ++this.object.transformId, _arg_1.ma, _arg_1.mb, _arg_1.mc, _arg_1.md, _arg_1.me, _arg_1.mf, _arg_1.mg, _arg_1.mh, _arg_1.mi, _arg_1.mj, _arg_1.mk, _arg_1.ml);
            };
            if (!this.viewAligned)
            {
                this.boundMinX = 1E22;
                this.boundMinY = 1E22;
                this.boundMinZ = 1E22;
                this.boundMaxX = -1E22;
                this.boundMaxY = -1E22;
                this.boundMaxZ = -1E22;
                this.calculateOOBBStruct(this.faceStruct, ++this.object.transformId, this.object.ima, this.object.imb, this.object.imc, this.object.imd, this.object.ime, this.object.imf, this.object.img, this.object.imh, this.object.imi, this.object.imj, this.object.imk, this.object.iml);
                if ((this.boundMaxX - this.boundMinX) < 1)
                {
                    this.boundMaxX = (this.boundMinX + 1);
                };
                if ((this.boundMaxY - this.boundMinY) < 1)
                {
                    this.boundMaxY = (this.boundMinY + 1);
                };
                if ((this.boundMaxZ - this.boundMinZ) < 1)
                {
                    this.boundMaxZ = (this.boundMinZ + 1);
                };
                _local_2 = this.boundVertexList;
                _local_2.x = this.boundMinX;
                _local_2.y = this.boundMinY;
                _local_2.z = this.boundMinZ;
                _local_3 = _local_2.next;
                _local_3.x = this.boundMaxX;
                _local_3.y = this.boundMinY;
                _local_3.z = this.boundMinZ;
                _local_4 = _local_3.next;
                _local_4.x = this.boundMinX;
                _local_4.y = this.boundMaxY;
                _local_4.z = this.boundMinZ;
                _local_5 = _local_4.next;
                _local_5.x = this.boundMaxX;
                _local_5.y = this.boundMaxY;
                _local_5.z = this.boundMinZ;
                _local_6 = _local_5.next;
                _local_6.x = this.boundMinX;
                _local_6.y = this.boundMinY;
                _local_6.z = this.boundMaxZ;
                _local_7 = _local_6.next;
                _local_7.x = this.boundMaxX;
                _local_7.y = this.boundMinY;
                _local_7.z = this.boundMaxZ;
                _local_8 = _local_7.next;
                _local_8.x = this.boundMinX;
                _local_8.y = this.boundMaxY;
                _local_8.z = this.boundMaxZ;
                _local_9 = _local_8.next;
                _local_9.x = this.boundMaxX;
                _local_9.y = this.boundMaxY;
                _local_9.z = this.boundMaxZ;
                _local_10 = _local_2;
                while (_local_10 != null)
                {
                    _local_10.cameraX = ((((this.object.ma * _local_10.x) + (this.object.mb * _local_10.y)) + (this.object.mc * _local_10.z)) + this.object.md);
                    _local_10.cameraY = ((((this.object.me * _local_10.x) + (this.object.mf * _local_10.y)) + (this.object.mg * _local_10.z)) + this.object.mh);
                    _local_10.cameraZ = ((((this.object.mi * _local_10.x) + (this.object.mj * _local_10.y)) + (this.object.mk * _local_10.z)) + this.object.ml);
                    _local_10 = _local_10.next;
                };
                _local_11 = this.boundPlaneList;
                _local_12 = _local_11.next;
                _local_13 = _local_2.cameraX;
                _local_14 = _local_2.cameraY;
                _local_15 = _local_2.cameraZ;
                _local_16 = (_local_3.cameraX - _local_13);
                _local_17 = (_local_3.cameraY - _local_14);
                _local_18 = (_local_3.cameraZ - _local_15);
                _local_19 = (_local_6.cameraX - _local_13);
                _local_20 = (_local_6.cameraY - _local_14);
                _local_21 = (_local_6.cameraZ - _local_15);
                _local_22 = ((_local_21 * _local_17) - (_local_20 * _local_18));
                _local_23 = ((_local_19 * _local_18) - (_local_21 * _local_16));
                _local_24 = ((_local_20 * _local_16) - (_local_19 * _local_17));
                _local_25 = (1 / Math.sqrt((((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24))));
                _local_22 = (_local_22 * _local_25);
                _local_23 = (_local_23 * _local_25);
                _local_24 = (_local_24 * _local_25);
                _local_11.cameraX = _local_22;
                _local_11.cameraY = _local_23;
                _local_11.cameraZ = _local_24;
                _local_11.offset = (((_local_13 * _local_22) + (_local_14 * _local_23)) + (_local_15 * _local_24));
                _local_12.cameraX = -(_local_22);
                _local_12.cameraY = -(_local_23);
                _local_12.cameraZ = -(_local_24);
                _local_12.offset = (((-(_local_4.cameraX) * _local_22) - (_local_4.cameraY * _local_23)) - (_local_4.cameraZ * _local_24));
                _local_26 = _local_12.next;
                _local_27 = _local_26.next;
                _local_13 = _local_2.cameraX;
                _local_14 = _local_2.cameraY;
                _local_15 = _local_2.cameraZ;
                _local_16 = (_local_6.cameraX - _local_13);
                _local_17 = (_local_6.cameraY - _local_14);
                _local_18 = (_local_6.cameraZ - _local_15);
                _local_19 = (_local_4.cameraX - _local_13);
                _local_20 = (_local_4.cameraY - _local_14);
                _local_21 = (_local_4.cameraZ - _local_15);
                _local_22 = ((_local_21 * _local_17) - (_local_20 * _local_18));
                _local_23 = ((_local_19 * _local_18) - (_local_21 * _local_16));
                _local_24 = ((_local_20 * _local_16) - (_local_19 * _local_17));
                _local_25 = (1 / Math.sqrt((((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24))));
                _local_22 = (_local_22 * _local_25);
                _local_23 = (_local_23 * _local_25);
                _local_24 = (_local_24 * _local_25);
                _local_26.cameraX = _local_22;
                _local_26.cameraY = _local_23;
                _local_26.cameraZ = _local_24;
                _local_26.offset = (((_local_13 * _local_22) + (_local_14 * _local_23)) + (_local_15 * _local_24));
                _local_27.cameraX = -(_local_22);
                _local_27.cameraY = -(_local_23);
                _local_27.cameraZ = -(_local_24);
                _local_27.offset = (((-(_local_3.cameraX) * _local_22) - (_local_3.cameraY * _local_23)) - (_local_3.cameraZ * _local_24));
                _local_28 = _local_27.next;
                _local_29 = _local_28.next;
                _local_13 = _local_6.cameraX;
                _local_14 = _local_6.cameraY;
                _local_15 = _local_6.cameraZ;
                _local_16 = (_local_7.cameraX - _local_13);
                _local_17 = (_local_7.cameraY - _local_14);
                _local_18 = (_local_7.cameraZ - _local_15);
                _local_19 = (_local_8.cameraX - _local_13);
                _local_20 = (_local_8.cameraY - _local_14);
                _local_21 = (_local_8.cameraZ - _local_15);
                _local_22 = ((_local_21 * _local_17) - (_local_20 * _local_18));
                _local_23 = ((_local_19 * _local_18) - (_local_21 * _local_16));
                _local_24 = ((_local_20 * _local_16) - (_local_19 * _local_17));
                _local_25 = (1 / Math.sqrt((((_local_22 * _local_22) + (_local_23 * _local_23)) + (_local_24 * _local_24))));
                _local_22 = (_local_22 * _local_25);
                _local_23 = (_local_23 * _local_25);
                _local_24 = (_local_24 * _local_25);
                _local_28.cameraX = _local_22;
                _local_28.cameraY = _local_23;
                _local_28.cameraZ = _local_24;
                _local_28.offset = (((_local_13 * _local_22) + (_local_14 * _local_23)) + (_local_15 * _local_24));
                _local_29.cameraX = -(_local_22);
                _local_29.cameraY = -(_local_23);
                _local_29.cameraZ = -(_local_24);
                _local_29.offset = (((-(_local_2.cameraX) * _local_22) - (_local_2.cameraY * _local_23)) - (_local_2.cameraZ * _local_24));
                if (_local_11.offset < -(_local_12.offset))
                {
                    _local_12.cameraX = -(_local_12.cameraX);
                    _local_12.cameraY = -(_local_12.cameraY);
                    _local_12.cameraZ = -(_local_12.cameraZ);
                    _local_12.offset = -(_local_12.offset);
                    _local_11.cameraX = -(_local_11.cameraX);
                    _local_11.cameraY = -(_local_11.cameraY);
                    _local_11.cameraZ = -(_local_11.cameraZ);
                    _local_11.offset = -(_local_11.offset);
                };
                if (_local_26.offset < -(_local_27.offset))
                {
                    _local_26.cameraX = -(_local_26.cameraX);
                    _local_26.cameraY = -(_local_26.cameraY);
                    _local_26.cameraZ = -(_local_26.cameraZ);
                    _local_26.offset = -(_local_26.offset);
                    _local_27.cameraX = -(_local_27.cameraX);
                    _local_27.cameraY = -(_local_27.cameraY);
                    _local_27.cameraZ = -(_local_27.cameraZ);
                    _local_27.offset = -(_local_27.offset);
                };
                if (_local_29.offset < -(_local_28.offset))
                {
                    _local_29.cameraX = -(_local_29.cameraX);
                    _local_29.cameraY = -(_local_29.cameraY);
                    _local_29.cameraZ = -(_local_29.cameraZ);
                    _local_29.offset = -(_local_29.offset);
                    _local_28.cameraX = -(_local_28.cameraX);
                    _local_28.cameraY = -(_local_28.cameraY);
                    _local_28.cameraZ = -(_local_28.cameraZ);
                    _local_28.offset = -(_local_28.offset);
                };
            };
            this.space = 2;
        }

        private function calculateAABBStruct(_arg_1:Face, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number, _arg_12:Number, _arg_13:Number, _arg_14:Number):void{
            var _local_16:Wrapper;
            var _local_17:Vertex;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_15:Face = _arg_1;
            while (_local_15 != null)
            {
                _local_16 = _local_15.wrapper;
                while (_local_16 != null)
                {
                    _local_17 = _local_16.vertex;
                    if (_local_17.transformId != _arg_2)
                    {
                        _local_18 = _local_17.cameraX;
                        _local_19 = _local_17.cameraY;
                        _local_20 = _local_17.cameraZ;
                        _local_17.cameraX = ((((_arg_3 * _local_18) + (_arg_4 * _local_19)) + (_arg_5 * _local_20)) + _arg_6);
                        _local_17.cameraY = ((((_arg_7 * _local_18) + (_arg_8 * _local_19)) + (_arg_9 * _local_20)) + _arg_10);
                        _local_17.cameraZ = ((((_arg_11 * _local_18) + (_arg_12 * _local_19)) + (_arg_13 * _local_20)) + _arg_14);
                        if (_local_17.cameraX < this.boundMinX)
                        {
                            this.boundMinX = _local_17.cameraX;
                        };
                        if (_local_17.cameraX > this.boundMaxX)
                        {
                            this.boundMaxX = _local_17.cameraX;
                        };
                        if (_local_17.cameraY < this.boundMinY)
                        {
                            this.boundMinY = _local_17.cameraY;
                        };
                        if (_local_17.cameraY > this.boundMaxY)
                        {
                            this.boundMaxY = _local_17.cameraY;
                        };
                        if (_local_17.cameraZ < this.boundMinZ)
                        {
                            this.boundMinZ = _local_17.cameraZ;
                        };
                        if (_local_17.cameraZ > this.boundMaxZ)
                        {
                            this.boundMaxZ = _local_17.cameraZ;
                        };
                        _local_17.transformId = _arg_2;
                    };
                    _local_16 = _local_16.next;
                };
                _local_15 = _local_15.processNext;
            };
            if (_arg_1.processNegative != null)
            {
                this.calculateAABBStruct(_arg_1.processNegative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
            if (_arg_1.processPositive != null)
            {
                this.calculateAABBStruct(_arg_1.processPositive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
        }

        private function calculateOOBBStruct(_arg_1:Face, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number, _arg_12:Number, _arg_13:Number, _arg_14:Number):void{
            var _local_16:Wrapper;
            var _local_17:Vertex;
            var _local_15:Face = _arg_1;
            while (_local_15 != null)
            {
                _local_16 = _local_15.wrapper;
                while (_local_16 != null)
                {
                    _local_17 = _local_16.vertex;
                    if (_local_17.transformId != _arg_2)
                    {
                        if (_local_17.x < this.boundMinX)
                        {
                            this.boundMinX = _local_17.x;
                        };
                        if (_local_17.x > this.boundMaxX)
                        {
                            this.boundMaxX = _local_17.x;
                        };
                        if (_local_17.y < this.boundMinY)
                        {
                            this.boundMinY = _local_17.y;
                        };
                        if (_local_17.y > this.boundMaxY)
                        {
                            this.boundMaxY = _local_17.y;
                        };
                        if (_local_17.z < this.boundMinZ)
                        {
                            this.boundMinZ = _local_17.z;
                        };
                        if (_local_17.z > this.boundMaxZ)
                        {
                            this.boundMaxZ = _local_17.z;
                        };
                        _local_17.transformId = _arg_2;
                    };
                    _local_16 = _local_16.next;
                };
                _local_15 = _local_15.processNext;
            };
            if (_arg_1.processNegative != null)
            {
                this.calculateOOBBStruct(_arg_1.processNegative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
            if (_arg_1.processPositive != null)
            {
                this.calculateOOBBStruct(_arg_1.processPositive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
        }

        private function updateAABBStruct(_arg_1:Face, _arg_2:int):void{
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_3:Face = _arg_1;
            while (_local_3 != null)
            {
                _local_4 = _local_3.wrapper;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.vertex;
                    if (_local_5.transformId != _arg_2)
                    {
                        if (_local_5.cameraX < this.boundMinX)
                        {
                            this.boundMinX = _local_5.cameraX;
                        };
                        if (_local_5.cameraX > this.boundMaxX)
                        {
                            this.boundMaxX = _local_5.cameraX;
                        };
                        if (_local_5.cameraY < this.boundMinY)
                        {
                            this.boundMinY = _local_5.cameraY;
                        };
                        if (_local_5.cameraY > this.boundMaxY)
                        {
                            this.boundMaxY = _local_5.cameraY;
                        };
                        if (_local_5.cameraZ < this.boundMinZ)
                        {
                            this.boundMinZ = _local_5.cameraZ;
                        };
                        if (_local_5.cameraZ > this.boundMaxZ)
                        {
                            this.boundMaxZ = _local_5.cameraZ;
                        };
                        _local_5.transformId = _arg_2;
                    };
                    _local_4 = _local_4.next;
                };
                _local_3 = _local_3.processNext;
            };
            if (_arg_1.processNegative != null)
            {
                this.updateAABBStruct(_arg_1.processNegative, _arg_2);
            };
            if (_arg_1.processPositive != null)
            {
                this.updateAABBStruct(_arg_1.processPositive, _arg_2);
            };
        }

        alternativa3d function split(_arg_1:Camera3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):void{
            var _local_8:VG;
            var _local_7:Face = this.faceStruct.create();
            this.splitFaceStruct(_arg_1, this.faceStruct, _local_7, _arg_2, _arg_3, _arg_4, _arg_5, (_arg_5 - _arg_6), (_arg_5 + _arg_6));
            if (_local_7.processNegative != null)
            {
                if (collector != null)
                {
                    _local_8 = collector;
                    collector = collector.next;
                    _local_8.next = null;
                }
                else
                {
                    _local_8 = new VG();
                };
                this.next = _local_8;
                _local_8.faceStruct = _local_7.processNegative;
                _local_7.processNegative = null;
                _local_8.object = this.object;
                _local_8.sorting = this.sorting;
                _local_8.debug = this.debug;
                _local_8.space = this.space;
                _local_8.viewAligned = this.viewAligned;
                _local_8.boundMinX = 1E22;
                _local_8.boundMinY = 1E22;
                _local_8.boundMinZ = 1E22;
                _local_8.boundMaxX = -1E22;
                _local_8.boundMaxY = -1E22;
                _local_8.boundMaxZ = -1E22;
                _local_8.updateAABBStruct(_local_8.faceStruct, ++this.object.transformId);
            }
            else
            {
                this.next = null;
            };
            if (_local_7.processPositive != null)
            {
                this.faceStruct = _local_7.processPositive;
                _local_7.processPositive = null;
                this.boundMinX = 1E22;
                this.boundMinY = 1E22;
                this.boundMinZ = 1E22;
                this.boundMaxX = -1E22;
                this.boundMaxY = -1E22;
                this.boundMaxZ = -1E22;
                this.updateAABBStruct(this.faceStruct, ++this.object.transformId);
            }
            else
            {
                this.faceStruct = null;
            };
            _local_7.next = Face.collector;
            Face.collector = _local_7;
        }

        alternativa3d function crop(_arg_1:Camera3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):void{
            this.faceStruct = this.cropFaceStruct(_arg_1, this.faceStruct, _arg_2, _arg_3, _arg_4, _arg_5, (_arg_5 - _arg_6), (_arg_5 + _arg_6));
            if (this.faceStruct != null)
            {
                this.boundMinX = 1E22;
                this.boundMinY = 1E22;
                this.boundMinZ = 1E22;
                this.boundMaxX = -1E22;
                this.boundMaxY = -1E22;
                this.boundMaxZ = -1E22;
                this.updateAABBStruct(this.faceStruct, ++this.object.transformId);
            };
        }

        private function splitFaceStruct(_arg_1:Camera3D, _arg_2:Face, _arg_3:Face, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number):void{
            var _local_10:Face;
            var _local_11:Face;
            var _local_12:Wrapper;
            var _local_13:Vertex;
            var _local_14:Vertex;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Face;
            var _local_18:Face;
            var _local_19:Face;
            var _local_20:Face;
            var _local_21:Face;
            var _local_22:Face;
            var _local_23:Face;
            var _local_24:Face;
            var _local_25:Wrapper;
            var _local_26:Wrapper;
            var _local_27:Wrapper;
            var _local_28:Boolean;
            var _local_29:Vertex;
            var _local_30:Vertex;
            var _local_31:Vertex;
            var _local_32:Number;
            var _local_33:Number;
            var _local_34:Number;
            var _local_35:Boolean;
            var _local_36:Boolean;
            var _local_37:Boolean;
            var _local_38:Number;
            var _local_39:Number;
            if (_arg_2.processNegative != null)
            {
                this.splitFaceStruct(_arg_1, _arg_2.processNegative, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                _arg_2.processNegative = null;
                _local_15 = _arg_3.processNegative;
                _local_16 = _arg_3.processPositive;
            };
            if (_arg_2.processPositive != null)
            {
                this.splitFaceStruct(_arg_1, _arg_2.processPositive, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
                _arg_2.processPositive = null;
                _local_17 = _arg_3.processNegative;
                _local_18 = _arg_3.processPositive;
            };
            if (_arg_2.wrapper != null)
            {
                _local_10 = _arg_2;
                while (_local_10 != null)
                {
                    _local_11 = _local_10.processNext;
                    _local_12 = _local_10.wrapper;
                    _local_29 = _local_12.vertex;
                    _local_12 = _local_12.next;
                    _local_30 = _local_12.vertex;
                    _local_12 = _local_12.next;
                    _local_31 = _local_12.vertex;
                    _local_12 = _local_12.next;
                    _local_32 = (((_local_29.cameraX * _arg_4) + (_local_29.cameraY * _arg_5)) + (_local_29.cameraZ * _arg_6));
                    _local_33 = (((_local_30.cameraX * _arg_4) + (_local_30.cameraY * _arg_5)) + (_local_30.cameraZ * _arg_6));
                    _local_34 = (((_local_31.cameraX * _arg_4) + (_local_31.cameraY * _arg_5)) + (_local_31.cameraZ * _arg_6));
                    _local_35 = (((_local_32 < _arg_8) || (_local_33 < _arg_8)) || (_local_34 < _arg_8));
                    _local_36 = (((_local_32 > _arg_9) || (_local_33 > _arg_9)) || (_local_34 > _arg_9));
                    _local_37 = (((_local_32 < _arg_8) && (_local_33 < _arg_8)) && (_local_34 < _arg_8));
                    while (_local_12 != null)
                    {
                        _local_13 = _local_12.vertex;
                        _local_38 = (((_local_13.cameraX * _arg_4) + (_local_13.cameraY * _arg_5)) + (_local_13.cameraZ * _arg_6));
                        if (_local_38 < _arg_8)
                        {
                            _local_35 = true;
                        }
                        else
                        {
                            _local_37 = false;
                            if (_local_38 > _arg_9)
                            {
                                _local_36 = true;
                            };
                        };
                        _local_13.offset = _local_38;
                        _local_12 = _local_12.next;
                    };
                    if ((!(_local_35)))
                    {
                        if (_local_21 != null)
                        {
                            _local_22.processNext = _local_10;
                        }
                        else
                        {
                            _local_21 = _local_10;
                        };
                        _local_22 = _local_10;
                    }
                    else
                    {
                        if ((!(_local_36)))
                        {
                            if (_local_37)
                            {
                                if (_local_19 != null)
                                {
                                    _local_20.processNext = _local_10;
                                }
                                else
                                {
                                    _local_19 = _local_10;
                                };
                                _local_20 = _local_10;
                            }
                            else
                            {
                                _local_29.offset = _local_32;
                                _local_30.offset = _local_33;
                                _local_31.offset = _local_34;
                                _local_23 = _local_10.create();
                                _local_23.material = _local_10.material;
                                _arg_1.lastFace.next = _local_23;
                                _arg_1.lastFace = _local_23;
                                _local_25 = null;
                                _local_28 = ((!(_local_10.material == null)) && (_local_10.material.useVerticesNormals));
                                _local_12 = _local_10.wrapper;
                                while (_local_12 != null)
                                {
                                    _local_30 = _local_12.vertex;
                                    if (_local_30.offset >= _arg_8)
                                    {
                                        _local_14 = _local_30.create();
                                        _arg_1.lastVertex.next = _local_14;
                                        _arg_1.lastVertex = _local_14;
                                        _local_14.x = _local_30.x;
                                        _local_14.y = _local_30.y;
                                        _local_14.z = _local_30.z;
                                        _local_14.u = _local_30.u;
                                        _local_14.v = _local_30.v;
                                        _local_14.cameraX = _local_30.cameraX;
                                        _local_14.cameraY = _local_30.cameraY;
                                        _local_14.cameraZ = _local_30.cameraZ;
                                        if (_local_28)
                                        {
                                            _local_14.normalX = _local_30.normalX;
                                            _local_14.normalY = _local_30.normalY;
                                            _local_14.normalZ = _local_30.normalZ;
                                        };
                                        _local_30 = _local_14;
                                    };
                                    _local_27 = _local_12.create();
                                    _local_27.vertex = _local_30;
                                    if (_local_25 != null)
                                    {
                                        _local_25.next = _local_27;
                                    }
                                    else
                                    {
                                        _local_23.wrapper = _local_27;
                                    };
                                    _local_25 = _local_27;
                                    _local_12 = _local_12.next;
                                };
                                if (_local_19 != null)
                                {
                                    _local_20.processNext = _local_23;
                                }
                                else
                                {
                                    _local_19 = _local_23;
                                };
                                _local_20 = _local_23;
                                _local_10.processNext = null;
                            };
                        }
                        else
                        {
                            _local_29.offset = _local_32;
                            _local_30.offset = _local_33;
                            _local_31.offset = _local_34;
                            _local_23 = _local_10.create();
                            _local_23.material = _local_10.material;
                            _arg_1.lastFace.next = _local_23;
                            _arg_1.lastFace = _local_23;
                            _local_24 = _local_10.create();
                            _local_24.material = _local_10.material;
                            _arg_1.lastFace.next = _local_24;
                            _arg_1.lastFace = _local_24;
                            _local_25 = null;
                            _local_26 = null;
                            _local_12 = _local_10.wrapper.next.next;
                            while (_local_12.next != null)
                            {
                                _local_12 = _local_12.next;
                            };
                            _local_29 = _local_12.vertex;
                            _local_32 = _local_29.offset;
                            _local_28 = ((!(_local_10.material == null)) && (_local_10.material.useVerticesNormals));
                            _local_12 = _local_10.wrapper;
                            while (_local_12 != null)
                            {
                                _local_30 = _local_12.vertex;
                                _local_33 = _local_30.offset;
                                if ((((_local_32 < _arg_8) && (_local_33 > _arg_9)) || ((_local_32 > _arg_9) && (_local_33 < _arg_8))))
                                {
                                    _local_39 = ((_arg_7 - _local_32) / (_local_33 - _local_32));
                                    _local_13 = _local_30.create();
                                    _arg_1.lastVertex.next = _local_13;
                                    _arg_1.lastVertex = _local_13;
                                    _local_13.x = (_local_29.x + ((_local_30.x - _local_29.x) * _local_39));
                                    _local_13.y = (_local_29.y + ((_local_30.y - _local_29.y) * _local_39));
                                    _local_13.z = (_local_29.z + ((_local_30.z - _local_29.z) * _local_39));
                                    _local_13.u = (_local_29.u + ((_local_30.u - _local_29.u) * _local_39));
                                    _local_13.v = (_local_29.v + ((_local_30.v - _local_29.v) * _local_39));
                                    _local_13.cameraX = (_local_29.cameraX + ((_local_30.cameraX - _local_29.cameraX) * _local_39));
                                    _local_13.cameraY = (_local_29.cameraY + ((_local_30.cameraY - _local_29.cameraY) * _local_39));
                                    _local_13.cameraZ = (_local_29.cameraZ + ((_local_30.cameraZ - _local_29.cameraZ) * _local_39));
                                    if (_local_28)
                                    {
                                        _local_13.normalX = (_local_29.normalX + ((_local_30.normalX - _local_29.normalX) * _local_39));
                                        _local_13.normalY = (_local_29.normalY + ((_local_30.normalY - _local_29.normalY) * _local_39));
                                        _local_13.normalZ = (_local_29.normalZ + ((_local_30.normalZ - _local_29.normalZ) * _local_39));
                                    };
                                    _local_27 = _local_12.create();
                                    _local_27.vertex = _local_13;
                                    if (_local_25 != null)
                                    {
                                        _local_25.next = _local_27;
                                    }
                                    else
                                    {
                                        _local_23.wrapper = _local_27;
                                    };
                                    _local_25 = _local_27;
                                    _local_14 = _local_30.create();
                                    _arg_1.lastVertex.next = _local_14;
                                    _arg_1.lastVertex = _local_14;
                                    _local_14.x = _local_13.x;
                                    _local_14.y = _local_13.y;
                                    _local_14.z = _local_13.z;
                                    _local_14.u = _local_13.u;
                                    _local_14.v = _local_13.v;
                                    _local_14.cameraX = _local_13.cameraX;
                                    _local_14.cameraY = _local_13.cameraY;
                                    _local_14.cameraZ = _local_13.cameraZ;
                                    if (_local_28)
                                    {
                                        _local_14.normalX = _local_13.normalX;
                                        _local_14.normalY = _local_13.normalY;
                                        _local_14.normalZ = _local_13.normalZ;
                                    };
                                    _local_27 = _local_12.create();
                                    _local_27.vertex = _local_14;
                                    if (_local_26 != null)
                                    {
                                        _local_26.next = _local_27;
                                    }
                                    else
                                    {
                                        _local_24.wrapper = _local_27;
                                    };
                                    _local_26 = _local_27;
                                };
                                if (_local_30.offset < _arg_8)
                                {
                                    _local_27 = _local_12.create();
                                    _local_27.vertex = _local_30;
                                    if (_local_25 != null)
                                    {
                                        _local_25.next = _local_27;
                                    }
                                    else
                                    {
                                        _local_23.wrapper = _local_27;
                                    };
                                    _local_25 = _local_27;
                                }
                                else
                                {
                                    if (_local_30.offset > _arg_9)
                                    {
                                        _local_27 = _local_12.create();
                                        _local_27.vertex = _local_30;
                                        if (_local_26 != null)
                                        {
                                            _local_26.next = _local_27;
                                        }
                                        else
                                        {
                                            _local_24.wrapper = _local_27;
                                        };
                                        _local_26 = _local_27;
                                    }
                                    else
                                    {
                                        _local_27 = _local_12.create();
                                        _local_27.vertex = _local_30;
                                        if (_local_26 != null)
                                        {
                                            _local_26.next = _local_27;
                                        }
                                        else
                                        {
                                            _local_24.wrapper = _local_27;
                                        };
                                        _local_26 = _local_27;
                                        _local_14 = _local_30.create();
                                        _arg_1.lastVertex.next = _local_14;
                                        _arg_1.lastVertex = _local_14;
                                        _local_14.x = _local_30.x;
                                        _local_14.y = _local_30.y;
                                        _local_14.z = _local_30.z;
                                        _local_14.u = _local_30.u;
                                        _local_14.v = _local_30.v;
                                        _local_14.cameraX = _local_30.cameraX;
                                        _local_14.cameraY = _local_30.cameraY;
                                        _local_14.cameraZ = _local_30.cameraZ;
                                        if (_local_28)
                                        {
                                            _local_14.normalX = _local_30.normalX;
                                            _local_14.normalY = _local_30.normalY;
                                            _local_14.normalZ = _local_30.normalZ;
                                        };
                                        _local_27 = _local_12.create();
                                        _local_27.vertex = _local_14;
                                        if (_local_25 != null)
                                        {
                                            _local_25.next = _local_27;
                                        }
                                        else
                                        {
                                            _local_23.wrapper = _local_27;
                                        };
                                        _local_25 = _local_27;
                                    };
                                };
                                _local_29 = _local_30;
                                _local_32 = _local_33;
                                _local_12 = _local_12.next;
                            };
                            if (_local_19 != null)
                            {
                                _local_20.processNext = _local_23;
                            }
                            else
                            {
                                _local_19 = _local_23;
                            };
                            _local_20 = _local_23;
                            if (_local_21 != null)
                            {
                                _local_22.processNext = _local_24;
                            }
                            else
                            {
                                _local_21 = _local_24;
                            };
                            _local_22 = _local_24;
                            _local_10.processNext = null;
                        };
                    };
                    _local_10 = _local_11;
                };
            };
            if (((!(_local_19 == null)) || ((!(_local_15 == null)) && (!(_local_17 == null)))))
            {
                if (_local_19 == null)
                {
                    _local_19 = _arg_2.create();
                    _arg_1.lastFace.next = _local_19;
                    _arg_1.lastFace = _local_19;
                }
                else
                {
                    _local_20.processNext = null;
                };
                if (this.sorting == 3)
                {
                    _local_19.normalX = _arg_2.normalX;
                    _local_19.normalY = _arg_2.normalY;
                    _local_19.normalZ = _arg_2.normalZ;
                    _local_19.offset = _arg_2.offset;
                };
                _local_19.processNegative = _local_15;
                _local_19.processPositive = _local_17;
                _arg_3.processNegative = _local_19;
            }
            else
            {
                _arg_3.processNegative = ((_local_15 != null) ? _local_15 : _local_17);
            };
            if (((!(_local_21 == null)) || ((!(_local_16 == null)) && (!(_local_18 == null)))))
            {
                if (_local_21 == null)
                {
                    _local_21 = _arg_2.create();
                    _arg_1.lastFace.next = _local_21;
                    _arg_1.lastFace = _local_21;
                }
                else
                {
                    _local_22.processNext = null;
                };
                if (this.sorting == 3)
                {
                    _local_21.normalX = _arg_2.normalX;
                    _local_21.normalY = _arg_2.normalY;
                    _local_21.normalZ = _arg_2.normalZ;
                    _local_21.offset = _arg_2.offset;
                };
                _local_21.processNegative = _local_16;
                _local_21.processPositive = _local_18;
                _arg_3.processPositive = _local_21;
            }
            else
            {
                _arg_3.processPositive = ((_local_16 != null) ? _local_16 : _local_18);
            };
        }

        private function cropFaceStruct(_arg_1:Camera3D, _arg_2:Face, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):Face{
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Wrapper;
            var _local_12:Vertex;
            var _local_13:Face;
            var _local_14:Face;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Vertex;
            var _local_18:Vertex;
            var _local_19:Vertex;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Boolean;
            var _local_24:Boolean;
            var _local_25:Number;
            var _local_26:Face;
            var _local_27:Wrapper;
            var _local_28:Wrapper;
            var _local_29:Boolean;
            var _local_30:Number;
            if (_arg_2.processNegative != null)
            {
                _local_13 = this.cropFaceStruct(_arg_1, _arg_2.processNegative, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
                _arg_2.processNegative = null;
            };
            if (_arg_2.processPositive != null)
            {
                _local_14 = this.cropFaceStruct(_arg_1, _arg_2.processPositive, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
                _arg_2.processPositive = null;
            };
            if (_arg_2.wrapper != null)
            {
                _local_9 = _arg_2;
                while (_local_9 != null)
                {
                    _local_10 = _local_9.processNext;
                    _local_11 = _local_9.wrapper;
                    _local_17 = _local_11.vertex;
                    _local_11 = _local_11.next;
                    _local_18 = _local_11.vertex;
                    _local_11 = _local_11.next;
                    _local_19 = _local_11.vertex;
                    _local_11 = _local_11.next;
                    _local_20 = (((_local_17.cameraX * _arg_3) + (_local_17.cameraY * _arg_4)) + (_local_17.cameraZ * _arg_5));
                    _local_21 = (((_local_18.cameraX * _arg_3) + (_local_18.cameraY * _arg_4)) + (_local_18.cameraZ * _arg_5));
                    _local_22 = (((_local_19.cameraX * _arg_3) + (_local_19.cameraY * _arg_4)) + (_local_19.cameraZ * _arg_5));
                    _local_23 = (((_local_20 < _arg_7) || (_local_21 < _arg_7)) || (_local_22 < _arg_7));
                    _local_24 = (((_local_20 > _arg_8) || (_local_21 > _arg_8)) || (_local_22 > _arg_8));
                    while (_local_11 != null)
                    {
                        _local_12 = _local_11.vertex;
                        _local_25 = (((_local_12.cameraX * _arg_3) + (_local_12.cameraY * _arg_4)) + (_local_12.cameraZ * _arg_5));
                        if (_local_25 < _arg_7)
                        {
                            _local_23 = true;
                        }
                        else
                        {
                            if (_local_25 > _arg_8)
                            {
                                _local_24 = true;
                            };
                        };
                        _local_12.offset = _local_25;
                        _local_11 = _local_11.next;
                    };
                    if ((!(_local_24)))
                    {
                        _local_9.processNext = null;
                    }
                    else
                    {
                        if ((!(_local_23)))
                        {
                            if (_local_15 != null)
                            {
                                _local_16.processNext = _local_9;
                            }
                            else
                            {
                                _local_15 = _local_9;
                            };
                            _local_16 = _local_9;
                        }
                        else
                        {
                            _local_17.offset = _local_20;
                            _local_18.offset = _local_21;
                            _local_19.offset = _local_22;
                            _local_26 = _local_9.create();
                            _local_26.material = _local_9.material;
                            _arg_1.lastFace.next = _local_26;
                            _arg_1.lastFace = _local_26;
                            _local_27 = null;
                            _local_11 = _local_9.wrapper.next.next;
                            while (_local_11.next != null)
                            {
                                _local_11 = _local_11.next;
                            };
                            _local_17 = _local_11.vertex;
                            _local_20 = _local_17.offset;
                            _local_29 = ((!(_local_9.material == null)) && (_local_9.material.useVerticesNormals));
                            _local_11 = _local_9.wrapper;
                            while (_local_11 != null)
                            {
                                _local_18 = _local_11.vertex;
                                _local_21 = _local_18.offset;
                                if ((((_local_20 < _arg_7) && (_local_21 > _arg_8)) || ((_local_20 > _arg_8) && (_local_21 < _arg_7))))
                                {
                                    _local_30 = ((_arg_6 - _local_20) / (_local_21 - _local_20));
                                    _local_12 = _local_18.create();
                                    _arg_1.lastVertex.next = _local_12;
                                    _arg_1.lastVertex = _local_12;
                                    _local_12.x = (_local_17.x + ((_local_18.x - _local_17.x) * _local_30));
                                    _local_12.y = (_local_17.y + ((_local_18.y - _local_17.y) * _local_30));
                                    _local_12.z = (_local_17.z + ((_local_18.z - _local_17.z) * _local_30));
                                    _local_12.u = (_local_17.u + ((_local_18.u - _local_17.u) * _local_30));
                                    _local_12.v = (_local_17.v + ((_local_18.v - _local_17.v) * _local_30));
                                    _local_12.cameraX = (_local_17.cameraX + ((_local_18.cameraX - _local_17.cameraX) * _local_30));
                                    _local_12.cameraY = (_local_17.cameraY + ((_local_18.cameraY - _local_17.cameraY) * _local_30));
                                    _local_12.cameraZ = (_local_17.cameraZ + ((_local_18.cameraZ - _local_17.cameraZ) * _local_30));
                                    if (_local_29)
                                    {
                                        _local_12.normalX = (_local_17.normalX + ((_local_18.normalX - _local_17.normalX) * _local_30));
                                        _local_12.normalY = (_local_17.normalY + ((_local_18.normalY - _local_17.normalY) * _local_30));
                                        _local_12.normalZ = (_local_17.normalZ + ((_local_18.normalZ - _local_17.normalZ) * _local_30));
                                    };
                                    _local_28 = _local_11.create();
                                    _local_28.vertex = _local_12;
                                    if (_local_27 != null)
                                    {
                                        _local_27.next = _local_28;
                                    }
                                    else
                                    {
                                        _local_26.wrapper = _local_28;
                                    };
                                    _local_27 = _local_28;
                                };
                                if (_local_21 >= _arg_7)
                                {
                                    _local_28 = _local_11.create();
                                    _local_28.vertex = _local_18;
                                    if (_local_27 != null)
                                    {
                                        _local_27.next = _local_28;
                                    }
                                    else
                                    {
                                        _local_26.wrapper = _local_28;
                                    };
                                    _local_27 = _local_28;
                                };
                                _local_17 = _local_18;
                                _local_20 = _local_21;
                                _local_11 = _local_11.next;
                            };
                            if (_local_15 != null)
                            {
                                _local_16.processNext = _local_26;
                            }
                            else
                            {
                                _local_15 = _local_26;
                            };
                            _local_16 = _local_26;
                            _local_9.processNext = null;
                        };
                    };
                    _local_9 = _local_10;
                };
            };
            if (((!(_local_15 == null)) || ((!(_local_13 == null)) && (!(_local_14 == null)))))
            {
                if (_local_15 == null)
                {
                    _local_15 = _arg_2.create();
                    _arg_1.lastFace.next = _local_15;
                    _arg_1.lastFace = _local_15;
                }
                else
                {
                    _local_16.processNext = null;
                };
                if (this.sorting == 3)
                {
                    _local_15.normalX = _arg_2.normalX;
                    _local_15.normalY = _arg_2.normalY;
                    _local_15.normalZ = _arg_2.normalZ;
                    _local_15.offset = _arg_2.offset;
                };
                _local_15.processNegative = _local_13;
                _local_15.processPositive = _local_14;
                return (_local_15);
            };
            return ((_local_13 != null) ? _local_13 : _local_14);
        }

        alternativa3d function transformStruct(_arg_1:Face, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number, _arg_12:Number, _arg_13:Number, _arg_14:Number):void{
            var _local_16:Wrapper;
            var _local_17:Vertex;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_15:Face = _arg_1;
            while (_local_15 != null)
            {
                _local_16 = _local_15.wrapper;
                while (_local_16 != null)
                {
                    _local_17 = _local_16.vertex;
                    if (_local_17.transformId != _arg_2)
                    {
                        _local_18 = _local_17.cameraX;
                        _local_19 = _local_17.cameraY;
                        _local_20 = _local_17.cameraZ;
                        _local_17.cameraX = ((((_arg_3 * _local_18) + (_arg_4 * _local_19)) + (_arg_5 * _local_20)) + _arg_6);
                        _local_17.cameraY = ((((_arg_7 * _local_18) + (_arg_8 * _local_19)) + (_arg_9 * _local_20)) + _arg_10);
                        _local_17.cameraZ = ((((_arg_11 * _local_18) + (_arg_12 * _local_19)) + (_arg_13 * _local_20)) + _arg_14);
                        _local_17.transformId = _arg_2;
                    };
                    _local_16 = _local_16.next;
                };
                _local_15 = _local_15.processNext;
            };
            if (_arg_1.processNegative != null)
            {
                this.transformStruct(_arg_1.processNegative, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
            if (_arg_1.processPositive != null)
            {
                this.transformStruct(_arg_1.processPositive, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14);
            };
        }

        alternativa3d function draw(_arg_1:Camera3D, _arg_2:Number, _arg_3:Object3D):void{
            var _local_4:Face;
            var _local_5:Face;
            var _local_6:Face;
            var _local_7:Face;
            if (this.space == 1)
            {
                this.transformStruct(this.faceStruct, ++this.object.transformId, _arg_3.ma, _arg_3.mb, _arg_3.mc, _arg_3.md, _arg_3.me, _arg_3.mf, _arg_3.mg, _arg_3.mh, _arg_3.mi, _arg_3.mj, _arg_3.mk, _arg_3.ml);
            };
            if (this.viewAligned)
            {
                _local_4 = this.faceStruct;
                if (this.debug > 0)
                {
                    if ((this.debug & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, _local_4, ((this.space != 2) ? 0xFFFFFF : 0xFF9900));
                    };
                    if ((this.debug & Debug.BOUNDS))
                    {
                        if (this.space == 1)
                        {
                            Debug.drawBounds(_arg_1, _arg_3, this.boundMinX, this.boundMinY, this.boundMinZ, this.boundMaxX, this.boundMaxY, this.boundMaxZ, 0x99FF00);
                        };
                    };
                };
                _arg_1.addTransparent(_local_4, this.object);
            }
            else
            {
                switch (this.sorting)
                {
                    case 0:
                        _local_4 = this.faceStruct;
                        break;
                    case 1:
                        _local_4 = ((this.faceStruct.processNext != null) ? _arg_1.sortByAverageZ(this.faceStruct) : this.faceStruct);
                        break;
                    case 2:
                        _local_4 = ((this.faceStruct.processNext != null) ? _arg_1.sortByDynamicBSP(this.faceStruct, _arg_2) : this.faceStruct);
                        break;
                    case 3:
                        _local_4 = this.collectNode(this.faceStruct);
                        break;
                };
                if (this.debug > 0)
                {
                    if ((this.debug & Debug.EDGES))
                    {
                        Debug.drawEdges(_arg_1, _local_4, 0xFFFFFF);
                    };
                    if ((this.debug & Debug.BOUNDS))
                    {
                        if (this.space == 1)
                        {
                            Debug.drawBounds(_arg_1, _arg_3, this.boundMinX, this.boundMinY, this.boundMinZ, this.boundMaxX, this.boundMaxY, this.boundMaxZ, 0x99FF00);
                        }
                        else
                        {
                            if (this.space == 2)
                            {
                                Debug.drawBounds(_arg_1, this.object, this.boundMinX, this.boundMinY, this.boundMinZ, this.boundMaxX, this.boundMaxY, this.boundMaxZ, 0xFF9900);
                            };
                        };
                    };
                };
                _local_7 = _local_4;
                while (_local_7 != null)
                {
                    _local_5 = _local_7.processNext;
                    if (((_local_5 == null) || (!(_local_5.material == _local_4.material))))
                    {
                        _local_7.processNext = null;
                        if (_local_4.material != null)
                        {
                            _local_4.processNegative = _local_6;
                            _local_6 = _local_4;
                        }
                        else
                        {
                            while (_local_4 != null)
                            {
                                _local_7 = _local_4.processNext;
                                _local_4.processNext = null;
                                _local_4 = _local_7;
                            };
                        };
                        _local_4 = _local_5;
                    };
                    _local_7 = _local_5;
                };
                _local_4 = _local_6;
                while (_local_4 != null)
                {
                    _local_5 = _local_4.processNegative;
                    _local_4.processNegative = null;
                    _arg_1.addTransparent(_local_4, this.object);
                    _local_4 = _local_5;
                };
            };
            this.faceStruct = null;
        }

        private function collectNode(_arg_1:Face, _arg_2:Face=null):Face{
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:Face;
            if (_arg_1.offset < 0)
            {
                _local_4 = _arg_1.processNegative;
                _local_5 = _arg_1.processPositive;
            }
            else
            {
                _local_4 = _arg_1.processPositive;
                _local_5 = _arg_1.processNegative;
            };
            _arg_1.processNegative = null;
            _arg_1.processPositive = null;
            if (_local_5 != null)
            {
                _arg_2 = this.collectNode(_local_5, _arg_2);
            };
            if (_arg_1.wrapper != null)
            {
                _local_3 = _arg_1;
                while (_local_3.processNext != null)
                {
                    _local_3 = _local_3.processNext;
                };
                _local_3.processNext = _arg_2;
                _arg_2 = _arg_1;
            };
            if (_local_4 != null)
            {
                _arg_2 = this.collectNode(_local_4, _arg_2);
            };
            return (_arg_2);
        }


    }
}//package alternativa.engine3d.core