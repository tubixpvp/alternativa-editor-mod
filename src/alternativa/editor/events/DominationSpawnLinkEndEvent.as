package alternativa.editor.events
{
   import alternativa.editor.prop.ControlPoint;
   import flash.events.Event;
   
   public class DominationSpawnLinkEndEvent extends Event
   {
      public static const DOMINATION_SPAWN_LINK_END:String = "dominationSpawnLinkEnd";
      
      public var checkPoint:ControlPoint;
      
      public function DominationSpawnLinkEndEvent(param1:ControlPoint)
      {
         super(DOMINATION_SPAWN_LINK_END);
         this.checkPoint = param1;
      }
      
      override public function clone() : Event
      {
         return new DominationSpawnLinkEndEvent(this.checkPoint);
      }
   }
}

