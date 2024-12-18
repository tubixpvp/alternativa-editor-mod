package alternativa.editor.mapexport
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Vertex;
   import alternativa.types.Matrix4;
   import alternativa.types.Point3D;
   
   public class CollisionBox extends CollisionPrimitive
   {
      public var size:Point3D;
      
      public function CollisionBox(param1:int, param2:Mesh = null)
      {
         this.size = new Point3D();
         super(param1,param2);
      }
      
      override public function parse(param1:Mesh) : void
      {
         var loc8:Vertex = null;
         var loc9:Point3D = null;
         var loc10:Point3D = null;
         var loc2:Number = Number.MAX_VALUE;
         var loc3:Number = -Number.MAX_VALUE;
         var loc4:Number = Number.MAX_VALUE;
         var loc5:Number = -Number.MAX_VALUE;
         var loc6:Number = Number.MAX_VALUE;
         var loc7:Number = -Number.MAX_VALUE;
         for each(loc8 in param1.alternativa3d::_vertices)
         {
            loc10 = loc8.alternativa3d::_coords;
            if(loc10.x < loc2)
            {
               loc2 = loc10.x;
            }
            if(loc10.x > loc3)
            {
               loc3 = loc10.x;
            }
            if(loc10.y < loc4)
            {
               loc4 = loc10.y;
            }
            if(loc10.y > loc5)
            {
               loc5 = loc10.y;
            }
            if(loc10.z < loc6)
            {
               loc6 = loc10.z;
            }
            if(loc10.z > loc7)
            {
               loc7 = loc10.z;
            }
         }
         this.size.x = loc3 - loc2;
         this.size.y = loc5 - loc4;
         this.size.z = loc7 - loc6;
         loc9 = new Point3D(0.5 * (loc3 + loc2),0.5 * (loc5 + loc4),0.5 * (loc7 + loc6));
         transform.toIdentity();
         transform.rotate(param1.alternativa3d::_rotationX,param1.alternativa3d::_rotationY,param1.alternativa3d::_rotationZ);
         transform.translate(param1.alternativa3d::_coords.x,param1.alternativa3d::_coords.y,param1.alternativa3d::_coords.z);
         loc9.transform(transform);
         transform.d = loc9.x;
         transform.h = loc9.y;
         transform.l = loc9.z;
      }
      
      override public function getXml(param1:Matrix4) : XML
      {
         var loc2:Matrix4 = null;
         if(param1 == null)
         {
            loc2 = transform;
         }
         else
         {
            loc2 = transform.clone();
            loc2.combine(param1);
         }
         var loc3:Point3D = loc2.getRotations();
         return <collision-box id={id}>
				<size>
					<x>{this.size.x.toFixed(PRECISION)}</x>
					<y>{this.size.y.toFixed(PRECISION)}</y>
					<z>{this.size.z.toFixed(PRECISION)}</z>
				</size>
				<position>
					<x>{loc2.d.toFixed(PRECISION)}</x>
					<y>{loc2.h.toFixed(PRECISION)}</y>
					<z>{loc2.l.toFixed(PRECISION)}</z>
				</position>
				<rotation>
					<x>{loc3.x.toFixed(ROT_PRECISION)}</x>
					<y>{loc3.y.toFixed(ROT_PRECISION)}</y>
					<z>{loc3.z.toFixed(ROT_PRECISION)}</z>
				</rotation>
			</collision-box>;
      }
      
      override public function getXml2() : XML
      {
         var loc1:Point3D = transform.getRotations();
         var loc2:XML = <collision-box/>;
         loc2.appendChild(getVector3DXML(<size/>,this.size.x,this.size.y,this.size.z,PRECISION));
         loc2.appendChild(getVector3DXML(<position/>,transform.d,transform.h,transform.l,PRECISION));
         loc2.appendChild(getVector3DXML(<angles/>,loc1.x,loc1.y,loc1.z,ROT_PRECISION));
         return loc2;
      }
   }
}

