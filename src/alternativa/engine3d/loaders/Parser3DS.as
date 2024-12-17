package alternativa.engine3d.loaders
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.TextureMaterialPrecision;
   import alternativa.engine3d.materials.WireMaterial;
   import alternativa.types.Map;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   import alternativa.utils.ColorUtils;
   import alternativa.utils.MathUtils;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   use namespace alternativa3d;
   
   public class Parser3DS
   {
      private static const CHUNK_MAIN:uint = 19789;
      
      private static const CHUNK_VERSION:uint = 2;
      
      private static const CHUNK_SCENE:uint = 15677;
      
      private static const CHUNK_ANIMATION:uint = 45056;
      
      private static const CHUNK_OBJECT:uint = 16384;
      
      private static const CHUNK_TRIMESH:uint = 16640;
      
      private static const CHUNK_VERTICES:uint = 16656;
      
      private static const CHUNK_FACES:uint = 16672;
      
      private static const CHUNK_FACESMATERIAL:uint = 16688;
      
      private static const CHUNK_MAPPINGCOORDS:uint = 16704;
      
      private static const CHUNK_OBJECTCOLOR:uint = 16741;
      
      private static const CHUNK_TRANSFORMATION:uint = 16736;
      
      private static const CHUNK_MESHANIMATION:uint = 45058;
      
      private static const CHUNK_MATERIAL:uint = 45055;
      
      private var data:ByteArray;
      
      private var _content:Object3D;
      
      private var _textureMaterials:Map;
      
      private var _repeat:Boolean = true;
      
      private var _smooth:Boolean = false;
      
      private var _blendMode:String = "normal";
      
      private var _precision:Number;
      
      private var _scale:Number = 1;
      
      private var _mobility:int = 0;
      
      private var version:uint;
      
      private var objectDatas:Map;
      
      private var animationDatas:Array;
      
      private var materialDatas:Map;
      
      public function Parser3DS()
      {
         this._precision = TextureMaterialPrecision.MEDIUM;
         super();
      }
      
      public function get content() : Object3D
      {
         return this._content;
      }
      
      public function get repeat() : Boolean
      {
         return this._repeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         this._repeat = param1;
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         this._smooth = param1;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this._blendMode = param1;
      }
      
      public function get precision() : Number
      {
         return this._precision;
      }
      
      public function set precision(param1:Number) : void
      {
         this._precision = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      public function get mobility() : int
      {
         return this._mobility;
      }
      
      public function set mobility(param1:int) : void
      {
         this._mobility = param1;
      }
      
      public function get textureMaterials() : Map
      {
         return this._textureMaterials;
      }
      
      public function parse(param1:ByteArray) : Boolean
      {
         var data:ByteArray = param1;
         this.unload();
         if(data.bytesAvailable < 6)
         {
            return false;
         }
         this.data = data;
         data.endian = Endian.LITTLE_ENDIAN;
         try
         {
            this.parse3DSChunk(data.position,data.bytesAvailable);
            this.buildContent();
         }
         catch(e:Error)
         {
            unload();
            throw e;
         }
         finally
         {
            this.clean();
         }
         return true;
      }
      
      public function unload() : void
      {
         this._content = null;
         this._textureMaterials = null;
      }
      
      private function clean() : void
      {
         this.version = 0;
         this.objectDatas = null;
         this.animationDatas = null;
         this.materialDatas = null;
      }
      
      private function readChunkInfo(param1:uint, param2:uint) : ChunkInfo
      {
         if(param2 < 6)
         {
            return null;
         }
         this.data.position = param1;
         var loc3:ChunkInfo = new ChunkInfo();
         loc3.id = this.data.readUnsignedShort();
         loc3.size = this.data.readUnsignedInt();
         loc3.dataSize = loc3.size - 6;
         loc3.dataPosition = this.data.position;
         loc3.nextChunkPosition = param1 + loc3.size;
         return loc3;
      }
      
      private function parse3DSChunk(param1:uint, param2:uint) : void
      {
         var loc3:ChunkInfo = this.readChunkInfo(param1,param2);
         if(loc3 == null)
         {
            return;
         }
         this.data.position = param1;
         switch(loc3.id)
         {
            case CHUNK_MAIN:
               this.parseMainChunk(loc3.dataPosition,loc3.dataSize);
         }
         this.parse3DSChunk(loc3.nextChunkPosition,param2 - loc3.size);
      }
      
      private function parseMainChunk(param1:uint, param2:uint) : void
      {
         var loc3:ChunkInfo = this.readChunkInfo(param1,param2);
         if(loc3 == null)
         {
            return;
         }
         switch(loc3.id)
         {
            case CHUNK_VERSION:
               this.version = this.data.readUnsignedInt();
               break;
            case CHUNK_SCENE:
               this.parse3DChunk(loc3.dataPosition,loc3.dataSize);
               break;
            case CHUNK_ANIMATION:
               this.parseAnimationChunk(loc3.dataPosition,loc3.dataSize);
         }
         this.parseMainChunk(loc3.nextChunkPosition,param2 - loc3.size);
      }
      
      private function parse3DChunk(param1:uint, param2:uint) : void
      {
         var loc4:MaterialData = null;
         var loc3:ChunkInfo = this.readChunkInfo(param1,param2);
         if(loc3 == null)
         {
            return;
         }
         switch(loc3.id)
         {
            case CHUNK_MATERIAL:
               loc4 = new MaterialData();
               this.parseMaterialChunk(loc4,loc3.dataPosition,loc3.dataSize);
               break;
            case CHUNK_OBJECT:
               this.parseObject(loc3);
         }
         this.parse3DChunk(loc3.nextChunkPosition,param2 - loc3.size);
      }
      
      private function parseObject(param1:ChunkInfo) : void
      {
         if(this.objectDatas == null)
         {
            this.objectDatas = new Map();
         }
         var loc2:ObjectData = new ObjectData();
         loc2.name = this.getString(param1.dataPosition);
         this.objectDatas[loc2.name] = loc2;
         var loc3:int = loc2.name.length + 1;
         this.parseObjectChunk(loc2,param1.dataPosition + loc3,param1.dataSize - loc3);
      }
      
      private function parseObjectChunk(param1:ObjectData, param2:uint, param3:uint) : void
      {
         var loc4:ChunkInfo = this.readChunkInfo(param2,param3);
         if(loc4 == null)
         {
            return;
         }
         switch(loc4.id)
         {
            case CHUNK_TRIMESH:
               this.parseMeshChunk(param1,loc4.dataPosition,loc4.dataSize);
               break;
            case 17920:
            case 18176:
         }
         this.parseObjectChunk(param1,loc4.nextChunkPosition,param3 - loc4.size);
      }
      
      private function parseMeshChunk(param1:ObjectData, param2:uint, param3:uint) : void
      {
         var loc4:ChunkInfo = this.readChunkInfo(param2,param3);
         if(loc4 == null)
         {
            return;
         }
         switch(loc4.id)
         {
            case CHUNK_VERTICES:
               this.parseVertices(param1);
               break;
            case CHUNK_MAPPINGCOORDS:
               this.parseUVs(param1);
               break;
            case CHUNK_TRANSFORMATION:
               this.parseMatrix(param1);
               break;
            case CHUNK_FACES:
               this.parseFaces(param1,loc4);
         }
         this.parseMeshChunk(param1,loc4.nextChunkPosition,param3 - loc4.size);
      }
      
      private function parseVertices(param1:ObjectData) : void
      {
         var loc2:uint = this.data.readUnsignedShort();
         param1.vertices = new Array();
         var loc3:uint = 0;
         while(loc3 < loc2)
         {
            param1.vertices.push(new Point3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat()));
            loc3++;
         }
      }
      
      private function parseUVs(param1:ObjectData) : void
      {
         var loc2:uint = this.data.readUnsignedShort();
         param1.uvs = new Array();
         var loc3:uint = 0;
         while(loc3 < loc2)
         {
            param1.uvs.push(new Point(this.data.readFloat(),this.data.readFloat()));
            loc3++;
         }
      }
      
      private function parseMatrix(param1:ObjectData) : void
      {
         param1.matrix = new Matrix3D();
         param1.matrix.a = this.data.readFloat();
         param1.matrix.e = this.data.readFloat();
         param1.matrix.i = this.data.readFloat();
         param1.matrix.b = this.data.readFloat();
         param1.matrix.f = this.data.readFloat();
         param1.matrix.j = this.data.readFloat();
         param1.matrix.c = this.data.readFloat();
         param1.matrix.g = this.data.readFloat();
         param1.matrix.k = this.data.readFloat();
         param1.matrix.d = this.data.readFloat();
         param1.matrix.h = this.data.readFloat();
         param1.matrix.l = this.data.readFloat();
      }
      
      private function parseFaces(param1:ObjectData, param2:ChunkInfo) : void
      {
         var loc6:FaceData = null;
         var loc3:uint = this.data.readUnsignedShort();
         param1.faces = new Array();
         var loc4:uint = 0;
         while(loc4 < loc3)
         {
            loc6 = new FaceData();
            loc6.a = this.data.readUnsignedShort();
            loc6.b = this.data.readUnsignedShort();
            loc6.c = this.data.readUnsignedShort();
            param1.faces.push(loc6);
            this.data.position += 2;
            loc4++;
         }
         var loc5:uint = 2 + 8 * loc3;
         this.parseFacesChunk(param1,param2.dataPosition + loc5,param2.dataSize - loc5);
      }
      
      private function parseFacesChunk(param1:ObjectData, param2:uint, param3:uint) : void
      {
         var loc4:ChunkInfo = this.readChunkInfo(param2,param3);
         if(loc4 == null)
         {
            return;
         }
         switch(loc4.id)
         {
            case CHUNK_FACESMATERIAL:
               this.parseSurface(param1);
         }
         this.parseFacesChunk(param1,loc4.nextChunkPosition,param3 - loc4.size);
      }
      
      private function parseSurface(param1:ObjectData) : void
      {
         if(param1.surfaces == null)
         {
            param1.surfaces = new Map();
         }
         var loc2:SurfaceData = new SurfaceData();
         loc2.materialName = this.getString(this.data.position);
         param1.surfaces[loc2.materialName] = loc2;
         var loc3:uint = this.data.readUnsignedShort();
         loc2.faces = new Array(loc3);
         var loc4:uint = 0;
         while(loc4 < loc3)
         {
            loc2.faces[loc4] = this.data.readUnsignedShort();
            loc4++;
         }
      }
      
      private function parseAnimationChunk(param1:uint, param2:uint) : void
      {
         var loc4:AnimationData = null;
         var loc3:ChunkInfo = this.readChunkInfo(param1,param2);
         if(loc3 == null)
         {
            return;
         }
         switch(loc3.id)
         {
            case 45057:
            case 45058:
            case 45059:
            case 45060:
            case 45061:
            case 45062:
            case 45063:
               if(this.animationDatas == null)
               {
                  this.animationDatas = new Array();
               }
               loc4 = new AnimationData();
               this.animationDatas.push(loc4);
               this.parseObjectAnimationChunk(loc4,loc3.dataPosition,loc3.dataSize);
               break;
            case 45064:
         }
         this.parseAnimationChunk(loc3.nextChunkPosition,param2 - loc3.size);
      }
      
      private function parseObjectAnimationChunk(param1:AnimationData, param2:uint, param3:uint) : void
      {
         var loc4:ChunkInfo = this.readChunkInfo(param2,param3);
         if(loc4 == null)
         {
            return;
         }
         switch(loc4.id)
         {
            case 45072:
               param1.objectName = this.getString(this.data.position);
               this.data.position += 4;
               param1.parentIndex = this.data.readUnsignedShort();
               break;
            case 45073:
               param1.objectName = this.getString(this.data.position);
               break;
            case 45075:
               param1.pivot = new Point3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45088:
               this.data.position += 20;
               param1.position = new Point3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45089:
               this.data.position += 20;
               param1.rotation = this.getRotationFrom3DSAngleAxis(this.data.readFloat(),this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45090:
               this.data.position += 20;
               param1.scale = new Point3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
         }
         this.parseObjectAnimationChunk(param1,loc4.nextChunkPosition,param3 - loc4.size);
      }
      
      private function parseMaterialChunk(param1:MaterialData, param2:uint, param3:uint) : void
      {
         var loc5:TextureMapsInfo = null;
         var loc4:ChunkInfo = this.readChunkInfo(param2,param3);
         if(loc4 == null)
         {
            return;
         }
         switch(loc4.id)
         {
            case 40960:
               this.parseMaterialName(param1);
               break;
            case 40976:
               break;
            case 40992:
               this.data.position = loc4.dataPosition + 6;
               param1.color = ColorUtils.rgb(this.data.readUnsignedByte(),this.data.readUnsignedByte(),this.data.readUnsignedByte());
               break;
            case 41008:
               break;
            case 41024:
               this.data.position = loc4.dataPosition + 6;
               param1.glossiness = this.data.readUnsignedShort();
               break;
            case 41025:
               this.data.position = loc4.dataPosition + 6;
               param1.specular = this.data.readUnsignedShort();
               break;
            case 41040:
               this.data.position = loc4.dataPosition + 6;
               param1.transparency = this.data.readUnsignedShort();
               break;
            case 41472:
               param1.diffuseMap = new MapData();
               this.parseMapChunk(param1.name,param1.diffuseMap,loc4.dataPosition,loc4.dataSize);
               loc5 = this.getTextureMapsInfo(param1.name);
               loc5.diffuseMapFileName = param1.diffuseMap.filename;
               break;
            case 41786:
               break;
            case 41488:
               param1.opacityMap = new MapData();
               this.parseMapChunk(param1.name,param1.opacityMap,loc4.dataPosition,loc4.dataSize);
               loc5 = this.getTextureMapsInfo(param1.name);
               loc5.opacityMapFileName = param1.opacityMap.filename;
               break;
            case 41520:
            case 41788:
            case 41476:
            case 41789:
            case 41504:
         }
         this.parseMaterialChunk(param1,loc4.nextChunkPosition,param3 - loc4.size);
      }
      
      private function getTextureMapsInfo(param1:String) : TextureMapsInfo
      {
         if(this._textureMaterials == null)
         {
            this._textureMaterials = new Map();
         }
         var loc2:TextureMapsInfo = this._textureMaterials[param1];
         if(loc2 == null)
         {
            loc2 = new TextureMapsInfo();
            this._textureMaterials[param1] = loc2;
         }
         return loc2;
      }
      
      private function parseMaterialName(param1:MaterialData) : void
      {
         if(this.materialDatas == null)
         {
            this.materialDatas = new Map();
         }
         param1.name = this.getString(this.data.position);
         this.materialDatas[param1.name] = param1;
      }
      
      private function parseMapChunk(param1:String, param2:MapData, param3:uint, param4:uint) : void
      {
         var loc5:ChunkInfo = this.readChunkInfo(param3,param4);
         if(loc5 == null)
         {
            return;
         }
         switch(loc5.id)
         {
            case 41728:
               param2.filename = this.getString(loc5.dataPosition).toLowerCase();
               break;
            case 41809:
               break;
            case 41812:
               param2.scaleU = this.data.readFloat();
               break;
            case 41814:
               param2.scaleV = this.data.readFloat();
               break;
            case 41816:
               param2.offsetU = this.data.readFloat();
               break;
            case 41818:
               param2.offsetV = this.data.readFloat();
               break;
            case 41820:
               param2.rotation = this.data.readFloat();
         }
         this.parseMapChunk(param1,param2,loc5.nextChunkPosition,param4 - loc5.size);
      }
      
      private function buildContent() : void
      {
         var loc1:uint = 0;
         var loc2:uint = 0;
         var loc3:String = null;
         var loc4:ObjectData = null;
         var loc5:Mesh = null;
         var loc6:AnimationData = null;
         var loc7:uint = 0;
         var loc8:uint = 0;
         var loc9:AnimationData = null;
         var loc10:String = null;
         var loc11:ObjectData = null;
         var loc12:Object3D = null;
         this._content = new Object3D("container_3ds");
         this.buildMaterialMatrices();
         if(this.animationDatas != null)
         {
            if(this.objectDatas != null)
            {
               loc2 = this.animationDatas.length;
               loc1 = 0;
               while(loc1 < loc2)
               {
                  loc6 = this.animationDatas[loc1];
                  loc3 = loc6.objectName;
                  loc4 = this.objectDatas[loc3];
                  if(loc4 != null)
                  {
                     loc7 = 2;
                     loc8 = uint(loc1 + 1);
                     while(loc8 < loc2)
                     {
                        loc9 = this.animationDatas[loc8];
                        if(loc3 == loc9.objectName)
                        {
                           loc10 = loc3 + loc7;
                           loc9.objectName = loc10;
                           loc11 = new ObjectData();
                           loc11.name = loc10;
                           if(loc4.vertices != null)
                           {
                              loc11.vertices = new Array().concat(loc4.vertices);
                           }
                           if(loc4.uvs != null)
                           {
                              loc11.uvs = new Array().concat(loc4.uvs);
                           }
                           if(loc4.matrix != null)
                           {
                              loc11.matrix = loc4.matrix.clone();
                           }
                           if(loc4.faces != null)
                           {
                              loc11.faces = new Array().concat(loc4.faces);
                           }
                           if(loc4.surfaces != null)
                           {
                              loc11.surfaces = loc4.surfaces.clone();
                           }
                           this.objectDatas[loc10] = loc11;
                           loc7++;
                        }
                        loc8++;
                     }
                  }
                  if(loc4 != null && loc4.vertices != null)
                  {
                     loc5 = new Mesh(loc3);
                     loc6.object = loc5;
                     this.setBasicObjectProperties(loc6);
                     this.buildMesh(loc5,loc4,loc6);
                  }
                  else
                  {
                     loc12 = new Object3D(loc3);
                     loc6.object = loc12;
                     this.setBasicObjectProperties(loc6);
                  }
                  loc1++;
               }
               this.buildHierarchy();
            }
         }
         else
         {
            for(loc3 in this.objectDatas)
            {
               loc4 = this.objectDatas[loc3];
               if(loc4.vertices != null)
               {
                  loc5 = new Mesh(loc3);
                  this.buildMesh(loc5,loc4,null);
                  this._content.addChild(loc5);
               }
            }
         }
      }
      
      private function buildMaterialMatrices() : void
      {
         var loc1:MaterialData = null;
         var loc2:String = null;
         var loc3:Matrix = null;
         var loc4:MapData = null;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         for(loc2 in this.materialDatas)
         {
            loc1 = this.materialDatas[loc2];
            loc3 = new Matrix();
            loc4 = loc1.diffuseMap;
            if(loc4 != null)
            {
               loc5 = MathUtils.toRadian(loc4.rotation);
               loc6 = Math.sin(loc5);
               loc7 = Math.cos(loc5);
               loc3.translate(-loc4.offsetU,loc4.offsetV);
               loc3.translate(-0.5,-0.5);
               loc3.rotate(-loc5);
               loc3.scale(loc4.scaleU,loc4.scaleV);
               loc3.translate(0.5,0.5);
            }
            loc1.matrix = loc3;
         }
      }
      
      private function setBasicObjectProperties(param1:AnimationData) : void
      {
         var loc2:Object3D = param1.object;
         if(param1.position != null)
         {
            loc2.x = param1.position.x * this._scale;
            loc2.y = param1.position.y * this._scale;
            loc2.z = param1.position.z * this._scale;
         }
         if(param1.rotation != null)
         {
            loc2.rotationX = param1.rotation.x;
            loc2.rotationY = param1.rotation.y;
            loc2.rotationZ = param1.rotation.z;
         }
         if(param1.scale != null)
         {
            loc2.scaleX = param1.scale.x;
            loc2.scaleY = param1.scale.y;
            loc2.scaleZ = param1.scale.z;
         }
         loc2.mobility = this._mobility;
      }
      
      private function buildMesh(param1:Mesh, param2:ObjectData, param3:AnimationData) : void
      {
         var loc4:int = 0;
         var loc5:* = undefined;
         var loc6:Vertex = null;
         var loc7:Face = null;
         var loc9:Point3D = null;
         var loc10:FaceData = null;
         var loc11:String = null;
         var loc12:MaterialData = null;
         var loc13:SurfaceData = null;
         var loc14:Surface = null;
         var loc15:Matrix = null;
         var loc16:Number = NaN;
         var loc17:Number = NaN;
         var loc18:Surface = null;
         var loc19:String = null;
         var loc8:int = int(param2.vertices.length);
         loc4 = 0;
         while(loc4 < loc8)
         {
            loc9 = param2.vertices[loc4];
            param2.vertices[loc4] = param1.createVertex(loc9.x,loc9.y,loc9.z,loc4);
            loc4++;
         }
         if(param3 != null)
         {
            param2.matrix.invert();
            if(param3.pivot != null)
            {
               param2.matrix.d -= param3.pivot.x;
               param2.matrix.h -= param3.pivot.y;
               param2.matrix.l -= param3.pivot.z;
            }
            for(loc5 in param1.alternativa3d::_vertices)
            {
               loc6 = param1.alternativa3d::_vertices[loc5];
               loc6.alternativa3d::_coords.transform(param2.matrix);
            }
         }
         for(loc5 in param1.alternativa3d::_vertices)
         {
            loc6 = param1.alternativa3d::_vertices[loc5];
            loc6.alternativa3d::_coords.multiply(this._scale);
         }
         loc8 = param2.faces == null ? 0 : int(param2.faces.length);
         loc4 = 0;
         while(loc4 < loc8)
         {
            loc10 = param2.faces[loc4];
            loc7 = param1.createFace([param2.vertices[loc10.a],param2.vertices[loc10.b],param2.vertices[loc10.c]],loc4);
            if(param2.uvs != null)
            {
               loc7.aUV = param2.uvs[loc10.a];
               loc7.bUV = param2.uvs[loc10.b];
               loc7.cUV = param2.uvs[loc10.c];
            }
            loc4++;
         }
         if(param2.surfaces != null)
         {
            for(loc11 in param2.surfaces)
            {
               loc12 = this.materialDatas[loc11];
               loc13 = param2.surfaces[loc11];
               loc14 = param1.createSurface(loc13.faces,loc11);
               if(loc12.diffuseMap != null)
               {
                  loc8 = int(loc13.faces.length);
                  loc4 = 0;
                  while(loc4 < loc8)
                  {
                     loc7 = param1.getFaceById(loc13.faces[loc4]);
                     if(loc7.alternativa3d::_aUV != null && loc7.alternativa3d::_bUV != null && loc7.alternativa3d::_cUV != null)
                     {
                        loc15 = loc12.matrix;
                        loc16 = loc7.aUV.x;
                        loc17 = loc7.aUV.y;
                        loc7.alternativa3d::_aUV.x = loc15.a * loc16 + loc15.b * loc17 + loc15.tx;
                        loc7.alternativa3d::_aUV.y = loc15.c * loc16 + loc15.d * loc17 + loc15.ty;
                        loc16 = loc7.alternativa3d::_bUV.x;
                        loc17 = loc7.alternativa3d::_bUV.y;
                        loc7.alternativa3d::_bUV.x = loc15.a * loc16 + loc15.b * loc17 + loc15.tx;
                        loc7.alternativa3d::_bUV.y = loc15.c * loc16 + loc15.d * loc17 + loc15.ty;
                        loc16 = loc7.alternativa3d::_cUV.x;
                        loc17 = loc7.alternativa3d::_cUV.y;
                        loc7.alternativa3d::_cUV.x = loc15.a * loc16 + loc15.b * loc17 + loc15.tx;
                        loc7.alternativa3d::_cUV.y = loc15.c * loc16 + loc15.d * loc17 + loc15.ty;
                     }
                     loc4++;
                  }
                  loc14.material = new TextureMaterial(null,1 - loc12.transparency / 100,this._repeat,this._smooth,this._blendMode,-1,0,this._precision);
               }
               else
               {
                  loc14.material = new FillMaterial(this.materialDatas[loc11].color,1 - loc12.transparency / 100);
               }
            }
         }
         else
         {
            loc18 = param1.createSurface();
            for(loc19 in param1.alternativa3d::_faces)
            {
               loc18.addFace(param1.alternativa3d::_faces[loc19]);
            }
            loc18.material = new WireMaterial(0,8355711);
         }
      }
      
      private function buildHierarchy() : void
      {
         var loc3:AnimationData = null;
         var loc1:Number = this.animationDatas.length;
         var loc2:int = 0;
         while(loc2 < loc1)
         {
            loc3 = this.animationDatas[loc2];
            if(loc3.parentIndex == 65535)
            {
               this._content.addChild(loc3.object);
            }
            else
            {
               AnimationData(this.animationDatas[loc3.parentIndex]).object.addChild(loc3.object);
            }
            loc2++;
         }
      }
      
      private function getString(param1:uint) : String
      {
         var loc2:uint = 0;
         this.data.position = param1;
         var loc3:String = "";
         while(true)
         {
            loc2 = uint(this.data.readByte());
            if(loc2 == 0)
            {
               break;
            }
            loc3 += String.fromCharCode(loc2);
         }
         return loc3;
      }
      
      private function getRotationFrom3DSAngleAxis(param1:Number, param2:Number, param3:Number, param4:Number) : Point3D
      {
         var loc10:Number = NaN;
         var loc5:Point3D = new Point3D();
         var loc6:Number = Math.sin(param1);
         var loc7:Number = Math.cos(param1);
         var loc8:Number = 1 - loc7;
         var loc9:Number = param2 * param4 * loc8 + param3 * loc6;
         if(loc9 >= 1)
         {
            loc10 = param1 / 2;
            loc5.z = -2 * Math.atan2(param2 * Math.sin(loc10),Math.cos(loc10));
            loc5.y = -Math.PI / 2;
            loc5.x = 0;
            return loc5;
         }
         if(loc9 <= -1)
         {
            loc10 = param1 / 2;
            loc5.z = 2 * Math.atan2(param2 * Math.sin(loc10),Math.cos(loc10));
            loc5.y = Math.PI / 2;
            loc5.x = 0;
            return loc5;
         }
         loc5.z = -Math.atan2(param4 * loc6 - param2 * param3 * loc8,1 - (param4 * param4 + param3 * param3) * loc8);
         loc5.y = -Math.asin(param2 * param4 * loc8 + param3 * loc6);
         loc5.x = -Math.atan2(param2 * loc6 - param4 * param3 * loc8,1 - (param2 * param2 + param3 * param3) * loc8);
         return loc5;
      }
   }
}

