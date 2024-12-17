package alternativa.editor.scene
{
   import alternativa.editor.prop.Prop;
   import alternativa.types.Map;
   import alternativa.types.Set;
   
   public class OccupyMap
   {
      private var map:Map;
      
      public function OccupyMap()
      {
         super();
         this.map = new Map();
      }
      
      public function occupy(param1:Prop) : void
      {
         var loc2:Number = NaN;
         var loc3:Number = NaN;
         var loc4:Map = null;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Set = null;
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc11:Number = NaN;
         var loc12:Number = NaN;
         var loc13:Number = NaN;
         if(param1.free)
         {
            loc2 = param1.distancesZ.x + param1.z;
            loc3 = param1.distancesZ.y + param1.z;
            loc4 = new Map();
            loc5 = loc2;
            while(loc5 < loc3)
            {
               loc4.add(loc5,[param1]);
               loc5 += EditorScene.vBase;
            }
            loc6 = param1.distancesY.x + param1.y;
            loc7 = param1.distancesY.y + param1.y;
            loc8 = new Set();
            loc5 = loc6;
            while(loc5 < loc7)
            {
               loc8.add(loc5);
               loc5 += EditorScene.hBase;
            }
            loc9 = param1.distancesX.x + param1.x;
            loc10 = param1.distancesX.y + param1.x;
            loc11 = loc9;
            while(loc11 < loc10)
            {
               loc12 = loc6;
               while(loc12 < loc7)
               {
                  loc13 = loc2;
                  while(loc13 < loc3)
                  {
                     this.addElement(loc11,loc12,loc13,param1);
                     loc13 += EditorScene.vBase;
                  }
                  loc12 += EditorScene.hBase;
               }
               loc11 += EditorScene.hBase;
            }
            param1.free = false;
         }
      }
      
      public function addElement(param1:Number, param2:Number, param3:Number, param4:Prop) : void
      {
         var loc5:Map = this.map[param1];
         if(!loc5)
         {
            loc5 = new Map();
            this.map[param1] = loc5;
         }
         var loc6:Map = loc5[param2];
         if(!loc6)
         {
            loc6 = new Map();
            loc5[param2] = loc6;
         }
         var loc7:Array = loc6[param3];
         if(!loc7)
         {
            loc6.add(param3,[param4]);
         }
         else
         {
            loc7.push(param4);
         }
      }
      
      public function free(param1:Prop) : void
      {
         var loc2:Number = NaN;
         var loc3:Number = NaN;
         var loc4:Set = null;
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Set = null;
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc11:Map = null;
         var loc12:* = undefined;
         var loc13:Number = NaN;
         var loc14:Map = null;
         var loc15:* = undefined;
         var loc16:Number = NaN;
         var loc17:Array = null;
         var loc18:int = 0;
         if(!param1.free)
         {
            loc2 = param1.distancesZ.x + param1.z;
            loc3 = param1.distancesZ.y + param1.z;
            loc4 = new Set();
            loc5 = loc2;
            while(loc5 < loc3)
            {
               loc4.add(loc5);
               loc5 += EditorScene.vBase;
            }
            loc6 = param1.distancesY.x + param1.y;
            loc7 = param1.distancesY.y + param1.y;
            loc8 = new Set();
            loc5 = loc6;
            while(loc5 < loc7)
            {
               loc8.add(loc5);
               loc5 += EditorScene.hBase;
            }
            loc9 = param1.distancesX.x + param1.x;
            loc10 = param1.distancesX.y + param1.x;
            loc5 = loc9;
            while(loc5 < loc10)
            {
               loc11 = this.map[loc5];
               if(loc11)
               {
                  for(loc12 in loc8)
                  {
                     loc13 = loc12;
                     loc14 = loc11[loc13];
                     if(loc14)
                     {
                        for(loc15 in loc4)
                        {
                           loc16 = loc15;
                           loc17 = loc14[loc16];
                           if(loc17)
                           {
                              loc18 = int(loc17.indexOf(param1));
                              if(loc18 > -1)
                              {
                                 loc17.splice(loc18,1);
                                 if(loc17.length == 0)
                                 {
                                    loc14.remove(loc16);
                                 }
                              }
                           }
                        }
                        if(loc14.length == 0)
                        {
                           loc11.remove(loc13);
                        }
                     }
                  }
                  if(loc11.length == 0)
                  {
                     this.map.remove(loc5);
                  }
               }
               loc5 += EditorScene.hBase;
            }
            param1.free = true;
         }
      }
      
      public function isOccupy(param1:Number, param2:Number, param3:Number) : Array
      {
         var loc5:Map = null;
         var loc4:Map = this.map[param1];
         if(loc4)
         {
            loc5 = loc4[param2];
            if(loc5)
            {
               if(loc5.hasKey(param3))
               {
                  return loc5[param3];
               }
            }
         }
         return null;
      }
      
      public function clear() : void
      {
         this.map.clear();
      }
      
      public function isConflict(param1:Prop) : Boolean
      {
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Number = NaN;
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc11:Array = null;
         var loc2:Number = param1.distancesX.x + param1.x;
         var loc3:Number = param1.distancesX.y + param1.x;
         var loc4:Number = loc2;
         while(loc4 < loc3)
         {
            loc5 = param1.distancesY.x + param1.y;
            loc6 = param1.distancesY.y + param1.y;
            loc7 = loc5;
            while(loc7 < loc6)
            {
               loc8 = param1.distancesZ.x + param1.z;
               loc9 = param1.distancesZ.y + param1.z;
               loc10 = loc8;
               while(loc10 < loc9)
               {
                  loc11 = this.isOccupy(loc4,loc7,loc10);
                  if((Boolean(loc11)) && (loc11.indexOf(param1) == -1 || loc11.length > 1))
                  {
                     return true;
                  }
                  loc10 += EditorScene.vBase;
               }
               loc7 += EditorScene.hBase;
            }
            loc4 += EditorScene.hBase;
         }
         return false;
      }
      
      public function isConflictGroup(param1:Prop) : Boolean
      {
         var loc5:Number = NaN;
         var loc6:Number = NaN;
         var loc7:Number = NaN;
         var loc8:Number = NaN;
         var loc9:Number = NaN;
         var loc10:Number = NaN;
         var loc11:Array = null;
         var loc12:int = 0;
         var loc13:int = 0;
         var loc14:Prop = null;
         var loc2:Number = param1.distancesX.x + param1.x;
         var loc3:Number = param1.distancesX.y + param1.x;
         var loc4:Number = loc2;
         while(loc4 < loc3)
         {
            loc5 = param1.distancesY.x + param1.y;
            loc6 = param1.distancesY.y + param1.y;
            loc7 = loc5;
            while(loc7 < loc6)
            {
               loc8 = param1.distancesZ.x + param1.z;
               loc9 = param1.distancesZ.y + param1.z;
               loc10 = loc8;
               while(loc10 < loc9)
               {
                  loc11 = this.isOccupy(loc4,loc7,loc10);
                  if(loc11)
                  {
                     loc12 = int(loc11.length);
                     loc13 = 0;
                     while(loc13 < loc12)
                     {
                        loc14 = loc11[loc13];
                        if(loc14 != param1 && loc14.groupName == param1.groupName)
                        {
                           return true;
                        }
                        loc13++;
                     }
                  }
                  loc10 += EditorScene.vBase;
               }
               loc7 += EditorScene.hBase;
            }
            loc4 += EditorScene.hBase;
         }
         return false;
      }
      
      public function getConflictProps() : Set
      {
         var loc2:* = undefined;
         var loc3:Map = null;
         var loc4:* = undefined;
         var loc5:Map = null;
         var loc6:* = undefined;
         var loc7:Array = null;
         var loc8:int = 0;
         var loc1:Set = new Set();
         for(loc2 in this.map)
         {
            loc3 = this.map[loc2];
            for(loc4 in loc3)
            {
               loc5 = loc3[loc4];
               for(loc6 in loc5)
               {
                  loc7 = loc5[loc6];
                  if((Boolean(loc7)) && loc7.length > 1)
                  {
                     loc8 = 0;
                     while(loc8 < loc7.length)
                     {
                        loc1.add(loc7[loc8]);
                        loc8++;
                     }
                  }
               }
            }
         }
         return loc1;
      }
   }
}

