package alternativa.engine3d.core
{
   import alternativa.engine3d.*;
   import alternativa.types.Set;
   
   use namespace alternativa3d;
   
   public class Operation
   {
      alternativa3d static const OBJECT_CALCULATE_TRANSFORMATION:uint = 16777216;
      
      alternativa3d static const OBJECT_CALCULATE_MOBILITY:uint = 33554432;
      
      alternativa3d static const VERTEX_CALCULATE_COORDS:uint = 50331648;
      
      alternativa3d static const FACE_CALCULATE_BASE_UV:uint = 67108864;
      
      alternativa3d static const FACE_CALCULATE_NORMAL:uint = 83886080;
      
      alternativa3d static const FACE_CALCULATE_UV:uint = 100663296;
      
      alternativa3d static const FACE_UPDATE_PRIMITIVE:uint = 117440512;
      
      alternativa3d static const SECTOR_UPDATE:uint = 134217728;
      
      alternativa3d static const SPLITTER_UPDATE:uint = 150994944;
      
      alternativa3d static const SCENE_CALCULATE_BSP:uint = 167772160;
      
      alternativa3d static const SECTOR_FIND_NODE:uint = 184549376;
      
      alternativa3d static const SPLITTER_CHANGE_STATE:uint = 201326592;
      
      alternativa3d static const SECTOR_CHANGE_VISIBLE:uint = 218103808;
      
      alternativa3d static const FACE_UPDATE_MATERIAL:uint = 234881024;
      
      alternativa3d static const SPRITE_UPDATE_MATERIAL:uint = 251658240;
      
      alternativa3d static const CAMERA_CALCULATE_MATRIX:uint = 268435456;
      
      alternativa3d static const CAMERA_CALCULATE_PLANES:uint = 285212672;
      
      alternativa3d static const CAMERA_RENDER:uint = 301989888;
      
      alternativa3d static const SCENE_CLEAR_PRIMITIVES:uint = 318767104;
      
      alternativa3d var object:Object;
      
      alternativa3d var method:Function;
      
      alternativa3d var name:String;
      
      private var sequel:Operation;
      
      private var sequels:Set;
      
      alternativa3d var priority:uint;
      
      alternativa3d var queued:Boolean = false;
      
      public function Operation(param1:String, param2:Object = null, param3:Function = null, param4:uint = 0)
      {
         super();
         this.alternativa3d::object = param2;
         this.alternativa3d::method = param3;
         this.alternativa3d::name = param1;
         this.alternativa3d::priority = param4;
      }
      
      alternativa3d function addSequel(param1:Operation) : void
      {
         if(this.sequel == null)
         {
            if(this.sequels == null)
            {
               this.sequel = param1;
            }
            else
            {
               this.sequels[param1] = true;
            }
         }
         else if(this.sequel != param1)
         {
            this.sequels = new Set(true);
            this.sequels[this.sequel] = true;
            this.sequels[param1] = true;
            this.sequel = null;
         }
      }
      
      alternativa3d function removeSequel(param1:Operation) : void
      {
         var loc2:* = undefined;
         var loc3:Boolean = false;
         if(this.sequel == null)
         {
            if(this.sequels != null)
            {
               delete this.sequels[param1];
               loc3 = false;
               for(loc2 in this.sequels)
               {
                  if(loc3)
                  {
                     loc3 = false;
                     break;
                  }
                  loc3 = true;
               }
               if(loc3)
               {
                  this.sequel = loc2;
                  this.sequels = null;
               }
            }
         }
         else if(this.sequel == param1)
         {
            this.sequel = null;
         }
      }
      
      alternativa3d function collectSequels(param1:Array) : void
      {
         var loc2:* = undefined;
         var loc3:Operation = null;
         if(this.sequel == null)
         {
            for(loc2 in this.sequels)
            {
               loc3 = loc2;
               if(!loc3.alternativa3d::queued)
               {
                  param1.push(loc3);
                  loc3.alternativa3d::queued = true;
                  loc3.alternativa3d::collectSequels(param1);
               }
            }
         }
         else if(!this.sequel.alternativa3d::queued)
         {
            param1.push(this.sequel);
            this.sequel.alternativa3d::queued = true;
            this.sequel.alternativa3d::collectSequels(param1);
         }
      }
      
      public function toString() : String
      {
         return "[Operation " + (this.alternativa3d::priority >>> 24) + "/" + (this.alternativa3d::priority & 0xFFFFFF) + " " + this.alternativa3d::object + "." + this.alternativa3d::name + "]";
      }
   }
}

