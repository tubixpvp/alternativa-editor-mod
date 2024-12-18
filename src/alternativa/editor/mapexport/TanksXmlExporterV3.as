package alternativa.editor.mapexport
{
   import alternativa.editor.prop.BonusRegion;
   import alternativa.editor.prop.CTFFlagBase;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import flash.filesystem.FileStream;
   import alternativa.engine3d.core.Object3DContainer;
   
   use namespace alternativa3d;
   
   public class TanksXmlExporterV3 extends FileExporter
   {
      private static const VERSION:String = "3.0";
      
      private const PRECISION:int = 3;
      
      private const ROT_PRECISION:int = 6;
      
      private var propIndex:int;
      
      private var mapObjectIndex:int;
      
      private var collisionBoxIndex:int;
      
      private var collisionRectIndex:int;
      
      private var collisionTriIndex:int;
      
      private var propRegistry:Object;
      
      private var propsXML:XML;
      
      private var meshesXML:XML;
      
      private var spritesXML:XML;
      
      public function TanksXmlExporterV3(param1:Object3DContainer)
      {
         super(param1);
      }
      
      override public function exportToFileStream(param1:FileStream) : void
      {
         var loc7:XML = null;
         var loc8:PropRegistryData = null;
         var loc9:Prop = null;
         this.propIndex = 0;
         this.mapObjectIndex = 0;
         this.collisionBoxIndex = 0;
         this.collisionRectIndex = 0;
         this.collisionTriIndex = 0;
         this.propRegistry = {};
         var loc2:XML = <tanks-map version={VERSION}/>;
         this.propsXML = <x/>;
         this.meshesXML = <x/>;
         this.spritesXML = <x/>;
         var loc3:XML = <x/>;
         var loc4:XML = <x/>;
         var loc5:XML = <ctf-flags/>;
         for each(var loc6:Object3D in sceneRoot.children)
         {
            loc9 = loc6 as Prop;
            if(!loc9)
            {
               continue;
            }
            switch(loc9.type)
            {
               case Prop.BONUS:
                  break;
               case Prop.SPAWN:
                  loc4.appendChild(this.getSpawnXml(SpawnPoint(loc9)));
                  break;
               case Prop.FLAG:
                  this.addCtfFlag(loc5,CTFFlagBase(loc9));
                  break;
               case Prop.TILE:
                  this.processTile(MeshProp(loc9));
                  break;
            }
         }
         for each(loc7 in [this.propsXML,this.meshesXML,this.spritesXML,loc4,loc3])
         {
            loc2.appendChild(loc7.children());
         }
         if(loc5.children().length() > 0)
         {
            loc2.appendChild(loc5);
         }
         for each(loc8 in this.propRegistry)
         {
            loc8.createCollisionRecords();
         }
         param1.writeUTFBytes(loc2.toXMLString());
         loc3 = null;
         loc4 = null;
      }
      
      private function processTile(param1:MeshProp) : void
      {
         var loc4:XML = null;
         var loc2:String = param1.libraryName + "/" + param1.groupName + "/" + param1.name;
         var loc3:PropRegistryData = this.propRegistry[loc2];
         if(loc3 == null)
         {
            loc4 = <prop library-name={param1.libraryName} group-name={param1.groupName} name={param1.name}/>;
            this.propsXML.appendChild(loc4);
            loc3 = new PropRegistryData(this.propIndex++,loc4);
            this.createPropCollisionPrimitives(loc3,param1);
            this.propRegistry[loc2] = loc3;
         }
         this.addReferences(this.mapObjectIndex,loc3,param1);
         ++this.mapObjectIndex;
      }
      
      private function createPropCollisionPrimitives(param1:PropRegistryData, param2:MeshProp) : void
      {
         var loc6:* = undefined;
         var loc7:Mesh = null;
         var loc8:String = null;
         var loc3:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
         var loc4:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
         var loc5:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
         for(loc6 in param2.collisionGeometry)
         {
            loc7 = loc6;
            loc8 = loc7.name.toLowerCase();
            if(loc8.indexOf("plane") == 0)
            {
               loc4.push(new CollisionRect(this.collisionRectIndex++,loc7));
            }
            else if(loc8.indexOf("box") == 0)
            {
               loc3.push(new CollisionBox(this.collisionBoxIndex++,loc7));
            }
            else if(loc8.indexOf("tri") == 0)
            {
               loc5.push(new CollisionTriangle(this.collisionTriIndex++,loc7));
            }
         }
         if(loc3.length > 0)
         {
            param1.collisionBoxes = loc3;
         }
         if(loc4.length > 0)
         {
            param1.collisionRects = loc4;
         }
         if(loc5.length > 0)
         {
            param1.collisionTriangles = loc5;
         }
      }
      
      private function addCollisionRegistryPrimitives(param1:XML, param2:Vector.<CollisionPrimitive>) : void
      {
         var loc3:CollisionPrimitive = null;
         if(param2 == null)
         {
            return;
         }
         for each(loc3 in param2)
         {
            param1.appendChild(loc3.getXml2());
         }
      }
      
      private function addReferences(param1:int, param2:PropRegistryData, param3:MeshProp) : void
      {
         var loc5:String = null;
         var loc4:XML = <x prop-index={param2.propIndex}/>;
         if(param3.free)
         {
            loc4.@free = "true";
         }
         loc4.appendChild(this.getVector3DXML(<position/>,param3.x,param3.y,param3.z,this.PRECISION));
         if(param3 is Sprite3DProp)
         {
            loc4.setName("sprite");
            this.spritesXML.appendChild(loc4);
         }
         else
         {
            loc4.setName("mesh");
            loc4.appendChild(<rotation-z>{param3.rotationZ.toFixed(this.ROT_PRECISION)}</rotation-z>);
            loc5 = param3.textureName;
            if(loc5 != null && loc5 != "")
            {
               loc4.appendChild(<texture-index>{param2.getTextureIndex(loc5)}</texture-index>);
            }
            this.meshesXML.appendChild(loc4);
         }
      }
      
      private function addCtfFlag(param1:XML, param2:CTFFlagBase) : void
      {
         var loc3:XML = null;
         switch(param2.name)
         {
            case "red_flag":
               loc3 = <flag-red/>;
               break;
            case "blue_flag":
               loc3 = <flag-blue/>;
         }
         param1.appendChild(this.getVector3DXML(loc3,param2.x,param2.y,param2.z,this.PRECISION));
      }
      
      private function getSpawnXml(param1:SpawnPoint) : XML
      {
         var loc2:XML = <spawn-point type={param1.name}/>;
         loc2.appendChild(this.getVector3DXML(<position/>,param1.x,param1.y,param1.z,this.PRECISION));
         loc2.appendChild(<direction>{param1.rotationZ.toFixed(this.PRECISION)}</direction>);
         if(param1.free)
         {
            loc2.@free = "true";
         }
         return loc2;
      }
      
      private function getBonusXml(param1:BonusRegion) : XML
      {
         var loc3:* = undefined;
         var loc2:XML = <bonus-region name={param1.name}/>;
         if(param1.free)
         {
            loc2.@free = "true";
         }
         loc2.appendChild(this.getVector3DXML(<position/>,param1.x,param1.y,param1.z,this.PRECISION));
         loc2.appendChild(<rotation>{param1.rotationZ.toFixed(this.ROT_PRECISION)}</rotation>);
         loc2.appendChild(this.getVector3DXML(<min/>,param1.x + param1.distancesX.x,param1.y + param1.distancesY.x,param1.z + param1.distancesZ.x,this.PRECISION));
         loc2.appendChild(this.getVector3DXML(<max/>,param1.x + param1.distancesX.y,param1.y + param1.distancesY.y,param1.z + param1.distancesZ.y,this.PRECISION));
         for(loc3 in param1.typeNames)
         {
            loc2.appendChild(<bonus-type>{loc3}</bonus-type>);
         }
         return loc2;
      }
      
      private function getVector3DXML(param1:XML, param2:Number, param3:Number, param4:Number, param5:int) : XML
      {
         param1.@x = param2.toFixed(param5);
         param1.@y = param3.toFixed(param5);
         param1.@z = param4.toFixed(param5);
         return param1;
      }
   }
}

