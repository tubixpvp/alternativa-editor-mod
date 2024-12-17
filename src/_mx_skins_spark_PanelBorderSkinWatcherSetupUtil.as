package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.skins.spark.PanelBorderSkin;
   
   public class _mx_skins_spark_PanelBorderSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      public function _mx_skins_spark_PanelBorderSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PanelBorderSkin.watcherSetupUtil = new _mx_skins_spark_PanelBorderSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("contentMask",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}

