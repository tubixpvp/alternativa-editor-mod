package alternativa.editor
{
   import alternativa.editor.eventjournal.EventJournal;
   import alternativa.editor.eventjournal.EventJournalItem;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.scene.CursorScene;
   import alternativa.editor.scene.EditorScene;
   import alternativa.editor.scene.MainScene;
   import alternativa.editor.scene.OccupyMap;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.events.MouseEvent3D;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import alternativa.utils.KeyboardUtils;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import mx.controls.Alert;
   import mx.core.UIComponent;
   import mx.events.CloseEvent;
   
   use namespace alternativa3d;
   
   public class SceneContainer extends UIComponent
   {
      private static const cameraPoint:Point3D = new Point3D(0,0,1000);
      
      private static const cameraOffset:Point3D = new Point3D();
      
      public var cursorScene:CursorScene;
      
      public var mainScene:MainScene;
      
      public var multiplePropMode:MultiPropMode;
      
      private var verticalMoving:Boolean = false;
      
      private var copy:Boolean = false;
      
      private var mouseDown:Boolean;
      
      private var eventJournal:EventJournal;
      
      private var cameraTransformation:Matrix3D;
      
      private var _snapMode:Boolean;
      
      private var cameraDistance:Number;
      
      private var selectionRectOverlay:Shape;
      
      private var keyMapper:KeyMapper;
      
      private var boundBoxesOverlay:Shape;
      
      private var dominationOverlay:Shape;
      
      private var _showBoundBoxes:Boolean;
      
      private var mouseDownPoint:Point;
      
      private var startSelectionCoords:Point3D;
      
      private var prevMoveX:Number;
      
      private var prevMoveY:Number;
      
      private var rectProps:Set;
      
      private var middleDown:Boolean = false;
      
      private var mouseOX:Number = 0;
      
      private var mouseOY:Number = 0;
      
      private var leaveClickZone:Boolean;
      
      private var cloneThreshold:Number = 20;
      
      private var min:Point3D;
      
      private var max:Point3D;
      
      private var bbPoints:Array;
      
      private var clickZ:Number;
      
      private var propDown:Boolean = false;
      
      public function SceneContainer()
      {
         this.multiplePropMode = MultiPropMode.NONE;
         this.mouseDownPoint = new Point();
         this.rectProps = new Set();
         this.min = new Point3D();
         this.max = new Point3D();
         this.bbPoints = [new Point3D(),new Point3D(),new Point3D(),new Point3D(),new Point3D(),new Point3D(),new Point3D(),new Point3D()];
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.initKeyMapper();
      }
      
      private static function getMeshBounds(param1:Mesh, param2:Point3D, param3:Point3D) : void
      {
         var loc4:Vertex = null;
         var loc5:Point3D = null;
         param2.reset(10000000000,10000000000,10000000000);
         param3.reset(-10000000000,-10000000000,-10000000000);
         for each(loc4 in param1.alternativa3d::_vertices)
         {
            loc5 = loc4.alternativa3d::globalCoords;
            if(loc5.x < param2.x)
            {
               param2.x = loc5.x;
            }
            if(loc5.y < param2.y)
            {
               param2.y = loc5.y;
            }
            if(loc5.z < param2.z)
            {
               param2.z = loc5.z;
            }
            if(loc5.x > param3.x)
            {
               param3.x = loc5.x;
            }
            if(loc5.y > param3.y)
            {
               param3.y = loc5.y;
            }
            if(loc5.z > param3.z)
            {
               param3.z = loc5.z;
            }
         }
      }
      
      private static function fillBBPoints(param1:Point3D, param2:Point3D, param3:Array) : void
      {
         var loc4:Point3D = param3[0];
         loc4.copy(param1);
         loc4 = param3[1];
         loc4.reset(param2.x,param1.y,param1.z);
         loc4 = param3[2];
         loc4.reset(param2.x,param1.y,param2.z);
         loc4 = param3[3];
         loc4.reset(param1.x,param1.y,param2.z);
         loc4 = param3[4];
         loc4.reset(param1.x,param2.y,param1.z);
         loc4 = param3[5];
         loc4.reset(param2.x,param2.y,param1.z);
         loc4 = param3[6];
         loc4.reset(param2.x,param2.y,param2.z);
         loc4 = param3[7];
         loc4.reset(param1.x,param2.y,param2.z);
      }
      
      public function get showBoundBoxes() : Boolean
      {
         return this._showBoundBoxes;
      }
      
      public function set showBoundBoxes(param1:Boolean) : void
      {
         this._showBoundBoxes = param1;
         if(!this._showBoundBoxes)
         {
            this.boundBoxesOverlay.graphics.clear();
         }
      }
      
      private function initKeyMapper() : void
      {
         this.keyMapper = new KeyMapper();
         this.keyMapper.mapKey(0,KeyboardUtils.N);
         this.keyMapper.mapKey(1,KeyboardUtils.M);
         this.keyMapper.mapKey(2,Keyboard.NUMPAD_4);
         this.keyMapper.mapKey(3,Keyboard.NUMPAD_6);
         this.keyMapper.mapKey(4,Keyboard.NUMPAD_8);
         this.keyMapper.mapKey(5,Keyboard.NUMPAD_2);
         this.keyMapper.mapKey(6,Keyboard.NUMPAD_9);
         this.keyMapper.mapKey(7,Keyboard.NUMPAD_3);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.keyMapper.startListening(stage);
         this.cursorScene = new CursorScene(stage);
         this.mainScene = new MainScene();
         this.cursorScene.occupyMap = this.mainScene.occupyMap;
         addChild(this.mainScene.view);
         addChild(this.cursorScene.view);
         this.boundBoxesOverlay = new Shape();
         addChild(this.boundBoxesOverlay);
         this.dominationOverlay = new Shape();
         addChild(this.dominationOverlay);
         this.selectionRectOverlay = new Shape();
         addChild(this.selectionRectOverlay);
         this.initListeners();
         this.eventJournal = new EventJournal();
         var loc2:Point3D = this.cursorScene.camera.coords;
         this.cameraDistance = Math.sqrt(loc2.x * loc2.x + loc2.y * loc2.y + loc2.z * loc2.z);
      }
      
      protected function initListeners() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         parent.addEventListener(Event.RESIZE,this.onResize);
         parent.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         parent.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         parent.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         parent.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.onMiddleMouseDown);
         parent.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onMiddleMouseDown);
         parent.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.onMiddleMouseUp);
         parent.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onMiddleMouseUp);
         parent.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.onResize();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.leaveClickZone = false;
         this.mouseOX = stage.mouseX;
         this.mouseOY = stage.mouseY;
         if(this.mainScene.propMouseDown)
         {
            if(this.mainScene.selectedProp != null)
            {
               this.startSelectionCoords = this.mainScene.selectedProp.coords;
               this.cursorScene.visible = false;
            }
         }
         this.mouseDown = true;
         this.mouseDownPoint.x = this.mainScene.view.mouseX;
         this.mouseDownPoint.y = this.mainScene.view.mouseY;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         var loc4:Boolean = false;
         var loc5:Point3D = null;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:* = undefined;
         var loc9:Prop = null;
         var loc2:Prop = this.mainScene.selectedProp;
         var loc3:Set = this.mainScene.selectedProps;
         if(this.mainScene.propMouseDown)
         {
            if(loc2)
            {
               loc4 = false;
               if(this.copy)
               {
                  this.eventJournal.addEvent(EventJournal.COPY,loc3.clone());
               }
               else if(!this.startSelectionCoords.equals(loc2.coords))
               {
                  loc5 = loc2.coords;
                  loc5.difference(loc5,this.startSelectionCoords);
                  this.eventJournal.addEvent(EventJournal.MOVE,loc3.clone(),loc5);
                  loc4 = true;
               }
               if(this._snapMode && (this.copy || loc4))
               {
                  this.checkConflict();
               }
               this.copy = false;
            }
            this.mainScene.propMouseDown = false;
         }
         else
         {
            loc6 = this.mouseDownPoint.x - this.mainScene.view.mouseX;
            loc7 = this.mouseDownPoint.y - this.mainScene.view.mouseY;
            loc6 = loc6 < 0 ? -loc6 : loc6;
            loc7 = loc7 < 0 ? -loc7 : loc7;
            if(loc6 < 3 && loc7 < 3)
            {
               if(this.propDown)
               {
                  if(this.cursorScene.object)
                  {
                     this.cursorScene.object.z = this.clickZ;
                  }
                  this.propDown = false;
               }
               this.cursorScene.moveCursorByMouse();
               if(!this.cursorScene.visible)
               {
                  this.mainScene.deselectProps();
                  this.cursorScene.visible = true;
               }
            }
            else if(param1.shiftKey)
            {
               for(loc8 in this.rectProps)
               {
                  loc9 = loc8;
                  if(param1.altKey)
                  {
                     if(loc3.has(loc9))
                     {
                        this.mainScene.deselectProp(loc9);
                     }
                  }
                  else if(!loc3.has(loc9))
                  {
                     this.mainScene.selectProp(loc9);
                  }
               }
            }
         }
         this.mouseDown = false;
         this.selectionRectOverlay.graphics.clear();
      }
      
      private function alertConflict(param1:CloseEvent) : void
      {
         if(param1.detail == Alert.NO)
         {
            this.mainScene.undo(this.eventJournal.undo(true));
         }
         setFocus();
      }
      
      private function checkConflict() : void
      {
         var loc1:Set = null;
         var loc2:OccupyMap = null;
         var loc3:* = undefined;
         var loc4:Prop = null;
         if(this.multiplePropMode != MultiPropMode.ANY)
         {
            loc1 = this.mainScene.selectedProps;
            loc2 = this.mainScene.occupyMap;
            for(loc3 in loc1)
            {
               loc4 = loc3;
               if(this.multiplePropMode == MultiPropMode.NONE && loc2.isConflict(loc4) || this.multiplePropMode == MultiPropMode.GROUP && loc2.isConflictGroup(loc4))
               {
                  Alert.show("This location is occupied. Continue?","",Alert.YES | Alert.NO,this,this.alertConflict,null,Alert.YES);
                  break;
               }
            }
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         var loc6:Set = null;
         var loc7:Point3D = null;
         var loc8:Prop = null;
         var loc9:Matrix3D = null;
         var loc10:Point3D = null;
         var loc11:Point3D = null;
         var loc12:Point3D = null;
         var loc13:Number = NaN;
         var loc14:Number = NaN;
         var loc15:Point = null;
         var loc16:Graphics = null;
         var loc17:Set = null;
         var loc4:Prop = this.mainScene.selectedProp;
         var loc5:Set = this.mainScene.selectedProps;
         if(Math.abs(this.mouseOX - stage.mouseX) + Math.abs(this.mouseOY - stage.mouseY) > this.cloneThreshold || this.leaveClickZone)
         {
            this.leaveClickZone = true;
            if(this.mainScene.propMouseDown && Boolean(loc4))
            {
               if(param1.shiftKey && !this.copy)
               {
                  if(!this.startSelectionCoords.equals(loc4.coords))
                  {
                     loc7 = loc4.coords;
                     loc7.difference(loc7,this.startSelectionCoords);
                     this.eventJournal.addEvent(EventJournal.MOVE,loc5.clone(),loc7);
                  }
                  loc6 = new Set();
                  for(loc2 in loc5)
                  {
                     loc3 = loc2 as Prop;
                     loc8 = this.mainScene.addProp(loc3,loc3.coords,loc3.rotationZ);
                     if(loc3 == loc4)
                     {
                        loc4 = loc8;
                     }
                     loc6.add(loc8);
                  }
                  this.mainScene.selectProps(loc6);
                  this.mainScene.selectedProp = loc4;
                  this.startSelectionCoords = loc4.coords;
                  this.copy = true;
               }
               this.mainScene.moveSelectedPropsByMouse(this.verticalMoving);
            }
            else if(this.middleDown)
            {
               loc9 = this.cursorScene.camera.transformation;
               loc10 = new Point3D(loc9.a,loc9.e,loc9.i);
               loc11 = new Point3D(loc9.b,loc9.f,loc9.j);
               loc10.multiply(10 * (this.prevMoveX - param1.stageX));
               loc11.multiply(10 * (this.prevMoveY - param1.stageY));
               loc12 = new Point3D(loc9.d,loc9.h,loc9.l);
               loc12.add(loc10);
               loc12.add(loc11);
               this.cursorScene.cameraController.coords = this.cursorScene.container.globalToLocal(loc12);
            }
            else if(this.mouseDown)
            {
               loc13 = this.mouseDownPoint.x - this.mainScene.view.mouseX;
               loc13 = loc13 > 0 ? loc13 : -loc13;
               loc14 = this.mouseDownPoint.y - this.mainScene.view.mouseY;
               loc14 = loc14 > 0 ? loc14 : -loc14;
               if(loc13 > 3 && loc14 > 3)
               {
                  loc15 = new Point(Math.min(this.mainScene.view.mouseX,this.mouseDownPoint.x),Math.min(this.mainScene.view.mouseY,this.mouseDownPoint.y));
                  loc16 = this.selectionRectOverlay.graphics;
                  loc16.clear();
                  loc16.lineStyle(0,0);
                  loc16.moveTo(loc15.x,loc15.y);
                  loc16.lineTo(loc15.x + loc13,loc15.y);
                  loc16.lineTo(loc15.x + loc13,loc15.y + loc14);
                  loc16.lineTo(loc15.x,loc15.y + loc14);
                  loc16.lineTo(loc15.x,loc15.y);
                  if(param1.shiftKey)
                  {
                     loc17 = this.rectProps.clone();
                     if(param1.altKey)
                     {
                        this.rectProps = this.mainScene.getPropsUnderRect(loc15,loc13,loc14,false);
                        for(loc2 in loc17)
                        {
                           loc3 = loc2;
                           if(!this.rectProps.has(loc3) && loc5.has(loc3))
                           {
                              loc3.select();
                           }
                        }
                     }
                     else
                     {
                        this.rectProps = this.mainScene.getPropsUnderRect(loc15,loc13,loc14,true);
                        for(loc2 in loc17)
                        {
                           loc3 = loc2;
                           if(!this.rectProps.has(loc3) && !loc5.has(loc3))
                           {
                              loc3.deselect();
                           }
                        }
                     }
                  }
                  else
                  {
                     this.mainScene.selectProps(this.mainScene.getPropsUnderRect(loc15,loc13,loc14,true));
                  }
                  this.cursorScene.visible = false;
               }
            }
         }
         this.prevMoveX = param1.stageX;
         this.prevMoveY = param1.stageY;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         var loc2:Number = param1.shiftKey ? 20 : 3;
         if(param1.delta < 0)
         {
            loc2 *= -1;
         }
         this.zoom(loc2);
      }
      
      private function zoom(param1:int) : void
      {
         var loc2:Point3D = !!this.mainScene.selectedProp ? this.mainScene.selectedProp.coords : this.cursorScene.camera.localToGlobal(cameraPoint);
         var loc3:Point3D = this.cursorScene.container.localToGlobal(this.cursorScene.cameraController.coords);
         var loc4:Point3D = loc3.clone();
         var loc5:Point3D = Point3D.difference(loc2,loc3);
         if(loc5.length < 500)
         {
            loc5 = Point3D.difference(this.cursorScene.camera.localToGlobal(cameraPoint),loc3);
         }
         loc5.normalize();
         loc5.multiply(param1 * 100);
         loc3.add(loc5);
         this.cursorScene.cameraController.coords = this.cursorScene.container.globalToLocal(loc3);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            parent.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            this.cursorScene.containerController.setMouseLook(false);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         parent.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         if(!param1.buttonDown)
         {
            this.onMouseUp(param1);
         }
         else
         {
            this.onMouseDown(param1);
         }
      }
      
      private function onMiddleMouseDown(param1:MouseEvent) : void
      {
         var loc2:Point3D = null;
         var loc3:Prop = null;
         var loc4:Point3D = null;
         var loc5:Point3D = null;
         var loc6:Point = null;
         if(param1.altKey)
         {
            loc3 = this.mainScene.selectedProp;
            if(loc3)
            {
               loc6 = this.mainScene.getPropsGroupCenter(this.mainScene.selectedProps);
               loc2 = new Point3D(loc6.x,loc6.y,loc3.z);
            }
            else
            {
               loc2 = this.cursorScene.camera.localToGlobal(new Point3D(0,0,this.cameraDistance));
            }
            loc4 = this.cursorScene.containerController.coords.clone();
            loc4.subtract(loc2);
            loc5 = this.cursorScene.container.localToGlobal(this.cursorScene.cameraController.coords);
            loc5.add(loc4);
            this.cursorScene.cameraController.coords = this.cursorScene.container.globalToLocal(loc5);
            this.cursorScene.containerController.coords = loc2;
            this.cursorScene.containerController.setMouseLook(true);
         }
         else
         {
            this.middleDown = true;
         }
      }
      
      private function onMiddleMouseUp(param1:MouseEvent) : void
      {
         this.middleDown = false;
         this.cursorScene.containerController.setMouseLook(false);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         return;
         this.cursorScene.containerController.yawLeft(this.keyMapper.keyPressed(0));
         this.cursorScene.containerController.yawRight(this.keyMapper.keyPressed(1));
         this.cursorScene.containerController.pitchDown(this.keyMapper.keyPressed(6));
         this.cursorScene.containerController.pitchUp(this.keyMapper.keyPressed(7));
         this.cursorScene.containerController.speed = 2000;
         this.cursorScene.containerController.moveLeft(this.keyMapper.keyPressed(2));
         this.cursorScene.containerController.moveRight(this.keyMapper.keyPressed(3));
         this.cursorScene.containerController.moveForward(this.keyMapper.keyPressed(4));
         this.cursorScene.containerController.moveBack(this.keyMapper.keyPressed(5));
         this.cursorScene.cameraController.processInput();
         this.cursorScene.containerController.processInput();
         this.cursorScene.calculate();
         this.cameraTransformation = this.cursorScene.camera.transformation;
         cameraOffset.x = this.cameraTransformation.d;
         cameraOffset.y = this.cameraTransformation.h;
         cameraOffset.z = this.cameraTransformation.l;
         this.cursorScene.drawAxis(this.cameraTransformation);
         var loc2:Point3D = this.cameraTransformation.getRotations();
         this.mainScene.setCameraPosition(cameraOffset,loc2.x,loc2.y,loc2.z);
         this.mainScene.calculate();
         if(this._showBoundBoxes)
         {
            this.drawBoundBoxes();
         }
         this.mainScene.drawDominationLinks(this.dominationOverlay.graphics);
      }
      
      private function drawBoundBoxes() : void
      {
         var loc1:* = undefined;
         var loc2:MeshProp = null;
         this.boundBoxesOverlay.graphics.clear();
         for(loc1 in this.mainScene.root.alternativa3d::_children)
         {
            loc2 = loc1 as MeshProp;
            if(loc2 != null && !loc2.hidden)
            {
               this.drawPropBoundBox(loc2);
            }
         }
      }
      
      private function drawPropBoundBox(param1:MeshProp) : void
      {
         var loc4:Point3D = null;
         var loc5:int = 0;
         var loc2:Mesh = param1.object as Mesh;
         if(loc2 == null)
         {
            return;
         }
         getMeshBounds(loc2,this.min,this.max);
         fillBBPoints(this.min,this.max,this.bbPoints);
         var loc3:Number = this.cursorScene.camera.focalLength;
         var loc6:Number = 0.5 * this.cursorScene.view.width;
         var loc7:Number = 0.5 * this.cursorScene.view.height;
         loc5 = 0;
         while(loc5 < 8)
         {
            loc4 = this.bbPoints[loc5];
            loc4.inverseTransform(this.cameraTransformation);
            if(loc4.z <= 0)
            {
               return;
            }
            loc4.x = loc4.x * loc3 / loc4.z;
            if(loc4.x < -loc6 || loc4.x > loc6)
            {
               return;
            }
            loc4.x += loc6;
            loc4.y = loc4.y * loc3 / loc4.z;
            if(loc4.y < -loc7 || loc4.y > loc7)
            {
               return;
            }
            loc4.y += loc7;
            loc5++;
         }
         var loc8:Graphics = this.boundBoxesOverlay.graphics;
         loc8.lineStyle(0,65280);
         loc4 = this.bbPoints[0];
         loc8.moveTo(loc4.x,loc4.y);
         loc5 = 1;
         while(loc5 < 4)
         {
            loc4 = this.bbPoints[loc5];
            loc8.lineTo(loc4.x,loc4.y);
            loc5++;
         }
         loc4 = this.bbPoints[0];
         loc8.lineTo(loc4.x,loc4.y);
         loc5 = 4;
         while(loc5 < 8)
         {
            loc4 = this.bbPoints[loc5];
            loc8.lineTo(loc4.x,loc4.y);
            loc5++;
         }
         loc4 = this.bbPoints[4];
         loc8.lineTo(loc4.x,loc4.y);
         GraphicUtils.drawLine(loc8,this.bbPoints[1],this.bbPoints[5]);
         GraphicUtils.drawLine(loc8,this.bbPoints[2],this.bbPoints[6]);
         GraphicUtils.drawLine(loc8,this.bbPoints[3],this.bbPoints[7]);
      }
      
      private function onResize(param1:Event = null) : void
      {
         this.cursorScene.viewResize(parent.width - 20,parent.height - 40);
         this.mainScene.viewResize(parent.width - 20,parent.height - 40);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var loc2:Prop = null;
         var loc3:Point3D = null;
         var loc4:Point3D = null;
         var loc5:Point3D = null;
         var loc6:Prop = null;
         var loc7:Set = null;
         switch(param1.keyCode)
         {
            case Keyboard.NUMBER_0:
               if(param1.ctrlKey)
               {
                  this.cursorScene.camera.rotationX = this.cursorScene.camera.rotationX = this.cursorScene.camera.rotationX = -2.0943951023931953;
                  this.cursorScene.cameraController.coords = new Point3D(250,-7800,4670);
                  loc5 = this.cursorScene.camera.coords;
                  this.cameraDistance = Math.sqrt(loc5.x * loc5.x + loc5.y * loc5.y + loc5.z * loc5.z);
               }
               break;
            case KeyboardUtils.UP:
            case KeyboardUtils.DOWN:
            case KeyboardUtils.LEFT:
            case KeyboardUtils.RIGHT:
               if(this.cursorScene.visible)
               {
                  this.cursorScene.moveByArrows(param1.keyCode);
                  break;
               }
               loc2 = this.mainScene.selectedProp;
               loc4 = loc2.coords;
               this.mainScene.moveByArrows(param1.keyCode);
               loc3 = loc2.coords;
               loc3.difference(loc3,loc4);
               this.eventJournal.addEvent(EventJournal.MOVE,this.mainScene.selectedProps,loc3);
               break;
            case KeyboardUtils.V:
               this.verticalMoving = true;
               break;
            case KeyboardUtils.W:
               if(this.cursorScene.visible)
               {
                  this.cursorScene.object.z += EditorScene.snapByHalf ? EditorScene.VERTICAL_GRID_RESOLUTION_2 : EditorScene.VERTICAL_GRID_RESOLUTION_1;
                  this.cursorScene.updateMaterial();
                  break;
               }
               loc2 = this.mainScene.selectedProp;
               if(loc2)
               {
                  loc4 = loc2.coords;
                  this.mainScene.verticalMove(false);
                  loc3 = loc2.coords;
                  loc3.difference(loc3,loc4);
                  this.eventJournal.addEvent(EventJournal.MOVE,this.mainScene.selectedProps,loc3);
               }
               break;
            case KeyboardUtils.S:
               if(!param1.ctrlKey)
               {
                  if(this.cursorScene.visible)
                  {
                     this.cursorScene.object.z -= EditorScene.snapByHalf ? EditorScene.VERTICAL_GRID_RESOLUTION_2 : EditorScene.VERTICAL_GRID_RESOLUTION_1;
                     this.cursorScene.updateMaterial();
                     break;
                  }
                  loc2 = this.mainScene.selectedProp;
                  if(loc2)
                  {
                     loc4 = loc2.coords;
                     this.mainScene.verticalMove(true);
                     loc3 = loc2.coords;
                     loc3.difference(loc3,loc4);
                     this.eventJournal.addEvent(EventJournal.MOVE,this.mainScene.selectedProps,loc3);
                  }
               }
               break;
            case KeyboardUtils.DELETE:
            case KeyboardUtils.C:
               loc2 = this.mainScene.selectedProp;
               if(loc2)
               {
                  loc6 = this.cursorScene.object;
                  if(loc6)
                  {
                     loc6.coords = loc2.coords;
                     if(this.snapMode)
                     {
                        loc6.snapToGrid();
                     }
                  }
                  loc7 = this.mainScene.deleteProps();
                  this.eventJournal.addEvent(EventJournal.DELETE,loc7);
                  this.cursorScene.visible = true;
               }
               break;
            case KeyboardUtils.Z:
               if(this.cursorScene.visible)
               {
                  this.cursorScene.rotateCursorCounterClockwise();
                  this.cursorScene.updateMaterial();
                  break;
               }
               this.eventJournal.addEvent(EventJournal.ROTATE,this.mainScene.selectedProps.clone(),false);
               this.mainScene.rotateCounterClockwise();
               break;
            case KeyboardUtils.X:
               if(this.cursorScene.visible)
               {
                  this.cursorScene.rotateCursorClockwise();
                  this.cursorScene.updateMaterial();
                  break;
               }
               this.eventJournal.addEvent(EventJournal.ROTATE,this.mainScene.selectedProps.clone(),true);
               this.mainScene.rotateClockwise();
               break;
            case KeyboardUtils.ESCAPE:
               loc2 = this.mainScene.selectedProp;
               if(loc2)
               {
                  if(this.cursorScene.object)
                  {
                     this.cursorScene.object.coords = loc2.coords;
                     this.cursorScene.object.snapToGrid();
                  }
                  this.mainScene.deselectProps();
                  this.cursorScene.visible = true;
               }
               break;
            case Keyboard.NUMPAD_ADD:
               this.zoom(3);
               break;
            case Keyboard.NUMPAD_SUBTRACT:
               this.zoom(-3);
               break;
            case Keyboard.EQUAL:
               if(param1.ctrlKey)
               {
                  this.zoom(3);
               }
               break;
            case Keyboard.MINUS:
               if(param1.ctrlKey)
               {
                  this.zoom(-3);
               }
               break;
            case Keyboard.F:
               this.mainScene.mirrorTextures();
               break;
            case Keyboard.Q:
               this.mainScene.selectConflictingProps();
               break;
            case Keyboard.T:
               if(param1.shiftKey)
               {
                  this.mainScene.hidePlaneBounds();
                  break;
               }
               this.mainScene.showPlaneBounds();
               break;
            case Keyboard.K:
               EditorScene.toggleGridResolution();
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyboardUtils.V:
               this.verticalMoving = false;
         }
      }
      
      public function clear() : void
      {
         this.mainScene.clear();
         this.cursorScene.clear();
      }
      
      public function set snapMode(param1:Boolean) : void
      {
         this._snapMode = param1;
         this.mainScene.snapMode = param1;
         this.cursorScene.snapMode = param1;
      }
      
      public function get snapMode() : Boolean
      {
         return this._snapMode;
      }
      
      public function addProp(param1:Prop) : void
      {
         var loc2:Prop = this.mainScene.addProp(param1,this.cursorScene.object.coords,this.cursorScene.object.rotationZ);
         var loc3:Set = new Set();
         loc3.add(loc2);
         this.eventJournal.addEvent(EventJournal.ADD,loc3);
         setTimeout(this.cursorScene.updateMaterial,200);
         loc2.addEventListener(MouseEvent3D.MOUSE_DOWN,this.onPropMouseDown);
         if(this._snapMode && !this.cursorScene.freeState && (this.multiplePropMode == MultiPropMode.NONE && this.cursorScene.occupyMap.isConflict(loc2) || this.multiplePropMode == MultiPropMode.GROUP && this.cursorScene.occupyMap.isConflictGroup(loc2)))
         {
            Alert.show("This location is occupied. Continue?","",Alert.YES | Alert.NO,this,this.alertConflict,null,Alert.YES);
         }
      }
      
      private function onPropMouseDown(param1:MouseEvent3D) : void
      {
         this.clickZ = param1.object.z;
         this.propDown = true;
      }
      
      public function undo() : void
      {
         var loc1:EventJournalItem = this.eventJournal.undo();
         if(loc1)
         {
            this.mainScene.undo(loc1);
            if(this.cursorScene.visible)
            {
               this.cursorScene.updateMaterial();
            }
         }
      }
      
      public function redo() : void
      {
         var loc1:EventJournalItem = this.eventJournal.redo();
         if(loc1)
         {
            this.mainScene.redo(loc1);
            if(this.cursorScene.visible)
            {
               this.cursorScene.updateMaterial();
            }
         }
      }
   }
}

