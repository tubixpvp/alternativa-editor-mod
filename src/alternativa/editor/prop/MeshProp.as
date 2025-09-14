package alternativa.editor.prop
{
   import alternativa.editor.InvisibleTexture;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Map;
   import alternativa.types.Matrix4;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import mx.controls.Alert;
   import alternativa.engine3d.core.Face;
   import alternativa.editor.engine3d.materials.WireMaterial;
   import alternativa.engine3d.core.Vertex;
   
   use namespace alternativa3d;
   
   public class MeshProp extends Prop
   {
      [Embed(source="no_collision_texture.png")]
      private static const NO_COLLISION_TEXTURE_MASK_Class:Class;

      private static const NO_COLLISION_TEXTURE_Bitmap:BitmapData = new NO_COLLISION_TEXTURE_MASK_Class().bitmapData;

      public var bitmaps:Map;
      
      protected var _textureName:String = "";
      
      private var collisionMaterial:CustomFillMaterial;
      
      private var _isMirror:Boolean = false;
      
      private var collisionBoxes:Set;
      
      private var bound:Mesh;

      private var _objects:Vector.<Object3D>;

      private var _collisionEnabled:Boolean = true;

      private var _noCollisionTexture:BitmapData = null;
      private var _noCollisionMaterial:TextureMaterial = null;
      
      
      public function MeshProp(mainObject:Object3D, objects:Vector.<Object3D>, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         super(mainObject,param2,param3,param4,param5);
         _objects = objects;
         type = Prop.TILE;
         this.parseCollisionData(mainObject, objects);
      }

      public override function dispose() : void
      {
         if(this.bound)
         {
            this.bound.faceList.material.dispose();
            this.bound.setMaterialToAllFaces(null);
            this.bound.deleteResources();
            this.bound.destroy();
            this.bound = null;
         }

         var mesh:Mesh = _object as Mesh;

         if(mesh)
         {
            mesh.setMaterialToAllFaces(null);
            mesh.deleteResources();
         }

         for each(var obj:Object3D in _objects)
         {
            var objMesh:Mesh = obj as Mesh;
            objMesh.setMaterialToAllFaces(null);
            objMesh.deleteResources();
            objMesh.destroy();
         }
         _objects.length = 0;
         _objects = null;

         this.collisionMaterial.dispose();
         this.collisionMaterial = null;

         this.collisionBoxes.clear();
         this.collisionBoxes = null;

         this.bitmaps = null;

         super.dispose();
      }

      public function get isTextureMirrored() : Boolean
      {
         return _isMirror;
      }
      
      private static function getMirrorBitmapData(param1:BitmapData) : BitmapData
      {
         var loc2:BitmapData = new BitmapData(param1.width,param1.height);
         loc2.draw(param1,new Matrix(-1,0,0,1,param1.width,0));
         return loc2;
      }
      
      private function parseCollisionData(mainObject:Object3D, objects:Vector.<Object3D>) : void
      {
         var loc2:Object3D;
         var loc3:Mesh = null;
         this.collisionBoxes = new Set();
         for each(loc2 in objects)
         {
            loc3 = loc2 as Mesh;
            if(loc3)
            {
               loc3.setMaterialToAllFaces(null);
               if(loc3.name.substr(0,3) != "occ")
               {
                  this.collisionBoxes.add(loc3);
               }
            }
            else
            {
               Alert.show(mainObject.name + " include invalid collision mesh " + Object3D(loc2).name);
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
            loc2.setMaterialToAllFaces(this.collisionMaterial);
            addChild(loc2);
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
            loc2.setMaterialToAllFaces(null);
            removeChild(loc2);
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
         if(_material != null)
         {
            _material.dispose();
         }

         _material = new TextureMaterial(bitmapData);

         this.disposeSelectTexture();

         if(_selected)
         {  
            select();
         }
         else
         {
            setMaterial(_material);
         }
         if(_noCollisionTexture != null)
         {
            _noCollisionMaterial.dispose();
            _noCollisionMaterial = null;
            _noCollisionTexture.dispose();
            _noCollisionTexture = null;
         }
         this.setToCollisionDisabledTextureIfNeeded();
         if(this._textureName == "DEFAULT")
         {
            this._textureName = "";
         }
      }
      
      public function mirrorTexture() : void
      {
         this._isMirror = !this._isMirror;
         bitmapData = getMirrorBitmapData(bitmapData);
         (_material as TextureMaterial).texture = bitmapData;
         if(selected)
         {
            this.disposeSelectTexture();

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
         loc1.setMaterialToAllFaces(_material as TextureMaterial);

         var objectsCopy:Vector.<Object3D> = new Vector.<Object3D>();
         for each(var obj:Object3D in _objects)
         {
            objectsCopy.push(obj.clone());
         }
         
         var loc2:MeshProp = new MeshProp(loc1,objectsCopy,name,_libraryName,_groupName,false);
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2._multi = _multi;
         loc2.name = name;
         loc2.bitmaps = this.bitmaps;
         loc2._textureName = this._textureName;
         loc2.height = height;
         loc2.collisionEnabled = this._collisionEnabled;
         return loc2;
      }
      
      public function showBound() : void
      {
         var loc1:Matrix4 = null;
         var loc2:Point3D = null;
         var loc3:Point3D = null;
         var loc4:Point3D = null;
         var loc5:Point3D = null;
         var loc6:Face = null;
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
            this.bound.addFace(Vector.<Vertex>([this.bound.addVertex(loc2.x,loc2.y,loc2.z,3),this.bound.addVertex(loc3.x,loc3.y,loc3.z,2),this.bound.addVertex(loc4.x,loc4.y,loc4.z,1),this.bound.addVertex(loc5.x,loc5.y,loc5.z,0)]));
            //loc6 = this.bound.createSurface([0],0);
            //loc6.material = new WireMaterial(4,255);
            this.bound.setMaterialToAllFaces(new WireMaterial(4,128,128,5,255));
            addChild(this.bound);
            this.bound.z = 0.1;
            //this.bound.mobility = -100;
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
      
      public function get collisionEnabled() : Boolean
      {
         return this._collisionEnabled;
      }
      public function set collisionEnabled(enabled:Boolean) : void
      {
         if(this._collisionEnabled == enabled)
            return;

         this._collisionEnabled = enabled;
         
         this.setToCollisionDisabledTextureIfNeeded();         
      }
      private function setToCollisionDisabledTextureIfNeeded() : void
      {
         if(_collisionEnabled)
            return;
         if(_selected) //shouldn't change texture of 'selected'
            return;
         if(hidden)
            return;
         if(this._textureName == InvisibleTexture.TEXTURE_NAME)
            return;

         if(_noCollisionTexture == null)
         {
            _noCollisionTexture = this.bitmapData.clone();

            _matrix.a = this.bitmapData.width / NO_COLLISION_TEXTURE_Bitmap.width;
            _matrix.d = this.bitmapData.height / NO_COLLISION_TEXTURE_Bitmap.height;
            
            _noCollisionTexture.draw(NO_COLLISION_TEXTURE_Bitmap, _matrix);

            //_noCollisionTexture = NO_COLLISION_TEXTURE_Bitmap.clone();
            _noCollisionMaterial = new TextureMaterial(_noCollisionTexture);
         }

         setMaterial(_noCollisionMaterial);
      }
      
      public override function deselect() : void
      {
         super.deselect();

         this.setToCollisionDisabledTextureIfNeeded();
      }
   }
}

