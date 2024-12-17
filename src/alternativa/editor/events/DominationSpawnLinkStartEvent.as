package alternativa.editor.events
{
   import alternativa.editor.prop.SpawnPoint;
   import flash.events.Event;
   
   public class DominationSpawnLinkStartEvent extends Event
   {
      public static const DOMINATION_SPAWN_LINK_START:String = "dominationSpawnLinkStart";
      
      public var spawnPoint:SpawnPoint;
      
      public function DominationSpawnLinkStartEvent(param1:SpawnPoint)
      {
         super(DOMINATION_SPAWN_LINK_START);
         this.spawnPoint = param1;
      }
      
      override public function clone() : Event
      {
         return new DominationSpawnLinkStartEvent(this.spawnPoint);
      }
   }
}

