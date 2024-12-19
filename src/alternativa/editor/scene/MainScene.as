package alternativa.editor.scene
{
   import alternativa.editor.BonusRegionPropertiesPanel;
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.GraphicUtils;
   import alternativa.editor.KillZonePropertiesPanel;
   import alternativa.editor.LayerNames;
   import alternativa.editor.TexturePanel;
   import alternativa.editor.eventjournal.EventJournal;
   import alternativa.editor.eventjournal.EventJournalItem;
   import alternativa.editor.events.DominationSpawnLinkEndEvent;
   import alternativa.editor.events.DominationSpawnLinkStartEvent;
   import alternativa.editor.events.LayerContentChangeEvent;
   import alternativa.editor.events.LayerVisibilityChangeEvent;
   import alternativa.editor.mapexport.FileExporter;
   import alternativa.editor.mapexport.FileType;
   import alternativa.editor.mapexport.TanksXmlExporterV1Full;
   import alternativa.editor.mapexport.TanksXmlExporterV1Lite;
   import alternativa.editor.mapexport.TanksXmlExporterV3;
   import alternativa.editor.prop.BonusRegion;
   import alternativa.editor.prop.ControlPoint;
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.KillBox;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.MouseEvent3D;
   import alternativa.editor.engine3d.materials.WireMaterial;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.types.Map;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.filesystem.FileStream;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import gui.events.PropListEvent;
   import mx.containers.Panel;
   import alternativa.engine3d.core.EllipsoidCollider;
   import flash.geom.Vector3D;
   import alternativa.engine3d.core.Object3DContainer;
   
   public class MainScene extends EditorScene
   {
      public static var collider:EllipsoidCollider;
      private static var __root:Object3DContainer;
      
      public var selectedProp:Prop;
      
      public var selectedProps:Set;
      
      public var propMouseDown:Boolean = false;
      
      public var snapMode:Boolean = true;
      
      private var _changed:Boolean = false;
      
      private var hiddenProps:Array;
      
      private var texturePanel:TexturePanel;
      
      private var propertyPanel:Panel;
      
      private var bonusTypesPanel:BonusRegionPropertiesPanel;
      
      private var killZonePanel:KillZonePropertiesPanel;
      
      private var currentBitmaps:Map;
      
      private var _selectablePropTypes:Set;
      
      private var grid:Plane;
      
      private var exporters:Object;
      
      private var layers:Layers;
      
      private var dominationPoints:Dictionary;
      
      private var domSpawnPoint:SpawnPoint;
      
      private var controlPointNameField:ControlPointNameField;
      
      public function MainScene()
      {
         this.hiddenProps = [];
         this.bonusTypesPanel = new BonusRegionPropertiesPanel();
         this.killZonePanel = new KillZonePropertiesPanel();
         this._selectablePropTypes = new Set();
         this.exporters = {};
         this.layers = new Layers();
         this.dominationPoints = new Dictionary();
         super();
         occupyMap = new OccupyMap();
         this.selectedProps = new Set();
         this.selectablePropTypes = AlternativaEditor.DEFAULT_SELECTABLE_TYPES;
         var loc2:Number = 15 * hBase2;
         this.grid = new Plane(loc2,loc2);
         this.grid.setMaterialToAllFaces(new WireMaterial(10,loc2,loc2,15,9474192));
         root.addChild(this.grid);
         this.grid.x = hBase;
         this.grid.y = hBase;
         this.grid.mouseEnabled = false;
         this.exporters[FileType.MAP_XML_VERSION_1_LITE] = new TanksXmlExporterV1Lite(root);
         this.exporters[FileType.MAP_XML_VERSION_1_FULL] = new TanksXmlExporterV1Full(root);
         this.exporters[FileType.MAP_XML_VERSION_3] = new TanksXmlExporterV3(root);
         this.createControlPointNameTextField();
         collider = new EllipsoidCollider(30,30,30);
         __root = root;
         GlobalEventDispatcher.addListener(LayerVisibilityChangeEvent.VISIBILITY_CHANGED,this.onLayerVisibilityChange);
         GlobalEventDispatcher.addListener(LayerContentChangeEvent.LAYER_CONTENT_CHANGED,this.onLayerContentChange);
         GlobalEventDispatcher.addListener(DominationSpawnLinkStartEvent.DOMINATION_SPAWN_LINK_START,this.onDominationLinkStart);
         GlobalEventDispatcher.addListener(DominationSpawnLinkEndEvent.DOMINATION_SPAWN_LINK_END,this.onDominationLinkEnd);
      }
      
      public static function getProjectedPoint(param1:Vector3D) : Vector3D
      {
         return collider.calculateDestination(param1,new Vector3D(0,0,-10000),__root);
      }
      
      private static function snapPropsToGrid(param1:Set) : void
      {
         var loc2:* = undefined;
         for(loc2 in param1)
         {
            Prop(loc2).snapToGrid();
         }
      }
      
      private function createControlPointNameTextField() : void
      {
         this.controlPointNameField = new ControlPointNameField();
      }
      
      private function onDominationLinkStart(param1:DominationSpawnLinkStartEvent) : void
      {
         this.domSpawnPoint = param1.spawnPoint;
      }
      
      private function onDominationLinkEnd(param1:DominationSpawnLinkEndEvent) : void
      {
         if(this.domSpawnPoint != null)
         {
            if(this.domSpawnPoint.data != null)
            {
               ControlPoint(this.domSpawnPoint.data).removeSpawnPoint(this.domSpawnPoint);
            }
            param1.checkPoint.addSpawnPoint(this.domSpawnPoint);
            this.domSpawnPoint = null;
         }
      }
      
      private function onLayerVisibilityChange(param1:LayerVisibilityChangeEvent) : void
      {
         var loc3:* = undefined;
         var loc2:Layer = this.layers.getLayer(param1.layerName);
         loc2.visible = param1.visible;
         for(loc3 in loc2.props)
         {
            this.checkPropVisibility(loc3);
         }
      }
      
      override public function set root(param1:Object3DContainer) : void
      {
         var loc2:FileExporter = null;
         super.root = param1;
         for each(loc2 in this.exporters)
         {
            loc2.sceneRoot = param1;
         }
      }
      
      public function exportScene(param1:FileType, param2:FileStream) : void
      {
         FileExporter(this.exporters[param1]).exportToFileStream(param2);
         this._changed = false;
      }
      
      public function moveProps(param1:Set, param2:Point3D) : void
      {
         var loc3:* = undefined;
         var loc4:Prop = null;
         for(loc3 in param1)
         {
            loc4 = loc3;
            occupyMap.free(loc4);
            loc4.x -= param2.x;
            loc4.y -= param2.y;
            loc4.z -= param2.z;
            if(this.snapMode)
            {
               loc4.snapToGrid();
               occupyMap.occupy(loc4);
            }
         }
      }
      
      public function undo(param1:EventJournalItem) : void
      {
         var loc3:* = undefined;
         var loc4:Prop = null;
         var loc2:Set = param1.props;
         switch(param1.operation)
         {
            case EventJournal.ADD:
               this.deleteProps(loc2);
               break;
            case EventJournal.COPY:
               this.deleteProps(loc2);
               break;
            case EventJournal.DELETE:
               for(loc3 in loc2)
               {
                  loc4 = loc3;
                  loc4.deselect();
                  this.addProp(loc4,new Point3D(loc4.x,loc4.y,loc4.z),loc4.rotationZ,false);
               }
               break;
            case EventJournal.MOVE:
               this.moveProps(loc2,param1.oldState);
               (param1.oldState as Point3D).multiply(-1);
               break;
            case EventJournal.ROTATE:
               if(param1.oldState)
               {
                  this.rotateCounterClockwise(loc2);
               }
               else
               {
                  this.rotateClockwise(loc2);
               }
               param1.oldState = !param1.oldState;
               break;
            case EventJournal.CHANGE_TEXTURE:
         }
      }
      
      public function redo(param1:EventJournalItem) : void
      {
         var loc3:Prop = null;
         var loc4:* = undefined;
         var loc2:Set = param1.props;
         switch(param1.operation)
         {
            case EventJournal.ADD:
               loc3 = loc2.peek();
               this.addProp(loc3,new Point3D(loc3.x,loc3.y,loc3.z),loc3.rotationZ,false);
               break;
            case EventJournal.COPY:
               for(loc4 in loc2)
               {
                  loc3 = loc4;
                  this.addProp(loc3,new Point3D(loc3.x,loc3.y,loc3.z),loc3.rotationZ,false);
               }
               break;
            case EventJournal.DELETE:
               this.deleteProps(loc2);
               break;
            case EventJournal.MOVE:
               this.moveProps(loc2,param1.oldState);
               (param1.oldState as Point3D).multiply(-1);
               break;
            case EventJournal.ROTATE:
               if(param1.oldState)
               {
                  this.rotateCounterClockwise(loc2);
               }
               else
               {
                  this.rotateClockwise(loc2);
               }
               param1.oldState = !param1.oldState;
               break;
            case EventJournal.CHANGE_TEXTURE:
         }
      }
      
      public function setCameraPosition(param1:Point3D, param2:Number, param3:Number, param4:Number) : void
      {
         camera.setPositionXYZ(param1.x,param1.y,param1.z);
         camera.rotationX = param2;
         camera.rotationY = param3;
         camera.rotationZ = param4;
      }
      
      public function showCollisionBoxes() : void
      {
         var loc1:Object3D;
         var loc2:MeshProp = null;
         for each(loc1 in root.children)
         {
            loc2 = loc1 as MeshProp;
            if(loc2)
            {
               loc2.showCollisionBoxes();
            }
         }
      }
      
      public function hideCollisionBoxes() : void
      {
         var loc1:Object3D;
         var loc2:MeshProp = null;
         for each(loc1 in root.children)
         {
            loc2 = loc1 as MeshProp;
            if(loc2)
            {
               loc2.hideCollisionBoxes();
            }
         }
      }
      
      public function showGrid() : void
      {
         root.addChild(this.grid);
      }
      
      public function hideGrid() : void
      {
         root.removeChild(this.grid);
      }
      
      public function showPlaneBounds() : void
      {
         var loc1:Object3D;
         var loc2:MeshProp = null;
         for each(loc1 in root.children)
         {
            loc2 = loc1 as MeshProp;
            if(Boolean(loc2) && loc2.height == 0)
            {
               loc2.showBound();
            }
         }
      }
      
      public function hidePlaneBounds() : void
      {
         var loc1:Object3D;
         var loc2:MeshProp = null;
         for each(loc1 in root.children)
         {
            loc2 = loc1 as MeshProp;
            if(Boolean(loc2) && loc2.height == 0)
            {
               loc2.hideBound();
            }
         }
      }
      
      public function set selectablePropTypes(param1:Array) : void
      {
         var loc4:Object3D;
         var loc5:Prop = null;
         var loc6:Object3D;
         var loc7:Object3D = null;
         this._selectablePropTypes.clear();
         var loc2:int = int(param1.length);
         var loc3:int = 0;
         while(loc3 < loc2)
         {
            this._selectablePropTypes.add(getQualifiedClassName(param1[loc3]));
            loc3++;
         }
         for each(loc4 in root.children)
         {
            loc5 = loc4 as Prop;
            if(loc5)
            {
               loc5.mouseEnabled = this.isSelectableProp(loc5);
               for each(loc6 in loc5.children)
               {
                  loc7 = loc6 as Object3D;
                  loc7.mouseEnabled = loc5.mouseEnabled;
               }
            }
         }
      }
      
      public function get isTexturePanel() : Boolean
      {
         return this.propertyPanel.contains(this.texturePanel) && this.texturePanel.selectedItem;
      }
      
      public function setPropertyPanel(param1:Panel) : void
      {
         this.propertyPanel = param1;
         this.texturePanel = new TexturePanel();
         this.texturePanel.addEventListener(PropListEvent.SELECT,this.onTexturePanelSelect);
      }
      
      public function get changed() : Boolean
      {
         return this._changed;
      }
      
      public function set changed(param1:Boolean) : void
      {
         this._changed = param1;
      }
      
      public function moveSelectedPropsByMouse(param1:Boolean) : void
      {
         var loc2:Point = null;
         var loc3:Vector3D = null;
         var loc4:* = undefined;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:CameraFacing = null;
         var loc9:Prop = null;
         if(this.selectedProp)
         {
            loc2 = new Point(view.mouseX,view.mouseY);
            for(loc4 in this.selectedProps)
            {
               occupyMap.free(loc4 as Prop);
            }
            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            if(param1)
            {
               loc8 = getCameraFacing();
               if(loc8 == CameraFacing.Y || loc8 == CameraFacing.NEGATIVE_Y)
               {
                  loc3 = camera.projectGlobal(new Vector3D(loc2.x,loc2.y,this.selectedProp.y));
                  loc5 = loc3.x - this.selectedProp.x;
                  this.selectedProp.x = loc3.x;
               }
               else
               {
                  loc3 = camera.projectGlobal(new Vector3D(loc2.x,loc2.y,this.selectedProp.x));
                  loc6 = loc3.y - this.selectedProp.y;
                  this.selectedProp.y = loc3.y;
               }
               loc7 = loc3.z - this.selectedProp.z;
               this.selectedProp.z = loc3.z;
            }
            else
            {
               loc3 = camera.projectGlobal(new Vector3D(loc2.x,loc2.y,this.selectedProp.z));
               loc5 = loc3.x - this.selectedProp.x;
               loc6 = loc3.y - this.selectedProp.y;
               this.selectedProp.x = loc3.x;
               this.selectedProp.y = loc3.y;
            }
            for(loc4 in this.selectedProps)
            {
               loc9 = loc4;
               if(loc9 != this.selectedProp)
               {
                  loc9.x += loc5;
                  loc9.y += loc6;
                  loc9.z += loc7;
               }
               if(this.snapMode || loc9 is MeshProp && !(loc9 is Sprite3DProp))
               {
                  loc9.snapToGrid();
                  occupyMap.occupy(loc9);
               }
            }
         }
      }
      
      public function moveByArrows(param1:uint) : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         for(loc2 in this.selectedProps)
         {
            loc3 = loc2;
            occupyMap.free(loc3);
            move(loc3,param1);
            if(this.snapMode)
            {
               occupyMap.occupy(loc3);
            }
         }
      }
      
      public function verticalMove(param1:Boolean) : void
      {
         var loc3:* = undefined;
         var loc4:Prop = null;
         var loc2:Number = EditorScene.snapByHalf ? EditorScene.VERTICAL_GRID_RESOLUTION_2 : EditorScene.VERTICAL_GRID_RESOLUTION_1;
         if(param1)
         {
            loc2 = -loc2;
         }
         for(loc3 in this.selectedProps)
         {
            loc4 = loc3;
            occupyMap.free(loc4);
            loc4.z += loc2;
            if(this.snapMode)
            {
               occupyMap.occupy(loc4);
            }
         }
      }
      
      public function onPropMouseDown(param1:MouseEvent3D) : void
      {
         var loc2:Prop = null;
         var loc3:Boolean = false;
         if(!param1.ctrlKey)
         {
            loc2 = param1.relatedObject as Prop;
            if(this.isSelectableProp(loc2))
            {
               loc3 = loc2.selected;
               if(param1.shiftKey)
               {
                  if(param1.altKey)
                  {
                     if(loc3)
                     {
                        this.deselectProp(loc2);
                     }
                  }
                  else if(!loc3)
                  {
                     this.selectProp(loc2);
                  }
               }
               else if(!loc3)
               {
                  this.deselectProps();
                  this.selectProp(loc2);
               }
               else
               {
                  this.selectedProp = loc2;
               }
               this.propMouseDown = true;
            }
         }
      }
      
      public function deselectProps() : void
      {
         while(!this.selectedProps.isEmpty())
         {
            this.deselectProp(this.selectedProps.peek());
         }
         this.selectedProps.clear();
         this.selectedProp = null;
         this.hidePropertyPanelItem(this.bonusTypesPanel);
         this.hidePropertyPanelItem(this.texturePanel);
      }
      
      public function deselectProp(param1:Prop) : void
      {
         param1.deselect();
         this.selectedProps.remove(param1);
         if(param1 == this.selectedProp)
         {
            this.selectedProp = null;
         }
         var loc2:Boolean = this.isOneBonusSelected();
         if(loc2)
         {
            this.showPropertyPanelItem(this.bonusTypesPanel);
         }
         else
         {
            this.hidePropertyPanelItem(this.bonusTypesPanel);
         }
         if(!loc2 && Boolean(this.noConflictBitmaps()))
         {
            this.showPropertyPanelItem(this.texturePanel);
         }
         else
         {
            this.hidePropertyPanelItem(this.texturePanel);
         }
         if(param1 is BonusRegion && (param1 as BonusRegion).gameModes.length < 1)
         {
            this.deleteProp(param1);
         }
      }
      
      public function selectProps(param1:Set) : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         this.deselectProps();
         for(loc2 in param1)
         {
            loc3 = loc2;
            if(this.isSelectableProp(loc3))
            {
               loc3.select();
               this.selectedProps.add(loc3);
               this.selectedProp = loc3;
            }
         }
         this.showPropertyPanel();
      }
      
      public function selectConflictingProps() : void
      {
         this.selectProps(occupyMap.getConflictProps());
      }
      
      public function selectProp(param1:Prop) : void
      {
         if(this.isSelectableProp(param1))
         {
            param1.select();
            this.selectedProps.add(param1);
            this.selectedProp = param1;
            this.showPropertyPanel();
         }
      }
      
      public function getPropsUnderRect(param1:Point, param2:Number, param3:Number, param4:Boolean) : Set
      {
         var loc6:Object3D;
         var loc7:Prop = null;
         var loc8:Vector3D = null;
         var loc5:Set = new Set();
         for each(loc6 in root.children)
         {
            loc7 = loc6 as Prop;
            if((Boolean(loc7)) && this.isSelectableProp(loc7))
            {
               loc8 = camera.projectGlobal(new Vector3D(loc7.x,loc7.y,loc7.z));
               if(loc8.x >= param1.x && loc8.x <= param1.x + param2 && loc8.y >= param1.y && loc8.y <= param1.y + param3)
               {
                  if(param4)
                  {
                     if(!loc7.selected)
                     {
                        loc7.select();
                     }
                  }
                  else if(loc7.selected)
                  {
                     loc7.deselect();
                  }
                  loc5.add(loc7);
               }
            }
         }
         return loc5;
      }
      
      public function addProp(param1:Prop, param2:Point3D, param3:Number, param4:Boolean = true, param5:Boolean = true) : Prop
      {
         var loc6:Prop = null;
         var loc7:Object3D;
         var loc8:Object3D = null;
         if(param4)
         {
            loc6 = param1.clone() as Prop;
            loc6.rotationZ = param3;
         }
         else
         {
            loc6 = param1;
         }
         root.addChild(loc6);
         loc6.onAddedToScene();
         if(loc6 is ControlPoint)
         {
            this.dominationPoints[loc6] = true;
         }
         if(param3 != 0 && param4)
         {
            loc6.calculate();
         }
         loc6.x = param2.x;
         loc6.y = param2.y;
         loc6.z = param2.z;
         loc6.addEventListener(MouseEvent3D.MOUSE_DOWN,this.onPropMouseDown);
         loc6.addEventListener(MouseEvent3D.MOUSE_OUT,this.onPropMouseOut);
         loc6.addEventListener(MouseEvent3D.MOUSE_OVER,this.onPropMouseOver);
         this._changed = true;
         if(this.snapMode && param5)
         {
            occupyMap.occupy(loc6);
         }
         loc6.mouseEnabled = this.isSelectableProp(loc6);
         for each(loc7 in loc6.children)
         {
            loc8 = loc7 as Object3D;
            loc8.mouseEnabled = loc6.mouseEnabled;
         }
         this.addPropToLayer(loc6);
         return loc6;
      }
      
      private function addPropToLayer(param1:Prop, param2:String = null) : void
      {
         var loc3:BonusRegion = null;
         var loc4:String = null;
         if(!param2)
         {
            if(param1 is BonusRegion)
            {
               loc3 = BonusRegion(param1);
               for(loc4 in loc3.gameModes)
               {
                  this.layers.addProp(loc4,param1);
               }
            }
            param2 = FunctionalProps.getPropLayer(param1);
         }
         if(param2 != null)
         {
            this.layers.addProp(param2,param1);
            this.checkPropVisibility(param1);
         }
      }
      
      private function checkPropVisibility(param1:Prop) : void
      {
         var loc3:* = undefined;
         var loc2:Boolean = false;
         for each(loc3 in this.layers.getLayersContainingProp(param1))
         {
            if(loc3.visible)
            {
               loc2 = true;
            }
         }
         if(!loc2)
         {
            this.hideProp(param1);
         }
         else
         {
            this.showProp(param1);
         }
      }
      
      private function removePropFromLayer(param1:Prop, param2:String) : void
      {
         if(param2 != null)
         {
            this.layers.removeProp(param1,param2);
            this.checkPropVisibility(param1);
         }
      }
      
      private function hideProp(param1:Prop) : void
      {
         var loc2:Set = new Set();
         loc2.add(param1);
         this.hideProps(loc2);
      }
      
      private function deleteProp(param1:Prop) : void
      {
         var loc2:Set = new Set();
         loc2.add(param1);
         this.deleteProps(loc2);
      }
      
      private function showProp(param1:Prop) : void
      {
         var loc2:Set = new Set();
         loc2.add(param1);
         this.showProps(loc2);
      }
      
      public function deleteProps(param1:Set = null) : Set
      {
         var loc2:Set = null;
         var loc3:int = 0;
         var loc4:* = undefined;
         var loc5:Prop = null;
         if(!param1)
         {
            param1 = this.selectedProps;
            this.selectedProp = null;
         }
         if(param1)
         {
            loc2 = param1.clone();
            for(loc4 in loc2)
            {
               loc5 = loc4;
               loc3++;
               root.removeChild(loc5);
               occupyMap.free(loc5);
               if(this.selectedProps.has(loc5))
               {
                  this.deselectProp(loc5);
               }
               this.layers.removeProp(loc5);
               if(loc5 is ControlPoint)
               {
                  delete this.dominationPoints[loc5];
                  ControlPoint(loc5).unlinkSpawnPoints();
               }
               else if(loc5 is SpawnPoint)
               {
                  if(SpawnPoint(loc5).name == FunctionalProps.DOMINATION_SPAWN)
                  {
                     if(loc5.data != null)
                     {
                        ControlPoint(loc5.data).removeSpawnPoint(SpawnPoint(loc5));
                     }
                  }
               }
            }
            this.hidePropertyPanelItem(this.bonusTypesPanel);
            this.hidePropertyPanelItem(this.texturePanel);
            this.propMouseDown = false;
            this._changed = true;
         }
         return loc2;
      }
      
      public function clear() : void
      {
         var loc1:Object3D;
         var loc2:Prop = null;
         for each(loc1 in root.children)
         {
            loc2 = loc1 as Prop;
            if(loc2)
            {
               root.removeChild(loc2);
               loc2.dispose();
            }
         }
         this.selectedProp = null;
         this.selectedProps.clear();
         occupyMap.clear();
         this.layers.clear();
         view.interactive = true;
         this.dominationPoints = new Dictionary();
      }
      
      public function onTexturePanelSelect(param1:PropListEvent = null) : void
      {
         var loc2:* = undefined;
         var loc3:MeshProp = null;
         for(loc2 in this.selectedProps)
         {
            loc3 = loc2;
            if(Boolean(loc3) && Boolean(loc3.bitmaps))
            {
               loc3.textureName = this.texturePanel.selectedItem;
            }
         }
      }
      
      public function showPropertyPanel() : void
      {
         var loc1:Map = null;
         this.hideAllPropertyPanelItems();
         if(this.isOneBonusSelected())
         {
            this.showPropertyPanelItem(this.bonusTypesPanel);
            this.bonusTypesPanel.setBonusRegion(FreeBonusRegion(this.selectedProps.peek()));
         }
         else if(this.isControlPointSelected())
         {
            this.showPropertyPanelItem(this.controlPointNameField);
            this.controlPointNameField.setControlPoint(ControlPoint(this.selectedProp));
         }
         else if(this.isOneKillZoneSelected())
         {
            this.showPropertyPanelItem(this.killZonePanel);
            this.killZonePanel.setBonusRegion(KillBox(this.selectedProp));
         }
         else
         {
            this.bonusTypesPanel.setBonusRegion(null);
            loc1 = this.noConflictBitmaps();
            if(loc1)
            {
               this.showTexturePanel(loc1);
            }
         }
      }
      
      private function showTexturePanel(param1:Map) : void
      {
         this.showPropertyPanelItem(this.texturePanel);
         if(param1 != this.currentBitmaps)
         {
            this.texturePanel.fill(param1);
            this.currentBitmaps = param1;
         }
      }
      
      private function isControlPointSelected() : Boolean
      {
         return this.selectedProps.length == 1 && this.selectedProp is ControlPoint;
      }
      
      public function mirrorTextures() : void
      {
         var loc1:* = undefined;
         var loc2:MeshProp = null;
         for(loc1 in this.selectedProps)
         {
            loc2 = loc1 as MeshProp;
            if(loc2 != null)
            {
               loc2.mirrorTexture();
            }
         }
      }
      
      private function hideProps(param1:Set) : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         for(loc2 in param1)
         {
            loc3 = loc2;
            if(!loc3.free)
            {
               occupyMap.free(loc3);
               loc3.free = true;
            }
            loc3.hide();
         }
      }
      
      private function showProps(param1:Set) : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         for(loc2 in param1)
         {
            loc3 = loc2;
            loc3.show();
            occupyMap.occupy(loc3);
         }
      }
      
      public function hideSelectedProps() : void
      {
         var loc2:* = undefined;
         var loc3:Prop = null;
         var loc1:Set = this.selectedProps.clone();
         this.deselectProps();
         for(loc2 in loc1)
         {
            loc3 = loc2;
            this.hiddenProps.push(loc3);
            if(!loc3.free)
            {
               occupyMap.free(loc3);
               loc3.free = true;
            }
            loc3.hide();
         }
      }
      
      public function showAll() : void
      {
         var loc3:Prop = null;
         var loc1:int = int(this.hiddenProps.length);
         var loc2:int = 0;
         while(loc2 < loc1)
         {
            loc3 = this.hiddenProps[loc2];
            loc3.show();
            occupyMap.occupy(loc3);
            loc2++;
         }
         this.hiddenProps.length = 0;
      }
      
      public function rotateCounterClockwise(param1:Set = null) : void
      {
         if(!param1)
         {
            param1 = this.selectedProps;
         }
         this.freeProps(param1);
         rotatePropsCounterClockwise(param1);
         if(this.snapMode)
         {
            snapPropsToGrid(param1);
         }
         this._changed = true;
      }
      
      public function rotateClockwise(param1:Set = null) : void
      {
         if(!param1)
         {
            param1 = this.selectedProps;
         }
         this.freeProps(param1);
         rotatePropsClockwise(param1);
         if(this.snapMode)
         {
            snapPropsToGrid(param1);
         }
         this._changed = true;
      }
      
      private function freeProps(param1:Set) : void
      {
         var loc2:* = undefined;
         for(loc2 in param1)
         {
            occupyMap.free(loc2);
         }
      }
      
      private function isSelectableProp(param1:Prop) : Boolean
      {
         return !param1.hidden && this._selectablePropTypes.has(getQualifiedClassName(param1));
      }
      
      private function showPropertyPanelItem(param1:DisplayObject) : void
      {
         if(!this.propertyPanel.contains(param1))
         {
            this.propertyPanel.addChild(param1);
         }
      }
      
      private function hidePropertyPanelItem(param1:DisplayObject) : void
      {
         if(this.propertyPanel.contains(param1))
         {
            this.propertyPanel.removeChild(param1);
         }
      }
      
      private function hideAllPropertyPanelItems() : void
      {
         this.propertyPanel.removeAllChildren();
      }
      
      private function onPropMouseOut(param1:MouseEvent3D) : void
      {
         view.useHandCursor = false;
      }
      
      private function onPropMouseOver(param1:MouseEvent3D) : void
      {
         view.useHandCursor = true;
      }
      
      private function noConflictBitmaps() : Map
      {
         var loc1:Map = null;
         var loc2:* = undefined;
         var loc3:MeshProp = null;
         for(loc2 in this.selectedProps)
         {
            loc3 = loc2 as MeshProp;
            if(Boolean(loc3) && Boolean(loc3.bitmaps))
            {
               if(!loc1)
               {
                  loc1 = loc3.bitmaps;
               }
               else if(loc1 != loc3.bitmaps)
               {
                  return null;
               }
            }
         }
         return loc1;
      }
      
      private function isOneBonusSelected() : Boolean
      {
         if(this.selectedProps.length > 1)
         {
            return false;
         }
         var loc1:Prop = this.selectedProps.peek();
         return loc1 is FreeBonusRegion;
      }
      
      private function isOneKillZoneSelected() : Boolean
      {
         if(this.selectedProps.length > 1)
         {
            return false;
         }
         var loc1:KillBox = this.selectedProps.peek() as KillBox;
         return loc1 != null;
      }
      
      public function drawDominationLinks(param1:Graphics) : void
      {
         var loc2:* = undefined;
         param1.clear();
         if(this.layers.getLayer(LayerNames.DOMINATION).visible)
         {
            for(loc2 in this.dominationPoints)
            {
               this.drawDominationPointLinks(param1,loc2);
            }
         }
      }
      
      private function drawDominationPointLinks(param1:Graphics, param2:ControlPoint) : void
      {
         var loc4:SpawnPoint = null;
         var loc5:Point3D = new Point3D();
         param1.lineStyle(0,65280);
         var loc3:Point3D = new Point3D().copyFromVector3D(camera.projectGlobal(new Vector3D(param2.x,param2.y,param2.z)));
         for each(loc4 in param2.getSpawnPoints())
         {
            loc5.copyFromVector3D(camera.projectGlobal(new Vector3D(loc4.x,loc4.y,loc4.z)));
            GraphicUtils.drawLine(param1,loc3,loc5);
         }
      }
      
      public function selectAll() : void
      {
      }
      
      private function onLayerContentChange(param1:LayerContentChangeEvent) : void
      {
         if(param1.layerContainsProp)
         {
            this.addPropToLayer(param1.prop,param1.layerName);
         }
         else
         {
            this.removePropFromLayer(param1.prop,param1.layerName);
         }
      }
   }
}

