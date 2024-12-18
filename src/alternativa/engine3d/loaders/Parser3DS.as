package alternativa.engine3d.loaders
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   use namespace alternativa3d;
   
   public class Parser3DS
   {
      
      private static const CHUNK_MAIN:int = 19789;
      
      private static const CHUNK_VERSION:int = 2;
      
      private static const CHUNK_SCENE:int = 15677;
      
      private static const CHUNK_ANIMATION:int = 45056;
      
      private static const CHUNK_OBJECT:int = 16384;
      
      private static const CHUNK_TRIMESH:int = 16640;
      
      private static const CHUNK_VERTICES:int = 16656;
      
      private static const CHUNK_FACES:int = 16672;
      
      private static const CHUNK_FACESMATERIAL:int = 16688;
      
      private static const CHUNK_FACESSMOOTH:int = 16720;
      
      private static const CHUNK_MAPPINGCOORDS:int = 16704;
      
      private static const CHUNK_TRANSFORMATION:int = 16736;
      
      private static const CHUNK_MATERIAL:int = 45055;
       
      
      private var data:ByteArray;
      
      private var objectDatas:Object;
      
      private var animationDatas:Array;
      
      private var materialDatas:Object;
      
      public var objects:Vector.<Object3D>;
      
      public var parents:Vector.<Object3D>;
      
      public var materials:Vector.<Material>;
      
      public var textureMaterials:Vector.<TextureMaterial>;
      
      public function Parser3DS()
      {
         super();
      }
      
      public function getObjectByName(param1:String) : Object3D
      {
         var _loc2_:Object3D = null;
         for each(_loc2_ in this.objects)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function parse(param1:ByteArray, param2:String = "", param3:Number = 1) : void
      {
         if(param1.bytesAvailable < 6)
         {
            return;
         }
         this.data = param1;
         param1.endian = Endian.LITTLE_ENDIAN;
         this.parse3DSChunk(param1.position,param1.bytesAvailable);
         this.objects = new Vector.<Object3D>();
         this.parents = new Vector.<Object3D>();
         this.materials = new Vector.<Material>();
         this.textureMaterials = new Vector.<TextureMaterial>();
         this.buildContent(param2,param3);
         param1 = null;
         this.objectDatas = null;
         this.animationDatas = null;
         this.materialDatas = null;
      }
      
      private function readChunkInfo(param1:int) : ChunkInfo
      {
         this.data.position = param1;
         var _loc2_:ChunkInfo = new ChunkInfo();
         _loc2_.id = this.data.readUnsignedShort();
         _loc2_.size = this.data.readUnsignedInt();
         _loc2_.dataSize = _loc2_.size - 6;
         _loc2_.dataPosition = this.data.position;
         _loc2_.nextChunkPosition = param1 + _loc2_.size;
         return _loc2_;
      }
      
      private function parse3DSChunk(param1:int, param2:int) : void
      {
         if(param2 < 6)
         {
            return;
         }
         var _loc3_:ChunkInfo = this.readChunkInfo(param1);
         this.data.position = param1;
         switch(_loc3_.id)
         {
            case CHUNK_MAIN:
               this.parseMainChunk(_loc3_.dataPosition,_loc3_.dataSize);
         }
         this.parse3DSChunk(_loc3_.nextChunkPosition,param2 - _loc3_.size);
      }
      
      private function parseMainChunk(param1:int, param2:int) : void
      {
         if(param2 < 6)
         {
            return;
         }
         var _loc3_:ChunkInfo = this.readChunkInfo(param1);
         switch(_loc3_.id)
         {
            case CHUNK_VERSION:
               break;
            case CHUNK_SCENE:
               this.parse3DChunk(_loc3_.dataPosition,_loc3_.dataSize);
               break;
            case CHUNK_ANIMATION:
               this.parseAnimationChunk(_loc3_.dataPosition,_loc3_.dataSize);
         }
         this.parseMainChunk(_loc3_.nextChunkPosition,param2 - _loc3_.size);
      }
      
      private function parse3DChunk(param1:int, param2:int) : void
      {
         var _loc3_:ChunkInfo = null;
         var _loc4_:MaterialData = null;
         for(; param2 >= 6; param1 = _loc3_.nextChunkPosition,param2 = param2 - _loc3_.size)
         {
            _loc3_ = this.readChunkInfo(param1);
            switch(_loc3_.id)
            {
               case CHUNK_MATERIAL:
                  _loc4_ = new MaterialData();
                  this.parseMaterialChunk(_loc4_,_loc3_.dataPosition,_loc3_.dataSize);
                  continue;
               case CHUNK_OBJECT:
                  this.parseObject(_loc3_);
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function parseObject(param1:ChunkInfo) : void
      {
         if(this.objectDatas == null)
         {
            this.objectDatas = new Object();
         }
         var _loc2_:ObjectData = new ObjectData();
         _loc2_.name = this.getString(param1.dataPosition);
         this.objectDatas[_loc2_.name] = _loc2_;
         var _loc3_:int = _loc2_.name.length + 1;
         this.parseObjectChunk(_loc2_,param1.dataPosition + _loc3_,param1.dataSize - _loc3_);
      }
      
      private function parseObjectChunk(param1:ObjectData, param2:int, param3:int) : void
      {
         if(param3 < 6)
         {
            return;
         }
         var _loc4_:ChunkInfo = this.readChunkInfo(param2);
         switch(_loc4_.id)
         {
            case CHUNK_TRIMESH:
               this.parseMeshChunk(param1,_loc4_.dataPosition,_loc4_.dataSize);
               break;
            case 17920:
               break;
            case 18176:
         }
         this.parseObjectChunk(param1,_loc4_.nextChunkPosition,param3 - _loc4_.size);
      }
      
      private function parseMeshChunk(param1:ObjectData, param2:int, param3:int) : void
      {
         if(param3 < 6)
         {
            return;
         }
         var _loc4_:ChunkInfo = this.readChunkInfo(param2);
         switch(_loc4_.id)
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
               this.parseFaces(param1,_loc4_);
         }
         this.parseMeshChunk(param1,_loc4_.nextChunkPosition,param3 - _loc4_.size);
      }
      
      private function parseVertices(param1:ObjectData) : void
      {
         var _loc2_:int = this.data.readUnsignedShort();
         param1.vertices = new Vector.<Number>();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < _loc2_)
         {
            var _loc5_:* = _loc4_++;
            param1.vertices[_loc5_] = this.data.readFloat();
            var _loc6_:* = _loc4_++;
            param1.vertices[_loc6_] = this.data.readFloat();
            var _loc7_:* = _loc4_++;
            param1.vertices[_loc7_] = this.data.readFloat();
            _loc3_++;
         }
      }
      
      private function parseUVs(param1:ObjectData) : void
      {
         var _loc2_:int = this.data.readUnsignedShort();
         param1.uvs = new Vector.<Number>();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < _loc2_)
         {
            var _loc5_:* = _loc4_++;
            param1.uvs[_loc5_] = this.data.readFloat();
            var _loc6_:* = _loc4_++;
            param1.uvs[_loc6_] = this.data.readFloat();
            _loc3_++;
         }
      }
      
      private function parseMatrix(param1:ObjectData) : void
      {
         param1.a = this.data.readFloat();
         param1.e = this.data.readFloat();
         param1.i = this.data.readFloat();
         param1.b = this.data.readFloat();
         param1.f = this.data.readFloat();
         param1.j = this.data.readFloat();
         param1.c = this.data.readFloat();
         param1.g = this.data.readFloat();
         param1.k = this.data.readFloat();
         param1.d = this.data.readFloat();
         param1.h = this.data.readFloat();
         param1.l = this.data.readFloat();
      }
      
      private function parseFaces(param1:ObjectData, param2:ChunkInfo) : void
      {
         var _loc3_:int = this.data.readUnsignedShort();
         param1.faces = new Vector.<int>(_loc3_ * 3);
         param1.smoothingGroups = new Vector.<uint>(_loc3_);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc4_ < _loc3_)
         {
            var _loc7_:* = _loc5_++;
            param1.faces[_loc7_] = this.data.readUnsignedShort();
            var _loc8_:* = _loc5_++;
            param1.faces[_loc8_] = this.data.readUnsignedShort();
            var _loc9_:* = _loc5_++;
            param1.faces[_loc9_] = this.data.readUnsignedShort();
            this.data.position = this.data.position + 2;
            _loc4_++;
         }
         var _loc6_:int = 2 + 8 * _loc3_;
         this.parseFacesChunk(param1,param2.dataPosition + _loc6_,param2.dataSize - _loc6_);
      }
      
      private function parseFacesChunk(param1:ObjectData, param2:int, param3:int) : void
      {
         if(param3 < 6)
         {
            return;
         }
         var _loc4_:ChunkInfo = this.readChunkInfo(param2);
         switch(_loc4_.id)
         {
            case CHUNK_FACESMATERIAL:
               this.parseSurface(param1);
               break;
            case CHUNK_FACESSMOOTH:
               this.parseSmoothingGroups(param1);
         }
         this.parseFacesChunk(param1,_loc4_.nextChunkPosition,param3 - _loc4_.size);
      }
      
      private function parseSurface(param1:ObjectData) : void
      {
         if(param1.surfaces == null)
         {
            param1.surfaces = new Object();
         }
         var _loc2_:Vector.<int> = new Vector.<int>();
         param1.surfaces[this.getString(this.data.position)] = _loc2_;
         var _loc3_:int = this.data.readUnsignedShort();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_[_loc4_] = this.data.readUnsignedShort();
            _loc4_++;
         }
      }
      
      private function parseSmoothingGroups(param1:ObjectData) : void
      {
         var _loc2_:int = param1.faces.length / 3;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1.smoothingGroups[_loc3_] = this.data.readUnsignedInt();
            _loc3_++;
         }
      }
      
      private function parseAnimationChunk(param1:int, param2:int) : void
      {
         var _loc3_:ChunkInfo = null;
         var _loc4_:AnimationData = null;
         for(; param2 >= 6; param1 = _loc3_.nextChunkPosition,param2 = param2 - _loc3_.size)
         {
            _loc3_ = this.readChunkInfo(param1);
            switch(_loc3_.id)
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
                  _loc4_ = new AnimationData();
                  this.animationDatas.push(_loc4_);
                  this.parseObjectAnimationChunk(_loc4_,_loc3_.dataPosition,_loc3_.dataSize);
                  continue;
               case 45064:
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function parseObjectAnimationChunk(param1:AnimationData, param2:int, param3:int) : void
      {
         if(param3 < 6)
         {
            return;
         }
         var _loc4_:ChunkInfo = this.readChunkInfo(param2);
         switch(_loc4_.id)
         {
            case 45072:
               param1.objectName = this.getString(this.data.position);
               this.data.position = this.data.position + 4;
               param1.parentIndex = this.data.readUnsignedShort();
               break;
            case 45073:
               param1.objectName = this.getString(this.data.position);
               break;
            case 45075:
               param1.pivot = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45088:
               this.data.position = this.data.position + 20;
               param1.position = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45089:
               this.data.position = this.data.position + 20;
               param1.rotation = this.getRotationFrom3DSAngleAxis(this.data.readFloat(),this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45090:
               this.data.position = this.data.position + 20;
               param1.scale = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
         }
         this.parseObjectAnimationChunk(param1,_loc4_.nextChunkPosition,param3 - _loc4_.size);
      }
      
      private function parseMaterialChunk(param1:MaterialData, param2:int, param3:int) : void
      {
         if(param3 < 6)
         {
            return;
         }
         var _loc4_:ChunkInfo = this.readChunkInfo(param2);
         switch(_loc4_.id)
         {
            case 40960:
               this.parseMaterialName(param1);
               break;
            case 40976:
               break;
            case 40992:
               this.data.position = _loc4_.dataPosition + 6;
               param1.color = (this.data.readUnsignedByte() << 16) + (this.data.readUnsignedByte() << 8) + this.data.readUnsignedByte();
               break;
            case 41008:
               break;
            case 41024:
               this.data.position = _loc4_.dataPosition + 6;
               param1.glossiness = this.data.readUnsignedShort();
               break;
            case 41025:
               this.data.position = _loc4_.dataPosition + 6;
               param1.specular = this.data.readUnsignedShort();
               break;
            case 41040:
               this.data.position = _loc4_.dataPosition + 6;
               param1.transparency = this.data.readUnsignedShort();
               break;
            case 41472:
               param1.diffuseMap = new MapData();
               this.parseMapChunk(param1.name,param1.diffuseMap,_loc4_.dataPosition,_loc4_.dataSize);
               break;
            case 41786:
               break;
            case 41488:
               param1.opacityMap = new MapData();
               this.parseMapChunk(param1.name,param1.opacityMap,_loc4_.dataPosition,_loc4_.dataSize);
               break;
            case 41520:
               break;
            case 41788:
               break;
            case 41476:
               break;
            case 41789:
               break;
            case 41504:
         }
         this.parseMaterialChunk(param1,_loc4_.nextChunkPosition,param3 - _loc4_.size);
      }
      
      private function parseMaterialName(param1:MaterialData) : void
      {
         if(this.materialDatas == null)
         {
            this.materialDatas = new Object();
         }
         param1.name = this.getString(this.data.position);
         this.materialDatas[param1.name] = param1;
      }
      
      private function parseMapChunk(param1:String, param2:MapData, param3:int, param4:int) : void
      {
         if(param4 < 6)
         {
            return;
         }
         var _loc5_:ChunkInfo = this.readChunkInfo(param3);
         switch(_loc5_.id)
         {
            case 41728:
               param2.filename = this.getString(_loc5_.dataPosition).toLowerCase();
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
         this.parseMapChunk(param1,param2,_loc5_.nextChunkPosition,param4 - _loc5_.size);
      }
      
      private function buildContent(param1:String, param2:Number) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:ObjectData = null;
         var _loc6_:Object3D = null;
         var _loc7_:MaterialData = null;
         var _loc8_:MapData = null;
         var _loc9_:Matrix = null;
         var _loc10_:Number = NaN;
         var _loc11_:TextureMaterial = null;
         var _loc12_:FillMaterial = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:AnimationData = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:AnimationData = null;
         var _loc19_:ObjectData = null;
         var _loc20_:String = null;
         for(_loc3_ in this.materialDatas)
         {
            _loc7_ = this.materialDatas[_loc3_];
            _loc8_ = _loc7_.diffuseMap;
            if(_loc8_ != null)
            {
               _loc9_ = new Matrix();
               _loc10_ = _loc8_.rotation * Math.PI / 180;
               _loc9_.translate(-_loc8_.offsetU,_loc8_.offsetV);
               _loc9_.translate(-0.5,-0.5);
               _loc9_.rotate(-_loc10_);
               _loc9_.scale(_loc8_.scaleU,_loc8_.scaleV);
               _loc9_.translate(0.5,0.5);
               _loc7_.matrix = _loc9_;
               _loc11_ = new TextureMaterial();
               _loc11_.name = _loc3_;
               _loc11_.diffuseMapURL = param1 + _loc8_.filename;
               _loc11_.opacityMapURL = _loc7_.opacityMap != null?param1 + _loc7_.opacityMap.filename:null;
               _loc7_.material = _loc11_;
               _loc11_.name = _loc7_.name;
               this.textureMaterials.push(_loc11_);
            }
            else
            {
               _loc12_ = new FillMaterial(_loc7_.color);
               _loc7_.material = _loc12_;
               _loc12_.name = _loc7_.name;
            }
            this.materials.push(_loc7_.material);
         }
         if(this.animationDatas != null)
         {
            if(this.objectDatas != null)
            {
               _loc14_ = this.animationDatas.length;
               _loc13_ = 0;
               while(_loc13_ < _loc14_)
               {
                  _loc15_ = this.animationDatas[_loc13_];
                  _loc4_ = _loc15_.objectName;
                  _loc5_ = this.objectDatas[_loc4_];
                  if(_loc5_ != null)
                  {
                     _loc16_ = _loc13_ + 1;
                     _loc17_ = 1;
                     while(_loc16_ < _loc14_)
                     {
                        _loc18_ = this.animationDatas[_loc16_];
                        if(!_loc18_.isInstance && _loc4_ == _loc18_.objectName)
                        {
                           _loc19_ = new ObjectData();
                           _loc20_ = _loc4_ + _loc17_++;
                           _loc19_.name = _loc20_;
                           this.objectDatas[_loc20_] = _loc19_;
                           _loc18_.objectName = _loc20_;
                           _loc19_.vertices = _loc5_.vertices;
                           _loc19_.uvs = _loc5_.uvs;
                           _loc19_.faces = _loc5_.faces;
                           _loc19_.smoothingGroups = _loc5_.smoothingGroups;
                           _loc19_.surfaces = _loc5_.surfaces;
                           _loc19_.a = _loc5_.a;
                           _loc19_.b = _loc5_.b;
                           _loc19_.c = _loc5_.c;
                           _loc19_.d = _loc5_.d;
                           _loc19_.e = _loc5_.e;
                           _loc19_.f = _loc5_.f;
                           _loc19_.g = _loc5_.g;
                           _loc19_.h = _loc5_.h;
                           _loc19_.i = _loc5_.i;
                           _loc19_.j = _loc5_.j;
                           _loc19_.k = _loc5_.k;
                           _loc19_.l = _loc5_.l;
                        }
                        _loc16_++;
                     }
                  }
                  if(_loc5_ != null && _loc5_.vertices != null)
                  {
                     _loc6_ = new Mesh();
                     this.buildMesh(_loc6_ as Mesh,_loc5_,_loc15_,param2);
                  }
                  else
                  {
                     _loc6_ = new Object3D();
                  }
                  _loc6_.name = _loc4_;
                  _loc15_.object = _loc6_;
                  if(_loc15_.position != null)
                  {
                     _loc6_.x = _loc15_.position.x * param2;
                     _loc6_.y = _loc15_.position.y * param2;
                     _loc6_.z = _loc15_.position.z * param2;
                  }
                  if(_loc15_.rotation != null)
                  {
                     _loc6_.rotationX = _loc15_.rotation.x;
                     _loc6_.rotationY = _loc15_.rotation.y;
                     _loc6_.rotationZ = _loc15_.rotation.z;
                  }
                  if(_loc15_.scale != null)
                  {
                     _loc6_.scaleX = _loc15_.scale.x;
                     _loc6_.scaleY = _loc15_.scale.y;
                     _loc6_.scaleZ = _loc15_.scale.z;
                  }
                  _loc13_++;
               }
               _loc13_ = 0;
               while(_loc13_ < _loc14_)
               {
                  _loc15_ = this.animationDatas[_loc13_];
                  this.objects.push(_loc15_.object);
                  this.parents.push(_loc15_.parentIndex == 65535?null:AnimationData(this.animationDatas[_loc15_.parentIndex]).object);
                  _loc13_++;
               }
            }
         }
         else
         {
            for(_loc4_ in this.objectDatas)
            {
               _loc5_ = this.objectDatas[_loc4_];
               if(_loc5_.vertices != null)
               {
                  _loc6_ = new Mesh();
                  _loc6_.name = _loc4_;
                  this.buildMesh(_loc6_ as Mesh,_loc5_,null,param2);
                  this.objects.push(_loc6_);
                  this.parents.push(null);
               }
            }
         }
      }
      
      private function buildMesh(param1:Mesh, param2:ObjectData, param3:AnimationData, param4:Number) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Face = null;
         var _loc12_:Vertex = null;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Boolean = false;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Face = null;
         var _loc33_:* = null;
         var _loc34_:Vector.<int> = null;
         var _loc35_:MaterialData = null;
         var _loc36_:Material = null;
         var _loc37_:Wrapper = null;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc5_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc6_:Vector.<Face> = new Vector.<Face>();
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc13_:Boolean = false;
         if(param3 != null)
         {
            _loc15_ = param2.a;
            _loc16_ = param2.b;
            _loc17_ = param2.c;
            _loc18_ = param2.d;
            _loc19_ = param2.e;
            _loc20_ = param2.f;
            _loc21_ = param2.g;
            _loc22_ = param2.h;
            _loc23_ = param2.i;
            _loc24_ = param2.j;
            _loc25_ = param2.k;
            _loc26_ = param2.l;
            _loc27_ = 1 / (-_loc17_ * _loc20_ * _loc23_ + _loc16_ * _loc21_ * _loc23_ + _loc17_ * _loc19_ * _loc24_ - _loc15_ * _loc21_ * _loc24_ - _loc16_ * _loc19_ * _loc25_ + _loc15_ * _loc20_ * _loc25_);
            param2.a = (-_loc21_ * _loc24_ + _loc20_ * _loc25_) * _loc27_;
            param2.b = (_loc17_ * _loc24_ - _loc16_ * _loc25_) * _loc27_;
            param2.c = (-_loc17_ * _loc20_ + _loc16_ * _loc21_) * _loc27_;
            param2.d = (_loc18_ * _loc21_ * _loc24_ - _loc17_ * _loc22_ * _loc24_ - _loc18_ * _loc20_ * _loc25_ + _loc16_ * _loc22_ * _loc25_ + _loc17_ * _loc20_ * _loc26_ - _loc16_ * _loc21_ * _loc26_) * _loc27_;
            param2.e = (_loc21_ * _loc23_ - _loc19_ * _loc25_) * _loc27_;
            param2.f = (-_loc17_ * _loc23_ + _loc15_ * _loc25_) * _loc27_;
            param2.g = (_loc17_ * _loc19_ - _loc15_ * _loc21_) * _loc27_;
            param2.h = (_loc17_ * _loc22_ * _loc23_ - _loc18_ * _loc21_ * _loc23_ + _loc18_ * _loc19_ * _loc25_ - _loc15_ * _loc22_ * _loc25_ - _loc17_ * _loc19_ * _loc26_ + _loc15_ * _loc21_ * _loc26_) * _loc27_;
            param2.i = (-_loc20_ * _loc23_ + _loc19_ * _loc24_) * _loc27_;
            param2.j = (_loc16_ * _loc23_ - _loc15_ * _loc24_) * _loc27_;
            param2.k = (-_loc16_ * _loc19_ + _loc15_ * _loc20_) * _loc27_;
            param2.l = (_loc18_ * _loc20_ * _loc23_ - _loc16_ * _loc22_ * _loc23_ - _loc18_ * _loc19_ * _loc24_ + _loc15_ * _loc22_ * _loc24_ + _loc16_ * _loc19_ * _loc26_ - _loc15_ * _loc20_ * _loc26_) * _loc27_;
            if(param3.pivot != null)
            {
               param2.d = param2.d - param3.pivot.x;
               param2.h = param2.h - param3.pivot.y;
               param2.l = param2.l - param3.pivot.z;
            }
            _loc13_ = true;
         }
         if(param2.vertices != null)
         {
            _loc28_ = param2.uvs != null && param2.uvs.length > 0;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc14_ = param2.vertices.length;
            while(_loc9_ < _loc14_)
            {
               _loc12_ = new Vertex();
               if(_loc13_)
               {
                  _loc29_ = param2.vertices[_loc9_++];
                  _loc30_ = param2.vertices[_loc9_++];
                  _loc31_ = param2.vertices[_loc9_++];
                  _loc12_.x = param2.a * _loc29_ + param2.b * _loc30_ + param2.c * _loc31_ + param2.d;
                  _loc12_.y = param2.e * _loc29_ + param2.f * _loc30_ + param2.g * _loc31_ + param2.h;
                  _loc12_.z = param2.i * _loc29_ + param2.j * _loc30_ + param2.k * _loc31_ + param2.l;
               }
               else
               {
                  _loc12_.x = param2.vertices[_loc9_++];
                  _loc12_.y = param2.vertices[_loc9_++];
                  _loc12_.z = param2.vertices[_loc9_++];
               }
               _loc12_.x = _loc12_.x * param4;
               _loc12_.y = _loc12_.y * param4;
               _loc12_.z = _loc12_.z * param4;
               if(_loc28_)
               {
                  _loc12_.u = param2.uvs[_loc10_++];
                  _loc12_.v = 1 - param2.uvs[_loc10_++];
               }
               _loc12_.transformId = -1;
               var _loc40_:* = _loc7_++;
               _loc5_[_loc40_] = _loc12_;
               _loc12_.next = param1.vertexList;
               param1.vertexList = _loc12_;
            }
         }
         if(param2.faces != null)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            _loc14_ = param2.faces.length;
            while(_loc9_ < _loc14_)
            {
               _loc11_ = new Face();
               _loc11_.wrapper = new Wrapper();
               _loc11_.wrapper.next = new Wrapper();
               _loc11_.wrapper.next.next = new Wrapper();
               _loc11_.wrapper.vertex = _loc5_[param2.faces[_loc9_++]];
               _loc11_.wrapper.next.vertex = _loc5_[param2.faces[_loc9_++]];
               _loc11_.wrapper.next.next.vertex = _loc5_[param2.faces[_loc9_++]];
               _loc11_.smoothingGroups = param2.smoothingGroups[_loc10_++];
               _loc40_ = _loc8_++;
               _loc6_[_loc40_] = _loc11_;
               if(_loc32_ != null)
               {
                  _loc32_.next = _loc11_;
               }
               else
               {
                  param1.faceList = _loc11_;
               }
               _loc32_ = _loc11_;
            }
         }
         if(param2.surfaces != null)
         {
            for(_loc33_ in param2.surfaces)
            {
               _loc34_ = param2.surfaces[_loc33_];
               _loc35_ = this.materialDatas[_loc33_];
               _loc36_ = _loc35_.material;
               _loc9_ = 0;
               while(_loc9_ < _loc34_.length)
               {
                  _loc11_ = _loc6_[_loc34_[_loc9_]];
                  _loc11_.material = _loc36_;
                  if(_loc35_.matrix != null)
                  {
                     _loc37_ = _loc11_.wrapper;
                     while(_loc37_ != null)
                     {
                        _loc12_ = _loc37_.vertex;
                        if(_loc12_.transformId < 0)
                        {
                           _loc38_ = _loc12_.u;
                           _loc39_ = _loc12_.v;
                           _loc12_.u = _loc35_.matrix.a * _loc38_ + _loc35_.matrix.b * _loc39_ + _loc35_.matrix.tx;
                           _loc12_.v = _loc35_.matrix.c * _loc38_ + _loc35_.matrix.d * _loc39_ + _loc35_.matrix.ty;
                           _loc12_.transformId = 0;
                        }
                        _loc37_ = _loc37_.next;
                     }
                  }
                  _loc9_++;
               }
            }
         }
         param1.calculateFacesNormals(true);
         param1.calculateBounds();
      }
      
      private function getString(param1:int) : String
      {
         var _loc2_:int = 0;
         this.data.position = param1;
         var _loc3_:String = "";
         while((_loc2_ = this.data.readByte()) != 0)
         {
            _loc3_ = _loc3_ + String.fromCharCode(_loc2_);
         }
         return _loc3_;
      }
      
      private function getRotationFrom3DSAngleAxis(param1:Number, param2:Number, param3:Number, param4:Number) : Vector3D
      {
         var _loc10_:Number = NaN;
         var _loc5_:Vector3D = new Vector3D();
         var _loc6_:Number = Math.sin(param1);
         var _loc7_:Number = Math.cos(param1);
         var _loc8_:Number = 1 - _loc7_;
         var _loc9_:Number = param2 * param4 * _loc8_ + param3 * _loc6_;
         if(_loc9_ >= 1)
         {
            _loc10_ = param1 / 2;
            _loc5_.z = -2 * Math.atan2(param2 * Math.sin(_loc10_),Math.cos(_loc10_));
            _loc5_.y = -Math.PI / 2;
            _loc5_.x = 0;
            return _loc5_;
         }
         if(_loc9_ <= -1)
         {
            _loc10_ = param1 / 2;
            _loc5_.z = 2 * Math.atan2(param2 * Math.sin(_loc10_),Math.cos(_loc10_));
            _loc5_.y = Math.PI / 2;
            _loc5_.x = 0;
            return _loc5_;
         }
         _loc5_.z = -Math.atan2(param4 * _loc6_ - param2 * param3 * _loc8_,1 - (param4 * param4 + param3 * param3) * _loc8_);
         _loc5_.y = -Math.asin(param2 * param4 * _loc8_ + param3 * _loc6_);
         _loc5_.x = -Math.atan2(param2 * _loc6_ - param4 * param3 * _loc8_,1 - (param2 * param2 + param3 * param3) * _loc8_);
         return _loc5_;
      }
   }
}

