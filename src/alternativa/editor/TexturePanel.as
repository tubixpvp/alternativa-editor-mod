package alternativa.editor
{
   import alternativa.types.Map;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import gui.events.PropListEvent;
   import mx.containers.HBox;
   import mx.containers.Panel;
   import mx.controls.Image;
   import mx.controls.TileList;
   import mx.core.ClassFactory;
   import mx.events.ListEvent;
   
   public class TexturePanel extends Panel
   {
      public var selectedItem:* = null;
      
      private var dataProvider:Array;
      
      private var list:TileList;
      
      private var texturePreview:Image;
      
      public function TexturePanel()
      {
         this.list = new TileList();
         this.texturePreview = new Image();
         super();
         percentWidth = 100;
         percentHeight = 100;
         this.title = "Textures";
         var loc1:HBox = new HBox();
         addChild(loc1);
         loc1.addChild(this.list);
         loc1.addChild(this.texturePreview);
         loc1.percentHeight = loc1.percentWidth = 100;
         loc1.setStyle("verticalAlign","middle");
         this.texturePreview.width = this.texturePreview.height = 100;
         this.list.percentWidth = 100;
         this.list.height = 80;
         this.list.setStyle("verticalAlign","middle");
         this.dataProvider = new Array();
         this.list.dataProvider = this.dataProvider;
         this.list.rowHeight = 82;
         this.list.columnWidth = 52;
         this.list.itemRenderer = new ClassFactory(ImageItemRenderer);
         this.list.addEventListener(ListEvent.ITEM_CLICK,this.onSelect);
      }
      
      private function onSelect(param1:ListEvent) : void
      {
         this.texturePreview.source = param1.itemRenderer.data.pr;
         this.selectedItem = param1.itemRenderer.data.id;
         dispatchEvent(new PropListEvent(0,param1.itemRenderer.data.id));
      }
      
      public function fill(param1:Map) : void
      {
         var loc2:* = undefined;
         var loc3:BitmapData = null;
         var loc4:Bitmap = null;
         this.deleteAllProps();
         for(loc2 in param1)
         {
            loc3 = param1[loc2];
            loc4 = new Bitmap(loc3);
            this.addItem(loc2,loc4,loc2);
         }
         this.addTransparentTexture();
         this.selectedItem = null;
      }
      
      private function deleteAllProps() : void
      {
         this.dataProvider = new Array();
         this.list.dataProvider = this.dataProvider;
         this.texturePreview.source = null;
      }
      
      private function addItem(param1:Object, param2:Bitmap, param3:String) : void
      {
         var loc4:Sprite = new Sprite();
         var loc5:Sprite = new Sprite();
         loc4.addChild(param2);
         loc5.addChild(new Bitmap(param2.bitmapData));
         var loc6:Object = {
            "id":param1,
            "image":loc4,
            "label":param3,
            "pr":loc5
         };
         this.dataProvider.push(loc6);
         this.dataProvider.sortOn("label");
      }
      
      private function addTransparentTexture() : void
      {
         this.addItem(InvisibleTexture.TEXTURE_NAME,InvisibleTexture.invisibleTexture,InvisibleTexture.TEXTURE_NAME);
      }
   }
}

