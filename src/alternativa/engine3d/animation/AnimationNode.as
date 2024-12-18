package alternativa.engine3d.animation
{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class AnimationNode 
    {

        alternativa3d var _isActive:Boolean = false;
        alternativa3d var _parent:AnimationNode;
        alternativa3d var controller:AnimationController;
        public var speed:Number = 1;


        public function get isActive():Boolean
        {
            return ((this._isActive) && (!(this.controller == null)));
        }

        public function get parent():AnimationNode
        {
            return (this._parent);
        }

        alternativa3d function update(_arg_1:Number, _arg_2:Number):void
        {
        }

        alternativa3d function setController(_arg_1:AnimationController):void
        {
            this.controller = _arg_1;
        }

        alternativa3d function addNode(_arg_1:AnimationNode):void
        {
            if (_arg_1._parent != null)
            {
                _arg_1._parent.removeNode(_arg_1);
            };
            _arg_1._parent = this;
            _arg_1.setController(this.controller);
        }

        alternativa3d function removeNode(_arg_1:AnimationNode):void
        {
            _arg_1.setController(null);
            _arg_1._isActive = false;
            _arg_1._parent = null;
        }


    }
}//package alternativa.engine3d.animation