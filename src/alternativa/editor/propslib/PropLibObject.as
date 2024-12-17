package alternativa.editor.propslib
{
   import alternativa.engine3d.core.Object3D;
   
   public class PropLibObject
   {
      public var name:String;
      
      public var object3d:Object3D;
      
      public function PropLibObject(param1:String, param2:Object3D = null)
      {
         super();
         this.name = param1;
         this.object3d = param2;
      }
   }
}

