package alternativa.editor.prop
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Point;
   import alternativa.engine3d.materials.TextureMaterial;
   
   public class Sprite3DProp extends MeshProp
   {
      private static const EMPTY_OBJECTS:Vector.<Object3D> = new Vector.<Object3D>();

      private var spriteTextureMaterial:TextureMaterial;
      
      public function Sprite3DProp(param1:Sprite3D, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         super(param1,EMPTY_OBJECTS,param2,param3,param4,param5);
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
      
      override public function setMaterial(param1:Material) : void
      {
         var loc2:TextureMaterial = param1 as TextureMaterial;
         if(loc2)
         {
            //loc2.originX = this.spriteTextureMaterial.originX;
            //loc2.originY = this.spriteTextureMaterial.originY;
         }
         (_object as Sprite3D).material = loc2;
      }
      
      override protected function initBitmapData() : void
      {
         _material = (_object as Sprite3D).material;
         this.spriteTextureMaterial = _material as TextureMaterial;
         bitmapData = this.spriteTextureMaterial.texture;
      }
      
      override public function get vertices() : Vector.<Vertex>
      {
         /*var loc1:Vertex = new Vertex(0,0,0);
         var loc2:Map = new Map();
         loc2.add("1",loc1);
         return loc2;*/
         return Vector.<Vertex>([new Vertex()]);
      }
      
      override protected function get newSelectedMaterial() : Material
      {
         return new TextureMaterial(_selectBitmapData);
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

