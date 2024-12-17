package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.errors.SplitterNeedMoreVerticesError;
   import alternativa.types.Matrix3D;
   import alternativa.types.Point3D;
   
   use namespace alternativa3d;
   
   public class Splitter
   {
      private static var counter:uint = 0;
      
      alternativa3d var changeStateOperation:Operation;
      
      alternativa3d var updatePrimitiveOperation:Operation;
      
      alternativa3d var _open:Boolean = true;
      
      alternativa3d var primitive:SplitterPrimitive;
      
      alternativa3d var normal:Point3D;
      
      alternativa3d var offset:Number;
      
      alternativa3d var _scene:Scene3D;
      
      public var name:String;
      
      public function Splitter(param1:Array, param2:String = null)
      {
         this.alternativa3d::changeStateOperation = new Operation("changeSplitterState",this,this.changeState,Operation.alternativa3d::SPLITTER_CHANGE_STATE);
         this.alternativa3d::updatePrimitiveOperation = new Operation("updateSplitter",this,this.updatePrimitive,Operation.alternativa3d::SPLITTER_UPDATE);
         this.alternativa3d::normal = new Point3D();
         super();
         var loc3:int = int(param1.length);
         if(loc3 < 3)
         {
            throw new SplitterNeedMoreVerticesError(loc3);
         }
         this.alternativa3d::primitive = SplitterPrimitive.alternativa3d::create();
         this.alternativa3d::primitive.mobility = int.MIN_VALUE;
         this.alternativa3d::primitive.alternativa3d::splitter = this;
         var loc4:int = 0;
         while(loc4 < loc3)
         {
            this.alternativa3d::primitive.alternativa3d::points[loc4] = Point3D(param1[loc4]).clone();
            loc4++;
         }
         this.alternativa3d::primitive.alternativa3d::num = loc3;
         this.calculatePlane();
         this.name = param2 != null ? param2 : "splitter" + ++counter;
      }
      
      public static function createFromFace(param1:Face, param2:String = null) : Splitter
      {
         var loc5:int = 0;
         var loc6:Matrix3D = null;
         var loc7:Point3D = null;
         var loc3:Array = param1.alternativa3d::_vertices;
         var loc4:Array = new Array();
         if(param1.alternativa3d::_mesh != null && param1.alternativa3d::_mesh.alternativa3d::_scene != null)
         {
            loc6 = Object3D.alternativa3d::matrix2;
            param1.alternativa3d::_mesh.alternativa3d::getTransformation(loc6);
            loc5 = 0;
            while(loc5 < param1.alternativa3d::_verticesCount)
            {
               loc7 = Vertex(loc3[loc5]).alternativa3d::_coords.clone();
               loc7.transform(loc6);
               loc4[loc5] = loc7;
               loc5++;
            }
         }
         else
         {
            loc5 = 0;
            while(loc5 < param1.alternativa3d::_verticesCount)
            {
               loc4[loc5] = Vertex(loc3[loc5]).alternativa3d::_coords;
               loc5++;
            }
         }
         return new Splitter(loc4,param2);
      }
      
      public function get vertices() : Array
      {
         var loc1:Array = new Array().concat(this.alternativa3d::primitive.alternativa3d::points);
         var loc2:int = 0;
         while(loc2 < this.alternativa3d::primitive.alternativa3d::num)
         {
            loc1[loc2] = Point3D(loc1[loc2]).clone();
            loc2++;
         }
         return loc1;
      }
      
      public function get open() : Boolean
      {
         return this.alternativa3d::_open;
      }
      
      public function set open(param1:Boolean) : void
      {
         if(this.alternativa3d::_open != param1)
         {
            this.alternativa3d::_open = param1;
            if(this.alternativa3d::_scene != null)
            {
               this.alternativa3d::_scene.alternativa3d::addOperation(this.alternativa3d::changeStateOperation);
            }
         }
      }
      
      public function toString() : String
      {
         return "[Splitter " + this.name + (this.alternativa3d::_open ? " open]" : " closed]");
      }
      
      alternativa3d function addToScene(param1:Scene3D) : void
      {
         this.alternativa3d::_scene = param1;
         this.alternativa3d::changeStateOperation.alternativa3d::addSequel(this.alternativa3d::_scene.alternativa3d::changePrimitivesOperation);
         this.alternativa3d::_scene.alternativa3d::updateBSPOperation.alternativa3d::addSequel(this.alternativa3d::updatePrimitiveOperation);
      }
      
      alternativa3d function removeFromScene(param1:Scene3D) : void
      {
         this.alternativa3d::changeStateOperation.alternativa3d::removeSequel(param1.alternativa3d::changePrimitivesOperation);
         param1.alternativa3d::updateBSPOperation.alternativa3d::removeSequel(this.alternativa3d::updatePrimitiveOperation);
         param1.alternativa3d::removeOperation(this.alternativa3d::changeStateOperation);
         this.removePrimitive(this.alternativa3d::primitive);
         this.alternativa3d::_scene = null;
      }
      
      private function calculatePlane() : void
      {
         var loc1:Point3D = this.alternativa3d::primitive.alternativa3d::points[0];
         var loc2:Point3D = this.alternativa3d::primitive.alternativa3d::points[1];
         var loc3:Number = loc2.x - loc1.x;
         var loc4:Number = loc2.y - loc1.y;
         var loc5:Number = loc2.z - loc1.z;
         var loc6:Point3D = this.alternativa3d::primitive.alternativa3d::points[2];
         var loc7:Number = loc6.x - loc1.x;
         var loc8:Number = loc6.y - loc1.y;
         var loc9:Number = loc6.z - loc1.z;
         this.alternativa3d::normal.x = loc9 * loc4 - loc8 * loc5;
         this.alternativa3d::normal.y = loc7 * loc5 - loc9 * loc3;
         this.alternativa3d::normal.z = loc8 * loc3 - loc7 * loc4;
         this.alternativa3d::normal.normalize();
         this.alternativa3d::offset = loc1.x * this.alternativa3d::normal.x + loc1.y * this.alternativa3d::normal.y + loc1.z * this.alternativa3d::normal.z;
      }
      
      private function updatePrimitive() : void
      {
         this.removePrimitive(this.alternativa3d::primitive);
      }
      
      private function changeState() : void
      {
         this.changePrimitiveNode(this.alternativa3d::primitive);
      }
      
      private function changePrimitiveNode(param1:PolyPrimitive) : void
      {
         if(param1.alternativa3d::backFragment == null)
         {
            this.changePrimitivesInNode(param1.alternativa3d::node.alternativa3d::back);
            this.changePrimitivesInNode(param1.alternativa3d::node.alternativa3d::front);
         }
         else
         {
            this.changePrimitiveNode(param1.alternativa3d::backFragment);
            this.changePrimitiveNode(param1.alternativa3d::frontFragment);
         }
      }
      
      private function changePrimitivesInNode(param1:BSPNode) : void
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
            this.changePrimitivesInNode(param1.alternativa3d::back);
            this.changePrimitivesInNode(param1.alternativa3d::front);
         }
      }
      
      private function removePrimitive(param1:PolyPrimitive) : void
      {
         if(param1.alternativa3d::backFragment != null)
         {
            this.removePrimitive(param1.alternativa3d::backFragment);
            this.removePrimitive(param1.alternativa3d::frontFragment);
            param1.alternativa3d::backFragment = null;
            param1.alternativa3d::frontFragment = null;
         }
         else if(param1.alternativa3d::node != null)
         {
            param1.alternativa3d::node.alternativa3d::splitter = null;
            this.alternativa3d::_scene.alternativa3d::removeBSPPrimitive(param1);
         }
         if(param1 != this.alternativa3d::primitive)
         {
            param1.alternativa3d::parent = null;
            param1.alternativa3d::sibling = null;
            SplitterPrimitive.alternativa3d::destroy(param1 as SplitterPrimitive);
         }
      }
   }
}

