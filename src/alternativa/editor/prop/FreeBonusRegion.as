package alternativa.editor.prop
{
   import alternativa.editor.scene.MainScene;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.primitives.Box;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.types.Set;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   
   public class FreeBonusRegion extends Prop
   {
      private static const BOX_TEMPLATE:Box = new Box(BASE_WIDTH,BASE_LENGTH,BASE_HEIGHT);
      {
         BOX_TEMPLATE.setPositionXYZ(BASE_WIDTH / 2, BASE_LENGTH / 2, BASE_HEIGHT / 2);
         BOX_TEMPLATE.alpha = 0.5;
      }

      private static const tmpVec:Vector3D = new Vector3D();

      private static const BASE_WIDTH:Number = 500;
      
      private static const BASE_LENGTH:Number = 500;
      
      private static const BASE_HEIGHT:Number = 300;
      
      private static const texture:BitmapData = new BitmapData(1,1,false,16756224);
      
      private var _typeNames:Set;
      
      private var _gameModes:Set;
      
      public var parachute:Boolean = true;
      
      private var shadow:Plane;
      
      public function FreeBonusRegion(param1:String, param2:String, param3:String, param4:Boolean = true)
      {
         this._typeNames = new Set();
         this._gameModes = new Set();
         this._typeNames.add(BonusTypes.types[0]);
         this._gameModes.add(GameModes.modes[0]);
         this._gameModes.add(GameModes.modes[1]);
         this._gameModes.add(GameModes.modes[2]);
         this._gameModes.add(GameModes.modes[3]);
         //_material = new TextureMaterial(texture,0.5,true,false,BlendMode.MULTIPLY);
         super(BOX_TEMPLATE.clone(),param1,param2,param3,param4);
         type = Prop.BONUS;

         this.shadow = new Plane(BASE_WIDTH,BASE_LENGTH);
         this.shadow.mouseEnabled = false;
         this.shadow.alpha = 0.5;
         this.shadow.x = BASE_WIDTH / 2;
         this.shadow.y = BASE_LENGTH / 2;
         addChild(this.shadow);

         this.updateDestinationArea();
         this.changeTexture(texture);

         this.shadow.setMaterialToAllFaces(this.getMaterial());
      }
      
      public function get typeNames() : Set
      {
         return this._typeNames;
      }
      
      public function get gameModes() : Set
      {
         return this._gameModes;
      }
      
      override public function clone() : Object3D
      {
         var loc2:FreeBonusRegion = new FreeBonusRegion(name,_libraryName,_groupName,false);
         loc2.scaleX = scaleX;
         loc2.scaleY = scaleY;
         loc2.scaleZ = scaleZ;
         loc2.z = z;
         loc2._typeNames = this._typeNames.clone();
         loc2._gameModes = this._gameModes.clone();
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2.name = name;
         loc2.height = height;
         return loc2;
      }
      
      private function updateDestinationArea() : void
      {
         removeChild(this.shadow);
         var loc1:Vector3D = MainScene.getProjectedPoint(new Vector3D(x + scaleX * BASE_WIDTH / 2,y + scaleY * BASE_LENGTH / 2,z - 50));
         addChild(this.shadow);
         loc1 = globalToLocal(loc1);
         this.shadow.z = loc1.z + 3;
      }
      
      override protected function setMaterial(material:Material) : void
      {
         super.setMaterial(material);
         if (this.shadow != null)
         {
            this.shadow.setMaterialToAllFaces(material);
         }
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
            this.scaleX = scaleY;
            this.scaleY = loc2;
         }
      }
      
      public function get minX() : Number
      {
         return x;
      }
      
      public function set minX(param1:Number) : void
      {
         this.x = param1;
      }
      
      public function get minY() : Number
      {
         return y;
      }
      
      public function set minY(param1:Number) : void
      {
         this.y = param1;
      }
      
      public function get minZ() : Number
      {
         return z;
      }
      
      public function set minZ(param1:Number) : void
      {
         this.z = param1;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.updateDestinationArea();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.updateDestinationArea();
      }
      
      override public function set z(param1:Number) : void
      {
         super.z = param1;
         this.updateDestinationArea();
      }
      
      public function get maxx() : Number
      {
         return x + BASE_WIDTH * scaleX;
      }
      
      public function set maxx(param1:Number) : void
      {
         this.scaleX = (param1 - x) / BASE_WIDTH;
      }
      
      public function get maxy() : Number
      {
         return y + BASE_LENGTH * scaleY;
      }
      
      public function set maxy(param1:Number) : void
      {
         this.scaleY = (param1 - y) / BASE_LENGTH;
      }
      
      public function get maxz() : Number
      {
         return z + BASE_HEIGHT * scaleZ;
      }
      
      public function set maxz(param1:Number) : void
      {
         this.scaleZ = (param1 - z) / BASE_HEIGHT;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this.updateDestinationArea();
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this.updateDestinationArea();
      }
      
      override public function set scaleZ(param1:Number) : void
      {
         super.scaleZ = param1;
         this.updateDestinationArea();
      }
   }
}

