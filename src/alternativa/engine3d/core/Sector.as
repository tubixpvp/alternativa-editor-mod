package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.types.Point3D;
   import alternativa.types.Set;
   
   use namespace alternativa3d;
   
   public class Sector
   {
      private static var counter:uint = 0;
      
      alternativa3d var updateOperation:Operation;
      
      alternativa3d var findNodeOperation:Operation;
      
      alternativa3d var changeVisibleOperation:Operation;
      
      alternativa3d var _visible:Set;
      
      private var x:Number;
      
      private var y:Number;
      
      private var z:Number;
      
      alternativa3d var _scene:Scene3D;
      
      private var _node:BSPNode;
      
      public var name:String;
      
      public function Sector(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:String = null)
      {
         this.alternativa3d::updateOperation = new Operation("removeSector",this,this.removeFromBSP,Operation.alternativa3d::SECTOR_UPDATE);
         this.alternativa3d::findNodeOperation = new Operation("addSector",this,this.addToBSP,Operation.alternativa3d::SECTOR_FIND_NODE);
         this.alternativa3d::changeVisibleOperation = new Operation("changeSectorVisibility",this,this.changeVisible,Operation.alternativa3d::SECTOR_CHANGE_VISIBLE);
         this.alternativa3d::_visible = new Set();
         super();
         this.name = param4 != null ? param4 : "sector" + ++counter;
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.alternativa3d::_visible[this] = true;
         this.alternativa3d::updateOperation.alternativa3d::addSequel(this.alternativa3d::findNodeOperation);
         this.alternativa3d::findNodeOperation.alternativa3d::addSequel(this.alternativa3d::changeVisibleOperation);
      }
      
      public function addVisible(param1:Sector, ... rest) : void
      {
         var loc5:Sector = null;
         param1.alternativa3d::_visible[this] = true;
         this.alternativa3d::_visible[param1] = true;
         param1.alternativa3d::markToChange();
         var loc3:int = int(rest.length);
         var loc4:int = 0;
         while(loc4 < loc3)
         {
            loc5 = rest[loc4];
            loc5.alternativa3d::_visible[this] = true;
            this.alternativa3d::_visible[loc5] = true;
            loc5.alternativa3d::markToChange();
            loc4++;
         }
         this.alternativa3d::markToChange();
      }
      
      public function removeVisible(param1:Sector, ... rest) : void
      {
         var loc5:Sector = null;
         if(Boolean(this.alternativa3d::_visible[param1]) && param1 != this)
         {
            delete param1.alternativa3d::_visible[this];
            param1.alternativa3d::markToChange();
            delete this.alternativa3d::_visible[param1];
            this.alternativa3d::markToChange();
         }
         var loc3:int = int(rest.length);
         var loc4:int = 0;
         while(loc4 < loc3)
         {
            loc5 = rest[loc4];
            if(Boolean(this.alternativa3d::_visible[loc5]) && loc5 != this)
            {
               delete loc5.alternativa3d::_visible[this];
               loc5.alternativa3d::markToChange();
               delete this.alternativa3d::_visible[loc5];
               this.alternativa3d::markToChange();
            }
            loc4++;
         }
      }
      
      public function isVisible(param1:Sector) : Boolean
      {
         return this.alternativa3d::_visible[param1];
      }
      
      public function toString() : String
      {
         var loc2:Sector = null;
         var loc4:* = undefined;
         var loc1:String = "[Sector " + this.name + " X:" + this.x.toFixed(3) + " Y:" + this.y.toFixed(3) + " Z:" + this.z.toFixed(3);
         var loc3:String = "";
         for(loc4 in this.alternativa3d::_visible)
         {
            if(loc4 != this)
            {
               if(loc2 == null)
               {
                  loc2 = loc4;
                  loc3 = loc2.name;
               }
               else
               {
                  loc2 = loc4;
                  loc3 += " " + loc2.name;
               }
            }
         }
         return loc2 == null ? loc1 + "]" : loc1 + " visible:[" + loc3 + "]]";
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
         this.alternativa3d::_scene = param1;
         param1.alternativa3d::updateSplittersOperation.alternativa3d::addSequel(this.alternativa3d::updateOperation);
         this.alternativa3d::changeVisibleOperation.alternativa3d::addSequel(param1.alternativa3d::changePrimitivesOperation);
         param1.alternativa3d::addOperation(this.alternativa3d::findNodeOperation);
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::updateSplittersOperation.alternativa3d::removeSequel(this.alternativa3d::updateOperation);
         this.alternativa3d::changeVisibleOperation.alternativa3d::removeSequel(param1.alternativa3d::changePrimitivesOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::findNodeOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::changeVisibleOperation);
         this.removeFromBSP();
         this.alternativa3d::_scene = null;
      }
      
      alternativa3d function setLevel(param1:int) : void
      {
         this.alternativa3d::findNodeOperation.alternativa3d::priority = this.alternativa3d::findNodeOperation.alternativa3d::priority & 4278190080 | param1;
      }
      
      alternativa3d function markToChange() : void
      {
         if(this.alternativa3d::_scene != null)
         {
            this.alternativa3d::_scene.alternativa3d::addOperation(this.alternativa3d::changeVisibleOperation);
         }
      }
      
      private function removeFromBSP() : void
      {
         if(this._node != null)
         {
            if(this._node.alternativa3d::frontSector == this)
            {
               this._node.alternativa3d::frontSector = null;
            }
            else
            {
               this._node.alternativa3d::backSector = null;
            }
            this._node = null;
         }
      }
      
      private function addToBSP() : void
      {
         this.findSectorNode(this.alternativa3d::_scene.alternativa3d::bsp);
      }
      
      private function findSectorNode(param1:BSPNode) : void
      {
         var loc2:Point3D = null;
         if(param1 != null && param1.alternativa3d::splitter != null)
         {
            loc2 = param1.alternativa3d::normal;
            if(this.x * loc2.x + this.y * loc2.y + this.z * loc2.z - param1.alternativa3d::offset >= 0)
            {
               if(param1.alternativa3d::front == null || param1.alternativa3d::front.alternativa3d::splitter == null)
               {
                  if(param1.alternativa3d::frontSector == null)
                  {
                     param1.alternativa3d::frontSector = this;
                     this._node = param1;
                  }
               }
               else
               {
                  this.findSectorNode(param1.alternativa3d::front);
               }
            }
            else if(param1.alternativa3d::back == null || param1.alternativa3d::back.alternativa3d::splitter == null)
            {
               if(param1.alternativa3d::backSector == null)
               {
                  param1.alternativa3d::backSector = this;
                  this._node = param1;
               }
            }
            else
            {
               this.findSectorNode(param1.alternativa3d::back);
            }
         }
      }
      
      private function changeVisible() : void
      {
         if(this._node != null)
         {
            if(this._node.alternativa3d::frontSector == this)
            {
               this.changeNode(this._node.alternativa3d::front);
            }
            else
            {
               this.changeNode(this._node.alternativa3d::back);
            }
         }
      }
      
      private function changeNode(param1:BSPNode) : void
      {
         var loc2:* = undefined;
         if(param1 != null)
         {
            if(param1.alternativa3d::primitive != null)
            {
               this.alternativa3d::_scene.alternativa3d::changedPrimitives[param1.alternativa3d::primitive] = true;
            }
            else
            {
               for(loc2 in param1.alternativa3d::frontPrimitives)
               {
                  this.alternativa3d::_scene.alternativa3d::changedPrimitives[loc2] = true;
               }
               for(loc2 in param1.alternativa3d::backPrimitives)
               {
                  this.alternativa3d::_scene.alternativa3d::changedPrimitives[loc2] = true;
               }
            }
            this.changeNode(param1.alternativa3d::back);
            this.changeNode(param1.alternativa3d::front);
         }
      }
   }
}

