package alternativa.editor.prop
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Point;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Map;
   import flash.display.BitmapData;
   
   public class Sprite3DProp extends MeshProp
   {
      private static const EMPTY_OBJECTS:Vector.<Object3D> = new Vector.<Object3D>();
      
      public function Sprite3DProp(param1:Sprite3D, name:String, libraryName:String, groupName:String, param5:Boolean = true)
      {
         super(param1,EMPTY_OBJECTS,name,libraryName,groupName,param5);
      }

      public override function dispose() : void
      {
         (_object as Sprite3D).material = null;
         super.dispose();
      }
      
      public function get scale() : Number
      {
         return (_object as Sprite3D).scaleX;
      }
      
      override public function calculate() : void
      {
         distancesX = new Point();
         distancesY = new Point();
         distancesZ = new Point();
         _multi = false;
         height = -1;
      }

      override protected function initBitmapData() : void
      {
         this.bitmaps = new Map();

         var material:Material = (_object as Sprite3D).material;
         var textureMaterial:TextureMaterial = material as TextureMaterial;
         if (textureMaterial == null || textureMaterial.texture == null)
            return;
         var bitmap:BitmapData = textureMaterial.texture;
         
         this.bitmaps.add("DEFAULT", bitmap);
         this.changeTexture(bitmap);
      }
      
      override protected function setMaterial(material:Material) : void
      {
         (_object as Sprite3D).material = material;
      }
      
      override public function clone() : Object3D
      {
         var loc1:Sprite3D = _object.clone() as Sprite3D;
         var loc2:Sprite3DProp = new Sprite3DProp(loc1,name,_libraryName,_groupName,false);
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2._multi = _multi;
         loc2.name = name;
         loc2.bitmaps = bitmaps;
         loc2.height = height;
         return loc2;
      }
   }
}

