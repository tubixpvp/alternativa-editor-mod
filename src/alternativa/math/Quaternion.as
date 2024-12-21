package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Quaternion
   {
      
      private static const _q:Quaternion = new Quaternion();
       
      
      public var w:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Quaternion(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.w = param1;
         this.x = param2;
         this.y = param3;
         this.z = param4;
      }
      
      public static function multiply(param1:Quaternion, param2:Quaternion, param3:Quaternion) : void
      {
         param3.w = param1.w * param2.w - param1.x * param2.x - param1.y * param2.y - param1.z * param2.z;
         param3.x = param1.w * param2.x + param1.x * param2.w + param1.y * param2.z - param1.z * param2.y;
         param3.y = param1.w * param2.y + param1.y * param2.w + param1.z * param2.x - param1.x * param2.z;
         param3.z = param1.w * param2.z + param1.z * param2.w + param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function createFromAxisAngle(param1:Vector3D, param2:Number) : Quaternion
      {
         var _loc3_:Quaternion = new Quaternion();
         _loc3_.setFromAxisAngle(param1,param2);
         return _loc3_;
      }
      
      public static function createFromAxisAngleComponents(param1:Number, param2:Number, param3:Number, param4:Number) : Quaternion
      {
         var _loc5_:Quaternion = new Quaternion();
         _loc5_.setFromAxisAngleComponents(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public function reset(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Quaternion
      {
         this.w = param1;
         this.x = param2;
         this.y = param3;
         this.z = param4;
         return this;
      }
      
      public function normalize() : Quaternion
      {
         var _loc1_:Number = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(_loc1_ == 0)
         {
            this.w = 1;
         }
         else
         {
            _loc1_ = 1 / Math.sqrt(_loc1_);
            this.w *= _loc1_;
            this.x *= _loc1_;
            this.y *= _loc1_;
            this.z *= _loc1_;
         }
         return this;
      }
      
      public function prepend(param1:Quaternion) : Quaternion
      {
         var _loc2_:Number = this.w * param1.w - this.x * param1.x - this.y * param1.y - this.z * param1.z;
         var _loc3_:Number = this.w * param1.x + this.x * param1.w + this.y * param1.z - this.z * param1.y;
         var _loc4_:Number = this.w * param1.y + this.y * param1.w + this.z * param1.x - this.x * param1.z;
         var _loc5_:Number = this.w * param1.z + this.z * param1.w + this.x * param1.y - this.y * param1.x;
         this.w = _loc2_;
         this.x = _loc3_;
         this.y = _loc4_;
         this.z = _loc5_;
         return this;
      }
      
      public function append(param1:Quaternion) : Quaternion
      {
         var _loc2_:Number = param1.w * this.w - param1.x * this.x - param1.y * this.y - param1.z * this.z;
         var _loc3_:Number = param1.w * this.x + param1.x * this.w + param1.y * this.z - param1.z * this.y;
         var _loc4_:Number = param1.w * this.y + param1.y * this.w + param1.z * this.x - param1.x * this.z;
         var _loc5_:Number = param1.w * this.z + param1.z * this.w + param1.x * this.y - param1.y * this.x;
         this.w = _loc2_;
         this.x = _loc3_;
         this.y = _loc4_;
         this.z = _loc5_;
         return this;
      }
      
      public function rotateByVector(param1:Vector3D) : Quaternion
      {
         var _loc2_:Number = -param1.x * this.x - param1.y * this.y - param1.z * this.z;
         var _loc3_:Number = param1.x * this.w + param1.y * this.z - param1.z * this.y;
         var _loc4_:Number = param1.y * this.w + param1.z * this.x - param1.x * this.z;
         var _loc5_:Number = param1.z * this.w + param1.x * this.y - param1.y * this.x;
         this.w = _loc2_;
         this.x = _loc3_;
         this.y = _loc4_;
         this.z = _loc5_;
         return this;
      }
      
      public function addScaledVector(param1:Vector3D, param2:Number) : Quaternion
      {
         var _loc3_:Number = param1.x * param2;
         var _loc4_:Number = param1.y * param2;
         var _loc5_:Number = param1.z * param2;
         var _loc6_:Number = -this.x * _loc3_ - this.y * _loc4_ - this.z * _loc5_;
         var _loc7_:Number = _loc3_ * this.w + _loc4_ * this.z - _loc5_ * this.y;
         var _loc8_:Number = _loc4_ * this.w + _loc5_ * this.x - _loc3_ * this.z;
         var _loc9_:Number = _loc5_ * this.w + _loc3_ * this.y - _loc4_ * this.x;
         this.w += 0.5 * _loc6_;
         this.x += 0.5 * _loc7_;
         this.y += 0.5 * _loc8_;
         this.z += 0.5 * _loc9_;
         var _loc10_:Number = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(_loc10_ == 0)
         {
            this.w = 1;
         }
         else
         {
            _loc10_ = 1 / Math.sqrt(_loc10_);
            this.w *= _loc10_;
            this.x *= _loc10_;
            this.y *= _loc10_;
            this.z *= _loc10_;
         }
         return this;
      }
      
      /*fpublic function toMatrix3(param1:Matrix3) : Quaternion
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:Number = 2 * this.x * this.x;
         var _loc3_:Number = 2 * this.y * this.y;
         var _loc4_:Number = 2 * this.z * this.z;
         var _loc5_:Number = 2 * this.x * this.y;
         var _loc6_:Number = 2 * this.y * this.z;
         _loc7_ = 2 * this.z * this.x;
         _loc8_ = 2 * this.w * this.x;
         _loc9_ = 2 * this.w * this.y;
         var _loc10_:Number = 2 * this.w * this.z;
         param1.m00 = 1 - _loc3_ - _loc4_;
         param1.m01 = _loc5_ - _loc10_;
         param1.m02 = _loc7_ + _loc9_;
         param1.m10 = _loc5_ + _loc10_;
         param1.m11 = 1 - _loc2_ - _loc4_;
         param1.m12 = _loc6_ - _loc8_;
         param1.m20 = _loc7_ - _loc9_;
         param1.m21 = _loc6_ + _loc8_;
         param1.m22 = 1 - _loc2_ - _loc3_;
         return this;
      }*/
      
      public function getYAxis(param1:Vector3D) : Vector3D
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = 2 * this.x * this.x;
         var _loc3_:Number = 2 * this.z * this.z;
         var _loc4_:Number = 2 * this.x * this.y;
         _loc5_ = 2 * this.y * this.z;
         var _loc6_:Number = 2 * this.w * this.x;
         var _loc7_:Number = 2 * this.w * this.z;
         param1.x = _loc4_ - _loc7_;
         param1.y = 1 - _loc2_ - _loc3_;
         param1.z = _loc5_ + _loc6_;
         return param1;
      }
      
      public function getZAxis(param1:Vector3D) : Vector3D
      {
         var _loc2_:Number = NaN;
         _loc2_ = 2 * this.x * this.x;
         var _loc3_:Number = 2 * this.y * this.y;
         var _loc4_:Number = 2 * this.y * this.z;
         var _loc5_:Number = 2 * this.z * this.x;
         var _loc6_:Number = 2 * this.w * this.x;
         var _loc7_:Number = 2 * this.w * this.y;
         param1.x = _loc5_ + _loc7_;
         param1.y = _loc4_ - _loc6_;
         param1.z = 1 - _loc2_ - _loc3_;
         return param1;
      }
      
      /*public function toMatrix4(param1:Matrix4) : Quaternion
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc2_ = 2 * this.x * this.x;
         var _loc3_:Number = 2 * this.y * this.y;
         _loc4_ = 2 * this.z * this.z;
         var _loc5_:Number = 2 * this.x * this.y;
         _loc6_ = 2 * this.y * this.z;
         var _loc7_:Number = 2 * this.z * this.x;
         _loc8_ = 2 * this.w * this.x;
         var _loc9_:Number = 2 * this.w * this.y;
         var _loc10_:Number = 2 * this.w * this.z;
         param1.m00 = 1 - _loc3_ - _loc4_;
         param1.m01 = _loc5_ - _loc10_;
         param1.m02 = _loc7_ + _loc9_;
         param1.m10 = _loc5_ + _loc10_;
         param1.m11 = 1 - _loc2_ - _loc4_;
         param1.m12 = _loc6_ - _loc8_;
         param1.m20 = _loc7_ - _loc9_;
         param1.m21 = _loc6_ + _loc8_;
         param1.m22 = 1 - _loc2_ - _loc3_;
         return this;
      }*/
      
      public function length() : Number
      {
         return Math.sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function lengthSqr() : Number
      {
         return this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function setFromAxisAngle(param1:Vector3D, param2:Number) : Quaternion
      {
         this.w = Math.cos(0.5 * param2);
         var _loc3_:Number = Math.sin(0.5 * param2) / Math.sqrt(param1.x * param1.x + param1.y * param1.y + param1.z * param1.z);
         this.x = param1.x * _loc3_;
         this.y = param1.y * _loc3_;
         this.z = param1.z * _loc3_;
         return this;
      }
      
      public function setFromAxisAngleComponents(param1:Number, param2:Number, param3:Number, param4:Number) : Quaternion
      {
         this.w = Math.cos(0.5 * param4);
         var _loc5_:Number = Math.sin(0.5 * param4) / Math.sqrt(param1 * param1 + param2 * param2 + param3 * param3);
         this.x = param1 * _loc5_;
         this.y = param2 * _loc5_;
         this.z = param3 * _loc5_;
         return this;
      }
      
      public function toAxisVector(param1:Vector3D = null) : Vector3D
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.w < -1 || this.w > 1)
         {
            this.normalize();
         }
         if(param1 == null)
         {
            param1 = new Vector3D();
         }
         if(this.w > -1 && this.w < 1)
         {
            if(this.w == 0)
            {
               param1.x = this.x;
               param1.y = this.y;
               param1.z = this.z;
            }
            else
            {
               _loc2_ = 2 * Math.acos(this.w);
               _loc3_ = 1 / Math.sqrt(1 - this.w * this.w);
               param1.x = this.x * _loc3_ * _loc2_;
               param1.y = this.y * _loc3_ * _loc2_;
               param1.z = this.z * _loc3_ * _loc2_;
            }
         }
         else
         {
            param1.x = 0;
            param1.y = 0;
            param1.z = 0;
         }
         return param1;
      }
      
      public function getEulerAngles(param1:Vector3D) : Vector3D
      {
         var _loc2_:Number = 2 * this.x * this.x;
         var _loc3_:Number = 2 * this.y * this.y;
         var _loc4_:Number = 2 * this.z * this.z;
         var _loc5_:Number = 2 * this.x * this.y;
         var _loc6_:Number = 2 * this.y * this.z;
         var _loc7_:Number = 2 * this.z * this.x;
         var _loc8_:Number = 2 * this.w * this.x;
         var _loc9_:Number = 2 * this.w * this.y;
         var _loc10_:Number = 2 * this.w * this.z;
         var _loc11_:Number = 1 - _loc3_ - _loc4_;
         var _loc12_:Number = _loc5_ - _loc10_;
         var _loc13_:Number = _loc5_ + _loc10_;
         var _loc14_:Number = 1 - _loc2_ - _loc4_;
         var _loc15_:Number = _loc7_ - _loc9_;
         var _loc16_:Number = _loc6_ + _loc8_;
         var _loc17_:Number = 1 - _loc2_ - _loc3_;
         if(-1 < _loc15_ && _loc15_ < 1)
         {
            if(param1 == null)
            {
               param1 = new Vector3D(Math.atan2(_loc16_,_loc17_),-Math.asin(_loc15_),Math.atan2(_loc13_,_loc11_));
            }
            else
            {
               param1.x = Math.atan2(_loc16_,_loc17_);
               param1.y = -Math.asin(_loc15_);
               param1.z = Math.atan2(_loc13_,_loc11_);
            }
         }
         else if(param1 == null)
         {
            param1 = new Vector3D(0,0.5 * (_loc15_ <= -1 ? Math.PI : -Math.PI),Math.atan2(-_loc12_,_loc14_));
         }
         else
         {
            param1.x = 0;
            param1.y = _loc15_ <= -1 ? Math.PI : -Math.PI;
            param1.y *= 0.5;
            param1.z = Math.atan2(-_loc12_,_loc14_);
         }
         return param1;
      }
      
      public function setFromEulerAnglesXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.setFromAxisAngleComponents(1,0,0,param1);
         _q.setFromAxisAngleComponents(0,1,0,param2);
         this.append(_q);
         this.normalize();
         _q.setFromAxisAngleComponents(0,0,1,param3);
         this.append(_q);
         this.normalize();
      }
      
      public function setFromEulerAngles(param1:Vector3D) : void
      {
         this.setFromEulerAnglesXYZ(param1.x,param1.y,param1.z);
      }
      
      public function conjugate() : void
      {
         this.x = -this.x;
         this.y = -this.y;
         this.z = -this.z;
      }
      
      public function nlerp(param1:Quaternion, param2:Quaternion, param3:Number) : Quaternion
      {
         var _loc4_:Number = 1 - param3;
         this.w = param1.w * _loc4_ + param2.w * param3;
         this.x = param1.x * _loc4_ + param2.x * param3;
         this.y = param1.y * _loc4_ + param2.y * param3;
         this.z = param1.z * _loc4_ + param2.z * param3;
         _loc4_ = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(_loc4_ == 0)
         {
            this.w = 1;
         }
         else
         {
            _loc4_ = 1 / Math.sqrt(_loc4_);
            this.w *= _loc4_;
            this.x *= _loc4_;
            this.y *= _loc4_;
            this.z *= _loc4_;
         }
         return this;
      }
      
      public function subtract(param1:Quaternion) : Quaternion
      {
         this.w -= param1.w;
         this.x -= param1.x;
         this.y -= param1.y;
         this.z -= param1.z;
         return this;
      }
      
      public function diff(param1:Quaternion, param2:Quaternion) : Quaternion
      {
         this.w = param2.w - param1.w;
         this.x = param2.x - param1.x;
         this.y = param2.y - param1.y;
         this.z = param2.z - param1.z;
         return this;
      }
      
      public function copy(param1:Quaternion) : Quaternion
      {
         this.w = param1.w;
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         return this;
      }
      
      public function toVector3D(param1:Vector3D) : Vector3D
      {
         param1.x = this.x;
         param1.y = this.y;
         param1.z = this.z;
         param1.w = this.w;
         return param1;
      }
      
      public function clone() : Quaternion
      {
         return new Quaternion(this.w,this.x,this.y,this.z);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + "(" + this.w + ", " + this.x + ", " + this.y + ", " + this.z + ")";
      }
      
      public function slerp(param1:Quaternion, param2:Quaternion, param3:Number) : Quaternion
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc4_:Number = 1;
         var _loc5_:Number = param1.w * param2.w + param1.x * param2.x + param1.y * param2.y + param1.z * param2.z;
         if(_loc5_ < 0)
         {
            _loc5_ = -_loc5_;
            _loc4_ = -1;
         }
         if(1 - _loc5_ < 0.001)
         {
            _loc6_ = 1 - param3;
            _loc7_ = param3 * _loc4_;
            this.w = param1.w * _loc6_ + param2.w * _loc7_;
            this.x = param1.x * _loc6_ + param2.x * _loc7_;
            this.y = param1.y * _loc6_ + param2.y * _loc7_;
            this.z = param1.z * _loc6_ + param2.z * _loc7_;
            this.normalize();
         }
         else
         {
            _loc8_ = Math.acos(_loc5_);
            _loc9_ = Math.sin(_loc8_);
            _loc10_ = Math.sin((1 - param3) * _loc8_) / _loc9_;
            _loc11_ = Math.sin(param3 * _loc8_) / _loc9_ * _loc4_;
            this.w = param1.w * _loc10_ + param2.w * _loc11_;
            this.x = param1.x * _loc10_ + param2.x * _loc11_;
            this.y = param1.y * _loc10_ + param2.y * _loc11_;
            this.z = param1.z * _loc10_ + param2.z * _loc11_;
         }
         return this;
      }
      
      public function isFiniteQuaternion() : Boolean
      {
         return isFinite(this.w) && isFinite(this.x) && isFinite(this.y) && isFinite(this.z);
      }
   }
}
