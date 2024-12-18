package alternativa.engine3d.lights
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import flash.display.Sprite;
   use namespace alternativa3d;
   public class AmbientLight extends Light3D
   {
       
      
      public function AmbientLight(param1:uint)
      {
         super();
         this.color = param1;
         calculateBounds();
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:AmbientLight = new AmbientLight(color);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override alternativa3d function drawDebug(param1:Camera3D) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:int = param1.checkInDebug(this);
         if(_loc2_ > 0)
         {
            _loc3_ = param1.view.canvas;
            if(_loc2_ & Debug.LIGHTS && ml > param1.nearClipping)
            {
            }
            if(_loc2_ & Debug.BOUNDS)
            {
               Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ,10092288);
            }
         }
      }
   }
}
