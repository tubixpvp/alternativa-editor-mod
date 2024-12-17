package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _AlternativaEditorWatcherSetupUtil implements IWatcherSetupUtil2
   {
      public function _AlternativaEditorWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AlternativaEditor.watcherSetupUtil = new _AlternativaEditorWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("menuData",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}

