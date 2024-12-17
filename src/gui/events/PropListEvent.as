package gui.events
{
   import flash.events.Event;
   
   public class PropListEvent extends Event
   {
      public static const SELECT:String = "select";
      
      private var _selectedIndex:int;
      
      private var _selectedItem:*;
      
      public function PropListEvent(param1:int, param2:*)
      {
         super(PropListEvent.SELECT,false,false);
         this._selectedIndex = param1;
         this._selectedItem = param2;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function get selectedItem() : *
      {
         return this._selectedItem;
      }
      
      override public function toString() : String
      {
         return formatToString("ListEvents","type","bubbles","cancelable","selectedIndex","selectedItem");
      }
      
      override public function clone() : Event
      {
         return new PropListEvent(this._selectedIndex,this._selectedItem);
      }
   }
}

