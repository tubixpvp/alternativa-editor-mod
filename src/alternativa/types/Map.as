package alternativa.types
{
   import flash.utils.Dictionary;
   
   public dynamic class Map extends Dictionary
   {
      private var weakKeys:Boolean;
      
      public function Map(param1:Boolean = false)
      {
         this.weakKeys = param1;
         super(param1);
      }
      
      public function add(param1:*, param2:*) : void
      {
         this[param1] = param2;
      }
      
      public function isEmpty() : Boolean
      {
         var loc1:* = undefined;
         var loc2:int = 0;
         var loc3:* = this;
         for(loc1 in loc3)
         {
            return false;
         }
         return true;
      }
      
      public function remove(param1:*) : void
      {
         delete this[param1];
      }
      
      public function hasKey(param1:*) : Boolean
      {
         return this[param1] !== undefined;
      }
      
      public function get length() : uint
      {
         var loc2:* = undefined;
         var loc1:uint = 0;
         for(loc2 in this)
         {
            loc1++;
         }
         return loc1;
      }
      
      public function take() : *
      {
         var loc1:* = undefined;
         var loc2:* = undefined;
         var loc3:int = 0;
         var loc4:* = this;
         for(loc1 in loc4)
         {
            loc2 = this[loc1];
            delete this[loc1];
            return loc2;
         }
         return null;
      }
      
      public function clear() : void
      {
         var loc1:* = undefined;
         for(loc1 in this)
         {
            delete this[loc1];
         }
      }
      
      public function any() : *
      {
         var loc3:* = undefined;
         var loc1:uint = 0;
         var loc2:uint = Math.random() * length;
         for(loc3 in this)
         {
            if(loc1 == loc2)
            {
               return this[loc3];
            }
            loc1++;
         }
         return null;
      }
      
      public function isSingle() : Boolean
      {
         var loc2:* = undefined;
         var loc1:Boolean = false;
         for(loc2 in this)
         {
            if(loc1)
            {
               return false;
            }
            loc1 = true;
         }
         return loc1;
      }
      
      public function concat(param1:Map) : void
      {
         var loc2:* = undefined;
         for(loc2 in param1)
         {
            this[loc2] = param1[loc2];
         }
      }
      
      public function toSet(param1:Boolean = false) : Set
      {
         var loc3:* = undefined;
         var loc2:Set = new Set(param1);
         for each(loc3 in this)
         {
            loc2[loc3] = true;
         }
         return loc2;
      }
      
      public function hasValue(param1:*) : Boolean
      {
         var loc2:* = undefined;
         for(loc2 in this)
         {
            if(this[loc2] === param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function toString() : String
      {
         var loc3:* = undefined;
         var loc1:int = 0;
         var loc2:String = "";
         for(loc3 in this)
         {
            loc2 += "," + loc3 + ":" + this[loc3];
            loc1++;
         }
         return "[Map length:" + loc1 + (loc1 > 0 ? " " + loc2.substring(1) : "") + "]";
      }
      
      public function peek() : *
      {
         var loc1:* = undefined;
         var loc2:int = 0;
         var loc3:* = this;
         for(loc1 in loc3)
         {
            return this[loc1];
         }
         return null;
      }
      
      public function clone() : Map
      {
         var loc2:* = undefined;
         var loc1:Map = new Map(weakKeys);
         for(loc2 in this)
         {
            loc1[loc2] = this[loc2];
         }
         return loc1;
      }
      
      public function toArray(param1:Boolean = false) : Array
      {
         var loc3:* = undefined;
         var loc2:Array = new Array();
         if(param1)
         {
            for(loc3 in this)
            {
               loc2.push(this[loc3]);
            }
         }
         else
         {
            for(loc3 in this)
            {
               loc2[loc3] = this[loc3];
            }
         }
         return loc2;
      }
   }
}

