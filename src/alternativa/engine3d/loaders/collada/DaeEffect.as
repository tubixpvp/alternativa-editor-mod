package alternativa.engine3d.loaders.collada
{
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   
   use namespace collada;
   
   public class DaeEffect extends DaeElement
   {
       
      
      private var effectParams:Object;
      
      private var commonParams:Object;
      
      private var techniqueParams:Object;
      
      private var diffuse:DaeEffectParam;
      
      private var emission:DaeEffectParam;
      
      private var transparent:DaeEffectParam;
      
      private var transparency:DaeEffectParam;
      
      public function DaeEffect(param1:XML, param2:DaeDocument)
      {
         super(param1,param2);
         this.constructImages();
      }
      
      private function constructImages() : void
      {
         var _loc2_:XML = null;
         var _loc3_:DaeImage = null;
         var _loc1_:XMLList = data..image;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new DaeImage(_loc2_,document);
            if(_loc3_.id != null)
            {
               document.images[_loc3_.id] = _loc3_;
            }
         }
      }
      
      override protected function parseImplementation() : Boolean
      {
         var element:XML = null;
         var param:DaeParam = null;
         var technique:XML = null;
         var transparentXML:XML = null;
         var transparencyXML:XML = null;
         var emissionXML:XML = null;
         var diffuseXML:XML = null;
         this.effectParams = new Object();
         for each(element in data.newparam)
         {
            param = new DaeParam(element,document);
            this.effectParams[param.sid] = param;
         }
         this.commonParams = new Object();
         for each(element in data.profile_COMMON.newparam)
         {
            param = new DaeParam(element,document);
            this.commonParams[param.sid] = param;
         }
         this.techniqueParams = new Object();
         technique = data.profile_COMMON.technique[0];
         if(technique != null)
         {
            for each(element in technique.newparam)
            {
               param = new DaeParam(element,document);
               this.techniqueParams[param.sid] = param;
            }
         }
         var shader:XML = data.profile_COMMON.technique.*.(localName() == "constant" || localName() == "lambert" || localName() == "phong" || localName() == "blinn")[0];
         if(shader != null)
         {
            if(shader.localName() == "constant")
            {
               emissionXML = shader.emission[0];
               if(emissionXML != null)
               {
                  this.emission = new DaeEffectParam(emissionXML,this);
               }
            }
            else
            {
               diffuseXML = shader.diffuse[0];
               if(diffuseXML != null)
               {
                  this.diffuse = new DaeEffectParam(diffuseXML,this);
               }
            }
            transparentXML = shader.transparent[0];
            if(transparentXML != null)
            {
               this.transparent = new DaeEffectParam(transparentXML,this);
            }
            transparencyXML = shader.transparency[0];
            if(transparencyXML != null)
            {
               this.transparency = new DaeEffectParam(transparencyXML,this);
            }
         }
         return true;
      }
      
      public function getParam(param1:String, param2:Object) : DaeParam
      {
         var _loc3_:DaeParam = param2[param1];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         _loc3_ = this.techniqueParams[param1];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         _loc3_ = this.commonParams[param1];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         return this.effectParams[param1];
      }
      
      private function float4ToUint(param1:Array, param2:Boolean = true) : uint
      {
         var _loc6_:uint = 0;
         var _loc3_:uint = param1[0] * 255;
         var _loc4_:uint = param1[1] * 255;
         var _loc5_:uint = param1[2] * 255;
         if(param2)
         {
            _loc6_ = param1[3] * 255;
            return _loc6_ << 24 | _loc3_ << 16 | _loc4_ << 8 | _loc5_;
         }
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      public function getMaterial(param1:Object) : Material
      {
         var _loc3_:Array = null;
         var _loc4_:FillMaterial = null;
         var _loc5_:Number = NaN;
         var _loc6_:DaeImage = null;
         var _loc7_:DaeParam = null;
         var _loc8_:TextureMaterial = null;
         var _loc9_:DaeImage = null;
         var _loc2_:DaeEffectParam = this.diffuse != null ? this.diffuse : this.emission;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getColor(param1);
            if(_loc3_ != null)
            {
               _loc4_ = new FillMaterial(this.float4ToUint(_loc3_,false),_loc3_[3]);
               if(this.transparency != null)
               {
                  _loc5_ = this.transparency.getFloat(param1);
                  if(!isNaN(_loc5_))
                  {
                     _loc4_.alpha = _loc5_;
                  }
               }
               return _loc4_;
            }
            _loc6_ = _loc2_.getImage(param1);
            if(_loc6_ != null)
            {
               _loc7_ = _loc2_.getSampler(param1);
               _loc8_ = new TextureMaterial();
               _loc8_.repeat = _loc7_ == null ? Boolean(true) : _loc7_.wrap_s == null || _loc7_.wrap_s == "WRAP";
               _loc8_.diffuseMapURL = _loc6_.init_from;
               _loc9_ = this.transparent == null ? null : this.transparent.getImage(param1);
               if(_loc9_ != null)
               {
                  _loc8_.opacityMapURL = _loc9_.init_from;
               }
               return _loc8_;
            }
         }
         return null;
      }
      
      public function get diffuseTexCoords() : String
      {
         return this.diffuse == null && this.emission == null ? null : (this.diffuse != null ? this.diffuse.texCoord : this.emission.texCoord);
      }
   }
}