import alternativa.engine3d.core.Object3D;
import alternativa.types.Map;
import alternativa.types.Matrix3D;
import alternativa.types.Point3D;
import flash.geom.Matrix;

class MaterialData
{
   public var name:String;
   
   public var color:uint;
   
   public var specular:uint;
   
   public var glossiness:uint;
   
   public var transparency:uint;
   
   public var diffuseMap:MapData;
   
   public var opacityMap:MapData;
   
   public var matrix:Matrix;
   
   public function MaterialData()
   {
      super();
   }
}

class MapData
{
   public var filename:String;
   
   public var scaleU:Number = 1;
   
   public var scaleV:Number = 1;
   
   public var offsetU:Number = 0;
   
   public var offsetV:Number = 0;
   
   public var rotation:Number = 0;
   
   public function MapData()
   {
      super();
   }
}

class ObjectData
{
   public var name:String;
   
   public var vertices:Array;
   
   public var uvs:Array;
   
   public var matrix:Matrix3D;
   
   public var faces:Array;
   
   public var surfaces:Map;
   
   public function ObjectData()
   {
      super();
   }
}

class FaceData
{
   public var a:uint;
   
   public var b:uint;
   
   public var c:uint;
   
   public function FaceData()
   {
      super();
   }
}

class SurfaceData
{
   public var materialName:String;
   
   public var faces:Array;
   
   public function SurfaceData()
   {
      super();
   }
}

class AnimationData
{
   public var objectName:String;
   
   public var object:Object3D;
   
   public var parentIndex:uint;
   
   public var pivot:Point3D;
   
   public var position:Point3D;
   
   public var rotation:Point3D;
   
   public var scale:Point3D;
   
   public function AnimationData()
   {
      super();
   }
}

class ChunkInfo
{
   public var id:uint;
   
   public var size:uint;
   
   public var dataSize:uint;
   
   public var dataPosition:uint;
   
   public var nextChunkPosition:uint;
   
   public function ChunkInfo()
   {
      super();
   }
}
