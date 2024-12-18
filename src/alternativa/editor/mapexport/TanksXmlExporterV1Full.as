package alternativa.editor.mapexport
{
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.prop.CTFFlagBase;
   import alternativa.editor.prop.ControlPoint;
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.KillBox;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.engine3d.core.Object3D;
   import flash.filesystem.FileStream;
   import alternativa.engine3d.core.Object3DContainer;
   
   public class TanksXmlExporterV1Full extends TanksXmlExporterV1Lite
   {
      public function TanksXmlExporterV1Full(param1:Object3DContainer)
      {
         super(param1);
      }
      
      private static function getKillXml(param1:KillBox) : XML
      {
         var loc2:XML = <{FunctionalProps.KILL_BOX_NAME} type={param1.name}>
				<minX>{param1.minX}</minX>
				<minY>{param1.minY}</minY>
				<minZ>{param1.minZ}</minZ>

				<maxX>{param1.maxx}</maxX>
				<maxY>{param1.maxy}</maxY>
				<maxZ>{param1.maxz}</maxZ>


				<action>{param1.action}</action>
			</{FunctionalProps.KILL_BOX_NAME}>;
         if(param1.free)
         {
            loc2.@free = "true";
         }
         return loc2;
      }
      
      override public function exportToFileStream(param1:FileStream) : void
      {
         var loc9:Prop = null;
         var loc10:MeshProp = null;
         var loc2:XML = new XML("<map version=\"1.0\">\r\n\t\t\t\t\t\t<static-geometry>\r\n\t\t\t\t\t\t</static-geometry>\r\n\t\t\t\t\t\t<collision-geometry>\r\n\t\t\t\t\t\t</collision-geometry>\r\n\t\t\t\t\t\t<spawn-points>\r\n\t\t\t\t\t\t</spawn-points>\r\n\t\t\t\t\t\t<bonus-regions>\r\n\t\t\t\t\t\t</bonus-regions>\r\n\t\t\t\t\t\t" + ("<" + FunctionalProps.KILL_GEOMETRY + "/>") + "\r\n\t\t\t\t\t</map>");
         var loc3:XML = loc2.child("static-geometry")[0];
         var loc4:XML = loc2.child("collision-geometry")[0];
         var loc5:XML = loc2.child("bonus-regions")[0];
         var loc6:XML = loc2.child("spawn-points")[0];
         var loc7:XML = loc2.child(FunctionalProps.KILL_GEOMETRY)[0];
         for each(var loc8:Object3D in sceneRoot.children)
         {
            loc9 = loc8 as Prop;
            if(!loc9)
            {
               continue;
            }
            switch(loc9.type)
            {
               case Prop.BONUS:
                  loc5.appendChild(getBonusXml(loc9 as FreeBonusRegion));
                  break;
               case Prop.KILL_GEOMETRY:
                  loc7.appendChild(getKillXml(loc9 as KillBox));
                  break;
               case Prop.SPAWN:
                  if(loc9.name != FunctionalProps.DOMINATION_SPAWN)
                  {
                     loc6.appendChild(getSpawnXml(loc9 as SpawnPoint));
                  }
                  break;
               case Prop.FLAG:
                  addCtfFlag(loc2,loc9 as CTFFlagBase);
                  break;
               case Prop.TILE:
                  loc10 = loc9 as MeshProp;
                  loc3.appendChild(getTileXml(loc10));
                  createTileCollisionXml(loc10,loc4);
                  break;
               case Prop.DOMINATION_CONTROL_POINT:
                  addDominationControlPoint(loc2,loc9 as ControlPoint);
                  break;
            }
         }
         param1.writeUTFBytes(loc2.toXMLString());
      }
   }
}

