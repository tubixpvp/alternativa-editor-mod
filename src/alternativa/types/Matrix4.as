package alternativa.types
{
   public final class Matrix4
   {
      public var a:Number;
      
      public var b:Number;
      
      public var c:Number;
      
      public var d:Number;
      
      public var f:Number;
      
      public var g:Number;
      
      public var h:Number;
      
      public var i:Number;
      
      public var j:Number;
      
      public var k:Number;
      
      public var e:Number;
      
      public var l:Number;
      
      public function Matrix4(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:Number = 1, param12:Number = 0)
      {
         super();
         this.a = param1;
         this.b = param2;
         this.c = param3;
         this.d = param4;
         this.e = param5;
         this.f = param6;
         this.g = param7;
         this.h = param8;
         this.i = param9;
         this.j = param10;
         this.k = param11;
         this.l = param12;
      }
      
      public static function inverseTranslationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Matrix4
      {
         return new Matrix4(1,0,0,-param1,0,1,0,-param2,0,0,1,-param3);
      }
      
      public static function translationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Matrix4
      {
         return new Matrix4(1,0,0,param1,0,1,0,param2,0,0,1,param3);
      }
      
      public static function axisAngleToMatrix(param1:Point3D, param2:Number = 0) : Matrix4
      {
         var loc3:Number = Math.cos(param2);
         var loc4:Number = Math.sin(param2);
         var loc5:Number = 1 - loc3;
         var loc6:Number = param1.x;
         var loc7:Number = param1.y;
         var loc8:Number = param1.z;
         return new Matrix4(loc5 * loc6 * loc6 + loc3,loc5 * loc6 * loc7 - loc8 * loc4,loc5 * loc6 * loc8 + loc7 * loc4,0,loc5 * loc6 * loc7 + loc8 * loc4,loc5 * loc7 * loc7 + loc3,loc5 * loc7 * loc8 - loc6 * loc4,0,loc5 * loc6 * loc8 - loc7 * loc4,loc5 * loc7 * loc8 + loc6 * loc4,loc5 * loc8 * loc8 + loc3,0);
      }
      
      public static function inverseRotationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Matrix4
      {
         var loc4:Number = Math.cos(param1);
         var loc5:Number = Math.sin(-param1);
         var loc6:Number = Math.cos(param2);
         var loc7:Number = Math.sin(-param2);
         var loc8:Number = Math.cos(param3);
         var loc9:Number = Math.sin(-param3);
         var loc10:Number = loc5 * loc7;
         return new Matrix4(loc6 * loc8,-loc6 * loc9,loc7,0,loc4 * loc9 + loc10 * loc8,loc4 * loc8 - loc10 * loc9,-loc5 * loc6,0,loc5 * loc9 - loc4 * loc8 * loc7,loc5 * loc8 + loc4 * loc7 * loc9,loc4 * loc6,0);
      }
      
      public static function inverseTransformationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1) : Matrix4
      {
         var loc10:Number = Math.cos(-param4);
         var loc11:Number = Math.sin(-param4);
         var loc12:Number = Math.cos(-param5);
         var loc13:Number = Math.sin(-param5);
         var loc14:Number = Math.cos(-param6);
         var loc15:Number = Math.sin(-param6);
         var loc16:Number = loc11 * loc13;
         var loc17:Number = 1 / param7;
         var loc18:Number = 1 / param8;
         var loc19:Number = 1 / param9;
         var loc20:Number = loc12 * loc17;
         var loc21:Number = loc10 * loc18;
         var loc22:Number = loc11 * loc19;
         var loc23:Number = loc10 * loc19;
         var loc24:Number = loc14 * loc20;
         var loc25:Number = -loc15 * loc20;
         var loc26:Number = loc13 * loc17;
         var loc27:Number = loc15 * loc21 + loc16 * loc14 * loc18;
         var loc28:Number = loc14 * loc21 - loc16 * loc15 * loc18;
         var loc29:Number = -loc11 * loc12 * loc18;
         var loc30:Number = loc15 * loc22 - loc14 * loc13 * loc23;
         var loc31:Number = loc14 * loc22 + loc13 * loc15 * loc23;
         var loc32:Number = loc12 * loc23;
         return new Matrix4(loc24,loc25,loc26,-(loc24 * param1 + loc25 * param2 + loc26 * param3),loc27,loc28,loc29,-(loc27 * param1 + loc28 * param2 + loc29 * param3),loc30,loc31,loc32,-(loc30 * param1 + loc31 * param2 + loc32 * param3));
      }
      
      public static function inverseMatrix(param1:Matrix4) : Matrix4
      {
         var loc2:Number = -param1.c * param1.f * param1.i + param1.b * param1.g * param1.i + param1.c * param1.e * param1.j - param1.a * param1.g * param1.j - param1.b * param1.e * param1.k + param1.a * param1.f * param1.k;
         var loc3:Number = (-param1.g * param1.j + param1.f * param1.k) / loc2;
         var loc4:Number = (param1.c * param1.j - param1.b * param1.k) / loc2;
         var loc5:Number = (-param1.c * param1.f + param1.b * param1.g) / loc2;
         var loc6:Number = (param1.d * param1.g * param1.j - param1.c * param1.h * param1.j - param1.d * param1.f * param1.k + param1.b * param1.h * param1.k + param1.c * param1.f * param1.l - param1.b * param1.g * param1.l) / loc2;
         var loc7:Number = (param1.g * param1.i - param1.e * param1.k) / loc2;
         var loc8:Number = (-param1.c * param1.i + param1.a * param1.k) / loc2;
         var loc9:Number = (param1.c * param1.e - param1.a * param1.g) / loc2;
         var loc10:Number = (param1.c * param1.h * param1.i - param1.d * param1.g * param1.i + param1.d * param1.e * param1.k - param1.a * param1.h * param1.k - param1.c * param1.e * param1.l + param1.a * param1.g * param1.l) / loc2;
         var loc11:Number = (-param1.f * param1.i + param1.e * param1.j) / loc2;
         var loc12:Number = (param1.b * param1.i - param1.a * param1.j) / loc2;
         var loc13:Number = (-param1.b * param1.e + param1.a * param1.f) / loc2;
         var loc14:Number = (param1.d * param1.f * param1.i - param1.b * param1.h * param1.i - param1.d * param1.e * param1.j + param1.a * param1.h * param1.j + param1.b * param1.e * param1.l - param1.a * param1.f * param1.l) / loc2;
         return new Matrix4(loc3,loc4,loc5,loc6,loc7,loc8,loc9,loc10,loc11,loc12,loc13,loc14);
      }
      
      public static function inverseScaleMatrix(param1:Number = 1, param2:Number = 1, param3:Number = 1) : Matrix4
      {
         return new Matrix4(1 / param1,0,0,0,0,1 / param2,0,0,0,0,1 / param3,0);
      }
      
      public static function scaleMatrix(param1:Number = 1, param2:Number = 1, param3:Number = 1) : Matrix4
      {
         return new Matrix4(param1,0,0,0,0,param2,0,0,0,0,param3,0);
      }
      
      public static function transformationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1) : Matrix4
      {
         var loc10:Number = Math.cos(param4);
         var loc11:Number = Math.sin(param4);
         var loc12:Number = Math.cos(param5);
         var loc13:Number = Math.sin(param5);
         var loc14:Number = Math.cos(param6);
         var loc15:Number = Math.sin(param6);
         var loc16:Number = loc14 * loc13;
         var loc17:Number = loc15 * loc13;
         var loc18:Number = loc12 * param7;
         var loc19:Number = loc11 * param8;
         var loc20:Number = loc10 * param8;
         var loc21:Number = loc10 * param9;
         var loc22:Number = loc11 * param9;
         return new Matrix4(loc14 * loc18,loc16 * loc19 - loc15 * loc20,loc16 * loc21 + loc15 * loc22,param1,loc15 * loc18,loc17 * loc19 + loc14 * loc20,loc17 * loc21 - loc14 * loc22,param2,-loc13 * param7,loc12 * loc19,loc12 * loc21,param3);
      }
      
      public static function product(param1:Matrix4, param2:Matrix4) : Matrix4
      {
         return new Matrix4(param1.a * param2.a + param1.b * param2.e + param1.c * param2.i,param1.a * param2.b + param1.b * param2.f + param1.c * param2.j,param1.a * param2.c + param1.b * param2.g + param1.c * param2.k,param1.a * param2.d + param1.b * param2.h + param1.c * param2.l + param1.d,param1.e * param2.a + param1.f * param2.e + param1.g * param2.i,param1.e * param2.b + param1.f * param2.f + param1.g * param2.j,param1.e * param2.c + param1.f * param2.g + param1.g * param2.k,param1.e * param2.d + param1.f * param2.h + param1.g * param2.l + param1.h,param1.i * param2.a + param1.j * param2.e + param1.k * param2.i,param1.i * param2.b + param1.j * param2.f + param1.k * param2.j,param1.i * param2.c + param1.j * param2.g + param1.k * param2.k,param1.i * param2.d + param1.j * param2.h + param1.k * param2.l + param1.l);
      }
      
      public static function rotationMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Matrix4
      {
         var loc4:Number = Math.cos(param1);
         var loc5:Number = Math.sin(param1);
         var loc6:Number = Math.cos(param2);
         var loc7:Number = Math.sin(param2);
         var loc8:Number = Math.cos(param3);
         var loc9:Number = Math.sin(param3);
         var loc10:Number = loc8 * loc7;
         var loc11:Number = loc9 * loc7;
         return new Matrix4(loc8 * loc6,loc10 * loc5 - loc9 * loc4,loc10 * loc4 + loc9 * loc5,0,loc9 * loc6,loc11 * loc5 + loc8 * loc4,loc11 * loc4 - loc8 * loc5,0,-loc7,loc6 * loc5,loc6 * loc4,0);
      }
      
      public function transform(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1) : void
      {
         var loc10:Number = Math.cos(param4);
         var loc11:Number = Math.sin(param4);
         var loc12:Number = Math.cos(param5);
         var loc13:Number = Math.sin(param5);
         var loc14:Number = Math.cos(param6);
         var loc15:Number = Math.sin(param6);
         var loc16:Number = loc14 * loc13;
         var loc17:Number = loc15 * loc13;
         var loc18:Number = loc12 * param7;
         var loc19:Number = loc11 * param8;
         var loc20:Number = loc10 * param8;
         var loc21:Number = loc10 * param9;
         var loc22:Number = loc11 * param9;
         var loc23:Number = loc14 * loc18;
         var loc24:Number = loc16 * loc19 - loc15 * loc20;
         var loc25:Number = loc16 * loc21 + loc15 * loc22;
         var loc26:Number = param1;
         var loc27:Number = loc15 * loc18;
         var loc28:Number = loc17 * loc19 + loc14 * loc20;
         var loc29:Number = loc17 * loc21 - loc14 * loc22;
         var loc30:Number = param2;
         var loc31:Number = -loc13 * param7;
         var loc32:Number = loc12 * loc19;
         var loc33:Number = loc12 * loc21;
         var loc34:Number = param3;
         var loc35:Number = a;
         var loc36:Number = b;
         var loc37:Number = c;
         var loc38:Number = d;
         var loc39:Number = e;
         var loc40:Number = f;
         var loc41:Number = g;
         var loc42:Number = h;
         var loc43:Number = i;
         var loc44:Number = j;
         var loc45:Number = k;
         var loc46:Number = l;
         a = loc23 * loc35 + loc24 * loc39 + loc25 * loc43;
         b = loc23 * loc36 + loc24 * loc40 + loc25 * loc44;
         c = loc23 * loc37 + loc24 * loc41 + loc25 * loc45;
         d = loc23 * loc38 + loc24 * loc42 + loc25 * loc46 + loc26;
         e = loc27 * loc35 + loc28 * loc39 + loc29 * loc43;
         f = loc27 * loc36 + loc28 * loc40 + loc29 * loc44;
         g = loc27 * loc37 + loc28 * loc41 + loc29 * loc45;
         h = loc27 * loc38 + loc28 * loc42 + loc29 * loc46 + loc30;
         i = loc31 * loc35 + loc32 * loc39 + loc33 * loc43;
         j = loc31 * loc36 + loc32 * loc40 + loc33 * loc44;
         k = loc31 * loc37 + loc32 * loc41 + loc33 * loc45;
         l = loc31 * loc38 + loc32 * loc42 + loc33 * loc46 + loc34;
      }
      
      public function offset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         d = param1;
         h = param2;
         l = param3;
      }
      
      public function getAxis(param1:int, param2:Point3D) : void
      {
         switch(param1)
         {
            case 0:
               param2.x = a;
               param2.y = e;
               param2.z = i;
               return;
            case 1:
               param2.x = b;
               param2.y = f;
               param2.z = j;
               return;
            case 2:
               param2.x = c;
               param2.y = g;
               param2.z = k;
               return;
            case 3:
               param2.x = d;
               param2.y = h;
               param2.z = l;
               return;
            default:
               return;
         }
      }
      
      public function inverseTransform(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1) : void
      {
         var loc10:Number = Math.cos(param4);
         var loc11:Number = Math.sin(-param4);
         var loc12:Number = Math.cos(param5);
         var loc13:Number = Math.sin(-param5);
         var loc14:Number = Math.cos(param6);
         var loc15:Number = Math.sin(-param6);
         var loc16:Number = loc11 * loc13;
         var loc17:Number = 1 / param7;
         var loc18:Number = 1 / param8;
         var loc19:Number = 1 / param9;
         var loc20:Number = loc12 * loc17;
         var loc21:Number = loc10 * loc18;
         var loc22:Number = loc11 * loc19;
         var loc23:Number = loc10 * loc19;
         var loc24:Number = loc14 * loc20;
         var loc25:Number = -loc15 * loc20;
         var loc26:Number = loc13 * loc17;
         var loc27:Number = -(loc24 * param1 + loc25 * param2 + loc26 * param3);
         var loc28:Number = loc15 * loc21 + loc16 * loc14 * loc18;
         var loc29:Number = loc14 * loc21 - loc16 * loc15 * loc18;
         var loc30:Number = -loc11 * loc12 * loc18;
         var loc31:Number = -(loc28 * param1 + loc29 * param2 + loc30 * param3);
         var loc32:Number = loc15 * loc22 - loc14 * loc13 * loc23;
         var loc33:Number = loc14 * loc22 + loc13 * loc15 * loc23;
         var loc34:Number = loc12 * loc23;
         var loc35:Number = -(loc32 * param1 + loc33 * param2 + loc34 * param3);
         var loc36:Number = a;
         var loc37:Number = b;
         var loc38:Number = c;
         var loc39:Number = d;
         var loc40:Number = e;
         var loc41:Number = f;
         var loc42:Number = g;
         var loc43:Number = h;
         var loc44:Number = i;
         var loc45:Number = j;
         var loc46:Number = k;
         var loc47:Number = l;
         a = loc24 * loc36 + loc25 * loc40 + loc26 * loc44;
         b = loc24 * loc37 + loc25 * loc41 + loc26 * loc45;
         c = loc24 * loc38 + loc25 * loc42 + loc26 * loc46;
         d = loc24 * loc39 + loc25 * loc43 + loc26 * loc47 + loc27;
         e = loc28 * loc36 + loc29 * loc40 + loc30 * loc44;
         f = loc28 * loc37 + loc29 * loc41 + loc30 * loc45;
         g = loc28 * loc38 + loc29 * loc42 + loc30 * loc46;
         h = loc28 * loc39 + loc29 * loc43 + loc30 * loc47 + loc31;
         i = loc32 * loc36 + loc33 * loc40 + loc34 * loc44;
         j = loc32 * loc37 + loc33 * loc41 + loc34 * loc45;
         k = loc32 * loc38 + loc33 * loc42 + loc34 * loc46;
         l = loc32 * loc39 + loc33 * loc43 + loc34 * loc47 + loc35;
      }
      
      public function add(param1:Matrix4) : void
      {
         a += param1.a;
         b += param1.b;
         c += param1.c;
         d += param1.d;
         e += param1.e;
         f += param1.f;
         g += param1.g;
         h += param1.h;
         i += param1.i;
         j += param1.j;
         k += param1.k;
         l += param1.l;
      }
      
      public function fromAxisAngle(param1:Point3D, param2:Number = 0) : void
      {
         var loc3:Number = Math.cos(param2);
         var loc4:Number = Math.sin(param2);
         var loc5:Number = 1 - loc3;
         var loc6:Number = param1.x;
         var loc7:Number = param1.y;
         var loc8:Number = param1.z;
         a = loc5 * loc6 * loc6 + loc3;
         b = loc5 * loc6 * loc7 - loc8 * loc4;
         c = loc5 * loc6 * loc8 + loc7 * loc4;
         d = 0;
         e = loc5 * loc6 * loc7 + loc8 * loc4;
         f = loc5 * loc7 * loc7 + loc3;
         g = loc5 * loc7 * loc8 - loc6 * loc4;
         h = 0;
         i = loc5 * loc6 * loc8 - loc7 * loc4;
         j = loc5 * loc7 * loc8 + loc6 * loc4;
         k = loc5 * loc8 * loc8 + loc3;
         l = 0;
      }
      
      public function inverseRotate(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         var loc4:Number = Math.cos(param1);
         var loc5:Number = Math.sin(-param1);
         var loc6:Number = Math.cos(param2);
         var loc7:Number = Math.sin(-param2);
         var loc8:Number = Math.cos(param3);
         var loc9:Number = Math.sin(-param3);
         var loc10:Number = loc5 * loc7;
         var loc11:Number = loc6 * loc8;
         var loc12:Number = -loc6 * loc9;
         var loc13:Number = loc7;
         var loc14:Number = loc4 * loc9 + loc10 * loc8;
         var loc15:Number = loc4 * loc8 - loc10 * loc9;
         var loc16:Number = -loc5 * loc6;
         var loc17:Number = loc5 * loc9 - loc4 * loc8 * loc7;
         var loc18:Number = loc5 * loc8 + loc4 * loc7 * loc9;
         var loc19:Number = loc4 * loc6;
         var loc20:Number = a;
         var loc21:Number = b;
         var loc22:Number = c;
         var loc23:Number = d;
         var loc24:Number = e;
         var loc25:Number = f;
         var loc26:Number = g;
         var loc27:Number = h;
         var loc28:Number = i;
         var loc29:Number = j;
         var loc30:Number = k;
         var loc31:Number = l;
         a = loc11 * loc20 + loc12 * loc24 + loc13 * loc28;
         b = loc11 * loc21 + loc12 * loc25 + loc13 * loc29;
         c = loc11 * loc22 + loc12 * loc26 + loc13 * loc30;
         d = loc11 * loc23 + loc12 * loc27 + loc13 * loc31;
         e = loc14 * loc20 + loc15 * loc24 + loc16 * loc28;
         f = loc14 * loc21 + loc15 * loc25 + loc16 * loc29;
         g = loc14 * loc22 + loc15 * loc26 + loc16 * loc30;
         h = loc14 * loc23 + loc15 * loc27 + loc16 * loc31;
         i = loc17 * loc20 + loc18 * loc24 + loc19 * loc28;
         j = loc17 * loc21 + loc18 * loc25 + loc19 * loc29;
         k = loc17 * loc22 + loc18 * loc26 + loc19 * loc30;
         l = loc17 * loc23 + loc18 * loc27 + loc19 * loc31;
      }
      
      public function toTransform(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1) : void
      {
         var loc10:Number = Math.cos(param4);
         var loc11:Number = Math.sin(param4);
         var loc12:Number = Math.cos(param5);
         var loc13:Number = Math.sin(param5);
         var loc14:Number = Math.cos(param6);
         var loc15:Number = Math.sin(param6);
         var loc16:Number = loc14 * loc13;
         var loc17:Number = loc15 * loc13;
         var loc18:Number = loc12 * param7;
         var loc19:Number = loc11 * param8;
         var loc20:Number = loc10 * param8;
         var loc21:Number = loc10 * param9;
         var loc22:Number = loc11 * param9;
         a = loc14 * loc18;
         b = loc16 * loc19 - loc15 * loc20;
         c = loc16 * loc21 + loc15 * loc22;
         d = param1;
         e = loc15 * loc18;
         f = loc17 * loc19 + loc14 * loc20;
         g = loc17 * loc21 - loc14 * loc22;
         h = param2;
         i = -loc13 * param7;
         j = loc12 * loc19;
         k = loc12 * loc21;
         l = param3;
      }
      
      public function transpose() : void
      {
         var loc1:Number = b;
         b = e;
         e = loc1;
         loc1 = c;
         c = i;
         i = loc1;
         loc1 = g;
         g = j;
         j = loc1;
      }
      
      public function translateLocal(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         d += a * param1 + b * param2 + c * param3;
         h += e * param1 + f * param2 + g * param3;
         l += i * param1 + j * param2 + k * param3;
      }
      
      public function equals(param1:Matrix4, param2:Number = 0) : Boolean
      {
         var loc3:Number = a - param1.a;
         var loc4:Number = b - param1.b;
         var loc5:Number = c - param1.c;
         var loc6:Number = d - param1.d;
         var loc7:Number = e - param1.e;
         var loc8:Number = f - param1.f;
         var loc9:Number = g - param1.g;
         var loc10:Number = h - param1.h;
         var loc11:Number = i - param1.i;
         var loc12:Number = j - param1.j;
         var loc13:Number = k - param1.k;
         var loc14:Number = l - param1.l;
         loc3 = loc3 < 0 ? -loc3 : loc3;
         loc4 = loc4 < 0 ? -loc4 : loc4;
         loc5 = loc5 < 0 ? -loc5 : loc5;
         loc6 = loc6 < 0 ? -loc6 : loc6;
         loc7 = loc7 < 0 ? -loc7 : loc7;
         loc8 = loc8 < 0 ? -loc8 : loc8;
         loc9 = loc9 < 0 ? -loc9 : loc9;
         loc10 = loc10 < 0 ? -loc10 : loc10;
         loc11 = loc11 < 0 ? -loc11 : loc11;
         loc12 = loc12 < 0 ? -loc12 : loc12;
         loc13 = loc13 < 0 ? -loc13 : loc13;
         loc14 = loc14 < 0 ? -loc14 : loc14;
         return loc3 <= param2 && loc4 <= param2 && loc5 <= param2 && loc6 <= param2 && loc7 <= param2 && loc8 <= param2 && loc9 <= param2 && loc10 <= param2 && loc11 <= param2 && loc12 <= param2 && loc13 <= param2 && loc14 <= param2;
      }
      
      public function scale(param1:Number = 1, param2:Number = 1, param3:Number = 1) : void
      {
         a *= param1;
         b *= param1;
         c *= param1;
         d *= param1;
         e *= param2;
         f *= param2;
         g *= param2;
         h *= param2;
         i *= param3;
         j *= param3;
         k *= param3;
         l *= param3;
      }
      
      public function translate(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         d += param1;
         h += param2;
         l += param3;
      }
      
      public function combine(param1:Matrix4) : void
      {
         var loc2:Number = a;
         var loc3:Number = b;
         var loc4:Number = c;
         var loc5:Number = d;
         var loc6:Number = e;
         var loc7:Number = f;
         var loc8:Number = g;
         var loc9:Number = h;
         var loc10:Number = i;
         var loc11:Number = j;
         var loc12:Number = k;
         var loc13:Number = l;
         a = param1.a * loc2 + param1.b * loc6 + param1.c * loc10;
         b = param1.a * loc3 + param1.b * loc7 + param1.c * loc11;
         c = param1.a * loc4 + param1.b * loc8 + param1.c * loc12;
         d = param1.a * loc5 + param1.b * loc9 + param1.c * loc13 + param1.d;
         e = param1.e * loc2 + param1.f * loc6 + param1.g * loc10;
         f = param1.e * loc3 + param1.f * loc7 + param1.g * loc11;
         g = param1.e * loc4 + param1.f * loc8 + param1.g * loc12;
         h = param1.e * loc5 + param1.f * loc9 + param1.g * loc13 + param1.h;
         i = param1.i * loc2 + param1.j * loc6 + param1.k * loc10;
         j = param1.i * loc3 + param1.j * loc7 + param1.k * loc11;
         k = param1.i * loc4 + param1.j * loc8 + param1.k * loc12;
         l = param1.i * loc5 + param1.j * loc9 + param1.k * loc13 + param1.l;
      }
      
      public function toIdentity() : void
      {
         a = f = k = 1;
         b = c = d = e = g = h = i = j = l = 0;
      }
      
      public function rotate(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         var loc4:Number = Math.cos(param1);
         var loc5:Number = Math.sin(param1);
         var loc6:Number = Math.cos(param2);
         var loc7:Number = Math.sin(param2);
         var loc8:Number = Math.cos(param3);
         var loc9:Number = Math.sin(param3);
         var loc10:Number = loc8 * loc7;
         var loc11:Number = loc9 * loc7;
         var loc12:Number = loc8 * loc6;
         var loc13:Number = loc10 * loc5 - loc9 * loc4;
         var loc14:Number = loc10 * loc4 + loc9 * loc5;
         var loc15:Number = loc9 * loc6;
         var loc16:Number = loc11 * loc5 + loc8 * loc4;
         var loc17:Number = loc11 * loc4 - loc8 * loc5;
         var loc18:Number = -loc7;
         var loc19:Number = loc6 * loc5;
         var loc20:Number = loc6 * loc4;
         var loc21:Number = a;
         var loc22:Number = b;
         var loc23:Number = c;
         var loc24:Number = d;
         var loc25:Number = e;
         var loc26:Number = f;
         var loc27:Number = g;
         var loc28:Number = h;
         var loc29:Number = i;
         var loc30:Number = j;
         var loc31:Number = k;
         var loc32:Number = l;
         a = loc12 * loc21 + loc13 * loc25 + loc14 * loc29;
         b = loc12 * loc22 + loc13 * loc26 + loc14 * loc30;
         c = loc12 * loc23 + loc13 * loc27 + loc14 * loc31;
         d = loc12 * loc24 + loc13 * loc28 + loc14 * loc32;
         e = loc15 * loc21 + loc16 * loc25 + loc17 * loc29;
         f = loc15 * loc22 + loc16 * loc26 + loc17 * loc30;
         g = loc15 * loc23 + loc16 * loc27 + loc17 * loc31;
         h = loc15 * loc24 + loc16 * loc28 + loc17 * loc32;
         i = loc18 * loc21 + loc19 * loc25 + loc20 * loc29;
         j = loc18 * loc22 + loc19 * loc26 + loc20 * loc30;
         k = loc18 * loc23 + loc19 * loc27 + loc20 * loc31;
         l = loc18 * loc24 + loc19 * loc28 + loc20 * loc32;
      }
      
      public function clone() : Matrix4
      {
         return new Matrix4(a,b,c,d,e,f,g,h,i,j,k,l);
      }
      
      public function invert() : void
      {
         var loc1:Number = a;
         var loc2:Number = b;
         var loc3:Number = c;
         var loc4:Number = d;
         var loc5:Number = e;
         var loc6:Number = f;
         var loc7:Number = g;
         var loc8:Number = h;
         var loc9:Number = i;
         var loc10:Number = j;
         var loc11:Number = k;
         var loc12:Number = l;
         var loc13:Number = -loc3 * loc6 * loc9 + loc2 * loc7 * loc9 + loc3 * loc5 * loc10 - loc1 * loc7 * loc10 - loc2 * loc5 * loc11 + loc1 * loc6 * loc11;
         a = (-loc7 * loc10 + loc6 * loc11) / loc13;
         b = (loc3 * loc10 - loc2 * loc11) / loc13;
         c = (-loc3 * loc6 + loc2 * loc7) / loc13;
         d = (loc4 * loc7 * loc10 - loc3 * loc8 * loc10 - loc4 * loc6 * loc11 + loc2 * loc8 * loc11 + loc3 * loc6 * loc12 - loc2 * loc7 * loc12) / loc13;
         e = (loc7 * loc9 - loc5 * loc11) / loc13;
         f = (-loc3 * loc9 + loc1 * loc11) / loc13;
         g = (loc3 * loc5 - loc1 * loc7) / loc13;
         h = (loc3 * loc8 * loc9 - loc4 * loc7 * loc9 + loc4 * loc5 * loc11 - loc1 * loc8 * loc11 - loc3 * loc5 * loc12 + loc1 * loc7 * loc12) / loc13;
         i = (-loc6 * loc9 + loc5 * loc10) / loc13;
         j = (loc2 * loc9 - loc1 * loc10) / loc13;
         k = (-loc2 * loc5 + loc1 * loc6) / loc13;
         l = (loc4 * loc6 * loc9 - loc2 * loc8 * loc9 - loc4 * loc5 * loc10 + loc1 * loc8 * loc10 + loc2 * loc5 * loc12 - loc1 * loc6 * loc12) / loc13;
      }
      
      public function toString() : String
      {
         return "[Matrix3D " + "[" + a.toFixed(3) + " " + b.toFixed(3) + " " + c.toFixed(3) + " " + d.toFixed(3) + "] [" + e.toFixed(3) + " " + f.toFixed(3) + " " + g.toFixed(3) + " " + h.toFixed(3) + "] [" + i.toFixed(3) + " " + j.toFixed(3) + " " + k.toFixed(3) + " " + l.toFixed(3) + "]]";
      }
      
      public function inverseCombine(param1:Matrix4) : void
      {
         var loc2:Number = a;
         var loc3:Number = b;
         var loc4:Number = c;
         var loc5:Number = d;
         var loc6:Number = e;
         var loc7:Number = f;
         var loc8:Number = g;
         var loc9:Number = h;
         var loc10:Number = i;
         var loc11:Number = j;
         var loc12:Number = k;
         var loc13:Number = l;
         a = loc2 * param1.a + loc3 * param1.e + loc4 * param1.i;
         b = loc2 * param1.b + loc3 * param1.f + loc4 * param1.j;
         c = loc2 * param1.c + loc3 * param1.g + loc4 * param1.k;
         d = loc2 * param1.d + loc3 * param1.h + loc4 * param1.l + loc5;
         e = loc6 * param1.a + loc7 * param1.e + loc8 * param1.i;
         f = loc6 * param1.b + loc7 * param1.f + loc8 * param1.j;
         g = loc6 * param1.c + loc7 * param1.g + loc8 * param1.k;
         h = loc6 * param1.d + loc7 * param1.h + loc8 * param1.l + loc9;
         i = loc10 * param1.a + loc11 * param1.e + loc12 * param1.i;
         j = loc10 * param1.b + loc11 * param1.f + loc12 * param1.j;
         k = loc10 * param1.c + loc11 * param1.g + loc12 * param1.k;
         l = loc10 * param1.d + loc11 * param1.h + loc12 * param1.l + loc13;
      }
      
      public function setVectors(param1:Point3D, param2:Point3D, param3:Point3D, param4:Point3D) : void
      {
         a = param1.x;
         e = param1.y;
         i = param1.z;
         b = param2.x;
         f = param2.y;
         j = param2.z;
         c = param3.x;
         g = param3.y;
         k = param3.z;
         d = param4.x;
         h = param4.y;
         l = param4.z;
      }
      
      public function multByScalar(param1:Number) : void
      {
         a *= param1;
         b *= param1;
         c *= param1;
         d *= param1;
         e *= param1;
         f *= param1;
         g *= param1;
         h *= param1;
         i *= param1;
         j *= param1;
         k *= param1;
         l *= param1;
      }
      
      public function copy(param1:Matrix4) : void
      {
         a = param1.a;
         b = param1.b;
         c = param1.c;
         d = param1.d;
         e = param1.e;
         f = param1.f;
         g = param1.g;
         h = param1.h;
         i = param1.i;
         j = param1.j;
         k = param1.k;
         l = param1.l;
      }
      
      public function deltaTransformVector(param1:Point3D, param2:Point3D) : void
      {
         param2.x = a * param1.x + b * param1.y + c * param1.z + d;
         param2.y = e * param1.x + f * param1.y + g * param1.z + h;
         param2.z = i * param1.x + j * param1.y + k * param1.z + l;
      }
      
      public function inverseScale(param1:Number = 1, param2:Number = 1, param3:Number = 1) : void
      {
         var loc4:Number = 1 / param1;
         var loc5:Number = 1 / param2;
         var loc6:Number = 1 / param3;
         a *= loc4;
         b *= loc4;
         c *= loc4;
         d *= loc4;
         e *= loc5;
         f *= loc5;
         g *= loc5;
         h *= loc5;
         i *= loc6;
         j *= loc6;
         k *= loc6;
         l *= loc6;
      }
      
      public function inverseTranslate(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         d -= param1;
         h -= param2;
         l -= param3;
      }
      
      public function getRotations(param1:Point3D = null) : Point3D
      {
         if(param1 == null)
         {
            param1 = new Point3D();
         }
         if(-1 < i && i < 1)
         {
            param1.x = Math.atan2(j,k);
            param1.y = -Math.asin(i);
            param1.z = Math.atan2(e,a);
         }
         else
         {
            param1.x = 0;
            param1.y = 0.5 * (i <= -1 ? Math.PI : -Math.PI);
            param1.z = Math.atan2(-b,f);
         }
         return param1;
      }
   }
}

