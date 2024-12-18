package alternativa.types
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Object3D;
   
   public final class Point3D
   {
      public var z:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public function Point3D(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }

      public function toVector3D() : Vector3D
      {
         return new Vector3D(this.x,this.y,this.z);
      }
      public function copyToVector3D(vec:Vector3D) : Vector3D
      {
         vec.x = this.x;
         vec.y = this.y;
         vec.z = this.z;
         return vec;
      }

      public function copyFromVector3D(vec:Vector3D) : Point3D
      {
         this.x = vec.x;
         this.y = vec.y;
         this.z = vec.z;
         return this;
      }

      public function copyFromVertex(v:Vertex) : Point3D
      {
         this.x = v.x;
         this.y = v.y;
         this.z = v.z;
         return this;
      }

      public function copyFromObject3D(obj:Object3D) : Point3D
      {
         this.x = obj.x;
         this.y = obj.y;
         this.z = obj.z;
         return this;
      }
      
      public static function cross(param1:Point3D, param2:Point3D) : Point3D
      {
         return new Point3D(param1.y * param2.z - param1.z * param2.y,param1.z * param2.x - param1.x * param2.z,param1.x * param2.y - param1.y * param2.x);
      }
      
      public static function cross2D(param1:Point3D, param2:Point3D) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function angle(param1:Point3D, param2:Point3D) : Number
      {
         var loc3:Number = Math.sqrt((param1.x * param1.x + param1.y * param1.y + param1.z * param1.z) * (param2.x * param2.x + param2.y * param2.y + param2.z * param2.z));
         var loc4:Number = loc3 != 0 ? dot(param1,param2) / loc3 : 1;
         return Math.acos(loc4);
      }
      
      public static function average(param1:Point3D, param2:Point3D = null, param3:Point3D = null, param4:Point3D = null) : Point3D
      {
         if(param2 == null)
         {
            return param1.clone();
         }
         if(param3 == null)
         {
            return new Point3D((param1.x + param2.x) * 0.5,(param1.y + param2.y) * 0.5,(param1.z + param2.z) * 0.5);
         }
         if(param4 == null)
         {
            return new Point3D((param1.x + param2.x + param3.x) / 3,(param1.y + param2.y + param3.y) / 3,(param1.z + param2.z + param3.z) / 3);
         }
         return new Point3D((param1.x + param2.x + param3.x + param4.x) * 0.25,(param1.y + param2.y + param3.y + param4.y) * 0.25,(param1.z + param2.z + param3.z + param4.z) / 0.25);
      }
      
      public static function random(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : Point3D
      {
         return new Point3D(param1 + Math.random() * (param2 - param1),param3 + Math.random() * (param4 - param3),param5 + Math.random() * (param6 - param5));
      }
      
      public static function interpolate(param1:Point3D, param2:Point3D, param3:Number = 0.5) : Point3D
      {
         return new Point3D(param1.x + (param2.x - param1.x) * param3,param1.y + (param2.y - param1.y) * param3,param1.z + (param2.z - param1.z) * param3);
      }
      
      public static function dot(param1:Point3D, param2:Point3D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y + param1.z * param2.z;
      }
      
      public static function sum(param1:Point3D, param2:Point3D) : Point3D
      {
         return new Point3D(param1.x + param2.x,param1.y + param2.y,param1.z + param2.z);
      }
      
      public static function dot2D(param1:Point3D, param2:Point3D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function difference(param1:Point3D, param2:Point3D) : Point3D
      {
         return new Point3D(param1.x - param2.x,param1.y - param2.y,param1.z - param2.z);
      }
      
      public static function angleFast(param1:Point3D, param2:Point3D) : Number
      {
         var loc3:Number = dot(param1,param2);
         if(Math.abs(loc3) > 1)
         {
            loc3 = loc3 > 0 ? 1 : -1;
         }
         return Math.acos(loc3);
      }
      
      public function cross(param1:Point3D) : void
      {
         var loc2:Number = y * param1.z - z * param1.y;
         var loc3:Number = z * param1.x - x * param1.z;
         var loc4:Number = x * param1.y - y * param1.x;
         x = loc2;
         y = loc3;
         z = loc4;
      }
      
      public function transformOrientation(param1:Matrix4) : void
      {
         var loc2:Number = x;
         var loc3:Number = y;
         var loc4:Number = z;
         x = param1.a * loc2 + param1.b * loc3 + param1.c * loc4;
         y = param1.e * loc2 + param1.f * loc3 + param1.g * loc4;
         z = param1.i * loc2 + param1.j * loc3 + param1.k * loc4;
      }
      
      public function dot(param1:Point3D) : Number
      {
         return x * param1.x + y * param1.y + z * param1.z;
      }
      
      public function cross2(param1:Point3D, param2:Point3D) : void
      {
         x = param1.y * param2.z - param1.z * param2.y;
         y = param1.z * param2.x - param1.x * param2.z;
         z = param1.x * param2.y - param1.y * param2.x;
      }
      
      public function floor() : void
      {
         x = Math.floor(x);
         y = Math.floor(y);
         z = Math.floor(z);
      }
      
      public function normalize() : void
      {
         var loc1:Number = NaN;
         if(x != 0 || y != 0 || z != 0)
         {
            loc1 = Math.sqrt(x * x + y * y + z * z);
            x /= loc1;
            y /= loc1;
            z /= loc1;
         }
         else
         {
            z = 1;
         }
      }
      
      public function get lengthSqr() : Number
      {
         return x * x + y * y + z * z;
      }
      
      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function createSkewSymmetricMatrix(param1:Matrix4) : void
      {
         param1.a = param1.f = param1.k = param1.d = param1.h = param1.l = 0;
         param1.b = -z;
         param1.c = y;
         param1.e = z;
         param1.g = -x;
         param1.i = -y;
         param1.j = x;
      }
      
      public function set length(param1:Number) : void
      {
         var loc2:Number = NaN;
         if(x != 0 || y != 0 || z != 0)
         {
            loc2 = param1 / length;
            x *= loc2;
            y *= loc2;
            z *= loc2;
         }
         else
         {
            z = param1;
         }
      }
      
      public function subtract(param1:Point3D) : void
      {
         x -= param1.x;
         y -= param1.y;
         z -= param1.z;
      }
      
      public function toPoint() : Point
      {
         return new Point(x,y);
      }
      
      public function invert() : void
      {
         x = -x;
         y = -y;
         z = -z;
      }
      
      public function inverseTransform(param1:Matrix4) : void
      {
         x -= param1.d;
         y -= param1.h;
         z -= param1.l;
         var loc2:Number = x * param1.a + y * param1.e + z * param1.i;
         var loc3:Number = x * param1.b + y * param1.f + z * param1.j;
         var loc4:Number = x * param1.c + y * param1.g + z * param1.k;
         x = loc2;
         y = loc3;
         z = loc4;
      }
      
      public function clone() : Point3D
      {
         return new Point3D(x,y,z);
      }
      
      public function add(param1:Point3D) : void
      {
         x += param1.x;
         y += param1.y;
         z += param1.z;
      }
      
      public function multiply(param1:Number) : void
      {
         x *= param1;
         y *= param1;
         z *= param1;
      }
      
      public function get length() : Number
      {
         return Math.sqrt(x * x + y * y + z * z);
      }
      
      public function toString() : String
      {
         return "[Point3D X: " + x.toFixed(3) + " Y:" + y.toFixed(3) + " Z:" + z.toFixed(3) + "]";
      }
      
      public function transformTranspose(param1:Matrix4) : void
      {
         var loc2:Number = x * param1.a + y * param1.e + z * param1.i;
         var loc3:Number = x * param1.b + y * param1.f + z * param1.j;
         var loc4:Number = x * param1.c + y * param1.g + z * param1.k;
         x = loc2;
         y = loc3;
         z = loc4;
      }
      
      public function transform(param1:Matrix4) : void
      {
         var loc2:Number = x;
         var loc3:Number = y;
         var loc4:Number = z;
         x = param1.a * loc2 + param1.b * loc3 + param1.c * loc4 + param1.d;
         y = param1.e * loc2 + param1.f * loc3 + param1.g * loc4 + param1.h;
         z = param1.i * loc2 + param1.j * loc3 + param1.k * loc4 + param1.l;
      }
      
      public function copy(param1:Point3D) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
      
      public function round() : void
      {
         x = Math.round(x);
         y = Math.round(y);
         z = Math.round(z);
      }
      
      public function difference(param1:Point3D, param2:Point3D) : void
      {
         x = param1.x - param2.x;
         y = param1.y - param2.y;
         z = param1.z - param2.z;
      }
      
      public function equals(param1:Point3D, param2:Number = 0) : Boolean
      {
         return x - param1.x <= param2 && x - param1.x >= -param2 && y - param1.y <= param2 && y - param1.y >= -param2 && z - param1.z <= param2 && z - param1.z >= -param2;
      }
      public function equalsXYZ(vX:Number,vY:Number,vZ:Number, epsilon:Number = 0) : Boolean
      {
         return x - vZ <= epsilon && x - vZ >= -epsilon && y - vY <= epsilon && y - vY >= -epsilon && z - vZ <= epsilon && z - vZ >= -epsilon;
      }
   }
}

