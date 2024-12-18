package alternativa.editor
{
   import alternativa.editor.events.EditorProgressEvent;
   import alternativa.editor.prop.CTFFlagBase;
   import alternativa.editor.prop.ControlPoint;
   import alternativa.editor.prop.FreeBonusRegion;
   import alternativa.editor.prop.KillBox;
   import alternativa.editor.prop.MeshProp;
   import alternativa.editor.prop.Prop;
   import alternativa.editor.prop.SpawnPoint;
   import alternativa.editor.prop.Sprite3DProp;
   import alternativa.editor.propslib.PropGroup;
   import alternativa.editor.propslib.PropLibMesh;
   import alternativa.editor.propslib.PropLibObject;
   import alternativa.editor.propslib.PropsLibrary;
   import alternativa.editor.propslib.events.PropLibProgressEvent;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.types.Map;
   import alternativa.types.Point3D;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   
   public class LibraryManager extends EventDispatcher
   {
      private static var funcIsNotLoadedYet:Boolean = true;
      
      private var file:File;
      
      private var clearLibrariesBeforeLoad:Boolean = false;
      
      public var libraryNames:Array;
      
      private var propsByLibraryName:Map;
      
      public var propByKey:Map;
      
      private var libUrls:Array;
      
      private var currentLib:PropsLibrary;
      
      private var totalLibs:int;
      
      private var loadedLibs:int;
      
      public function LibraryManager()
      {
         this.file = new File();
         this.libraryNames = [];
         this.propsByLibraryName = new Map();
         this.propByKey = new Map();
         super();
         this.file.addEventListener(Event.SELECT,this.onFileSelect);
      }
      
      private static function createFunctionalProp(param1:PropLibObject, param2:String) : Prop
      {
         var loc3:Object3D = param1.mainObject;
         switch(param2)
         {
            case FunctionalProps.GRP_SPAWN_POINTS:
               return new SpawnPoint(loc3,param1.name,FunctionalProps.LIBRARY_NAME,param2);
            case FunctionalProps.GRP_BONUS_REGIONS:
               return new FreeBonusRegion(param1.name,FunctionalProps.LIBRARY_NAME,param2);
            case FunctionalProps.GRP_FLAGS:
               return new CTFFlagBase(loc3,param1.name,FunctionalProps.LIBRARY_NAME,param2);
            case FunctionalProps.GRP_DOMINATION:
               return createDominationProp(param2,param1);
            default:
               if(param2 == FunctionalProps.KILL_GEOMETRY)
               {
                  return createKillProp(param2,param1);
               }
               throw new Error("Unknown functional group name: " + param2);
         }
      }
      
      private static function createDominationProp(param1:String, param2:PropLibObject) : Prop
      {
         switch(param2.name)
         {
            case FunctionalProps.DOMINATION_BLUE_SPAWN:
            case FunctionalProps.DOMINATION_RED_SPAWN:
            case FunctionalProps.DOMINATION_SPAWN:
               return new SpawnPoint(param2.mainObject,param2.name,FunctionalProps.LIBRARY_NAME,param1);
            case FunctionalProps.DOMINATION_POINT:
               return new ControlPoint(param2.mainObject,param2.name,FunctionalProps.LIBRARY_NAME,param1);
            default:
               throw new Error("Unsupported prop type: " + param2.name);
         }
      }
      
      private static function createRegularProp(param1:PropLibObject, param2:String, param3:String) : Prop
      {
         var loc5:MeshProp = null;
         var loc6:String = null;
         var loc4:Object3D = param1.mainObject;
         loc4.setPositionXYZ(0,0,0);
         if(loc4 is Mesh)
         {
            loc5 = new MeshProp(loc4,param1.objects,param1.name,param2,param3);
            loc5.bitmaps = (param1 as PropLibMesh).bitmaps;
            if(loc5.bitmaps != null)
            {
               var loc7:int = 0;
               var loc8:* = loc5.bitmaps;
               for(loc6 in loc8)
               {
                  loc5.textureName = loc6;
               }
            }
            return loc5;
         }
         if(loc4 is Sprite3D)
         {
            return new Sprite3DProp(loc4 as Sprite3D,param1.name,param2,param3);
         }
         throw new Error("Unknown object type: " + loc4);
      }
      
      private static function createKillProp(param1:String, param2:PropLibObject) : Prop
      {
         switch(param2.name)
         {
            case FunctionalProps.KILL_GEOMETRY:
               return new KillBox(param2.name,FunctionalProps.LIBRARY_NAME,param1);
            default:
               throw new Error("Unsupported prop type: " + param2.name);
         }
      }
      
      public function clearAndLoadLibrary() : void
      {
         this.clearLibrariesBeforeLoad = true;
         this.load();
      }
      
      private function load() : void
      {
         this.file.browseForDirectory("Load library");
      }
      
      public function loadLibrary() : void
      {
         this.clearLibrariesBeforeLoad = false;
         this.load();
      }
      
      public function getPropsByLibName(param1:String) : Array
      {
         return this.propsByLibraryName[param1];
      }
      
      private function searchForLibrariesInDir(param1:File) : void
      {
         var loc2:File = null;
         var loc3:Array = null;
         if(param1.isDirectory)
         {
            loc2 = param1.resolvePath("library.xml");
            if(loc2.exists)
            {
               this.libUrls.push(param1.url);
            }
            loc3 = param1.getDirectoryListing();
            for each(loc2 in loc3)
            {
               if(loc2.isDirectory)
               {
                  this.searchForLibrariesInDir(loc2);
               }
            }
         }
      }
      
      public function loadGivenLibraries(param1:Array) : void
      {
         var loc2:* = undefined;
         this.libUrls = [];
         for each(loc2 in param1)
         {
            this.searchForLibrariesInDir(loc2);
         }
         this.startLoadingLibs();
      }
      
      private function onFileSelect(param1:Event) : void
      {
         this.libUrls = [];
         this.searchForLibrariesInDir(this.file);
         if(this.clearLibrariesBeforeLoad)
         {
            this.clearLibrariesBeforeLoad = false;
            this.clearLibraries();
         }
         this.startLoadingLibs();
      }
      
      private function startLoadingLibs() : void
      {
         ErrorHandler.clearMessages();
         this.totalLibs = this.libUrls.length;
         this.loadedLibs = 0;
         if(this.libUrls.length > 0)
         {
            dispatchEvent(new Event("open"));
            this.loadNextLib();
         }
      }
      
      public function clearLibraries() : void
      {
         var loc1:* = this.propsByLibraryName[FunctionalProps.LIBRARY_NAME];
         this.libraryNames.length = 0;
         this.libraryNames.push(FunctionalProps.LIBRARY_NAME);
         this.propsByLibraryName.clear();
         this.propsByLibraryName.add(FunctionalProps.LIBRARY_NAME,loc1);
      }
      
      private function loadNextLib() : void
      {
         var loc1:String = this.libUrls.pop();
         ErrorHandler.addText("Start loading " + loc1 + "---------------------------------");
         this.currentLib = new PropsLibrary();
         this.currentLib.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.currentLib.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this.currentLib.addEventListener(PropLibProgressEvent.PROGRESS,this.onProgress);
         this.currentLib.load(loc1);
      }
      
      private function onProgress(param1:PropLibProgressEvent) : void
      {
         if(hasEventListener(EditorProgressEvent.PROGRESS))
         {
            dispatchEvent(new EditorProgressEvent((this.loadedLibs + param1.propsLoaded / param1.propsTotal) / this.totalLibs));
         }
      }
      
      private function onLoadingComplete(param1:Event) : void
      {
         ++this.loadedLibs;
         this.currentLib.removeEventListener(PropLibProgressEvent.PROGRESS,this.onProgress);
         this.currentLib.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
         ErrorHandler.addText("Complete loading" + this.currentLib.name);
         this.addLibrary(this.currentLib);
         if(this.libUrls.length == 0)
         {
            this.currentLib = null;
            this.libUrls = null;
            dispatchEvent(new Event("complete"));
         }
         else
         {
            this.loadNextLib();
         }
      }
      
      public function addLibrary(param1:PropsLibrary) : void
      {
         var loc7:PropGroup = null;
         var loc8:String = null;
         var loc9:Vector.<PropLibObject> = null;
         var loc10:int = 0;
         var loc11:int = 0;
         var loc12:PropLibObject = null;
         var loc13:Prop = null;
         var loc2:String = param1.name;
         var loc3:Array = [];
         var loc4:Vector.<PropGroup> = param1.rootGroup.groups;
         var loc5:int = int(loc4.length);
         var loc6:int = 0;
         while(loc6 < loc5)
         {
            loc7 = loc4[loc6];
            loc8 = loc7.name;
            loc9 = loc7.props;
            loc10 = int(loc9.length);
            loc11 = 0;
            while(loc11 < loc10)
            {
               loc12 = loc9[loc11];
               if(loc12)
               {
                  if(loc2 == FunctionalProps.LIBRARY_NAME)
                  {
                     if(funcIsNotLoadedYet)
                     {
                        loc13 = createFunctionalProp(loc12,loc8);
                        loc13.name = loc12.name;
                        loc13.icon = AlternativaEditor.preview.getPropIcon(loc13);
                        loc3.push(loc13);
                        this.propByKey.add(loc2 + loc8 + loc13.name,loc13);
                     }
                  }
                  else
                  {
                     loc13 = createRegularProp(loc12,loc2,loc8);
                     loc13.name = loc12.name;
                     loc13.icon = AlternativaEditor.preview.getPropIcon(loc13);
                     loc3.push(loc13);
                     this.propByKey.add(loc2 + loc8 + loc13.name,loc13);
                  }
               }
               loc11++;
            }
            loc6++;
         }
         if(loc2 == FunctionalProps.LIBRARY_NAME)
         {
            if(funcIsNotLoadedYet)
            {
               this.propsByLibraryName.add(loc2,loc3);
               this.libraryNames.push(loc2);
               funcIsNotLoadedYet = false;
            }
         }
         else
         {
            this.propsByLibraryName.add(loc2,loc3);
            this.libraryNames.push(loc2);
         }
      }
      
      private function onLoadingError(param1:ErrorEvent) : void
      {
         ErrorHandler.setMessage("Loadind error");
         ErrorHandler.addText(param1.text);
         ErrorHandler.showWindow();
      }
   }
}

