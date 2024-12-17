package alternativa.editor.events
{
   import flash.events.Event;
   
   public class LayerVisibilityChangeEvent extends Event
   {
      public static const VISIBILITY_CHANGED:String = "visibilityChanged";
      
      public var layerName:String;
      
      public var visible:Boolean;
      
      public function LayerVisibilityChangeEvent(param1:String, param2:Boolean)
      {
         super(VISIBILITY_CHANGED,false,true);
         this.layerName = param1;
         this.visible = param2;
      }
      
      override public function clone() : Event
      {
         return new LayerVisibilityChangeEvent(this.layerName,this.visible);
      }
   }
}

