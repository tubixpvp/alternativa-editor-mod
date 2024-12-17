package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.PolyPrimitive;
   import alternativa.engine3d.core.Scene3D;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.display.Skin;
   
   use namespace alternativa3d;
   
   public class SurfaceMaterial extends Material
   {
      alternativa3d var _surface:Surface;
      
      alternativa3d var useUV:Boolean = false;
      
      public function SurfaceMaterial(param1:Number = 1, param2:String = "normal")
      {
         super(param1,param2);
      }
      
      public function get surface() : Surface
      {
         return this.alternativa3d::_surface;
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
      }
      
      alternativa3d function addToMesh(param1:Mesh) : void
      {
      }
      
      alternativa3d function removeFromMesh(param1:Mesh) : void
      {
      }
      
      alternativa3d function addToSurface(param1:Surface) : void
      {
         this.alternativa3d::_surface = param1;
      }
      
      alternativa3d function removeFromSurface(param1:Surface) : void
      {
         this.alternativa3d::_surface = null;
      }
      
      override protected function markToChange() : void
      {
         if(this.alternativa3d::_surface != null)
         {
            this.alternativa3d::_surface.alternativa3d::addMaterialChangedOperationToScene();
         }
      }
      
      alternativa3d function canDraw(param1:PolyPrimitive) : Boolean
      {
         return true;
      }
      
      alternativa3d function draw(param1:Camera3D, param2:Skin, param3:uint, param4:Array) : void
      {
         param2.alpha = alternativa3d::_alpha;
         param2.blendMode = alternativa3d::_blendMode;
      }
      
      override public function clone() : Material
      {
         return new SurfaceMaterial(alternativa3d::_alpha,alternativa3d::_blendMode);
      }
   }
}

