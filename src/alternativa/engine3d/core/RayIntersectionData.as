package alternativa.engine3d.core
{
    import flash.geom.Vector3D;
    import flash.geom.Point;

    public class RayIntersectionData 
    {

        public var object:Object3D;
        public var face:Face;
        public var point:Vector3D;
        public var uv:Point;
        public var time:Number;


        public function toString():String
        {
            return (((((((((("[RayIntersectionData " + this.object) + ", ") + this.face) + ", ") + this.point) + ", ") + this.uv) + ", ") + this.time) + "]");
        }


    }
}//package alternativa.engine3d.core