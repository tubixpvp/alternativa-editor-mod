package alternativa.engine3d.materials
{
    import flash.utils.getQualifiedClassName;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Material 
    {

        public var name:String;
        public var alphaTestThreshold:Number = 0;
        public var zOffset:Boolean = false;
        public var uploadEveryFrame:Boolean = false;
        alternativa3d var drawId:uint = 0;
        alternativa3d var useVerticesNormals:Boolean = true;
        private var isTransparent:Boolean;


        alternativa3d function get transparent():Boolean
        {
            return (this.isTransparent);
        }

        alternativa3d function set transparent(_arg_1:Boolean):void
        {
            this.isTransparent = _arg_1;
        }

        public function clone():Material
        {
            var _local_1:Material = new Material();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        protected function clonePropertiesFrom(_arg_1:Material):void
        {
            this.name = _arg_1.name;
            this.alphaTestThreshold = _arg_1.alphaTestThreshold;
            this.useVerticesNormals = _arg_1.useVerticesNormals;
        }

        public function toString():String
        {
            var _local_1:String = getQualifiedClassName(this);
            return (((("[" + _local_1.substr((_local_1.indexOf("::") + 2))) + " ") + this.name) + "]");
        }

        alternativa3d function drawOpaque(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D):void
        {
        }

        alternativa3d function drawTransparent(_arg_1:Camera3D, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D, _arg_7:Boolean=false):void
        {
        }

        public function dispose():void
        {
        }


    }
}//package alternativa.engine3d.materials