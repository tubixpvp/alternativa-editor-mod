package alternativa.editor.prop
{
   import alternativa.editor.scene.MainScene;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.SurfaceMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.primitives.Box;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import alternativa.types.Texture;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class FreeBonusRegion extends Prop
   {
      private static const BASE_WIDTH:Number = 500;
      
      private static const BASE_LENGTH:Number = 500;
      
      private static const BASE_HEIGHT:Number = 300;
      
      private static const texture:Texture = new Texture(new BitmapData(1,1,false,16756224));
      
      private var _typeNames:Set;
      
      private var _gameModes:Set;
      
      public var parachute:Boolean = true;
      
      private var BOX_SIZE:int = 0;
      
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
         var loc5:Box = new Box(BASE_WIDTH,BASE_LENGTH,BASE_HEIGHT);
         loc5.x = BASE_WIDTH / 2;
         loc5.y = BASE_LENGTH / 2;
         loc5.z = BASE_HEIGHT / 2;
         _material = new TextureMaterial(texture,0.5,true,false,BlendMode.MULTIPLY);
         loc5.cloneMaterialToAllSurfaces(SurfaceMaterial(_material));
         _object = loc5;
         super(object,param1,param2,param3,param4);
         type = Prop.BONUS;
         this.showDestinationArea();
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
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.cloneMaterialToAllSurfaces(_material as TextureMaterial);
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
      
      public function showDestinationArea() : void
      {
         if(Boolean(this.shadow) && children.has(this.shadow))
         {
            removeChild(this.shadow);
         }
         var loc1:Point3D = MainScene.getProjectedPoint(new Point3D(x + scaleX * BASE_WIDTH / 2,y + scaleY * BASE_LENGTH / 2,z - 50));
         globalToLocal(loc1,loc1);
         var loc2:Number = BASE_WIDTH * scaleX + this.BOX_SIZE;
         var loc3:Number = BASE_LENGTH * scaleY + this.BOX_SIZE;
         this.shadow = new Plane(loc2,loc3);
         this.shadow.mouseEnabled = false;
         var loc4:TextureMaterial = new TextureMaterial(texture);
         loc4.alpha = 0.5;
         this.shadow.cloneMaterialToAllSurfaces(loc4);
         this.shadow.scaleX /= scaleX;
         this.shadow.scaleY /= scaleY;
         this.shadow.x = BASE_WIDTH / 2;
         this.shadow.y = BASE_LENGTH / 2;
         this.shadow.z = loc1.z + 3;
         addChild(this.shadow);
      }
      
      override public function setMaterial(param1:Material) : void
      {
         var loc2:SurfaceMaterial = param1 as SurfaceMaterial;
         (_object as Mesh).cloneMaterialToAllSurfaces(loc2);
         (this.shadow as Mesh).cloneMaterialToAllSurfaces(loc2);
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
         this.showDestinationArea();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.showDestinationArea();
      }
      
      override public function set z(param1:Number) : void
      {
         super.z = param1;
         this.showDestinationArea();
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
         this.showDestinationArea();
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this.showDestinationArea();
      }
      
      override public function set scaleZ(param1:Number) : void
      {
         super.scaleZ = param1;
         this.showDestinationArea();
      }
   }
}

