package alternativa.editor.prop
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Point;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Map;
   
   public class Sprite3DProp extends MeshProp
   {
      private static const EMPTY_OBJECTS:Vector.<Object3D> = new Vector.<Object3D>();
      
      public function Sprite3DProp(param1:Sprite3D, name:String, libraryName:String, groupName:String, param5:Boolean = true)
      {
         super(param1,EMPTY_OBJECTS,name,libraryName,groupName,param5);
         this.collisionEnabled = false;
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
         _material = (_object as Sprite3D).material; //no need to clone(), already cloned earlier
         bitmapData = (_material as TextureMaterial).texture;

         this.bitmaps = new Map();
         this.bitmaps.add("DEFAULT", bitmapData);
      }
      
      override public function setMaterial(param1:Material) : void
      {
         (_object as Sprite3D).material = param1;
      }
      
      override public function get vertices() : Vector.<Vertex>
      {
         return Vector.<Vertex>([new Vertex()]);
      }

      protected override function setToCollisionDisabledTextureIfNeeded() : void
      {
      }
      
      override public function clone() : Object3D
      {
         var loc1:Sprite3D = _object.clone() as Sprite3D;
         loc1.material = _material.clone() as TextureMaterial;
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

