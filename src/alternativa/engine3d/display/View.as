package alternativa.engine3d.display
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sprite3D;
   import alternativa.engine3d.core.SpritePrimitive;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.events.MouseEvent3D;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   use namespace alternativa3d;
   
   public class View extends Sprite
   {
      alternativa3d var canvas:Sprite;
      
      private var _camera:Camera3D;
      
      alternativa3d var _width:Number;
      
      alternativa3d var _height:Number;
      
      alternativa3d var _interactive:Boolean;
      
      private var faceUnderPoint:Face;
      
      private var objectUnderPoint:Object3D;
      
      private var lastMouseEvent:MouseEvent;
      
      private var stagePoint:Point;
      
      private var currentFace:Face;
      
      private var currentSurface:Surface;
      
      private var currentObject:Object3D;
      
      private var pressedFace:Face;
      
      private var pressedSurface:Surface;
      
      private var pressedObject:Object3D;
      
      private var lineVector:Point3D;
      
      private var linePoint:Point3D;
      
      private var globalCursor3DCoords:Point3D;
      
      private var localCursor3DCoords:Point3D;
      
      private var uvPoint:Point;
      
      private var inverseMatrix:Matrix3D;
      
      public function View(param1:Camera3D = null, param2:Number = 0, param3:Number = 0)
      {
         this.stagePoint = new Point();
         this.lineVector = new Point3D();
         this.linePoint = new Point3D();
         this.globalCursor3DCoords = new Point3D();
         this.localCursor3DCoords = new Point3D();
         this.uvPoint = new Point();
         this.inverseMatrix = new Matrix3D();
         super();
         this.alternativa3d::canvas = new Sprite();
         this.alternativa3d::canvas.mouseEnabled = false;
         this.alternativa3d::canvas.mouseChildren = false;
         this.alternativa3d::canvas.tabEnabled = false;
         this.alternativa3d::canvas.tabChildren = false;
         addChild(this.alternativa3d::canvas);
         this.camera = param1;
         this.width = param2;
         this.height = param3;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function get camera() : Camera3D
      {
         return this._camera;
      }
      
      public function set camera(param1:Camera3D) : void
      {
         var loc2:Skin = null;
         var loc3:Skin = null;
         if(this._camera != param1)
         {
            if(this._camera != null)
            {
               this._camera.alternativa3d::removeFromView(this);
            }
            if(param1 != null)
            {
               if(param1.alternativa3d::_view != null)
               {
                  param1.alternativa3d::_view.camera = null;
               }
               param1.alternativa3d::addToView(this);
            }
            else if(this.alternativa3d::canvas.numChildren > 0)
            {
               loc2 = Skin(this.alternativa3d::canvas.getChildAt(0));
               while(loc2 != null)
               {
                  loc3 = loc2.alternativa3d::nextSkin;
                  this.alternativa3d::canvas.removeChild(loc2);
                  if(loc2.alternativa3d::material != null)
                  {
                     loc2.alternativa3d::material.alternativa3d::clear(loc2);
                  }
                  loc2.alternativa3d::nextSkin = null;
                  loc2.alternativa3d::primitive = null;
                  loc2.alternativa3d::material = null;
                  Skin.alternativa3d::destroySkin(loc2);
                  loc2 = loc3;
               }
            }
            this._camera = param1;
         }
      }
      
      override public function get width() : Number
      {
         return this.alternativa3d::_width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this.alternativa3d::_width != param1)
         {
            this.alternativa3d::_width = param1;
            this.alternativa3d::canvas.x = this.alternativa3d::_width * 0.5;
            if(this._camera != null)
            {
               this.camera.alternativa3d::addOperationToScene(this.camera.alternativa3d::calculatePlanesOperation);
            }
         }
      }
      
      override public function get height() : Number
      {
         return this.alternativa3d::_height;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this.alternativa3d::_height != param1)
         {
            this.alternativa3d::_height = param1;
            this.alternativa3d::canvas.y = this.alternativa3d::_height * 0.5;
            if(this._camera != null)
            {
               this.camera.alternativa3d::addOperationToScene(this.camera.alternativa3d::calculatePlanesOperation);
            }
         }
      }
      
      public function getObjectUnderPoint(param1:Point) : Object
      {
         var loc4:Skin = null;
         if(stage == null)
         {
            return null;
         }
         var loc2:Point = localToGlobal(param1);
         var loc3:Array = stage.getObjectsUnderPoint(loc2);
         var loc5:int = int(loc3.length - 1);
         while(loc5 >= 0)
         {
            loc4 = loc3[loc5] as Skin;
            if(loc4 != null && loc4.parent.parent == this)
            {
               return loc4.alternativa3d::primitive.alternativa3d::face != null ? loc4.alternativa3d::primitive.alternativa3d::face : (loc4.alternativa3d::primitive as SpritePrimitive).alternativa3d::sprite;
            }
            loc5--;
         }
         return null;
      }
      
      override public function getObjectsUnderPoint(param1:Point) : Array
      {
         var loc7:Skin = null;
         if(stage == null)
         {
            return null;
         }
         var loc2:Point = localToGlobal(param1);
         var loc3:Array = stage.getObjectsUnderPoint(loc2);
         var loc4:Array = new Array();
         var loc5:uint = loc3.length;
         var loc6:uint = 0;
         while(loc6 < loc5)
         {
            loc7 = loc3[loc6] as Skin;
            if(loc7 != null && loc7.parent.parent == this)
            {
               if(loc7.alternativa3d::primitive.alternativa3d::face != null)
               {
                  loc4.push(loc7.alternativa3d::primitive.alternativa3d::face);
               }
               else
               {
                  loc4.push((loc7.alternativa3d::primitive as SpritePrimitive).alternativa3d::sprite);
               }
            }
            loc6++;
         }
         return loc4;
      }
      
      public function projectPoint(param1:Point3D) : Point3D
      {
         var loc4:Number = NaN;
         if(this._camera == null || this._camera.alternativa3d::_scene == null)
         {
            return null;
         }
         var loc2:Matrix3D = Object3D.alternativa3d::matrix2;
         var loc3:Number = this._camera.alternativa3d::_focalLength;
         if(this._camera.alternativa3d::getTransformation(loc2))
         {
            loc2.invert();
            if(this._camera.alternativa3d::_orthographic)
            {
               loc4 = this._camera.zoom;
               loc2.scale(loc4,loc4,loc4);
            }
         }
         else if(this._camera.alternativa3d::_orthographic && this._camera.alternativa3d::calculateMatrixOperation.alternativa3d::queued)
         {
            loc2.invert();
            loc4 = this._camera.zoom;
            loc2.scale(loc4,loc4,loc4);
         }
         else
         {
            loc2 = this._camera.alternativa3d::cameraMatrix;
         }
         if(!this._camera.alternativa3d::_orthographic && this._camera.alternativa3d::calculatePlanesOperation.alternativa3d::queued)
         {
            loc3 = 0.5 * Math.sqrt(this.alternativa3d::_height * this.alternativa3d::_height + this.alternativa3d::_width * this.alternativa3d::_width) / Math.tan(0.5 * this._camera.alternativa3d::_fov);
         }
         var loc5:Number = loc2.a * param1.x + loc2.b * param1.y + loc2.c * param1.z + loc2.d;
         var loc6:Number = loc2.e * param1.x + loc2.f * param1.y + loc2.g * param1.z + loc2.h;
         var loc7:Number = loc2.i * param1.x + loc2.j * param1.y + loc2.k * param1.z + loc2.l;
         if(this._camera.alternativa3d::_orthographic)
         {
            return new Point3D(loc5 + (this.alternativa3d::_width >> 1),loc6 + (this.alternativa3d::_height >> 1),loc7);
         }
         return new Point3D(loc5 * loc3 / loc7 + (this.alternativa3d::_width >> 1),loc6 * loc3 / loc7 + (this.alternativa3d::_height >> 1),loc7);
      }
      
      public function get interactive() : Boolean
      {
         return this.alternativa3d::_interactive;
      }
      
      public function set interactive(param1:Boolean) : void
      {
         if(this.alternativa3d::_interactive == param1)
         {
            return;
         }
         this.alternativa3d::_interactive = param1;
         if(this.alternativa3d::_interactive)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
            if(stage != null)
            {
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageMouseUp);
            }
            this.pressedFace = this.currentFace = null;
            this.pressedSurface = this.currentSurface = null;
            this.pressedObject = this.currentObject = null;
         }
      }
      
      public function projectViewPointToPlane(param1:Point, param2:Point3D, param3:Number, param4:Point3D = null) : Point3D
      {
         if(this._camera == null || this._camera.alternativa3d::_scene == null)
         {
            return null;
         }
         if(param4 == null)
         {
            param4 = new Point3D();
         }
         this.calculateRayOriginAndVector(param1.x - (this.alternativa3d::_width >> 1),param1.y - (this.alternativa3d::_height >> 1),this.linePoint,this.lineVector,true);
         if(!this.calculateLineAndPlaneIntersection(this.linePoint,this.lineVector,param2,param3,param4))
         {
            param4.reset(NaN,NaN,NaN);
         }
         return param4;
      }
      
      public function get3DCoords(param1:Point, param2:Number, param3:Point3D = null) : Point3D
      {
         var loc4:Number = NaN;
         if(this._camera == null)
         {
            return null;
         }
         if(param3 == null)
         {
            param3 = new Point3D();
         }
         if(this._camera.alternativa3d::_orthographic)
         {
            param3.x = (param1.x - (this.alternativa3d::_width >> 1)) / this.camera.alternativa3d::_zoom;
            param3.y = (param1.y - (this.alternativa3d::_height >> 1)) / this.camera.alternativa3d::_zoom;
         }
         else
         {
            loc4 = param2 / this._camera.focalLength;
            param3.x = (param1.x - (this.alternativa3d::_width >> 1)) * loc4;
            param3.y = (param1.y - (this.alternativa3d::_height >> 1)) * loc4;
         }
         param3.z = param2;
         return param3;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.interactive = false;
      }
      
      private function stageMouseUp(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.pressedFace = null;
         this.pressedSurface = null;
         this.pressedObject = null;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageMouseUp);
      }
      
      private function getInteractiveObjectUnderPoint(param1:Number, param2:Number) : void
      {
         var loc4:Skin = null;
         var loc6:Sprite3D = null;
         if(stage == null)
         {
            return;
         }
         this.faceUnderPoint = null;
         this.objectUnderPoint = null;
         this.stagePoint.x = param1;
         this.stagePoint.y = param2;
         var loc3:Array = stage.getObjectsUnderPoint(this.stagePoint);
         var loc5:int = int(loc3.length - 1);
         while(loc5 >= 0)
         {
            loc4 = loc3[loc5] as Skin;
            if(loc4 != null && loc4.parent.parent == this)
            {
               if(loc4.alternativa3d::primitive.alternativa3d::face != null)
               {
                  if(loc4.alternativa3d::primitive.alternativa3d::face.alternativa3d::_mesh.mouseEnabled)
                  {
                     this.faceUnderPoint = loc4.alternativa3d::primitive.alternativa3d::face;
                     this.objectUnderPoint = this.faceUnderPoint.alternativa3d::_mesh;
                     return;
                  }
               }
               else
               {
                  loc6 = (loc4.alternativa3d::primitive as SpritePrimitive).alternativa3d::sprite;
                  if(loc6.mouseEnabled)
                  {
                     this.objectUnderPoint = loc6;
                     return;
                  }
               }
            }
            loc5--;
         }
      }
      
      private function getInteractiveObjectPointProperties(param1:Number, param2:Number) : void
      {
         var loc3:Point3D = null;
         var loc4:Number = NaN;
         var loc5:Point = null;
         if(this.objectUnderPoint == null)
         {
            return;
         }
         this.calculateRayOriginAndVector(param1,param2,this.linePoint,this.lineVector);
         if(this.faceUnderPoint != null)
         {
            loc3 = this.faceUnderPoint.alternativa3d::globalNormal;
            loc4 = this.faceUnderPoint.alternativa3d::globalOffset;
         }
         else
         {
            loc3 = this.lineVector.clone();
            loc3.invert();
            this.globalCursor3DCoords.copy(this.objectUnderPoint.alternativa3d::_coords);
            this.globalCursor3DCoords.transform(this.objectUnderPoint.alternativa3d::_transformation);
            loc4 = this.globalCursor3DCoords.dot(loc3);
         }
         this.calculateLineAndPlaneIntersection(this.linePoint,this.lineVector,loc3,loc4,this.globalCursor3DCoords);
         this.inverseMatrix.copy((this.faceUnderPoint != null ? this.faceUnderPoint.alternativa3d::_mesh : this.objectUnderPoint)._transformation);
         this.inverseMatrix.invert();
         this.localCursor3DCoords.copy(this.globalCursor3DCoords);
         this.localCursor3DCoords.transform(this.inverseMatrix);
         if(this.faceUnderPoint != null)
         {
            loc5 = this.faceUnderPoint.getUV(this.localCursor3DCoords);
            if(loc5 != null)
            {
               this.uvPoint.x = loc5.x;
               this.uvPoint.y = loc5.y;
            }
            else
            {
               this.uvPoint.x = NaN;
               this.uvPoint.y = NaN;
            }
         }
      }
      
      private function createSimpleMouseEvent3D(param1:String, param2:Object3D, param3:Surface, param4:Face) : MouseEvent3D
      {
         var loc5:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.altKey;
         var loc6:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.ctrlKey;
         var loc7:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.shiftKey;
         var loc8:int = this.lastMouseEvent == null ? 0 : this.lastMouseEvent.delta;
         return new MouseEvent3D(param1,this,param2,param3,param4,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,loc5,loc6,loc7,loc8);
      }
      
      private function createFullMouseEvent3D(param1:String, param2:Object3D, param3:Surface, param4:Face) : MouseEvent3D
      {
         var loc5:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.altKey;
         var loc6:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.ctrlKey;
         var loc7:Boolean = this.lastMouseEvent == null ? false : this.lastMouseEvent.shiftKey;
         var loc8:int = this.lastMouseEvent == null ? 0 : this.lastMouseEvent.delta;
         return new MouseEvent3D(param1,this,param2,param3,param4,this.globalCursor3DCoords.x,this.globalCursor3DCoords.y,this.globalCursor3DCoords.z,this.localCursor3DCoords.x,this.localCursor3DCoords.y,this.localCursor3DCoords.z,this.uvPoint.x,this.uvPoint.y,loc5,loc6,loc7,loc8);
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.lastMouseEvent = param1;
         this.getInteractiveObjectUnderPoint(stage.mouseX,stage.mouseY);
         this.getInteractiveObjectPointProperties(mouseX - (this.alternativa3d::_width >> 1),mouseY - (this.alternativa3d::_height >> 1));
         switch(param1.type)
         {
            case MouseEvent.MOUSE_MOVE:
               this.processMouseMove();
               break;
            case MouseEvent.MOUSE_OUT:
               stage.addEventListener(MouseEvent.MOUSE_UP,this.stageMouseUp);
               this.alternativa3d::checkMouseOverOut();
               break;
            case MouseEvent.MOUSE_DOWN:
               this.processMouseDown();
               break;
            case MouseEvent.MOUSE_UP:
               this.processMouseUp();
               break;
            case MouseEvent.MOUSE_WHEEL:
               this.processMouseWheel();
         }
         this.lastMouseEvent = null;
      }
      
      private function processMouseDown() : void
      {
         var loc1:MouseEvent3D = null;
         if(this.objectUnderPoint == null)
         {
            return;
         }
         if(this.faceUnderPoint != null)
         {
            this.currentFace = this.faceUnderPoint;
            this.currentSurface = this.faceUnderPoint.alternativa3d::_surface;
         }
         else
         {
            this.currentFace = null;
            this.currentSurface = null;
         }
         this.currentObject = this.pressedObject = this.objectUnderPoint;
         if(this.currentFace != null && this.currentFace.mouseEnabled)
         {
            this.pressedFace = this.currentFace;
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_DOWN,this.currentObject,this.currentSurface,this.currentFace);
            this.currentFace.dispatchEvent(loc1);
         }
         if(this.currentSurface != null && this.currentSurface.mouseEnabled)
         {
            this.pressedSurface = this.currentSurface;
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_DOWN,this.currentObject,this.currentSurface,this.currentFace);
            this.currentSurface.dispatchEvent(loc1);
         }
         loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_DOWN,this.currentObject,this.currentSurface,this.currentFace);
         this.currentObject.dispatchEvent(loc1);
      }
      
      private function processMouseUp() : void
      {
         var loc1:MouseEvent3D = null;
         if(this.objectUnderPoint == null)
         {
            this.pressedFace = null;
            this.pressedSurface = null;
            this.pressedObject = null;
            return;
         }
         if(this.faceUnderPoint != null)
         {
            this.currentFace = this.faceUnderPoint;
            this.currentSurface = this.faceUnderPoint.alternativa3d::_surface;
         }
         else
         {
            this.currentFace = null;
            this.currentSurface = null;
         }
         this.currentObject = this.objectUnderPoint;
         if(this.currentFace != null && this.currentFace.mouseEnabled)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_UP,this.currentObject,this.currentSurface,this.currentFace);
            this.currentFace.dispatchEvent(loc1);
         }
         if(this.currentSurface != null && this.currentSurface.mouseEnabled)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_UP,this.currentObject,this.currentSurface,this.currentFace);
            this.currentSurface.dispatchEvent(loc1);
         }
         loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_UP,this.currentObject,this.currentSurface,this.currentFace);
         this.currentObject.dispatchEvent(loc1);
         if(this.currentFace != null && this.currentFace == this.pressedFace && this.currentFace.mouseEnabled)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.CLICK,this.currentObject,this.currentSurface,this.currentFace);
            this.currentFace.dispatchEvent(loc1);
         }
         if(this.currentSurface != null && this.currentSurface == this.pressedSurface && this.currentSurface.mouseEnabled)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.CLICK,this.currentObject,this.currentSurface,this.currentFace);
            this.currentSurface.dispatchEvent(loc1);
         }
         if(this.currentObject == this.pressedObject)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.CLICK,this.currentObject,this.currentSurface,this.currentFace);
            this.currentObject.dispatchEvent(loc1);
         }
         this.pressedFace = null;
         this.pressedSurface = null;
         this.pressedObject = null;
      }
      
      private function processMouseWheel() : void
      {
         var loc1:MouseEvent3D = null;
         if(this.objectUnderPoint == null)
         {
            return;
         }
         if(this.faceUnderPoint != null)
         {
            this.currentFace = this.faceUnderPoint;
            this.currentSurface = this.faceUnderPoint.alternativa3d::_surface;
            if(this.currentFace.mouseEnabled)
            {
               loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_WHEEL,this.currentObject,this.currentSurface,this.currentFace);
               this.currentFace.dispatchEvent(loc1);
            }
            if(this.currentSurface.mouseEnabled)
            {
               loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_WHEEL,this.currentObject,this.currentSurface,this.currentFace);
               this.currentSurface.dispatchEvent(loc1);
            }
         }
         else
         {
            this.currentFace = null;
            this.currentSurface = null;
         }
         this.currentObject = this.objectUnderPoint;
         loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_WHEEL,this.currentObject,this.currentSurface,this.currentFace);
         this.currentObject.dispatchEvent(loc1);
      }
      
      alternativa3d function checkMouseOverOut(param1:Boolean = false) : void
      {
         var loc2:MouseEvent3D = null;
         var loc3:Surface = null;
         var loc4:Boolean = false;
         var loc5:Boolean = false;
         var loc6:Boolean = false;
         if(stage == null)
         {
            return;
         }
         if(param1)
         {
            this.getInteractiveObjectUnderPoint(stage.mouseX,stage.mouseY);
            this.getInteractiveObjectPointProperties(mouseX - (this.alternativa3d::_width >> 1),mouseY - (this.alternativa3d::_height >> 1));
         }
         if(this.objectUnderPoint == null)
         {
            if(this.currentFace != null)
            {
               if(this.currentFace.mouseEnabled)
               {
                  loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentFace.dispatchEvent(loc2);
               }
               if(this.currentSurface.mouseEnabled)
               {
                  loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentSurface.dispatchEvent(loc2);
               }
            }
            if(this.currentObject != null)
            {
               loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
               this.currentObject.dispatchEvent(loc2);
            }
            this.currentFace = null;
            this.currentSurface = null;
            this.currentObject = null;
         }
         else
         {
            if(this.faceUnderPoint != null)
            {
               loc3 = this.faceUnderPoint.alternativa3d::_surface;
            }
            if(this.faceUnderPoint != this.currentFace)
            {
               if(this.currentFace != null && this.currentFace.mouseEnabled)
               {
                  loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentFace.dispatchEvent(loc2);
               }
               loc4 = true;
               if(loc3 != this.currentSurface)
               {
                  if(this.currentSurface != null && this.currentSurface.mouseEnabled)
                  {
                     loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
                     this.currentSurface.dispatchEvent(loc2);
                  }
                  loc5 = true;
               }
            }
            if(this.objectUnderPoint != this.currentObject)
            {
               if(this.currentObject != null)
               {
                  loc2 = this.createSimpleMouseEvent3D(MouseEvent3D.MOUSE_OUT,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentObject.dispatchEvent(loc2);
               }
               loc6 = true;
            }
            this.currentFace = this.faceUnderPoint;
            this.currentSurface = loc3;
            this.currentObject = this.objectUnderPoint;
            if(this.currentFace != null)
            {
               if(loc4 && this.currentFace.mouseEnabled)
               {
                  loc2 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_OVER,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentFace.dispatchEvent(loc2);
               }
               if(loc5 && this.currentSurface.mouseEnabled)
               {
                  loc2 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_OVER,this.currentObject,this.currentSurface,this.currentFace);
                  this.currentSurface.dispatchEvent(loc2);
               }
            }
            if(loc6)
            {
               loc2 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_OVER,this.currentObject,this.currentSurface,this.currentFace);
               this.currentObject.dispatchEvent(loc2);
            }
         }
      }
      
      private function processMouseMove() : void
      {
         var loc1:MouseEvent3D = null;
         this.alternativa3d::checkMouseOverOut();
         if(this.currentFace != null)
         {
            if(this.currentFace.mouseEnabled)
            {
               loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_MOVE,this.currentObject,this.currentSurface,this.currentFace);
               this.currentFace.dispatchEvent(loc1);
            }
            if(this.currentSurface.mouseEnabled)
            {
               loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_MOVE,this.currentObject,this.currentSurface,this.currentFace);
               this.currentSurface.dispatchEvent(loc1);
            }
         }
         if(this.currentObject != null)
         {
            loc1 = this.createFullMouseEvent3D(MouseEvent3D.MOUSE_MOVE,this.currentObject,this.currentSurface,this.currentFace);
            this.currentObject.dispatchEvent(loc1);
         }
      }
      
      private function calculateLineAndPlaneIntersection(param1:Point3D, param2:Point3D, param3:Point3D, param4:Number, param5:Point3D) : Boolean
      {
         var loc6:Number = param3.x * param2.x + param3.y * param2.y + param3.z * param2.z;
         if(loc6 < 1e-8 && loc6 > -1e-8)
         {
            return false;
         }
         var loc7:Number = (param4 - param1.x * param3.x - param1.y * param3.y - param1.z * param3.z) / loc6;
         param5.x = param1.x + loc7 * param2.x;
         param5.y = param1.y + loc7 * param2.y;
         param5.z = param1.z + loc7 * param2.z;
         return true;
      }
      
      private function calculateRayOriginAndVector(param1:Number, param2:Number, param3:Point3D, param4:Point3D, param5:Boolean = false) : void
      {
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Number = NaN;
         var loc9:Matrix3D = null;
         if(param5)
         {
            loc9 = Object3D.alternativa3d::matrix2;
            this._camera.alternativa3d::getTransformation(loc9);
         }
         else
         {
            loc9 = this._camera.alternativa3d::_transformation;
         }
         if(this._camera.alternativa3d::_orthographic)
         {
            loc6 = param1 / this._camera.zoom;
            loc7 = param2 / this._camera.zoom;
            param3.x = loc9.a * loc6 + loc9.b * loc7 + loc9.d;
            param3.y = loc9.e * loc6 + loc9.f * loc7 + loc9.h;
            param3.z = loc9.i * loc6 + loc9.j * loc7 + loc9.l;
            loc7 = 0;
            loc6 = 0;
            loc8 = 1;
         }
         else
         {
            param3.x = loc9.d;
            param3.y = loc9.h;
            param3.z = loc9.l;
            loc6 = param1;
            loc7 = param2;
            if(param5)
            {
               loc8 = this._camera.focalLength;
            }
            else
            {
               loc8 = this._camera.alternativa3d::_focalLength;
            }
         }
         this.lineVector.x = loc6 * loc9.a + loc7 * loc9.b + loc8 * loc9.c;
         this.lineVector.y = loc6 * loc9.e + loc7 * loc9.f + loc8 * loc9.g;
         this.lineVector.z = loc6 * loc9.i + loc7 * loc9.j + loc8 * loc9.k;
      }
   }
}

