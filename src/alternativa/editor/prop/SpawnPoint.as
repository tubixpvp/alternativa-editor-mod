package alternativa.editor.prop
{
   import alternativa.editor.FunctionalProps;
   import alternativa.editor.events.DominationSpawnLinkStartEvent;
   import alternativa.editor.scene.EditorScene;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.MouseEvent3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.utils.MathUtils;
   import flash.geom.Point;
   
   public class SpawnPoint extends Prop
   {
      public function SpawnPoint(param1:Object3D, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
         type = Prop.SPAWN;
      }
      
      override public function calculate() : void
      {
         distancesX = new Point(-EditorScene.hBase,EditorScene.hBase);
         distancesY = new Point(-EditorScene.hBase,EditorScene.hBase);
         distancesZ = new Point(0,EditorScene.vBase);
         height = -1;
      }
      
      override public function rotateCounterClockwise() : void
      {
         rotationZ += MathUtils.DEG5;
      }
      
      override public function rotateClockwise() : void
      {
         rotationZ -= MathUtils.DEG5;
      }
      
      override public function clone() : Object3D
      {
         var loc2:SpawnPoint = null;
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.setMaterialToAllFaces(_material as TextureMaterial);
         loc2 = new SpawnPoint(loc1,name,_libraryName,_groupName,false);
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2._multi = _multi;
         loc2.name = name;
         loc2.height = height;
         return loc2;
      }
      
      override public function onAddedToScene() : void
      {
         if(_groupName == FunctionalProps.GRP_DOMINATION)
         {
            addEventListener(MouseEvent3D.CLICK,this.onMouseClick);
         }
      }
      
      private function onMouseClick(param1:MouseEvent3D) : void
      {
         if(param1.ctrlKey && name == FunctionalProps.DOMINATION_SPAWN)
         {
            GlobalEventDispatcher.dispatch(new DominationSpawnLinkStartEvent(this));
         }
      }
   }
}

