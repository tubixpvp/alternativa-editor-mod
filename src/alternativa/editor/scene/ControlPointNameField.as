package alternativa.editor.scene
{
   import alternativa.editor.prop.ControlPoint;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import mx.controls.TextInput;
   
   public class ControlPointNameField extends TextInput
   {
      public function ControlPointNameField()
      {
         super();
         maxChars = 1;
         restrict = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
         width = 50;
         addEventListener(KeyboardEvent.KEY_DOWN,onKey);
         addEventListener(KeyboardEvent.KEY_UP,onKey);
      }
      
      private static function onKey(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function setControlPoint(param1:ControlPoint) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError();
         }
         this.data = param1;
         this.disableChangeListener();
         text = param1.controlPointName;
         this.enableChangeListener();
      }
      
      public function clearControlPoint() : void
      {
         this.disableChangeListener();
         text = "";
         data = null;
      }
      
      private function enableChangeListener() : void
      {
         addEventListener(Event.CHANGE,this.onChange);
      }
      
      private function disableChangeListener() : void
      {
         removeEventListener(Event.CHANGE,this.onChange);
      }
      
      private function onChange(param1:Event) : void
      {
         ControlPoint(data).controlPointName = text;
      }
   }
}

