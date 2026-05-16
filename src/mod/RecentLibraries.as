package mod
{
    import flash.net.SharedObject;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.display.NativeMenu;
    import alternativa.editor.LibraryManager;
    import mod.locale.Locale;
    import mod.locale.TextId;

    public class RecentLibraries
    {

        private static const recentDirsKey:String = "recentDirs";

        private static const maxItems:int = 3;


        private var _storage:SharedObject;

        private var _libraryManager:LibraryManager;

        private var _recentLibrariesMenu:NativeMenuItem;


        private var _recentLibraryDirectories:Array;


        private var _clearItem:NativeMenuItem;

        private var _separator:NativeMenuItem;


        public function RecentLibraries(storage:SharedObject, menu:NativeMenuItem, libraryManager:LibraryManager)
        {
            _storage = storage;
            _recentLibrariesMenu = menu;
            _libraryManager = libraryManager;

            if(menu.submenu == null)
            {
                menu.submenu = new NativeMenu();
            }
        }

        public function initRecentLibrariesList():void
        {
            var storedDirs:String = _storage.data[recentDirsKey];

            _recentLibraryDirectories = null;
            if (storedDirs != null)
            {
                _recentLibraryDirectories = JSON.parse(storedDirs).list as Array;
            }

            if (_recentLibraryDirectories == null)
                _recentLibraryDirectories = [];

            for each (var directory:String in _recentLibraryDirectories)
            {
                _recentLibrariesMenu.submenu.addItem(createRecentDirectoryMenuItem(directory));
            }

            _separator = _recentLibrariesMenu.submenu.addItem(new NativeMenuItem("", true));
            _clearItem = _recentLibrariesMenu.submenu.addItem(new NativeMenuItem(""));

            _clearItem.addEventListener(Event.SELECT, onClearClicked);

            Locale.addListener(applyLocalization);
        }

        private function applyLocalization() : void
        {
            _clearItem.label = Locale.getText(TextId.MENUITEM_LIBRARY_RECENT_CLEAR);
        }

        private function onClearClicked(e:Event):void
        {
            _recentLibraryDirectories.length = 0;

            var numItems:int = _recentLibrariesMenu.submenu.numItems;
            for (var i:int = 0; i < numItems - 2; i++)
            {
                _recentLibrariesMenu.submenu.getItemAt(i).removeEventListener(Event.SELECT, onRecentLibraryLoadClicked);
            }
            _recentLibrariesMenu.submenu.removeAllItems();

            _recentLibrariesMenu.submenu.addItem(_separator);
            _recentLibrariesMenu.submenu.addItem(_clearItem);

            saveRecentLibraries();
        }

        public function appendRecentDirectory(path:String):void
        {
            if (_recentLibraryDirectories.includes(path))
                return;

            _recentLibraryDirectories.insertAt(0, path);
            _recentLibrariesMenu.submenu.addItemAt(createRecentDirectoryMenuItem(path), 0);

            while (_recentLibraryDirectories.length > maxItems)
            {
                var index:int = _recentLibraryDirectories.length - 1;
                _recentLibraryDirectories.pop();

                var item:NativeMenuItem = _recentLibrariesMenu.submenu.removeItemAt(index);
                item.removeEventListener(Event.SELECT, onRecentLibraryLoadClicked);
            }

            saveRecentLibraries();
        }
        private function createRecentDirectoryMenuItem(directory:String):NativeMenuItem
        {
            var item:NativeMenuItem = new NativeMenuItem(directory);
            item.addEventListener(Event.SELECT, onRecentLibraryLoadClicked);
            return item;
        }

        private function saveRecentLibraries():void
        {
            _storage.data[recentDirsKey] = JSON.stringify({
                        list: _recentLibraryDirectories
                    });
            _storage.flush();
        }

        private function onRecentLibraryLoadClicked(e:Event):void
        {
            var item:NativeMenuItem = (e.target as NativeMenuItem);

            _libraryManager.loadFromDirectory(item.label);
        }

    }
}