import alternativa.editor.mapexport.CollisionPrimitive;

class PropRegistryData
{
   public var propIndex:int;
   
   public var collisionBoxes:Vector.<CollisionPrimitive>;
   
   public var collisionRects:Vector.<CollisionPrimitive>;
   
   public var collisionTriangles:Vector.<CollisionPrimitive>;
   
   private var textureNames:Array;
   
   private var xml:XML;
   
   public function PropRegistryData(param1:int, param2:XML)
   {
      this.textureNames = [];
      super();
      this.propIndex = param1;
      this.xml = param2;
   }
   
   public function getTextureIndex(param1:String) : int
   {
      var loc2:int = int(this.textureNames.indexOf(param1));
      if(loc2 < 0)
      {
         loc2 = int(this.textureNames.length);
         this.textureNames.push(param1);
         this.xml.appendChild(<texture-name>{param1}</texture-name>);
      }
      return loc2;
   }
   
   public function createCollisionRecords() : void
   {
      this.addCollisionPrimitives(this.collisionBoxes);
      this.addCollisionPrimitives(this.collisionRects);
      this.addCollisionPrimitives(this.collisionTriangles);
   }
   
   private function addCollisionPrimitives(param1:Vector.<CollisionPrimitive>) : void
   {
      var loc2:CollisionPrimitive = null;
      if(param1 == null)
      {
         return;
      }
      for each(loc2 in param1)
      {
         this.xml.appendChild(loc2.getXml2());
      }
   }
}
