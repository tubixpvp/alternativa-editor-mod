package mod.locale
{
    import flash.net.SharedObject;
    import mx.controls.Alert;
    import flash.display.NativeMenuItem;
    import flash.display.NativeMenu;
    import flash.events.Event;

    public class Locale
    {

        [Embed(source="localization.json", mimeType="application/octet-stream")]
        private static const LOCALIZATION_JSON_Class:Class;

    
        private static const LAST_LANGUAGE_KEY:String = "lang";


        private static const _existingLanguages:Vector.<String> = new Vector.<String>();

        private static const _langToTexts:Object = new Object();

        private static var _defaultLanguage:String = "";


        private static const _languageMenuItems:Vector.<NativeMenuItem> = new Vector.<NativeMenuItem>();


        private static const _changeListeners:Vector.<Function> = new Vector.<Function>();


        private static var _currentLocaleId:String = null;

        private static var _storage:SharedObject = null;


        private static var _initialLoadComplete:Boolean = false;


        public static function getText(id:String) : String
        {
            var texts:Object = _langToTexts[_currentLocaleId];

            var text:String = texts[id];
            if (text == null)
                return id;

            return text;
        }


        public static function init(storage:SharedObject, languagesMenu:NativeMenuItem) : void
        {
            _storage = storage;

            var jsonText:String = (new LOCALIZATION_JSON_Class()).toString();

            var jsonObj:Object = JSON.parse(jsonText);

            
            _defaultLanguage = jsonObj["_default"];

            var menu:NativeMenu = languagesMenu.submenu;
            if (menu == null)
            {
                menu = languagesMenu.submenu = new NativeMenu();
            }

            var previousLang:String = _storage.data[LAST_LANGUAGE_KEY];
            if (previousLang == null)
            {
                previousLang = _defaultLanguage;
            }

            for (var langId:String in jsonObj)
            {
                if (langId == "_default")
                    continue;
                _langToTexts[langId] = jsonObj[langId];
                
                var menuItem:NativeMenuItem = new NativeMenuItem(langId);

                menu.addItem(menuItem);

                menuItem.checked = (langId == previousLang);
                menuItem.addEventListener(Event.SELECT, onLanguageItemClicked);

                _languageMenuItems.push(menuItem);
            }

            _initialLoadComplete = true;

            setLocale(previousLang);
        }

        private static function onLanguageItemClicked(e:Event) : void
        {
            var item:NativeMenuItem = (e.target as NativeMenuItem);

            for each(var otherItem:NativeMenuItem in _languageMenuItems)
            {
                otherItem.checked = (otherItem == item);
            }

            setLocale(item.label);
        }

        public static function setLocale(localeId:String) : void
        {
            if (_currentLocaleId == localeId)
                return;

            if (_langToTexts[localeId] == null)
            {
                Alert.show("ERROR: Locale does not exist: " + localeId);
                return;
            }

            if (_storage != null)
            {
                _storage.data[LAST_LANGUAGE_KEY] = localeId;
            }

            _currentLocaleId = localeId;

            for each(var listener:Function in _changeListeners)
            {
                try 
                {
                    listener();
                } 
                catch(e:Error)
                {
                    Alert.show("ERROR: " + e);
                }
            }
        }

        public static function getLocaleId() : String
        {
            return _currentLocaleId;
        }

        public static function addListener(func:Function) : void
        {
            _changeListeners.push(func);

            if (_initialLoadComplete)
            {
                func();
            }
        }

    }
}