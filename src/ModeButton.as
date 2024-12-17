package
{
   import flash.events.MouseEvent;
   import mx.binding.BindingManager;
   import mx.controls.Button;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   
   public class ModeButton extends Button
   {
      private var _1023233823downToolTip:String;
      
      private var _1427000520upToolTip:String;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _down:Boolean = false;
      
      public var downModeIcon:Class;
      
      public var upModeIcon:Class;
      
      public function ModeButton()
      {
         super();
         this._ModeButton_String2_i();
         this._ModeButton_String1_i();
         this.addEventListener("creationComplete",this.___ModeButton_Button1_creationComplete);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function get down() : Boolean
      {
         return this._down;
      }
      
      public function set down(param1:Boolean) : void
      {
         this._down = param1;
         this.update();
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         this.down = !this.down;
         super.clickHandler(param1);
      }
      
      private function update() : void
      {
         if(this._down)
         {
            setStyle("icon",this.downModeIcon);
            toolTip = this.downToolTip;
         }
         else
         {
            setStyle("icon",this.upModeIcon);
            toolTip = this.upToolTip;
         }
      }
      
      private function _ModeButton_String2_i() : String
      {
         this.downToolTip = "null";
         BindingManager.executeBindings(this,"downToolTip",this.downToolTip);
         return "null";
      }
      
      private function _ModeButton_String1_i() : String
      {
         this.upToolTip = "null";
         BindingManager.executeBindings(this,"upToolTip",this.upToolTip);
         return "null";
      }
      
      public function ___ModeButton_Button1_creationComplete(param1:FlexEvent) : void
      {
         this.update();
      }
      
      [Bindable(event="propertyChange")]
      public function get downToolTip() : String
      {
         return this._1023233823downToolTip;
      }
      
      public function set downToolTip(param1:String) : void
      {
         var loc2:Object = this._1023233823downToolTip;
         if(loc2 !== param1)
         {
            this._1023233823downToolTip = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"downToolTip",loc2,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get upToolTip() : String
      {
         return this._1427000520upToolTip;
      }
      
      public function set upToolTip(param1:String) : void
      {
         var loc2:Object = this._1427000520upToolTip;
         if(loc2 !== param1)
         {
            this._1427000520upToolTip = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"upToolTip",loc2,param1));
            }
         }
      }
   }
}

