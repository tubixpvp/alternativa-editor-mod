package alternativa.engine3d.primitives
{
   import alternativa.engine3d.core.Mesh;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Surface;
   import flash.geom.Point;
   
   public class Box extends Mesh
   {
      private static var counter:uint = 0;
      
      public function Box(param1:Number = 100, param2:Number = 100, param3:Number = 100, param4:uint = 1, param5:uint = 1, param6:uint = 1, param7:Boolean = false, param8:Boolean = false)
      {
         var loc15:int = 0;
         var loc16:int = 0;
         var loc17:int = 0;
         var loc27:String = null;
         var loc28:Point = null;
         var loc29:Point = null;
         super();
         if(param4 == 0 || param5 == 0 || param6 == 0)
         {
            return;
         }
         param1 = param1 < 0 ? 0 : param1;
         param2 = param2 < 0 ? 0 : param2;
         param3 = param3 < 0 ? 0 : param3;
         var loc9:Number = param1 / 2;
         var loc10:Number = param2 / 2;
         var loc11:Number = param3 / 2;
         var loc12:Number = param1 / param4;
         var loc13:Number = param2 / param5;
         var loc14:Number = param3 / param6;
         loc15 = 0;
         while(loc15 <= param4)
         {
            loc16 = 0;
            while(loc16 <= param5)
            {
               loc17 = 0;
               while(loc17 <= param6)
               {
                  if(loc15 == 0 || loc15 == param4 || loc16 == 0 || loc16 == param5 || loc17 == 0 || loc17 == param6)
                  {
                     createVertex(loc15 * loc12 - loc9,loc16 * loc13 - loc10,loc17 * loc14 - loc11,loc15 + "_" + loc16 + "_" + loc17);
                  }
                  loc17++;
               }
               loc16++;
            }
            loc15++;
         }
         var loc18:Surface = createSurface(null,"front");
         var loc19:Surface = createSurface(null,"back");
         var loc20:Surface = createSurface(null,"left");
         var loc21:Surface = createSurface(null,"right");
         var loc22:Surface = createSurface(null,"top");
         var loc23:Surface = createSurface(null,"bottom");
         var loc24:Number = 1 / param4;
         var loc25:Number = 1 / param5;
         var loc26:Number = 1 / param6;
         loc16 = 0;
         while(loc16 < param5)
         {
            loc15 = 0;
            while(loc15 < param4)
            {
               loc27 = "top_" + loc15 + "_" + loc16;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point(loc15 * loc24,(param5 - loc16) * loc25);
                     loc29 = new Point((loc15 + 1) * loc24,(param5 - loc16 - 1) * loc25);
                     createFace([loc15 + "_" + loc16 + "_" + param6,loc15 + "_" + (loc16 + 1) + "_" + param6,loc15 + 1 + "_" + (loc16 + 1) + "_" + param6],loc27 + ":1");
                     setUVsToFace(loc28,new Point(loc15 * loc24,(param5 - loc16 - 1) * loc25),loc29,loc27 + ":1");
                     createFace([loc15 + 1 + "_" + (loc16 + 1) + "_" + param6,loc15 + 1 + "_" + loc16 + "_" + param6,loc15 + "_" + loc16 + "_" + param6],loc27 + ":0");
                     setUVsToFace(loc29,new Point((loc15 + 1) * loc24,(param5 - loc16) * loc25),loc28,loc27 + ":0");
                  }
                  else
                  {
                     createFace([loc15 + "_" + loc16 + "_" + param6,loc15 + "_" + (loc16 + 1) + "_" + param6,loc15 + 1 + "_" + (loc16 + 1) + "_" + param6,loc15 + 1 + "_" + loc16 + "_" + param6],loc27);
                     setUVsToFace(new Point(loc15 * loc24,(param5 - loc16) * loc25),new Point(loc15 * loc24,(param5 - loc16 - 1) * loc25),new Point((loc15 + 1) * loc24,(param5 - loc16 - 1) * loc25),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point(loc15 * loc24,loc16 * loc25);
                  loc29 = new Point((loc15 + 1) * loc24,(loc16 + 1) * loc25);
                  createFace([loc15 + "_" + loc16 + "_" + param6,loc15 + 1 + "_" + loc16 + "_" + param6,loc15 + 1 + "_" + (loc16 + 1) + "_" + param6],loc27 + ":0");
                  setUVsToFace(loc28,new Point((loc15 + 1) * loc24,loc16 * loc25),loc29,loc27 + ":0");
                  createFace([loc15 + 1 + "_" + (loc16 + 1) + "_" + param6,loc15 + "_" + (loc16 + 1) + "_" + param6,loc15 + "_" + loc16 + "_" + param6],loc27 + ":1");
                  setUVsToFace(loc29,new Point(loc15 * loc24,(loc16 + 1) * loc25),loc28,loc27 + ":1");
               }
               else
               {
                  createFace([loc15 + "_" + loc16 + "_" + param6,loc15 + 1 + "_" + loc16 + "_" + param6,loc15 + 1 + "_" + (loc16 + 1) + "_" + param6,loc15 + "_" + (loc16 + 1) + "_" + param6],loc27);
                  setUVsToFace(new Point(loc15 * loc24,loc16 * loc25),new Point((loc15 + 1) * loc24,loc16 * loc25),new Point((loc15 + 1) * loc24,(loc16 + 1) * loc25),loc27);
               }
               if(param8)
               {
                  loc22.addFace(loc27 + ":0");
                  loc22.addFace(loc27 + ":1");
               }
               else
               {
                  loc22.addFace(loc27);
               }
               loc15++;
            }
            loc16++;
         }
         loc16 = 0;
         while(loc16 < param5)
         {
            loc15 = 0;
            while(loc15 < param4)
            {
               loc27 = "bottom_" + loc15 + "_" + loc16;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point((param4 - loc15) * loc24,(param5 - loc16) * loc25);
                     loc29 = new Point((param4 - loc15 - 1) * loc24,(param5 - loc16 - 1) * loc25);
                     createFace([loc15 + "_" + loc16 + "_" + 0,loc15 + 1 + "_" + loc16 + "_" + 0,loc15 + 1 + "_" + (loc16 + 1) + "_" + 0],loc27 + ":0");
                     setUVsToFace(loc28,new Point((param4 - loc15 - 1) * loc24,(param5 - loc16) * loc25),loc29,loc27 + ":0");
                     createFace([loc15 + 1 + "_" + (loc16 + 1) + "_" + 0,loc15 + "_" + (loc16 + 1) + "_" + 0,loc15 + "_" + loc16 + "_" + 0],loc27 + ":1");
                     setUVsToFace(loc29,new Point((param4 - loc15) * loc24,(param5 - loc16 - 1) * loc25),loc28,loc27 + ":1");
                  }
                  else
                  {
                     createFace([loc15 + "_" + loc16 + "_" + 0,loc15 + 1 + "_" + loc16 + "_" + 0,loc15 + 1 + "_" + (loc16 + 1) + "_" + 0,loc15 + "_" + (loc16 + 1) + "_" + 0],loc27);
                     setUVsToFace(new Point((param4 - loc15) * loc24,(param5 - loc16) * loc25),new Point((param4 - loc15 - 1) * loc24,(param5 - loc16) * loc25),new Point((param4 - loc15 - 1) * loc24,(param5 - loc16 - 1) * loc25),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point((param4 - loc15) * loc24,loc16 * loc25);
                  loc29 = new Point((param4 - loc15 - 1) * loc24,(loc16 + 1) * loc25);
                  createFace([loc15 + "_" + loc16 + "_" + 0,loc15 + "_" + (loc16 + 1) + "_" + 0,loc15 + 1 + "_" + (loc16 + 1) + "_" + 0],loc27 + ":1");
                  setUVsToFace(loc28,new Point((param4 - loc15) * loc24,(loc16 + 1) * loc25),loc29,loc27 + ":1");
                  createFace([loc15 + 1 + "_" + (loc16 + 1) + "_" + 0,loc15 + 1 + "_" + loc16 + "_" + 0,loc15 + "_" + loc16 + "_" + 0],loc27 + ":0");
                  setUVsToFace(loc29,new Point((param4 - loc15 - 1) * loc24,loc16 * loc25),loc28,loc27 + ":0");
               }
               else
               {
                  createFace([loc15 + "_" + loc16 + "_" + 0,loc15 + "_" + (loc16 + 1) + "_" + 0,loc15 + 1 + "_" + (loc16 + 1) + "_" + 0,loc15 + 1 + "_" + loc16 + "_" + 0],loc27);
                  setUVsToFace(new Point((param4 - loc15) * loc24,loc16 * loc25),new Point((param4 - loc15) * loc24,(loc16 + 1) * loc25),new Point((param4 - loc15 - 1) * loc24,(loc16 + 1) * loc25),loc27);
               }
               if(param8)
               {
                  loc23.addFace(loc27 + ":0");
                  loc23.addFace(loc27 + ":1");
               }
               else
               {
                  loc23.addFace(loc27);
               }
               loc15++;
            }
            loc16++;
         }
         loc17 = 0;
         while(loc17 < param6)
         {
            loc15 = 0;
            while(loc15 < param4)
            {
               loc27 = "front_" + loc15 + "_" + loc17;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point((param4 - loc15) * loc24,loc17 * loc26);
                     loc29 = new Point((param4 - loc15 - 1) * loc24,(loc17 + 1) * loc26);
                     createFace([loc15 + "_" + 0 + "_" + loc17,loc15 + "_" + 0 + "_" + (loc17 + 1),loc15 + 1 + "_" + 0 + "_" + (loc17 + 1)],loc27 + ":1");
                     setUVsToFace(loc28,new Point((param4 - loc15) * loc24,(loc17 + 1) * loc26),loc29,loc27 + ":1");
                     createFace([loc15 + 1 + "_" + 0 + "_" + (loc17 + 1),loc15 + 1 + "_" + 0 + "_" + loc17,loc15 + "_" + 0 + "_" + loc17],loc27 + ":0");
                     setUVsToFace(loc29,new Point((param4 - loc15 - 1) * loc24,loc17 * loc26),loc28,loc27 + ":0");
                  }
                  else
                  {
                     createFace([loc15 + "_" + 0 + "_" + loc17,loc15 + "_" + 0 + "_" + (loc17 + 1),loc15 + 1 + "_" + 0 + "_" + (loc17 + 1),loc15 + 1 + "_" + 0 + "_" + loc17],loc27);
                     setUVsToFace(new Point((param4 - loc15) * loc24,loc17 * loc26),new Point((param4 - loc15) * loc24,(loc17 + 1) * loc26),new Point((param4 - loc15 - 1) * loc24,(loc17 + 1) * loc26),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point(loc15 * loc24,loc17 * loc26);
                  loc29 = new Point((loc15 + 1) * loc24,(loc17 + 1) * loc26);
                  createFace([loc15 + "_" + 0 + "_" + loc17,loc15 + 1 + "_" + 0 + "_" + loc17,loc15 + 1 + "_" + 0 + "_" + (loc17 + 1)],loc27 + ":0");
                  setUVsToFace(loc28,new Point((loc15 + 1) * loc24,loc17 * loc26),loc29,loc27 + ":0");
                  createFace([loc15 + 1 + "_" + 0 + "_" + (loc17 + 1),loc15 + "_" + 0 + "_" + (loc17 + 1),loc15 + "_" + 0 + "_" + loc17],loc27 + ":1");
                  setUVsToFace(loc29,new Point(loc15 * loc24,(loc17 + 1) * loc26),loc28,loc27 + ":1");
               }
               else
               {
                  createFace([loc15 + "_" + 0 + "_" + loc17,loc15 + 1 + "_" + 0 + "_" + loc17,loc15 + 1 + "_" + 0 + "_" + (loc17 + 1),loc15 + "_" + 0 + "_" + (loc17 + 1)],loc27);
                  setUVsToFace(new Point(loc15 * loc24,loc17 * loc26),new Point((loc15 + 1) * loc24,loc17 * loc26),new Point((loc15 + 1) * loc24,(loc17 + 1) * loc26),loc27);
               }
               if(param8)
               {
                  loc18.addFace(loc27 + ":0");
                  loc18.addFace(loc27 + ":1");
               }
               else
               {
                  loc18.addFace(loc27);
               }
               loc15++;
            }
            loc17++;
         }
         loc17 = 0;
         while(loc17 < param6)
         {
            loc15 = 0;
            while(loc15 < param4)
            {
               loc27 = "back_" + loc15 + "_" + loc17;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point(loc15 * loc24,(loc17 + 1) * loc26);
                     loc29 = new Point((loc15 + 1) * loc24,loc17 * loc26);
                     createFace([loc15 + "_" + param5 + "_" + (loc17 + 1),loc15 + "_" + param5 + "_" + loc17,loc15 + 1 + "_" + param5 + "_" + loc17],loc27 + ":0");
                     setUVsToFace(loc28,new Point(loc15 * loc24,loc17 * loc26),loc29,loc27 + ":0");
                     createFace([loc15 + 1 + "_" + param5 + "_" + loc17,loc15 + 1 + "_" + param5 + "_" + (loc17 + 1),loc15 + "_" + param5 + "_" + (loc17 + 1)],loc27 + ":1");
                     setUVsToFace(loc29,new Point((loc15 + 1) * loc24,(loc17 + 1) * loc26),loc28,loc27 + ":1");
                  }
                  else
                  {
                     createFace([loc15 + "_" + param5 + "_" + loc17,loc15 + 1 + "_" + param5 + "_" + loc17,loc15 + 1 + "_" + param5 + "_" + (loc17 + 1),loc15 + "_" + param5 + "_" + (loc17 + 1)],loc27);
                     setUVsToFace(new Point(loc15 * loc24,loc17 * loc26),new Point((loc15 + 1) * loc24,loc17 * loc26),new Point((loc15 + 1) * loc24,(loc17 + 1) * loc26),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point((param4 - loc15) * loc24,(loc17 + 1) * loc26);
                  loc29 = new Point((param4 - loc15 - 1) * loc24,loc17 * loc26);
                  createFace([loc15 + "_" + param5 + "_" + loc17,loc15 + "_" + param5 + "_" + (loc17 + 1),loc15 + 1 + "_" + param5 + "_" + loc17],loc27 + ":0");
                  setUVsToFace(new Point((param4 - loc15) * loc24,loc17 * loc26),loc28,loc29,loc27 + ":0");
                  createFace([loc15 + "_" + param5 + "_" + (loc17 + 1),loc15 + 1 + "_" + param5 + "_" + (loc17 + 1),loc15 + 1 + "_" + param5 + "_" + loc17],loc27 + ":1");
                  setUVsToFace(loc28,new Point((param4 - loc15 - 1) * loc24,(loc17 + 1) * loc26),loc29,loc27 + ":1");
               }
               else
               {
                  createFace([loc15 + "_" + param5 + "_" + loc17,loc15 + "_" + param5 + "_" + (loc17 + 1),loc15 + 1 + "_" + param5 + "_" + (loc17 + 1),loc15 + 1 + "_" + param5 + "_" + loc17],loc27);
                  setUVsToFace(new Point((param4 - loc15) * loc24,loc17 * loc26),new Point((param4 - loc15) * loc24,(loc17 + 1) * loc26),new Point((param4 - loc15 - 1) * loc24,(loc17 + 1) * loc26),loc27);
               }
               if(param8)
               {
                  loc19.addFace(loc27 + ":0");
                  loc19.addFace(loc27 + ":1");
               }
               else
               {
                  loc19.addFace(loc27);
               }
               loc15++;
            }
            loc17++;
         }
         loc16 = 0;
         while(loc16 < param5)
         {
            loc17 = 0;
            while(loc17 < param6)
            {
               loc27 = "left_" + loc16 + "_" + loc17;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point(loc16 * loc25,(loc17 + 1) * loc26);
                     loc29 = new Point((loc16 + 1) * loc25,loc17 * loc26);
                     createFace([0 + "_" + loc16 + "_" + (loc17 + 1),0 + "_" + loc16 + "_" + loc17,0 + "_" + (loc16 + 1) + "_" + loc17],loc27 + ":0");
                     setUVsToFace(loc28,new Point(loc16 * loc25,loc17 * loc26),loc29,loc27 + ":0");
                     createFace([0 + "_" + (loc16 + 1) + "_" + loc17,0 + "_" + (loc16 + 1) + "_" + (loc17 + 1),0 + "_" + loc16 + "_" + (loc17 + 1)],loc27 + ":1");
                     setUVsToFace(loc29,new Point((loc16 + 1) * loc25,(loc17 + 1) * loc26),loc28,loc27 + ":1");
                  }
                  else
                  {
                     createFace([0 + "_" + loc16 + "_" + loc17,0 + "_" + (loc16 + 1) + "_" + loc17,0 + "_" + (loc16 + 1) + "_" + (loc17 + 1),0 + "_" + loc16 + "_" + (loc17 + 1)],loc27);
                     setUVsToFace(new Point(loc16 * loc25,loc17 * loc26),new Point((loc16 + 1) * loc25,loc17 * loc26),new Point((loc16 + 1) * loc25,(loc17 + 1) * loc26),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point((param5 - loc16 - 1) * loc25,loc17 * loc26);
                  loc29 = new Point((param5 - loc16) * loc25,(loc17 + 1) * loc26);
                  createFace([0 + "_" + (loc16 + 1) + "_" + loc17,0 + "_" + loc16 + "_" + loc17,0 + "_" + loc16 + "_" + (loc17 + 1)],loc27 + ":0");
                  setUVsToFace(loc28,new Point((param5 - loc16) * loc25,loc17 * loc26),loc29,loc27 + ":0");
                  createFace([0 + "_" + loc16 + "_" + (loc17 + 1),0 + "_" + (loc16 + 1) + "_" + (loc17 + 1),0 + "_" + (loc16 + 1) + "_" + loc17],loc27 + ":1");
                  setUVsToFace(loc29,new Point((param5 - loc16 - 1) * loc25,(loc17 + 1) * loc26),loc28,loc27 + ":1");
               }
               else
               {
                  createFace([0 + "_" + loc16 + "_" + loc17,0 + "_" + loc16 + "_" + (loc17 + 1),0 + "_" + (loc16 + 1) + "_" + (loc17 + 1),0 + "_" + (loc16 + 1) + "_" + loc17],loc27);
                  setUVsToFace(new Point((param5 - loc16) * loc25,loc17 * loc26),new Point((param5 - loc16) * loc25,(loc17 + 1) * loc26),new Point((param5 - loc16 - 1) * loc25,(loc17 + 1) * loc26),loc27);
               }
               if(param8)
               {
                  loc20.addFace(loc27 + ":0");
                  loc20.addFace(loc27 + ":1");
               }
               else
               {
                  loc20.addFace(loc27);
               }
               loc17++;
            }
            loc16++;
         }
         loc16 = 0;
         while(loc16 < param5)
         {
            loc17 = 0;
            while(loc17 < param6)
            {
               loc27 = "right_" + loc16 + "_" + loc17;
               if(param7)
               {
                  if(param8)
                  {
                     loc28 = new Point((param5 - loc16) * loc25,loc17 * loc26);
                     loc29 = new Point((param5 - loc16 - 1) * loc25,(loc17 + 1) * loc26);
                     createFace([param4 + "_" + loc16 + "_" + loc17,param4 + "_" + loc16 + "_" + (loc17 + 1),param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1)],loc27 + ":1");
                     setUVsToFace(loc28,new Point((param5 - loc16) * loc25,(loc17 + 1) * loc26),loc29,loc27 + ":1");
                     createFace([param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1),param4 + "_" + (loc16 + 1) + "_" + loc17,param4 + "_" + loc16 + "_" + loc17],loc27 + ":0");
                     setUVsToFace(loc29,new Point((param5 - loc16 - 1) * loc25,loc17 * loc26),loc28,loc27 + ":0");
                  }
                  else
                  {
                     createFace([param4 + "_" + loc16 + "_" + loc17,param4 + "_" + loc16 + "_" + (loc17 + 1),param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1),param4 + "_" + (loc16 + 1) + "_" + loc17],loc27);
                     setUVsToFace(new Point((param5 - loc16) * loc25,loc17 * loc26),new Point((param5 - loc16) * loc25,(loc17 + 1) * loc26),new Point((param5 - loc16 - 1) * loc25,(loc17 + 1) * loc26),loc27);
                  }
               }
               else if(param8)
               {
                  loc28 = new Point(loc16 * loc25,loc17 * loc26);
                  loc29 = new Point((loc16 + 1) * loc25,(loc17 + 1) * loc26);
                  createFace([param4 + "_" + loc16 + "_" + loc17,param4 + "_" + (loc16 + 1) + "_" + loc17,param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1)],loc27 + ":0");
                  setUVsToFace(loc28,new Point((loc16 + 1) * loc25,loc17 * loc26),loc29,loc27 + ":0");
                  createFace([param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1),param4 + "_" + loc16 + "_" + (loc17 + 1),param4 + "_" + loc16 + "_" + loc17],loc27 + ":1");
                  setUVsToFace(loc29,new Point(loc16 * loc25,(loc17 + 1) * loc26),loc28,loc27 + ":1");
               }
               else
               {
                  createFace([param4 + "_" + loc16 + "_" + loc17,param4 + "_" + (loc16 + 1) + "_" + loc17,param4 + "_" + (loc16 + 1) + "_" + (loc17 + 1),param4 + "_" + loc16 + "_" + (loc17 + 1)],loc27);
                  setUVsToFace(new Point(loc16 * loc25,loc17 * loc26),new Point((loc16 + 1) * loc25,loc17 * loc26),new Point((loc16 + 1) * loc25,(loc17 + 1) * loc26),loc27);
               }
               if(param8)
               {
                  loc21.addFace(loc27 + ":0");
                  loc21.addFace(loc27 + ":1");
               }
               else
               {
                  loc21.addFace(loc27);
               }
               loc17++;
            }
            loc16++;
         }
      }
      
      override protected function createEmptyObject() : Object3D
      {
         return new Box(0,0,0,0);
      }
      
      override protected function defaultName() : String
      {
         return "box" + ++counter;
      }
   }
}

