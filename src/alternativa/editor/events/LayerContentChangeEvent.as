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
      
      public function LayerContentChangeEvent(prop:Prop, layerName:String, layerContainsProp:Boolean)
      {
         this.prop = prop;
         this.layerName = layerName;
         this.layerContainsProp = layerContainsProp;
         super(LAYER_CONTENT_CHANGED,false,true);
      }
   }
}

