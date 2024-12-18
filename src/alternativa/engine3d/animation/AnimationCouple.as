package alternativa.engine3d.animation
{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationCouple extends AnimationNode 
    {

        private var _left:AnimationNode;
        private var _right:AnimationNode;
        public var balance:Number = 0.5;


        override alternativa3d function update(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:Number = ((this.balance <= 0) ? 0 : ((this.balance >= 1) ? 1 : this.balance));
            if (this._left == null)
            {
                this._right.update((_arg_1 * speed), _arg_2);
            } else
            {
                if (this._right == null)
                {
                    this._left.update((_arg_1 * speed), _arg_2);
                } else
                {
                    this._left.update((_arg_1 * speed), ((1 - _local_3) * _arg_2));
                    this._right.update((_arg_1 * speed), (_local_3 * _arg_2));
                };
            };
        }

        override alternativa3d function setController(_arg_1:AnimationController):void
        {
            this.controller = _arg_1;
            if (this._left != null)
            {
                this._left.setController(_arg_1);
            };
            if (this._right != null)
            {
                this._right.setController(_arg_1);
            };
        }

        override alternativa3d function addNode(_arg_1:AnimationNode):void
        {
            super.addNode(_arg_1);
            _arg_1._isActive = true;
        }

        override alternativa3d function removeNode(_arg_1:AnimationNode):void
        {
            if (this._left == _arg_1)
            {
                this._left = null;
            } else
            {
                this._right = null;
            };
            super.removeNode(_arg_1);
        }

        public function get left():AnimationNode
        {
            return (this._left);
        }

        public function set left(_arg_1:AnimationNode):void
        {
            if (_arg_1 != this._left)
            {
                if (_arg_1._parent == this)
                {
                    throw (new Error("Animation already exist in  blender"));
                };
                if (this._left != null)
                {
                    this.removeNode(this._left);
                };
                this._left = _arg_1;
                if (_arg_1 != null)
                {
                    this.addNode(_arg_1);
                };
            };
        }

        public function get right():AnimationNode
        {
            return (this._right);
        }

        public function set right(_arg_1:AnimationNode):void
        {
            if (_arg_1 != this._right)
            {
                if (_arg_1._parent == this)
                {
                    throw (new Error("Animation already exist in blender"));
                };
                if (this._right != null)
                {
                    this.removeNode(this._right);
                };
                this._right = _arg_1;
                if (_arg_1 != null)
                {
                    this.addNode(_arg_1);
                };
            };
        }


    }
}//package alternativa.engine3d.animation