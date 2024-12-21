package alternativa.math
{
   import alternativa.engine3d.core.Object3D;
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Matrix3
   {
      
      public static const ZERO:Matrix3 = new Matrix3(0,0,0,0,0,0,0,0,0);
      
      public static const IDENTITY:Matrix3 = new Matrix3();
      
      private static const xAxis:Vector3D = new Vector3D();
      
      private static const yAxis:Vector3D = new Vector3D();
      
      private static const zAxis:Vector3D = new Vector3D();

      
      public static const V_X_AXIS:Vector3D = new Vector3D(1,0,0);
      
      public static const V_Y_AXIS:Vector3D = new Vector3D(0,1,0);
      
      public static const V_Z_AXIS:Vector3D = new Vector3D(0,0,1);
       
      
      public var m00:Number;
      
      public var m01:Number;
      
      public var m02:Number;
      
      public var m10:Number;
      
      public var m11:Number;
      
      public var m12:Number;
      
      public var m20:Number;
      
      public var m21:Number;
      
      public var m22:Number;
      
      public function Matrix3(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 1, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:Number = 1)
      {
         super();
         this.m00 = param1;
         this.m01 = param2;
         this.m02 = param3;
         this.m10 = param4;
         this.m11 = param5;
         this.m12 = param6;
         this.m20 = param7;
         this.m21 = param8;
         this.m22 = param9;
      }
      
      public function toIdentity() : Matrix3
      {
         this.m00 = this.m11 = this.m22 = 1;
         this.m01 = this.m02 = this.m10 = this.m12 = this.m20 = this.m21 = 0;
         return this;
      }
      
      public function invert() : Matrix3
      {
         var _loc1_:Number = this.m00;
         var _loc2_:Number = this.m01;
         var _loc3_:Number = this.m02;
         var _loc4_:Number = this.m10;
         var _loc5_:Number = this.m11;
         var _loc6_:Number = this.m12;
         var _loc7_:Number = this.m20;
         var _loc8_:Number = this.m21;
         var _loc9_:Number = this.m22;
         var _loc10_:Number = 1 / (-_loc3_ * _loc5_ * _loc7_ + _loc2_ * _loc6_ * _loc7_ + _loc3_ * _loc4_ * _loc8_ - _loc1_ * _loc6_ * _loc8_ - _loc2_ * _loc4_ * _loc9_ + _loc1_ * _loc5_ * _loc9_);
         this.m00 = (_loc5_ * _loc9_ - _loc6_ * _loc8_) * _loc10_;
         this.m01 = (_loc3_ * _loc8_ - _loc2_ * _loc9_) * _loc10_;
         this.m02 = (_loc2_ * _loc6_ - _loc3_ * _loc5_) * _loc10_;
         this.m10 = (_loc6_ * _loc7_ - _loc4_ * _loc9_) * _loc10_;
         this.m11 = (_loc1_ * _loc9_ - _loc3_ * _loc7_) * _loc10_;
         this.m12 = (_loc3_ * _loc4_ - _loc1_ * _loc6_) * _loc10_;
         this.m20 = (_loc4_ * _loc8_ - _loc5_ * _loc7_) * _loc10_;
         this.m21 = (_loc2_ * _loc7_ - _loc1_ * _loc8_) * _loc10_;
         this.m22 = (_loc1_ * _loc5_ - _loc2_ * _loc4_) * _loc10_;
         return this;
      }
      
      public function append(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.m00;
         var _loc3_:Number = this.m01;
         var _loc4_:Number = this.m02;
         var _loc5_:Number = this.m10;
         var _loc6_:Number = this.m11;
         var _loc7_:Number = this.m12;
         var _loc8_:Number = this.m20;
         var _loc9_:Number = this.m21;
         var _loc10_:Number = this.m22;
         this.m00 = param1.m00 * _loc2_ + param1.m01 * _loc5_ + param1.m02 * _loc8_;
         this.m01 = param1.m00 * _loc3_ + param1.m01 * _loc6_ + param1.m02 * _loc9_;
         this.m02 = param1.m00 * _loc4_ + param1.m01 * _loc7_ + param1.m02 * _loc10_;
         this.m10 = param1.m10 * _loc2_ + param1.m11 * _loc5_ + param1.m12 * _loc8_;
         this.m11 = param1.m10 * _loc3_ + param1.m11 * _loc6_ + param1.m12 * _loc9_;
         this.m12 = param1.m10 * _loc4_ + param1.m11 * _loc7_ + param1.m12 * _loc10_;
         this.m20 = param1.m20 * _loc2_ + param1.m21 * _loc5_ + param1.m22 * _loc8_;
         this.m21 = param1.m20 * _loc3_ + param1.m21 * _loc6_ + param1.m22 * _loc9_;
         this.m22 = param1.m20 * _loc4_ + param1.m21 * _loc7_ + param1.m22 * _loc10_;
         return this;
      }
      
      public function prepend(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.m00;
         var _loc3_:Number = this.m01;
         var _loc4_:Number = this.m02;
         var _loc5_:Number = this.m10;
         var _loc6_:Number = this.m11;
         var _loc7_:Number = this.m12;
         var _loc8_:Number = this.m20;
         var _loc9_:Number = this.m21;
         var _loc10_:Number = this.m22;
         this.m00 = _loc2_ * param1.m00 + _loc3_ * param1.m10 + _loc4_ * param1.m20;
         this.m01 = _loc2_ * param1.m01 + _loc3_ * param1.m11 + _loc4_ * param1.m21;
         this.m02 = _loc2_ * param1.m02 + _loc3_ * param1.m12 + _loc4_ * param1.m22;
         this.m10 = _loc5_ * param1.m00 + _loc6_ * param1.m10 + _loc7_ * param1.m20;
         this.m11 = _loc5_ * param1.m01 + _loc6_ * param1.m11 + _loc7_ * param1.m21;
         this.m12 = _loc5_ * param1.m02 + _loc6_ * param1.m12 + _loc7_ * param1.m22;
         this.m20 = _loc8_ * param1.m00 + _loc9_ * param1.m10 + _loc10_ * param1.m20;
         this.m21 = _loc8_ * param1.m01 + _loc9_ * param1.m11 + _loc10_ * param1.m21;
         this.m22 = _loc8_ * param1.m02 + _loc9_ * param1.m12 + _loc10_ * param1.m22;
         return this;
      }
      
      public function prependTransposed(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.m00;
         var _loc3_:Number = this.m01;
         var _loc4_:Number = this.m02;
         var _loc5_:Number = this.m10;
         var _loc6_:Number = this.m11;
         var _loc7_:Number = this.m12;
         var _loc8_:Number = this.m20;
         var _loc9_:Number = this.m21;
         var _loc10_:Number = this.m22;
         this.m00 = _loc2_ * param1.m00 + _loc3_ * param1.m01 + _loc4_ * param1.m02;
         this.m01 = _loc2_ * param1.m10 + _loc3_ * param1.m11 + _loc4_ * param1.m12;
         this.m02 = _loc2_ * param1.m20 + _loc3_ * param1.m21 + _loc4_ * param1.m22;
         this.m10 = _loc5_ * param1.m00 + _loc6_ * param1.m01 + _loc7_ * param1.m02;
         this.m11 = _loc5_ * param1.m10 + _loc6_ * param1.m11 + _loc7_ * param1.m12;
         this.m12 = _loc5_ * param1.m20 + _loc6_ * param1.m21 + _loc7_ * param1.m22;
         this.m20 = _loc8_ * param1.m00 + _loc9_ * param1.m01 + _loc10_ * param1.m02;
         this.m21 = _loc8_ * param1.m10 + _loc9_ * param1.m11 + _loc10_ * param1.m12;
         this.m22 = _loc8_ * param1.m20 + _loc9_ * param1.m21 + _loc10_ * param1.m22;
         return this;
      }
      
      public function add(param1:Matrix3) : Matrix3
      {
         this.m00 += param1.m00;
         this.m01 += param1.m01;
         this.m02 += param1.m02;
         this.m10 += param1.m10;
         this.m11 += param1.m11;
         this.m12 += param1.m12;
         this.m20 += param1.m20;
         this.m21 += param1.m21;
         this.m22 += param1.m22;
         return this;
      }
      
      public function subtract(param1:Matrix3) : Matrix3
      {
         this.m00 -= param1.m00;
         this.m01 -= param1.m01;
         this.m02 -= param1.m02;
         this.m10 -= param1.m10;
         this.m11 -= param1.m11;
         this.m12 -= param1.m12;
         this.m20 -= param1.m20;
         this.m21 -= param1.m21;
         this.m22 -= param1.m22;
         return this;
      }
      
      public function transpose() : Matrix3
      {
         var _loc1_:Number = this.m01;
         this.m01 = this.m10;
         this.m10 = _loc1_;
         _loc1_ = this.m02;
         this.m02 = this.m20;
         this.m20 = _loc1_;
         _loc1_ = this.m12;
         this.m12 = this.m21;
         this.m21 = _loc1_;
         return this;
      }
      
      public function transformVector(param1:Vector3D, param2:Vector3D) : void
      {
         param2.x = this.m00 * param1.x + this.m01 * param1.y + this.m02 * param1.z;
         param2.y = this.m10 * param1.x + this.m11 * param1.y + this.m12 * param1.z;
         param2.z = this.m20 * param1.x + this.m21 * param1.y + this.m22 * param1.z;
      }
      
      public function transformVectorInverse(param1:Vector3D, param2:Vector3D) : void
      {
         param2.x = this.m00 * param1.x + this.m10 * param1.y + this.m20 * param1.z;
         param2.y = this.m01 * param1.x + this.m11 * param1.y + this.m21 * param1.z;
         param2.z = this.m02 * param1.x + this.m12 * param1.y + this.m22 * param1.z;
      }
      
      public function transformVector3To3D(param1:Vector3D, param2:Vector3D) : void
      {
         param2.x = this.m00 * param1.x + this.m01 * param1.y + this.m02 * param1.z;
         param2.y = this.m10 * param1.x + this.m11 * param1.y + this.m12 * param1.z;
         param2.z = this.m20 * param1.x + this.m21 * param1.y + this.m22 * param1.z;
      }
      
      public function createSkewSymmetric(param1:Vector3D) : Matrix3
      {
         this.m00 = this.m11 = this.m22 = 0;
         this.m01 = -param1.z;
         this.m02 = param1.y;
         this.m10 = param1.z;
         this.m12 = -param1.x;
         this.m20 = -param1.y;
         this.m21 = param1.x;
         return this;
      }
      
      public function copy(param1:Matrix3) : Matrix3
      {
         this.m00 = param1.m00;
         this.m01 = param1.m01;
         this.m02 = param1.m02;
         this.m10 = param1.m10;
         this.m11 = param1.m11;
         this.m12 = param1.m12;
         this.m20 = param1.m20;
         this.m21 = param1.m21;
         this.m22 = param1.m22;
         return this;
      }
      
      public function setRotationMatrix(param1:Number, param2:Number, param3:Number) : Matrix3
      {
         var _loc4_:Number = Math.cos(param1);
         var _loc5_:Number = Math.sin(param1);
         var _loc6_:Number = Math.cos(param2);
         var _loc7_:Number = Math.sin(param2);
         var _loc8_:Number = Math.cos(param3);
         var _loc9_:Number = Math.sin(param3);
         var _loc10_:Number = _loc8_ * _loc7_;
         var _loc11_:Number = _loc9_ * _loc7_;
         this.m00 = _loc8_ * _loc6_;
         this.m01 = _loc10_ * _loc5_ - _loc9_ * _loc4_;
         this.m02 = _loc10_ * _loc4_ + _loc9_ * _loc5_;
         this.m10 = _loc9_ * _loc6_;
         this.m11 = _loc11_ * _loc5_ + _loc8_ * _loc4_;
         this.m12 = _loc11_ * _loc4_ - _loc8_ * _loc5_;
         this.m20 = -_loc7_;
         this.m21 = _loc6_ * _loc5_;
         this.m22 = _loc6_ * _loc4_;
         return this;
      }
      
      public function setRotationMatrixForObject3D(param1:Object3D) : void
      {
         this.setRotationMatrix(param1.rotationX,param1.rotationY,param1.rotationZ);
      }
      
      public function fromAxisAngle(param1:Vector3D, param2:Number) : void
      {
         var _loc3_:Number = Math.cos(param2);
         var _loc4_:Number = Math.sin(param2);
         var _loc5_:Number = 1 - _loc3_;
         var _loc6_:Number = param1.x;
         var _loc7_:Number = param1.y;
         var _loc8_:Number = param1.z;
         this.m00 = _loc5_ * _loc6_ * _loc6_ + _loc3_;
         this.m01 = _loc5_ * _loc6_ * _loc7_ - _loc8_ * _loc4_;
         this.m02 = _loc5_ * _loc6_ * _loc8_ + _loc7_ * _loc4_;
         this.m10 = _loc5_ * _loc6_ * _loc7_ + _loc8_ * _loc4_;
         this.m11 = _loc5_ * _loc7_ * _loc7_ + _loc3_;
         this.m12 = _loc5_ * _loc7_ * _loc8_ - _loc6_ * _loc4_;
         this.m20 = _loc5_ * _loc6_ * _loc8_ - _loc7_ * _loc4_;
         this.m21 = _loc5_ * _loc7_ * _loc8_ + _loc6_ * _loc4_;
         this.m22 = _loc5_ * _loc8_ * _loc8_ + _loc3_;
      }
      
      public function clone() : Matrix3
      {
         return new Matrix3(this.m00,this.m01,this.m02,this.m10,this.m11,this.m12,this.m20,this.m21,this.m22);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.m00 + ", " + this.m01 + ", " + this.m02 + "), (" + this.m10 + ", " + this.m11 + ", " + this.m12 + "), (" + this.m20 + ", " + this.m21 + ", " + this.m22 + ")";
      }
      
      public function getEulerAngles(param1:Vector3D) : void
      {
         if(-1 < this.m20 && this.m20 < 1)
         {
            param1.x = Math.atan2(this.m21,this.m22);
            param1.y = -Math.asin(this.m20);
            param1.z = Math.atan2(this.m10,this.m00);
         }
         else
         {
            param1.x = 0;
            param1.y = this.m20 <= -1 ? Math.PI : -Math.PI;
            param1.y *= 0.5;
            param1.z = Math.atan2(-this.m01,this.m11);
         }
      }
      
      public function getRight(param1:Vector3D) : void
      {
         this.getAxis(0,param1);
      }
      
      public function getForward(param1:Vector3D) : void
      {
         this.getAxis(1,param1);
      }
      
      public function getUp(param1:Vector3D) : void
      {
         this.getAxis(2,param1);
      }
      
      public function getAxis(param1:int, param2:Vector3D) : void
      {
         switch(param1)
         {
            case 0:
               param2.setTo(this.m00,this.m10,this.m20);
               break;
            case 1:
               param2.setTo(this.m01,this.m11,this.m21);
               break;
            case 2:
               param2.setTo(this.m02,this.m12,this.m22);
         }
      }
      
      public function setDirectionVector(param1:Vector3D) : void
      {
         yAxis.copyFrom(param1);
         yAxis.normalize();
         if(yAxis.dotProduct(V_X_AXIS) < 0.9)
         {
            zAxis.crossProductToOutput(V_X_AXIS,yAxis);
         }
         else
         {
            zAxis.crossProductToOutput(yAxis,V_Y_AXIS);
         }
         zAxis.normalize();
         xAxis.crossProductToOutput(yAxis,zAxis).normalize();
         this.setAxis(xAxis,yAxis,zAxis);
      }
      
      public function setAxis(param1:Vector3D, param2:Vector3D, param3:Vector3D) : void
      {
         this.m00 = param1.x;
         this.m01 = param2.x;
         this.m02 = param3.x;
         this.m10 = param1.y;
         this.m11 = param2.y;
         this.m12 = param3.y;
         this.m20 = param1.z;
         this.m21 = param2.z;
         this.m22 = param3.z;
      }
      
      public function rotationMatrixToQuaternion(param1:Quaternion) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = this.m00 + this.m11 + this.m22;
         if(_loc2_ > 0)
         {
            _loc3_ = Math.sqrt(_loc2_ + 1) * 2;
            param1.w = 0.25 * _loc3_;
            param1.x = (this.m21 - this.m12) / _loc3_;
            param1.y = (this.m02 - this.m20) / _loc3_;
            param1.z = (this.m10 - this.m01) / _loc3_;
         }
         else if(this.m00 > this.m11 && this.m00 > this.m22)
         {
            _loc3_ = Math.sqrt(1 + this.m00 - this.m11 - this.m22) * 2;
            param1.w = (this.m21 - this.m12) / _loc3_;
            param1.x = 0.25 * _loc3_;
            param1.y = (this.m01 + this.m10) / _loc3_;
            param1.z = (this.m02 + this.m20) / _loc3_;
         }
         else if(this.m11 > this.m22)
         {
            _loc3_ = Math.sqrt(1 + this.m11 - this.m00 - this.m22) * 2;
            param1.w = (this.m02 - this.m20) / _loc3_;
            param1.x = (this.m01 + this.m10) / _loc3_;
            param1.y = 0.25 * _loc3_;
            param1.z = (this.m12 + this.m21) / _loc3_;
         }
         else
         {
            _loc3_ = Math.sqrt(1 + this.m22 - this.m00 - this.m11) * 2;
            param1.w = (this.m10 - this.m01) / _loc3_;
            param1.x = (this.m02 + this.m20) / _loc3_;
            param1.y = (this.m12 + this.m21) / _loc3_;
            param1.z = 0.25 * _loc3_;
         }
      }
   }
}
