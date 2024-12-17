package alternativa.editor
{
   import alternativa.editor.events.LayerVisibilityChangeEvent;
   import flash.events.Event;
   import mx.controls.CheckBox;
   import mx.events.FlexEvent;
   
   public class LayersWindow extends LayersWindowBase
   {
      public function LayersWindow()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      private static function onChange(param1:Event) : void
      {
         var loc2:CheckBox = CheckBox(param1.target);
         GlobalEventDispatcher.dispatch(new LayerVisibilityChangeEvent(loc2.data.toString(),loc2.selected));
      }
      
      private function onCreationComplete(param1:FlexEvent) : void
      {
         this.addLayerCheckBox(LayerNames.DM,"DM");
         this.addLayerCheckBox(LayerNames.TDM,"TDM");
         this.addLayerCheckBox(LayerNames.CTF,"CTF");
         this.addLayerCheckBox(LayerNames.DOMINATION,"Domination");
         this.addLayerCheckBox(LayerNames.BONUSES,"Bonuses");
         this.addLayerCheckBox(LayerNames.SPECIAL_GEOMETRY,"Special geometry");
      }
      
      private function addLayerCheckBox(param1:String, param2:String) : void
      {
         var loc3:CheckBox = new CheckBox();
         loc3.label = param2;
         loc3.data = param1;
         loc3.selected = true;
         loc3.addEventListener(Event.CHANGE,onChange);
         mainBox.addChild(loc3);
      }
   }
}

