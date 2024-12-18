package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.animation.AnimationClip;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Joint;
   import alternativa.engine3d.objects.Skin;
   import alternativa.engine3d.objects.VertexBinding;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   use namespace collada;
   
   public class DaeController extends DaeElement
   {
       
      
      private var jointsBindMatrices:Vector.<Vector.<Number>>;
      
      private var vcounts:Array;
      
      private var indices:Array;
      
      private var jointsInput:DaeInput;
      
      private var weightsInput:DaeInput;
      
      private var inputsStride:int;
      
      public function DaeController(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
      }
      
      override protected function parseImplementation() : Boolean
      {
         var _loc1_:XML = data.skin.vertex_weights[0];
         if(_loc1_ == null)
         {
            return false;
         }
         var _loc2_:XML = _loc1_.vcount[0];
         if(_loc2_ == null)
         {
            return false;
         }
         this.vcounts = parseIntsArray(_loc2_);
         var _loc3_:XML = _loc1_.v[0];
         if(_loc3_ == null)
         {
            return false;
         }
         this.indices = parseIntsArray(_loc3_);
         this.parseInputs();
         this.parseJointsBindMatrices();
         return true;
      }
      
      private function parseInputs() : void
      {
         var _loc5_:DaeInput = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc1_:XMLList = data.skin.vertex_weights.input;
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
               case "JOINT":
                  if(this.jointsInput == null)
                  {
                     this.jointsInput = _loc5_;
                  }
                  break;
               case "WEIGHT":
                  if(this.weightsInput == null)
                  {
                     this.weightsInput = _loc5_;
                  }
                  break;
            }
         }
         this.inputsStride = _loc2_ + 1;
      }
      
      private function parseJointsBindMatrices() : void
      {
         var jointsXML:XML = null;
         var jointsSource:DaeSource = null;
         var stride:int = 0;
         var count:int = 0;
         var i:int = 0;
         var index:int = 0;
         var matrix:Vector.<Number> = null;
         var j:int = 0;
         jointsXML = data.skin.joints.input.(@semantic == "INV_BIND_MATRIX")[0];
         if(jointsXML != null)
         {
            jointsSource = document.findSource(jointsXML.@source[0]);
            if(jointsSource != null)
            {
               if(jointsSource.parse() && jointsSource.numbers != null && jointsSource.stride >= 16)
               {
                  stride = jointsSource.stride;
                  count = jointsSource.numbers.length / stride;
                  this.jointsBindMatrices = new Vector.<Vector.<Number>>(count);
                  i = 0;
                  while(i < count)
                  {
                     index = stride * i;
                     matrix = new Vector.<Number>(16);
                     this.jointsBindMatrices[i] = matrix;
                     j = 0;
                     while(j < 16)
                     {
                        matrix[j] = jointsSource.numbers[int(index + j)];
                        j++;
                     }
                     i++;
                  }
               }
            }
            else
            {
               document.logger.logNotFoundError(jointsXML.@source[0]);
            }
         }
      }
      
      private function get geometry() : DaeGeometry
      {
         var _loc1_:DaeGeometry = document.findGeometry(data.skin.@source[0]);
         if(_loc1_ == null)
         {
            document.logger.logNotFoundError(data.@source[0]);
         }
         return _loc1_;
      }
      
      public function parseSkin(param1:Object, param2:Vector.<DaeNode>, param3:Vector.<DaeNode>) : DaeObject
      {
         var _loc5_:Skin = null;
         var _loc6_:DaeGeometry = null;
         var _loc7_:Vector.<Vertex> = null;
         var _loc8_:Vector.<DaeObject> = null;
         var _loc4_:XML = data.skin[0];
         if(_loc4_ != null)
         {
            _loc5_ = new Skin();
            _loc6_ = this.geometry;
            if(_loc6_ != null)
            {
               _loc6_.parse();
               _loc7_ = _loc6_.fillInMesh(_loc5_,param1);
               this.applyBindShapeMatrix(_loc5_);
               _loc8_ = this.addJointsToSkin(_loc5_,param2,this.findNodes(param3));
               this.setJointsBindMatrices(_loc8_);
               this.linkVerticesToJoints(_loc8_,_loc7_);
               _loc5_.normalizeWeights();
               _loc6_.cleanVertices(_loc5_);
               _loc5_.calculateFacesNormals(true);
               _loc5_.calculateBounds();
               return new DaeObject(_loc5_,this.mergeJointsClips(_loc5_,_loc8_));
            }
            _loc5_.calculateFacesNormals(true);
            _loc5_.calculateBounds();
            return new DaeObject(_loc5_);
         }
         return null;
      }
      
      private function mergeJointsClips(param1:Skin, param2:Vector.<DaeObject>) : AnimationClip
      {
         var _loc7_:DaeObject = null;
         var _loc8_:AnimationClip = null;
         var _loc9_:Object3D = null;
         var _loc10_:int = 0;
         if(!this.hasJointsAnimation(param2))
         {
            return null;
         }
         var _loc3_:AnimationClip = new AnimationClip();
         var _loc4_:Array = [param1];
         var _loc5_:int = 0;
         var _loc6_:int = param2.length;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param2[_loc5_];
            _loc8_ = _loc7_.animation;
            if(_loc8_ != null)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc8_.numTracks)
               {
                  _loc3_.addTrack(_loc8_.getTrackAt(_loc10_));
                  _loc10_++;
               }
            }
            else
            {
               _loc3_.addTrack(_loc7_.jointNode.createStaticTransformTrack());
            }
            _loc9_ = _loc7_.object;
            _loc9_.name = _loc7_.jointNode.animName;
            _loc4_.push(_loc9_);
            _loc5_++;
         }
         _loc3_._objects = _loc4_;
         return _loc3_;
      }
      
      private function hasJointsAnimation(param1:Vector.<DaeObject>) : Boolean
      {
         var _loc4_:DaeObject = null;
         var _loc2_:int = 0;
         var _loc3_:int = param1.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            if(_loc4_.animation != null)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function setJointsBindMatrices(param1:Vector.<DaeObject>) : void
      {
         var _loc4_:DaeObject = null;
         var _loc5_:Vector.<Number> = null;
         var _loc6_:Joint = null;
         var _loc2_:int = 0;
         var _loc3_:int = this.jointsBindMatrices.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = this.jointsBindMatrices[_loc2_];
            _loc6_ = _loc4_.object as Joint;
            _loc6_.bma = _loc5_[0];
            _loc6_.bmb = _loc5_[1];
            _loc6_.bmc = _loc5_[2];
            _loc6_.bmd = _loc5_[3];
            _loc6_.bme = _loc5_[4];
            _loc6_.bmf = _loc5_[5];
            _loc6_.bmg = _loc5_[6];
            _loc6_.bmh = _loc5_[7];
            _loc6_.bmi = _loc5_[8];
            _loc6_.bmj = _loc5_[9];
            _loc6_.bmk = _loc5_[10];
            _loc6_.bml = _loc5_[11];
            _loc2_++;
         }
      }
      
      private function linkVertexToJoint(param1:Joint, param2:Vertex, param3:Number) : void
      {
         var _loc4_:VertexBinding = new VertexBinding();
         _loc4_.next = param1.vertexBindingList;
         param1.vertexBindingList = _loc4_;
         _loc4_.vertex = param2;
         _loc4_.weight = param3;
         while((param2 = param2.value) != null)
         {
            _loc4_ = new VertexBinding();
            _loc4_.next = param1.vertexBindingList;
            param1.vertexBindingList = _loc4_;
            _loc4_.vertex = param2;
            _loc4_.weight = param3;
         }
      }
      
      private function linkVerticesToJoints(param1:Vector.<DaeObject>, param2:Vector.<Vertex>) : void
      {
         var _loc11_:Vertex = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc3_:int = this.jointsInput.offset;
         var _loc4_:int = this.weightsInput.offset;
         var _loc5_:DaeSource = this.weightsInput.prepareSource(1);
         var _loc6_:Vector.<Number> = _loc5_.numbers;
         var _loc7_:int = _loc5_.stride;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = param2.length;
         while(_loc9_ < _loc10_)
         {
            _loc11_ = param2[_loc9_];
            _loc12_ = this.vcounts[_loc9_];
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc14_ = this.inputsStride * (_loc8_ + _loc13_);
               _loc15_ = this.indices[int(_loc14_ + _loc3_)];
               if(_loc15_ >= 0)
               {
                  _loc16_ = this.indices[int(_loc14_ + _loc4_)];
                  _loc17_ = _loc6_[int(_loc7_ * _loc16_)];
                  this.linkVertexToJoint(Joint(param1[_loc15_].object),_loc11_,_loc17_);
               }
               _loc13_++;
            }
            _loc8_ += _loc12_;
            _loc9_++;
         }
      }
      
      private function addJointsToSkin(param1:Skin, param2:Vector.<DaeNode>, param3:Vector.<DaeNode>) : Vector.<DaeObject>
      {
         var _loc6_:int = 0;
         var _loc9_:DaeNode = null;
         var _loc10_:DaeObject = null;
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:int = param3.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_[param3[_loc6_]] = _loc6_;
            _loc6_++;
         }
         var _loc7_:Vector.<DaeObject> = new Vector.<DaeObject>(_loc5_);
         var _loc8_:int = param2.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc9_ = param2[_loc6_];
            _loc10_ = this.addRootJointToSkin(param1,_loc9_,_loc7_,_loc4_);
            this.addJointChildren(Joint(_loc10_.object),_loc7_,_loc9_,_loc4_);
            _loc6_++;
         }
         return _loc7_;
      }
      
      private function addRootJointToSkin(param1:Skin, param2:DaeNode, param3:Vector.<DaeObject>, param4:Dictionary) : DaeObject
      {
         var _loc5_:Joint = new Joint();
         _loc5_.name = param2.name;
         param1.addJoint(_loc5_);
         var _loc6_:DaeObject = param2.applyAnimation(param2.applyTransformations(_loc5_));
         _loc6_.jointNode = param2;
         if(param2 in param4)
         {
            param3[param4[param2]] = _loc6_;
         }
         else
         {
            param3.push(_loc6_);
         }
         return _loc6_;
      }
      
      private function addJointChildren(param1:Joint, param2:Vector.<DaeObject>, param3:DaeNode, param4:Dictionary) : void
      {
         var _loc5_:DaeObject = null;
         var _loc9_:DaeNode = null;
         var _loc10_:Joint = null;
         var _loc6_:Vector.<DaeNode> = param3.nodes;
         var _loc7_:int = 0;
         var _loc8_:int = _loc6_.length;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc6_[_loc7_];
            if(_loc9_ in param4)
            {
               _loc10_ = new Joint();
               _loc10_.name = _loc9_.name;
               _loc5_ = _loc9_.applyAnimation(_loc9_.applyTransformations(_loc10_));
               _loc5_.jointNode = _loc9_;
               param2[param4[_loc9_]] = _loc5_;
               param1.addChild(_loc10_);
               this.addJointChildren(_loc10_,param2,_loc9_,param4);
            }
            else if(this.hasJointInDescendants(_loc9_,param4))
            {
               _loc10_ = new Joint();
               _loc10_.name = _loc9_.name;
               _loc5_ = _loc9_.applyAnimation(_loc9_.applyTransformations(_loc10_));
               _loc5_.jointNode = _loc9_;
               param2.push(_loc5_);
               param1.addChild(_loc10_);
               this.addJointChildren(_loc10_,param2,_loc9_,param4);
            }
            _loc7_++;
         }
      }
      
      private function hasJointInDescendants(param1:DaeNode, param2:Dictionary) : Boolean
      {
         var _loc6_:DaeNode = null;
         var _loc3_:Vector.<DaeNode> = param1.nodes;
         var _loc4_:int = 0;
         var _loc5_:int = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_ in param2 || this.hasJointInDescendants(_loc6_,param2))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function applyBindShapeMatrix(param1:Skin) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Vertex = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc2_:XML = data.skin.bind_shape_matrix[0];
         if(_loc2_ != null)
         {
            _loc3_ = parseNumbersArray(_loc2_);
            if(_loc3_.length >= 16)
            {
               _loc4_ = _loc3_[0];
               _loc5_ = _loc3_[1];
               _loc6_ = _loc3_[2];
               _loc7_ = _loc3_[3];
               _loc8_ = _loc3_[4];
               _loc9_ = _loc3_[5];
               _loc10_ = _loc3_[6];
               _loc11_ = _loc3_[7];
               _loc12_ = _loc3_[8];
               _loc13_ = _loc3_[9];
               _loc14_ = _loc3_[10];
               _loc15_ = _loc3_[11];
               _loc16_ = param1.vertexList;
               while(_loc16_ != null)
               {
                  _loc17_ = _loc16_.x;
                  _loc18_ = _loc16_.y;
                  _loc19_ = _loc16_.z;
                  _loc16_.x = _loc4_ * _loc17_ + _loc5_ * _loc18_ + _loc6_ * _loc19_ + _loc7_;
                  _loc16_.y = _loc8_ * _loc17_ + _loc9_ * _loc18_ + _loc10_ * _loc19_ + _loc11_;
                  _loc16_.z = _loc12_ * _loc17_ + _loc13_ * _loc18_ + _loc14_ * _loc19_ + _loc15_;
                  _loc16_ = _loc16_.next;
               }
            }
         }
      }
      
      private function isRootJointNode(param1:DaeNode, param2:Dictionary) : Boolean
      {
         var _loc3_:DaeNode = param1.parent;
         while(_loc3_ != null)
         {
            if(_loc3_ in param2)
            {
               return false;
            }
            _loc3_ = _loc3_.parent;
         }
         return true;
      }
      
      public function findRootJointNodes(param1:Vector.<DaeNode>) : Vector.<DaeNode>
      {
         var _loc5_:Dictionary = null;
         var _loc6_:Vector.<DaeNode> = null;
         var _loc7_:DaeNode = null;
         var _loc2_:Vector.<DaeNode> = this.findNodes(param1);
         var _loc3_:int = 0;
         var _loc4_:int = _loc2_.length;
         if(_loc4_ > 0)
         {
            _loc5_ = new Dictionary();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_[_loc2_[_loc3_]] = _loc3_;
               _loc3_++;
            }
            _loc6_ = new Vector.<DaeNode>();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc7_ = _loc2_[_loc3_];
               if(this.isRootJointNode(_loc7_,_loc5_))
               {
                  _loc6_.push(_loc7_);
               }
               _loc3_++;
            }
            return _loc6_;
         }
         return null;
      }
      
      private function findNode(param1:String, param2:Vector.<DaeNode>) : DaeNode
      {
         var _loc5_:DaeNode = null;
         var _loc3_:int = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_].getNodeBySid(param1);
            if(_loc5_ != null)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      private function findNodes(param1:Vector.<DaeNode>) : Vector.<DaeNode>
      {
         var jointsXML:XML = null;
         var jointsSource:DaeSource = null;
         var stride:int = 0;
         var count:int = 0;
         var nodes:Vector.<DaeNode> = null;
         var i:int = 0;
         var node:DaeNode = null;
         var skeletons:Vector.<DaeNode> = param1;
         jointsXML = data.skin.joints.input.(@semantic == "JOINT")[0];
         if(jointsXML != null)
         {
            jointsSource = document.findSource(jointsXML.@source[0]);
            if(jointsSource != null)
            {
               if(jointsSource.parse() && jointsSource.names != null)
               {
                  stride = jointsSource.stride;
                  count = jointsSource.names.length / stride;
                  nodes = new Vector.<DaeNode>(count);
                  i = 0;
                  while(i < count)
                  {
                     node = this.findNode(jointsSource.names[int(stride * i)],skeletons);
                     if(node == null)
                     {
                     }
                     nodes[i] = node;
                     i++;
                  }
                  return nodes;
               }
            }
            else
            {
               document.logger.logNotFoundError(jointsXML.@source[0]);
            }
         }
         return null;
      }
   }
}
