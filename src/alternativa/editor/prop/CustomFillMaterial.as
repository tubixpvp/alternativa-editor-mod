package alternativa.editor.prop
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.types.Point3D;
   import alternativa.utils.ColorUtils;
   
   use namespace alternativa3d;
   
   public class CustomFillMaterial extends FillMaterial
   {
      private var center:Point3D;
      
      private var lightPoint:Point3D;
      
      private var normal:Point3D;

      private var blendMode:String;
      
      public function CustomFillMaterial(param1:Point3D, param2:uint, param3:Number = 1, param4:String = "normal", param5:Number = -1, param6:uint = 0)
      {
         this.center = new Point3D();
         this.lightPoint = new Point3D();
         this.normal = new Point3D();
         //super(param2,param3,param4,param5,param6);
         super(param2, param3, param5, param6);
         this.lightPoint.copy(param1);
         this.blendMode = param4;
      }
      
      /*override alternativa3d function draw(param1:Camera3D, param2:Skin, param3:uint, param4:Array) : void
      {
         var loc5:PolyPrimitive = param2.alternativa3d::primitive;
         this.center.reset();
         var loc6:int = 0;
         while(loc6 < loc5.alternativa3d::num)
         {
            this.center.add(loc5.alternativa3d::points[loc6]);
            loc6++;
         }
         this.center.multiply(1 / loc5.alternativa3d::num);
         this.normal.difference(this.lightPoint,this.center);
         this.normal.normalize();
         var loc7:uint = uint(alternativa3d::_color);
         var loc8:Number = 0.5 * (1 + this.normal.dot(loc5.alternativa3d::face.alternativa3d::globalNormal));
         alternativa3d::_color = ColorUtils.multiply(alternativa3d::_color,loc8);
         super.alternativa3d::draw(param1,param2,param3,param4);
         alternativa3d::_color = loc7;
      }*/
      
      override public function clone() : Material
      {
         return new CustomFillMaterial(this.lightPoint,color,alpha,blendMode,lineThickness,lineColor);
      }
   }
}

