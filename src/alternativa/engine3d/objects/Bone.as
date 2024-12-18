package alternativa.engine3d.objects
{
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Debug;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Bone extends Joint 
    {

        public var length:Number;
        alternativa3d var lx:Number;
        alternativa3d var ly:Number;
        alternativa3d var lz:Number;
        alternativa3d var ldot:Number;

        public function Bone(_arg_1:Number, _arg_2:Number)
        {
            this.length = _arg_1;
            this.distance = _arg_2;
        }

        public function bindVerticesByDistance(_arg_1:Skin):void
        {
            var _local_2:Vertex = _arg_1.vertexList;
            while (_local_2 != null)
            {
                this.bindVertexByDistance(_local_2);
                _local_2 = _local_2.next;
            };
        }

        public function bindVertexByDistance(_arg_1:Vertex):void
        {
            var _local_2:Number = (_arg_1.x - md);
            var _local_3:Number = (_arg_1.y - mh);
            var _local_4:Number = (_arg_1.z - ml);
            var _local_5:Number = (((_local_2 * this.lx) + (_local_3 * this.ly)) + (_local_4 * this.lz));
            if (_local_5 > 0)
            {
                if (this.ldot > _local_5)
                {
                    _local_5 = (_local_5 / this.ldot);
                    _local_2 = ((_arg_1.x - md) - (_local_5 * this.lx));
                    _local_3 = ((_arg_1.y - mh) - (_local_5 * this.ly));
                    _local_4 = ((_arg_1.z - ml) - (_local_5 * this.lz));
                } else
                {
                    _local_2 = (_local_2 - this.lx);
                    _local_3 = (_local_3 - this.ly);
                    _local_4 = (_local_4 - this.lz);
                };
            };
            bindVertex(_arg_1, (1 - (Math.sqrt((((_local_2 * _local_2) + (_local_3 * _local_3)) + (_local_4 * _local_4))) / distance)));
        }

        override alternativa3d function calculateBindingMatrix(_arg_1:Object3D):void
        {
            super.calculateBindingMatrix(_arg_1);
            this.lx = (mc * this.length);
            this.ly = (mg * this.length);
            this.lz = (mk * this.length);
            this.ldot = (((this.lx * this.lx) + (this.ly * this.ly)) + (this.lz * this.lz));
        }

        override alternativa3d function drawDebug(_arg_1:Camera3D):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            if (numChildren == 0)
            {
                _local_2 = ((md * _arg_1.viewSizeX) / ml);
                _local_3 = ((mh * _arg_1.viewSizeY) / ml);
                _local_4 = ((mi * this.length) + ml);
                _local_5 = ((((ma * this.length) + md) * _arg_1.viewSizeX) / _local_4);
                _local_6 = ((((me * this.length) + mh) * _arg_1.viewSizeY) / _local_4);
                if (((ml > 0) && (_local_4 > 0)))
                {
                    Debug.drawBone(_arg_1, _local_2, _local_3, _local_5, _local_6, ((10 * _arg_1.focalLength) / ml), 39423);
                };
            } else
            {
                super.drawDebug(_arg_1);
            };
        }


    }
}//package alternativa.engine3d.objects