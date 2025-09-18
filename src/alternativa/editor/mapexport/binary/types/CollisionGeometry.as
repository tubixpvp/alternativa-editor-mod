package alternativa.editor.mapexport.binary.types
{
    import alternativa.protocol.ProtocolBuffer;
    import alternativa.protocol.LengthCodecHelper;

    public class CollisionGeometry
    {
        public var boxes:Vector.<CollisionBoxData>;

        public var planes:Vector.<CollisionPlaneData>;

        public var triangles:Vector.<CollisionTriangleData>;


        public function encode(buffer:ProtocolBuffer) : void
        {
            LengthCodecHelper.encodeLength(buffer, boxes.length);
            for each(var box:CollisionBoxData in boxes)
            {
                box.encode(buffer);
            }

            LengthCodecHelper.encodeLength(buffer, planes.length);
            for each(var plane:CollisionPlaneData in planes)
            {
                plane.encode(buffer);
            }

            LengthCodecHelper.encodeLength(buffer, triangles.length);
            for each(var triangle:CollisionTriangleData in triangles)
            {
                triangle.encode(buffer);
            }
        }

        public static function instantiate() : CollisionGeometry
        {
            var geom:CollisionGeometry = new CollisionGeometry();

            geom.boxes = new Vector.<CollisionBoxData>();
            geom.planes = new Vector.<CollisionPlaneData>();
            geom.triangles = new Vector.<CollisionTriangleData>();

            return geom;
        }

    }
}