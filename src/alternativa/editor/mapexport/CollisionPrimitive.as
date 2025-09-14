package alternativa.editor.mapexport
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.types.Matrix4;
   import alternativa.editor.mapexport.binary.types.BattleMap;
   import alternativa.types.Point3D;
   
   public class CollisionPrimitive
   {
      private static const tmpMatrix:Matrix4 = new Matrix4();
      protected static const tmpRotation:Point3D = new Point3D();

      public static const PRECISION:int = 3;
      
      public static const ROT_PRECISION:int = 6;
      
      public var id:int;
      
      public var transform:Matrix4;
      
      public function CollisionPrimitive(param1:int, param2:Mesh = null)
      {
         this.transform = new Matrix4();
         super();
         this.id = param1;
         if(param2 != null)
         {
            this.parse(param2);
         }
      }
      
      public function parse(param1:Mesh) : void
      {
      }
      
      public function getXml(param1:Matrix4) : XML
      {
         return new XML();
      }
      
      public function getXml2() : XML
      {
         return new XML();
      }

      public function addToBinaryData(mapOutput:BattleMap, propTransform:Matrix4) : void
      {
      }
      
      protected function getVector3DXML(param1:XML, param2:Number, param3:Number, param4:Number, param5:int) : XML
      {
         param1.@x = param2.toFixed(param5);
         param1.@y = param3.toFixed(param5);
         param1.@z = param4.toFixed(param5);
         return param1;
      }
      
      protected function getPrimitiveTransformation(propMatrix:Matrix4) : Matrix4
      {
         var matrix:Matrix4 = null;
         if(propMatrix == null)
         {
            matrix = transform;
         }
         else
         {
            matrix = tmpMatrix;
            matrix.copy(transform);
            matrix.combine(propMatrix);
         }
         return matrix;
      }
   }
}

