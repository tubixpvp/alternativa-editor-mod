package alternativa.engine3d.primitives
{
   import alternativa.engine3d.*;
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import flash.geom.Point;
   
   use namespace alternativa3d;
   
   public class Plane extends Mesh
   {
      private static var counter:uint = 0;
      
      public function Plane(param1:Number = 100, param2:Number = 100, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false)
      {
         var loc14:int = 0;
         var loc15:int = 0;
         var loc17:Surface = null;
         var loc18:Surface = null;
         super();
         if(param3 == 0 || param4 == 0)
         {
            return;
         }
         param1 = param1 < 0 ? 0 : param1;
         param2 = param2 < 0 ? 0 : param2;
         var loc8:Number = param1 / 2;
         var loc9:Number = param2 / 2;
         var loc10:Number = param1 / param3;
         var loc11:Number = param2 / param4;
         var loc12:Number = 1 / param3;
         var loc13:Number = 1 / param4;
         var loc16:Array = new Array();
         loc15 = 0;
         while(loc15 <= param4)
         {
            loc16[loc15] = new Array();
            loc14 = 0;
            while(loc14 <= param3)
            {
               loc16[loc15][loc14] = new Point(loc14 * loc12,loc15 * loc13);
               createVertex(loc14 * loc10 - loc8,loc15 * loc11 - loc9,0,loc14 + "_" + loc15);
               loc14++;
            }
            loc15++;
         }
         if(param5 || !param6)
         {
            loc17 = createSurface(null,"front");
         }
         if(param5 || param6)
         {
            loc18 = createSurface(null,"back");
         }
         loc15 = 0;
         while(loc15 < param4)
         {
            loc14 = 0;
            while(loc14 < param3)
            {
               if(param5 || !param6)
               {
                  if(param7)
                  {
                     createFace([loc14 + "_" + loc15,loc14 + 1 + "_" + loc15,loc14 + 1 + "_" + (loc15 + 1)],"front" + loc14 + "_" + loc15 + ":0");
                     setUVsToFace(loc16[loc15][loc14],loc16[loc15][loc14 + 1],loc16[loc15 + 1][loc14 + 1],"front" + loc14 + "_" + loc15 + ":0");
                     createFace([loc14 + 1 + "_" + (loc15 + 1),loc14 + "_" + (loc15 + 1),loc14 + "_" + loc15],"front" + loc14 + "_" + loc15 + ":1");
                     setUVsToFace(loc16[loc15 + 1][loc14 + 1],loc16[loc15 + 1][loc14],loc16[loc15][loc14],"front" + loc14 + "_" + loc15 + ":1");
                     loc17.addFace("front" + loc14 + "_" + loc15 + ":0");
                     loc17.addFace("front" + loc14 + "_" + loc15 + ":1");
                  }
                  else
                  {
                     createFace([loc14 + "_" + loc15,loc14 + 1 + "_" + loc15,loc14 + 1 + "_" + (loc15 + 1),loc14 + "_" + (loc15 + 1)],"front" + loc14 + "_" + loc15);
                     setUVsToFace(loc16[loc15][loc14],loc16[loc15][loc14 + 1],loc16[loc15 + 1][loc14 + 1],"front" + loc14 + "_" + loc15);
                     loc17.addFace("front" + loc14 + "_" + loc15);
                  }
               }
               if(param5 || param6)
               {
                  if(param7)
                  {
                     createFace([loc14 + "_" + loc15,loc14 + "_" + (loc15 + 1),loc14 + 1 + "_" + (loc15 + 1)],"back" + loc14 + "_" + loc15 + ":0");
                     setUVsToFace(loc16[param4 - loc15][loc14],loc16[param4 - loc15 - 1][loc14],loc16[param4 - loc15 - 1][loc14 + 1],"back" + loc14 + "_" + loc15 + ":0");
                     createFace([loc14 + 1 + "_" + (loc15 + 1),loc14 + 1 + "_" + loc15,loc14 + "_" + loc15],"back" + loc14 + "_" + loc15 + ":1");
                     setUVsToFace(loc16[param4 - loc15 - 1][loc14 + 1],loc16[param4 - loc15][loc14 + 1],loc16[param4 - loc15][loc14],"back" + loc14 + "_" + loc15 + ":1");
                     loc18.addFace("back" + loc14 + "_" + loc15 + ":0");
                     loc18.addFace("back" + loc14 + "_" + loc15 + ":1");
                  }
                  else
                  {
                     createFace([loc14 + "_" + loc15,loc14 + "_" + (loc15 + 1),loc14 + 1 + "_" + (loc15 + 1),loc14 + 1 + "_" + loc15],"back" + loc14 + "_" + loc15);
                     setUVsToFace(loc16[param4 - loc15][loc14],loc16[param4 - loc15 - 1][loc14],loc16[param4 - loc15 - 1][loc14 + 1],"back" + loc14 + "_" + loc15);
                     loc18.addFace("back" + loc14 + "_" + loc15);
                  }
               }
               loc14++;
            }
            loc15++;
         }
      }
      
      override protected function createEmptyObject() : Object3D
      {
         return new Plane(0,0,0);
      }
      
      override protected function defaultName() : String
      {
         return "plane" + ++counter;
      }
   }
}

