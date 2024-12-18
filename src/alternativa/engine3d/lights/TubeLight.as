package alternativa.engine3d.lights
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import flash.display.Sprite;
   use namespace alternativa3d;
   public class TubeLight extends Light3D
   {
       
      
      public var length:Number;
      
      public var attenuationBegin:Number;
      
      public var attenuationEnd:Number;
      
      public var falloff:Number;
      
      public function TubeLight(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.color = param1;
         this.length = param2;
         this.attenuationBegin = param3;
         this.attenuationEnd = param4;
         this.falloff = param5;
         calculateBounds();
      }
      
      public function lookAt(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         _loc4_ = param1 - this.x;
         var _loc5_:Number = param2 - this.y;
         var _loc6_:Number = param3 - this.z;
         rotationX = Math.atan2(_loc6_,Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_)) - Math.PI / 2;
         rotationY = 0;
         rotationZ = -Math.atan2(_loc4_,_loc5_);
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:TubeLight = new TubeLight(color,this.length,this.attenuationBegin,this.attenuationEnd,this.falloff);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override alternativa3d function drawDebug(param1:Camera3D) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc2_:int = param1.checkInDebug(this);
         if(_loc2_ > 0)
         {
            _loc3_ = param1.view.canvas;
            if(_loc2_ & Debug.LIGHTS && ml > param1.nearClipping)
            {
               _loc4_ = (color >> 16 & 255) * intensity;
               _loc5_ = (color >> 8 & 255) * intensity;
               _loc6_ = (color & 255) * intensity;
               _loc7_ = ((_loc4_ > 255?255:_loc4_) << 16) + ((_loc5_ > 255?255:_loc5_) << 8) + (_loc6_ > 255?255:_loc6_);
               _loc8_ = md + ma * this.attenuationBegin;
               _loc9_ = mh + me * this.attenuationBegin;
               _loc10_ = ml + mi * this.attenuationBegin;
               _loc11_ = md + (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               _loc12_ = mh + (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               _loc13_ = ml + (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               _loc14_ = md + mb * this.attenuationBegin;
               _loc15_ = mh + mf * this.attenuationBegin;
               _loc16_ = ml + mj * this.attenuationBegin;
               _loc17_ = md - (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               _loc18_ = mh - (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               _loc19_ = ml - (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               _loc20_ = md - ma * this.attenuationBegin;
               _loc21_ = mh - me * this.attenuationBegin;
               _loc22_ = ml - mi * this.attenuationBegin;
               _loc23_ = md - (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               _loc24_ = mh - (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               _loc25_ = ml - (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               _loc26_ = md - mb * this.attenuationBegin;
               _loc27_ = mh - mf * this.attenuationBegin;
               _loc28_ = ml - mj * this.attenuationBegin;
               _loc29_ = md + (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               _loc30_ = mh + (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               _loc31_ = ml + (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               _loc32_ = md + mc * this.length + ma * this.attenuationBegin;
               _loc33_ = mh + mg * this.length + me * this.attenuationBegin;
               _loc34_ = ml + mk * this.length + mi * this.attenuationBegin;
               _loc35_ = md + mc * this.length + (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               _loc36_ = mh + mg * this.length + (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               _loc37_ = ml + mk * this.length + (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               _loc38_ = md + mc * this.length + mb * this.attenuationBegin;
               _loc39_ = mh + mg * this.length + mf * this.attenuationBegin;
               _loc40_ = ml + mk * this.length + mj * this.attenuationBegin;
               _loc41_ = md + mc * this.length - (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               _loc42_ = mh + mg * this.length - (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               _loc43_ = ml + mk * this.length - (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               _loc44_ = md + mc * this.length - ma * this.attenuationBegin;
               _loc45_ = mh + mg * this.length - me * this.attenuationBegin;
               _loc46_ = ml + mk * this.length - mi * this.attenuationBegin;
               _loc47_ = md + mc * this.length - (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               _loc48_ = mh + mg * this.length - (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               _loc49_ = ml + mk * this.length - (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               _loc50_ = md + mc * this.length - mb * this.attenuationBegin;
               _loc51_ = mh + mg * this.length - mf * this.attenuationBegin;
               _loc52_ = ml + mk * this.length - mj * this.attenuationBegin;
               _loc53_ = md + mc * this.length + (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               _loc54_ = mh + mg * this.length + (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               _loc55_ = ml + mk * this.length + (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               if(_loc10_ > param1.nearClipping && _loc13_ > param1.nearClipping && _loc16_ > param1.nearClipping && _loc19_ > param1.nearClipping && _loc22_ > param1.nearClipping && _loc25_ > param1.nearClipping && _loc28_ > param1.nearClipping && _loc31_ > param1.nearClipping && _loc34_ > param1.nearClipping && _loc37_ > param1.nearClipping && _loc40_ > param1.nearClipping && _loc43_ > param1.nearClipping && _loc46_ > param1.nearClipping && _loc49_ > param1.nearClipping && _loc52_ > param1.nearClipping && _loc55_ > param1.nearClipping)
               {
                  _loc3_.graphics.lineStyle(1,_loc7_);
                  _loc3_.graphics.moveTo(_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.curveTo(_loc11_ * param1.viewSizeX / _loc13_,_loc12_ * param1.viewSizeY / _loc13_,_loc14_ * param1.viewSizeX / _loc16_,_loc15_ * param1.viewSizeY / _loc16_);
                  _loc3_.graphics.curveTo(_loc17_ * param1.viewSizeX / _loc19_,_loc18_ * param1.viewSizeY / _loc19_,_loc20_ * param1.viewSizeX / _loc22_,_loc21_ * param1.viewSizeY / _loc22_);
                  _loc3_.graphics.curveTo(_loc23_ * param1.viewSizeX / _loc25_,_loc24_ * param1.viewSizeY / _loc25_,_loc26_ * param1.viewSizeX / _loc28_,_loc27_ * param1.viewSizeY / _loc28_);
                  _loc3_.graphics.curveTo(_loc29_ * param1.viewSizeX / _loc31_,_loc30_ * param1.viewSizeY / _loc31_,_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.moveTo(_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.curveTo(_loc35_ * param1.viewSizeX / _loc37_,_loc36_ * param1.viewSizeY / _loc37_,_loc38_ * param1.viewSizeX / _loc40_,_loc39_ * param1.viewSizeY / _loc40_);
                  _loc3_.graphics.curveTo(_loc41_ * param1.viewSizeX / _loc43_,_loc42_ * param1.viewSizeY / _loc43_,_loc44_ * param1.viewSizeX / _loc46_,_loc45_ * param1.viewSizeY / _loc46_);
                  _loc3_.graphics.curveTo(_loc47_ * param1.viewSizeX / _loc49_,_loc48_ * param1.viewSizeY / _loc49_,_loc50_ * param1.viewSizeX / _loc52_,_loc51_ * param1.viewSizeY / _loc52_);
                  _loc3_.graphics.curveTo(_loc53_ * param1.viewSizeX / _loc55_,_loc54_ * param1.viewSizeY / _loc55_,_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.moveTo(_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.lineTo(_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.moveTo(_loc14_ * param1.viewSizeX / _loc16_,_loc15_ * param1.viewSizeY / _loc16_);
                  _loc3_.graphics.lineTo(_loc38_ * param1.viewSizeX / _loc40_,_loc39_ * param1.viewSizeY / _loc40_);
                  _loc3_.graphics.moveTo(_loc20_ * param1.viewSizeX / _loc22_,_loc21_ * param1.viewSizeY / _loc22_);
                  _loc3_.graphics.lineTo(_loc44_ * param1.viewSizeX / _loc46_,_loc45_ * param1.viewSizeY / _loc46_);
                  _loc3_.graphics.moveTo(_loc26_ * param1.viewSizeX / _loc28_,_loc27_ * param1.viewSizeY / _loc28_);
                  _loc3_.graphics.lineTo(_loc50_ * param1.viewSizeX / _loc52_,_loc51_ * param1.viewSizeY / _loc52_);
               }
               _loc8_ = md - mc * this.falloff + ma * this.attenuationEnd;
               _loc9_ = mh - mg * this.falloff + me * this.attenuationEnd;
               _loc10_ = ml - mk * this.falloff + mi * this.attenuationEnd;
               _loc11_ = md - mc * this.falloff + (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               _loc12_ = mh - mg * this.falloff + (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               _loc13_ = ml - mk * this.falloff + (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               _loc14_ = md - mc * this.falloff + mb * this.attenuationEnd;
               _loc15_ = mh - mg * this.falloff + mf * this.attenuationEnd;
               _loc16_ = ml - mk * this.falloff + mj * this.attenuationEnd;
               _loc17_ = md - mc * this.falloff - (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               _loc18_ = mh - mg * this.falloff - (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               _loc19_ = ml - mk * this.falloff - (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               _loc20_ = md - mc * this.falloff - ma * this.attenuationEnd;
               _loc21_ = mh - mg * this.falloff - me * this.attenuationEnd;
               _loc22_ = ml - mk * this.falloff - mi * this.attenuationEnd;
               _loc23_ = md - mc * this.falloff - (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               _loc24_ = mh - mg * this.falloff - (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               _loc25_ = ml - mk * this.falloff - (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               _loc26_ = md - mc * this.falloff - mb * this.attenuationEnd;
               _loc27_ = mh - mg * this.falloff - mf * this.attenuationEnd;
               _loc28_ = ml - mk * this.falloff - mj * this.attenuationEnd;
               _loc29_ = md - mc * this.falloff + (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               _loc30_ = mh - mg * this.falloff + (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               _loc31_ = ml - mk * this.falloff + (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               _loc32_ = md + mc * (this.length + this.falloff) + ma * this.attenuationEnd;
               _loc33_ = mh + mg * (this.length + this.falloff) + me * this.attenuationEnd;
               _loc34_ = ml + mk * (this.length + this.falloff) + mi * this.attenuationEnd;
               _loc35_ = md + mc * (this.length + this.falloff) + (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               _loc36_ = mh + mg * (this.length + this.falloff) + (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               _loc37_ = ml + mk * (this.length + this.falloff) + (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               _loc38_ = md + mc * (this.length + this.falloff) + mb * this.attenuationEnd;
               _loc39_ = mh + mg * (this.length + this.falloff) + mf * this.attenuationEnd;
               _loc40_ = ml + mk * (this.length + this.falloff) + mj * this.attenuationEnd;
               _loc41_ = md + mc * (this.length + this.falloff) - (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               _loc42_ = mh + mg * (this.length + this.falloff) - (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               _loc43_ = ml + mk * (this.length + this.falloff) - (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               _loc44_ = md + mc * (this.length + this.falloff) - ma * this.attenuationEnd;
               _loc45_ = mh + mg * (this.length + this.falloff) - me * this.attenuationEnd;
               _loc46_ = ml + mk * (this.length + this.falloff) - mi * this.attenuationEnd;
               _loc47_ = md + mc * (this.length + this.falloff) - (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               _loc48_ = mh + mg * (this.length + this.falloff) - (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               _loc49_ = ml + mk * (this.length + this.falloff) - (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               _loc50_ = md + mc * (this.length + this.falloff) - mb * this.attenuationEnd;
               _loc51_ = mh + mg * (this.length + this.falloff) - mf * this.attenuationEnd;
               _loc52_ = ml + mk * (this.length + this.falloff) - mj * this.attenuationEnd;
               _loc53_ = md + mc * (this.length + this.falloff) + (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               _loc54_ = mh + mg * (this.length + this.falloff) + (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               _loc55_ = ml + mk * (this.length + this.falloff) + (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               if(_loc10_ > param1.nearClipping && _loc13_ > param1.nearClipping && _loc16_ > param1.nearClipping && _loc19_ > param1.nearClipping && _loc22_ > param1.nearClipping && _loc25_ > param1.nearClipping && _loc28_ > param1.nearClipping && _loc31_ > param1.nearClipping && _loc34_ > param1.nearClipping && _loc37_ > param1.nearClipping && _loc40_ > param1.nearClipping && _loc43_ > param1.nearClipping && _loc46_ > param1.nearClipping && _loc49_ > param1.nearClipping && _loc52_ > param1.nearClipping && _loc55_ > param1.nearClipping)
               {
                  _loc3_.graphics.lineStyle(1,_loc7_);
                  _loc3_.graphics.moveTo(_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.curveTo(_loc11_ * param1.viewSizeX / _loc13_,_loc12_ * param1.viewSizeY / _loc13_,_loc14_ * param1.viewSizeX / _loc16_,_loc15_ * param1.viewSizeY / _loc16_);
                  _loc3_.graphics.curveTo(_loc17_ * param1.viewSizeX / _loc19_,_loc18_ * param1.viewSizeY / _loc19_,_loc20_ * param1.viewSizeX / _loc22_,_loc21_ * param1.viewSizeY / _loc22_);
                  _loc3_.graphics.curveTo(_loc23_ * param1.viewSizeX / _loc25_,_loc24_ * param1.viewSizeY / _loc25_,_loc26_ * param1.viewSizeX / _loc28_,_loc27_ * param1.viewSizeY / _loc28_);
                  _loc3_.graphics.curveTo(_loc29_ * param1.viewSizeX / _loc31_,_loc30_ * param1.viewSizeY / _loc31_,_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.moveTo(_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.curveTo(_loc35_ * param1.viewSizeX / _loc37_,_loc36_ * param1.viewSizeY / _loc37_,_loc38_ * param1.viewSizeX / _loc40_,_loc39_ * param1.viewSizeY / _loc40_);
                  _loc3_.graphics.curveTo(_loc41_ * param1.viewSizeX / _loc43_,_loc42_ * param1.viewSizeY / _loc43_,_loc44_ * param1.viewSizeX / _loc46_,_loc45_ * param1.viewSizeY / _loc46_);
                  _loc3_.graphics.curveTo(_loc47_ * param1.viewSizeX / _loc49_,_loc48_ * param1.viewSizeY / _loc49_,_loc50_ * param1.viewSizeX / _loc52_,_loc51_ * param1.viewSizeY / _loc52_);
                  _loc3_.graphics.curveTo(_loc53_ * param1.viewSizeX / _loc55_,_loc54_ * param1.viewSizeY / _loc55_,_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.moveTo(_loc8_ * param1.viewSizeX / _loc10_,_loc9_ * param1.viewSizeY / _loc10_);
                  _loc3_.graphics.lineTo(_loc32_ * param1.viewSizeX / _loc34_,_loc33_ * param1.viewSizeY / _loc34_);
                  _loc3_.graphics.moveTo(_loc14_ * param1.viewSizeX / _loc16_,_loc15_ * param1.viewSizeY / _loc16_);
                  _loc3_.graphics.lineTo(_loc38_ * param1.viewSizeX / _loc40_,_loc39_ * param1.viewSizeY / _loc40_);
                  _loc3_.graphics.moveTo(_loc20_ * param1.viewSizeX / _loc22_,_loc21_ * param1.viewSizeY / _loc22_);
                  _loc3_.graphics.lineTo(_loc44_ * param1.viewSizeX / _loc46_,_loc45_ * param1.viewSizeY / _loc46_);
                  _loc3_.graphics.moveTo(_loc26_ * param1.viewSizeX / _loc28_,_loc27_ * param1.viewSizeY / _loc28_);
                  _loc3_.graphics.lineTo(_loc50_ * param1.viewSizeX / _loc52_,_loc51_ * param1.viewSizeY / _loc52_);
               }
            }
            if(_loc2_ & Debug.BOUNDS)
            {
               Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ,10092288);
            }
         }
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc3_:Vertex = null;
         if(param2 != null)
         {
            _loc3_ = boundVertexList;
            _loc3_.x = -this.attenuationEnd;
            _loc3_.y = -this.attenuationEnd;
            _loc3_.z = -this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = this.attenuationEnd;
            _loc3_.y = -this.attenuationEnd;
            _loc3_.z = -this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = -this.attenuationEnd;
            _loc3_.y = this.attenuationEnd;
            _loc3_.z = -this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = this.attenuationEnd;
            _loc3_.y = this.attenuationEnd;
            _loc3_.z = -this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = -this.attenuationEnd;
            _loc3_.y = -this.attenuationEnd;
            _loc3_.z = this.length + this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = this.attenuationEnd;
            _loc3_.y = -this.attenuationEnd;
            _loc3_.z = this.length + this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = -this.attenuationEnd;
            _loc3_.y = this.attenuationEnd;
            _loc3_.z = this.length + this.falloff;
            _loc3_ = _loc3_.next;
            _loc3_.x = this.attenuationEnd;
            _loc3_.y = this.attenuationEnd;
            _loc3_.z = this.length + this.falloff;
            _loc3_ = boundVertexList;
            while(_loc3_ != null)
            {
               _loc3_.cameraX = param2.ma * _loc3_.x + param2.mb * _loc3_.y + param2.mc * _loc3_.z + param2.md;
               _loc3_.cameraY = param2.me * _loc3_.x + param2.mf * _loc3_.y + param2.mg * _loc3_.z + param2.mh;
               _loc3_.cameraZ = param2.mi * _loc3_.x + param2.mj * _loc3_.y + param2.mk * _loc3_.z + param2.ml;
               if(_loc3_.cameraX < param1.boundMinX)
               {
                  param1.boundMinX = _loc3_.cameraX;
               }
               if(_loc3_.cameraX > param1.boundMaxX)
               {
                  param1.boundMaxX = _loc3_.cameraX;
               }
               if(_loc3_.cameraY < param1.boundMinY)
               {
                  param1.boundMinY = _loc3_.cameraY;
               }
               if(_loc3_.cameraY > param1.boundMaxY)
               {
                  param1.boundMaxY = _loc3_.cameraY;
               }
               if(_loc3_.cameraZ < param1.boundMinZ)
               {
                  param1.boundMinZ = _loc3_.cameraZ;
               }
               if(_loc3_.cameraZ > param1.boundMaxZ)
               {
                  param1.boundMaxZ = _loc3_.cameraZ;
               }
               _loc3_ = _loc3_.next;
            }
         }
         else
         {
            if(-this.attenuationEnd < param1.boundMinX)
            {
               param1.boundMinX = -this.attenuationEnd;
            }
            if(this.attenuationEnd > param1.boundMaxX)
            {
               param1.boundMaxX = this.attenuationEnd;
            }
            if(-this.attenuationEnd < param1.boundMinY)
            {
               param1.boundMinY = -this.attenuationEnd;
            }
            if(this.attenuationEnd > param1.boundMaxY)
            {
               param1.boundMaxY = this.attenuationEnd;
            }
            if(-this.falloff < param1.boundMinZ)
            {
               param1.boundMinZ = -this.falloff;
            }
            if(this.length + this.falloff > param1.boundMaxZ)
            {
               param1.boundMaxZ = this.length + this.falloff;
            }
         }
      }
   }
}
