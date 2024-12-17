package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Scene3D;
   import alternativa.engine3d.core.Sprite3D;
   import alternativa.engine3d.display.Skin;
   
   use namespace alternativa3d;
   
   public class SpriteMaterial extends Material
   {
      alternativa3d var _sprite:Sprite3D;
      
      public function SpriteMaterial(param1:Number = 1, param2:String = "normal")
      {
         super(param1,param2);
      }
      
      public function get sprite() : Sprite3D
      {
         return this.alternativa3d::_sprite;
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
      }
      
      alternativa3d function addToSprite(param1:Sprite3D) : void
      {
         this.alternativa3d::_sprite = param1;
      }
      
      alternativa3d function removeFromSprite(param1:Sprite3D) : void
      {
         this.alternativa3d::_sprite = null;
      }
      
      alternativa3d function canDraw(param1:Camera3D) : Boolean
      {
         return true;
      }
      
      alternativa3d function draw(param1:Camera3D, param2:Skin) : void
      {
         param2.alpha = alternativa3d::_alpha;
         param2.blendMode = alternativa3d::_blendMode;
      }
      
      override protected function markToChange() : void
      {
         if(this.alternativa3d::_sprite != null)
         {
            this.alternativa3d::_sprite.alternativa3d::addMaterialChangedOperationToScene();
         }
      }
      
      override public function clone() : Material
      {
         return new SpriteMaterial(alternativa3d::_alpha,alternativa3d::_blendMode);
      }
   }
}

