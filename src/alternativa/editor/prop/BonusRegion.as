package alternativa.editor.prop
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.types.Set;
   
   public class BonusRegion extends Prop
   {
      private var _typeNames:Set;
      
      private var _gameModes:Set;
      
      public function BonusRegion(param1:Object3D, param2:String, param3:String, param4:String, param5:Boolean = true)
      {
         this._typeNames = new Set();
         this._gameModes = new Set();
         super(param1,param2,param3,param4,param5);
         this._typeNames.add(BonusTypes.types[0]);
         this._gameModes.add(GameModes.modes[0]);
         this._gameModes.add(GameModes.modes[1]);
         this._gameModes.add(GameModes.modes[2]);
         this._gameModes.add(GameModes.modes[3]);
      }
      
      public function get typeNames() : Set
      {
         return this._typeNames;
      }
      
      public function get gameModes() : Set
      {
         return this._gameModes;
      }
      
      override public function clone() : Object3D
      {
         var loc2:BonusRegion = null;
         var loc1:Mesh = _object.clone() as Mesh;
         loc1.cloneMaterialToAllSurfaces(_material as TextureMaterial);
         loc2 = new BonusRegion(loc1,name,_libraryName,_groupName,false);
         loc2.distancesX = distancesX.clone();
         loc2.distancesY = distancesY.clone();
         loc2.distancesZ = distancesZ.clone();
         loc2._multi = _multi;
         loc2.name = name;
         loc2._typeNames = this._typeNames.clone();
         loc2._gameModes = this._gameModes.clone();
         loc2.height = height;
         return loc2;
      }
   }
}

