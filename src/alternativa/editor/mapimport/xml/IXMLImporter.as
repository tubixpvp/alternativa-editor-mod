package alternativa.editor.mapimport.xml
{
   import alternativa.editor.LibraryManager;
   import alternativa.editor.scene.MainScene;
   import flash.events.IEventDispatcher;
   
   public interface IXMLImporter extends IEventDispatcher
   {
      function importMap(param1:XML, param2:MainScene, param3:LibraryManager) : void;
      
      function addInternalObjectsToExistingScene(param1:XML, param2:MainScene, param3:LibraryManager) : void;
   }
}

