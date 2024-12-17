package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.materials.SpriteMaterial;
   
   use namespace alternativa3d;
   
   public class Sprite3D extends Object3D
   {
      private static var counter:uint = 0;
      
      alternativa3d var updateMaterialOperation:Operation;
      
      alternativa3d var primitive:SpritePrimitive;
      
      alternativa3d var _material:SpriteMaterial;
      
      alternativa3d var _materialScale:Number;
      
      public function Sprite3D(param1:String = null)
      {
         this.alternativa3d::updateMaterialOperation = new Operation("updateSpriteMaterial",this,this.updateMaterial,Operation.alternativa3d::SPRITE_UPDATE_MATERIAL);
         super(param1);
         this.alternativa3d::primitive = new SpritePrimitive();
         this.alternativa3d::primitive.alternativa3d::sprite = this;
         this.alternativa3d::primitive.alternativa3d::points = [this.alternativa3d::globalCoords];
         this.alternativa3d::primitive.alternativa3d::num = 1;
         this.alternativa3d::primitive.mobility = int.MAX_VALUE;
      }
      
      override alternativa3d function calculateTransformation() : void
      {
         var loc1:Number = NaN;
         var loc2:Number = NaN;
         var loc3:Number = NaN;
         var loc4:Number = NaN;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Number = NaN;
         var loc9:Number = NaN;
         super.alternativa3d::calculateTransformation();
         this.updatePrimitive();
         if(alternativa3d::changeRotationOrScaleOperation.alternativa3d::queued)
         {
            loc1 = Number(alternativa3d::_transformation.a);
            loc2 = Number(alternativa3d::_transformation.b);
            loc3 = Number(alternativa3d::_transformation.c);
            loc4 = Number(alternativa3d::_transformation.e);
            loc5 = Number(alternativa3d::_transformation.f);
            loc6 = Number(alternativa3d::_transformation.g);
            loc7 = Number(alternativa3d::_transformation.i);
            loc8 = Number(alternativa3d::_transformation.j);
            loc9 = Number(alternativa3d::_transformation.k);
            this.alternativa3d::_materialScale = (Math.sqrt(loc1 * loc1 + loc4 * loc4 + loc7 * loc7) + Math.sqrt(loc2 * loc2 + loc5 * loc5 + loc8 * loc8) + Math.sqrt(loc3 * loc3 + loc6 * loc6 + loc9 * loc9)) / 3;
         }
      }
      
      private function updatePrimitive() : void
      {
         if(this.alternativa3d::primitive.alternativa3d::node != null)
         {
            alternativa3d::_scene.alternativa3d::removeBSPPrimitive(this.alternativa3d::primitive);
         }
         alternativa3d::_scene.alternativa3d::addPrimitives.push(this.alternativa3d::primitive);
      }
      
      private function updateMaterial() : void
      {
         if(!alternativa3d::calculateTransformationOperation.alternativa3d::queued)
         {
            alternativa3d::_scene.alternativa3d::changedPrimitives[this.alternativa3d::primitive] = true;
         }
      }
      
      override protected function addToScene(param1:Scene3D) : void
      {
         super.addToScene(param1);
         alternativa3d::calculateTransformationOperation.alternativa3d::addSequel(param1.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updateMaterialOperation.alternativa3d::addSequel(param1.alternativa3d::changePrimitivesOperation);
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::addToScene(param1);
         }
      }
      
      override protected function removeFromScene(param1:Scene3D) : void
      {
         param1.alternativa3d::removeOperation(this.alternativa3d::updateMaterialOperation);
         if(this.alternativa3d::primitive.alternativa3d::node != null)
         {
            param1.alternativa3d::removeBSPPrimitive(this.alternativa3d::primitive);
         }
         param1.alternativa3d::addOperation(param1.alternativa3d::calculateBSPOperation);
         alternativa3d::calculateTransformationOperation.alternativa3d::removeSequel(param1.alternativa3d::calculateBSPOperation);
         this.alternativa3d::updateMaterialOperation.alternativa3d::removeSequel(param1.alternativa3d::changePrimitivesOperation);
         if(this.alternativa3d::_material != null)
         {
            this.alternativa3d::_material.alternativa3d::removeFromScene(param1);
         }
         super.removeFromScene(param1);
      }
      
      alternativa3d function addMaterialChangedOperationToScene() : void
      {
         if(alternativa3d::_scene != null)
         {
            alternativa3d::_scene.alternativa3d::addOperation(this.alternativa3d::updateMaterialOperation);
         }
      }
      
      public function get material() : SpriteMaterial
      {
         return this.alternativa3d::_material;
      }
      
      public function set material(param1:SpriteMaterial) : void
      {
         if(this.alternativa3d::_material != param1)
         {
            if(this.alternativa3d::_material != null)
            {
               this.alternativa3d::_material.alternativa3d::removeFromSprite(this);
               if(alternativa3d::_scene != null)
               {
                  this.alternativa3d::_material.alternativa3d::removeFromScene(alternativa3d::_scene);
               }
            }
            if(param1 != null)
            {
               if(param1.alternativa3d::_sprite != null)
               {
                  param1.alternativa3d::_sprite.material = null;
               }
               param1.alternativa3d::addToSprite(this);
               if(alternativa3d::_scene != null)
               {
                  param1.alternativa3d::addToScene(alternativa3d::_scene);
               }
            }
            this.alternativa3d::_material = param1;
            this.alternativa3d::addMaterialChangedOperationToScene();
         }
      }
      
      override protected function defaultName() : String
      {
         return "sprite" + ++counter;
      }
      
      override protected function createEmptyObject() : Object3D
      {
         return new Sprite3D();
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         this.material = (param1 as Sprite3D).material.clone() as SpriteMaterial;
      }
   }
}

