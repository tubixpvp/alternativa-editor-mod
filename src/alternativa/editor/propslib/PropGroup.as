package alternativa.editor.propslib
{
   public class PropGroup
   {
      public var name:String;
      
      public var props:Vector.<PropLibObject>;
      
      public var groups:Vector.<PropGroup>;
      
      public function PropGroup(param1:String)
      {
         super();
         this.name = param1;
      }
      
      public function getPropByName(param1:String) : PropLibObject
      {
         var loc2:PropLibObject = null;
         if(this.props != null)
         {
            for each(loc2 in this.props)
            {
               if(loc2.name == param1)
               {
                  return loc2;
               }
            }
         }
         return null;
      }
      
      public function getGroupByName(param1:String) : PropGroup
      {
         var loc2:PropGroup = null;
         if(this.groups != null)
         {
            for each(loc2 in this.groups)
            {
               if(loc2.name == param1)
               {
                  return loc2;
               }
            }
         }
         return null;
      }
      
      public function addProp(param1:PropLibObject) : void
      {
         if(this.props == null)
         {
            this.props = new Vector.<PropLibObject>();
         }
         this.props.push(param1);
      }
      
      public function addGroup(param1:PropGroup) : void
      {
         if(this.groups == null)
         {
            this.groups = new Vector.<PropGroup>();
         }
         this.groups.push(param1);
      }
   }
}

