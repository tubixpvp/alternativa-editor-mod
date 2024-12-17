package alternativa.engine3d.physics
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.BSPNode;
   
   use namespace alternativa3d;
   
   public class CollisionPlane
   {
      private static var collector:Array = new Array();
      
      public var node:BSPNode;
      
      public var infront:Boolean;
      
      public var sourceOffset:Number;
      
      public var destinationOffset:Number;
      
      public function CollisionPlane()
      {
         super();
      }
      
      alternativa3d static function createCollisionPlane(param1:BSPNode, param2:Boolean, param3:Number, param4:Number) : CollisionPlane
      {
         var loc5:CollisionPlane = collector.pop();
         if(loc5 == null)
         {
            loc5 = new CollisionPlane();
         }
         loc5.node = param1;
         loc5.infront = param2;
         loc5.sourceOffset = param3;
         loc5.destinationOffset = param4;
         return loc5;
      }
      
      alternativa3d static function destroyCollisionPlane(param1:CollisionPlane) : void
      {
         param1.node = null;
         collector.push(param1);
      }
   }
}

