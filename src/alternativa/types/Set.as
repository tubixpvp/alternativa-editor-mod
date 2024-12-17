package alternativa.types
{
   import flash.utils.Dictionary;
   
   public final dynamic class Set extends Dictionary
   {
      private var weakKeys:Boolean;
      
      public function Set(param1:Boolean = false)
      {
         this.weakKeys = param1;
         super(param1);
      }
      
      public static function intersection(param1:Set, param2:Set, param3:Boolean = false) : Set
      {
         var loc5:* = undefined;
         var loc4:Set = new Set(param3);
         for(loc5 in param1)
         {
            if(param2[loc5])
            {
               loc4[loc5] = true;
            }
         }
         return loc4;
      }
      
      public static function createFromArray(param1:Array, param2:Boolean = false) : Set
      {
         var loc4:* = undefined;
         var loc3:Set = new Set(param2);
         for each(loc4 in param1)
         {
            loc3[loc4] = true;
         }
         return loc3;
      }
      
      public static function difference(param1:Set, param2:Set, param3:Boolean = false) : Set
      {
         var loc5:* = undefined;
         var loc4:Set = new Set(param3);
         for(loc5 in param1)
         {
            if(!param2[loc5])
            {
               loc4[loc5] = true;
            }
         }
         return loc4;
      }
      
      public static function union(param1:Set, param2:Set, param3:Boolean = false) : Set
      {
         var loc5:* = undefined;
         var loc4:Set = new Set(param3);
         for(loc5 in param1)
         {
            loc4[loc5] = true;
         }
         for(loc5 in param2)
         {
            loc4[loc5] = true;
         }
         return loc4;
      }
      
      public function add(param1:*) : void
      {
         this[param1] = true;
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
         var loc2:int = 0;
         var loc3:* = this;
         for(loc1 in loc3)
         {
            delete this[loc1];
            return loc1;
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
               return loc3;
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
      
      public function concat(param1:Set) : void
      {
         var loc2:* = undefined;
         for(loc2 in param1)
         {
            this[loc2] = true;
         }
      }
      
      public function subtract(param1:Set) : void
      {
         var loc2:* = undefined;
         for(loc2 in param1)
         {
            delete this[loc2];
         }
      }
      
      public function toString() : String
      {
         var loc3:* = undefined;
         var loc1:int = 0;
         var loc2:String = "";
         for(loc3 in this)
         {
            loc2 += "," + loc3;
            loc1++;
         }
         return "[Set length:" + loc1 + (loc1 > 0 ? " " + loc2.substring(1) : "") + "]";
      }
      
      public function has(param1:*) : Boolean
      {
         return this[param1];
      }
      
      public function peek() : *
      {
         var loc1:* = undefined;
         var loc2:int = 0;
         var loc3:* = this;
         for(loc1 in loc3)
         {
            return loc1;
         }
         return null;
      }
      
      public function clone() : Set
      {
         var loc2:* = undefined;
         var loc1:Set = new Set(weakKeys);
         for(loc2 in this)
         {
            loc1[loc2] = true;
         }
         return loc1;
      }
      
      public function toArray() : Array
      {
         var loc2:* = undefined;
         var loc1:Array = new Array();
         for(loc2 in this)
         {
            loc1.push(loc2);
         }
         return loc1;
      }
      
      public function intersect(param1:Set) : void
      {
         var loc3:* = undefined;
         var loc2:Set = new Set(true);
         for(loc3 in this)
         {
            if(param1[loc3])
            {
               loc2[loc3] = true;
            }
            delete this[loc3];
         }
         concat(loc2);
      }
   }
}

