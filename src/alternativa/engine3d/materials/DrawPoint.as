package alternativa.engine3d.materials
{
   public final class DrawPoint
   {
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var u:Number;
      
      public var v:Number;
      
      public function DrawPoint(param1:Number, param2:Number, param3:Number, param4:Number = 0, param5:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.u = param4;
         this.v = param5;
      }
   }
}

