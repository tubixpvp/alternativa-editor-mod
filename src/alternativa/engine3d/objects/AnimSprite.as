package alternativa.engine3d.objects
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimSprite extends Sprite3D 
    {

        private var _materials:Vector.<Material>;
        private var _frame:int = 0;
        private var _loop:Boolean = false;

        public function AnimSprite(_arg_1:Number, _arg_2:Number, _arg_3:Vector.<Material>=null, _arg_4:Boolean=false, _arg_5:int=0)
        {
            super(_arg_1, _arg_2);
            this._materials = _arg_3;
            this._loop = _arg_4;
            this.frame = _arg_5;
        }

        public function get materials():Vector.<Material>
        {
            return (this._materials);
        }

        public function set materials(_arg_1:Vector.<Material>):void
        {
            this._materials = _arg_1;
            if (_arg_1 != null)
            {
                this.frame = this._frame;
            } else
            {
                material = null;
            };
        }

        public function get loop():Boolean
        {
            return (this._loop);
        }

        public function set loop(_arg_1:Boolean):void
        {
            this._loop = _arg_1;
            this.frame = this._frame;
        }

        public function get frame():int
        {
            return (this._frame);
        }

        public function set frame(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            this._frame = _arg_1;
            if (this._materials != null)
            {
                _local_2 = this._materials.length;
                _local_3 = this._frame;
                if (this._frame < 0)
                {
                    _local_4 = (this._frame % _local_2);
                    _local_3 = (((this._loop) && (!(_local_4 == 0))) ? (_local_4 + _local_2) : 0);
                } else
                {
                    if (this._frame > (_local_2 - 1))
                    {
                        _local_3 = ((this._loop) ? (this._frame % _local_2) : (_local_2 - 1));
                    };
                };
                material = this._materials[_local_3];
            };
        }

        override public function clone():Object3D
        {
            var _local_1:AnimSprite = new AnimSprite(width, height);
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:AnimSprite = (_arg_1 as AnimSprite);
            this._materials = _local_2._materials;
            this._loop = _local_2._loop;
            this._frame = _local_2._frame;
        }


    }
}//package alternativa.engine3d.objects