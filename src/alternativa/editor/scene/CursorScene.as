package alternativa.editor.scene
{
   import alternativa.editor.prop.CustomFillMaterial;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.editor.engine3d.controllers.WalkController;
   import alternativa.types.Matrix4;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.Vector3D;
   import flash.display.Sprite;
   import flash.geom.Point;
   import alternativa.engine3d.materials.FillMaterial;
   import flash.display.BitmapData;
   import mod.textures.ConvertedBitmapsRegistry;
   import alternativa.engine3d.materials.Material;
   import mod.textures.MaterialsRegistry;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.editor.SceneContainer;
   
   public class CursorScene
   {

      private static const znormal:Vector3D = new Vector3D(0,0,1);

      private static const intersectionPoint:Vector3D = new Vector3D();
      
      private static const pointOnScreen:Point = new Point();

      private static const selectedObjectSet:Set = new Set();

      
      private var _selectedPropPrefab:Prop;
      private var _selectedProp:Prop;

      private var _conflictMaterial:FillMaterial;

      private var _acceptMaterial:FillMaterial;

      
      private var _freeState:Boolean = true;
      
      public var cameraController:WalkController;
      
      public var containerController:WalkController;
      
      public var container:Object3DContainer;
      
      private var eventSourceObject:DisplayObject;
      
      private var _snapMode:Boolean = true;
      
      private var axisIndicatorOverlay:Shape;
      
      private var axisIndicatorSize:Number = 30;
      
      private var _visible:Boolean = false;

      private var mainScene:MainScene;
      
      public function CursorScene(param1:DisplayObject, container:SceneContainer)
      {
         super();
         this.eventSourceObject = param1;
         this.mainScene = container.mainScene;
         this.initControllers();
         container.addChild(this.axisIndicatorOverlay = new Shape());

         _acceptMaterial = new CustomFillMaterial(new Point3D(-10000000000,-7000000000,4000000000),65280);
         _conflictMaterial = new CustomFillMaterial(new Point3D(-10000000000,-7000000000,4000000000),16711680);
      }
      
      private function initControllers() : void
      {
         this.cameraController = new WalkController(this.eventSourceObject);
         this.cameraController.object = this.mainScene.camera;
         this.cameraController.speedMultiplier = 4;
         this.cameraController.speedThreshold = 1;
         this.cameraController.mouseEnabled = false;
         this.cameraController.coords = new Point3D(250,-7800,4670);
         this.container = new Object3DContainer();
         this.mainScene.root.addChild(this.container);
         this.containerController = new WalkController(this.eventSourceObject);
         this.containerController.object = this.container;
         this.containerController.mouseEnabled = false;
         this.container.addChild(this.mainScene.camera);
         this.container.mouseChildren = false;
      }
      
      public function set object(propPrefab:Prop) : void
      {
         if (_selectedPropPrefab == propPrefab)
            return;

         var previousPosition:Vector3D = null;
         if (_selectedProp != null)
         {
            previousPosition = new Vector3D(_selectedProp.x, _selectedProp.y, _selectedProp.z);
            clearSelection();
         }

         _selectedPropPrefab = propPrefab;

         _selectedProp = propPrefab.clone() as Prop;
         _selectedProp.alpha = 0.5;
         
         if (previousPosition != null)
         {
            _selectedProp.setPositionFromVector3(previousPosition);
         }

         _selectedProp.visible = _visible;

         this.mainScene.root.addChild(_selectedProp);

         snapToGridIfNeccessary();

         checkForConflicts();
      }
      
      public function get object() : Prop
      {
         return this._selectedProp;
      }
      public function get prefab() : Prop
      {
         return this._selectedPropPrefab;
      }
      
      public function set snapMode(snapMode:Boolean) : void
      {
         if (_snapMode == snapMode)
            return;
         _snapMode = snapMode;
         if (_selectedProp == null)
            return;
         snapToGridIfNeccessary();
      }

      private function snapToGridIfNeccessary() : void
      {
         if (_snapMode && !(_selectedProp is Sprite3DProp))
         {
            _selectedProp.snapToGrid();
         }
      }
      
      public function moveCursorByMouse() : void
      {
         if (_selectedProp == null)
            return;
         pointOnScreen.setTo(this.mainScene.view.mouseX,this.mainScene.view.mouseY);
         this.mainScene.camera.projectViewPointToPlane(pointOnScreen,znormal,this._selectedProp.z,intersectionPoint);
         if (isNaN(intersectionPoint.x))
            return;
         _selectedProp.x = intersectionPoint.x;
         _selectedProp.y = intersectionPoint.y;
         snapToGridIfNeccessary();
         checkForConflicts();
      }
      
      public function get freeState() : Boolean
      {
         return this._freeState;
      }
      
      public function checkForConflicts() : void
      {
         if (_selectedProp == null)
            return;
         if (!_snapMode)
         {
            _selectedProp.resetMaterial();
            return;
         }
         _freeState = !this.mainScene.occupyMap.isConflict(_selectedProp);
         if (_selectedProp is Sprite3DProp)
         {
            var texture:BitmapData = ConvertedBitmapsRegistry.getCursorConflictBitmap(_selectedProp.bitmapData, _freeState);
            var material:Material = MaterialsRegistry.getTextureMaterial(texture);
            _selectedProp.overrideMaterial(material);
         }
         else
         {
            _selectedProp.overrideMaterial(_freeState ? _acceptMaterial : _conflictMaterial);
         }
      }
      
      public function clear() : void
      {
         _visible = false;
         clearSelection();
      }

      private function clearSelection() : void
      {
         selectedObjectSet.clear();
         if (_selectedProp == null)
            return;
         _selectedPropPrefab = null;
         this.mainScene.root.removeChild(_selectedProp);
         
         var material:Material = _selectedProp.getOverridenMaterial();
         var textureMaterial:TextureMaterial = material as TextureMaterial;
         if(textureMaterial != null)
         {
            MaterialsRegistry.releaseTextureMaterial(textureMaterial);
         }
         
         _selectedProp.dispose();
         _selectedProp = null;
      }
      
      public function drawAxis(param1:Matrix4) : void
      {
         var loc2:Graphics = this.axisIndicatorOverlay.graphics;
         var loc3:Number = this.axisIndicatorSize;
         loc2.clear();
         loc2.lineStyle(2,16711680);
         loc2.moveTo(loc3,0);
         loc2.lineTo(param1.a * this.axisIndicatorSize + loc3,param1.b * this.axisIndicatorSize + 0);
         loc2.lineStyle(2,65280);
         loc2.moveTo(loc3,0);
         loc2.lineTo(param1.e * this.axisIndicatorSize + loc3,param1.f * this.axisIndicatorSize + 0);
         loc2.lineStyle(2,255);
         loc2.moveTo(loc3,0);
         loc2.lineTo(param1.i * this.axisIndicatorSize + loc3,param1.j * this.axisIndicatorSize + 0);
      }
      
      public function set visible(visible:Boolean) : void
      {
         if (_visible == visible)
            return;
         _visible = visible;
         if (_selectedProp != null)
         {
            _selectedProp.visible = visible;
            if (visible)
            {
               checkForConflicts();
            }
         }
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function moveByArrows(param1:uint) : void
      {
         this.mainScene.move(this._selectedProp,param1);
         this.checkForConflicts();
      }
      
      public function viewResize(param1:Number, param2:Number) : void
      {
         //super.viewResize(param1,param2);
         this.axisIndicatorOverlay.y = this.mainScene.view.height - this.axisIndicatorSize;
      }
      
      public function rotateCursorCounterClockwise() : void
      {
         this.mainScene.rotatePropsCounterClockwise(this.getCursorObjectSet());
         this.snapCursorToGrid();
      }
      
      public function rotateCursorClockwise() : void
      {
         this.mainScene.rotatePropsClockwise(this.getCursorObjectSet());
         this.snapCursorToGrid();
      }
      
      private function getCursorObjectSet() : Set
      {
         selectedObjectSet.clear();
         selectedObjectSet.add(this._selectedProp);
         return selectedObjectSet;
      }
      
      private function snapCursorToGrid() : void
      {
         if(this._snapMode || this._selectedProp is MeshProp && !(this._selectedProp is Sprite3DProp))
         {
            this._selectedProp.snapToGrid();
         }
      }
   }
}

