package alternativa.engine3d.core
{
    import flash.display.Sprite;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa.engine3d.alternativa3d;

    public class Debug 
    {

        public static const BOUNDS:int = 8;
        public static const EDGES:int = 16;
        public static const NODES:int = 128;
        public static const LIGHTS:int = 0x0100;
        public static const BONES:int = 0x0200;
        private static const boundVertexList:Vertex = Vertex.createList(8);
        private static const nodeVertexList:Vertex = Vertex.createList(4);


        alternativa3d static function drawEdges(_arg_1:Camera3D, _arg_2:Face, _arg_3:int):void
        {
            var _local_6:Number;
            var _local_9:Wrapper;
            var _local_10:Vertex;
            var _local_11:Number;
            var _local_12:Number;
            var _local_4:Number = _arg_1.viewSizeX;
            var _local_5:Number = _arg_1.viewSizeY;
            var _local_7:Sprite = _arg_1.view.canvas;
            _local_7.graphics.lineStyle(0, _arg_3);
            var _local_8:Face = _arg_2;
            while (_local_8 != null)
            {
                _local_9 = _local_8.wrapper;
                _local_10 = _local_9.vertex;
                _local_6 = (1 / _local_10.cameraZ);
                _local_11 = ((_local_10.cameraX * _local_4) * _local_6);
                _local_12 = ((_local_10.cameraY * _local_5) * _local_6);
                _local_7.graphics.moveTo(_local_11, _local_12);
                _local_9 = _local_9.next;
                while (_local_9 != null)
                {
                    _local_10 = _local_9.vertex;
                    _local_6 = (1 / _local_10.cameraZ);
                    _local_7.graphics.lineTo(((_local_10.cameraX * _local_4) * _local_6), ((_local_10.cameraY * _local_5) * _local_6));
                    _local_9 = _local_9.next;
                };
                _local_7.graphics.lineTo(_local_11, _local_12);
                _local_8 = _local_8.processNext;
            };
        }

        alternativa3d static function drawBounds(_arg_1:Camera3D, _arg_2:Object3D, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:int=-1, _arg_10:Number=1):void
        {
            var _local_11:Vertex;
            var _local_23:Number;
            var _local_12:Vertex = boundVertexList;
            _local_12.x = _arg_3;
            _local_12.y = _arg_4;
            _local_12.z = _arg_5;
            var _local_13:Vertex = _local_12.next;
            _local_13.x = _arg_6;
            _local_13.y = _arg_4;
            _local_13.z = _arg_5;
            var _local_14:Vertex = _local_13.next;
            _local_14.x = _arg_3;
            _local_14.y = _arg_7;
            _local_14.z = _arg_5;
            var _local_15:Vertex = _local_14.next;
            _local_15.x = _arg_6;
            _local_15.y = _arg_7;
            _local_15.z = _arg_5;
            var _local_16:Vertex = _local_15.next;
            _local_16.x = _arg_3;
            _local_16.y = _arg_4;
            _local_16.z = _arg_8;
            var _local_17:Vertex = _local_16.next;
            _local_17.x = _arg_6;
            _local_17.y = _arg_4;
            _local_17.z = _arg_8;
            var _local_18:Vertex = _local_17.next;
            _local_18.x = _arg_3;
            _local_18.y = _arg_7;
            _local_18.z = _arg_8;
            var _local_19:Vertex = _local_18.next;
            _local_19.x = _arg_6;
            _local_19.y = _arg_7;
            _local_19.z = _arg_8;
            _local_11 = _local_12;
            while (_local_11 != null)
            {
                _local_11.cameraX = ((((_arg_2.ma * _local_11.x) + (_arg_2.mb * _local_11.y)) + (_arg_2.mc * _local_11.z)) + _arg_2.md);
                _local_11.cameraY = ((((_arg_2.me * _local_11.x) + (_arg_2.mf * _local_11.y)) + (_arg_2.mg * _local_11.z)) + _arg_2.mh);
                _local_11.cameraZ = ((((_arg_2.mi * _local_11.x) + (_arg_2.mj * _local_11.y)) + (_arg_2.mk * _local_11.z)) + _arg_2.ml);
                if (_local_11.cameraZ <= 0)
                {
                    return;
                };
                _local_11 = _local_11.next;
            };
            var _local_20:Number = _arg_1.viewSizeX;
            var _local_21:Number = _arg_1.viewSizeY;
            _local_11 = _local_12;
            while (_local_11 != null)
            {
                _local_23 = (1 / _local_11.cameraZ);
                _local_11.cameraX = ((_local_11.cameraX * _local_20) * _local_23);
                _local_11.cameraY = ((_local_11.cameraY * _local_21) * _local_23);
                _local_11 = _local_11.next;
            };
            var _local_22:Sprite = _arg_1.view.canvas;
            _local_22.graphics.lineStyle(0, ((_arg_9 < 0) ? ((_arg_2.culling > 0) ? 0xFFFF00 : 0xFF00) : _arg_9), _arg_10);
            _local_22.graphics.moveTo(_local_12.cameraX, _local_12.cameraY);
            _local_22.graphics.lineTo(_local_13.cameraX, _local_13.cameraY);
            _local_22.graphics.lineTo(_local_15.cameraX, _local_15.cameraY);
            _local_22.graphics.lineTo(_local_14.cameraX, _local_14.cameraY);
            _local_22.graphics.lineTo(_local_12.cameraX, _local_12.cameraY);
            _local_22.graphics.moveTo(_local_16.cameraX, _local_16.cameraY);
            _local_22.graphics.lineTo(_local_17.cameraX, _local_17.cameraY);
            _local_22.graphics.lineTo(_local_19.cameraX, _local_19.cameraY);
            _local_22.graphics.lineTo(_local_18.cameraX, _local_18.cameraY);
            _local_22.graphics.lineTo(_local_16.cameraX, _local_16.cameraY);
            _local_22.graphics.moveTo(_local_12.cameraX, _local_12.cameraY);
            _local_22.graphics.lineTo(_local_16.cameraX, _local_16.cameraY);
            _local_22.graphics.moveTo(_local_13.cameraX, _local_13.cameraY);
            _local_22.graphics.lineTo(_local_17.cameraX, _local_17.cameraY);
            _local_22.graphics.moveTo(_local_15.cameraX, _local_15.cameraY);
            _local_22.graphics.lineTo(_local_19.cameraX, _local_19.cameraY);
            _local_22.graphics.moveTo(_local_14.cameraX, _local_14.cameraY);
            _local_22.graphics.lineTo(_local_18.cameraX, _local_18.cameraY);
        }

        alternativa3d static function drawKDNode(_arg_1:Camera3D, _arg_2:Object3D, _arg_3:int, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number):void
        {
            var _local_12:Vertex;
            var _local_20:Number;
            var _local_13:Vertex = nodeVertexList;
            var _local_14:Vertex = _local_13.next;
            var _local_15:Vertex = _local_14.next;
            var _local_16:Vertex = _local_15.next;
            if (_arg_3 == 0)
            {
                _local_13.x = _arg_4;
                _local_13.y = _arg_6;
                _local_13.z = _arg_10;
                _local_14.x = _arg_4;
                _local_14.y = _arg_9;
                _local_14.z = _arg_10;
                _local_15.x = _arg_4;
                _local_15.y = _arg_9;
                _local_15.z = _arg_7;
                _local_16.x = _arg_4;
                _local_16.y = _arg_6;
                _local_16.z = _arg_7;
            } else
            {
                if (_arg_3 == 1)
                {
                    _local_13.x = _arg_8;
                    _local_13.y = _arg_4;
                    _local_13.z = _arg_10;
                    _local_14.x = _arg_5;
                    _local_14.y = _arg_4;
                    _local_14.z = _arg_10;
                    _local_15.x = _arg_5;
                    _local_15.y = _arg_4;
                    _local_15.z = _arg_7;
                    _local_16.x = _arg_8;
                    _local_16.y = _arg_4;
                    _local_16.z = _arg_7;
                } else
                {
                    _local_13.x = _arg_5;
                    _local_13.y = _arg_6;
                    _local_13.z = _arg_4;
                    _local_14.x = _arg_8;
                    _local_14.y = _arg_6;
                    _local_14.z = _arg_4;
                    _local_15.x = _arg_8;
                    _local_15.y = _arg_9;
                    _local_15.z = _arg_4;
                    _local_16.x = _arg_5;
                    _local_16.y = _arg_9;
                    _local_16.z = _arg_4;
                };
            };
            _local_12 = _local_13;
            while (_local_12 != null)
            {
                _local_12.cameraX = ((((_arg_2.ma * _local_12.x) + (_arg_2.mb * _local_12.y)) + (_arg_2.mc * _local_12.z)) + _arg_2.md);
                _local_12.cameraY = ((((_arg_2.me * _local_12.x) + (_arg_2.mf * _local_12.y)) + (_arg_2.mg * _local_12.z)) + _arg_2.mh);
                _local_12.cameraZ = ((((_arg_2.mi * _local_12.x) + (_arg_2.mj * _local_12.y)) + (_arg_2.mk * _local_12.z)) + _arg_2.ml);
                if (_local_12.cameraZ <= 0)
                {
                    return;
                };
                _local_12 = _local_12.next;
            };
            var _local_17:Number = _arg_1.viewSizeX;
            var _local_18:Number = _arg_1.viewSizeY;
            _local_12 = _local_13;
            while (_local_12 != null)
            {
                _local_20 = (1 / _local_12.cameraZ);
                _local_12.cameraX = ((_local_12.cameraX * _local_17) * _local_20);
                _local_12.cameraY = ((_local_12.cameraY * _local_18) * _local_20);
                _local_12 = _local_12.next;
            };
            var _local_19:Sprite = _arg_1.view.canvas;
            _local_19.graphics.lineStyle(0, ((_arg_3 == 0) ? 0xFF0000 : ((_arg_3 == 1) ? 0xFF00 : 0xFF)), _arg_11);
            _local_19.graphics.moveTo(_local_13.cameraX, _local_13.cameraY);
            _local_19.graphics.lineTo(_local_14.cameraX, _local_14.cameraY);
            _local_19.graphics.lineTo(_local_15.cameraX, _local_15.cameraY);
            _local_19.graphics.lineTo(_local_16.cameraX, _local_16.cameraY);
            _local_19.graphics.lineTo(_local_13.cameraX, _local_13.cameraY);
        }

        alternativa3d static function drawBone(_arg_1:Camera3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:int):void
        {
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Sprite;
            var _local_8:Number = (_arg_4 - _arg_2);
            var _local_9:Number = (_arg_5 - _arg_3);
            var _local_10:Number = Math.sqrt(((_local_8 * _local_8) + (_local_9 * _local_9)));
            if (_local_10 > 0.001)
            {
                _local_8 = (_local_8 / _local_10);
                _local_9 = (_local_9 / _local_10);
                _local_11 = (_local_9 * _arg_6);
                _local_12 = (-(_local_8) * _arg_6);
                _local_13 = (-(_local_9) * _arg_6);
                _local_14 = (_local_8 * _arg_6);
                if (_local_10 > (_arg_6 * 2))
                {
                    _local_10 = _arg_6;
                } else
                {
                    _local_10 = (_local_10 / 2);
                };
                _local_15 = _arg_1.view.canvas;
                _local_15.graphics.lineStyle(1, _arg_7);
                _local_15.graphics.beginFill(_arg_7, 0.6);
                _local_15.graphics.moveTo(_arg_2, _arg_3);
                _local_15.graphics.lineTo(((_arg_2 + (_local_8 * _local_10)) + _local_11), ((_arg_3 + (_local_9 * _local_10)) + _local_12));
                _local_15.graphics.lineTo(_arg_4, _arg_5);
                _local_15.graphics.lineTo(((_arg_2 + (_local_8 * _local_10)) + _local_13), ((_arg_3 + (_local_9 * _local_10)) + _local_14));
                _local_15.graphics.lineTo(_arg_2, _arg_3);
                _local_15.graphics.endFill();
            };
        }


    }
}//package alternativa.engine3d.core