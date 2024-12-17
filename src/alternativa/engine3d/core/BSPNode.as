package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   
   use namespace alternativa3d;
   
   public final class BSPNode
   {
      private static var collector:Array = new Array();
      
      alternativa3d var splitter:Splitter;
      
      alternativa3d var frontSector:Sector;
      
      alternativa3d var backSector:Sector;
      
      alternativa3d var isSprite:Boolean;
      
      alternativa3d var parent:BSPNode;
      
      alternativa3d var front:BSPNode;
      
      alternativa3d var back:BSPNode;
      
      alternativa3d var normal:Point3D;
      
      alternativa3d var offset:Number;
      
      alternativa3d var mobility:int = 2147483647;
      
      alternativa3d var primitive:PolyPrimitive;
      
      alternativa3d var backPrimitives:Set;
      
      alternativa3d var frontPrimitives:Set;
      
      public function BSPNode()
      {
         this.alternativa3d::normal = new Point3D();
         super();
      }
      
      alternativa3d static function create(param1:PolyPrimitive) : BSPNode
      {
         var loc2:BSPNode = null;
         var loc3:SplitterPrimitive = null;
         loc2 = collector.pop();
         if(loc2 == null)
         {
            loc2 = new BSPNode();
         }
         loc2.alternativa3d::primitive = param1;
         param1.alternativa3d::node = loc2;
         if(param1.alternativa3d::face == null)
         {
            loc3 = param1 as SplitterPrimitive;
            if(loc3 == null)
            {
               loc2.alternativa3d::normal.x = 0;
               loc2.alternativa3d::normal.y = 0;
               loc2.alternativa3d::normal.z = 0;
               loc2.alternativa3d::offset = 0;
               loc2.alternativa3d::isSprite = true;
            }
            else
            {
               loc2.alternativa3d::splitter = loc3.alternativa3d::splitter;
               loc2.alternativa3d::normal.copy(loc3.alternativa3d::splitter.alternativa3d::normal);
               loc2.alternativa3d::offset = loc3.alternativa3d::splitter.alternativa3d::offset;
               loc2.alternativa3d::isSprite = false;
            }
         }
         else
         {
            loc2.alternativa3d::normal.copy(param1.alternativa3d::face.alternativa3d::globalNormal);
            loc2.alternativa3d::offset = param1.alternativa3d::face.alternativa3d::globalOffset;
            loc2.alternativa3d::isSprite = false;
         }
         loc2.alternativa3d::mobility = param1.mobility;
         return loc2;
      }
      
      alternativa3d static function destroy(param1:BSPNode) : void
      {
         collector.push(param1);
      }
   }
}

