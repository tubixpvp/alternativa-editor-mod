package alternativa.engine3d.animation
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationSwitcher extends AnimationNode 
    {

        private var _numAnimations:int = 0;
        private var _animations:Vector.<AnimationNode> = new Vector.<AnimationNode>();
        private var _weights:Vector.<Number> = new Vector.<Number>();
        private var _active:AnimationNode;
        private var fadingSpeed:Number = 0;


        override alternativa3d function update(_arg_1:Number, _arg_2:Number):void
        {
            var _local_6:AnimationNode;
            var _local_7:Number;
            var _local_3:Number = (speed * _arg_1);
            var _local_4:Number = (this.fadingSpeed * _local_3);
            var _local_5:int;
            while (_local_5 < this._numAnimations)
            {
                _local_6 = this._animations[_local_5];
                _local_7 = this._weights[_local_5];
                if (_local_6 == this._active)
                {
                    _local_7 = (_local_7 + _local_4);
                    _local_7 = ((_local_7 >= 1) ? 1 : _local_7);
                    _local_6.update(_local_3, (_arg_2 * _local_7));
                    this._weights[_local_5] = _local_7;
                } else
                {
                    _local_7 = (_local_7 - _local_4);
                    if (_local_7 > 0)
                    {
                        _local_6.update(_local_3, (_arg_2 * _local_7));
                        this._weights[_local_5] = _local_7;
                    } else
                    {
                        _local_6._isActive = false;
                        this._weights[_local_5] = 0;
                    };
                };
                _local_5++;
            };
        }

        public function get active():AnimationNode
        {
            return (this._active);
        }

        public function activate(_arg_1:AnimationNode, _arg_2:Number=0):void
        {
            var _local_3:int;
            if (_arg_1._parent != this)
            {
                throw (new Error("Animation is not child of this blender"));
            };
            this._active = _arg_1;
            _arg_1._isActive = true;
            if (_arg_2 <= 0)
            {
                _local_3 = 0;
                while (_local_3 < this._numAnimations)
                {
                    if (this._animations[_local_3] == _arg_1)
                    {
                        this._weights[_local_3] = 1;
                    } else
                    {
                        this._weights[_local_3] = 0;
                        this._animations[_local_3]._isActive = false;
                    };
                    _local_3++;
                };
                this.fadingSpeed = 0;
            } else
            {
                this.fadingSpeed = (1 / _arg_2);
            };
        }

        override alternativa3d function setController(_arg_1:AnimationController):void
        {
            var _local_3:AnimationNode;
            this.controller = _arg_1;
            var _local_2:int;
            while (_local_2 < this._numAnimations)
            {
                _local_3 = this._animations[_local_2];
                _local_3.setController(controller);
                _local_2++;
            };
        }

        override alternativa3d function removeNode(_arg_1:AnimationNode):void
        {
            this.removeAnimation(_arg_1);
        }

        public function addAnimation(_arg_1:AnimationNode):AnimationNode
        {
            if (_arg_1 == null)
            {
                throw (new Error("Animation cannot be null"));
            };
            if (_arg_1._parent == this)
            {
                throw (new Error("Animation already exist in blender"));
            };
            this._animations[this._numAnimations] = _arg_1;
            if (this._numAnimations == 0)
            {
                this._active = _arg_1;
                _arg_1._isActive = true;
                this._weights[this._numAnimations] = 1;
            } else
            {
                this._weights[this._numAnimations] = 0;
            };
            this._numAnimations++;
            addNode(_arg_1);
            return (_arg_1);
        }

        public function removeAnimation(_arg_1:AnimationNode):AnimationNode
        {
            var _local_2:int = this._animations.indexOf(_arg_1);
            if (_local_2 < 0)
            {
                throw (new ArgumentError("Animation not found"));
            };
            this._numAnimations--;
            var _local_3:int = (_local_2 + 1);
            while (_local_2 < this._numAnimations)
            {
                this._animations[_local_2] = this._animations[_local_3];
                _local_2++;
                _local_3++;
            };
            this._animations.length = this._numAnimations;
            this._weights.length = this._numAnimations;
            if (this._active == _arg_1)
            {
                if (this._numAnimations > 0)
                {
                    this._active = this._animations[int((this._numAnimations - 1))];
                    this._weights[int((this._numAnimations - 1))] = 1;
                } else
                {
                    this._active = null;
                };
            };
            super.removeNode(_arg_1);
            return (_arg_1);
        }

        public function getAnimationAt(_arg_1:int):AnimationNode
        {
            return (this._animations[_arg_1]);
        }

        public function numAnimations():int
        {
            return (this._numAnimations);
        }


    }
}//package alternativa.engine3d.animation