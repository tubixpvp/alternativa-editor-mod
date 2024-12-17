package alternativa.engine3d.events
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import alternativa.engine3d.display.View;
   import flash.events.Event;
   
   public class MouseEvent3D extends Event
   {
      public static const CLICK:String = "click";
      
      public static const MOUSE_DOWN:String = "mouseDown";
      
      public static const MOUSE_UP:String = "mouseUp";
      
      public static const MOUSE_OVER:String = "mouseOver";
      
      public static const MOUSE_OUT:String = "mouseOut";
      
      public static const MOUSE_MOVE:String = "mouseMove";
      
      public static const MOUSE_WHEEL:String = "mouseWheel";
      
      public var object:Object3D;
      
      public var surface:Surface;
      
      public var face:Face;
      
      public var view:View;
      
      public var globalX:Number;
      
      public var globalY:Number;
      
      public var globalZ:Number;
      
      public var localX:Number;
      
      public var localY:Number;
      
      public var localZ:Number;
      
      public var u:Number;
      
      public var v:Number;
      
      public var altKey:Boolean;
      
      public var ctrlKey:Boolean;
      
      public var shiftKey:Boolean;
      
      public var delta:int;
      
      public function MouseEvent3D(param1:String, param2:View, param3:Object3D, param4:Surface, param5:Face, param6:Number = NaN, param7:Number = NaN, param8:Number = NaN, param9:Number = NaN, param10:Number = NaN, param11:Number = NaN, param12:Number = NaN, param13:Number = NaN, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false, param17:int = 0)
      {
         super(param1);
         this.view = param2;
         this.object = param3;
         this.surface = param4;
         this.face = param5;
         this.globalX = param6;
         this.globalY = param7;
         this.globalZ = param8;
         this.localX = param9;
         this.localY = param10;
         this.localZ = param11;
         this.u = param12;
         this.v = param13;
         this.altKey = param14;
         this.ctrlKey = param15;
         this.shiftKey = param16;
         this.delta = param17;
      }
      
      override public function toString() : String
      {
         return formatToString("MouseEvent3D","object","surface","face","globalX","globalY","globalZ","localX","localY","localZ","u","v","delta","altKey","ctrlKey","shiftKey");
      }
      
      override public function clone() : Event
      {
         return new MouseEvent3D(type,this.view,this.object,this.surface,this.face,this.globalX,this.globalY,this.globalZ,this.localX,this.localY,this.localZ,this.u,this.v,this.altKey,this.ctrlKey,this.shiftKey,this.delta);
      }
   }
}

