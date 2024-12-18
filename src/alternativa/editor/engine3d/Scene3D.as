package alternativa.editor.engine3d
{
    import alternativa.engine3d.core.Object3DContainer;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.alternativa3d;
    import alternativa.editor.prop.Prop;

    use namespace alternativa3d;

    public class Scene3D
    {
        public var camera:Camera3D;

        private var _root:Object3DContainer;


        public function get root() : Object3DContainer
        {
            return _root;
        }
        public function set root(container:Object3DContainer) : void
        {
            _root = container;
        }


        public function calculate() : void
        {
            var child:Object3D = _root.childrenList;
            while(child != null)
            {
                if(child is Prop)
                {
                    (child as Prop).calculate();
                }

                child = child.next;
            }

            this.camera.render();
        }
    }
}