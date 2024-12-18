package alternativa.editor
{
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.KillBox;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.propslib.PropGroup;
   import alternativa.editor.propslib.PropLibObject;
   import alternativa.editor.propslib.PropsLibrary;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Texture;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import alternativa.engine3d.primitives.Box;
   
   public class FunctionalProps
   {
      public static const LIBRARY_NAME:String = "Functional";
      
      public static const GRP_SPAWN_POINTS:String = "Spawn Points";
      
      public static const GRP_BONUS_REGIONS:String = "Bonus Regions";
      
      public static const GRP_FLAGS:String = "Flags";
      
      public static const GRP_DOMINATION:String = "Domination";
      
      public static const BLUE_SPAWN:String = "blue";
      
      public static const RED_SPAWN:String = "red";
      
      public static const FREE_BONUS_NAME:String = "free-bonus";
      
      public static const DOMINATION_POINT:String = "dom-keypoint";
      
      public static const DOMINATION_BLUE_SPAWN:String = "dom-blue";
      
      public static const DOMINATION_RED_SPAWN:String = "dom-red";
      
      public static const DOMINATION_SPAWN:String = "dom";
      
      private static const BLUE_FLAG:String = "blue_flag";
      
      private static const RED_FLAG:String = "red_flag";
      
      private static const DM_SPAWN:String = "dm";
      
      private static const RED:uint = 14960384;
      
      private static const BLUE:uint = 786943;
      
      private static const YELLOW:uint = 14860033;
      
      private static const flag3DSClass:Class = FunctionalProps_flag3DSClass;
      
      private static const ctfFlagBaseBlueClass:Class = FunctionalProps_ctfFlagBaseBlueClass;
      
      private static const ctfFlagBaseRedClass:Class = FunctionalProps_ctfFlagBaseRedClass;
      
      private static const spawnPoint3DSClass:Class = FunctionalProps_spawnPoint3DSClass;
      
      private static const bonus13DSClass:Class = FunctionalProps_bonus13DSClass;
      
      private static const bonus23DSClass:Class = FunctionalProps_bonus23DSClass;
      
      private static const bonus33DSClass:Class = FunctionalProps_bonus33DSClass;
      
      private static const textures:Dictionary = new Dictionary();
      
      public static const KILL_GEOMETRY:String = "special-geometry";
      
      public static const KILL_BOX_NAME:String = "special-box";
      
      public function FunctionalProps()
      {
         super();
      }
      
      public static function getPropLayer(param1:Prop) : String
      {
         if(param1.libraryName == LIBRARY_NAME)
         {
            if(param1.groupName == GRP_SPAWN_POINTS)
            {
               if(param1.name == DM_SPAWN)
               {
                  return LayerNames.DM;
               }
               return LayerNames.TDM;
            }
            if(param1.groupName == GRP_FLAGS)
            {
               return LayerNames.TDM;
            }
            if(param1.groupName == GRP_DOMINATION)
            {
               return LayerNames.DOMINATION;
            }
            if(param1.groupName == GRP_BONUS_REGIONS)
            {
               return LayerNames.BONUSES;
            }
            if(param1.groupName == KILL_GEOMETRY)
            {
               return LayerNames.SPECIAL_GEOMETRY;
            }
         }
         return null;
      }
      
      public static function getFunctionalLibrary() : PropsLibrary
      {
         var loc1:PropsLibrary = new PropsLibrary();
         loc1.name = LIBRARY_NAME;
         loc1.rootGroup = new PropGroup("root");
         loc1.rootGroup.addGroup(createFlags());
         loc1.rootGroup.addGroup(createKillBoxes());
         loc1.rootGroup.addGroup(createSpawnMarkers());
         loc1.rootGroup.addGroup(getBonusRegions());
         loc1.rootGroup.addGroup(createDominationGroup());
         return loc1;
      }
      
      private static function createFlags() : PropGroup
      {
         var loc1:PropGroup = new PropGroup(GRP_FLAGS);
         loc1.addProp(getBlueFlag());
         loc1.addProp(getRedFlag());
         return loc1;
      }
      
      private static function getBlueFlag() : PropLibObject
      {
         return getTexturedPropObject(BLUE_FLAG,new flag3DSClass(),new ctfFlagBaseBlueClass().bitmapData);
      }
      
      private static function getRedFlag() : PropLibObject
      {
         return getTexturedPropObject(RED_FLAG,new flag3DSClass(),new ctfFlagBaseRedClass().bitmapData);
      }
      
      private static function createSpawnMarkers() : PropGroup
      {
         var loc1:PropGroup = new PropGroup(GRP_SPAWN_POINTS);
         loc1.addProp(getColoredPropObject(DM_SPAWN,new spawnPoint3DSClass(),YELLOW));
         loc1.addProp(getColoredPropObject(BLUE_SPAWN,new spawnPoint3DSClass(),BLUE));
         loc1.addProp(getColoredPropObject(RED_SPAWN,new spawnPoint3DSClass(),RED));
         return loc1;
      }
      
      private static function getBonusRegions() : PropGroup
      {
         var loc1:PropGroup = new PropGroup(GRP_BONUS_REGIONS);
         var loc2:FreeBonusRegion = new FreeBonusRegion(FREE_BONUS_NAME,"Functional",GRP_BONUS_REGIONS,true);
         loc1.addProp(new PropLibObject(FREE_BONUS_NAME,loc2));
         return loc1;
      }
      
      private static function getColoredPropObject(param1:String, param2:ByteArray, param3:uint) : PropLibObject
      {
         var loc4:Mesh = parse3DS(param2);
         loc4.setMaterialToAllFaces(new TextureMaterial(getMonochromeTexture(param3)));
         return new PropLibObject(param1,loc4);
      }
      
      private static function getTexturedPropObject(param1:String, param2:ByteArray, param3:BitmapData) : PropLibObject
      {
         var loc4:Mesh = parse3DS(param2);
         loc4.setMaterialToAllFaces(new TextureMaterial(param3));
         return new PropLibObject(param1,loc4);
      }
      
      private static function parse3DS(param1:ByteArray) : Mesh
      {
         var loc2:Parser3DS = new Parser3DS();
         loc2.parse(param1);
         var loc3:Mesh = loc2.objects[0] as Mesh;
         loc3.x = 0;
         loc3.y = 0;
         loc3.z = 0;
         return loc3;
      }
      
      private static function getMonochromeTexture(param1:uint) : BitmapData
      {
         var loc2:BitmapData = textures[param1];
         if(loc2 == null)
         {
            loc2 = new BitmapData(1,1,false,param1);
            textures[param1] = loc2;
         }
         return loc2;
      }
      
      private static function createDominationGroup() : PropGroup
      {
         var loc1:PropGroup = new PropGroup(GRP_DOMINATION);
         loc1.addProp(new PropLibObject(DOMINATION_POINT,createDominationPoint()));
         loc1.addProp(getColoredPropObject(DOMINATION_SPAWN,new spawnPoint3DSClass(),YELLOW));
         loc1.addProp(getColoredPropObject(DOMINATION_RED_SPAWN,new spawnPoint3DSClass(),RED));
         loc1.addProp(getColoredPropObject(DOMINATION_BLUE_SPAWN,new spawnPoint3DSClass(),BLUE));
         return loc1;
      }
      
      private static function createDominationPoint() : Object3D
      {
         /*var loc1:Mesh = new Mesh();
         var loc4:Vertex = loc1.createVertex(-50,-50,0);
         var loc5:Vertex = loc1.createVertex(50,-50,0);
         var loc6:Vertex = loc1.createVertex(50,50,0);
         var loc7:Vertex = loc1.createVertex(-50,50,0);
         var loc8:Vertex = loc1.createVertex(-50,-50,400);
         var loc9:Vertex = loc1.createVertex(50,-50,400);
         var loc10:Vertex = loc1.createVertex(50,50,400);
         var loc11:Vertex = loc1.createVertex(-50,50,400);
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc7,loc6,loc5,loc4]));
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc8,loc9,loc10,loc11]));
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc4,loc5,loc9,loc8]));
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc5,loc6,loc10,loc9]));
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc6,loc7,loc11,loc10]));
         loc1.setUVsToFace(new Point(0,0),new Point(1,0),new Point(1,1),loc1.createFace([loc4,loc8,loc11,loc7]));
         loc1.moveAllFacesToSurface();*/
         var loc1:Box = new Box(100,100,400);
         loc1.setMaterialToAllFaces(new TextureMaterial(getMonochromeTexture(16711935)));
         return loc1;
      }
      
      private static function createKillBoxes() : PropGroup
      {
         var loc1:PropGroup = new PropGroup(KILL_GEOMETRY);
         var loc2:KillBox = new KillBox(KILL_BOX_NAME,"Functional",FunctionalProps.KILL_GEOMETRY,true);
         loc1.addProp(new PropLibObject(KILL_GEOMETRY,loc2));
         return loc1;
      }
   }
}

