package alternativa.engine3d.core
{
   public class BoundBox
   {
       
      
      public var minX:Number = 1.7976931348623157E308;
      
      public var minY:Number = 1.7976931348623157E308;
      
      public var minZ:Number = 1.7976931348623157E308;
      
      public var maxX:Number;
      
      public var maxY:Number;
      
      public var maxZ:Number;
      
      public function BoundBox()
      {
         this.maxX = -Number.MAX_VALUE;
         this.maxY = -Number.MAX_VALUE;
         this.maxZ = -Number.MAX_VALUE;
         super();
      }
      
      public function setSize(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.minX = param1;
         this.minY = param2;
         this.minZ = param3;
         this.maxX = param4;
         this.maxY = param5;
         this.maxZ = param6;
      }
      
      public function clone() : BoundBox
      {
         var _loc1_:BoundBox = new BoundBox();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function infinity() : void
      {
         this.minX = this.minY = this.minZ = Number.MAX_VALUE;
         this.maxX = this.maxY = this.maxZ = -Number.MAX_VALUE;
      }
      
      public function toString() : String
      {
         return "BoundBox [" + this.minX.toFixed(2) + ", " + this.minY.toFixed(2) + ", " + this.minZ.toFixed(2) + " - " + this.maxX.toFixed(2) + ", " + this.maxY.toFixed(2) + ", " + this.maxZ.toFixed(2) + "]";
      }
      
      public function addBoundBox(param1:BoundBox) : void
      {
         this.minX = param1.minX < this.minX ? Number(param1.minX) : Number(this.minX);
         this.minY = param1.minY < this.minY ? Number(param1.minY) : Number(this.minY);
         this.minZ = param1.minZ < this.minZ ? Number(param1.minZ) : Number(this.minZ);
         this.maxX = param1.maxX > this.maxX ? Number(param1.maxX) : Number(this.maxX);
         this.maxY = param1.maxY > this.maxY ? Number(param1.maxY) : Number(this.maxY);
         this.maxZ = param1.maxZ > this.maxZ ? Number(param1.maxZ) : Number(this.maxZ);
      }
      
      public function addPoint(param1:Number, param2:Number, param3:Number) : void
      {
         if(param1 < this.minX)
         {
            this.minX = param1;
         }
         if(param1 > this.maxX)
         {
            this.maxX = param1;
         }
         if(param2 < this.minY)
         {
            this.minY = param2;
         }
         if(param2 > this.maxY)
         {
            this.maxY = param2;
         }
         if(param3 < this.minZ)
         {
            this.minZ = param3;
         }
         if(param3 > this.maxZ)
         {
            this.maxZ = param3;
         }
      }
      
      public function copyFrom(param1:BoundBox) : void
      {
         this.minX = param1.minX;
         this.minY = param1.minY;
         this.minZ = param1.minZ;
         this.maxX = param1.maxX;
         this.maxY = param1.maxY;
         this.maxZ = param1.maxZ;
      }
   }
}
