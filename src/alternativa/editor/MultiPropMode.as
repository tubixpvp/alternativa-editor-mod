package alternativa.editor
{
   import flash.utils.Dictionary;

   public class MultiPropMode
   {
      public static const ANY:MultiPropMode = new MultiPropMode("ANY");
      
      public static const GROUP:MultiPropMode = new MultiPropMode("GROUP");
      
      public static const NONE:MultiPropMode = new MultiPropMode("NONE");
      

      private static const _values:Dictionary = new Dictionary();

      {
         _values[ANY.name] = ANY;
         _values[GROUP.name] = GROUP;
         _values[NONE.name] = NONE;
      }

      public static function getByName(name:String) : MultiPropMode
      {
         return _values[name];
      }

      public var name:String;

      public function MultiPropMode(name:String)
      {
         super();
         this.name = name;
      }
   }
}

