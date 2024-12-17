package alternativa.editor.scene
{
   import alternativa.editor.prop.Prop;
   
   public class Layers
   {
      public var layers:Object;

      public function Layers()
      {
         this.layers = {};
         super();
      }
      
      public function addProp(param1:String, param2:Prop) : void
      {
         this.getLayer(param1).addProp(param2);
      }
      
      public function removeProp(param1:Prop, param2:String = null) : void
      {
         var loc3:Layer = null;
         if(param2)
         {
            this.getLayer(param2).removeProp(param1);
         }
         else
         {
            for each(loc3 in this.layers)
            {
               loc3.removeProp(param1);
            }
         }
      }
      
      public function getLayersContainingProp(param1:Prop) : Vector.<Layer>
      {
         var loc3:Layer = null;
         var loc2:Vector.<Layer> = new Vector.<Layer>();
         for each(loc3 in this.layers)
         {
            if(loc3.props.has(param1))
            {
               loc2.push(loc3);
            }
         }
         return loc2;
      }
      
      public function getLayerNamesContainingProp(param1:Prop) : Vector.<String>
      {
         var loc3:String = null;
         var loc2:Vector.<String> = new Vector.<String>();
         for(loc3 in this.layers)
         {
            if(this.layers[loc3].props.has(param1))
            {
               loc2.push(loc3);
            }
         }
         return loc2;
      }
      
      internal function getLayer(param1:String) : Layer
      {
         if(this.layers[param1] == null)
         {
            this.layers[param1] = new Layer();
         }
         return this.layers[param1];
      }
      
      public function clear() : void
      {
         var loc1:Layer = null;
         for each(loc1 in this.layers)
         {
            loc1.clear();
         }
      }
   }
}

