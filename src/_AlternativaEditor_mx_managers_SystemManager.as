package
{
   import flash.display.LoaderInfo;
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.ISWFContext;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.events.RSLEvent;
   import mx.managers.SystemManager;
   import mx.preloaders.SparkDownloadProgressBar;
   
   public class _AlternativaEditor_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory, ISWFContext
   {
      private var _info:Object;
      
      private var _preloadedRSLs:Dictionary;
      
      private var _allowDomainParameters:Vector.<Array>;
      
      private var _allowInsecureDomainParameters:Vector.<Array>;
      
      public function _AlternativaEditor_mx_managers_SystemManager()
      {
         super();
      }
      
      override public function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *
      {
         if(param4)
         {
            return param1.apply(param2,param3);
         }
         param1.apply(param2,param3);
      }
      
      override public function create(... rest) : Object
      {
         if(rest.length > 0 && !(rest[0] is String))
         {
            return super.create.apply(this,rest);
         }
         var loc2:String = rest.length == 0 ? "AlternativaEditor" : String(rest[0]);
         var loc3:Class = Class(getDefinitionByName(loc2));
         if(!loc3)
         {
            return null;
         }
         var loc4:Object = new loc3();
         if(loc4 is IFlexModule)
         {
            IFlexModule(loc4).moduleFactory = this;
         }
         return loc4;
      }
      
      override public function info() : Object
      {
         if(!this._info)
         {
            this._info = {
               "applicationComplete":"onApplicationComplete();",
               "compiledLocales":["en_US"],
               "compiledResourceBundleNames":["collections","components","containers","controls","core","effects","layout","skins","sparkEffects","styles","textLayout"],
               "currentDomain":ApplicationDomain.currentDomain,
               "layout":"absolute",
               "mainClassName":"AlternativaEditor",
               "mixins":["_AlternativaEditor_FlexInit","_AlternativaEditor_Styles","mx.managers.systemClasses.ActiveWindowManager","mx.messaging.config.LoaderConfig"],
               "preloader":SparkDownloadProgressBar
            };
         }
         return this._info;
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... rest) : void
      {
         var loc2:Object = null;
         Security.allowDomain.apply(null,rest);
         for(loc2 in this._preloadedRSLs)
         {
            if(Boolean(loc2.content) && "allowDomainInRSL" in loc2.content)
            {
               loc2.content["allowDomainInRSL"].apply(null,rest);
            }
         }
         if(!this._allowDomainParameters)
         {
            this._allowDomainParameters = new Vector.<Array>();
         }
         this._allowDomainParameters.push(rest);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      override public function allowInsecureDomain(... rest) : void
      {
         var loc2:Object = null;
         Security.allowInsecureDomain.apply(null,rest);
         for(loc2 in this._preloadedRSLs)
         {
            if(Boolean(loc2.content) && "allowInsecureDomainInRSL" in loc2.content)
            {
               loc2.content["allowInsecureDomainInRSL"].apply(null,rest);
            }
         }
         if(!this._allowInsecureDomainParameters)
         {
            this._allowInsecureDomainParameters = new Vector.<Array>();
         }
         this._allowInsecureDomainParameters.push(rest);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      private function addPreloadedRSLHandler(param1:RSLEvent) : void
      {
         var loc3:Array = null;
         var loc2:LoaderInfo = param1.loaderInfo;
         if(!loc2 || !loc2.content)
         {
            return;
         }
         if(allowDomainsInNewRSLs && Boolean(this._allowDomainParameters))
         {
            for each(loc3 in this._allowDomainParameters)
            {
               if("allowDomainInRSL" in loc2.content)
               {
                  loc2.content["allowDomainInRSL"].apply(null,loc3);
               }
            }
         }
         if(allowInsecureDomainsInNewRSLs && Boolean(this._allowInsecureDomainParameters))
         {
            for each(loc3 in this._allowInsecureDomainParameters)
            {
               if("allowInsecureDomainInRSL" in loc2.content)
               {
                  loc2.content["allowInsecureDomainInRSL"].apply(null,loc3);
               }
            }
         }
      }
   }
}

