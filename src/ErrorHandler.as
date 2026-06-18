package
{
   import flash.display.DisplayObject;
   import mx.core.FlexGlobals;
   import mx.managers.PopUpManager;
   import mod.locale.Locale;
   import mod.locale.TextId;
   
   public class ErrorHandler
   {
      private static var windowMessage:String = "";
      
      private static var content:String = "";
      
      private static var window:ErrorWindow = new ErrorWindow();

      private static var _initialized:Boolean = false;
      
      public function ErrorHandler()
      {
         super();
      }
      
      public static function addText(param1:String) : void
      {
         content += param1 + "\r";
         updateContent();
      }
      
      public static function setMessage(param1:String) : void
      {
         windowMessage = param1;
         updateContent();
      }
      
      private static function updateContent() : void
      {
         if(window.text)
         {
            window.text.text = content;
            window.message.text = windowMessage;
         }
      }
      
      public static function clearMessages() : void
      {
         content = "";
      }
      
      public static function showWindow() : void
      {
         PopUpManager.addPopUp(window,DisplayObject(FlexGlobals.topLevelApplication));
         PopUpManager.centerPopUp(window);
         updateContent();
         if (!_initialized)
         {
            _initialized = true;
            Locale.addListener(applyLocalization);
         }
      }

      private static function applyLocalization() : void
      {
         window.title = Locale.getText(TextId.ERROR_PANEL_TITLE);
         window.okButton.label = Locale.getText(TextId.ALERT_BUTTON_OK);
      }
   }
}

