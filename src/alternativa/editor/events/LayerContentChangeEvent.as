package alternativa.editor.events
{
   import alternativa.editor.prop.Prop;
   import flash.events.Event;
   
   public class LayerContentChangeEvent extends Event
   {
      public static const LAYER_CONTENT_CHANGED:String = "LAYER_CONTENT_CHANGED";
      
      public var prop:Prop;
      
      public var layerName:String;
      
      public var layerContainsProp:Boolean;
      
      public function LayerContentChangeEvent(param1:Prop, param2:String, param3:Boolean)
      {
         this.prop = param1;
         this.layerName = param2;
         this.layerContainsProp = param3;
         super(LAYER_CONTENT_CHANGED,false,true);
      }
   }
}

