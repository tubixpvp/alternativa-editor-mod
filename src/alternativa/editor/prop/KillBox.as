package alternativa.editor.prop
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.primitives.Box;
   import flash.display.BitmapData;
   import mx.collections.ArrayCollection;
   
   public class KillBox extends Prop
   {
      public static const KILL:String = "kill";
      
      public static const KICK:String = "kick";
      
      public static const BLOCK:String = "block";
      
      private static const BASE_WIDTH:Number = 500;
      
      private static const BASE_LENGTH:Number = 500;
      
      private static const BASE_HEIGHT:Number = 300;
      
      private static const texture:BitmapData = new BitmapData(1,1,false,15732981);
      
      public static const typesProvider:ArrayCollection = new ArrayCollection([KICK,KILL,BLOCK]);
      
      public var action:String = "kill";
      
      public function KillBox(param1:String, param2:String, param3:String, param4:Boolean = true)
      {
         var loc5:Box = new Box(BASE_WIDTH,BASE_LENGTH,BASE_HEIGHT);
         loc5.x = BASE_WIDTH / 2;
         loc5.y = BASE_LENGTH / 2;
         loc5.z = BASE_HEIGHT / 2;
         _object = loc5;
         var loc6:TextureMaterial = new TextureMaterial(texture);
         //loc6.alpha = 0.5;
         loc5.alpha = 0.5;
         loc5.setMaterialToAllFaces(loc6);
         super(object,param1,param2,param3,param4);
         type = Prop.KILL_GEOMETRY;
      }
      
      override public function clone() : Object3D
      {
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.setMaterialToAllFaces(_material as TextureMaterial);
         var loc2:KillBox = new KillBox(name,_libraryName,_groupName,false);
         loc2.action = this.action;
         loc2.scaleX = scaleX;
         loc2.scaleY = scaleY;
         loc2.scaleZ = scaleZ;
         loc2.z = z;
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2.name = name;
         loc2.height = height;
         return loc2;
      }
      
      override public function get rotationX() : Number
      {
         return super.rotationX;
      }
      
      override public function get rotationY() : Number
      {
         return super.rotationY;
      }
      
      override public function get rotationZ() : Number
      {
         return super.rotationZ;
      }
      
      override public function set rotationX(param1:Number) : void
      {
      }
      
      override public function set rotationY(param1:Number) : void
      {
      }
      
      override public function set rotationZ(param1:Number) : void
      {
         var loc2:Number = NaN;
         if(Math.abs(param1 - this.rotationZ) < 0.0001)
         {
            return;
         }
         if(Math.abs(this.rotationZ - param1) % (Math.PI / 2) < 0.0001)
         {
            loc2 = scaleX;
            scaleX = scaleY;
            scaleY = loc2;
         }
      }
      
      public function get minX() : Number
      {
         return x;
      }
      
      public function set minX(param1:Number) : void
      {
         x = param1;
      }
      
      public function get minY() : Number
      {
         return y;
      }
      
      public function set minY(param1:Number) : void
      {
         y = param1;
      }
      
      public function get minZ() : Number
      {
         return z;
      }
      
      public function set minZ(param1:Number) : void
      {
         z = param1;
      }
      
      public function get maxx() : Number
      {
         return x + BASE_WIDTH * scaleX;
      }
      
      public function set maxx(param1:Number) : void
      {
         scaleX = (param1 - x) / BASE_WIDTH;
      }
      
      public function get maxy() : Number
      {
         return y + BASE_LENGTH * scaleY;
      }
      
      public function set maxy(param1:Number) : void
      {
         scaleY = (param1 - y) / BASE_LENGTH;
      }
      
      public function get maxz() : Number
      {
         return z + BASE_HEIGHT * scaleZ;
      }
      
      public function set maxz(param1:Number) : void
      {
         scaleZ = (param1 - z) / BASE_HEIGHT;
      }
   }
}

