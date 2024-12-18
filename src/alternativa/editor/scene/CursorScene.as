package alternativa.editor.scene
{
   import alternativa.editor.prop.CustomFillMaterial;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.editor.engine3d.controllers.WalkController;
   import alternativa.engine3d.materials.Material;
   import alternativa.types.Matrix4;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.Vector3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.Sprite;
   import mx.controls.Alert;
   
   public class CursorScene
   {
      private static var redClass:Class = CursorScene_redClass;
      
      private static const redBmp:BitmapData = new redClass().bitmapData;
      
      private static var greenClass:Class = CursorScene_greenClass;
      
      private static const greenBmp:BitmapData = new greenClass().bitmapData;
      
      protected var _object:Prop;
      
      private var redMaterial:Material;
      
      private var greenMaterial:Material;
      
      private var material:Material;
      
      private var _freeState:Boolean = true;
      
      public var cameraController:WalkController;
      
      public var containerController:WalkController;
      
      public var container:Object3DContainer;
      
      private var eventSourceObject:DisplayObject;
      
      protected var _snapMode:Boolean = true;
      
      private var axisIndicatorOverlay:Shape;
      
      private var axisIndicatorSize:Number = 30;
      
      private var _visible:Boolean = false;

      private var mainScene:MainScene;
      
      public function CursorScene(param1:DisplayObject, container:Sprite, mainScene:MainScene)
      {
         super();
         this.eventSourceObject = param1;
         this.mainScene = mainScene;
         this.initControllers();
         container.addChild(this.axisIndicatorOverlay = new Shape());
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
      }
      
      public function set object(param1:Prop) : void
      {
         var loc2:Vector3D = null;
         if(this._object)
         {
            loc2 = new Vector3D(this._object.x,this._object.y,this._object.z);
            if(this._visible)
            {
               this.mainScene.root.removeChild(this._object);
            }
         }
         this._object = param1;
         this.material = this._object.material.clone();
         //this.material.alpha = 0.5;
         this._object.alpha = 0.5;
         if(loc2)
         {
            this._object.setPositionFromVector3(loc2);
         }
         if(this._visible)
         {
            this.mainScene.root.addChild(this._object);
         }
         if(this._snapMode || this._object is MeshProp && !(this._object is Sprite3DProp))
         {
            this.snapObject();
         }
         this.updateMaterial();
      }
      
      public function get object() : Prop
      {
         return this._object;
      }
      
      public function set snapMode(param1:Boolean) : void
      {
         if(this._snapMode != param1 && Boolean(this._object))
         {
            this._snapMode = param1;
            if(param1)
            {
               this.snapObject();
            }
            else
            {
               this._object.setMaterial(this.material);
            }
         }
      }
      
      private function snapObject() : void
      {
         this.createMaterials();
         this._object.snapToGrid();
      }
      
      private function createMaterials() : void
      {
         if(_object.bitmapData == null)
         {
            Alert.show("No texture on " + _object.name + ", " + _object.groupName + ", " + _object.libraryName + ", " + (_object as MeshProp).textureName);
            return;
         }
         var loc1:BitmapData = this._object.bitmapData.clone();
         var loc2:BitmapData = loc1.clone();
         var loc3:Matrix = new Matrix();
         loc3.a = loc1.width / redBmp.width;
         loc3.d = loc3.a;
         loc1.draw(redBmp,loc3,null,BlendMode.HARDLIGHT);
         loc2.draw(greenBmp,loc3,null,BlendMode.HARDLIGHT);
         if(this._object is Sprite3DProp)
         {
            this.greenMaterial = new TextureMaterial(loc2);
            this.redMaterial = new TextureMaterial(loc1);
         }
         else
         {
            this.greenMaterial = new CustomFillMaterial(new Point3D(-10000000000,-7000000000,4000000000),65280);
            this.redMaterial = new CustomFillMaterial(new Point3D(-10000000000,-7000000000,4000000000),16711680);
         }
         //this.greenMaterial.alpha = 0.8;
         //this.redMaterial.alpha = 0.8;
         this._object.alpha = 0.8;
      }
      
      public function moveCursorByMouse() : void
      {
         var loc1:Vector3D = null;
         if(this._object)
         {
            loc1 = this.mainScene.camera.projectGlobal(new Vector3D(this.mainScene.view.mouseX,this.mainScene.view.mouseY,this._object.z));
            this._object.x = loc1.x;
            this._object.y = loc1.y;
            if(this._snapMode || this._object is MeshProp && !(this._object is Sprite3DProp))
            {
               this._object.snapToGrid();
            }
            this.updateMaterial();
         }
      }
      
      public function get freeState() : Boolean
      {
         return this._freeState;
      }
      
      public function updateMaterial() : void
      {
         if(this._object)
         {
            if(this._snapMode)
            {
               if(this.mainScene.occupyMap.isConflict(this._object))
               {
                  this._freeState = false;
                  this._object.setMaterial(this.redMaterial);
               }
               else
               {
                  this._freeState = true;
                  this._object.setMaterial(this.greenMaterial);
               }
            }
            else
            {
               this._object.setMaterial(this.material);
            }
         }
      }
      
      public function clear() : void
      {
         if(this._object)
         {
            if(this.mainScene.root.getChildByName(this._object.name))
            {
               this.mainScene.root.removeChild(this._object);
            }
            this._object = null;
            this._visible = false;
         }
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
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 != this._visible)
         {
            this._visible = param1;
            if(this._object)
            {
               if(this._visible)
               {
                  this.mainScene.root.addChild(this._object);
                  this.updateMaterial();
               }
               else
               {
                  this.mainScene.root.removeChild(this._object);
               }
            }
         }
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function moveByArrows(param1:uint) : void
      {
         this.mainScene.move(this._object,param1);
         this.updateMaterial();
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
         var loc1:Set = new Set();
         loc1.add(this._object);
         return loc1;
      }
      
      private function snapCursorToGrid() : void
      {
         if(this._snapMode || this._object is MeshProp && !(this._object is Sprite3DProp))
         {
            this._object.snapToGrid();
         }
      }
   }
}

