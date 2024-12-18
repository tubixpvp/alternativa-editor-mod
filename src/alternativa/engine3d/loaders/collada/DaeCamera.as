package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.core.Camera3D;
   
   use namespace collada;
   
   public class DaeCamera extends DaeElement
   {
       
      
      public function DaeCamera(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
      }
      
      private function setXFov(param1:Camera3D, param2:Number) : void
      {
      }
      
      public function parseCamera() : Camera3D
      {
         var _loc3_:Number = NaN;
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:Number = NaN;
         var _loc1_:Camera3D = new Camera3D();
         var _loc2_:XML = data.optics.technique_common.perspective[0];
         if(_loc2_)
         {
            _loc3_ = Math.PI / 180;
            _loc4_ = _loc2_.xfov[0];
            _loc5_ = _loc2_.yfov[0];
            _loc6_ = _loc2_.aspect_ratio[0];
            if(_loc6_ == null)
            {
               if(_loc4_ != null)
               {
                  this.setXFov(_loc1_,parseNumber(_loc4_) * _loc3_);
               }
               else if(_loc5_ != null)
               {
                  this.setXFov(_loc1_,parseNumber(_loc5_) * _loc3_);
               }
            }
            else
            {
               _loc9_ = parseNumber(_loc6_);
               if(_loc4_ != null)
               {
                  this.setXFov(_loc1_,parseNumber(_loc4_) * _loc3_);
               }
               else if(_loc5_ != null)
               {
                  this.setXFov(_loc1_,_loc9_ * parseNumber(_loc5_) * _loc3_);
               }
            }
            _loc7_ = _loc2_.znear[0];
            _loc8_ = _loc2_.zfar[0];
            if(_loc7_ != null)
            {
               _loc1_.nearClipping = parseNumber(_loc7_);
            }
            if(_loc8_ != null)
            {
               _loc1_.farClipping = parseNumber(_loc8_);
            }
         }
         return _loc1_;
      }
   }
}
