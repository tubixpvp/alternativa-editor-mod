package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.errors.SectorInOtherSceneError;
   import alternativa.engine3d.errors.SplitterInOtherSceneError;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.SpriteTextureMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.WireMaterial;
   import alternativa.types.*;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   use namespace alternativatypes;
   
   public class Scene3D
   {
      alternativa3d var updateBSPOperation:Operation;
      
      alternativa3d var updateSplittersOperation:Operation;
      
      alternativa3d var changePrimitivesOperation:Operation;
      
      alternativa3d var calculateBSPOperation:Operation;
      
      alternativa3d var clearPrimitivesOperation:Operation;
      
      alternativa3d var _root:Object3D;
      
      alternativa3d var operations:Array;
      
      alternativa3d var dummyOperation:Operation;
      
      alternativa3d var _splitAnalysis:Boolean = true;
      
      alternativa3d var _splitBalance:Number = 0;
      
      alternativa3d var changedPrimitives:Set;
      
      private var childPrimitives:Set;
      
      alternativa3d var addPrimitives:Array;
      
      private var _planeOffsetThreshold:Number = 0.01;
      
      alternativa3d var bsp:BSPNode;
      
      alternativa3d var removeNodes:Set;
      
      alternativa3d var dummyNode:BSPNode;
      
      private var _splitters:Array;
      
      private var _sectors:Array;
      
      public function Scene3D()
      {
         this.alternativa3d::updateBSPOperation = new Operation("updateBSP",this);
         this.alternativa3d::updateSplittersOperation = new Operation("updateSplitters",this);
         this.alternativa3d::changePrimitivesOperation = new Operation("changePrimitives",this);
         this.alternativa3d::calculateBSPOperation = new Operation("calculateBSP",this,this.calculateBSP,Operation.alternativa3d::SCENE_CALCULATE_BSP);
         this.alternativa3d::clearPrimitivesOperation = new Operation("clearPrimitives",this,this.clearPrimitives,Operation.alternativa3d::SCENE_CLEAR_PRIMITIVES);
         this.alternativa3d::operations = new Array();
         this.alternativa3d::dummyOperation = new Operation("removed",this);
         this.alternativa3d::changedPrimitives = new Set();
         this.childPrimitives = new Set();
         this.alternativa3d::addPrimitives = new Array();
         this.alternativa3d::removeNodes = new Set();
         this.alternativa3d::dummyNode = new BSPNode();
         this._splitters = new Array();
         this._sectors = new Array();
         super();
         this.alternativa3d::updateBSPOperation.alternativa3d::addSequel(this.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updateBSPOperation.alternativa3d::addSequel(this.alternativa3d::updateSplittersOperation);
         this.alternativa3d::updateSplittersOperation.alternativa3d::addSequel(this.alternativa3d::calculateBSPOperation);
         this.alternativa3d::calculateBSPOperation.alternativa3d::addSequel(this.alternativa3d::changePrimitivesOperation);
         this.alternativa3d::changePrimitivesOperation.alternativa3d::addSequel(this.alternativa3d::clearPrimitivesOperation);
      }
      
      public function calculate() : void
      {
         var loc1:Operation = null;
         var loc2:uint = 0;
         var loc3:uint = 0;
         if(this.alternativa3d::operations[0] != undefined)
         {
            loc2 = this.alternativa3d::operations.length;
            loc3 = 0;
            while(loc3 < loc2)
            {
               loc1 = this.alternativa3d::operations[loc3];
               loc1.alternativa3d::collectSequels(this.alternativa3d::operations);
               loc3++;
            }
            loc2 = this.alternativa3d::operations.length;
            this.alternativa3d::sortOperations(0,loc2 - 1);
            loc3 = 0;
            while(loc3 < loc2)
            {
               loc1 = this.alternativa3d::operations[loc3];
               if(loc1.alternativa3d::method != null)
               {
                  loc1.alternativa3d::method();
               }
               loc3++;
            }
            loc3 = 0;
            while(loc3 < loc2)
            {
               loc1 = this.alternativa3d::operations.pop();
               loc1.alternativa3d::queued = false;
               loc3++;
            }
         }
      }
      
      alternativa3d function sortOperations(param1:int, param2:int) : void
      {
         var loc5:Operation = null;
         var loc7:Operation = null;
         var loc3:int = param1;
         var loc4:int = param2;
         var loc6:uint = uint(this.alternativa3d::operations[param2 + param1 >> 1].priority);
         while(true)
         {
            loc5 = this.alternativa3d::operations[loc3];
            if(loc5.alternativa3d::priority >= loc6)
            {
               while(loc6 < (loc7 = this.alternativa3d::operations[loc4]).alternativa3d::priority)
               {
                  loc4--;
               }
               if(loc3 <= loc4)
               {
                  var loc8:*;
                  this.alternativa3d::operations[loc8 = loc3++] = loc7;
                  var loc9:*;
                  this.alternativa3d::operations[loc9 = loc4--] = loc5;
               }
               if(loc3 > loc4)
               {
                  break;
               }
            }
            else
            {
               loc3++;
            }
         }
         if(param1 < loc4)
         {
            this.alternativa3d::sortOperations(param1,loc4);
         }
         if(loc3 < param2)
         {
            this.alternativa3d::sortOperations(loc3,param2);
         }
      }
      
      alternativa3d function addOperation(param1:Operation) : void
      {
         if(!param1.alternativa3d::queued)
         {
            this.alternativa3d::operations.push(param1);
            param1.alternativa3d::queued = true;
         }
      }
      
      alternativa3d function removeOperation(param1:Operation) : void
      {
         if(param1.alternativa3d::queued)
         {
            this.alternativa3d::operations[this.alternativa3d::operations.indexOf(param1)] = this.alternativa3d::dummyOperation;
            param1.alternativa3d::queued = false;
         }
      }
      
      protected function calculateBSP() : void
      {
         var loc1:int = 0;
         var loc2:Splitter = null;
         var loc3:int = 0;
         var loc5:PolyPrimitive = null;
         var loc6:BSPNode = null;
         var loc7:BSPNode = null;
         var loc8:BSPNode = null;
         var loc9:BSPNode = null;
         if(this.alternativa3d::updateSplittersOperation.alternativa3d::queued || this.alternativa3d::updateBSPOperation.alternativa3d::queued)
         {
            this.alternativa3d::removeNodes.clear();
            this.childBSP(this.alternativa3d::bsp);
            this.assembleChildPrimitives();
            loc1 = int(this._splitters.length);
            if(loc1 > 0)
            {
               loc2 = this._splitters[0];
               this.alternativa3d::bsp = BSPNode.alternativa3d::create(loc2.alternativa3d::primitive);
               loc3 = 1;
               while(loc3 < loc1)
               {
                  loc2 = this.splitters[loc3];
                  this.addBSP(this.alternativa3d::bsp,loc2.alternativa3d::primitive);
                  loc3++;
               }
            }
            else
            {
               this.alternativa3d::bsp = null;
            }
         }
         else if(!this.alternativa3d::removeNodes.isEmpty())
         {
            while(true)
            {
               loc6 = this.alternativa3d::removeNodes.peek();
               if(loc6 == null)
               {
                  break;
               }
               loc7 = loc6;
               while(true)
               {
                  loc6 = loc6.alternativa3d::parent;
                  if(loc6 == null)
                  {
                     break;
                  }
                  if(this.alternativa3d::removeNodes[loc6])
                  {
                     loc7 = loc6;
                  }
               }
               loc8 = loc7.alternativa3d::parent;
               loc9 = this.removeBSPNode(loc7);
               if(loc9 == this.alternativa3d::dummyNode)
               {
                  loc9 = null;
               }
               if(loc8 != null)
               {
                  if(loc8.alternativa3d::front == loc7)
                  {
                     loc8.alternativa3d::front = loc9;
                  }
                  else
                  {
                     loc8.alternativa3d::back = loc9;
                  }
               }
               else
               {
                  this.alternativa3d::bsp = loc9;
               }
               if(loc9 != null)
               {
                  loc9.alternativa3d::parent = loc8;
               }
            }
            this.assembleChildPrimitives();
         }
         if(this.alternativa3d::addPrimitives[0] != undefined)
         {
            if(this.alternativa3d::_splitAnalysis)
            {
               this.analyseSplitQuality();
               this.alternativa3d::sortPrimitives(0,this.alternativa3d::addPrimitives.length - 1);
            }
            else
            {
               this.alternativa3d::sortPrimitivesByMobility(0,this.alternativa3d::addPrimitives.length - 1);
            }
            if(this.alternativa3d::bsp == null)
            {
               loc5 = this.alternativa3d::addPrimitives.pop();
               this.alternativa3d::bsp = BSPNode.alternativa3d::create(loc5);
               this.alternativa3d::changedPrimitives[loc5] = true;
            }
            while(true)
            {
               loc5 = this.alternativa3d::addPrimitives.pop();
               if(loc5 == null)
               {
                  break;
               }
               this.addBSP(this.alternativa3d::bsp,loc5);
            }
         }
      }
      
      alternativa3d function sortPrimitives(param1:int, param2:int) : void
      {
         var loc5:PolyPrimitive = null;
         var loc9:PolyPrimitive = null;
         var loc3:int = param1;
         var loc4:int = param2;
         var loc6:PolyPrimitive = this.alternativa3d::addPrimitives[param2 + param1 >> 1];
         var loc7:int = loc6.mobility;
         var loc8:Number = loc6.splitQuality;
         while(true)
         {
            loc5 = this.alternativa3d::addPrimitives[loc3];
            if(!(loc5.mobility > loc7 || loc5.mobility == loc7 && loc5.splitQuality > loc8))
            {
               while(loc7 > (loc9 = this.alternativa3d::addPrimitives[loc4]).mobility || loc7 == loc9.mobility && loc8 > loc9.splitQuality)
               {
                  loc4--;
               }
               if(loc3 <= loc4)
               {
                  var loc10:*;
                  this.alternativa3d::addPrimitives[loc10 = loc3++] = loc9;
                  var loc11:*;
                  this.alternativa3d::addPrimitives[loc11 = loc4--] = loc5;
               }
               if(loc3 > loc4)
               {
                  break;
               }
            }
            else
            {
               loc3++;
            }
         }
         if(param1 < loc4)
         {
            this.alternativa3d::sortPrimitives(param1,loc4);
         }
         if(loc3 < param2)
         {
            this.alternativa3d::sortPrimitives(loc3,param2);
         }
      }
      
      alternativa3d function sortPrimitivesByMobility(param1:int, param2:int) : void
      {
         var loc5:PolyPrimitive = null;
         var loc7:PolyPrimitive = null;
         var loc3:int = param1;
         var loc4:int = param2;
         var loc6:int = int(this.alternativa3d::addPrimitives[param2 + param1 >> 1].mobility);
         while(true)
         {
            loc5 = this.alternativa3d::addPrimitives[loc3];
            if(loc5.mobility <= loc6)
            {
               while(loc6 > (loc7 = this.alternativa3d::addPrimitives[loc4]).mobility)
               {
                  loc4--;
               }
               if(loc3 <= loc4)
               {
                  var loc8:*;
                  this.alternativa3d::addPrimitives[loc8 = loc3++] = loc7;
                  var loc9:*;
                  this.alternativa3d::addPrimitives[loc9 = loc4--] = loc5;
               }
               if(loc3 > loc4)
               {
                  break;
               }
            }
            else
            {
               loc3++;
            }
         }
         if(param1 < loc4)
         {
            this.alternativa3d::sortPrimitivesByMobility(param1,loc4);
         }
         if(loc3 < param2)
         {
            this.alternativa3d::sortPrimitivesByMobility(loc3,param2);
         }
      }
      
      private function analyseSplitQuality() : void
      {
         var loc1:uint = 0;
         var loc5:PolyPrimitive = null;
         var loc6:Point3D = null;
         var loc7:Number = NaN;
         var loc8:uint = 0;
         var loc9:PolyPrimitive = null;
         var loc10:Boolean = false;
         var loc11:Boolean = false;
         var loc12:uint = 0;
         var loc13:Point3D = null;
         var loc14:Number = NaN;
         var loc2:uint = this.alternativa3d::addPrimitives.length;
         var loc3:uint = 0;
         var loc4:uint = 0;
         loc1 = 0;
         while(loc1 < loc2)
         {
            loc5 = this.alternativa3d::addPrimitives[loc1];
            if(loc5.alternativa3d::face != null)
            {
               loc5.alternativa3d::splits = 0;
               loc5.alternativa3d::disbalance = 0;
               loc6 = loc5.alternativa3d::face.alternativa3d::globalNormal;
               loc7 = loc5.alternativa3d::face.alternativa3d::globalOffset;
               loc8 = 0;
               while(loc8 < loc2)
               {
                  if(loc1 != loc8)
                  {
                     loc9 = this.alternativa3d::addPrimitives[loc8];
                     if(loc9.alternativa3d::face != null)
                     {
                        if(loc5.mobility <= loc9.mobility)
                        {
                           loc10 = false;
                           loc11 = false;
                           loc12 = 0;
                           while(loc12 < loc9.alternativa3d::num)
                           {
                              loc13 = loc9.alternativa3d::points[loc12];
                              loc14 = loc13.x * loc6.x + loc13.y * loc6.y + loc13.z * loc6.z - loc7;
                              if(loc14 > this._planeOffsetThreshold)
                              {
                                 if(!loc10)
                                 {
                                    ++loc5.alternativa3d::disbalance;
                                    loc10 = true;
                                 }
                                 if(loc11)
                                 {
                                    ++loc5.alternativa3d::splits;
                                    break;
                                 }
                              }
                              else if(loc14 < -this._planeOffsetThreshold)
                              {
                                 if(!loc11)
                                 {
                                    --loc5.alternativa3d::disbalance;
                                    loc11 = true;
                                 }
                                 if(loc10)
                                 {
                                    ++loc5.alternativa3d::splits;
                                    break;
                                 }
                              }
                              loc12++;
                           }
                        }
                     }
                  }
                  loc8++;
               }
               loc5.alternativa3d::disbalance = loc5.alternativa3d::disbalance > 0 ? loc5.alternativa3d::disbalance : int(-loc5.alternativa3d::disbalance);
               loc3 = loc3 > loc5.alternativa3d::splits ? loc3 : loc5.alternativa3d::splits;
               loc4 = loc4 > loc5.alternativa3d::disbalance ? loc4 : uint(loc5.alternativa3d::disbalance);
            }
            loc1++;
         }
         loc1 = 0;
         while(loc1 < loc2)
         {
            loc5 = this.alternativa3d::addPrimitives[loc1];
            loc5.splitQuality = (1 - this.alternativa3d::_splitBalance) * loc5.alternativa3d::splits / loc3 + this.alternativa3d::_splitBalance * loc5.alternativa3d::disbalance / loc4;
            loc1++;
         }
      }
      
      protected function addBSP(param1:BSPNode, param2:PolyPrimitive) : void
      {
         var loc3:Point3D = null;
         var loc4:Point3D = null;
         var loc5:* = undefined;
         var loc6:PolyPrimitive = null;
         var loc7:Array = null;
         var loc8:Boolean = false;
         var loc9:Boolean = false;
         var loc10:uint = 0;
         var loc11:Number = NaN;
         var loc12:SplitterPrimitive = null;
         var loc13:PolyPrimitive = null;
         var loc14:PolyPrimitive = null;
         var loc15:Number = NaN;
         var loc16:Number = NaN;
         var loc17:Number = NaN;
         var loc18:uint = 0;
         var loc19:Number = NaN;
         if(param2.mobility < param1.alternativa3d::mobility || param1.alternativa3d::isSprite && param2.alternativa3d::face != null)
         {
            if(param1.alternativa3d::primitive != null)
            {
               this.childPrimitives[param1.alternativa3d::primitive] = true;
               this.alternativa3d::changedPrimitives[param1.alternativa3d::primitive] = true;
               param1.alternativa3d::primitive.alternativa3d::node = null;
            }
            else
            {
               for(loc5 in param1.alternativa3d::backPrimitives)
               {
                  loc6 = loc5;
                  this.childPrimitives[loc6] = true;
                  this.alternativa3d::changedPrimitives[loc6] = true;
                  loc6.alternativa3d::node = null;
               }
               for(loc5 in param1.alternativa3d::frontPrimitives)
               {
                  loc6 = loc5;
                  this.childPrimitives[loc6] = true;
                  this.alternativa3d::changedPrimitives[loc6] = true;
                  loc6.alternativa3d::node = null;
               }
            }
            this.childBSP(param1.alternativa3d::back);
            this.childBSP(param1.alternativa3d::front);
            this.assembleChildPrimitives();
            if(this.alternativa3d::_splitAnalysis)
            {
               this.analyseSplitQuality();
               this.alternativa3d::sortPrimitives(0,this.alternativa3d::addPrimitives.length - 1);
            }
            else
            {
               this.alternativa3d::sortPrimitivesByMobility(0,this.alternativa3d::addPrimitives.length - 1);
            }
            param1.alternativa3d::primitive = param2;
            this.alternativa3d::changedPrimitives[param2] = true;
            param2.alternativa3d::node = param1;
            param1.alternativa3d::normal.copy(param2.alternativa3d::face.alternativa3d::globalNormal);
            param1.alternativa3d::offset = param2.alternativa3d::face.alternativa3d::globalOffset;
            param1.alternativa3d::isSprite = false;
            param1.alternativa3d::mobility = param2.mobility;
            param1.alternativa3d::backPrimitives = null;
            param1.alternativa3d::frontPrimitives = null;
            param1.alternativa3d::back = null;
            param1.alternativa3d::front = null;
         }
         else
         {
            loc4 = param1.alternativa3d::normal;
            loc7 = param2.alternativa3d::points;
            loc8 = false;
            loc9 = false;
            loc10 = 0;
            while(loc10 < param2.alternativa3d::num)
            {
               loc3 = loc7[loc10];
               loc11 = loc3.x * loc4.x + loc3.y * loc4.y + loc3.z * loc4.z - param1.alternativa3d::offset;
               if(loc11 > this._planeOffsetThreshold)
               {
                  loc8 = true;
                  if(loc9)
                  {
                     break;
                  }
               }
               else if(loc11 < -this._planeOffsetThreshold)
               {
                  loc9 = true;
                  if(loc8)
                  {
                     break;
                  }
               }
               loc10++;
            }
            if(param1.alternativa3d::splitter != null && !loc8 && !loc9)
            {
               if(param2.alternativa3d::face == null)
               {
                  loc12 = param2 as SplitterPrimitive;
                  if(loc12 != null)
                  {
                     if(Point3D.dot(loc4,loc12.alternativa3d::splitter.alternativa3d::normal) > 0)
                     {
                        loc8 = true;
                     }
                     else
                     {
                        loc9 = true;
                     }
                  }
                  else
                  {
                     loc8 = true;
                  }
               }
               else if(Point3D.dot(loc4,param2.alternativa3d::face.alternativa3d::globalNormal) > 0)
               {
                  loc8 = true;
               }
               else
               {
                  loc9 = true;
               }
            }
            if(!loc8 && !loc9 && (param2.alternativa3d::face != null || param1.alternativa3d::isSprite))
            {
               param2.alternativa3d::node = param1;
               if(param1.alternativa3d::primitive != null)
               {
                  param1.alternativa3d::frontPrimitives = new Set(true);
                  param1.alternativa3d::frontPrimitives[param1.alternativa3d::primitive] = true;
                  param1.alternativa3d::primitive = null;
               }
               if(param2.alternativa3d::face == null || Point3D.dot(param2.alternativa3d::face.alternativa3d::globalNormal,loc4) > 0)
               {
                  param1.alternativa3d::frontPrimitives[param2] = true;
               }
               else
               {
                  if(param1.alternativa3d::backPrimitives == null)
                  {
                     param1.alternativa3d::backPrimitives = new Set(true);
                  }
                  param1.alternativa3d::backPrimitives[param2] = true;
               }
               this.alternativa3d::changedPrimitives[param2] = true;
            }
            else if(!loc9)
            {
               if(param1.alternativa3d::front == null)
               {
                  param1.alternativa3d::front = BSPNode.alternativa3d::create(param2);
                  param1.alternativa3d::front.alternativa3d::parent = param1;
                  this.alternativa3d::changedPrimitives[param2] = true;
               }
               else
               {
                  this.addBSP(param1.alternativa3d::front,param2);
               }
            }
            else if(!loc8)
            {
               if(param1.alternativa3d::back == null)
               {
                  param1.alternativa3d::back = BSPNode.alternativa3d::create(param2);
                  param1.alternativa3d::back.alternativa3d::parent = param1;
                  this.alternativa3d::changedPrimitives[param2] = true;
               }
               else
               {
                  this.addBSP(param1.alternativa3d::back,param2);
               }
            }
            else
            {
               loc13 = param2.alternativa3d::createFragment();
               loc14 = param2.alternativa3d::createFragment();
               loc3 = loc7[0];
               loc16 = loc15 = loc3.x * loc4.x + loc3.y * loc4.y + loc3.z * loc4.z - param1.alternativa3d::offset;
               loc10 = 0;
               while(loc10 < param2.alternativa3d::num)
               {
                  if(loc10 < param2.alternativa3d::num - 1)
                  {
                     loc18 = uint(loc10 + 1);
                     loc3 = loc7[loc18];
                     loc17 = loc3.x * loc4.x + loc3.y * loc4.y + loc3.z * loc4.z - param1.alternativa3d::offset;
                  }
                  else
                  {
                     loc18 = 0;
                     loc17 = loc15;
                  }
                  if(loc16 > this._planeOffsetThreshold)
                  {
                     loc14.alternativa3d::points.push(loc7[loc10]);
                  }
                  else if(loc16 < -this._planeOffsetThreshold)
                  {
                     loc13.alternativa3d::points.push(loc7[loc10]);
                  }
                  else
                  {
                     loc13.alternativa3d::points.push(loc7[loc10]);
                     loc14.alternativa3d::points.push(loc7[loc10]);
                  }
                  if(loc16 > this._planeOffsetThreshold && loc17 < -this._planeOffsetThreshold || loc16 < -this._planeOffsetThreshold && loc17 > this._planeOffsetThreshold)
                  {
                     loc19 = loc16 / (loc16 - loc17);
                     loc3 = Point3D.interpolate(loc7[loc10],loc7[loc18],loc19);
                     loc13.alternativa3d::points.push(loc3);
                     loc14.alternativa3d::points.push(loc3);
                  }
                  loc16 = loc17;
                  loc10++;
               }
               loc13.alternativa3d::num = loc13.alternativa3d::points.length;
               loc14.alternativa3d::num = loc14.alternativa3d::points.length;
               loc13.alternativa3d::parent = param2;
               loc14.alternativa3d::parent = param2;
               loc13.alternativa3d::sibling = loc14;
               loc14.alternativa3d::sibling = loc13;
               param2.alternativa3d::backFragment = loc13;
               param2.alternativa3d::frontFragment = loc14;
               if(param1.alternativa3d::back == null)
               {
                  param1.alternativa3d::back = BSPNode.alternativa3d::create(loc13);
                  param1.alternativa3d::back.alternativa3d::parent = param1;
                  this.alternativa3d::changedPrimitives[loc13] = true;
               }
               else
               {
                  this.addBSP(param1.alternativa3d::back,loc13);
               }
               if(param1.alternativa3d::front == null)
               {
                  param1.alternativa3d::front = BSPNode.alternativa3d::create(loc14);
                  param1.alternativa3d::front.alternativa3d::parent = param1;
                  this.alternativa3d::changedPrimitives[loc14] = true;
               }
               else
               {
                  this.addBSP(param1.alternativa3d::front,loc14);
               }
            }
         }
      }
      
      protected function removeBSPNode(param1:BSPNode) : BSPNode
      {
         var loc2:BSPNode = null;
         if(param1 != null)
         {
            param1.alternativa3d::back = this.removeBSPNode(param1.alternativa3d::back);
            param1.alternativa3d::front = this.removeBSPNode(param1.alternativa3d::front);
            if(!this.alternativa3d::removeNodes[param1])
            {
               loc2 = param1;
               if(param1.alternativa3d::back != null)
               {
                  if(param1.alternativa3d::back != this.alternativa3d::dummyNode)
                  {
                     param1.alternativa3d::back.alternativa3d::parent = param1;
                  }
                  else
                  {
                     param1.alternativa3d::back = null;
                  }
               }
               if(param1.alternativa3d::front != null)
               {
                  if(param1.alternativa3d::front != this.alternativa3d::dummyNode)
                  {
                     param1.alternativa3d::front.alternativa3d::parent = param1;
                  }
                  else
                  {
                     param1.alternativa3d::front = null;
                  }
               }
            }
            else
            {
               if(param1.alternativa3d::back == null)
               {
                  if(param1.alternativa3d::front != null)
                  {
                     loc2 = param1.alternativa3d::front;
                     param1.alternativa3d::front = null;
                  }
               }
               else if(param1.alternativa3d::front == null)
               {
                  loc2 = param1.alternativa3d::back;
                  param1.alternativa3d::back = null;
               }
               else
               {
                  this.childBSP(param1.alternativa3d::back);
                  this.childBSP(param1.alternativa3d::front);
                  loc2 = this.alternativa3d::dummyNode;
                  param1.alternativa3d::back = null;
                  param1.alternativa3d::front = null;
               }
               delete this.alternativa3d::removeNodes[param1];
               param1.alternativa3d::parent = null;
               BSPNode.alternativa3d::destroy(param1);
            }
         }
         return loc2;
      }
      
      alternativa3d function removeBSPPrimitive(param1:PolyPrimitive) : void
      {
         var loc4:* = undefined;
         var loc5:BSPNode = null;
         var loc2:BSPNode = param1.alternativa3d::node;
         param1.alternativa3d::node = null;
         var loc3:Boolean = false;
         this.alternativa3d::changedPrimitives[param1] = true;
         if(loc2.alternativa3d::primitive == param1)
         {
            this.alternativa3d::removeNodes[loc2] = true;
            loc2.alternativa3d::primitive = null;
         }
         else if(loc2.alternativa3d::frontPrimitives[param1])
         {
            delete loc2.alternativa3d::frontPrimitives[param1];
            for(loc4 in loc2.alternativa3d::frontPrimitives)
            {
               if(loc3)
               {
                  loc3 = false;
                  break;
               }
               loc3 = true;
            }
            if(loc4 == null)
            {
               loc5 = loc2.alternativa3d::back;
               loc2.alternativa3d::back = loc2.alternativa3d::front;
               loc2.alternativa3d::front = loc5;
               loc2.alternativa3d::normal.invert();
               loc2.alternativa3d::offset = -loc2.alternativa3d::offset;
               for(loc4 in loc2.alternativa3d::backPrimitives)
               {
                  if(loc3)
                  {
                     loc3 = false;
                     break;
                  }
                  loc3 = true;
               }
               if(loc3)
               {
                  loc2.alternativa3d::primitive = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::primitive.mobility;
                  loc2.alternativa3d::frontPrimitives = null;
               }
               else
               {
                  loc2.alternativa3d::frontPrimitives = loc2.alternativa3d::backPrimitives;
                  if(param1.mobility == loc2.alternativa3d::mobility)
                  {
                     loc2.alternativa3d::mobility = int.MAX_VALUE;
                     for(loc4 in loc2.alternativa3d::frontPrimitives)
                     {
                        param1 = loc4;
                        loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
                     }
                  }
               }
               loc2.alternativa3d::backPrimitives = null;
            }
            else if(loc3 && loc2.alternativa3d::backPrimitives == null)
            {
               loc2.alternativa3d::primitive = loc4;
               loc2.alternativa3d::mobility = loc2.alternativa3d::primitive.mobility;
               loc2.alternativa3d::frontPrimitives = null;
            }
            else if(param1.mobility == loc2.alternativa3d::mobility)
            {
               loc2.alternativa3d::mobility = int.MAX_VALUE;
               for(loc4 in loc2.alternativa3d::backPrimitives)
               {
                  param1 = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
               }
               for(loc4 in loc2.alternativa3d::frontPrimitives)
               {
                  param1 = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
               }
            }
         }
         else
         {
            delete loc2.alternativa3d::backPrimitives[param1];
            var loc6:int = 0;
            var loc7:* = loc2.alternativa3d::backPrimitives;
            for(loc4 in loc7)
            {
            }
            if(loc4 == null)
            {
               for(loc4 in loc2.alternativa3d::frontPrimitives)
               {
                  if(loc3)
                  {
                     loc3 = false;
                     break;
                  }
                  loc3 = true;
               }
               if(loc3)
               {
                  loc2.alternativa3d::primitive = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::primitive.mobility;
                  loc2.alternativa3d::frontPrimitives = null;
               }
               else if(param1.mobility == loc2.alternativa3d::mobility)
               {
                  loc2.alternativa3d::mobility = int.MAX_VALUE;
                  for(loc4 in loc2.alternativa3d::frontPrimitives)
                  {
                     param1 = loc4;
                     loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
                  }
               }
               loc2.alternativa3d::backPrimitives = null;
            }
            else if(param1.mobility == loc2.alternativa3d::mobility)
            {
               loc2.alternativa3d::mobility = int.MAX_VALUE;
               for(loc4 in loc2.alternativa3d::backPrimitives)
               {
                  param1 = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
               }
               for(loc4 in loc2.alternativa3d::frontPrimitives)
               {
                  param1 = loc4;
                  loc2.alternativa3d::mobility = loc2.alternativa3d::mobility > param1.mobility ? param1.mobility : loc2.alternativa3d::mobility;
               }
            }
         }
      }
      
      protected function childBSP(param1:BSPNode) : void
      {
         var loc2:PolyPrimitive = null;
         var loc3:* = undefined;
         if(param1 != null && param1 != this.alternativa3d::dummyNode)
         {
            loc2 = param1.alternativa3d::primitive;
            if(loc2 != null)
            {
               this.childPrimitives[loc2] = true;
               this.alternativa3d::changedPrimitives[loc2] = true;
               param1.alternativa3d::primitive = null;
               loc2.alternativa3d::node = null;
            }
            else
            {
               for(loc3 in param1.alternativa3d::backPrimitives)
               {
                  loc2 = loc3;
                  this.childPrimitives[loc2] = true;
                  this.alternativa3d::changedPrimitives[loc2] = true;
                  loc2.alternativa3d::node = null;
               }
               for(loc3 in param1.alternativa3d::frontPrimitives)
               {
                  loc2 = loc3;
                  this.childPrimitives[loc2] = true;
                  this.alternativa3d::changedPrimitives[loc2] = true;
                  loc2.alternativa3d::node = null;
               }
               param1.alternativa3d::backPrimitives = null;
               param1.alternativa3d::frontPrimitives = null;
            }
            this.childBSP(param1.alternativa3d::back);
            this.childBSP(param1.alternativa3d::front);
            param1.alternativa3d::parent = null;
            param1.alternativa3d::back = null;
            param1.alternativa3d::front = null;
            BSPNode.alternativa3d::destroy(param1);
         }
      }
      
      protected function assembleChildPrimitives() : void
      {
         var loc1:PolyPrimitive = null;
         while(true)
         {
            loc1 = this.childPrimitives.take();
            if(loc1 == null)
            {
               break;
            }
            this.assemblePrimitive(loc1);
         }
      }
      
      private function assemblePrimitive(param1:PolyPrimitive) : void
      {
         if(param1.alternativa3d::sibling != null && this.canAssemble(param1.alternativa3d::sibling))
         {
            this.assemblePrimitive(param1.alternativa3d::parent);
            param1.alternativa3d::sibling.alternativa3d::sibling = null;
            param1.alternativa3d::sibling.alternativa3d::parent = null;
            PolyPrimitive.alternativa3d::destroy(param1.alternativa3d::sibling);
            param1.alternativa3d::sibling = null;
            param1.alternativa3d::parent.alternativa3d::backFragment = null;
            param1.alternativa3d::parent.alternativa3d::frontFragment = null;
            param1.alternativa3d::parent = null;
            PolyPrimitive.alternativa3d::destroy(param1);
         }
         else
         {
            this.alternativa3d::addPrimitives.push(param1);
         }
      }
      
      private function canAssemble(param1:PolyPrimitive) : Boolean
      {
         var loc2:PolyPrimitive = null;
         var loc3:PolyPrimitive = null;
         var loc4:Boolean = false;
         var loc5:Boolean = false;
         if(this.childPrimitives[param1])
         {
            delete this.childPrimitives[param1];
            return true;
         }
         loc2 = param1.alternativa3d::backFragment;
         loc3 = param1.alternativa3d::frontFragment;
         if(loc2 != null)
         {
            loc4 = this.canAssemble(loc2);
            loc5 = this.canAssemble(loc3);
            if(loc4 && loc5)
            {
               loc2.alternativa3d::parent = null;
               loc3.alternativa3d::parent = null;
               loc2.alternativa3d::sibling = null;
               loc3.alternativa3d::sibling = null;
               param1.alternativa3d::backFragment = null;
               param1.alternativa3d::frontFragment = null;
               PolyPrimitive.alternativa3d::destroy(loc2);
               PolyPrimitive.alternativa3d::destroy(loc3);
               return true;
            }
            if(loc4)
            {
               this.alternativa3d::addPrimitives.push(loc2);
            }
            if(loc5)
            {
               this.alternativa3d::addPrimitives.push(loc3);
            }
         }
         return false;
      }
      
      private function clearPrimitives() : void
      {
         this.alternativa3d::changedPrimitives.clear();
      }
      
      public function hasChanges() : Boolean
      {
         var loc1:int = int(this.alternativa3d::operations.length);
         var loc2:int = 0;
         while(loc2 < loc1)
         {
            if(this.alternativa3d::operations[loc2] != this.alternativa3d::dummyOperation)
            {
               return true;
            }
            loc2++;
         }
         return false;
      }
      
      public function get root() : Object3D
      {
         return this.alternativa3d::_root;
      }
      
      public function set root(param1:Object3D) : void
      {
         if(this.alternativa3d::_root != param1)
         {
            if(param1 != null)
            {
               if(param1.alternativa3d::_parent != null)
               {
                  param1.alternativa3d::_parent.alternativa3d::_children.remove(param1);
               }
               else if(param1.alternativa3d::_scene != null && param1.alternativa3d::_scene.alternativa3d::_root == param1)
               {
                  param1.alternativa3d::_scene.root = null;
               }
               param1.alternativa3d::setParent(null);
               param1.alternativa3d::setScene(this);
               param1.alternativa3d::setLevel(0);
            }
            if(this.alternativa3d::_root != null)
            {
               this.alternativa3d::_root.alternativa3d::setParent(null);
               this.alternativa3d::_root.alternativa3d::setScene(null);
            }
            this.alternativa3d::_root = param1;
         }
      }
      
      public function get splitters() : Array
      {
         return new Array().concat(this._splitters);
      }
      
      public function set splitters(param1:Array) : void
      {
         var loc2:Splitter = null;
         var loc3:int = 0;
         var loc4:int = 0;
         for each(loc2 in this._splitters)
         {
            loc2.alternativa3d::removeFromScene(this);
         }
         if(param1 != null)
         {
            loc3 = int(param1.length);
            loc4 = 0;
            while(loc4 < loc3)
            {
               loc2 = param1[loc4];
               if(loc2.alternativa3d::_scene != null)
               {
                  this._splitters.length = loc4;
                  this.alternativa3d::addOperation(this.alternativa3d::updateSplittersOperation);
                  throw new SplitterInOtherSceneError(loc2,this);
               }
               loc2.alternativa3d::addToScene(this);
               this._splitters[loc4] = loc2;
               loc4++;
            }
            this._splitters.length = loc3;
         }
         else
         {
            this._splitters.length = 0;
         }
         this.alternativa3d::addOperation(this.alternativa3d::updateSplittersOperation);
      }
      
      public function get sectors() : Array
      {
         return new Array().concat(this._sectors);
      }
      
      public function set sectors(param1:Array) : void
      {
         var loc2:Sector = null;
         var loc3:int = 0;
         var loc4:int = 0;
         for each(loc2 in this._sectors)
         {
            loc2.alternativa3d::removeFromScene(this);
         }
         if(param1 != null)
         {
            loc3 = int(param1.length);
            loc4 = 0;
            while(loc4 < loc3)
            {
               loc2 = param1[loc4];
               if(loc2.alternativa3d::_scene != null)
               {
                  this._sectors.length = loc4;
                  throw new SectorInOtherSceneError(loc2,this);
               }
               loc2.alternativa3d::addToScene(this);
               loc2.alternativa3d::setLevel(loc4);
               this._sectors[loc4] = loc2;
               loc4++;
            }
            this._sectors.length = loc3;
         }
         else
         {
            this._sectors.length = 0;
         }
      }
      
      public function get splitAnalysis() : Boolean
      {
         return this.alternativa3d::_splitAnalysis;
      }
      
      public function set splitAnalysis(param1:Boolean) : void
      {
         if(this.alternativa3d::_splitAnalysis != param1)
         {
            this.alternativa3d::_splitAnalysis = param1;
            this.alternativa3d::addOperation(this.alternativa3d::updateBSPOperation);
         }
      }
      
      public function get splitBalance() : Number
      {
         return this.alternativa3d::_splitBalance;
      }
      
      public function set splitBalance(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : (param1 > 1 ? 1 : param1);
         if(this.alternativa3d::_splitBalance != param1)
         {
            this.alternativa3d::_splitBalance = param1;
            if(this.alternativa3d::_splitAnalysis)
            {
               this.alternativa3d::addOperation(this.alternativa3d::updateBSPOperation);
            }
         }
      }
      
      public function get planeOffsetThreshold() : Number
      {
         return this._planeOffsetThreshold;
      }
      
      public function set planeOffsetThreshold(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         if(this._planeOffsetThreshold != param1)
         {
            this._planeOffsetThreshold = param1;
            this.alternativa3d::addOperation(this.alternativa3d::updateBSPOperation);
         }
      }
      
      public function drawBSP(param1:Sprite) : void
      {
         param1.graphics.clear();
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
         if(this.alternativa3d::bsp != null)
         {
            this.drawBSPNode(this.alternativa3d::bsp,param1,0,0,1);
         }
      }
      
      private function drawBSPNode(param1:BSPNode, param2:Sprite, param3:Number, param4:Number, param5:Number) : void
      {
         var loc10:SpritePrimitive = null;
         var loc11:SpriteTextureMaterial = null;
         var loc12:PolyPrimitive = null;
         var loc6:Shape = new Shape();
         param2.addChild(loc6);
         loc6.x = param3;
         loc6.y = param4;
         var loc7:uint = 16711680;
         if(param1.alternativa3d::splitter != null)
         {
            if(param1.alternativa3d::splitter.alternativa3d::_open)
            {
               loc7 = 65280;
            }
            else
            {
               loc7 = 16773120;
            }
            loc6.graphics.beginFill(loc7);
            loc6.graphics.moveTo(-4,0);
            loc6.graphics.lineTo(0,-4);
            loc6.graphics.lineTo(4,0);
            loc6.graphics.lineTo(0,4);
            loc6.graphics.endFill();
         }
         else if(param1.alternativa3d::isSprite)
         {
            if(param1.alternativa3d::primitive != null)
            {
               loc10 = param1.alternativa3d::primitive as SpritePrimitive;
            }
            else if(param1.alternativa3d::frontPrimitives != null)
            {
               loc10 = param1.alternativa3d::frontPrimitives.peek();
            }
            if(loc10 != null)
            {
               loc11 = loc10.alternativa3d::sprite.alternativa3d::_material as SpriteTextureMaterial;
               if(loc11 != null && loc11.alternativa3d::_texture != null)
               {
                  loc7 = loc11.alternativa3d::_texture.alternativatypes::_bitmapData.getPixel(loc11.alternativa3d::_texture.alternativatypes::_bitmapData.width >> 1,loc11.alternativa3d::_texture.alternativatypes::_bitmapData.height >> 1);
               }
            }
            loc6.graphics.beginFill(loc7);
            loc6.graphics.drawRect(0,0,5,5);
            loc6.graphics.endFill();
         }
         else
         {
            if(param1.alternativa3d::primitive != null)
            {
               loc12 = param1.alternativa3d::primitive;
            }
            else if(param1.alternativa3d::frontPrimitives != null)
            {
               loc12 = param1.alternativa3d::frontPrimitives.peek();
            }
            if(loc12 != null)
            {
               if(loc12.alternativa3d::face.alternativa3d::_surface != null && loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material != null)
               {
                  if(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material is FillMaterial)
                  {
                     loc7 = FillMaterial(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material).alternativa3d::_color;
                  }
                  if(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material is WireMaterial)
                  {
                     loc7 = WireMaterial(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material).alternativa3d::_color;
                  }
                  if(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material is TextureMaterial && TextureMaterial(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material).alternativa3d::_texture != null)
                  {
                     loc7 = TextureMaterial(loc12.alternativa3d::face.alternativa3d::_surface.alternativa3d::_material).texture.alternativatypes::_bitmapData.getPixel(0,0);
                  }
               }
            }
            if(param1 == this.alternativa3d::dummyNode)
            {
               loc7 = 16711935;
            }
            loc6.graphics.beginFill(loc7);
            loc6.graphics.drawCircle(0,0,3);
            loc6.graphics.endFill();
         }
         if(param1.alternativa3d::back != null)
         {
            param2.graphics.lineStyle(0,6684672);
            param2.graphics.moveTo(param3,param4);
            param2.graphics.lineTo(param3 - 100 * param5,param4 + 20);
            this.drawBSPNode(param1.alternativa3d::back,param2,param3 - 100 * param5,param4 + 20,param5 * 0.8);
         }
         if(param1.alternativa3d::front != null)
         {
            param2.graphics.lineStyle(0,26112);
            param2.graphics.moveTo(param3,param4);
            param2.graphics.lineTo(param3 + 100 * param5,param4 + 20);
            this.drawBSPNode(param1.alternativa3d::front,param2,param3 + 100 * param5,param4 + 20,param5 * 0.8);
         }
      }
   }
}

