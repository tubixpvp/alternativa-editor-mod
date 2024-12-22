package alternativa.editor
{
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.editor.engine3d.Scene3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.View;
   import alternativa.types.Map;
   import alternativa.types.Point3D;
   import alternativa.utils.MathUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import mx.core.UIComponent;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.Stage;
   
   public class Preview extends UIComponent
   {
      private static const ICON_SIZE:Number = 50;
      
      private var scene:Scene3D;
      
      private var view:View;
      
      private var camera:Camera3D;
      
      private var cameraContainer:Object3DContainer;
      
      private var propDistance:Map;

      private var _renderingBlocked:Boolean = false;

      private var _stage3dBitmapData:BitmapData = null;
      
      public function Preview()
      {
         this.propDistance = new Map();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.initScene();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
      }
      
      private function initScene() : void
      {
         this.scene = new Scene3D();
         this.scene.root = new Object3DContainer();
         this.camera = this.scene.camera = new Camera3D();
         this.camera.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
         this.cameraContainer = new Object3DContainer();
         this.cameraContainer.addChild(this.camera);
         this.camera.setPositionXYZ(0,-100,40);
         this.scene.root.addChild(this.cameraContainer);
         this.view = new View(this.camera,100,100);
         addChild(this.view);
         //this.view.graphics.beginFill(16777215);
         //this.view.graphics.drawRect(0,0,1,1);
         //this.view.graphics.endFill();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(_renderingBlocked)
         {
            return;
         }
         this.cameraContainer.rotationZ += MathUtils.DEG1;
         this.scene.calculate();
      }
      
      private function calculateOptimalCameraPosition(param1:Prop) : void
      {
         var storedPoint:Point = this.propDistance[param1];
         if(storedPoint != null)
         {
            return;
         }

         var loc7:BitmapData = null;
         //var loc8:Vector.<Vertex> = null;
         //var loc9:int = 0;
         //var loc10:int = 0;
         var loc11:Point3D = new Point3D();
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         var loc14:Number = NaN;
         var loc15:Number = NaN;
         var loc2:Number = 0;
         var loc3:Number = -Number.MAX_VALUE;
         var loc4:Number = Number.MAX_VALUE;
         var loc5:Sprite3DProp = param1 as Sprite3DProp;
         if(loc5)
         {
            loc7 = param1.bitmapData;
            loc2 = loc5.scale * 1.5 * Math.max(loc7.width,loc7.height);
            loc3 = loc7.height;
            loc4 = 0;
         }
         else
         {
            var vertex:Vertex = (param1.object as Mesh).vertexList;
            //loc8 = param1.vertices;
            //loc9 = int(loc8.length);
            while(vertex != null)
            {
               loc11.copyFromVertex(vertex);
               loc12 = loc11.x - param1.x;
               loc13 = loc11.y - param1.y;
               loc14 = loc11.z - param1.z;
               loc15 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
               if(loc15 > loc2)
               {
                  loc2 = loc15;
               }
               if(loc11.z < loc4)
               {
                  loc4 = loc11.z;
               }
               if(loc11.z > loc3)
               {
                  loc3 = loc11.z;
               }

               vertex = vertex.next;
            }
            /*loc10 = 0;
            while(loc10 < loc9)
            {
               loc11.copyFromVertex(loc8[loc10]);
               loc12 = loc11.x - param1.x;
               loc13 = loc11.y - param1.y;
               loc14 = loc11.z - param1.z;
               loc15 = loc12 * loc12 + loc13 * loc13 + loc14 * loc14;
               if(loc15 > loc2)
               {
                  loc2 = loc15;
               }
               if(loc11.z < loc4)
               {
                  loc4 = loc11.z;
               }
               if(loc11.z > loc3)
               {
                  loc3 = loc11.z;
               }
               loc10++;
            }*/
            loc2 = 2 * Math.sqrt(loc2);
         }
         var loc6:Number = loc2 * (Math.SQRT2 / (2 * Math.tan(this.camera.fov / 2)) + 0.5);
         this.propDistance.add(param1,new Point(loc6,(loc3 - loc4) / 2));
      }
      
      private const tmpMatrix:Matrix = new Matrix();
      
      public function getPropIcon(param1:Prop) : Bitmap
      {
         _renderingBlocked = true;
         
         //setup scene
         this.clearScene();
         this.calculateOptimalCameraPosition(param1);
         this.setCameraCoords(param1);
         this.scene.root.addChild(param1);

         this.cameraContainer.rotationZ = 0; //TODO adjust angle

         //draw to bitmap
         var stage:Stage = this.stage;
         if(_stage3dBitmapData != null && 
            (_stage3dBitmapData.width != stage.width || _stage3dBitmapData.height != stage.height))
         {
            _stage3dBitmapData.dispose();
            _stage3dBitmapData = null;
         }
         if(_stage3dBitmapData == null)
         {
            _stage3dBitmapData = new BitmapData(stage.width, stage.height, true, 0xff000000);
         }

         View.getStaticDevice().clear(1,1,1); //clear buffers to avoid context3d error
         
         this.scene.calculate(false);

         view.getContext3D().drawToBitmapData(_stage3dBitmapData);
         
         //clean up
         var mesh:Mesh = (param1.object as Mesh);
         if(mesh != null)
         {
            mesh.deleteResources();

            var currMaterial:Material = mesh.faceList.material;
            if(currMaterial is TextureMaterial)
            {
               (currMaterial as TextureMaterial).disposeResource();
            }
         }
         
         this.scene.root.removeChild(param1);

         _renderingBlocked = false;

         //draw icon
			var imagePos:Point = this.view.localToGlobal(new Point(0,0));

			var bitmapData:BitmapData = new BitmapData(ICON_SIZE,ICON_SIZE,false,0x0);

			var scale:Number = ICON_SIZE/this.view.width;

         var matrix:Matrix = this.tmpMatrix;
			matrix.a = scale;
			matrix.d = scale;
			matrix.tx = -imagePos.x * scale;
			matrix.ty = -imagePos.y * scale;

			bitmapData.draw(_stage3dBitmapData,matrix);

			return new Bitmap(bitmapData);

         //original:
         /*var loc2:BitmapData = new BitmapData(ICON_SIZE,ICON_SIZE,false,0);
         var loc3:Matrix = tmpMatrix;
         loc3.a = ICON_SIZE / this.view.width;
         loc3.d = loc3.a;
         loc2.draw(this.view,loc3);
         return new Bitmap(loc2);*/
      }
      
      private function setCameraCoords(param1:Object3D) : void
      {
         var loc2:Point = this.propDistance[param1];
         if(loc2 != null)
         {
            this.camera.y = -loc2.x;
            this.camera.z = loc2.y / 2 + loc2.x / Math.sqrt(3);
         }
      }
      
      private function clearScene() : void
      {
         var loc1:Object3D;
         var loc2:Prop = null;
         for each(loc1 in this.scene.root.children)
         {
            loc2 = loc1 as Prop;
            if(loc2 != null)
            {
               this.scene.root.removeChild(loc2);
            }
         }
      }
      
      public function showProp(param1:Prop) : void
      {
         this.clearScene();
         this.setCameraCoords(param1);
         this.scene.root.addChild(param1);
      }
      
      public function onResize(param1:Event = null) : void
      {
         this.view.width = parent.width;
         this.view.height = parent.height;
         if(_renderingBlocked)
         {
            return;
         }
         this.scene.calculate();
      }
   }
}

