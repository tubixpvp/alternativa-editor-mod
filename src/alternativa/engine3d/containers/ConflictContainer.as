package alternativa.engine3d.containers
{
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.VG;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Wrapper;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class ConflictContainer extends Object3DContainer 
    {

        public var resolveByAABB:Boolean = true;
        public var resolveByOOBB:Boolean = true;
        public var threshold:Number = 0.01;


        override public function clone():Object3D
        {
            var _local_1:ConflictContainer = new ConflictContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:ConflictContainer = (_arg_1 as ConflictContainer);
            this.resolveByAABB = _local_2.resolveByAABB;
            this.resolveByOOBB = _local_2.resolveByOOBB;
            this.threshold = _local_2.threshold;
        }

        override alternativa3d function draw(_arg_1:Camera3D):void
        {
            var _local_2:int;
            var _local_4:VG;
            var _local_3:VG = getVG(_arg_1);
            if (_local_3 != null)
            {
                if (((_arg_1.debug) && ((_local_2 = _arg_1.checkInDebug(this)) > 0)))
                {
                    if ((_local_2 & Debug.BOUNDS))
                    {
                        Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ);
                    };
                };
                if (_local_3.next != null)
                {
                    calculateInverseMatrix();
                    if (this.resolveByAABB)
                    {
                        _local_4 = _local_3;
                        while (_local_4 != null)
                        {
                            _local_4.calculateAABB(ima, imb, imc, imd, ime, imf, img, imh, imi, imj, imk, iml);
                            _local_4 = _local_4.next;
                        };
                        this.drawAABBGeometry(_arg_1, _local_3);
                    } else
                    {
                        if (this.resolveByOOBB)
                        {
                            _local_4 = _local_3;
                            while (_local_4 != null)
                            {
                                _local_4.calculateOOBB(this);
                                _local_4 = _local_4.next;
                            };
                            this.drawOOBBGeometry(_arg_1, _local_3);
                        } else
                        {
                            this.drawConflictGeometry(_arg_1, _local_3);
                        };
                    };
                } else
                {
                    _local_3.draw(_arg_1, this.threshold, this);
                    _local_3.destroy();
                };
            };
        }

        alternativa3d function drawAABBGeometry(_arg_1:Camera3D, _arg_2:VG, _arg_3:Boolean=true, _arg_4:Boolean=false, _arg_5:Boolean=true, _arg_6:int=-1):void
        {
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_14:Boolean;
            var _local_10:VG = ((_arg_5) ? this.sortGeometry(_arg_2, _arg_3, _arg_4) : _arg_2);
            var _local_11:VG = _local_10;
            var _local_12:VG = _local_10.next;
            var _local_13:Number = _local_10.boundMax;
            while (_local_12 != null)
            {
                _local_14 = (_local_12.boundMin >= (_local_13 - this.threshold));
                if (((_local_14) || (_local_12.next == null)))
                {
                    if (_local_14)
                    {
                        _local_11.next = null;
                        _arg_6 = 0;
                    } else
                    {
                        _local_12 = null;
                        _arg_6++;
                    };
                    if (_arg_3)
                    {
                        _local_7 = (imd < _local_13);
                        _local_8 = false;
                        _local_9 = true;
                    } else
                    {
                        if (_arg_4)
                        {
                            _local_7 = (imh < _local_13);
                            _local_8 = false;
                            _local_9 = false;
                        } else
                        {
                            _local_7 = (iml < _local_13);
                            _local_8 = true;
                            _local_9 = false;
                        };
                    };
                    if (_local_7)
                    {
                        if (_local_10.next != null)
                        {
                            if (_arg_6 < 2)
                            {
                                this.drawAABBGeometry(_arg_1, _local_10, _local_8, _local_9, true, _arg_6);
                            } else
                            {
                                if (this.resolveByOOBB)
                                {
                                    _local_11 = _local_10;
                                    while (_local_11 != null)
                                    {
                                        _local_11.calculateOOBB(this);
                                        _local_11 = _local_11.next;
                                    };
                                    this.drawOOBBGeometry(_arg_1, _local_10);
                                } else
                                {
                                    this.drawConflictGeometry(_arg_1, _local_10);
                                };
                            };
                        } else
                        {
                            _local_10.draw(_arg_1, this.threshold, this);
                            _local_10.destroy();
                        };
                        if (_local_12 != null)
                        {
                            if (_local_12.next != null)
                            {
                                this.drawAABBGeometry(_arg_1, _local_12, _arg_3, _arg_4, false, -1);
                            } else
                            {
                                _local_12.draw(_arg_1, this.threshold, this);
                                _local_12.destroy();
                            };
                        };
                    } else
                    {
                        if (_local_12 != null)
                        {
                            if (_local_12.next != null)
                            {
                                this.drawAABBGeometry(_arg_1, _local_12, _arg_3, _arg_4, false, -1);
                            } else
                            {
                                _local_12.draw(_arg_1, this.threshold, this);
                                _local_12.destroy();
                            };
                        };
                        if (_local_10.next != null)
                        {
                            if (_arg_6 < 2)
                            {
                                this.drawAABBGeometry(_arg_1, _local_10, _local_8, _local_9, true, _arg_6);
                            } else
                            {
                                if (this.resolveByOOBB)
                                {
                                    _local_11 = _local_10;
                                    while (_local_11 != null)
                                    {
                                        _local_11.calculateOOBB(this);
                                        _local_11 = _local_11.next;
                                    };
                                    this.drawOOBBGeometry(_arg_1, _local_10);
                                } else
                                {
                                    this.drawConflictGeometry(_arg_1, _local_10);
                                };
                            };
                        } else
                        {
                            _local_10.draw(_arg_1, this.threshold, this);
                            _local_10.destroy();
                        };
                    };
                    return;
                };
                if (_local_12.boundMax > _local_13)
                {
                    _local_13 = _local_12.boundMax;
                };
                _local_11 = _local_12;
                _local_12 = _local_12.next;
            };
        }

        private function sortGeometry(_arg_1:VG, _arg_2:Boolean, _arg_3:Boolean):VG
        {
            var _local_4:VG = _arg_1;
            var _local_5:VG = _arg_1.next;
            while (((!(_local_5 == null)) && (!(_local_5.next == null))))
            {
                _arg_1 = _arg_1.next;
                _local_5 = _local_5.next.next;
            };
            _local_5 = _arg_1.next;
            _arg_1.next = null;
            if (_local_4.next != null)
            {
                _local_4 = this.sortGeometry(_local_4, _arg_2, _arg_3);
            } else
            {
                if (_arg_2)
                {
                    _local_4.boundMin = _local_4.boundMinX;
                    _local_4.boundMax = _local_4.boundMaxX;
                } else
                {
                    if (_arg_3)
                    {
                        _local_4.boundMin = _local_4.boundMinY;
                        _local_4.boundMax = _local_4.boundMaxY;
                    } else
                    {
                        _local_4.boundMin = _local_4.boundMinZ;
                        _local_4.boundMax = _local_4.boundMaxZ;
                    };
                };
            };
            if (_local_5.next != null)
            {
                _local_5 = this.sortGeometry(_local_5, _arg_2, _arg_3);
            } else
            {
                if (_arg_2)
                {
                    _local_5.boundMin = _local_5.boundMinX;
                    _local_5.boundMax = _local_5.boundMaxX;
                } else
                {
                    if (_arg_3)
                    {
                        _local_5.boundMin = _local_5.boundMinY;
                        _local_5.boundMax = _local_5.boundMaxY;
                    } else
                    {
                        _local_5.boundMin = _local_5.boundMinZ;
                        _local_5.boundMax = _local_5.boundMaxZ;
                    };
                };
            };
            var _local_6:Boolean = (_local_4.boundMin < _local_5.boundMin);
            if (_local_6)
            {
                _arg_1 = _local_4;
                _local_4 = _local_4.next;
            } else
            {
                _arg_1 = _local_5;
                _local_5 = _local_5.next;
            };
            var _local_7:VG = _arg_1;
            while (true)
            {
                if (_local_4 == null)
                {
                    _local_7.next = _local_5;
                    return (_arg_1);
                };
                if (_local_5 == null)
                {
                    _local_7.next = _local_4;
                    return (_arg_1);
                };
                if (_local_6)
                {
                    if (_local_4.boundMin < _local_5.boundMin)
                    {
                        _local_7 = _local_4;
                        _local_4 = _local_4.next;
                    } else
                    {
                        _local_7.next = _local_5;
                        _local_7 = _local_5;
                        _local_5 = _local_5.next;
                        _local_6 = false;
                    };
                } else
                {
                    if (_local_5.boundMin < _local_4.boundMin)
                    {
                        _local_7 = _local_5;
                        _local_5 = _local_5.next;
                    } else
                    {
                        _local_7.next = _local_4;
                        _local_7 = _local_4;
                        _local_4 = _local_4.next;
                        _local_6 = true;
                    };
                };
            };
            return (null);
        }

        alternativa3d function drawOOBBGeometry(_arg_1:Camera3D, _arg_2:VG):void
        {
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Wrapper;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Boolean;
            var _local_12:Boolean;
            var _local_13:VG;
            var _local_14:VG;
            var _local_15:Boolean;
            var _local_16:VG;
            var _local_17:VG;
            var _local_18:VG;
            var _local_19:VG;
            _local_13 = _arg_2;
            while (_local_13 != null)
            {
                if (_local_13.viewAligned)
                {
                    _local_10 = _local_13.object.ml;
                    _local_14 = _arg_2;
                    while (_local_14 != null)
                    {
                        if ((!(_local_14.viewAligned)))
                        {
                            _local_11 = false;
                            _local_12 = false;
                            _local_3 = _local_14.boundVertexList;
                            while (_local_3 != null)
                            {
                                if (_local_3.cameraZ > _local_10)
                                {
                                    if (_local_11) break;
                                    _local_12 = true;
                                } else
                                {
                                    if (_local_12) break;
                                    _local_11 = true;
                                };
                                _local_3 = _local_3.next;
                            };
                            if (_local_3 != null) break;
                        };
                        _local_14 = _local_14.next;
                    };
                    if (_local_14 == null) break;
                } else
                {
                    _local_4 = _local_13.boundPlaneList;
                    while (_local_4 != null)
                    {
                        _local_7 = _local_4.cameraX;
                        _local_8 = _local_4.cameraY;
                        _local_9 = _local_4.cameraZ;
                        _local_10 = _local_4.offset;
                        _local_15 = false;
                        _local_14 = _arg_2;
                        while (_local_14 != null)
                        {
                            if (_local_13 != _local_14)
                            {
                                _local_11 = false;
                                _local_12 = false;
                                if (_local_14.viewAligned)
                                {
                                    _local_5 = _local_14.faceStruct.wrapper;
                                    while (_local_5 != null)
                                    {
                                        _local_3 = _local_5.vertex;
                                        if ((((_local_3.cameraX * _local_7) + (_local_3.cameraY * _local_8)) + (_local_3.cameraZ * _local_9)) >= (_local_10 - this.threshold))
                                        {
                                            if (_local_11) break;
                                            _local_15 = true;
                                            _local_12 = true;
                                        } else
                                        {
                                            if (_local_12) break;
                                            _local_11 = true;
                                        };
                                        _local_5 = _local_5.next;
                                    };
                                    if (_local_5 != null) break;
                                } else
                                {
                                    _local_3 = _local_14.boundVertexList;
                                    while (_local_3 != null)
                                    {
                                        if ((((_local_3.cameraX * _local_7) + (_local_3.cameraY * _local_8)) + (_local_3.cameraZ * _local_9)) >= (_local_10 - this.threshold))
                                        {
                                            if (_local_11) break;
                                            _local_15 = true;
                                            _local_12 = true;
                                        } else
                                        {
                                            if (_local_12) break;
                                            _local_11 = true;
                                        };
                                        _local_3 = _local_3.next;
                                    };
                                    if (_local_3 != null) break;
                                };
                            };
                            _local_14 = _local_14.next;
                        };
                        if (((_local_14 == null) && (_local_15))) break;
                        _local_4 = _local_4.next;
                    };
                    if (_local_4 != null) break;
                };
                _local_13 = _local_13.next;
            };
            if (_local_13 != null)
            {
                if (_local_13.viewAligned)
                {
                    while (_arg_2 != null)
                    {
                        _local_16 = _arg_2.next;
                        if (_arg_2.viewAligned)
                        {
                            _local_6 = (_arg_2.object.ml - _local_10);
                            if (_local_6 < -(this.threshold))
                            {
                                _arg_2.next = _local_19;
                                _local_19 = _arg_2;
                            } else
                            {
                                if (_local_6 > this.threshold)
                                {
                                    _arg_2.next = _local_17;
                                    _local_17 = _arg_2;
                                } else
                                {
                                    _arg_2.next = _local_18;
                                    _local_18 = _arg_2;
                                };
                            };
                        } else
                        {
                            _local_3 = _arg_2.boundVertexList;
                            while (_local_3 != null)
                            {
                                _local_6 = (_local_3.cameraZ - _local_10);
                                if (_local_6 < -(this.threshold))
                                {
                                    _arg_2.next = _local_19;
                                    _local_19 = _arg_2;
                                    break;
                                };
                                if (_local_6 > this.threshold)
                                {
                                    _arg_2.next = _local_17;
                                    _local_17 = _arg_2;
                                    break;
                                };
                                _local_3 = _local_3.next;
                            };
                            if (_local_3 == null)
                            {
                                _arg_2.next = _local_18;
                                _local_18 = _arg_2;
                            };
                        };
                        _arg_2 = _local_16;
                    };
                } else
                {
                    while (_arg_2 != null)
                    {
                        _local_16 = _arg_2.next;
                        if (_arg_2.viewAligned)
                        {
                            _local_5 = _arg_2.faceStruct.wrapper;
                            while (_local_5 != null)
                            {
                                _local_3 = _local_5.vertex;
                                _local_6 = ((((_local_3.cameraX * _local_7) + (_local_3.cameraY * _local_8)) + (_local_3.cameraZ * _local_9)) - _local_10);
                                if (_local_6 < -(this.threshold))
                                {
                                    _arg_2.next = _local_17;
                                    _local_17 = _arg_2;
                                    break;
                                };
                                if (_local_6 > this.threshold)
                                {
                                    _arg_2.next = _local_19;
                                    _local_19 = _arg_2;
                                    break;
                                };
                                _local_5 = _local_5.next;
                            };
                            if (_local_5 == null)
                            {
                                _arg_2.next = _local_18;
                                _local_18 = _arg_2;
                            };
                        } else
                        {
                            _local_3 = _arg_2.boundVertexList;
                            while (_local_3 != null)
                            {
                                _local_6 = ((((_local_3.cameraX * _local_7) + (_local_3.cameraY * _local_8)) + (_local_3.cameraZ * _local_9)) - _local_10);
                                if (_local_6 < -(this.threshold))
                                {
                                    _arg_2.next = _local_17;
                                    _local_17 = _arg_2;
                                    break;
                                };
                                if (_local_6 > this.threshold)
                                {
                                    _arg_2.next = _local_19;
                                    _local_19 = _arg_2;
                                    break;
                                };
                                _local_3 = _local_3.next;
                            };
                            if (_local_3 == null)
                            {
                                _arg_2.next = _local_18;
                                _local_18 = _arg_2;
                            };
                        };
                        _arg_2 = _local_16;
                    };
                };
                if (((_local_13.viewAligned) || (_local_10 < 0)))
                {
                    if (_local_19 != null)
                    {
                        if (_local_19.next != null)
                        {
                            this.drawOOBBGeometry(_arg_1, _local_19);
                        } else
                        {
                            _local_19.draw(_arg_1, this.threshold, this);
                            _local_19.destroy();
                        };
                    };
                    while (_local_18 != null)
                    {
                        _local_16 = _local_18.next;
                        _local_18.draw(_arg_1, this.threshold, this);
                        _local_18.destroy();
                        _local_18 = _local_16;
                    };
                    if (_local_17 != null)
                    {
                        if (_local_17.next != null)
                        {
                            this.drawOOBBGeometry(_arg_1, _local_17);
                        } else
                        {
                            _local_17.draw(_arg_1, this.threshold, this);
                            _local_17.destroy();
                        };
                    };
                } else
                {
                    if (_local_17 != null)
                    {
                        if (_local_17.next != null)
                        {
                            this.drawOOBBGeometry(_arg_1, _local_17);
                        } else
                        {
                            _local_17.draw(_arg_1, this.threshold, this);
                            _local_17.destroy();
                        };
                    };
                    while (_local_18 != null)
                    {
                        _local_16 = _local_18.next;
                        _local_18.draw(_arg_1, this.threshold, this);
                        _local_18.destroy();
                        _local_18 = _local_16;
                    };
                    if (_local_19 != null)
                    {
                        if (_local_19.next != null)
                        {
                            this.drawOOBBGeometry(_arg_1, _local_19);
                        } else
                        {
                            _local_19.draw(_arg_1, this.threshold, this);
                            _local_19.destroy();
                        };
                    };
                };
            } else
            {
                this.drawConflictGeometry(_arg_1, _arg_2);
            };
        }

        alternativa3d function drawConflictGeometry(_arg_1:Camera3D, _arg_2:VG):void
        {
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:VG;
            var _local_6:VG;
            var _local_7:VG;
            var _local_8:Face;
            var _local_9:Face;
            var _local_10:Face;
            var _local_11:Face;
            var _local_12:Face;
            var _local_13:Face;
            var _local_14:Face;
            var _local_15:Face;
            var _local_16:Face;
            var _local_17:Boolean;
            while (_arg_2 != null)
            {
                _local_5 = _arg_2.next;
                if (_arg_2.space == 1)
                {
                    _arg_2.transformStruct(_arg_2.faceStruct, ++_arg_2.object.transformId, ma, mb, mc, md, me, mf, mg, mh, mi, mj, mk, ml);
                };
                if (_arg_2.sorting == 3)
                {
                    _arg_2.next = _local_6;
                    _local_6 = _arg_2;
                } else
                {
                    if (_arg_2.sorting == 2)
                    {
                        if (_local_8 != null)
                        {
                            _local_9.processNext = _arg_2.faceStruct;
                        } else
                        {
                            _local_8 = _arg_2.faceStruct;
                        };
                        _local_9 = _arg_2.faceStruct;
                        _local_9.geometry = _arg_2;
                        while (_local_9.processNext != null)
                        {
                            _local_9 = _local_9.processNext;
                            _local_9.geometry = _arg_2;
                        };
                    } else
                    {
                        if (_local_10 != null)
                        {
                            _local_11.processNext = _arg_2.faceStruct;
                        } else
                        {
                            _local_10 = _arg_2.faceStruct;
                        };
                        _local_11 = _arg_2.faceStruct;
                        _local_11.geometry = _arg_2;
                        while (_local_11.processNext != null)
                        {
                            _local_11 = _local_11.processNext;
                            _local_11.geometry = _arg_2;
                        };
                    };
                    _arg_2.faceStruct = null;
                    _arg_2.next = _local_7;
                    _local_7 = _arg_2;
                };
                _arg_2 = _local_5;
            };
            if (_local_7 != null)
            {
                _arg_2 = _local_7;
                while (_arg_2.next != null)
                {
                    _arg_2 = _arg_2.next;
                };
                _arg_2.next = _local_6;
            } else
            {
                _local_7 = _local_6;
            };
            if (_local_8 != null)
            {
                _local_12 = _local_8;
                _local_9.processNext = _local_10;
            } else
            {
                _local_12 = _local_10;
            };
            if (_local_6 != null)
            {
                _local_6.faceStruct.geometry = _local_6;
                _local_12 = this.collectNode(_local_6.faceStruct, _local_12, _arg_1, this.threshold, true);
                _local_6.faceStruct = null;
                _local_6 = _local_6.next;
                while (_local_6 != null)
                {
                    _local_6.faceStruct.geometry = _local_6;
                    _local_12 = this.collectNode(_local_6.faceStruct, _local_12, _arg_1, this.threshold, false);
                    _local_6.faceStruct = null;
                    _local_6 = _local_6.next;
                };
            } else
            {
                if (_local_8 != null)
                {
                    _local_12 = this.collectNode(null, _local_12, _arg_1, this.threshold, true);
                } else
                {
                    if (_local_10 != null)
                    {
                        _local_12 = _arg_1.sortByAverageZ(_local_12);
                    };
                };
            };
            _local_3 = _local_12;
            while (_local_3 != null)
            {
                _local_4 = _local_3.processNext;
                _arg_2 = _local_3.geometry;
                _local_3.geometry = null;
                _local_17 = ((_local_4 == null) || (!(_arg_2 == _local_4.geometry)));
                if (((_local_17) || (!(_local_3.material == _local_4.material))))
                {
                    _local_3.processNext = null;
                    if (_local_17)
                    {
                        if (_local_13 != null)
                        {
                            _local_14.processNegative = _local_12;
                            _local_13 = null;
                            _local_14 = null;
                        } else
                        {
                            _local_12.processPositive = _local_15;
                            _local_15 = _local_12;
                            _local_15.geometry = _arg_2;
                        };
                    } else
                    {
                        if (_local_13 != null)
                        {
                            _local_14.processNegative = _local_12;
                        } else
                        {
                            _local_12.processPositive = _local_15;
                            _local_15 = _local_12;
                            _local_15.geometry = _arg_2;
                            _local_13 = _local_12;
                        };
                        _local_14 = _local_12;
                    };
                    _local_12 = _local_4;
                };
                _local_3 = _local_4;
            };
            if (_arg_1.debug)
            {
                _local_12 = _local_15;
                while (_local_12 != null)
                {
                    if ((_local_12.geometry.debug & Debug.EDGES))
                    {
                        _local_3 = _local_12;
                        while (_local_3 != null)
                        {
                            Debug.drawEdges(_arg_1, _local_3, 0xFF0000);
                            _local_3 = _local_3.processNegative;
                        };
                    };
                    _local_12 = _local_12.processPositive;
                };
            };
            while (_local_15 != null)
            {
                _local_12 = _local_15;
                _local_15 = _local_12.processPositive;
                _local_12.processPositive = null;
                _arg_2 = _local_12.geometry;
                _local_12.geometry = null;
                _local_16 = null;
                while (_local_12 != null)
                {
                    _local_4 = _local_12.processNegative;
                    if (_local_12.material != null)
                    {
                        _local_12.processNegative = _local_16;
                        _local_16 = _local_12;
                    } else
                    {
                        _local_12.processNegative = null;
                        while (_local_12 != null)
                        {
                            _local_3 = _local_12.processNext;
                            _local_12.processNext = null;
                            _local_12 = _local_3;
                        };
                    };
                    _local_12 = _local_4;
                };
                _local_12 = _local_16;
                while (_local_12 != null)
                {
                    _local_4 = _local_12.processNegative;
                    _local_12.processNegative = null;
                    _arg_1.addTransparent(_local_12, _arg_2.object);
                    _local_12 = _local_4;
                };
            };
            _arg_2 = _local_7;
            while (_arg_2 != null)
            {
                _local_5 = _arg_2.next;
                _arg_2.destroy();
                _arg_2 = _local_5;
            };
        }

        private function collectNode(_arg_1:Face, _arg_2:Face, _arg_3:Camera3D, _arg_4:Number, _arg_5:Boolean, _arg_6:Face=null):Face
        {
            var _local_7:Wrapper;
            var _local_8:Vertex;
            var _local_9:Vertex;
            var _local_10:Vertex;
            var _local_11:Vertex;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Face;
            var _local_17:Face;
            var _local_18:Face;
            var _local_19:VG;
            var _local_22:Face;
            var _local_23:Face;
            var _local_24:Face;
            var _local_25:Face;
            var _local_26:Face;
            var _local_28:Number;
            var _local_29:Number;
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
            var _local_45:Boolean;
            var _local_46:Boolean;
            var _local_47:Number;
            var _local_48:Face;
            var _local_49:Face;
            var _local_50:Wrapper;
            var _local_51:Wrapper;
            var _local_52:Wrapper;
            var _local_53:Boolean;
            var _local_54:Number;
            if (_arg_1 != null)
            {
                _local_19 = _arg_1.geometry;
                if (_arg_1.offset < 0)
                {
                    _local_17 = _arg_1.processNegative;
                    _local_18 = _arg_1.processPositive;
                    _local_12 = _arg_1.normalX;
                    _local_13 = _arg_1.normalY;
                    _local_14 = _arg_1.normalZ;
                    _local_15 = _arg_1.offset;
                } else
                {
                    _local_17 = _arg_1.processPositive;
                    _local_18 = _arg_1.processNegative;
                    _local_12 = -(_arg_1.normalX);
                    _local_13 = -(_arg_1.normalY);
                    _local_14 = -(_arg_1.normalZ);
                    _local_15 = -(_arg_1.offset);
                };
                _arg_1.processNegative = null;
                _arg_1.processPositive = null;
                if (_arg_1.wrapper != null)
                {
                    _local_16 = _arg_1;
                    while (_local_16.processNext != null)
                    {
                        _local_16 = _local_16.processNext;
                        _local_16.geometry = _local_19;
                    };
                } else
                {
                    _arg_1.geometry = null;
                    _arg_1 = null;
                };
            } else
            {
                _arg_1 = _arg_2;
                _arg_2 = _arg_1.processNext;
                _local_16 = _arg_1;
                _local_7 = _arg_1.wrapper;
                _local_8 = _local_7.vertex;
                _local_7 = _local_7.next;
                _local_9 = _local_7.vertex;
                _local_28 = _local_8.cameraX;
                _local_29 = _local_8.cameraY;
                _local_30 = _local_8.cameraZ;
                _local_31 = (_local_9.cameraX - _local_28);
                _local_32 = (_local_9.cameraY - _local_29);
                _local_33 = (_local_9.cameraZ - _local_30);
                _local_12 = 0;
                _local_13 = 0;
                _local_14 = 1;
                _local_15 = _local_30;
                _local_34 = 0;
                _local_7 = _local_7.next;
                while (_local_7 != null)
                {
                    _local_11 = _local_7.vertex;
                    _local_35 = (_local_11.cameraX - _local_28);
                    _local_36 = (_local_11.cameraY - _local_29);
                    _local_37 = (_local_11.cameraZ - _local_30);
                    _local_38 = ((_local_37 * _local_32) - (_local_36 * _local_33));
                    _local_39 = ((_local_35 * _local_33) - (_local_37 * _local_31));
                    _local_40 = ((_local_36 * _local_31) - (_local_35 * _local_32));
                    _local_41 = (((_local_38 * _local_38) + (_local_39 * _local_39)) + (_local_40 * _local_40));
                    if (_local_41 > _arg_4)
                    {
                        _local_41 = (1 / Math.sqrt(_local_41));
                        _local_12 = (_local_38 * _local_41);
                        _local_13 = (_local_39 * _local_41);
                        _local_14 = (_local_40 * _local_41);
                        _local_15 = (((_local_28 * _local_12) + (_local_29 * _local_13)) + (_local_30 * _local_14));
                        break;
                    };
                    if (_local_41 > _local_34)
                    {
                        _local_41 = (1 / Math.sqrt(_local_41));
                        _local_12 = (_local_38 * _local_41);
                        _local_13 = (_local_39 * _local_41);
                        _local_14 = (_local_40 * _local_41);
                        _local_15 = (((_local_28 * _local_12) + (_local_29 * _local_13)) + (_local_30 * _local_14));
                        _local_34 = _local_41;
                    };
                    _local_7 = _local_7.next;
                };
            };
            var _local_20:Number = (_local_15 - _arg_4);
            var _local_21:Number = (_local_15 + _arg_4);
            var _local_27:Face = _arg_2;
            while (_local_27 != null)
            {
                _local_26 = _local_27.processNext;
                _local_7 = _local_27.wrapper;
                _local_8 = _local_7.vertex;
                _local_7 = _local_7.next;
                _local_9 = _local_7.vertex;
                _local_7 = _local_7.next;
                _local_10 = _local_7.vertex;
                _local_7 = _local_7.next;
                _local_42 = (((_local_8.cameraX * _local_12) + (_local_8.cameraY * _local_13)) + (_local_8.cameraZ * _local_14));
                _local_43 = (((_local_9.cameraX * _local_12) + (_local_9.cameraY * _local_13)) + (_local_9.cameraZ * _local_14));
                _local_44 = (((_local_10.cameraX * _local_12) + (_local_10.cameraY * _local_13)) + (_local_10.cameraZ * _local_14));
                _local_45 = (((_local_42 < _local_20) || (_local_43 < _local_20)) || (_local_44 < _local_20));
                _local_46 = (((_local_42 > _local_21) || (_local_43 > _local_21)) || (_local_44 > _local_21));
                while (_local_7 != null)
                {
                    _local_11 = _local_7.vertex;
                    _local_47 = (((_local_11.cameraX * _local_12) + (_local_11.cameraY * _local_13)) + (_local_11.cameraZ * _local_14));
                    if (_local_47 < _local_20)
                    {
                        _local_45 = true;
                    } else
                    {
                        if (_local_47 > _local_21)
                        {
                            _local_46 = true;
                        };
                    };
                    _local_11.offset = _local_47;
                    _local_7 = _local_7.next;
                };
                if ((!(_local_45)))
                {
                    if ((!(_local_46)))
                    {
                        if (_arg_1 != null)
                        {
                            _local_16.processNext = _local_27;
                        } else
                        {
                            _arg_1 = _local_27;
                        };
                        _local_16 = _local_27;
                    } else
                    {
                        if (_local_24 != null)
                        {
                            _local_25.processNext = _local_27;
                        } else
                        {
                            _local_24 = _local_27;
                        };
                        _local_25 = _local_27;
                    };
                } else
                {
                    if ((!(_local_46)))
                    {
                        if (_local_22 != null)
                        {
                            _local_23.processNext = _local_27;
                        } else
                        {
                            _local_22 = _local_27;
                        };
                        _local_23 = _local_27;
                    } else
                    {
                        _local_8.offset = _local_42;
                        _local_9.offset = _local_43;
                        _local_10.offset = _local_44;
                        _local_48 = _local_27.create();
                        _local_48.material = _local_27.material;
                        _local_48.geometry = _local_27.geometry;
                        _arg_3.lastFace.next = _local_48;
                        _arg_3.lastFace = _local_48;
                        _local_49 = _local_27.create();
                        _local_49.material = _local_27.material;
                        _local_49.geometry = _local_27.geometry;
                        _arg_3.lastFace.next = _local_49;
                        _arg_3.lastFace = _local_49;
                        _local_50 = null;
                        _local_51 = null;
                        _local_7 = _local_27.wrapper.next.next;
                        while (_local_7.next != null)
                        {
                            _local_7 = _local_7.next;
                        };
                        _local_8 = _local_7.vertex;
                        _local_42 = _local_8.offset;
                        _local_53 = ((!(_local_27.material == null)) && (_local_27.material.useVerticesNormals));
                        _local_7 = _local_27.wrapper;
                        while (_local_7 != null)
                        {
                            _local_9 = _local_7.vertex;
                            _local_43 = _local_9.offset;
                            if ((((_local_42 < _local_20) && (_local_43 > _local_21)) || ((_local_42 > _local_21) && (_local_43 < _local_20))))
                            {
                                _local_54 = ((_local_15 - _local_42) / (_local_43 - _local_42));
                                _local_11 = _local_9.create();
                                _arg_3.lastVertex.next = _local_11;
                                _arg_3.lastVertex = _local_11;
                                _local_11.cameraX = (_local_8.cameraX + ((_local_9.cameraX - _local_8.cameraX) * _local_54));
                                _local_11.cameraY = (_local_8.cameraY + ((_local_9.cameraY - _local_8.cameraY) * _local_54));
                                _local_11.cameraZ = (_local_8.cameraZ + ((_local_9.cameraZ - _local_8.cameraZ) * _local_54));
                                _local_11.u = (_local_8.u + ((_local_9.u - _local_8.u) * _local_54));
                                _local_11.v = (_local_8.v + ((_local_9.v - _local_8.v) * _local_54));
                                if (_local_53)
                                {
                                    _local_11.x = (_local_8.x + ((_local_9.x - _local_8.x) * _local_54));
                                    _local_11.y = (_local_8.y + ((_local_9.y - _local_8.y) * _local_54));
                                    _local_11.z = (_local_8.z + ((_local_9.z - _local_8.z) * _local_54));
                                    _local_11.normalX = (_local_8.normalX + ((_local_9.normalX - _local_8.normalX) * _local_54));
                                    _local_11.normalY = (_local_8.normalY + ((_local_9.normalY - _local_8.normalY) * _local_54));
                                    _local_11.normalZ = (_local_8.normalZ + ((_local_9.normalZ - _local_8.normalZ) * _local_54));
                                };
                                _local_52 = _local_7.create();
                                _local_52.vertex = _local_11;
                                if (_local_50 != null)
                                {
                                    _local_50.next = _local_52;
                                } else
                                {
                                    _local_48.wrapper = _local_52;
                                };
                                _local_50 = _local_52;
                                _local_52 = _local_7.create();
                                _local_52.vertex = _local_11;
                                if (_local_51 != null)
                                {
                                    _local_51.next = _local_52;
                                } else
                                {
                                    _local_49.wrapper = _local_52;
                                };
                                _local_51 = _local_52;
                            };
                            if (_local_43 <= _local_21)
                            {
                                _local_52 = _local_7.create();
                                _local_52.vertex = _local_9;
                                if (_local_50 != null)
                                {
                                    _local_50.next = _local_52;
                                } else
                                {
                                    _local_48.wrapper = _local_52;
                                };
                                _local_50 = _local_52;
                            };
                            if (_local_43 >= _local_20)
                            {
                                _local_52 = _local_7.create();
                                _local_52.vertex = _local_9;
                                if (_local_51 != null)
                                {
                                    _local_51.next = _local_52;
                                } else
                                {
                                    _local_49.wrapper = _local_52;
                                };
                                _local_51 = _local_52;
                            };
                            _local_8 = _local_9;
                            _local_42 = _local_43;
                            _local_7 = _local_7.next;
                        };
                        if (_local_22 != null)
                        {
                            _local_23.processNext = _local_48;
                        } else
                        {
                            _local_22 = _local_48;
                        };
                        _local_23 = _local_48;
                        if (_local_24 != null)
                        {
                            _local_25.processNext = _local_49;
                        } else
                        {
                            _local_24 = _local_49;
                        };
                        _local_25 = _local_49;
                        _local_27.processNext = null;
                        _local_27.geometry = null;
                    };
                };
                _local_27 = _local_26;
            };
            if (_local_18 != null)
            {
                _local_18.geometry = _local_19;
                if (_local_25 != null)
                {
                    _local_25.processNext = null;
                };
                _arg_6 = this.collectNode(_local_18, _local_24, _arg_3, _arg_4, _arg_5, _arg_6);
            } else
            {
                if (_local_24 != null)
                {
                    if (((_arg_5) && (!(_local_24 == _local_25))))
                    {
                        if (_local_25 != null)
                        {
                            _local_25.processNext = null;
                        };
                        if (_local_24.geometry.sorting == 2)
                        {
                            _arg_6 = this.collectNode(null, _local_24, _arg_3, _arg_4, _arg_5, _arg_6);
                        } else
                        {
                            _local_24 = _arg_3.sortByAverageZ(_local_24);
                            _local_25 = _local_24.processNext;
                            while (_local_25.processNext != null)
                            {
                                _local_25 = _local_25.processNext;
                            };
                            _local_25.processNext = _arg_6;
                            _arg_6 = _local_24;
                        };
                    } else
                    {
                        _local_25.processNext = _arg_6;
                        _arg_6 = _local_24;
                    };
                };
            };
            if (_arg_1 != null)
            {
                _local_16.processNext = _arg_6;
                _arg_6 = _arg_1;
            };
            if (_local_17 != null)
            {
                _local_17.geometry = _local_19;
                if (_local_23 != null)
                {
                    _local_23.processNext = null;
                };
                _arg_6 = this.collectNode(_local_17, _local_22, _arg_3, _arg_4, _arg_5, _arg_6);
            } else
            {
                if (_local_22 != null)
                {
                    if (((_arg_5) && (!(_local_22 == _local_23))))
                    {
                        if (_local_23 != null)
                        {
                            _local_23.processNext = null;
                        };
                        if (_local_22.geometry.sorting == 2)
                        {
                            _arg_6 = this.collectNode(null, _local_22, _arg_3, _arg_4, _arg_5, _arg_6);
                        } else
                        {
                            _local_22 = _arg_3.sortByAverageZ(_local_22);
                            _local_23 = _local_22.processNext;
                            while (_local_23.processNext != null)
                            {
                                _local_23 = _local_23.processNext;
                            };
                            _local_23.processNext = _arg_6;
                            _arg_6 = _local_22;
                        };
                    } else
                    {
                        _local_23.processNext = _arg_6;
                        _arg_6 = _local_22;
                    };
                };
            };
            return (_arg_6);
        }


    }
}//package alternativa.engine3d.containers