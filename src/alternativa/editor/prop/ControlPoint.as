package alternativa.editor.prop
{
   import alternativa.editor.events.DominationSpawnLinkEndEvent;
   import alternativa.editor.scene.EditorScene;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.MouseEvent3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class ControlPoint extends Prop
   {
      public var controlPointName:String;

      public var spawnPoints:Dictionary;
      
      public function ControlPoint(param1:Object3D, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         this.spawnPoints = new Dictionary();
         super(param1,param2,param3,param4,param5);
         type = Prop.DOMINATION_CONTROL_POINT;
      }
      
      public function addSpawnPoint(param1:SpawnPoint) : void
      {
         this.spawnPoints[param1] = true;
         param1.data = this;
      }
      
      public function removeSpawnPoint(param1:SpawnPoint) : void
      {
         if(this.spawnPoints[param1] != null)
         {
            delete this.spawnPoints[param1];
            param1.data = null;
         }
      }
      
      public function getSpawnPoints() : Vector.<SpawnPoint>
      {
         var loc2:* = undefined;
         var loc1:Vector.<SpawnPoint> = new Vector.<SpawnPoint>();
         for(loc2 in this.spawnPoints)
         {
            loc1.push(loc2);
         }
         return loc1;
      }
      
      public function unlinkSpawnPoints() : void
      {
         var loc1:* = undefined;
         for(loc1 in this.spawnPoints)
         {
            this.removeSpawnPoint(loc1);
         }
      }
      
      override public function calculate() : void
      {
         distancesX = new Point(-EditorScene.hBase,EditorScene.hBase);
         distancesY = new Point(-EditorScene.hBase,EditorScene.hBase);
         distancesZ = new Point(0,EditorScene.vBase);
         height = -1;
      }
      
      override public function clone() : Object3D
      {
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.setMaterialToAllFaces(_material as TextureMaterial);
         var loc2:ControlPoint = new ControlPoint(loc1,name,_libraryName,_groupName,false);
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
         addEventListener(MouseEvent3D.CLICK,this.onMouseClick);
      }
      
      private function onMouseClick(param1:MouseEvent3D) : void
      {
         if(param1.ctrlKey)
         {
            GlobalEventDispatcher.dispatch(new DominationSpawnLinkEndEvent(this));
         }
      }
   }
}

