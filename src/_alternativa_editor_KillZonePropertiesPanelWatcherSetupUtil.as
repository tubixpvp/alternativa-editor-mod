package
{
   import alternativa.editor.KillZonePropertiesPanel;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   
   public class _alternativa_editor_KillZonePropertiesPanelWatcherSetupUtil implements IWatcherSetupUtil2
   {
      public function _alternativa_editor_KillZonePropertiesPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         KillZonePropertiesPanel.watcherSetupUtil = new _alternativa_editor_KillZonePropertiesPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

