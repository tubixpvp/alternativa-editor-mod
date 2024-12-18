package alternativa.editor.propslib
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.types.Map;
   
   public class PropLibMesh extends PropLibObject
   {
      public var bitmaps:Map;
      
      public function PropLibMesh(param1:String, param2:Object3D = null, param3:Map = null)
      {
         super(param1,param2);
         this.bitmaps = param3;
      }
      
      public function toString() : String
      {
         return "[PropMesh object3d=" + mainObject + ", bitmaps=" + this.bitmaps + (objects != null ? ", objectsLen="+objects.length : "") + "]";
      }
   }
}

