package alternativa.engine3d.lights
{
    import alternativa.engine3d.core.Light3D;
    import alternativa.engine3d.core.Object3D;
    import flash.display.Sprite;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class DirectionalLight extends Light3D 
    {

        public function DirectionalLight(_arg_1:uint)
        {
            this.color = _arg_1;
            calculateBounds();
        }

        public function lookAt(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Number = (_arg_1 - this.x);
            var _local_5:Number = (_arg_2 - this.y);
            var _local_6:Number = (_arg_3 - this.z);
            rotationX = (Math.atan2(_local_6, Math.sqrt(((_local_4 * _local_4) + (_local_5 * _local_5)))) - (Math.PI / 2));
            rotationY = 0;
            rotationZ = -(Math.atan2(_local_4, _local_5));
        }

        override public function clone():Object3D
        {
            var _local_1:DirectionalLight = new DirectionalLight(color);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override alternativa3d function drawDebug(_arg_1:Camera3D):void
        {
            var _local_3:Sprite;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:int;
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
            var _local_19:Number;
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
            var _local_47:Number;
            var _local_48:Number;
            var _local_49:Number;
            var _local_50:Number;
            var _local_51:Number;
            var _local_52:Number;
            var _local_53:Number;
            var _local_54:Number;
            var _local_55:Number;
            var _local_56:Number;
            var _local_57:Number;
            var _local_58:Number;
            var _local_59:Number;
            var _local_60:Number;
            var _local_61:Number;
            var _local_62:Number;
            var _local_63:Number;
            var _local_64:Number;
            var _local_2:int = _arg_1.checkInDebug(this);
            if (_local_2 > 0)
            {
                _local_3 = _arg_1.view.canvas;
                if (((_local_2 & Debug.LIGHTS) && (ml > _arg_1.nearClipping)))
                {
                    _local_4 = (((color >> 16) & 0xFF) * intensity);
                    _local_5 = (((color >> 8) & 0xFF) * intensity);
                    _local_6 = ((color & 0xFF) * intensity);
                    _local_7 = (((((_local_4 > 0xFF) ? 0xFF : _local_4) << 16) + (((_local_5 > 0xFF) ? 0xFF : _local_5) << 8)) + ((_local_6 > 0xFF) ? 0xFF : _local_6));
                    _local_8 = ((md * _arg_1.viewSizeX) / _arg_1.focalLength);
                    _local_9 = ((mh * _arg_1.viewSizeY) / _arg_1.focalLength);
                    _local_10 = ml;
                    _local_11 = ((mc * _arg_1.viewSizeX) / _arg_1.focalLength);
                    _local_12 = ((mg * _arg_1.viewSizeY) / _arg_1.focalLength);
                    _local_13 = mk;
                    _local_14 = Math.sqrt((((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_13 * _local_13)));
                    _local_11 = (_local_11 / _local_14);
                    _local_12 = (_local_12 / _local_14);
                    _local_13 = (_local_13 / _local_14);
                    _local_15 = ((ma * _arg_1.viewSizeX) / _arg_1.focalLength);
                    _local_16 = ((me * _arg_1.viewSizeY) / _arg_1.focalLength);
                    _local_17 = mi;
                    _local_18 = ((_local_17 * _local_12) - (_local_16 * _local_13));
                    _local_19 = ((_local_15 * _local_13) - (_local_17 * _local_11));
                    _local_20 = ((_local_16 * _local_11) - (_local_15 * _local_12));
                    _local_14 = Math.sqrt((((_local_18 * _local_18) + (_local_19 * _local_19)) + (_local_20 * _local_20)));
                    _local_18 = (_local_18 / _local_14);
                    _local_19 = (_local_19 / _local_14);
                    _local_20 = (_local_20 / _local_14);
                    _local_15 = ((mb * _arg_1.viewSizeX) / _arg_1.focalLength);
                    _local_16 = ((mf * _arg_1.viewSizeY) / _arg_1.focalLength);
                    _local_17 = mj;
                    _local_15 = ((_local_20 * _local_12) - (_local_19 * _local_13));
                    _local_16 = ((_local_18 * _local_13) - (_local_20 * _local_11));
                    _local_17 = ((_local_19 * _local_11) - (_local_18 * _local_12));
                    _local_21 = (ml / _arg_1.focalLength);
                    _local_11 = (_local_11 * _local_21);
                    _local_12 = (_local_12 * _local_21);
                    _local_13 = (_local_13 * _local_21);
                    _local_15 = (_local_15 * _local_21);
                    _local_16 = (_local_16 * _local_21);
                    _local_17 = (_local_17 * _local_21);
                    _local_18 = (_local_18 * _local_21);
                    _local_19 = (_local_19 * _local_21);
                    _local_20 = (_local_20 * _local_21);
                    _local_22 = 16;
                    _local_23 = 24;
                    _local_24 = 4;
                    _local_25 = 8;
                    _local_26 = (_local_8 + (_local_11 * _local_23));
                    _local_27 = (_local_9 + (_local_12 * _local_23));
                    _local_28 = (_local_10 + (_local_13 * _local_23));
                    _local_29 = ((_local_8 + (_local_15 * _local_24)) + (_local_18 * _local_24));
                    _local_30 = ((_local_9 + (_local_16 * _local_24)) + (_local_19 * _local_24));
                    _local_31 = ((_local_10 + (_local_17 * _local_24)) + (_local_20 * _local_24));
                    _local_32 = ((_local_8 - (_local_15 * _local_24)) + (_local_18 * _local_24));
                    _local_33 = ((_local_9 - (_local_16 * _local_24)) + (_local_19 * _local_24));
                    _local_34 = ((_local_10 - (_local_17 * _local_24)) + (_local_20 * _local_24));
                    _local_35 = ((_local_8 - (_local_15 * _local_24)) - (_local_18 * _local_24));
                    _local_36 = ((_local_9 - (_local_16 * _local_24)) - (_local_19 * _local_24));
                    _local_37 = ((_local_10 - (_local_17 * _local_24)) - (_local_20 * _local_24));
                    _local_38 = ((_local_8 + (_local_15 * _local_24)) - (_local_18 * _local_24));
                    _local_39 = ((_local_9 + (_local_16 * _local_24)) - (_local_19 * _local_24));
                    _local_40 = ((_local_10 + (_local_17 * _local_24)) - (_local_20 * _local_24));
                    _local_41 = (((_local_8 + (_local_11 * _local_22)) + (_local_15 * _local_24)) + (_local_18 * _local_24));
                    _local_42 = (((_local_9 + (_local_12 * _local_22)) + (_local_16 * _local_24)) + (_local_19 * _local_24));
                    _local_43 = (((_local_10 + (_local_13 * _local_22)) + (_local_17 * _local_24)) + (_local_20 * _local_24));
                    _local_44 = (((_local_8 + (_local_11 * _local_22)) - (_local_15 * _local_24)) + (_local_18 * _local_24));
                    _local_45 = (((_local_9 + (_local_12 * _local_22)) - (_local_16 * _local_24)) + (_local_19 * _local_24));
                    _local_46 = (((_local_10 + (_local_13 * _local_22)) - (_local_17 * _local_24)) + (_local_20 * _local_24));
                    _local_47 = (((_local_8 + (_local_11 * _local_22)) - (_local_15 * _local_24)) - (_local_18 * _local_24));
                    _local_48 = (((_local_9 + (_local_12 * _local_22)) - (_local_16 * _local_24)) - (_local_19 * _local_24));
                    _local_49 = (((_local_10 + (_local_13 * _local_22)) - (_local_17 * _local_24)) - (_local_20 * _local_24));
                    _local_50 = (((_local_8 + (_local_11 * _local_22)) + (_local_15 * _local_24)) - (_local_18 * _local_24));
                    _local_51 = (((_local_9 + (_local_12 * _local_22)) + (_local_16 * _local_24)) - (_local_19 * _local_24));
                    _local_52 = (((_local_10 + (_local_13 * _local_22)) + (_local_17 * _local_24)) - (_local_20 * _local_24));
                    _local_53 = (((_local_8 + (_local_11 * _local_22)) + (_local_15 * _local_25)) + (_local_18 * _local_25));
                    _local_54 = (((_local_9 + (_local_12 * _local_22)) + (_local_16 * _local_25)) + (_local_19 * _local_25));
                    _local_55 = (((_local_10 + (_local_13 * _local_22)) + (_local_17 * _local_25)) + (_local_20 * _local_25));
                    _local_56 = (((_local_8 + (_local_11 * _local_22)) - (_local_15 * _local_25)) + (_local_18 * _local_25));
                    _local_57 = (((_local_9 + (_local_12 * _local_22)) - (_local_16 * _local_25)) + (_local_19 * _local_25));
                    _local_58 = (((_local_10 + (_local_13 * _local_22)) - (_local_17 * _local_25)) + (_local_20 * _local_25));
                    _local_59 = (((_local_8 + (_local_11 * _local_22)) - (_local_15 * _local_25)) - (_local_18 * _local_25));
                    _local_60 = (((_local_9 + (_local_12 * _local_22)) - (_local_16 * _local_25)) - (_local_19 * _local_25));
                    _local_61 = (((_local_10 + (_local_13 * _local_22)) - (_local_17 * _local_25)) - (_local_20 * _local_25));
                    _local_62 = (((_local_8 + (_local_11 * _local_22)) + (_local_15 * _local_25)) - (_local_18 * _local_25));
                    _local_63 = (((_local_9 + (_local_12 * _local_22)) + (_local_16 * _local_25)) - (_local_19 * _local_25));
                    _local_64 = (((_local_10 + (_local_13 * _local_22)) + (_local_17 * _local_25)) - (_local_20 * _local_25));
                    if ((((((((((((((_local_28 > _arg_1.nearClipping) && (_local_31 > _arg_1.nearClipping)) && (_local_34 > _arg_1.nearClipping)) && (_local_37 > _arg_1.nearClipping)) && (_local_40 > _arg_1.nearClipping)) && (_local_43 > _arg_1.nearClipping)) && (_local_46 > _arg_1.nearClipping)) && (_local_49 > _arg_1.nearClipping)) && (_local_52 > _arg_1.nearClipping)) && (_local_55 > _arg_1.nearClipping)) && (_local_58 > _arg_1.nearClipping)) && (_local_61 > _arg_1.nearClipping)) && (_local_64 > _arg_1.nearClipping)))
                    {
                        _local_3.graphics.lineStyle(1, _local_7);
                        _local_3.graphics.moveTo(((_local_29 * _arg_1.focalLength) / _local_31), ((_local_30 * _arg_1.focalLength) / _local_31));
                        _local_3.graphics.lineTo(((_local_32 * _arg_1.focalLength) / _local_34), ((_local_33 * _arg_1.focalLength) / _local_34));
                        _local_3.graphics.lineTo(((_local_35 * _arg_1.focalLength) / _local_37), ((_local_36 * _arg_1.focalLength) / _local_37));
                        _local_3.graphics.lineTo(((_local_38 * _arg_1.focalLength) / _local_40), ((_local_39 * _arg_1.focalLength) / _local_40));
                        _local_3.graphics.lineTo(((_local_29 * _arg_1.focalLength) / _local_31), ((_local_30 * _arg_1.focalLength) / _local_31));
                        _local_3.graphics.moveTo(((_local_41 * _arg_1.focalLength) / _local_43), ((_local_42 * _arg_1.focalLength) / _local_43));
                        _local_3.graphics.lineTo(((_local_44 * _arg_1.focalLength) / _local_46), ((_local_45 * _arg_1.focalLength) / _local_46));
                        _local_3.graphics.lineTo(((_local_47 * _arg_1.focalLength) / _local_49), ((_local_48 * _arg_1.focalLength) / _local_49));
                        _local_3.graphics.lineTo(((_local_50 * _arg_1.focalLength) / _local_52), ((_local_51 * _arg_1.focalLength) / _local_52));
                        _local_3.graphics.lineTo(((_local_41 * _arg_1.focalLength) / _local_43), ((_local_42 * _arg_1.focalLength) / _local_43));
                        _local_3.graphics.moveTo(((_local_53 * _arg_1.focalLength) / _local_55), ((_local_54 * _arg_1.focalLength) / _local_55));
                        _local_3.graphics.lineTo(((_local_56 * _arg_1.focalLength) / _local_58), ((_local_57 * _arg_1.focalLength) / _local_58));
                        _local_3.graphics.lineTo(((_local_59 * _arg_1.focalLength) / _local_61), ((_local_60 * _arg_1.focalLength) / _local_61));
                        _local_3.graphics.lineTo(((_local_62 * _arg_1.focalLength) / _local_64), ((_local_63 * _arg_1.focalLength) / _local_64));
                        _local_3.graphics.lineTo(((_local_53 * _arg_1.focalLength) / _local_55), ((_local_54 * _arg_1.focalLength) / _local_55));
                        _local_3.graphics.moveTo(((_local_26 * _arg_1.focalLength) / _local_28), ((_local_27 * _arg_1.focalLength) / _local_28));
                        _local_3.graphics.lineTo(((_local_53 * _arg_1.focalLength) / _local_55), ((_local_54 * _arg_1.focalLength) / _local_55));
                        _local_3.graphics.moveTo(((_local_26 * _arg_1.focalLength) / _local_28), ((_local_27 * _arg_1.focalLength) / _local_28));
                        _local_3.graphics.lineTo(((_local_56 * _arg_1.focalLength) / _local_58), ((_local_57 * _arg_1.focalLength) / _local_58));
                        _local_3.graphics.moveTo(((_local_26 * _arg_1.focalLength) / _local_28), ((_local_27 * _arg_1.focalLength) / _local_28));
                        _local_3.graphics.lineTo(((_local_59 * _arg_1.focalLength) / _local_61), ((_local_60 * _arg_1.focalLength) / _local_61));
                        _local_3.graphics.moveTo(((_local_26 * _arg_1.focalLength) / _local_28), ((_local_27 * _arg_1.focalLength) / _local_28));
                        _local_3.graphics.lineTo(((_local_62 * _arg_1.focalLength) / _local_64), ((_local_63 * _arg_1.focalLength) / _local_64));
                        _local_3.graphics.moveTo(((_local_29 * _arg_1.focalLength) / _local_31), ((_local_30 * _arg_1.focalLength) / _local_31));
                        _local_3.graphics.lineTo(((_local_41 * _arg_1.focalLength) / _local_43), ((_local_42 * _arg_1.focalLength) / _local_43));
                        _local_3.graphics.moveTo(((_local_32 * _arg_1.focalLength) / _local_34), ((_local_33 * _arg_1.focalLength) / _local_34));
                        _local_3.graphics.lineTo(((_local_44 * _arg_1.focalLength) / _local_46), ((_local_45 * _arg_1.focalLength) / _local_46));
                        _local_3.graphics.moveTo(((_local_35 * _arg_1.focalLength) / _local_37), ((_local_36 * _arg_1.focalLength) / _local_37));
                        _local_3.graphics.lineTo(((_local_47 * _arg_1.focalLength) / _local_49), ((_local_48 * _arg_1.focalLength) / _local_49));
                        _local_3.graphics.moveTo(((_local_38 * _arg_1.focalLength) / _local_40), ((_local_39 * _arg_1.focalLength) / _local_40));
                        _local_3.graphics.lineTo(((_local_50 * _arg_1.focalLength) / _local_52), ((_local_51 * _arg_1.focalLength) / _local_52));
                    };
                };
                if ((_local_2 & Debug.BOUNDS))
                {
                    Debug.drawBounds(_arg_1, this, boundMinX, boundMinY, boundMinZ, boundMaxX, boundMaxY, boundMaxZ, 0x99FF00);
                };
            };
        }


    }
}//package alternativa.engine3d.lights