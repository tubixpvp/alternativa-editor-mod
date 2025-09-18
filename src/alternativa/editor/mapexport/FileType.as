package alternativa.editor.mapexport
{
   public class FileType
   {
      public static const MAP_XML_VERSION_1_FULL:FileType = new FileType("MAP_XML_VERSION_1_FULL");
      
      public static const MAP_XML_VERSION_1_LITE:FileType = new FileType("MAP_XML_VERSION_1_LITE");
      
      public static const MAP_XML_VERSION_2:FileType = new FileType("MAP_XML_VERSION_2");
      
      public static const MAP_XML_VERSION_3:FileType = new FileType("MAP_XML_VERSION_3");

      public static const BINARY:FileType = new FileType("BINARY");
      
      private var value:String;
      
      public function FileType(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function toString() : String
      {
         return this.value;
      }
   }
}

