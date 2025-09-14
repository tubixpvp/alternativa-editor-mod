package alternativa.editor.mapexport.xml
{
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.prop.CTFFlagBase;
   import alternativa.editor.prop.ControlPoint;
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import flash.filesystem.FileStream;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.editor.mapexport.FileExporter;
   import alternativa.editor.mapexport.CollisionPrimitivesCache;
   import alternativa.editor.mapexport.CollisionPrimitive;
   import alternativa.editor.mapexport.CollisionRect;
   import alternativa.editor.mapexport.CollisionBox;
   import alternativa.editor.mapexport.CollisionTriangle;
   
   public class TanksXmlExporterV1Lite extends FileExporter
   {
      private static const PRECISION:int = 3;
      
      private var collPrimCache:CollisionPrimitivesCache;
      
      public function TanksXmlExporterV1Lite(param1:Object3DContainer)
      {
         super(param1);
         this.collPrimCache = new CollisionPrimitivesCache();
      }
      
      protected static function addDominationControlPoint(param1:XML, param2:ControlPoint) : void
      {
         var loc4:XML = null;
         var loc6:SpawnPoint = null;
         var loc3:XMLList = param1.elements("dom-keypoints");
         if(loc3.length() == 0)
         {
            loc4 = <dom-keypoints/>;
            param1.appendChild(loc4);
         }
         else
         {
            loc4 = loc3[0];
         }
         var loc5:XML = <dom-keypoint free={param2.free} name={param2.controlPointName}/>;
         loc5.appendChild(getPositionXML(param2));
         for each(loc6 in param2.getSpawnPoints())
         {
            loc5.appendChild(getSpawnXml(loc6));
         }
         loc4.appendChild(loc5);
      }
      
      protected static function getPositionXML(param1:Prop) : XML
      {
         return <position>
				<x>{param1.x.toFixed(PRECISION)}</x>
				<y>{param1.y.toFixed(PRECISION)}</y>
				<z>{param1.z.toFixed(PRECISION)}</z>
			</position>;
      }
      
      protected static function getTileXml(param1:MeshProp) : XML
      {
         var loc2:XML = <prop library-name={param1.libraryName} group-name={param1.groupName} name={param1.name}>
				<rotation>
					<z>{param1.rotationZ.toFixed(6)}</z>
				</rotation>
				<texture-name>{param1.textureName}</texture-name>
			</prop>;
         loc2.appendChild(getPositionXML(param1));
         if(param1.free)
         {
            loc2.@free = "true";
         }
         return loc2;
      }
      
      protected static function addCtfFlag(param1:XML, param2:CTFFlagBase) : void
      {
         var loc4:XML = null;
         var loc5:XML = null;
         var loc3:XMLList = param1.elements("ctf-flags");
         if(loc3.length() == 0)
         {
            loc4 = <ctf-flags></ctf-flags>;
            param1.appendChild(loc4);
         }
         else
         {
            loc4 = loc3[0];
         }
         switch(param2.name)
         {
            case "red_flag":
               loc5 = <flag-red>
								<x>{param2.x.toFixed(PRECISION)}</x>
								<y>{param2.y.toFixed(PRECISION)}</y>
								<z>{param2.z.toFixed(PRECISION)}</z>
							</flag-red>;
               break;
            case "blue_flag":
               loc5 = <flag-blue>
								<x>{param2.x.toFixed(PRECISION)}</x>
								<y>{param2.y.toFixed(PRECISION)}</y>
								<z>{param2.z.toFixed(PRECISION)}</z>
							</flag-blue>;
         }
         loc4.appendChild(loc5);
      }
      
      public static function createPropCollisionPrimitives(param1:MeshProp) : Vector.<CollisionPrimitive>
      {
         var loc3:* = undefined;
         var loc4:Mesh = null;
         var loc5:String = null;
         var loc2:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
         for(loc3 in param1.collisionGeometry)
         {
            loc4 = loc3;
            loc5 = loc4.name.toLowerCase();
            if(loc5.indexOf("plane") == 0)
            {
               loc2.push(new CollisionRect(0,loc4));
            }
            else if(loc5.indexOf("box") == 0)
            {
               loc2.push(new CollisionBox(0,loc4));
            }
            else if(loc5.indexOf("tri") == 0)
            {
               loc2.push(new CollisionTriangle(0,loc4));
            }
         }
         return loc2;
      }
      
      protected static function getSpawnXml(param1:SpawnPoint) : XML
      {
         var loc2:XML = <spawn-point type={param1.name}>
				<rotation>
					<z>{param1.rotationZ.toFixed(PRECISION)}</z>
				</rotation>
			</spawn-point>;
         loc2.appendChild(getPositionXML(param1));
         if(param1.free)
         {
            loc2.@free = "true";
         }
         return loc2;
      }
      
      protected static function getBonusXml(param1:FreeBonusRegion) : XML
      {
         var loc3:* = undefined;
         var loc4:* = undefined;
         var loc2:XML = <bonus-region name={param1.name} parachute={param1.parachute}>
						<rotation>
							<z>{param1.rotationZ.toFixed(PRECISION)}</z>
						</rotation>
						<min>
							<x>{param1.minX.toFixed(PRECISION)}</x>
							<y>{param1.minY.toFixed(PRECISION)}</y>
							<z>{param1.minZ.toFixed(PRECISION)}</z>
						</min>
						<max>
							<x>{param1.maxx.toFixed(PRECISION)}</x>
							<y>{param1.maxy.toFixed(PRECISION)}</y>
							<z>{param1.maxz.toFixed(PRECISION)}</z>
						</max>
					</bonus-region>;
         loc2.appendChild(getPositionXML(param1));
         if(param1.free)
         {
            loc2.@free = "true";
         }
         for(loc3 in param1.typeNames)
         {
            loc2.appendChild(<bonus-type>{loc3}</bonus-type>);
         }
         for(loc4 in param1.gameModes)
         {
            loc2.appendChild(<game-mode>{loc4}</game-mode>);
         }
         return loc2;
      }
      
      override public function exportToFileStream(param1:FileStream) : void
      {
         var loc8:Prop = null;
         var loc9:MeshProp = null;
         var loc2:XML = <map version="1.0.Light">
						<static-geometry>
						</static-geometry>
						<collision-geometry>
						</collision-geometry>
						<spawn-points>
						</spawn-points>
						<bonus-regions>
						</bonus-regions>
					</map>;
         var loc3:XML = loc2.child("static-geometry")[0];
         var loc4:XML = loc2.child("collision-geometry")[0];
         var loc5:XML = loc2.child("bonus-regions")[0];
         var loc6:XML = loc2.child("spawn-points")[0];
         for each(var loc7:Object3D in sceneRoot.children)
         {
            loc8 = loc7 as Prop;
            if(!loc8)
            {
               continue;
            }
            switch(loc8.type)
            {
               case Prop.BONUS:
                  loc5.appendChild(getBonusXml(loc8 as FreeBonusRegion));
                  break;
               case Prop.SPAWN:
                  if(loc8.name != FunctionalProps.DOMINATION_SPAWN)
                  {
                     loc6.appendChild(getSpawnXml(loc8 as SpawnPoint));
                  }
                  break;
               case Prop.FLAG:
                  addCtfFlag(loc2,loc8 as CTFFlagBase);
                  break;
               case Prop.TILE:
                  loc9 = loc8 as MeshProp;
                  loc3.appendChild(getTileXml(loc9));
                  this.createTileCollisionXml(loc9,loc4);
                  break;
               case Prop.DOMINATION_CONTROL_POINT:
                  addDominationControlPoint(loc2,loc8 as ControlPoint);
                  break;
            }
         }
         param1.writeUTFBytes(loc2.toXMLString());
      }
      
      protected function createTileCollisionXml(param1:MeshProp, param2:XML) : void
      {
         if(!param1.collisionEnabled)
         {
            return;
         }
         var loc4:CollisionPrimitive = null;
         var loc3:Vector.<CollisionPrimitive> = this.collPrimCache.getPrimitives(param1.libraryName,param1.groupName,param1.name);
         if(loc3 == null)
         {
            loc3 = createPropCollisionPrimitives(param1);
            this.collPrimCache.addPrimitives(param1.libraryName,param1.groupName,param1.name,loc3);
         }
         for each(loc4 in loc3)
         {
            param2.appendChild(loc4.getXml(param1.transformation));
         }
      }
   }
}