import alternativa.engine3d.materials.Material;
import flash.geom.Matrix;

class MaterialData
{
    
   
   public var name:String;
   
   public var color:int;
   
   public var specular:int;
   
   public var glossiness:int;
   
   public var transparency:int;
   
   public var diffuseMap:MapData;
   
   public var opacityMap:MapData;
   
   public var matrix:Matrix;
   
   public var material:Material;
   
   function MaterialData()
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
   
   function MapData()
   {
      super();
   }
}

class ObjectData
{
    
   
   public var name:String;
   
   public var vertices:Vector.<Number>;
   
   public var uvs:Vector.<Number>;
   
   public var faces:Vector.<int>;
   
   public var smoothingGroups:Vector.<uint>;
   
   public var surfaces:Object;
   
   public var a:Number;
   
   public var b:Number;
   
   public var c:Number;
   
   public var d:Number;
   
   public var e:Number;
   
   public var f:Number;
   
   public var g:Number;
   
   public var h:Number;
   
   public var i:Number;
   
   public var j:Number;
   
   public var k:Number;
   
   public var l:Number;
   
   function ObjectData()
   {
      super();
   }
}

import alternativa.engine3d.core.Object3D;
import flash.geom.Vector3D;

class AnimationData
{
    
   
   public var objectName:String;
   
   public var object:Object3D;
   
   public var parentIndex:int;
   
   public var pivot:Vector3D;
   
   public var position:Vector3D;
   
   public var rotation:Vector3D;
   
   public var scale:Vector3D;
   
   public var isInstance:Boolean;
   
   function AnimationData()
   {
      super();
   }
}

class ChunkInfo
{
    
   
   public var id:int;
   
   public var size:int;
   
   public var dataSize:int;
   
   public var dataPosition:int;
   
   public var nextChunkPosition:int;
   
   function ChunkInfo()
   {
      super();
   }
}
