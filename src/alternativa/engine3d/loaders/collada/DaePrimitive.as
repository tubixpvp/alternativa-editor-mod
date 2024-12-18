package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   use namespace collada;
   
   public class DaePrimitive extends DaeElement
   {
       
      
      private var verticesInput:DaeInput;
      
      private var texCoordsInputs:Vector.<DaeInput>;
      
      private var inputsStride:int;
      
      public function DaePrimitive(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
      }
      
      override protected function parseImplementation() : Boolean
      {
         this.parseInputs();
         return true;
      }
      
      private function parseInputs() : void
      {
         var _loc5_:DaeInput = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         this.texCoordsInputs = new Vector.<DaeInput>();
         var _loc1_:XMLList = data.input;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _loc1_.length();
         for(; _loc3_ < _loc4_; _loc7_ = _loc5_.offset,_loc2_ = _loc7_ > _loc2_ ? int(_loc7_) : int(_loc2_),_loc3_++)
         {
            _loc5_ = new DaeInput(_loc1_[_loc3_],document);
            _loc6_ = _loc5_.semantic;
            if(_loc6_ == null)
            {
               continue;
            }
            switch(_loc6_)
            {
               case "VERTEX":
                  if(this.verticesInput == null)
                  {
                     this.verticesInput = _loc5_;
                  }
                  break;
               case "TEXCOORD":
                  this.texCoordsInputs.push(_loc5_);
                  break;
            }
         }
         this.inputsStride = _loc2_ + 1;
      }
      
      private function findTexCoordsInput(param1:int) : DaeInput
      {
         var _loc4_:DaeInput = null;
         var _loc2_:int = 0;
         var _loc3_:int = this.texCoordsInputs.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.texCoordsInputs[_loc2_];
            if(_loc4_.setNum == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return this.texCoordsInputs.length > 0 ? this.texCoordsInputs[0] : null;
      }
      
      private function get type() : String
      {
         return data.localName() as String;
      }
      
      public function fillInMesh(param1:Mesh, param2:Vector.<Vertex>, param3:DaeInstanceMaterial = null) : void
      {
         var _loc6_:DaeInput = null;
         var _loc7_:Material = null;
         var _loc8_:Vector.<Number> = null;
         var _loc11_:XML = null;
         var _loc12_:Array = null;
         var _loc13_:DaeMaterial = null;
         var _loc14_:Vertex = null;
         var _loc15_:DaeSource = null;
         var _loc16_:XMLList = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:XML = null;
         var _loc20_:Array = null;
         var _loc4_:XML = data.@count[0];
         if(_loc4_ == null)
         {
            document.logger.logNotEnoughDataError(data);
            return;
         }
         var _loc5_:int = parseInt(_loc4_.toString(),10);
         if(param3 != null)
         {
            _loc13_ = param3.material;
            _loc13_.parse();
            if(_loc13_.diffuseTexCoords != null)
            {
               _loc6_ = this.findTexCoordsInput(param3.getBindVertexInputSetNum(_loc13_.diffuseTexCoords));
            }
            else
            {
               _loc6_ = this.findTexCoordsInput(-1);
            }
            _loc13_.used = true;
            _loc7_ = _loc13_.material;
         }
         else
         {
            _loc6_ = this.findTexCoordsInput(-1);
         }
         if(_loc6_ != null)
         {
            for each(_loc14_ in param2)
            {
               while(_loc14_ != null && _loc14_.index != -1)
               {
                  _loc14_.index = -2;
                  _loc14_ = _loc14_.value;
               }
            }
         }
         var _loc9_:int = 1;
         var _loc10_:int = 0;
         if(_loc6_ != null)
         {
            _loc15_ = _loc6_.prepareSource(2);
            if(_loc15_ != null)
            {
               _loc8_ = _loc15_.numbers;
               _loc9_ = _loc15_.stride;
               _loc10_ = _loc6_.offset;
            }
         }
         switch(this.type)
         {
            case "polygons":
               if(data.ph.length() > 0)
               {
               }
               _loc16_ = data.p;
               _loc17_ = 0;
               _loc18_ = _loc16_.length();
               while(_loc17_ < _loc18_)
               {
                  _loc12_ = parseIntsArray(_loc16_[_loc17_]);
                  this.fillInPolygon(param1,_loc7_,param2,this.verticesInput.offset,_loc12_.length / this.inputsStride,_loc12_,_loc8_,_loc9_,_loc10_);
                  _loc17_++;
               }
               break;
            case "polylist":
               _loc11_ = data.p[0];
               if(_loc11_ == null)
               {
                  document.logger.logNotEnoughDataError(data);
                  return;
               }
               _loc12_ = parseIntsArray(_loc11_);
               _loc19_ = data.vcount[0];
               if(_loc19_ != null)
               {
                  _loc20_ = parseIntsArray(_loc19_);
                  if(_loc20_.length < _loc5_)
                  {
                     return;
                  }
                  this.fillInPolylist(param1,_loc7_,param2,this.verticesInput.offset,_loc5_,_loc12_,_loc20_,_loc8_,_loc9_,_loc10_);
               }
               else
               {
                  this.fillInPolygon(param1,_loc7_,param2,this.verticesInput.offset,_loc5_,_loc12_,_loc8_,_loc9_,_loc10_);
               }
               break;
            case "triangles":
               _loc11_ = data.p[0];
               if(_loc11_ == null)
               {
                  document.logger.logNotEnoughDataError(data);
                  return;
               }
               _loc12_ = parseIntsArray(_loc11_);
               this.fillInTriangles(param1,_loc7_,param2,this.verticesInput.offset,_loc5_,_loc12_,_loc8_,_loc9_,_loc10_);
               break;
         }
      }
      
      private function applyUV(param1:Mesh, param2:Vertex, param3:Vector.<Number>, param4:int) : Vertex
      {
         var _loc7_:Vertex = null;
         var _loc5_:Number = param3[param4];
         var _loc6_:Number = 1 - param3[int(param4 + 1)];
         if(param2.index == -1)
         {
            param2.u = _loc5_;
            param2.v = _loc6_;
            param2.index = param4;
            return param2;
         }
         if(param2.index == param4)
         {
            return param2;
         }
         while(param2.value != null)
         {
            param2 = param2.value;
            if(param2.index == param4)
            {
               return param2;
            }
         }
         _loc7_ = new Vertex();
         _loc7_.next = param1.vertexList;
         param1.vertexList = _loc7_;
         _loc7_.x = param2.x;
         _loc7_.y = param2.y;
         _loc7_.z = param2.z;
         _loc7_.u = _loc5_;
         _loc7_.v = _loc6_;
         param2.value = _loc7_;
         _loc7_.index = param4;
         return _loc7_;
      }
      
      private function fillInPolygon(param1:Mesh, param2:Material, param3:Vector.<Vertex>, param4:int, param5:int, param6:Array, param7:Vector.<Number>, param8:int = 1, param9:int = 0) : void
      {
         var _loc11_:Wrapper = null;
         var _loc13_:Vertex = null;
         var _loc14_:Wrapper = null;
         var _loc10_:Face = new Face();
         _loc10_.material = param2;
         _loc10_.next = param1.faceList;
         param1.faceList = _loc10_;
         var _loc12_:int = 0;
         while(_loc12_ < param5)
         {
            _loc13_ = param3[param6[int(this.inputsStride * _loc12_ + param4)]];
            if(param7 != null)
            {
               _loc13_ = this.applyUV(param1,_loc13_,param7,param8 * param6[int(this.inputsStride * _loc12_ + param9)]);
            }
            _loc14_ = new Wrapper();
            _loc14_.vertex = _loc13_;
            if(_loc11_ != null)
            {
               _loc11_.next = _loc14_;
            }
            else
            {
               _loc10_.wrapper = _loc14_;
            }
            _loc11_ = _loc14_;
            _loc12_++;
         }
      }
      
      private function fillInPolylist(param1:Mesh, param2:Material, param3:Vector.<Vertex>, param4:int, param5:int, param6:Array, param7:Array, param8:Vector.<Number> = null, param9:int = 1, param10:int = 0) : void
      {
         var _loc13_:int = 0;
         var _loc14_:Face = null;
         var _loc15_:Wrapper = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Vertex = null;
         var _loc19_:Wrapper = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         while(_loc12_ < param5)
         {
            _loc13_ = param7[_loc12_];
            if(_loc13_ >= 3)
            {
               _loc14_ = new Face();
               _loc14_.material = param2;
               _loc14_.next = param1.faceList;
               param1.faceList = _loc14_;
               _loc15_ = null;
               _loc16_ = 0;
               while(_loc16_ < _loc13_)
               {
                  _loc17_ = this.inputsStride * (_loc11_ + _loc16_);
                  _loc18_ = param3[param6[int(_loc17_ + param4)]];
                  if(param8 != null)
                  {
                     _loc18_ = this.applyUV(param1,_loc18_,param8,param9 * param6[int(_loc17_ + param10)]);
                  }
                  _loc19_ = new Wrapper();
                  _loc19_.vertex = _loc18_;
                  if(_loc15_ != null)
                  {
                     _loc15_.next = _loc19_;
                  }
                  else
                  {
                     _loc14_.wrapper = _loc19_;
                  }
                  _loc15_ = _loc19_;
                  _loc16_++;
               }
               _loc11_ += _loc13_;
            }
            _loc12_++;
         }
      }
      
      private function fillInTriangles(param1:Mesh, param2:Material, param3:Vector.<Vertex>, param4:int, param5:int, param6:Array, param7:Vector.<Number> = null, param8:int = 1, param9:int = 0) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Vertex = null;
         var _loc14_:Vertex = null;
         var _loc15_:Vertex = null;
         var _loc16_:Face = null;
         var _loc17_:int = 0;
         var _loc10_:int = 0;
         while(_loc10_ < param5)
         {
            _loc11_ = 3 * this.inputsStride * _loc10_;
            _loc12_ = _loc11_ + param4;
            _loc13_ = param3[param6[int(_loc12_)]];
            _loc14_ = param3[param6[int(_loc12_ + this.inputsStride)]];
            _loc15_ = param3[param6[int(_loc12_ + 2 * this.inputsStride)]];
            if(param7 != null)
            {
               _loc17_ = _loc11_ + param9;
               _loc13_ = this.applyUV(param1,_loc13_,param7,param8 * param6[int(_loc17_)]);
               _loc14_ = this.applyUV(param1,_loc14_,param7,param8 * param6[int(_loc17_ + this.inputsStride)]);
               _loc15_ = this.applyUV(param1,_loc15_,param7,param8 * param6[int(_loc17_ + 2 * this.inputsStride)]);
            }
            _loc16_ = new Face();
            _loc16_.material = param2;
            _loc16_.next = param1.faceList;
            param1.faceList = _loc16_;
            _loc16_.wrapper = new Wrapper();
            _loc16_.wrapper.vertex = _loc13_;
            _loc16_.wrapper.next = new Wrapper();
            _loc16_.wrapper.next.vertex = _loc14_;
            _loc16_.wrapper.next.next = new Wrapper();
            _loc16_.wrapper.next.next.vertex = _loc15_;
            _loc10_++;
         }
      }
      
      public function verticesEquals(param1:DaeVertices) : Boolean
      {
         var _loc2_:DaeVertices = document.findVertices(this.verticesInput.source);
         if(_loc2_ == null)
         {
            document.logger.logNotFoundError(this.verticesInput.source);
         }
         return _loc2_ == param1;
      }
      
      public function get materialSymbol() : String
      {
         var _loc1_:XML = data.@material[0];
         return _loc1_ == null ? null : _loc1_.toString();
      }
   }
}
