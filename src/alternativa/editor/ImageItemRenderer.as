package alternativa.editor
{
   import mx.containers.VBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.ScrollPolicy;
   import mx.events.FlexEvent;
   
   public class ImageItemRenderer extends VBox
   {
      private var img:Image;
      
      private var lbl:Label;
      
      public function ImageItemRenderer()
      {
         this.img = new Image();
         this.lbl = new Label();
         super();
         this.width = 52;
         this.height = 82;
         setStyle("horizontalAlign","center");
         setStyle("verticalGap","0");
         addChild(this.img);
         addChild(this.lbl);
         this.img.height = 50;
         this.img.width = 50;
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         updateDisplayList(52,82);
         addEventListener(FlexEvent.DATA_CHANGE,this.dataChangeHandler);
      }
      
      private function dataChangeHandler(param1:FlexEvent) : void
      {
         this.img.source = data["image"];
         this.lbl.text = data["label"];
      }
   }
}

