package alternativa.editor.scene
{
   import alternativa.editor.prop.Prop;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.editor.engine3d.Scene3D;
   import alternativa.engine3d.core.View;
   import alternativa.types.Matrix4;
   import alternativa.types.Set;
   import alternativa.utils.KeyboardUtils;
   import alternativa.utils.MathUtils;
   import flash.geom.Point;
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.Vector3D;
   
   public class EditorScene extends Scene3D
   {
      public static const HORIZONTAL_GRID_RESOLUTION_1:Number = 500;
      
      public static const HORIZONTAL_GRID_RESOLUTION_2:Number = 250;
      
      public static const VERTICAL_GRID_RESOLUTION_1:Number = 300;
      
      public static const VERTICAL_GRID_RESOLUTION_2:Number = 150;
      
      public static var snapByHalf:Boolean = false;
      
      public static var hBase:Number = 250;
      
      public static var hBase2:Number = 2 * hBase;
      
      public static var vBase:Number = 300;
      
      public var view:View;
      
      public var occupyMap:OccupyMap;
      
      protected var znormal:Vector3D;
      
      protected var ynormal:Vector3D;
      
      protected var xnormal:Vector3D;
      
      public function EditorScene()
      {
         this.znormal = new Vector3D(0,0,1);
         this.ynormal = new Vector3D(0,1,0);
         this.xnormal = new Vector3D(1,0,0);
         super();
         this.initScene();
      }
      
      public static function toggleGridResolution() : void
      {
         snapByHalf = !snapByHalf;
      }
      
      public function viewResize(param1:Number, param2:Number) : void
      {
         this.view.width = param1;
         this.view.height = param2;
         calculate();
      }
      
      protected function initScene() : void
      {
         root = new Object3DContainer();
         root.name = "EditorRoot";
         this.camera = new Camera3D();
         this.camera.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
         this.camera.setPositionXYZ(250,-7800,4670);
         //root.addChild(this.camera);
         this.view = new View(this.camera,100,100);
         this.view.interactive = true;
         this.view.buttonMode = true;
         this.view.useHandCursor = false;
      }
      
      protected function getCameraFacing() : CameraFacing
      {
         var loc1:Matrix4 = this.camera.transformation;
         if(loc1.a > 1 / Math.SQRT2)
         {
            return CameraFacing.Y;
         }
         if(loc1.a < -1 / Math.SQRT2)
         {
            return CameraFacing.NEGATIVE_Y;
         }
         if(loc1.e > 0)
         {
            return CameraFacing.NEGATIVE_X;
         }
         return CameraFacing.X;
      }
      
      public function move(param1:Prop, param2:uint) : void
      {
         var loc3:Point = null;
         var loc4:CameraFacing = null;
         var loc5:Point = null;
         if(param1 != null)
         {
            loc3 = new Point();
            switch(param2)
            {
               case KeyboardUtils.UP:
                  loc3.y = 1;
                  break;
               case KeyboardUtils.DOWN:
                  loc3.y = -1;
                  break;
               case KeyboardUtils.LEFT:
                  loc3.x = -1;
                  break;
               case KeyboardUtils.RIGHT:
                  loc3.x = 1;
            }
            if(loc3.length > 0)
            {
               loc4 = this.getCameraFacing();
               loc5 = loc4.getGlobalVector(loc3);
               param1.x += (EditorScene.snapByHalf ? EditorScene.HORIZONTAL_GRID_RESOLUTION_2 : EditorScene.HORIZONTAL_GRID_RESOLUTION_1) * loc5.x;
               param1.y += (EditorScene.snapByHalf ? EditorScene.HORIZONTAL_GRID_RESOLUTION_2 : EditorScene.HORIZONTAL_GRID_RESOLUTION_1) * loc5.y;
            }
         }
      }
      
      public function getPropsGroupCenter(param1:Set) : Point
      {
         var loc8:* = undefined;
         var loc9:Number = NaN;
         var loc10:Prop = null;
         var loc11:Number = NaN;
         var loc12:Number = NaN;
         var loc2:Number = Number.POSITIVE_INFINITY;
         var loc3:Number = Number.NEGATIVE_INFINITY;
         var loc4:Number = Number.POSITIVE_INFINITY;
         var loc5:Number = Number.NEGATIVE_INFINITY;
         var loc6:Number = 0;
         var loc7:Number = 0;
         for(loc8 in param1)
         {
            loc10 = loc8;
            loc11 = loc10.distancesX.x + loc10.x;
            loc12 = loc10.distancesX.y + loc10.x;
            if(loc11 < loc2)
            {
               loc2 = loc11;
            }
            if(loc12 > loc3)
            {
               loc3 = loc12;
            }
            loc11 = loc10.distancesY.x + loc10.y;
            loc12 = loc10.distancesY.y + loc10.y;
            if(loc11 < loc4)
            {
               loc4 = loc11;
            }
            if(loc12 > loc5)
            {
               loc5 = loc12;
            }
            loc6 += loc10.x;
            loc7 += loc10.y;
         }
         loc9 = (loc3 - loc2) / EditorScene.hBase2 % 2;
         if(loc9 != (loc5 - loc4) / EditorScene.hBase2 % 2)
         {
            if(loc9 != 0)
            {
               loc6 /= param1.length;
               if(Math.abs(loc6 - loc3) < Math.abs(loc6 - loc2))
               {
                  loc3 += EditorScene.hBase2;
               }
               else
               {
                  loc2 -= EditorScene.hBase2;
               }
            }
            else
            {
               loc7 /= param1.length;
               if(Math.abs(loc7 - loc5) < Math.abs(loc7 - loc4))
               {
                  loc5 += EditorScene.hBase2;
               }
               else
               {
                  loc4 -= EditorScene.hBase2;
               }
            }
         }
         return new Point((loc3 + loc2) / 2,(loc5 + loc4) / 2);
      }
      
      public function rotatePropsCounterClockwise(param1:Set) : void
      {
         var loc3:* = undefined;
         var loc4:Prop = null;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc2:Point = this.getPropsGroupCenter(param1);
         for(loc3 in param1)
         {
            loc4 = loc3;
            loc5 = loc4.x;
            loc6 = loc4.y;
            loc4.x = -loc6 + loc2.x + loc2.y;
            loc4.y = loc5 + loc2.y - loc2.x;
            loc4.rotateCounterClockwise();
         }
      }
      
      public function rotatePropsClockwise(param1:Set) : void
      {
         var loc3:* = undefined;
         var loc4:Prop = null;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc2:Point = this.getPropsGroupCenter(param1);
         for(loc3 in param1)
         {
            loc4 = loc3;
            loc5 = loc4.x;
            loc6 = loc4.y;
            loc4.x = loc6 + loc2.x - loc2.y;
            loc4.y = -loc5 + loc2.y + loc2.x;
            loc4.rotateClockwise();
         }
      }
   }
}

