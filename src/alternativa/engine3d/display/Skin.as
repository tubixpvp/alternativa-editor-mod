package alternativa.engine3d.display
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.PolyPrimitive;
   import alternativa.engine3d.materials.Material;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class Skin extends Sprite
   {
      private static var collector:Array = new Array();
      
      alternativa3d var gfx:Graphics;
      
      alternativa3d var nextSkin:Skin;
      
      alternativa3d var primitive:PolyPrimitive;
      
      alternativa3d var material:Material;
      
      public function Skin()
      {
         this.alternativa3d::gfx = graphics;
         super();
      }
      
      alternativa3d static function createSkin() : Skin
      {
         var loc1:Skin = null;
         loc1 = collector.pop();
         if(loc1 != null)
         {
            return loc1;
         }
         return new Skin();
      }
      
      alternativa3d static function destroySkin(param1:Skin) : void
      {
         collector.push(param1);
      }
   }
}

