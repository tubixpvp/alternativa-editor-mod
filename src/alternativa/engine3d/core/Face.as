package alternativa.engine3d.core
{
    import alternativa.engine3d.materials.Material;
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Face 
    {

        alternativa3d static var collector:Face;

        public var material:Material;
        public var smoothingGroups:uint = 0;
        alternativa3d var normalX:Number;
        alternativa3d var normalY:Number;
        alternativa3d var normalZ:Number;
        alternativa3d var offset:Number;
        alternativa3d var wrapper:Wrapper;
        alternativa3d var next:Face;
        alternativa3d var processNext:Face;
        alternativa3d var processNegative:Face;
        alternativa3d var processPositive:Face;
        alternativa3d var distance:Number;
        alternativa3d var geometry:VG;
        public var id:Object;


        alternativa3d static function create():Face
        {
            var _local_1:Face;
            if (collector != null)
            {
                _local_1 = collector;
                collector = _local_1.next;
                _local_1.next = null;
                return (_local_1);
            };
            return (new (Face)());
        }


        alternativa3d function create():Face
        {
            var _local_1:Face;
            if (collector != null)
            {
                _local_1 = collector;
                collector = _local_1.next;
                _local_1.next = null;
                return (_local_1);
            };
            return (new Face());
        }

        public function get normal():Vector3D
        {
            var _local_1:Wrapper = this.wrapper;
            var _local_2:Vertex = _local_1.vertex;
            _local_1 = _local_1.next;
            var _local_3:Vertex = _local_1.vertex;
            _local_1 = _local_1.next;
            var _local_4:Vertex = _local_1.vertex;
            var _local_5:Number = (_local_3.x - _local_2.x);
            var _local_6:Number = (_local_3.y - _local_2.y);
            var _local_7:Number = (_local_3.z - _local_2.z);
            var _local_8:Number = (_local_4.x - _local_2.x);
            var _local_9:Number = (_local_4.y - _local_2.y);
            var _local_10:Number = (_local_4.z - _local_2.z);
            var _local_11:Number = ((_local_10 * _local_6) - (_local_9 * _local_7));
            var _local_12:Number = ((_local_8 * _local_7) - (_local_10 * _local_5));
            var _local_13:Number = ((_local_9 * _local_5) - (_local_8 * _local_6));
            var _local_14:Number = (((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_13 * _local_13));
            if (_local_14 > 0.001)
            {
                _local_14 = (1 / Math.sqrt(_local_14));
                _local_11 = (_local_11 * _local_14);
                _local_12 = (_local_12 * _local_14);
                _local_13 = (_local_13 * _local_14);
            };
            return (new Vector3D(_local_11, _local_12, _local_13, (((_local_2.x * _local_11) + (_local_2.y * _local_12)) + (_local_2.z * _local_13))));
        }

        public function get vertices():Vector.<Vertex>
        {
            var _local_1:Vector.<Vertex> = new Vector.<Vertex>();
            var _local_2:int;
            var _local_3:Wrapper = this.wrapper;
            while (_local_3 != null)
            {
                _local_1[_local_2] = _local_3.vertex;
                _local_2++;
                _local_3 = _local_3.next;
            };
            return (_local_1);
        }

        public function getUV(_arg_1:Vector3D):Point
        {
            var _local_2:Vertex = this.wrapper.vertex;
            var _local_3:Vertex = this.wrapper.next.vertex;
            var _local_4:Vertex = this.wrapper.next.next.vertex;
            var _local_5:Number = (_local_3.x - _local_2.x);
            var _local_6:Number = (_local_3.y - _local_2.y);
            var _local_7:Number = (_local_3.z - _local_2.z);
            var _local_8:Number = (_local_3.u - _local_2.u);
            var _local_9:Number = (_local_3.v - _local_2.v);
            var _local_10:Number = (_local_4.x - _local_2.x);
            var _local_11:Number = (_local_4.y - _local_2.y);
            var _local_12:Number = (_local_4.z - _local_2.z);
            var _local_13:Number = (_local_4.u - _local_2.u);
            var _local_14:Number = (_local_4.v - _local_2.v);
            var _local_15:Number = (((((((-(this.normalX) * _local_11) * _local_7) + ((_local_10 * this.normalY) * _local_7)) + ((this.normalX * _local_6) * _local_12)) - ((_local_5 * this.normalY) * _local_12)) - ((_local_10 * _local_6) * this.normalZ)) + ((_local_5 * _local_11) * this.normalZ));
            var _local_16:Number = (((-(this.normalY) * _local_12) + (_local_11 * this.normalZ)) / _local_15);
            var _local_17:Number = (((this.normalX * _local_12) - (_local_10 * this.normalZ)) / _local_15);
            var _local_18:Number = (((-(this.normalX) * _local_11) + (_local_10 * this.normalY)) / _local_15);
            var _local_19:Number = ((((((((_local_2.x * this.normalY) * _local_12) - ((this.normalX * _local_2.y) * _local_12)) - ((_local_2.x * _local_11) * this.normalZ)) + ((_local_10 * _local_2.y) * this.normalZ)) + ((this.normalX * _local_11) * _local_2.z)) - ((_local_10 * this.normalY) * _local_2.z)) / _local_15);
            var _local_20:Number = (((this.normalY * _local_7) - (_local_6 * this.normalZ)) / _local_15);
            var _local_21:Number = (((-(this.normalX) * _local_7) + (_local_5 * this.normalZ)) / _local_15);
            var _local_22:Number = (((this.normalX * _local_6) - (_local_5 * this.normalY)) / _local_15);
            var _local_23:Number = ((((((((this.normalX * _local_2.y) * _local_7) - ((_local_2.x * this.normalY) * _local_7)) + ((_local_2.x * _local_6) * this.normalZ)) - ((_local_5 * _local_2.y) * this.normalZ)) - ((this.normalX * _local_6) * _local_2.z)) + ((_local_5 * this.normalY) * _local_2.z)) / _local_15);
            var _local_24:Number = ((_local_8 * _local_16) + (_local_13 * _local_20));
            var _local_25:Number = ((_local_8 * _local_17) + (_local_13 * _local_21));
            var _local_26:Number = ((_local_8 * _local_18) + (_local_13 * _local_22));
            var _local_27:Number = (((_local_8 * _local_19) + (_local_13 * _local_23)) + _local_2.u);
            var _local_28:Number = ((_local_9 * _local_16) + (_local_14 * _local_20));
            var _local_29:Number = ((_local_9 * _local_17) + (_local_14 * _local_21));
            var _local_30:Number = ((_local_9 * _local_18) + (_local_14 * _local_22));
            var _local_31:Number = (((_local_9 * _local_19) + (_local_14 * _local_23)) + _local_2.v);
            return (new Point(((((_local_24 * _arg_1.x) + (_local_25 * _arg_1.y)) + (_local_26 * _arg_1.z)) + _local_27), ((((_local_28 * _arg_1.x) + (_local_29 * _arg_1.y)) + (_local_30 * _arg_1.z)) + _local_31)));
        }

        public function toString():String
        {
            return (("[Face " + this.id) + "]");
        }

        alternativa3d function calculateBestSequenceAndNormal():void
        {
            var _local_1:Wrapper;
            var _local_2:Vertex;
            var _local_3:Vertex;
            var _local_4:Vertex;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Wrapper;
            var _local_17:Wrapper;
            var _local_18:Wrapper;
            var _local_19:Wrapper;
            var _local_20:Wrapper;
            if (this.wrapper.next.next.next != null)
            {
                _local_15 = -1E22;
                _local_1 = this.wrapper;
                while (_local_1 != null)
                {
                    _local_19 = ((_local_1.next != null) ? _local_1.next : this.wrapper);
                    _local_20 = ((_local_19.next != null) ? _local_19.next : this.wrapper);
                    _local_2 = _local_1.vertex;
                    _local_3 = _local_19.vertex;
                    _local_4 = _local_20.vertex;
                    _local_5 = (_local_3.x - _local_2.x);
                    _local_6 = (_local_3.y - _local_2.y);
                    _local_7 = (_local_3.z - _local_2.z);
                    _local_8 = (_local_4.x - _local_2.x);
                    _local_9 = (_local_4.y - _local_2.y);
                    _local_10 = (_local_4.z - _local_2.z);
                    _local_11 = ((_local_10 * _local_6) - (_local_9 * _local_7));
                    _local_12 = ((_local_8 * _local_7) - (_local_10 * _local_5));
                    _local_13 = ((_local_9 * _local_5) - (_local_8 * _local_6));
                    _local_14 = (((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_13 * _local_13));
                    if (_local_14 > _local_15)
                    {
                        _local_15 = _local_14;
                        _local_16 = _local_1;
                    };
                    _local_1 = _local_1.next;
                };
                if (_local_16 != this.wrapper)
                {
                    _local_17 = this.wrapper.next.next.next;
                    while (_local_17.next != null)
                    {
                        _local_17 = _local_17.next;
                    };
                    _local_18 = this.wrapper;
                    while (((!(_local_18.next == _local_16)) && (!(_local_18.next == null))))
                    {
                        _local_18 = _local_18.next;
                    };
                    _local_17.next = this.wrapper;
                    _local_18.next = null;
                    this.wrapper = _local_16;
                };
            };
            _local_1 = this.wrapper;
            _local_2 = _local_1.vertex;
            _local_1 = _local_1.next;
            _local_3 = _local_1.vertex;
            _local_1 = _local_1.next;
            _local_4 = _local_1.vertex;
            _local_5 = (_local_3.x - _local_2.x);
            _local_6 = (_local_3.y - _local_2.y);
            _local_7 = (_local_3.z - _local_2.z);
            _local_8 = (_local_4.x - _local_2.x);
            _local_9 = (_local_4.y - _local_2.y);
            _local_10 = (_local_4.z - _local_2.z);
            _local_11 = ((_local_10 * _local_6) - (_local_9 * _local_7));
            _local_12 = ((_local_8 * _local_7) - (_local_10 * _local_5));
            _local_13 = ((_local_9 * _local_5) - (_local_8 * _local_6));
            _local_14 = (((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_13 * _local_13));
            if (_local_14 > 0)
            {
                _local_14 = (1 / Math.sqrt(_local_14));
                _local_11 = (_local_11 * _local_14);
                _local_12 = (_local_12 * _local_14);
                _local_13 = (_local_13 * _local_14);
                this.normalX = _local_11;
                this.normalY = _local_12;
                this.normalZ = _local_13;
            };
            this.offset = (((_local_2.x * _local_11) + (_local_2.y * _local_12)) + (_local_2.z * _local_13));
        }
		
		 
	  public function destroy() : void
      {
         this.material = null;
         if(this.wrapper != null)
         {
            this.wrapper.destroy();
            this.wrapper = null;
         }
         if(this.geometry != null)
         {
            this.geometry.destroy();
            this.geometry = null;
         }
   }


    }
}//package alternativa.engine3d.core