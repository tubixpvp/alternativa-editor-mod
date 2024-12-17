package alternativa.editor.mapexport
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Mesh;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   
   public class CollisionRect extends CollisionPrimitive
   {
      public var width:Number = 0;
      
      public var length:Number = 0;
      
      public function CollisionRect(param1:int, param2:Mesh = null)
      {
         super(param1,param2);
      }
      
      override public function parse(param1:Mesh) : void
      {
         var loc2:int = 0;
         var loc14:Point3D = null;
         var loc15:Number = NaN;
         var loc3:Face = param1.alternativa3d::_faces.peek() as Face;
         var loc4:Number = -1;
         var loc5:int = 0;
         var loc6:Vector.<Point3D> = Vector.<Point3D>([new Point3D(),new Point3D(),new Point3D()]);
         var loc7:Vector.<Number> = new Vector.<Number>(3);
         loc2 = 0;
         while(loc2 < 3)
         {
            loc14 = loc6[loc2];
            loc14.difference(loc3.vertices[(loc2 + 1) % 3].alternativa3d::_coords,loc3.vertices[loc2].alternativa3d::_coords);
            loc15 = loc7[loc2] = loc14.length;
            if(loc15 > loc4)
            {
               loc4 = loc15;
               loc5 = loc2;
            }
            loc2++;
         }
         var loc8:int = (loc5 + 2) % 3;
         var loc9:int = (loc5 + 1) % 3;
         var loc10:Point3D = loc6[loc8];
         var loc11:Point3D = loc6[loc9];
         loc11.invert();
         this.width = loc7[loc8];
         this.length = loc7[loc9];
         var loc12:Point3D = loc3.vertices[(loc5 + 2) % 3].alternativa3d::_coords.clone();
         loc12.x += 0.5 * (loc10.x + loc11.x);
         loc12.y += 0.5 * (loc10.y + loc11.y);
         loc12.z += 0.5 * (loc10.z + loc11.z);
         loc10.normalize();
         loc11.normalize();
         var loc13:Point3D = Point3D.cross(loc10,loc11);
         transform.setVectors(loc10,loc11,loc13,loc12);
         transform.rotate(param1.alternativa3d::_rotationX,param1.alternativa3d::_rotationY,param1.alternativa3d::_rotationZ);
         transform.translate(param1.alternativa3d::_coords.x,param1.alternativa3d::_coords.y,param1.alternativa3d::_coords.z);
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
         return <collision-plane id={id}>
					<width>{this.width.toFixed(PRECISION)}</width>
					<length>{this.length.toFixed(PRECISION)}</length>
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
				</collision-plane>;
      }
      
      override public function getXml2() : XML
      {
         var loc1:Point3D = transform.getRotations();
         var loc2:XML = <collision-rect/>;
         var loc3:XML = <size x={this.width.toFixed(PRECISION)} y={this.length.toFixed(PRECISION)}/>;
         loc2.appendChild(loc3);
         loc2.appendChild(getVector3DXML(<position/>,transform.d,transform.h,transform.l,PRECISION));
         loc2.appendChild(getVector3DXML(<angles/>,loc1.x,loc1.y,loc1.z,ROT_PRECISION));
         return loc2;
      }
   }
}

