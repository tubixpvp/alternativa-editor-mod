package alternativa.editor.mapexport
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Vertex;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   
   public class CollisionTriangle extends CollisionPrimitive
   {
      private var v0:Point3D;
      
      private var v1:Point3D;
      
      private var v2:Point3D;
      
      public function CollisionTriangle(param1:int, param2:Mesh = null)
      {
         this.v0 = new Point3D();
         this.v1 = new Point3D();
         this.v2 = new Point3D();
         super(param1,param2);
      }
      
      override public function parse(param1:Mesh) : void
      {
         var loc2:Array = Face(param1.alternativa3d::_faces.peek()).vertices;
         this.v0.copy(Vertex(loc2[0]).alternativa3d::_coords);
         this.v1.copy(Vertex(loc2[1]).alternativa3d::_coords);
         this.v2.copy(Vertex(loc2[2]).alternativa3d::_coords);
         var loc3:Point3D = new Point3D();
         loc3.x = (this.v0.x + this.v1.x + this.v2.x) / 3;
         loc3.y = (this.v0.y + this.v1.y + this.v2.y) / 3;
         loc3.z = (this.v0.z + this.v1.z + this.v2.z) / 3;
         var loc4:Point3D = new Point3D();
         loc4.difference(this.v1,this.v0);
         this.v1.reset(loc4.length,0,0);
         loc4.normalize();
         var loc5:Point3D = new Point3D();
         loc5.difference(this.v2,this.v0);
         var loc6:Number = loc5.dot(loc4);
         var loc7:Number = Math.sqrt(loc5.lengthSqr - loc6 * loc6);
         this.v2.reset(loc6,loc7,0);
         var loc8:Point3D = new Point3D();
         loc8.cross2(loc4,loc5);
         loc8.normalize();
         loc5.cross2(loc8,loc4);
         loc5.normalize();
         transform.setVectors(loc4,loc5,loc8,loc3);
         transform.rotate(param1.alternativa3d::_rotationX,param1.alternativa3d::_rotationY,param1.alternativa3d::_rotationZ);
         transform.translate(param1.alternativa3d::_coords.x,param1.alternativa3d::_coords.y,param1.alternativa3d::_coords.z);
         loc6 = (this.v1.x + this.v2.x) / 3;
         loc7 = (this.v1.y + this.v2.y) / 3;
         this.v0.reset(-loc6,-loc7,0);
         this.v1.x -= loc6;
         this.v1.y -= loc7;
         this.v2.x -= loc6;
         this.v2.y -= loc7;
      }
      
      override public function getXml(param1:Matrix3D) : XML
      {
         var loc2:Matrix3D = null;
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
         return <collision-triangle id={id}>
				<v0>
					<x>{this.v0.x.toFixed(PRECISION)}</x>
					<y>{this.v0.y.toFixed(PRECISION)}</y>
					<z>{this.v0.z.toFixed(PRECISION)}</z>
				</v0>
				<v1>
					<x>{this.v1.x.toFixed(PRECISION)}</x>
					<y>{this.v1.y.toFixed(PRECISION)}</y>
					<z>{this.v1.z.toFixed(PRECISION)}</z>
				</v1>
				<v2>
					<x>{this.v2.x.toFixed(PRECISION)}</x>
					<y>{this.v2.y.toFixed(PRECISION)}</y>
					<z>{this.v2.z.toFixed(PRECISION)}</z>
				</v2>
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
			</collision-triangle>;
      }
      
      override public function getXml2() : XML
      {
         var loc1:Point3D = transform.getRotations();
         var loc2:XML = <collision-triangle/>;
         loc2.appendChild(this.getVector2DXML(<v0/>,this.v0,PRECISION));
         loc2.appendChild(this.getVector2DXML(<v1/>,this.v1,PRECISION));
         loc2.appendChild(this.getVector2DXML(<v2/>,this.v2,PRECISION));
         loc2.appendChild(getVector3DXML(<position/>,transform.d,transform.h,transform.l,PRECISION));
         loc2.appendChild(getVector3DXML(<angles/>,loc1.x,loc1.y,loc1.z,ROT_PRECISION));
         return loc2;
      }
      
      private function getVector2DXML(param1:XML, param2:Point3D, param3:int) : XML
      {
         param1.@x = param2.x.toFixed(param3);
         param1.@y = param2.y.toFixed(param3);
         return param1;
      }
   }
}

