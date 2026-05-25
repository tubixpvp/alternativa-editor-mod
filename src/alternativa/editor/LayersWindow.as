package alternativa.editor
{
   import alternativa.editor.events.LayerVisibilityChangeEvent;
   import flash.events.Event;
   import mx.controls.CheckBox;
   import mx.events.FlexEvent;
   import mod.locale.Locale;
   import mod.locale.TextId;
   
   public class LayersWindow extends LayersWindowBase
   {

      private const layerToCheckbox:Object = new Object();

      
      public function LayersWindow()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }

      private function applyLocalization() : void
      {
         title = Locale.getText(TextId.LAYERS_PANEL_TITLE);

         for(var layer:String in layerToCheckbox)
         {
            (layerToCheckbox[layer] as CheckBox).label = Locale.getText("LAYER_" + layer.toUpperCase());
         }
      }
      
      private static function onChange(param1:Event) : void
      {
         var loc2:CheckBox = CheckBox(param1.target);
         GlobalEventDispatcher.dispatch(new LayerVisibilityChangeEvent(loc2.data.toString(),loc2.selected));
      }
      
      private function onCreationComplete(param1:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);

         this.addLayerCheckBox(LayerNames.DM);
         this.addLayerCheckBox(LayerNames.TDM);
         //this.addLayerCheckBox(LayerNames.CTF);
         this.addLayerCheckBox(LayerNames.DOMINATION);
         this.addLayerCheckBox(LayerNames.BONUSES);
         this.addLayerCheckBox(LayerNames.SPECIAL_GEOMETRY);

         Locale.addListener(applyLocalization);
      }
      
      private function addLayerCheckBox(layer:String) : void
      {
         var loc3:CheckBox = new CheckBox();
         loc3.data = layer;
         loc3.selected = true;
         loc3.addEventListener(Event.CHANGE,onChange);
         mainBox.addChild(loc3);
         layerToCheckbox[layer] = loc3;
      }
   }
}

