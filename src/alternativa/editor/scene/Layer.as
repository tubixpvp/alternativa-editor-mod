package alternativa.editor.scene
{
   import alternativa.editor.prop.Prop;
   import alternativa.types.Set;
   
   public class Layer
   {
      public var visible:Boolean = true;

      public var props:Set;
      
      public function Layer()
      {
         this.props = new Set();
         super();
      }
      
      public function addProp(param1:Prop) : void
      {
         this.props.add(param1);
      }
      
      public function removeProp(param1:Prop) : void
      {
         this.props.remove(param1);
      }
      
      public function clear() : void
      {
         this.props.clear();
      }
   }
}

