package alternativa.editor.prop
{
   import alternativa.editor.InvisibleTexture;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.WireMaterial;
   import alternativa.types.Map;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import alternativa.types.Texture;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import mx.controls.Alert;
   
   use namespace alternativa3d;
   
   public class MeshProp extends Prop
   {
      public var bitmaps:Map;
      
      protected var _textureName:String = "";
      
      private var collisionMaterial:CustomFillMaterial;
      
      private var _isMirror:Boolean = false;
      
      private var collisionBoxes:Set;
      
      private var bound:Mesh;
      
      public function MeshProp(param1:Object3D, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
         type = Prop.TILE;
         this.parseCollisionData(param1);
      }
      
      private static function getMirrorBitmapData(param1:BitmapData) : BitmapData
      {
         var loc2:BitmapData = new BitmapData(param1.width,param1.height);
         loc2.draw(param1,new Matrix(-1,0,0,1,param1.width,0));
         return loc2;
      }
      
      private function parseCollisionData(param1:Object3D) : void
      {
         var loc2:* = undefined;
         var loc3:Mesh = null;
         this.collisionBoxes = new Set();
         for(loc2 in param1.children)
         {
            loc3 = loc2 as Mesh;
            if(loc3)
            {
               loc3.cloneMaterialToAllSurfaces(null);
               if(loc3.name.substr(0,3) != "occ")
               {
                  this.collisionBoxes.add(loc3);
               }
            }
            else
            {
               Alert.show(param1.name + " include invalid collision mesh " + Object3D(loc2).name);
            }
         }
         this.collisionMaterial = new CustomFillMaterial(new Point3D(-10000000000,-7000000000,4000000000),16744319);
      }
      
      public function showCollisionBoxes() : void
      {
         var loc1:* = undefined;
         var loc2:Mesh = null;
         for(loc1 in this.collisionBoxes)
         {
            loc2 = loc1 as Mesh;
            loc2.cloneMaterialToAllSurfaces(this.collisionMaterial);
         }
         setMaterial(null);
      }
      
      public function hideCollisionBoxes() : void
      {
         var loc1:* = undefined;
         var loc2:Mesh = null;
         for(loc1 in this.collisionBoxes)
         {
            loc2 = loc1 as Mesh;
            loc2.cloneMaterialToAllSurfaces(null);
         }
         setMaterial(_material);
      }
      
      public function get collisionGeometry() : Set
      {
         return this.collisionBoxes;
      }
      
      public function get textureName() : String
      {
         return this._textureName;
      }
      
      public function set textureName(param1:String) : void
      {
         this._textureName = param1;
         if(this._textureName == InvisibleTexture.TEXTURE_NAME)
         {
            bitmapData = InvisibleTexture.invisibleTexture.bitmapData;
         }
         else
         {
            bitmapData = this._isMirror ? getMirrorBitmapData(this.bitmaps[param1]) : this.bitmaps[param1];
         }
         _material = new TextureMaterial(new Texture(bitmapData));
         if(_selected)
         {
            _selectBitmapData.dispose();
            select();
         }
         else
         {
            setMaterial(_material);
         }
         if(this._textureName == "DEFAULT")
         {
            this._textureName = "";
         }
      }
      
      public function mirrorTexture() : void
      {
         this._isMirror = !this._isMirror;
         bitmapData = getMirrorBitmapData(bitmapData);
         (_material as TextureMaterial).texture = new Texture(bitmapData);
         if(selected)
         {
            _selectBitmapData.dispose();
            select();
         }
         else
         {
            setMaterial(_material);
         }
      }
      
      override public function clone() : Object3D
      {
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.cloneMaterialToAllSurfaces(_material as TextureMaterial);
         var loc2:MeshProp = new MeshProp(loc1,name,_libraryName,_groupName,false);
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2._multi = _multi;
         loc2.name = name;
         loc2.bitmaps = this.bitmaps;
         loc2._textureName = this._textureName;
         loc2.height = height;
         return loc2;
      }
      
      public function showBound() : void
      {
         var loc1:Matrix3D = null;
         var loc2:Point3D = null;
         var loc3:Point3D = null;
         var loc4:Point3D = null;
         var loc5:Point3D = null;
         var loc6:Surface = null;
         if(!this.bound)
         {
            this.bound = new Mesh();
            loc1 = this.transformation;
            loc1.invert();
            loc2 = new Point3D(distancesX.y + x,distancesY.x + y,z);
            loc3 = new Point3D(distancesX.y + x,distancesY.y + y,z);
            loc4 = new Point3D(distancesX.x + x,distancesY.y + y,z);
            loc5 = new Point3D(distancesX.x + x,distancesY.x + y,z);
            loc5.transform(loc1);
            loc4.transform(loc1);
            loc3.transform(loc1);
            loc2.transform(loc1);
            this.bound.createFace([this.bound.createVertex(loc2.x,loc2.y,loc2.z,3),this.bound.createVertex(loc3.x,loc3.y,loc3.z,2),this.bound.createVertex(loc4.x,loc4.y,loc4.z,1),this.bound.createVertex(loc5.x,loc5.y,loc5.z,0)],0);
            loc6 = this.bound.createSurface([0],0);
            loc6.material = new WireMaterial(4,255);
            addChild(this.bound);
            this.bound.z = 0.1;
            this.bound.mobility = -100;
            this.bound.mouseEnabled = false;
         }
      }
      
      public function hideBound() : void
      {
         if(this.bound)
         {
            removeChild(this.bound);
            this.bound = null;
         }
      }
   }
}

