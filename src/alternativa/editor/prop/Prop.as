package alternativa.editor.prop
{
   import alternativa.editor.scene.EditorScene;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.MouseEvent3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.utils.MathUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Vertex;
   import flash.geom.Vector3D;
   import mod.textures.ConvertedBitmapsRegistry;
   import mod.textures.MaterialsRegistry;
   
   public class Prop extends Object3DContainer
   {
      public static const TILE:int = 1;
      
      public static const SPAWN:int = 2;
      
      public static const BONUS:int = 3;
      
      public static const FLAG:int = 4;
      
      public static const DOMINATION_CONTROL_POINT:int = 5;
      
      public static const KILL_GEOMETRY:int = 6;

      private static const v1:Vector3D = new Vector3D();
      private static const v2:Vector3D = new Vector3D();
      
      public var type:int = 3;
      
      protected var _object:Object3D;
      
      protected var _groupName:String;
      
      protected var _libraryName:String;
      
      public var distancesX:Point;
      
      public var distancesY:Point;
      
      public var distancesZ:Point;
      
      public var _multi:Boolean = false;
      
      public var free:Boolean = true;
      
      public var bitmapData:BitmapData;
      
      public var icon:Bitmap;
      
      protected var _selected:Boolean = false;
      
      public var height:int;
      
      public var data:*;


      private var _defaultMaterial:TextureMaterial = null;
      private var _selectMaterial:TextureMaterial = null;

      private var _materialIsOverriden:Boolean = false;
      
      
      public function Prop(param1:Object3D, name:String, libraryName:String, groupName:String, param5:Boolean = true)
      {
         super();
         this.name = name;
         addChild(param1);
         this._object = param1;
         this._object.addEventListener(MouseEvent3D.MOUSE_DOWN,this.onMouseDown);
         this._libraryName = libraryName;
         this._groupName = groupName;
         this.initBitmapData();
         if(param5)
         {
            this.calculate();
         }
      }

      public function dispose() : void
      {
         bitmapData = null;
         icon = null;

         if (_defaultMaterial != null)
         {
            MaterialsRegistry.releaseTextureMaterial(_defaultMaterial);
            _defaultMaterial = null;
         }
         if(_selectMaterial != null)
         {
            MaterialsRegistry.releaseTextureMaterial(_selectMaterial);
            _selectMaterial = null;
         }

         _object.destroy();
         _object = null;

         super.destroy();
      }
      
      private static function calcDistance(param1:Number, param2:Number, param3:Number, param4:Number) : Point
      {
         var loc5:Point = new Point();
         param3 = floorTo(param3,param4);
         param2 = floorTo(param2,param4);
         if(param3 == 0 && param2 == 0)
         {
            loc5.x = 0;
            loc5.y = param4;
         }
         else if(param3 > param2)
         {
            if(param2 == 0)
            {
               loc5.x = 0;
               loc5.y = int(param3 - param1);
            }
            else
            {
               loc5.x = int(param2 - param1);
               loc5.y = int(param3 - param1);
            }
         }
         else if(param3 == 0)
         {
            loc5.x = 0;
            loc5.y = int(param2 - param1);
         }
         else
         {
            loc5.x = int(param3 - param1);
            loc5.y = int(param2 - param1);
         }
         return loc5;
      }
      
      public static function floorTo(param1:Number, param2:Number) : Number
      {
         return Math.floor(param1 / param2) * param2;
      }
      
      public static function ceilTo(param1:Number, param2:Number) : Number
      {
         return Math.ceil(param1 / param2) * param2;
      }
      
      public static function roundTo(param1:Number, param2:Number) : Number
      {
         return Math.round((param1 + param2 / 2) / param2) * param2;
      }
      
      public function get object() : Object3D
      {
         return this._object;
      }
      
      private function onMouseDown(param1:MouseEvent3D) : void
      {
         param1._target = this;
      }
      
      protected function initBitmapData() : void
      {
         var mesh:Mesh = _object as Mesh;
         if (mesh == null || mesh.faceList == null || mesh.faceList.material == null)
            return;
         var textureMaterial:TextureMaterial = mesh.faceList.material as TextureMaterial;
         if (textureMaterial == null || textureMaterial.texture == null)
            return;
         this.changeTexture(textureMaterial.texture);
      }

      protected function changeTexture(bitmap:BitmapData) : void
      {
         if (this.bitmapData == bitmap)
            return;
         this.bitmapData = bitmap;
         if (_defaultMaterial != null)
         {
            MaterialsRegistry.releaseTextureMaterial(_defaultMaterial);
            _defaultMaterial = null;
         }
         if (bitmap != null)
         {
            _defaultMaterial = MaterialsRegistry.getTextureMaterial(this.bitmapData);
         }
         this.updateMaterialState();
      }
      
      public function calculate() : void
      {
         var loc13:Vector3D = null;
         var loc14:int = 0;
         var loc15:Vector3D = null;
         var loc16:Number = NaN;
         var loc17:Number = NaN;
         var loc18:Number = NaN;
         var loc19:Number = NaN;
         var loc20:Number = NaN;
         var loc21:Number = NaN;
         var loc1:Vector.<Vertex> = (this._object as Mesh).vertices;
         var loc2:Number = 0;
         var loc3:Number = 0;
         var loc4:Number = 0;
         var loc5:Number = 0;
         var loc6:Number = 0;
         var loc7:Number = 0;
         var loc8:Number = 0;
         var loc9:Number = 0;
         var loc10:Number = 0;
         var loc11:int = int(loc1.length);
         var loc12:int = 0;
         while(loc12 < loc11)
         {
            loc13 = loc1[loc12].copyToVector3D(v1);
            if(parent)
            {
               loc13 = localToGlobal(loc13);
            }
            loc14 = loc12 + 1;
            while(loc14 < loc11)
            {
               loc15 = loc1[loc14].copyToVector3D(v2);
               if(parent)
               {
                  loc15 = localToGlobal(loc15);
               }
               loc16 = loc13.x - loc15.x;
               loc17 = loc13.y - loc15.y;
               loc18 = loc13.z - loc15.z;
               loc19 = loc16 * loc16;
               loc20 = loc17 * loc17;
               loc21 = loc18 * loc18;
               if(loc19 > loc4)
               {
                  loc4 = loc19;
                  loc9 = loc13.x;
                  loc10 = loc15.x;
               }
               if(loc20 > loc3)
               {
                  loc3 = loc20;
                  loc7 = loc13.y;
                  loc8 = loc15.y;
               }
               if(loc21 > loc2)
               {
                  loc2 = loc21;
                  loc5 = loc13.z;
                  loc6 = loc15.z;
               }
               loc14++;
            }
            loc12++;
         }
         this.height = Math.sqrt(loc2);
         this.distancesX = calcDistance(x,int(loc9),int(loc10),EditorScene.hBase);
         this.distancesY = calcDistance(y,int(loc7),int(loc8),EditorScene.hBase);
         this.distancesZ = calcDistance(z,int(loc5),int(loc6),EditorScene.vBase);
         if(Math.abs(int(loc10) - int(loc9)) / EditorScene.hBase2 > 1 || Math.abs(int(loc7) - int(loc8)) / EditorScene.hBase2 > 1)
         {
            this._multi = true;
         }
         if(!parent)
         {
            /*if(this._multi)
            {
               this.checkRemainder(loc9,"x",500);
               this.checkRemainder(loc10,"x",500);
               this.checkRemainder(loc7,"y",500);
               this.checkRemainder(loc8,"y",500);
            }
            else
            {
               if(Math.abs(loc9) - 250 > 0.01)
               {
                  ErrorHandler.addText("Prop" + this + "is out of size along x:" + loc9);
                  ErrorHandler.showWindow();
               }
               if(Math.abs(loc10) - 250 > 0.01)
               {
                  ErrorHandler.addText("Prop" + this + "is out of size along x:" + loc10);
                  ErrorHandler.showWindow();
               }
               if(Math.abs(loc7) - 250 > 0.01)
               {
                  ErrorHandler.addText("Prop" + this + "is out of size along y:" + loc7);
                  ErrorHandler.showWindow();
               }
               if(Math.abs(loc8) - 250 > 0.01)
               {
                  ErrorHandler.addText("Prop" + this + "is out of size along y:" + loc8);
                  ErrorHandler.showWindow();
               }
            }*/
         }
      }
      
      /*private function checkRemainder(param1:Number, param2:String, param3:Number) : void
      {
         var loc4:Number = Math.abs(param1 % 500);
         if(loc4 > 0.01 && loc4 < 5)
         {
            ErrorHandler.addText(loc4 + "Prop" + this + "is out of size along " + param2 + " " + param1);
            ErrorHandler.showWindow();
         }
      }*/
      
      public function select() : void
      {
         if (this._selected)
            return;
         this._selected = true;
         this.updateMaterialState();
      }
      
      public function deselect() : void
      {
         if (!this._selected)
            return;
         this._selected = false;
         this.updateMaterialState();
      }

      protected function updateMaterialState() : void
      {
         if (!this.visible)
            return;
         var material:Material = this.getCurrentMaterial();
         this.setMaterial(material);
      }
      protected function getCurrentMaterial() : Material
      {
         if (_selected)
         {
            var selectBitmap:BitmapData = ConvertedBitmapsRegistry.getSelectedBitmap(this.bitmapData);
            if (_selectMaterial != null && _selectMaterial.texture != selectBitmap)
            {
               MaterialsRegistry.releaseTextureMaterial(_selectMaterial);
               _selectMaterial = null;
            }
            if (_selectMaterial == null)
            {
               _selectMaterial = MaterialsRegistry.getTextureMaterial(selectBitmap);
            }
            return _selectMaterial;
         }
         return _defaultMaterial;
      }
      
      protected function setMaterial(material:Material) : void
      {
         var mesh:Mesh = _object as Mesh;
         if (mesh.faceList != null && mesh.faceList.material == material)
            return;
         mesh.setMaterialToAllFaces(material);
      }

      public function overrideMaterial(material:Material) : void
      {
         this.setMaterial(material);
         this._materialIsOverriden = true;
      }
      public function resetMaterial() : void
      {
         this.updateMaterialState();
         this._materialIsOverriden = false;
      }
      public function hasOverridenMaterial() : Boolean
      {
         return this._materialIsOverriden;
      }
      public function getMaterial() : Material
      {
         var mesh:Mesh = _object as Mesh;
         if (mesh == null)
            return null;
         if (mesh.faceList == null)
            return null;
         return mesh.faceList.material;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function show() : void
      {
         if (this.visible)
            return;
         this.visible = true;
         this.updateMaterialState();
      }
      
      public function get multi() : Boolean
      {
         return this._multi;
      }
      
      public function get libraryName() : String
      {
         return this._libraryName;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function rotateCounterClockwise() : void
      {
         var loc1:Point = new Point(this.distancesY.x,this.distancesY.y);
         this.distancesY.x = this.distancesX.x;
         this.distancesY.y = this.distancesX.y;
         this.distancesX.x = -loc1.y;
         this.distancesX.y = -loc1.x;
         rotationZ += MathUtils.DEG90;
      }
      
      public function rotateClockwise() : void
      {
         var loc1:Point = new Point(this.distancesX.x,this.distancesX.y);
         this.distancesX.x = this.distancesY.x;
         this.distancesX.y = this.distancesY.y;
         this.distancesY.x = -loc1.y;
         this.distancesY.y = -loc1.x;
         rotationZ -= MathUtils.DEG90;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._object.addEventListener(param1,param2);
      }
      
      override public function clone() : Object3D
      {
         throw new Error("Abstract method");
      }
      
      public function snapToGrid() : void
      {
         if(EditorScene.snapByHalf)
         {
            x = floorTo(x,EditorScene.HORIZONTAL_GRID_RESOLUTION_2);
            y = floorTo(y,EditorScene.HORIZONTAL_GRID_RESOLUTION_2);
            z = floorTo(z,EditorScene.VERTICAL_GRID_RESOLUTION_2);
         }
         else
         {
            if(!this._multi)
            {
               x -= EditorScene.HORIZONTAL_GRID_RESOLUTION_2;
               y -= EditorScene.HORIZONTAL_GRID_RESOLUTION_2;
            }
            x = ceilTo(x,EditorScene.HORIZONTAL_GRID_RESOLUTION_1);
            y = ceilTo(y,EditorScene.HORIZONTAL_GRID_RESOLUTION_1);
            z = floorTo(z,EditorScene.VERTICAL_GRID_RESOLUTION_1);
            if(!this._multi)
            {
               x += EditorScene.HORIZONTAL_GRID_RESOLUTION_2;
               y += EditorScene.HORIZONTAL_GRID_RESOLUTION_2;
            }
         }
      }
      
      // FIXME: never called (overriden in multiple classes)
      public function onAddedToScene() : void
      {
      }
   }
}

