package alternativa.engine3d.core
{
    import __AS3__.vec.Vector;
    import alternativa.gfx.core.VertexBufferResource;
    import alternativa.gfx.core.IndexBufferResource;
    import alternativa.gfx.core.Device;
    import alternativa.engine3d.materials.Material;
    import alternativa.engine3d.objects.Decal;
    import flash.utils.Dictionary;
    import alternativa.gfx.core.TextureResource;
    import alternativa.engine3d.lights.OmniLight;
    import alternativa.engine3d.lights.SpotLight;
    import alternativa.engine3d.lights.TubeLight;
    import alternativa.engine3d.lights.DirectionalLight;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import alternativa.engine3d.objects.Sprite3D;
    import flash.display3D.Context3DTriangleFace;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DClearMask;
    import flash.display3D.Context3DStencilAction;
    import flash.geom.Vector3D;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;
    import flash.utils.getTimer;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.system.System;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.display.StageAlign;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 
    import alternativa.types.Matrix4;

    use namespace alternativa3d;

    public class Camera3D extends Object3D 
    {
        private static const tmpOrigin:Vector3D = new Vector3D();
        private static const tmpDir:Vector3D = new Vector3D();

        alternativa3d static var renderId:int = 0;
        private static const constantsAttributesCount:int = 8;
        private static const constantsOffset:int = 16;
        private static const constantsMaxTriangles:int = 18;
        private static const constants:Vector.<Number> = new Vector.<Number>(((constantsMaxTriangles * 3) * constantsAttributesCount));
        private static const constantsVertexBuffer:VertexBufferResource = createConstantsVertexBuffer((constantsMaxTriangles * 3));
        private static const constantsIndexBuffer:IndexBufferResource = createConstantsIndexBuffer((constantsMaxTriangles * 3));

        alternativa3d var view:View;
        public var fov:Number = 1.5707963267949;
        public var nearClipping:Number = 1;
        public var farClipping:Number = 1000000;
        public var onRender:Function;
        alternativa3d var viewSizeX:Number;
        alternativa3d var viewSizeY:Number;
        alternativa3d var focalLength:Number;
        alternativa3d var correctionX:Number;
        alternativa3d var correctionY:Number;
        alternativa3d var lights:Vector.<Light3D> = new Vector.<Light3D>();
        alternativa3d var lightsLength:int = 0;
        alternativa3d var occluders:Vector.<Vertex> = new Vector.<Vertex>();
        alternativa3d var numOccluders:int;
        alternativa3d var occludedAll:Boolean;
        alternativa3d var numDraws:int;
        alternativa3d var numShadows:int;
        alternativa3d var numTriangles:int;
        alternativa3d var device:Device;
        alternativa3d var projection:Vector.<Number> = new Vector.<Number>(4);
        alternativa3d var correction:Vector.<Number> = new Vector.<Number>(4);
        alternativa3d var transform:Vector.<Number> = new Vector.<Number>(12);
        private var opaqueMaterials:Vector.<Material> = new Vector.<Material>();
        private var opaqueVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
        private var opaqueIndexBuffers:Vector.<IndexBufferResource> = new Vector.<IndexBufferResource>();
        private var opaqueFirstIndexes:Vector.<int> = new Vector.<int>();
        private var opaqueNumsTriangles:Vector.<int> = new Vector.<int>();
        private var opaqueObjects:Vector.<Object3D> = new Vector.<Object3D>();
        private var opaqueCount:int = 0;
        private var skyMaterials:Vector.<Material> = new Vector.<Material>();
        private var skyVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
        private var skyIndexBuffers:Vector.<IndexBufferResource> = new Vector.<IndexBufferResource>();
        private var skyFirstIndexes:Vector.<int> = new Vector.<int>();
        private var skyNumsTriangles:Vector.<int> = new Vector.<int>();
        private var skyObjects:Vector.<Object3D> = new Vector.<Object3D>();
        private var skyCount:int = 0;
        private var transparentFaceLists:Vector.<Face> = new Vector.<Face>();
        private var transparentObjects:Vector.<Object3D> = new Vector.<Object3D>();
        private var transparentCount:int = 0;
        private var transparentOpaqueFaceLists:Vector.<Face> = new Vector.<Face>();
        private var transparentOpaqueObjects:Vector.<Object3D> = new Vector.<Object3D>();
        private var transparentOpaqueCount:int = 0;
        private var transparentBatchObjects:Vector.<Object3D> = new Vector.<Object3D>();
        private var decals:Vector.<Decal> = new Vector.<Decal>();
        private var decalsCount:int = 0;
        alternativa3d var depthObjects:Vector.<Object3D> = new Vector.<Object3D>();
        alternativa3d var depthCount:int = 0;
        alternativa3d var casterObjects:Vector.<Object3D> = new Vector.<Object3D>();
        alternativa3d var casterCount:int = 0;
        alternativa3d var shadowAtlases:Array = new Array();
        alternativa3d var receiversVertexBuffers:Vector.<VertexBufferResource>;
        alternativa3d var receiversIndexBuffers:Vector.<IndexBufferResource>;
        alternativa3d var gma:Number;
        alternativa3d var gmb:Number;
        alternativa3d var gmc:Number;
        alternativa3d var gmd:Number;
        alternativa3d var gme:Number;
        alternativa3d var gmf:Number;
        alternativa3d var gmg:Number;
        alternativa3d var gmh:Number;
        alternativa3d var gmi:Number;
        alternativa3d var gmj:Number;
        alternativa3d var gmk:Number;
        alternativa3d var gml:Number;
        alternativa3d var fogParams:Vector.<Number> = Vector.<Number>([1, 1, 0, 1]);
        alternativa3d var fogFragment:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var fragmentConst:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0.5, 0.5, 0, (1 / 0x1000)]);
        private var shadows:Dictionary = new Dictionary();
        private var shadowList:Vector.<Shadow> = new Vector.<Shadow>();
        private var depthRenderer:DepthRenderer = new DepthRenderer();
        alternativa3d var depthMap:TextureResource;
        alternativa3d var lightMap:TextureResource;
        private var depthParams:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var ssaoParams:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var lightTransform:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);
        private var lightParams:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);
        alternativa3d var omnies:Vector.<OmniLight> = new Vector.<OmniLight>();
        alternativa3d var omniesCount:int = 0;
        alternativa3d var spots:Vector.<SpotLight> = new Vector.<SpotLight>();
        alternativa3d var spotsCount:int = 0;
        alternativa3d var tubes:Vector.<TubeLight> = new Vector.<TubeLight>();
        alternativa3d var tubesCount:int = 0;
        public var fogNear:Number = 0;
        public var fogFar:Number = 1000000;
        public var fogAlpha:Number = 0;
        public var fogColor:int = 0x7F7F7F;
        public var softTransparency:Boolean = false;
        public var depthBufferScale:Number = 1;
        public var ssao:Boolean = false;
        public var ssaoRadius:Number = 100;
        public var ssaoRange:Number = 1000;
        public var ssaoColor:int = 0;
        public var ssaoAlpha:Number = 1;
        public var directionalLight:DirectionalLight;
        public var shadowMap:ShadowMap;
        public var ambientColor:int = 0;
        public var deferredLighting:Boolean = false;
        public var fogStrength:Number = 1;
        public var softTransparencyStrength:Number = 1;
        public var ssaoStrength:Number = 1;
        public var directionalLightStrength:Number = 1;
        public var shadowMapStrength:Number = 1;
        public var shadowsStrength:Number = 1;
        public var shadowsDistanceMultiplier:Number = 1;
        public var deferredLightingStrength:Number = 1;
        public var debug:Boolean = false;
        private var debugSet:Object = new Object();
        private var _diagram:Sprite;
        public var fpsUpdatePeriod:int = 10;
        public var timerUpdatePeriod:int = 10;
        private var fpsTextField:TextField;
        private var memoryTextField:TextField;
        private var drawsTextField:TextField;
        private var shadowsTextField:TextField;
        private var trianglesTextField:TextField;
        private var timerTextField:TextField;
        private var graph:Bitmap;
        private var rect:Rectangle;
        private var _diagramAlign:String = "TR";
        private var _diagramHorizontalMargin:Number = 2;
        private var _diagramVerticalMargin:Number = 2;
        private var fpsUpdateCounter:int;
        private var previousFrameTime:int;
        private var previousPeriodTime:int;
        private var maxMemory:int;
        private var timerUpdateCounter:int;
        private var timeSum:int;
        private var timeCount:int;
        private var timer:int;
        private var firstVertex:Vertex;
        private var firstFace:Face;
        private var firstWrapper:Wrapper;
        alternativa3d var lastWrapper:Wrapper;
        alternativa3d var lastVertex:Vertex;
        alternativa3d var lastFace:Face;

        public function Camera3D()
        {
            this._diagram = this.createDiagram();
            this.firstVertex = new Vertex();
            this.firstFace = new Face();
            this.firstWrapper = new Wrapper();
            this.lastWrapper = this.firstWrapper;
            this.lastVertex = this.firstVertex;
            this.lastFace = this.firstFace;
            this.mouseEnabled = false;
            super();
        }

        private static function createConstantsVertexBuffer(_arg_1:int):VertexBufferResource
        {
            var _local_5:int;
            var _local_2:Vector.<Number> = new Vector.<Number>();
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                _local_2.push(((_local_3 << 1) + constantsOffset));
                _local_3++;
            };
            var _local_4:int;
            while (_local_4 < (_arg_1 << 1))
            {
                _local_5 = ((_local_4 * 4) + 3);
                constants[_local_5] = 1;
                _local_4++;
            };
            return (new VertexBufferResource(_local_2, 1));
        }

        private static function createConstantsIndexBuffer(_arg_1:int):IndexBufferResource
        {
            var _local_2:Vector.<uint> = new Vector.<uint>();
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                _local_2.push(_local_3);
                _local_3++;
            };
            return (new IndexBufferResource(_local_2));
        }


        public function addShadow(_arg_1:Shadow):void
        {
            this.shadows[_arg_1] = true;
        }

        public function removeShadow(_arg_1:Shadow):void
        {
            delete this.shadows[_arg_1];
        }

        public function removeAllShadows():void
        {
            this.shadows = new Dictionary();
        }

        public function render(present:Boolean = true):void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Shadow;
            var _local_5:Object3D;
            var _local_6:Light3D;
            var _local_7:ShadowAtlas;
            var _local_8:Boolean;
            var _local_9:Material;
            var _local_10:*;
            var _local_11:Decal;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:TextureResource;
            var _local_16:Face;
            var _local_17:Object3D;
            var _local_18:Boolean;
            var _local_19:Boolean;
            var _local_20:int;
            var _local_21:Sprite3D;
            var _local_22:Face;
            var _local_23:Face;
            var _local_24:Object3D;
            var _local_25:Sprite3D;
            this.numDraws = 0;
            this.numShadows = 0;
            this.numTriangles = 0;
            if ((((!(this.view == null)) && (!(this.view.device == null))) && (this.view.device.ready)))
            {
                renderId++;
                this.device = this.view.device;
                this.view.configure();
                if (this.nearClipping < 1)
                {
                    this.nearClipping = 1;
                };
                if (this.farClipping > 1000000)
                {
                    this.farClipping = 1000000;
                };
                this.viewSizeX = (this.view._width * 0.5);
                this.viewSizeY = (this.view._height * 0.5);
                this.focalLength = (Math.sqrt(((this.viewSizeX * this.viewSizeX) + (this.viewSizeY * this.viewSizeY))) / Math.tan((this.fov * 0.5)));
                this.correctionX = (this.viewSizeX / this.focalLength);
                this.correctionY = (this.viewSizeY / this.focalLength);
                this.projection[0] = (1 << this.view.zBufferPrecision);
                this.projection[1] = 1;
                this.projection[2] = (this.farClipping / (this.farClipping - this.nearClipping));
                this.projection[3] = ((this.nearClipping * this.farClipping) / (this.nearClipping - this.farClipping));
                this.composeCameraMatrix();
                _local_5 = this;
                while (_local_5._parent != null)
                {
                    _local_5 = _local_5._parent;
                    _local_5.composeMatrix();
                    appendMatrix(_local_5);
                };
                this.gma = ma;
                this.gmb = mb;
                this.gmc = mc;
                this.gmd = md;
                this.gme = me;
                this.gmf = mf;
                this.gmg = mg;
                this.gmh = mh;
                this.gmi = mi;
                this.gmj = mj;
                this.gmk = mk;
                this.gml = ml;
                invertMatrix();
                this.transform[0] = ma;
                this.transform[1] = mb;
                this.transform[2] = mc;
                this.transform[3] = md;
                this.transform[4] = me;
                this.transform[5] = mf;
                this.transform[6] = mg;
                this.transform[7] = mh;
                this.transform[8] = mi;
                this.transform[9] = mj;
                this.transform[10] = mk;
                this.transform[11] = ml;
                this.numOccluders = 0;
                this.occludedAll = false;
                if (((!(_local_5 == this)) && (_local_5.visible)))
                {
                    this.lightsLength = 0;
                    _local_6 = (_local_5 as Object3DContainer).lightList;
                    while (_local_6 != null)
                    {
                        if (_local_6.visible)
                        {
                            _local_6.calculateCameraMatrix(this);
                            if (_local_6.checkFrustumCulling(this))
                            {
                                this.lights[this.lightsLength] = _local_6;
                                this.lightsLength++;
                                if ((((!(this.view.constrained)) && (this.deferredLighting)) && (this.deferredLightingStrength > 0)))
                                {
                                    if ((_local_6 is OmniLight))
                                    {
                                        this.omnies[this.omniesCount] = (_local_6 as OmniLight);
                                        this.omniesCount++;
                                    } else
                                    {
                                        if ((_local_6 is SpotLight))
                                        {
                                            this.spots[this.spotsCount] = (_local_6 as SpotLight);
                                            this.spotsCount++;
                                        } else
                                        {
                                            if ((_local_6 is TubeLight))
                                            {
                                                this.tubes[this.tubesCount] = (_local_6 as TubeLight);
                                                this.tubesCount++;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                        _local_6 = _local_6.nextLight;
                    };
                    _local_5.appendMatrix(this);
                    _local_5.cullingInCamera(this, 63);
                    if (this.debug)
                    {
                        _local_1 = 0;
                        while (_local_1 < this.lightsLength)
                        {
                            (this.lights[_local_1] as Light3D).drawDebug(this);
                            _local_1++;
                        };
                    };
                    _local_8 = false;
                    if (((!(this.view.constrained)) && (this.shadowsStrength > 0)))
                    {
                        for (_local_10 in this.shadows)
                        {
                            _local_4 = _local_10;
                            if (_local_4.checkVisibility(this))
                            {
                                _local_2 = (_local_4.mapSize + _local_4.blur);
                                _local_7 = this.shadowAtlases[_local_2];
                                if (_local_7 == null)
                                {
                                    _local_7 = new ShadowAtlas(_local_4.mapSize, _local_4.blur);
                                    this.shadowAtlases[_local_2] = _local_7;
                                };
                                _local_7.shadows[_local_7.shadowsCount] = _local_4;
                                _local_7.shadowsCount++;
                                _local_8 = true;
                            };
                        };
                    };
                    this.device.setCulling(Context3DTriangleFace.FRONT);
                    this.device.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
                    this.device.setStencilActions(Context3DTriangleFace.NONE);
                    this.device.setStencilReferenceValue(0);
                    if (_local_8)
                    {
                        this.device.setCulling(Context3DTriangleFace.BACK);
                        this.device.setDepthTest(true, Context3DCompareMode.GREATER_EQUAL);
                        this.device.setProgram(Shadow.getCasterProgram());
                        for each (_local_7 in this.shadowAtlases)
                        {
                            if (_local_7.shadowsCount > 0)
                            {
                                _local_7.renderCasters(this);
                            };
                        };
                        this.device.setCulling(Context3DTriangleFace.FRONT);
                        this.device.setDepthTest(false, Context3DCompareMode.ALWAYS);
                        for each (_local_7 in this.shadowAtlases)
                        {
                            if (_local_7.shadowsCount > 0)
                            {
                                _local_7.renderBlur(this);
                            };
                        };
                        this.device.setTextureAt(0, null);
                        this.device.setVertexBufferAt(1, null);
                    };
                    if (this.directionalLight != null)
                    {
                        this.directionalLight.composeAndAppend(this);
                        this.directionalLight.calculateInverseMatrix();
                    };
                    _local_5.concatenatedAlpha = _local_5.alpha;
                    _local_5.concatenatedBlendMode = _local_5.blendMode;
                    _local_5.concatenatedColorTransform = _local_5.colorTransform;
                    _local_5.draw(this);
                    this.device.setDepthTest(true, Context3DCompareMode.LESS);
                    if ((((!(this.view.constrained)) && (!(this.shadowMap == null))) && (this.shadowMapStrength > 0)))
                    {
                        this.shadowMap.calculateBounds(this);
                        this.shadowMap.render(this, this.casterObjects, this.casterCount);
                    };
                    this.depthMap = null;
                    this.lightMap = null;
                    if (((!(this.view.constrained)) && ((((this.softTransparency) && (this.softTransparencyStrength > 0)) || ((this.ssao) && (this.ssaoStrength > 0))) || ((this.deferredLighting) && (this.deferredLightingStrength > 0)))))
                    {
                        this.depthRenderer.render(this, this.view._width, this.view._height, this.depthBufferScale, ((this.ssao) && (this.ssaoStrength > 0)), ((this.deferredLighting) && (this.deferredLightingStrength > 0)), ((((!(this.directionalLight == null)) && (this.directionalLightStrength > 0)) || ((!(this.shadowMap == null)) && (this.shadowMapStrength > 0))) ? 0 : 0.5), this.depthObjects, this.depthCount);
                        if ((((this.softTransparency) && (this.softTransparencyStrength > 0)) || ((this.ssao) && (this.ssaoStrength > 0))))
                        {
                            this.depthMap = this.depthRenderer.depthBuffer;
                        };
                        if (((this.deferredLighting) && (this.deferredLightingStrength > 0)))
                        {
                            this.lightMap = this.depthRenderer.lightBuffer;
                        };
                    } else
                    {
                        this.depthRenderer.resetResources();
                    };
                    if ((((_local_8) || ((!(this.view.constrained)) && ((((this.softTransparency) && (this.softTransparencyStrength > 0)) || ((this.ssao) && (this.ssaoStrength > 0))) || ((this.deferredLighting) && (this.deferredLightingStrength > 0))))) || (((!(this.view.constrained)) && (!(this.shadowMap == null))) && (this.shadowMapStrength > 0))))
                    {
                        this.device.setRenderToBackBuffer();
                    };
                    this.view.clearArea();
                    this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 3, this.projection, 1);
                    this.fragmentConst[0] = this.farClipping;
                    this.fragmentConst[1] = (this.farClipping / 0xFF);
                    this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 17, this.fragmentConst, 2);
                    this.correction[0] = (this.view.rect.width / this.device.width);
                    this.correction[1] = (this.view.rect.height / this.device.height);
                    this.correction[2] = ((((this.view.rect.x * 2) + this.view.rect.width) - this.device.width) / this.device.width);
                    this.correction[3] = ((((this.view.rect.y * 2) + this.view.rect.height) - this.device.height) / this.device.height);
                    this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, this.correction, 1);
                    if (((!(this.view.constrained)) && (((((this.softTransparency) && (this.softTransparencyStrength > 0)) || ((this.ssao) && (this.ssaoStrength > 0))) || ((this.deferredLighting) && (this.deferredLightingStrength > 0))) || ((!(this.shadowMap == null)) && (this.shadowMapStrength > 0)))))
                    {
                        this.depthParams[0] = this.depthRenderer.correctionX;
                        this.depthParams[1] = this.depthRenderer.correctionY;
                        this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, this.depthParams, 1);
                        if (((this.ssao) && (this.ssaoStrength > 0)))
                        {
                            this.ssaoParams[0] = (((1 - ((2 * ((this.ssaoColor >> 16) & 0xFF)) / 0xFF)) * this.ssaoAlpha) * this.ssaoStrength);
                            this.ssaoParams[1] = (((1 - ((2 * ((this.ssaoColor >> 8) & 0xFF)) / 0xFF)) * this.ssaoAlpha) * this.ssaoStrength);
                            this.ssaoParams[2] = (((1 - ((2 * (this.ssaoColor & 0xFF)) / 0xFF)) * this.ssaoAlpha) * this.ssaoStrength);
                            this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 12, this.ssaoParams, 1);
                        };
                    };
                    if ((((!(this.view.constrained)) && (!(this.shadowMap == null))) && (this.shadowMapStrength > 0)))
                    {
                        this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, this.shadowMap.transform, 4);
                        this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, this.shadowMap.params, 5);
                    };
                    if (((this.fogAlpha > 0) && (this.fogStrength > 0)))
                    {
                        this.fogParams[2] = this.fogNear;
                        this.fogParams[3] = (this.fogFar - this.fogNear);
                        this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, this.fogParams, 1);
                        this.fogFragment[0] = (((this.fogColor >> 16) & 0xFF) / 0xFF);
                        this.fogFragment[1] = (((this.fogColor >> 8) & 0xFF) / 0xFF);
                        this.fogFragment[2] = ((this.fogColor & 0xFF) / 0xFF);
                        this.fogFragment[3] = (this.fogAlpha * this.fogStrength);
                        this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.fogFragment, 1);
                    };
                    if ((((!(this.view.constrained)) && (!(this.directionalLight == null))) && (this.directionalLightStrength > 0)))
                    {
                        this.lightTransform[0] = -(this.directionalLight.imi);
                        this.lightTransform[1] = -(this.directionalLight.imj);
                        this.lightTransform[2] = -(this.directionalLight.imk);
                        this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, this.lightTransform, 1);
                        this.lightParams[0] = ((((this.directionalLight.intensity * ((this.directionalLight.color >> 16) & 0xFF)) * 2) * this.directionalLightStrength) / 0xFF);
                        this.lightParams[1] = ((((this.directionalLight.intensity * ((this.directionalLight.color >> 8) & 0xFF)) * 2) * this.directionalLightStrength) / 0xFF);
                        this.lightParams[2] = ((((this.directionalLight.intensity * (this.directionalLight.color & 0xFF)) * 2) * this.directionalLightStrength) / 0xFF);
                        this.lightParams[4] = (1 + ((((((this.ambientColor >> 16) & 0xFF) * 2) / 0xFF) - 1) * this.directionalLightStrength));
                        this.lightParams[5] = (1 + ((((((this.ambientColor >> 8) & 0xFF) * 2) / 0xFF) - 1) * this.directionalLightStrength));
                        this.lightParams[6] = (1 + (((((this.ambientColor & 0xFF) * 2) / 0xFF) - 1) * this.directionalLightStrength));
                        this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 10, this.lightParams, 2);
                    } else
                    {
                        if ((((!(this.view.constrained)) && (!(this.shadowMap == null))) && (this.shadowMapStrength > 0)))
                        {
                            this.lightParams[0] = 0;
                            this.lightParams[1] = 0;
                            this.lightParams[2] = 0;
                            this.lightParams[4] = 1;
                            this.lightParams[5] = 1;
                            this.lightParams[6] = 1;
                            this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 10, this.lightParams, 2);
                        };
                    };
                    _local_1 = 0;
                    while (_local_1 < this.opaqueCount)
                    {
                        _local_9 = this.opaqueMaterials[_local_1];
                        _local_9.drawOpaque(this, this.opaqueVertexBuffers[_local_1], this.opaqueIndexBuffers[_local_1], this.opaqueFirstIndexes[_local_1], this.opaqueNumsTriangles[_local_1], this.opaqueObjects[_local_1]);
                        _local_1++;
                    };
                    this.device.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
                    _local_1 = 0;
                    while (_local_1 < this.skyCount)
                    {
                        _local_9 = this.skyMaterials[_local_1];
                        _local_9.drawOpaque(this, this.skyVertexBuffers[_local_1], this.skyIndexBuffers[_local_1], this.skyFirstIndexes[_local_1], this.skyNumsTriangles[_local_1], this.skyObjects[_local_1]);
                        _local_1++;
                    };
                    this.device.setDepthTest(false, Context3DCompareMode.LESS);
                    _local_1 = (this.decalsCount - 1);
                    while (_local_1 >= 0)
                    {
                        _local_11 = this.decals[_local_1];
                        if (_local_11.concatenatedBlendMode != "normal")
                        {
                            this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
                        } else
                        {
                            this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                        };
                        _local_11.faceList.material.drawOpaque(this, _local_11.vertexBuffer, _local_11.indexBuffer, 0, _local_11.numTriangles, _local_11);
                        _local_1--;
                    };
                    if (_local_8)
                    {
                        this.device.setTextureAt(0, null);
                        this.device.setTextureAt(1, null);
                        this.device.setTextureAt(2, null);
                        this.device.setTextureAt(3, null);
                        this.device.setTextureAt(5, null);
                        this.device.setVertexBufferAt(1, null);
                        this.device.setVertexBufferAt(2, null);
                        _local_12 = 0;
                        for each (_local_7 in this.shadowAtlases)
                        {
                            _local_1 = 0;
                            while (_local_1 < _local_7.shadowsCount)
                            {
                                this.shadowList[_local_12] = _local_7.shadows[_local_1];
                                _local_12++;
                                _local_1++;
                            };
                        };
                        this.device.setDepthTest(false, Context3DCompareMode.LESS);
                        _local_15 = null;
                        _local_1 = 0;
                        while (_local_1 < _local_12)
                        {
                            if (_local_1 > 0)
                            {
                                this.device.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.STENCIL);
                            };
                            this.device.setBlendFactors(Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE);
                            this.device.setCulling(Context3DTriangleFace.NONE);
                            this.device.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.INVERT);
                            _local_13 = _local_1;
                            _local_14 = 1;
                            while (((_local_13 < (_local_1 + 8)) && (_local_13 < _local_12)))
                            {
                                _local_4 = this.shadowList[_local_13];
                                if ((!(_local_4.cameraInside)))
                                {
                                    this.device.setStencilReferenceValue(_local_14, _local_14, _local_14);
                                    _local_4.renderVolume(this);
                                };
                                _local_13++;
                                _local_14 = (_local_14 << 1);
                            };
                            this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                            this.device.setCulling(Context3DTriangleFace.FRONT);
                            this.device.setStencilActions(Context3DTriangleFace.BACK, Context3DCompareMode.EQUAL);
                            _local_13 = _local_1;
                            _local_14 = 1;
                            while (((_local_13 < (_local_1 + 8)) && (_local_13 < _local_12)))
                            {
                                _local_4 = this.shadowList[_local_13];
                                if (_local_4.texture != _local_15)
                                {
                                    this.device.setTextureAt(0, _local_4.texture);
                                    _local_15 = _local_4.texture;
                                };
                                if ((!(_local_4.cameraInside)))
                                {
                                    this.device.setStencilReferenceValue(_local_14, _local_14, _local_14);
                                    _local_4.renderReceivers(this);
                                } else
                                {
                                    this.device.setStencilActions(Context3DTriangleFace.BACK, Context3DCompareMode.ALWAYS);
                                    _local_4.renderReceivers(this);
                                    this.device.setStencilActions(Context3DTriangleFace.BACK, Context3DCompareMode.EQUAL);
                                };
                                _local_13++;
                                _local_14 = (_local_14 << 1);
                            };
                            this.device.setTextureAt(0, null);
                            _local_15 = null;
                            _local_1 = (_local_1 + 8);
                        };
                        this.device.setStencilActions();
                        this.device.setStencilReferenceValue(0);
                    };
                    this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, this.correction, 1);
                    this.device.setCulling(Context3DTriangleFace.FRONT);
                    _local_1 = 0;
                    while (_local_1 < this.transparentOpaqueCount)
                    {
                        if (((_local_1 < this.transparentOpaqueFaceLists.length) && (_local_1 < this.transparentOpaqueObjects.length)))
                        {
                            this.transparentFaceLists[this.transparentCount] = this.transparentOpaqueFaceLists[_local_1];
                            this.transparentObjects[this.transparentCount] = this.transparentOpaqueObjects[_local_1];
                            this.transparentCount++;
                        };
                        _local_1++;
                    };
                    this.transparentOpaqueCount = (this.transparentCount - this.transparentOpaqueCount);
                    this.device.setDepthTest(true, Context3DCompareMode.LESS);
                    _local_1 = (this.transparentCount - 1);
                    while (_local_1 >= 0)
                    {
                        if ((_local_1 + 1) == this.transparentOpaqueCount)
                        {
                            this.device.setDepthTest(false, Context3DCompareMode.LESS);
                        };
                        _local_16 = this.transparentFaceLists[_local_1];
                        _local_17 = this.transparentObjects[_local_1];
                        if (_local_17.concatenatedBlendMode != "normal")
                        {
                            this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
                        } else
                        {
                            this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                        };
                        _local_18 = (_local_17 is Sprite3D);
                        if (_local_18)
                        {
                            _local_20 = 0;
                            _local_21 = Sprite3D(_local_17);
                            _local_22 = _local_16;
                            while (_local_22.processNext != null)
                            {
                                _local_22.distance = _local_20;
                                _local_22 = _local_22.processNext;
                            };
                            _local_22.distance = _local_20;
                            this.transparentBatchObjects[_local_20] = _local_17;
                            _local_20++;
                            _local_13 = (_local_1 - 1);
                            while (_local_13 >= 0)
                            {
                                _local_23 = this.transparentFaceLists[_local_13];
                                if (_local_16.material != _local_23.material) break;
                                _local_24 = this.transparentObjects[_local_13];
                                if ((_local_24 is Sprite3D))
                                {
                                    _local_25 = Sprite3D(_local_24);
                                    if ((((((((((!(_local_21.useLight == _local_25.useLight)) || (!(_local_21.useShadowMap == _local_25.useShadowMap))) || (_local_21.lighted)) || (_local_25.lighted)) || (!(_local_21.softAttenuation == _local_25.softAttenuation))) || (!(_local_21.concatenatedAlpha == _local_25.concatenatedAlpha))) || (!(_local_21.concatenatedColorTransform == null))) || (!(_local_25.concatenatedColorTransform == null))) || (!(_local_21.concatenatedBlendMode == _local_25.concatenatedBlendMode)))) break;
                                } else
                                {
                                    break;
                                };
                                _local_22.processNext = _local_23;
                                _local_22 = _local_23;
                                while (_local_22.processNext != null)
                                {
                                    _local_22.distance = _local_20;
                                    _local_22 = _local_22.processNext;
                                };
                                _local_22.distance = _local_20;
                                this.transparentBatchObjects[_local_20] = _local_24;
                                _local_20++;
                                _local_1--;
                                _local_13--;
                            };
                        };
                        _local_19 = ((_local_18) && (!(Sprite3D(_local_17).depthTest)));
                        if (_local_19)
                        {
                            this.device.setDepthTest(false, Context3DCompareMode.ALWAYS);
                        };
                        this.drawTransparentList(_local_16, _local_17, _local_18);
                        if (_local_19)
                        {
                            this.device.setDepthTest(false, Context3DCompareMode.LESS);
                        };
                        _local_1--;
                    };
                    this.device.setTextureAt(0, null);
                    this.device.setTextureAt(1, null);
                    this.device.setTextureAt(2, null);
                    this.device.setTextureAt(3, null);
                    this.device.setTextureAt(5, null);
                    this.device.setTextureAt(6, null);
                    this.device.setTextureAt(7, null);
                    this.device.setVertexBufferAt(1, null);
                    this.device.setVertexBufferAt(2, null);
                    this.device.setVertexBufferAt(3, null);
                    this.device.setVertexBufferAt(4, null);
                    this.device.setVertexBufferAt(5, null);
                    this.device.setVertexBufferAt(6, null);
                    this.device.setVertexBufferAt(7, null);
                    this.opaqueMaterials.length = 0;
                    this.opaqueVertexBuffers.length = 0;
                    this.opaqueIndexBuffers.length = 0;
                    this.opaqueFirstIndexes.length = 0;
                    this.opaqueNumsTriangles.length = 0;
                    this.opaqueObjects.length = 0;
                    this.opaqueCount = 0;
                    this.skyMaterials.length = 0;
                    this.skyVertexBuffers.length = 0;
                    this.skyIndexBuffers.length = 0;
                    this.skyFirstIndexes.length = 0;
                    this.skyNumsTriangles.length = 0;
                    this.skyObjects.length = 0;
                    this.skyCount = 0;
                    this.transparentFaceLists.length = 0;
                    this.transparentObjects.length = 0;
                    this.transparentCount = 0;
                    this.transparentOpaqueFaceLists.length = 0;
                    this.transparentOpaqueObjects.length = 0;
                    this.transparentOpaqueCount = 0;
                    this.transparentBatchObjects.length = 0;
                    this.decals.length = 0;
                    this.decalsCount = 0;
                    this.depthObjects.length = 0;
                    this.depthCount = 0;
                    this.casterObjects.length = 0;
                    this.casterCount = 0;
                    this.omnies.length = 0;
                    this.omniesCount = 0;
                    this.spots.length = 0;
                    this.spotsCount = 0;
                    this.tubes.length = 0;
                    this.tubesCount = 0;
                    for each (_local_7 in this.shadowAtlases)
                    {
                        if (_local_7.shadowsCount > 0)
                        {
                            _local_7.clear();
                        };
                    };
                    this.receiversVertexBuffers = null;
                    this.receiversIndexBuffers = null;
                    this.deferredDestroy();
                    this.clearOccluders();
                    this.view.onRender(this);
                    if (this.onRender != null)
                    {
                        this.onRender();
                    };
                    if(present)
                    {
                        this.view.present();
                    }
                } else
                {
                    this.view.clearArea();
                    if (this.onRender != null)
                    {
                        this.onRender();
                    };
                    if(present)
                    {
                        this.view.present();
                    }
                };
                this.device = null;
            };
        }

        private function drawTransparentList(_arg_1:Face, _arg_2:Object3D, _arg_3:Boolean):void
        {
            var _local_4:Vertex;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Wrapper;
            var _local_8:Face;
            var _local_12:int;
            var _local_13:Object3D;
            var _local_9:int;
            var _local_10:int;
            var _local_11:Material = _arg_1.material;
            while (_arg_1 != null)
            {
                _local_8 = _arg_1.processNext;
                _arg_1.processNext = null;
                _local_7 = _arg_1.wrapper;
                _local_4 = _local_7.vertex;
                _local_7 = _local_7.next;
                _local_5 = _local_7.vertex;
                if (_arg_3)
                {
                    _local_12 = _arg_1.distance;
                    _local_13 = this.transparentBatchObjects[_local_12];
                    _local_7 = _local_7.next;
                    while (_local_7 != null)
                    {
                        if (_local_10 == constantsMaxTriangles)
                        {
                            if (_local_11 != null)
                            {
                                this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, constantsOffset, constants, (_local_10 * 6), false);
                                _local_11.drawTransparent(this, constantsVertexBuffer, constantsIndexBuffer, 0, _local_10, _arg_2, true);
                            };
                            _local_10 = 0;
                            _local_9 = 0;
                        };
                        _local_6 = _local_7.vertex;
                        constants[_local_9] = _local_4.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_4.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_4.cameraZ;
                        _local_9++;
                        constants[_local_9] = -(_local_13.md);
                        _local_9++;
                        constants[_local_9] = _local_4.u;
                        _local_9++;
                        constants[_local_9] = _local_4.v;
                        _local_9++;
                        constants[_local_9] = -(_local_13.mh);
                        _local_9++;
                        constants[_local_9] = -(_local_13.ml);
                        _local_9++;
                        constants[_local_9] = _local_5.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_5.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_5.cameraZ;
                        _local_9++;
                        constants[_local_9] = -(_local_13.md);
                        _local_9++;
                        constants[_local_9] = _local_5.u;
                        _local_9++;
                        constants[_local_9] = _local_5.v;
                        _local_9++;
                        constants[_local_9] = -(_local_13.mh);
                        _local_9++;
                        constants[_local_9] = -(_local_13.ml);
                        _local_9++;
                        constants[_local_9] = _local_6.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_6.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_6.cameraZ;
                        _local_9++;
                        constants[_local_9] = -(_local_13.md);
                        _local_9++;
                        constants[_local_9] = _local_6.u;
                        _local_9++;
                        constants[_local_9] = _local_6.v;
                        _local_9++;
                        constants[_local_9] = -(_local_13.mh);
                        _local_9++;
                        constants[_local_9] = -(_local_13.ml);
                        _local_9++;
                        _local_10++;
                        _local_5 = _local_6;
                        _local_7 = _local_7.next;
                    };
                } else
                {
                    _local_7 = _local_7.next;
                    while (_local_7 != null)
                    {
                        if (_local_10 == constantsMaxTriangles)
                        {
                            if (_local_11 != null)
                            {
                                this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, constantsOffset, constants, (_local_10 * 6), false);
                                _local_11.drawTransparent(this, constantsVertexBuffer, constantsIndexBuffer, 0, _local_10, _arg_2, true);
                            };
                            _local_10 = 0;
                            _local_9 = 0;
                        };
                        _local_6 = _local_7.vertex;
                        constants[_local_9] = _local_4.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_4.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_4.cameraZ;
                        _local_9++;
                        constants[_local_9] = _local_4.normalX;
                        _local_9++;
                        constants[_local_9] = _local_4.u;
                        _local_9++;
                        constants[_local_9] = _local_4.v;
                        _local_9++;
                        constants[_local_9] = _local_4.normalY;
                        _local_9++;
                        constants[_local_9] = _local_4.normalZ;
                        _local_9++;
                        constants[_local_9] = _local_5.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_5.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_5.cameraZ;
                        _local_9++;
                        constants[_local_9] = _local_5.normalX;
                        _local_9++;
                        constants[_local_9] = _local_5.u;
                        _local_9++;
                        constants[_local_9] = _local_5.v;
                        _local_9++;
                        constants[_local_9] = _local_5.normalY;
                        _local_9++;
                        constants[_local_9] = _local_5.normalZ;
                        _local_9++;
                        constants[_local_9] = _local_6.cameraX;
                        _local_9++;
                        constants[_local_9] = _local_6.cameraY;
                        _local_9++;
                        constants[_local_9] = _local_6.cameraZ;
                        _local_9++;
                        constants[_local_9] = _local_6.normalX;
                        _local_9++;
                        constants[_local_9] = _local_6.u;
                        _local_9++;
                        constants[_local_9] = _local_6.v;
                        _local_9++;
                        constants[_local_9] = _local_6.normalY;
                        _local_9++;
                        constants[_local_9] = _local_6.normalZ;
                        _local_9++;
                        _local_10++;
                        _local_5 = _local_6;
                        _local_7 = _local_7.next;
                    };
                };
                _arg_1 = _local_8;
            };
            if (((_local_10 > 0) && (!(_local_11 == null))))
            {
                this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX, constantsOffset, constants, (_local_10 * 6), false);
                _local_11.drawTransparent(this, constantsVertexBuffer, constantsIndexBuffer, 0, _local_10, _arg_2, true);
            };
        }

        public function lookAt(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Number = (_arg_1 - this.x);
            var _local_5:Number = (_arg_2 - this.y);
            var _local_6:Number = (_arg_3 - this.z);
            rotationX = (Math.atan2(_local_6, Math.sqrt(((_local_4 * _local_4) + (_local_5 * _local_5)))) - (Math.PI / 2));
            rotationY = 0;
            rotationZ = -(Math.atan2(_local_4, _local_5));
        }

        public function projectGlobal(_arg_1:Vector3D):Vector3D
        {
            if (this.view == null)
            {
                throw (new Error("It is necessary to have view set."));
            };
            this.viewSizeX = (this.view._width * 0.5);
            this.viewSizeY = (this.view._height * 0.5);
            this.focalLength = (Math.sqrt(((this.viewSizeX * this.viewSizeX) + (this.viewSizeY * this.viewSizeY))) / Math.tan((this.fov * 0.5)));
            this.composeCameraMatrix();
            var _local_2:Object3D = this;
            while (_local_2._parent != null)
            {
                _local_2 = _local_2._parent;
                tA.composeMatrixFromSource(_local_2);
                appendMatrix(tA);
            };
            invertMatrix();
            var _local_3:Vector3D = new Vector3D();
            _local_3.x = ((((ma * _arg_1.x) + (mb * _arg_1.y)) + (mc * _arg_1.z)) + md);
            _local_3.y = ((((me * _arg_1.x) + (mf * _arg_1.y)) + (mg * _arg_1.z)) + mh);
            _local_3.z = ((((mi * _arg_1.x) + (mj * _arg_1.y)) + (mk * _arg_1.z)) + ml);
            _local_3.x = (((_local_3.x * this.viewSizeX) / _local_3.z) + this.viewSizeX);
            _local_3.y = (((_local_3.y * this.viewSizeY) / _local_3.z) + this.viewSizeY);
            return (_local_3);
        }

        public function calculateRay(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Number, _arg_4:Number):void
        {
            if (this.view == null)
            {
                throw (new Error("It is necessary to have view set."));
            };
            this.viewSizeX = (this.view._width * 0.5);
            this.viewSizeY = (this.view._height * 0.5);
            this.focalLength = (Math.sqrt(((this.viewSizeX * this.viewSizeX) + (this.viewSizeY * this.viewSizeY))) / Math.tan((this.fov * 0.5)));
            _arg_3 = (_arg_3 - this.viewSizeX);
            _arg_4 = (_arg_4 - this.viewSizeY);
            var _local_5:Number = ((_arg_3 * this.focalLength) / this.viewSizeX);
            var _local_6:Number = ((_arg_4 * this.focalLength) / this.viewSizeY);
            var _local_7:Number = this.focalLength;
            var _local_8:Number = ((_local_5 * this.nearClipping) / this.focalLength);
            var _local_9:Number = ((_local_6 * this.nearClipping) / this.focalLength);
            var _local_10:Number = this.nearClipping;
            this.composeCameraMatrix();
            var _local_11:Object3D = this;
            while (_local_11._parent != null)
            {
                _local_11 = _local_11._parent;
                tA.composeMatrixFromSource(_local_11);
                appendMatrix(tA);
            };
            _arg_1.x = ((((ma * _local_8) + (mb * _local_9)) + (mc * _local_10)) + md);
            _arg_1.y = ((((me * _local_8) + (mf * _local_9)) + (mg * _local_10)) + mh);
            _arg_1.z = ((((mi * _local_8) + (mj * _local_9)) + (mk * _local_10)) + ml);
            _arg_2.x = (((ma * _local_5) + (mb * _local_6)) + (mc * _local_7));
            _arg_2.y = (((me * _local_5) + (mf * _local_6)) + (mg * _local_7));
            _arg_2.z = (((mi * _local_5) + (mj * _local_6)) + (mk * _local_7));
            var _local_12:Number = (1 / Math.sqrt((((_arg_2.x * _arg_2.x) + (_arg_2.y * _arg_2.y)) + (_arg_2.z * _arg_2.z))));
            _arg_2.x = (_arg_2.x * _local_12);
            _arg_2.y = (_arg_2.y * _local_12);
            _arg_2.z = (_arg_2.z * _local_12);
        }


        public function projectViewPointToPlane(param1:Point, param2:Vector3D, param3:Number, param4:Vector3D = null) : Vector3D
        {
            if(param4 == null)
            {
                param4 = new Vector3D();
            }
            this.calculateRayOriginAndVector(param1.x - (this.view._width >> 1),param1.y - (this.view._height >> 1),tmpOrigin,tmpDir,true);
            if(!this.calculateLineAndPlaneIntersection(tmpOrigin,tmpDir,param2,param3,param4))
            {
                param4.setTo(NaN,NaN,NaN);
            }
            return param4;
        }

        private function calculateRayOriginAndVector(param1:Number, param2:Number, param3:Vector3D, param4:Vector3D, param5:Boolean = false) : void
        {
            var loc6:Number = NaN;
            var loc7:Number = NaN;
            var loc8:Number = NaN;
            var loc9:Matrix4 = null;
            if(param5)
            {
                loc9 = Object3D.tmpMatrix4;
                this.getTransformation(loc9);
            }
            else
            {
                loc9 = this.transformation;
            }
            param3.x = loc9.d;
            param3.y = loc9.h;
            param3.z = loc9.l;
            loc6 = param1;
            loc7 = param2;
            if(param5)
            {
                loc8 = this.focalLength;
            }
            else
            {
                loc8 = this.focalLength;
            }
            param4.x = loc6 * loc9.a + loc7 * loc9.b + loc8 * loc9.c;
            param4.y = loc6 * loc9.e + loc7 * loc9.f + loc8 * loc9.g;
            param4.z = loc6 * loc9.i + loc7 * loc9.j + loc8 * loc9.k;
        }

        private function calculateLineAndPlaneIntersection(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number, param5:Vector3D) : Boolean
        {
            var loc6:Number = param3.x * param2.x + param3.y * param2.y + param3.z * param2.z;
            if(loc6 < 1e-8 && loc6 > -1e-8)
            {
                return false;
            }
            var loc7:Number = (param4 - param1.x * param3.x - param1.y * param3.y - param1.z * param3.z) / loc6;
            param5.x = param1.x + loc7 * param2.x;
            param5.y = param1.y + loc7 * param2.y;
            param5.z = param1.z + loc7 * param2.z;
            return true;
        }

        override public function clone():Object3D
        {
            var _local_1:Camera3D = new Camera3D();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            var _local_3:*;
            super.clonePropertiesFrom(_arg_1);
            var _local_2:Camera3D = (_arg_1 as Camera3D);
            this.fov = _local_2.fov;
            this.nearClipping = _local_2.nearClipping;
            this.farClipping = _local_2.farClipping;
            this.debug = _local_2.debug;
            this.fogNear = _local_2.fogNear;
            this.fogFar = _local_2.fogFar;
            this.fogAlpha = _local_2.fogAlpha;
            this.fogColor = _local_2.fogColor;
            this.softTransparency = _local_2.softTransparency;
            this.depthBufferScale = _local_2.depthBufferScale;
            this.ssao = _local_2.ssao;
            this.ssaoRadius = _local_2.ssaoRadius;
            this.ssaoRange = _local_2.ssaoRange;
            this.ssaoColor = _local_2.ssaoColor;
            this.ssaoAlpha = _local_2.ssaoAlpha;
            this.directionalLight = _local_2.directionalLight;
            this.shadowMap = _local_2.shadowMap;
            this.ambientColor = _local_2.ambientColor;
            this.deferredLighting = _local_2.deferredLighting;
            this.fogStrength = _local_2.fogStrength;
            this.softTransparencyStrength = _local_2.softTransparencyStrength;
            this.ssaoStrength = _local_2.ssaoStrength;
            this.directionalLightStrength = _local_2.directionalLightStrength;
            this.shadowMapStrength = _local_2.shadowMapStrength;
            this.shadowsStrength = _local_2.shadowsStrength;
            this.shadowsDistanceMultiplier = _local_2.shadowsDistanceMultiplier;
            this.deferredLightingStrength = _local_2.deferredLightingStrength;
            for (_local_3 in _local_2.shadows)
            {
                this.shadows[_local_3] = true;
            };
        }

        alternativa3d function addOpaque(_arg_1:Material, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D):void
        {
            this.opaqueMaterials[this.opaqueCount] = _arg_1;
            this.opaqueVertexBuffers[this.opaqueCount] = _arg_2;
            this.opaqueIndexBuffers[this.opaqueCount] = _arg_3;
            this.opaqueFirstIndexes[this.opaqueCount] = _arg_4;
            this.opaqueNumsTriangles[this.opaqueCount] = _arg_5;
            this.opaqueObjects[this.opaqueCount] = _arg_6;
            this.opaqueCount++;
        }

        alternativa3d function addSky(_arg_1:Material, _arg_2:VertexBufferResource, _arg_3:IndexBufferResource, _arg_4:int, _arg_5:int, _arg_6:Object3D):void
        {
            this.skyMaterials[this.skyCount] = _arg_1;
            this.skyVertexBuffers[this.skyCount] = _arg_2;
            this.skyIndexBuffers[this.skyCount] = _arg_3;
            this.skyFirstIndexes[this.skyCount] = _arg_4;
            this.skyNumsTriangles[this.skyCount] = _arg_5;
            this.skyObjects[this.skyCount] = _arg_6;
            this.skyCount++;
        }

        alternativa3d function addTransparent(_arg_1:Face, _arg_2:Object3D):void
        {
            this.transparentFaceLists[this.transparentCount] = _arg_1;
            this.transparentObjects[this.transparentCount] = _arg_2;
            this.transparentCount++;
        }

        alternativa3d function addTransparentOpaque(_arg_1:Face, _arg_2:Object3D):void
        {
            this.transparentOpaqueFaceLists[this.transparentOpaqueCount] = _arg_1;
            this.transparentOpaqueObjects[this.transparentOpaqueCount] = _arg_2;
            this.transparentOpaqueCount++;
        }

        alternativa3d function addDecal(_arg_1:Decal):void
        {
            this.decals[this.decalsCount] = _arg_1;
            this.decalsCount++;
        }

        alternativa3d function composeCameraMatrix():void
        {
            var _local_1:Number = (this.viewSizeX / this.focalLength);
            var _local_2:Number = (this.viewSizeY / this.focalLength);
            var _local_3:Number = Math.cos(rotationX);
            var _local_4:Number = Math.sin(rotationX);
            var _local_5:Number = Math.cos(rotationY);
            var _local_6:Number = Math.sin(rotationY);
            var _local_7:Number = Math.cos(rotationZ);
            var _local_8:Number = Math.sin(rotationZ);
            var _local_9:Number = (_local_7 * _local_6);
            var _local_10:Number = (_local_8 * _local_6);
            var _local_11:Number = (_local_5 * scaleX);
            var _local_12:Number = (_local_4 * scaleY);
            var _local_13:Number = (_local_3 * scaleY);
            var _local_14:Number = (_local_3 * scaleZ);
            var _local_15:Number = (_local_4 * scaleZ);
            ma = ((_local_7 * _local_11) * _local_1);
            mb = (((_local_9 * _local_12) - (_local_8 * _local_13)) * _local_2);
            mc = ((_local_9 * _local_14) + (_local_8 * _local_15));
            md = x;
            me = ((_local_8 * _local_11) * _local_1);
            mf = (((_local_10 * _local_12) + (_local_7 * _local_13)) * _local_2);
            mg = ((_local_10 * _local_14) - (_local_7 * _local_15));
            mh = y;
            mi = ((-(_local_6) * scaleX) * _local_1);
            mj = ((_local_5 * _local_12) * _local_2);
            mk = (_local_5 * _local_14);
            ml = z;
            var _local_16:Number = (this.view.offsetX / this.viewSizeX);
            var _local_17:Number = (this.view.offsetY / this.viewSizeY);
            mc = (mc - ((ma * _local_16) + (mb * _local_17)));
            mg = (mg - ((me * _local_16) + (mf * _local_17)));
            mk = (mk - ((mi * _local_16) + (mj * _local_17)));
        }

        public function addToDebug(_arg_1:int, _arg_2:*):void
        {
            if ((!(this.debugSet[_arg_1])))
            {
                this.debugSet[_arg_1] = new Dictionary();
            };
            this.debugSet[_arg_1][_arg_2] = true;
        }

        public function removeFromDebug(_arg_1:int, _arg_2:*):void
        {
            var _local_3:*;
            if (this.debugSet[_arg_1])
            {
                delete this.debugSet[_arg_1][_arg_2];
                for (_local_3 in this.debugSet[_arg_1])
                {
                    break;
                };
                if ((!(_local_3)))
                {
                    delete this.debugSet[_arg_1];
                };
            };
        }

        alternativa3d function checkInDebug(_arg_1:Object3D):int
        {
            var _local_4:Class;
            var _local_2:int;
            var _local_3:int = 1;
            while (_local_3 <= 0x0200)
            {
                if (this.debugSet[_local_3])
                {
                    if (((this.debugSet[_local_3][Object3D]) || (this.debugSet[_local_3][_arg_1])))
                    {
                        _local_2 = (_local_2 | _local_3);
                    } else
                    {
                        _local_4 = (getDefinitionByName(getQualifiedClassName(_arg_1)) as Class);
                        while (_local_4 != Object3D)
                        {
                            if (this.debugSet[_local_3][_local_4])
                            {
                                _local_2 = (_local_2 | _local_3);
                                break;
                            };
                            _local_4 = Class(getDefinitionByName(getQualifiedSuperclassName(_local_4)));
                        };
                    };
                };
                _local_3 = (_local_3 << 1);
            };
            return (_local_2);
        }

        public function startTimer():void
        {
            this.timer = getTimer();
        }

        public function stopTimer():void
        {
            this.timeSum = (this.timeSum + (getTimer() - this.timer));
            this.timeCount++;
        }

        public function get diagram():DisplayObject
        {
            return (this._diagram);
        }

        public function get diagramAlign():String
        {
            return (this._diagramAlign);
        }

        public function set diagramAlign(_arg_1:String):void
        {
            this._diagramAlign = _arg_1;
            this.resizeDiagram();
        }

        public function get diagramHorizontalMargin():Number
        {
            return (this._diagramHorizontalMargin);
        }

        public function set diagramHorizontalMargin(_arg_1:Number):void
        {
            this._diagramHorizontalMargin = _arg_1;
            this.resizeDiagram();
        }

        public function get diagramVerticalMargin():Number
        {
            return (this._diagramVerticalMargin);
        }

        public function set diagramVerticalMargin(_arg_1:Number):void
        {
            this._diagramVerticalMargin = _arg_1;
            this.resizeDiagram();
        }

        private function createDiagram():Sprite
        {
            var diagram:Sprite;
            diagram = new Sprite();
            diagram.mouseEnabled = false;
            diagram.mouseChildren = false;
            diagram.addEventListener(Event.ADDED_TO_STAGE, function ():void
            {
                while (internal::diagram.numChildren > 0)
                {
                    internal::diagram.removeChildAt(0);
                };
                fpsTextField = new TextField();
                fpsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCCCCCC);
                fpsTextField.autoSize = TextFieldAutoSize.LEFT;
                fpsTextField.text = "FPS:";
                fpsTextField.selectable = false;
                fpsTextField.x = -3;
                fpsTextField.y = -5;
                internal::diagram.addChild(fpsTextField);
                fpsTextField = new TextField();
                fpsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCCCCCC);
                fpsTextField.autoSize = TextFieldAutoSize.RIGHT;
                fpsTextField.text = Number(internal::diagram.stage.frameRate).toFixed(2);
                fpsTextField.selectable = false;
                fpsTextField.x = -3;
                fpsTextField.y = -5;
                fpsTextField.width = 65;
                internal::diagram.addChild(fpsTextField);
                timerTextField = new TextField();
                timerTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 26367);
                timerTextField.autoSize = TextFieldAutoSize.LEFT;
                timerTextField.text = "MS:";
                timerTextField.selectable = false;
                timerTextField.x = -3;
                timerTextField.y = 4;
                internal::diagram.addChild(timerTextField);
                timerTextField = new TextField();
                timerTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 26367);
                timerTextField.autoSize = TextFieldAutoSize.RIGHT;
                timerTextField.text = "";
                timerTextField.selectable = false;
                timerTextField.x = -3;
                timerTextField.y = 4;
                timerTextField.width = 65;
                internal::diagram.addChild(timerTextField);
                memoryTextField = new TextField();
                memoryTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCCCC00);
                memoryTextField.autoSize = TextFieldAutoSize.LEFT;
                memoryTextField.text = "MEM:";
                memoryTextField.selectable = false;
                memoryTextField.x = -3;
                memoryTextField.y = 13;
                internal::diagram.addChild(memoryTextField);
                memoryTextField = new TextField();
                memoryTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCCCC00);
                memoryTextField.autoSize = TextFieldAutoSize.RIGHT;
                memoryTextField.text = bytesToString(System.totalMemory);
                memoryTextField.selectable = false;
                memoryTextField.x = -3;
                memoryTextField.y = 13;
                memoryTextField.width = 65;
                internal::diagram.addChild(memoryTextField);
                drawsTextField = new TextField();
                drawsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCC00);
                drawsTextField.autoSize = TextFieldAutoSize.LEFT;
                drawsTextField.text = "DRW:";
                drawsTextField.selectable = false;
                drawsTextField.x = -3;
                drawsTextField.y = 22;
                internal::diagram.addChild(drawsTextField);
                drawsTextField = new TextField();
                drawsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCC00);
                drawsTextField.autoSize = TextFieldAutoSize.RIGHT;
                drawsTextField.text = "0";
                drawsTextField.selectable = false;
                drawsTextField.x = -3;
                drawsTextField.y = 22;
                drawsTextField.width = 52;
                internal::diagram.addChild(drawsTextField);
                shadowsTextField = new TextField();
                shadowsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF0033);
                shadowsTextField.autoSize = TextFieldAutoSize.LEFT;
                shadowsTextField.text = "SHD:";
                shadowsTextField.selectable = false;
                shadowsTextField.x = -3;
                shadowsTextField.y = 31;
                internal::diagram.addChild(shadowsTextField);
                shadowsTextField = new TextField();
                shadowsTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF0033);
                shadowsTextField.autoSize = TextFieldAutoSize.RIGHT;
                shadowsTextField.text = "0";
                shadowsTextField.selectable = false;
                shadowsTextField.x = -3;
                shadowsTextField.y = 31;
                shadowsTextField.width = 52;
                internal::diagram.addChild(shadowsTextField);
                trianglesTextField = new TextField();
                trianglesTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF6600);
                trianglesTextField.autoSize = TextFieldAutoSize.LEFT;
                trianglesTextField.text = "TRI:";
                trianglesTextField.selectable = false;
                trianglesTextField.x = -3;
                trianglesTextField.y = 40;
                internal::diagram.addChild(trianglesTextField);
                trianglesTextField = new TextField();
                trianglesTextField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF6600);
                trianglesTextField.autoSize = TextFieldAutoSize.RIGHT;
                trianglesTextField.text = "0";
                trianglesTextField.selectable = false;
                trianglesTextField.x = -3;
                trianglesTextField.y = 40;
                trianglesTextField.width = 52;
                internal::diagram.addChild(trianglesTextField);
                graph = new Bitmap(new BitmapData(60, 40, true, 553648127));
                rect = new Rectangle(0, 0, 1, 40);
                graph.x = 0;
                graph.y = 54;
                internal::diagram.addChild(graph);
                previousPeriodTime = getTimer();
                previousFrameTime = previousPeriodTime;
                fpsUpdateCounter = 0;
                maxMemory = 0;
                timerUpdateCounter = 0;
                timeSum = 0;
                timeCount = 0;
                internal::diagram.stage.addEventListener(Event.ENTER_FRAME, updateDiagram, false, -1000);
                internal::diagram.stage.addEventListener(Event.RESIZE, resizeDiagram, false, -1000);
                resizeDiagram();
            });
            diagram.addEventListener(Event.REMOVED_FROM_STAGE, function ():void
            {
                while (internal::diagram.numChildren > 0)
                {
                    internal::diagram.removeChildAt(0);
                };
                fpsTextField = null;
                memoryTextField = null;
                drawsTextField = null;
                shadowsTextField = null;
                trianglesTextField = null;
                timerTextField = null;
                graph.bitmapData.dispose();
                graph = null;
                rect = null;
                internal::diagram.stage.removeEventListener(Event.ENTER_FRAME, updateDiagram);
                internal::diagram.stage.removeEventListener(Event.RESIZE, resizeDiagram);
            });
            return (diagram);
        }

        private function resizeDiagram(_arg_1:Event=null):void
        {
            var _local_2:Point;
            if (this._diagram.stage != null)
            {
                _local_2 = this._diagram.parent.globalToLocal(new Point());
                if ((((this._diagramAlign == StageAlign.TOP_LEFT) || (this._diagramAlign == StageAlign.LEFT)) || (this._diagramAlign == StageAlign.BOTTOM_LEFT)))
                {
                    this._diagram.x = Math.round((_local_2.x + this._diagramHorizontalMargin));
                };
                if (((this._diagramAlign == StageAlign.TOP) || (this._diagramAlign == StageAlign.BOTTOM)))
                {
                    this._diagram.x = Math.round(((_local_2.x + (this._diagram.stage.stageWidth / 2)) - (this.graph.width / 2)));
                };
                if ((((this._diagramAlign == StageAlign.TOP_RIGHT) || (this._diagramAlign == StageAlign.RIGHT)) || (this._diagramAlign == StageAlign.BOTTOM_RIGHT)))
                {
                    this._diagram.x = Math.round((((_local_2.x + this._diagram.stage.stageWidth) - this._diagramHorizontalMargin) - this.graph.width));
                };
                if ((((this._diagramAlign == StageAlign.TOP_LEFT) || (this._diagramAlign == StageAlign.TOP)) || (this._diagramAlign == StageAlign.TOP_RIGHT)))
                {
                    this._diagram.y = Math.round((_local_2.y + this._diagramVerticalMargin));
                };
                if (((this._diagramAlign == StageAlign.LEFT) || (this._diagramAlign == StageAlign.RIGHT)))
                {
                    this._diagram.y = Math.round(((_local_2.y + (this._diagram.stage.stageHeight / 2)) - ((this.graph.y + this.graph.height) / 2)));
                };
                if ((((this._diagramAlign == StageAlign.BOTTOM_LEFT) || (this._diagramAlign == StageAlign.BOTTOM)) || (this._diagramAlign == StageAlign.BOTTOM_RIGHT)))
                {
                    this._diagram.y = Math.round(((((_local_2.y + this._diagram.stage.stageHeight) - this._diagramVerticalMargin) - this.graph.y) - this.graph.height));
                };
            };
        }

        private function updateDiagram(_arg_1:Event):void
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:String;
            var _local_5:int = getTimer();
            var _local_6:int = this._diagram.stage.frameRate;
            if (++this.fpsUpdateCounter == this.fpsUpdatePeriod)
            {
                _local_2 = ((1000 * this.fpsUpdatePeriod) / (_local_5 - this.previousPeriodTime));
                if (_local_2 > _local_6)
                {
                    _local_2 = _local_6;
                };
                _local_3 = ((_local_2 * 100) % 100);
                _local_4 = ((_local_3 >= 10) ? String(_local_3) : ((_local_3 > 0) ? ("0" + String(_local_3)) : "00"));
                this.fpsTextField.text = ((int(_local_2) + ".") + _local_4);
                this.previousPeriodTime = _local_5;
                this.fpsUpdateCounter = 0;
            };
            _local_2 = (1000 / (_local_5 - this.previousFrameTime));
            if (_local_2 > _local_6)
            {
                _local_2 = _local_6;
            };
            this.graph.bitmapData.scroll(1, 0);
            this.graph.bitmapData.fillRect(this.rect, 553648127);
            this.graph.bitmapData.setPixel32(0, (40 * (1 - (_local_2 / _local_6))), 4291611852);
            this.previousFrameTime = _local_5;
            if (++this.timerUpdateCounter == this.timerUpdatePeriod)
            {
                if (this.timeCount > 0)
                {
                    _local_2 = (this.timeSum / this.timeCount);
                    _local_3 = ((_local_2 * 100) % 100);
                    _local_4 = ((_local_3 >= 10) ? String(_local_3) : ((_local_3 > 0) ? ("0" + String(_local_3)) : "00"));
                    this.timerTextField.text = ((int(_local_2) + ".") + _local_4);
                } else
                {
                    this.timerTextField.text = "";
                };
                this.timerUpdateCounter = 0;
                this.timeSum = 0;
                this.timeCount = 0;
            };
            var _local_7:int = System.totalMemory;
            _local_2 = (_local_7 / 0x100000);
            _local_3 = ((_local_2 * 100) % 100);
            _local_4 = ((_local_3 >= 10) ? String(_local_3) : ((_local_3 > 0) ? ("0" + String(_local_3)) : "00"));
            this.memoryTextField.text = ((int(_local_2) + ".") + _local_4);
            if (_local_7 > this.maxMemory)
            {
                this.maxMemory = _local_7;
            };
            this.graph.bitmapData.setPixel32(0, (40 * (1 - (_local_7 / this.maxMemory))), 0xFFCCCC00);
            this.drawsTextField.text = String(this.numDraws);
            this.shadowsTextField.text = String(this.numShadows);
            this.trianglesTextField.text = String(this.numTriangles);
        }

        private function bytesToString(_arg_1:int):String
        {
            if (_arg_1 < 0x0400)
            {
                return (_arg_1 + "b");
            };
            if (_arg_1 < 0x2800)
            {
                return ((_arg_1 / 0x0400).toFixed(2) + "kb");
            };
            if (_arg_1 < 102400)
            {
                return ((_arg_1 / 0x0400).toFixed(1) + "kb");
            };
            if (_arg_1 < 0x100000)
            {
                return ((_arg_1 >> 10) + "kb");
            };
            if (_arg_1 < 0xA00000)
            {
                return ((_arg_1 / 0x100000).toFixed(2));
            };
            if (_arg_1 < 104857600)
            {
                return ((_arg_1 / 0x100000).toFixed(1));
            };
            return (String((_arg_1 >> 20)));
        }

        alternativa3d function deferredDestroy():void
        {
            var _local_2:Wrapper;
            var _local_3:Wrapper;
            var _local_1:Face = this.firstFace.next;
            while (_local_1 != null)
            {
                _local_2 = _local_1.wrapper;
                if (_local_2 != null)
                {
                    _local_3 = null;
                    while (_local_2 != null)
                    {
                        _local_2.vertex = null;
                        _local_3 = _local_2;
                        _local_2 = _local_2.next;
                    };
                    this.lastWrapper.next = _local_1.wrapper;
                    this.lastWrapper = _local_3;
                };
                _local_1.material = null;
                _local_1.wrapper = null;
                _local_1 = _local_1.next;
            };
            if (this.firstFace != this.lastFace)
            {
                this.lastFace.next = Face.collector;
                Face.collector = this.firstFace.next;
                this.firstFace.next = null;
                this.lastFace = this.firstFace;
            };
            if (this.firstWrapper != this.lastWrapper)
            {
                this.lastWrapper.next = Wrapper.collector;
                Wrapper.collector = this.firstWrapper.next;
                this.firstWrapper.next = null;
                this.lastWrapper = this.firstWrapper;
            };
            if (this.firstVertex != this.lastVertex)
            {
                this.lastVertex.next = Vertex.collector;
                Vertex.collector = this.firstVertex.next;
                this.firstVertex.next = null;
                this.lastVertex = this.firstVertex;
            };
        }

        alternativa3d function clearOccluders():void
        {
            var _local_2:Vertex;
            var _local_3:Vertex;
            var _local_1:int;
            while (_local_1 < this.numOccluders)
            {
                _local_2 = this.occluders[_local_1];
                _local_3 = _local_2;
                while (_local_3.next != null)
                {
                    _local_3 = _local_3.next;
                };
                _local_3.next = Vertex.collector;
                Vertex.collector = _local_2;
                this.occluders[_local_1] = null;
                _local_1++;
            };
            this.numOccluders = 0;
        }

        alternativa3d function sortByAverageZ(_arg_1:Face):Face
        {
            var _local_2:int;
            var _local_3:Number;
            var _local_4:Wrapper;
            var _local_5:Face = _arg_1;
            var _local_6:Face = _arg_1.processNext;
            while (((!(_local_6 == null)) && (!(_local_6.processNext == null))))
            {
                _arg_1 = _arg_1.processNext;
                _local_6 = _local_6.processNext.processNext;
            };
            _local_6 = _arg_1.processNext;
            _arg_1.processNext = null;
            if (_local_5.processNext != null)
            {
                _local_5 = this.sortByAverageZ(_local_5);
            } else
            {
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = _local_5.wrapper;
                while (_local_4 != null)
                {
                    _local_2++;
                    _local_3 = (_local_3 + _local_4.vertex.cameraZ);
                    _local_4 = _local_4.next;
                };
                _local_5.distance = (_local_3 / _local_2);
            };
            if (_local_6.processNext != null)
            {
                _local_6 = this.sortByAverageZ(_local_6);
            } else
            {
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = _local_6.wrapper;
                while (_local_4 != null)
                {
                    _local_2++;
                    _local_3 = (_local_3 + _local_4.vertex.cameraZ);
                    _local_4 = _local_4.next;
                };
                _local_6.distance = (_local_3 / _local_2);
            };
            var _local_7:Boolean = (_local_5.distance > _local_6.distance);
            if (_local_7)
            {
                _arg_1 = _local_5;
                _local_5 = _local_5.processNext;
            } else
            {
                _arg_1 = _local_6;
                _local_6 = _local_6.processNext;
            };
            var _local_8:Face = _arg_1;
            while (true)
            {
                if (_local_5 == null)
                {
                    _local_8.processNext = _local_6;
                    return (_arg_1);
                };
                if (_local_6 == null)
                {
                    _local_8.processNext = _local_5;
                    return (_arg_1);
                };
                if (_local_7)
                {
                    if (_local_5.distance > _local_6.distance)
                    {
                        _local_8 = _local_5;
                        _local_5 = _local_5.processNext;
                    } else
                    {
                        _local_8.processNext = _local_6;
                        _local_8 = _local_6;
                        _local_6 = _local_6.processNext;
                        _local_7 = false;
                    };
                } else
                {
                    if (_local_6.distance > _local_5.distance)
                    {
                        _local_8 = _local_6;
                        _local_6 = _local_6.processNext;
                    } else
                    {
                        _local_8.processNext = _local_5;
                        _local_8 = _local_5;
                        _local_5 = _local_5.processNext;
                        _local_7 = true;
                    };
                };
            };
            return (null);
        }

        alternativa3d function sortByDynamicBSP(_arg_1:Face, _arg_2:Number, _arg_3:Face=null):Face
        {
            var _local_4:Wrapper;
            var _local_5:Vertex;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_23:Face;
            var _local_24:Face;
            var _local_26:Face;
            var _local_27:Face;
            var _local_28:Face;
            var _local_30:Number;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Number;
            var _local_34:Number;
            var _local_35:Number;
            var _local_36:Number;
            var _local_37:Number;
            var _local_38:Number;
            var _local_39:Number;
            var _local_40:Boolean;
            var _local_41:Boolean;
            var _local_42:Number;
            var _local_43:Face;
            var _local_44:Face;
            var _local_45:Wrapper;
            var _local_46:Wrapper;
            var _local_47:Wrapper;
            var _local_48:Boolean;
            var _local_49:Number;
            var _local_9:Face = _arg_1;
            _arg_1 = _local_9.processNext;
            _local_4 = _local_9.wrapper;
            _local_5 = _local_4.vertex;
            _local_4 = _local_4.next;
            _local_6 = _local_4.vertex;
            var _local_10:Number = _local_5.cameraX;
            var _local_11:Number = _local_5.cameraY;
            var _local_12:Number = _local_5.cameraZ;
            var _local_13:Number = (_local_6.cameraX - _local_10);
            var _local_14:Number = (_local_6.cameraY - _local_11);
            var _local_15:Number = (_local_6.cameraZ - _local_12);
            var _local_16:Number = 0;
            var _local_17:Number = 0;
            var _local_18:Number = 1;
            var _local_19:Number = _local_12;
            var _local_20:Number = 0;
            _local_4 = _local_4.next;
            while (_local_4 != null)
            {
                _local_8 = _local_4.vertex;
                _local_30 = (_local_8.cameraX - _local_10);
                _local_31 = (_local_8.cameraY - _local_11);
                _local_32 = (_local_8.cameraZ - _local_12);
                _local_33 = ((_local_32 * _local_14) - (_local_31 * _local_15));
                _local_34 = ((_local_30 * _local_15) - (_local_32 * _local_13));
                _local_35 = ((_local_31 * _local_13) - (_local_30 * _local_14));
                _local_36 = (((_local_33 * _local_33) + (_local_34 * _local_34)) + (_local_35 * _local_35));
                if (_local_36 > _arg_2)
                {
                    _local_36 = (1 / Math.sqrt(_local_36));
                    _local_16 = (_local_33 * _local_36);
                    _local_17 = (_local_34 * _local_36);
                    _local_18 = (_local_35 * _local_36);
                    _local_19 = (((_local_10 * _local_16) + (_local_11 * _local_17)) + (_local_12 * _local_18));
                    break;
                };
                if (_local_36 > _local_20)
                {
                    _local_36 = (1 / Math.sqrt(_local_36));
                    _local_16 = (_local_33 * _local_36);
                    _local_17 = (_local_34 * _local_36);
                    _local_18 = (_local_35 * _local_36);
                    _local_19 = (((_local_10 * _local_16) + (_local_11 * _local_17)) + (_local_12 * _local_18));
                    _local_20 = _local_36;
                };
                _local_4 = _local_4.next;
            };
            var _local_21:Number = (_local_19 - _arg_2);
            var _local_22:Number = (_local_19 + _arg_2);
            var _local_25:Face = _local_9;
            var _local_29:Face = _arg_1;
            while (_local_29 != null)
            {
                _local_28 = _local_29.processNext;
                _local_4 = _local_29.wrapper;
                _local_5 = _local_4.vertex;
                _local_4 = _local_4.next;
                _local_6 = _local_4.vertex;
                _local_4 = _local_4.next;
                _local_7 = _local_4.vertex;
                _local_4 = _local_4.next;
                _local_37 = (((_local_5.cameraX * _local_16) + (_local_5.cameraY * _local_17)) + (_local_5.cameraZ * _local_18));
                _local_38 = (((_local_6.cameraX * _local_16) + (_local_6.cameraY * _local_17)) + (_local_6.cameraZ * _local_18));
                _local_39 = (((_local_7.cameraX * _local_16) + (_local_7.cameraY * _local_17)) + (_local_7.cameraZ * _local_18));
                _local_40 = (((_local_37 < _local_21) || (_local_38 < _local_21)) || (_local_39 < _local_21));
                _local_41 = (((_local_37 > _local_22) || (_local_38 > _local_22)) || (_local_39 > _local_22));
                while (_local_4 != null)
                {
                    _local_8 = _local_4.vertex;
                    _local_42 = (((_local_8.cameraX * _local_16) + (_local_8.cameraY * _local_17)) + (_local_8.cameraZ * _local_18));
                    if (_local_42 < _local_21)
                    {
                        _local_40 = true;
                    } else
                    {
                        if (_local_42 > _local_22)
                        {
                            _local_41 = true;
                        };
                    };
                    _local_8.offset = _local_42;
                    _local_4 = _local_4.next;
                };
                if ((!(_local_40)))
                {
                    if ((!(_local_41)))
                    {
                        _local_25.processNext = _local_29;
                        _local_25 = _local_29;
                    } else
                    {
                        if (_local_26 != null)
                        {
                            _local_27.processNext = _local_29;
                        } else
                        {
                            _local_26 = _local_29;
                        };
                        _local_27 = _local_29;
                    };
                } else
                {
                    if ((!(_local_41)))
                    {
                        if (_local_23 != null)
                        {
                            _local_24.processNext = _local_29;
                        } else
                        {
                            _local_23 = _local_29;
                        };
                        _local_24 = _local_29;
                    } else
                    {
                        _local_5.offset = _local_37;
                        _local_6.offset = _local_38;
                        _local_7.offset = _local_39;
                        _local_43 = _local_29.create();
                        _local_43.material = _local_29.material;
                        this.lastFace.next = _local_43;
                        this.lastFace = _local_43;
                        _local_44 = _local_29.create();
                        _local_44.material = _local_29.material;
                        this.lastFace.next = _local_44;
                        this.lastFace = _local_44;
                        _local_45 = null;
                        _local_46 = null;
                        _local_4 = _local_29.wrapper.next.next;
                        while (_local_4.next != null)
                        {
                            _local_4 = _local_4.next;
                        };
                        _local_5 = _local_4.vertex;
                        _local_37 = _local_5.offset;
                        _local_48 = ((!(_local_29.material == null)) && (_local_29.material.useVerticesNormals));
                        _local_4 = _local_29.wrapper;
                        while (_local_4 != null)
                        {
                            _local_6 = _local_4.vertex;
                            _local_38 = _local_6.offset;
                            if ((((_local_37 < _local_21) && (_local_38 > _local_22)) || ((_local_37 > _local_22) && (_local_38 < _local_21))))
                            {
                                _local_49 = ((_local_19 - _local_37) / (_local_38 - _local_37));
                                _local_8 = _local_6.create();
                                this.lastVertex.next = _local_8;
                                this.lastVertex = _local_8;
                                _local_8.cameraX = (_local_5.cameraX + ((_local_6.cameraX - _local_5.cameraX) * _local_49));
                                _local_8.cameraY = (_local_5.cameraY + ((_local_6.cameraY - _local_5.cameraY) * _local_49));
                                _local_8.cameraZ = (_local_5.cameraZ + ((_local_6.cameraZ - _local_5.cameraZ) * _local_49));
                                _local_8.u = (_local_5.u + ((_local_6.u - _local_5.u) * _local_49));
                                _local_8.v = (_local_5.v + ((_local_6.v - _local_5.v) * _local_49));
                                if (_local_48)
                                {
                                    _local_8.x = (_local_5.x + ((_local_6.x - _local_5.x) * _local_49));
                                    _local_8.y = (_local_5.y + ((_local_6.y - _local_5.y) * _local_49));
                                    _local_8.z = (_local_5.z + ((_local_6.z - _local_5.z) * _local_49));
                                    _local_8.normalX = (_local_5.normalX + ((_local_6.normalX - _local_5.normalX) * _local_49));
                                    _local_8.normalY = (_local_5.normalY + ((_local_6.normalY - _local_5.normalY) * _local_49));
                                    _local_8.normalZ = (_local_5.normalZ + ((_local_6.normalZ - _local_5.normalZ) * _local_49));
                                };
                                _local_47 = _local_4.create();
                                _local_47.vertex = _local_8;
                                if (_local_45 != null)
                                {
                                    _local_45.next = _local_47;
                                } else
                                {
                                    _local_43.wrapper = _local_47;
                                };
                                _local_45 = _local_47;
                                _local_47 = _local_4.create();
                                _local_47.vertex = _local_8;
                                if (_local_46 != null)
                                {
                                    _local_46.next = _local_47;
                                } else
                                {
                                    _local_44.wrapper = _local_47;
                                };
                                _local_46 = _local_47;
                            };
                            if (_local_38 <= _local_22)
                            {
                                _local_47 = _local_4.create();
                                _local_47.vertex = _local_6;
                                if (_local_45 != null)
                                {
                                    _local_45.next = _local_47;
                                } else
                                {
                                    _local_43.wrapper = _local_47;
                                };
                                _local_45 = _local_47;
                            };
                            if (_local_38 >= _local_21)
                            {
                                _local_47 = _local_4.create();
                                _local_47.vertex = _local_6;
                                if (_local_46 != null)
                                {
                                    _local_46.next = _local_47;
                                } else
                                {
                                    _local_44.wrapper = _local_47;
                                };
                                _local_46 = _local_47;
                            };
                            _local_5 = _local_6;
                            _local_37 = _local_38;
                            _local_4 = _local_4.next;
                        };
                        if (_local_23 != null)
                        {
                            _local_24.processNext = _local_43;
                        } else
                        {
                            _local_23 = _local_43;
                        };
                        _local_24 = _local_43;
                        if (_local_26 != null)
                        {
                            _local_27.processNext = _local_44;
                        } else
                        {
                            _local_26 = _local_44;
                        };
                        _local_27 = _local_44;
                        _local_29.processNext = null;
                    };
                };
                _local_29 = _local_28;
            };
            if (_local_26 != null)
            {
                _local_27.processNext = null;
                if (_local_26.processNext != null)
                {
                    _arg_3 = this.sortByDynamicBSP(_local_26, _arg_2, _arg_3);
                } else
                {
                    _local_26.processNext = _arg_3;
                    _arg_3 = _local_26;
                };
            };
            _local_25.processNext = _arg_3;
            _arg_3 = _local_9;
            if (_local_23 != null)
            {
                _local_24.processNext = null;
                if (_local_23.processNext != null)
                {
                    _arg_3 = this.sortByDynamicBSP(_local_23, _arg_2, _arg_3);
                } else
                {
                    _local_23.processNext = _arg_3;
                    _arg_3 = _local_23;
                };
            };
            return (_arg_3);
        }

        alternativa3d function cull(_arg_1:Face, _arg_2:int):Face
        {
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:Face;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Wrapper;
            var _local_10:Vertex;
            var _local_11:Wrapper;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Boolean = ((_arg_2 & 0x01) > 0);
            var _local_22:Boolean = ((_arg_2 & 0x02) > 0);
            var _local_23:Boolean = ((_arg_2 & 0x04) > 0);
            var _local_24:Boolean = ((_arg_2 & 0x08) > 0);
            var _local_25:Boolean = ((_arg_2 & 0x10) > 0);
            var _local_26:Boolean = ((_arg_2 & 0x20) > 0);
            var _local_27:Number = this.nearClipping;
            var _local_28:Number = this.farClipping;
            var _local_29:Boolean = ((_local_23) || (_local_24));
            var _local_30:Boolean = ((_local_25) || (_local_26));
            var _local_31:Face = _arg_1;
            for (;_local_31 != null;(_local_31 = _local_5))
            {
                _local_5 = _local_31.processNext;
                _local_9 = _local_31.wrapper;
                _local_6 = _local_9.vertex;
                _local_9 = _local_9.next;
                _local_7 = _local_9.vertex;
                _local_9 = _local_9.next;
                _local_8 = _local_9.vertex;
                _local_9 = _local_9.next;
                if (_local_29)
                {
                    _local_12 = _local_6.cameraX;
                    _local_15 = _local_7.cameraX;
                    _local_18 = _local_8.cameraX;
                };
                if (_local_30)
                {
                    _local_13 = _local_6.cameraY;
                    _local_16 = _local_7.cameraY;
                    _local_19 = _local_8.cameraY;
                };
                _local_14 = _local_6.cameraZ;
                _local_17 = _local_7.cameraZ;
                _local_20 = _local_8.cameraZ;
                if (_local_21)
                {
                    if ((((_local_14 <= _local_27) || (_local_17 <= _local_27)) || (_local_20 <= _local_27)))
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        if (_local_11.vertex.cameraZ <= _local_27) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 != null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (((((_local_22) && (_local_14 >= _local_28)) && (_local_17 >= _local_28)) && (_local_20 >= _local_28)))
                {
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        if (_local_11.vertex.cameraZ < _local_28) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 == null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (((((_local_23) && (_local_14 <= -(_local_12))) && (_local_17 <= -(_local_15))) && (_local_20 <= -(_local_18))))
                {
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        _local_10 = _local_11.vertex;
                        if (-(_local_10.cameraX) < _local_10.cameraZ) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 == null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (((((_local_24) && (_local_14 <= _local_12)) && (_local_17 <= _local_15)) && (_local_20 <= _local_18)))
                {
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        _local_10 = _local_11.vertex;
                        if (_local_10.cameraX < _local_10.cameraZ) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 == null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (((((_local_25) && (_local_14 <= -(_local_13))) && (_local_17 <= -(_local_16))) && (_local_20 <= -(_local_19))))
                {
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        _local_10 = _local_11.vertex;
                        if (-(_local_10.cameraY) < _local_10.cameraZ) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 == null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (((((_local_26) && (_local_14 <= _local_13)) && (_local_17 <= _local_16)) && (_local_20 <= _local_19)))
                {
                    _local_11 = _local_9;
                    while (_local_11 != null)
                    {
                        _local_10 = _local_11.vertex;
                        if (_local_10.cameraY < _local_10.cameraZ) break;
                        _local_11 = _local_11.next;
                    };
                    if (_local_11 == null)
                    {
                        _local_31.processNext = null;
                        continue;
                    };
                };
                if (_local_3 != null)
                {
                    _local_4.processNext = _local_31;
                } else
                {
                    _local_3 = _local_31;
                };
                _local_4 = _local_31;
            };
            if (_local_4 != null)
            {
                _local_4.processNext = null;
            };
            return (_local_3);
        }

        alternativa3d function clip(_arg_1:Face, _arg_2:int):Face
        {
            var _local_3:Face;
            var _local_4:Face;
            var _local_5:Face;
            var _local_6:Vertex;
            var _local_7:Vertex;
            var _local_8:Vertex;
            var _local_9:Wrapper;
            var _local_10:Vertex;
            var _local_11:Wrapper;
            var _local_12:Wrapper;
            var _local_13:Wrapper;
            var _local_14:Wrapper;
            var _local_15:Wrapper;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:Number;
            var _local_22:Number;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Boolean;
            var _local_26:Boolean;
            var _local_27:Boolean;
            var _local_28:Boolean;
            var _local_29:Boolean;
            var _local_30:Boolean;
            var _local_31:Number;
            var _local_32:Number;
            var _local_33:Boolean;
            var _local_34:Boolean;
            var _local_35:int;
            var _local_36:Number;
            var _local_37:Face;
            var _local_38:Boolean;
            var _local_39:Face;
            _local_25 = ((_arg_2 & 0x01) > 0);
            _local_26 = ((_arg_2 & 0x02) > 0);
            _local_27 = ((_arg_2 & 0x04) > 0);
            _local_28 = ((_arg_2 & 0x08) > 0);
            _local_29 = ((_arg_2 & 0x10) > 0);
            _local_30 = ((_arg_2 & 0x20) > 0);
            _local_31 = this.nearClipping;
            _local_32 = this.farClipping;
            _local_33 = ((_local_27) || (_local_28));
            _local_34 = ((_local_29) || (_local_30));
            _local_37 = _arg_1;
            for (;_local_37 != null;(_local_37 = _local_5))
            {
                _local_5 = _local_37.processNext;
                _local_9 = _local_37.wrapper;
                _local_6 = _local_9.vertex;
                _local_9 = _local_9.next;
                _local_7 = _local_9.vertex;
                _local_9 = _local_9.next;
                _local_8 = _local_9.vertex;
                _local_9 = _local_9.next;
                if (_local_33)
                {
                    _local_16 = _local_6.cameraX;
                    _local_19 = _local_7.cameraX;
                    _local_22 = _local_8.cameraX;
                };
                if (_local_34)
                {
                    _local_17 = _local_6.cameraY;
                    _local_20 = _local_7.cameraY;
                    _local_23 = _local_8.cameraY;
                };
                _local_18 = _local_6.cameraZ;
                _local_21 = _local_7.cameraZ;
                _local_24 = _local_8.cameraZ;
                _local_35 = 0;
                if (_local_25)
                {
                    if ((((_local_18 <= _local_31) && (_local_21 <= _local_31)) && (_local_24 <= _local_31)))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            if (_local_11.vertex.cameraZ > _local_31)
                            {
                                _local_35 = (_local_35 | 0x01);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 > _local_31) && (_local_21 > _local_31)) && (_local_24 > _local_31)))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                if (_local_11.vertex.cameraZ <= _local_31)
                                {
                                    _local_35 = (_local_35 | 0x01);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x01);
                        };
                    };
                };
                if (_local_26)
                {
                    if ((((_local_18 >= _local_32) && (_local_21 >= _local_32)) && (_local_24 >= _local_32)))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            if (_local_11.vertex.cameraZ < _local_32)
                            {
                                _local_35 = (_local_35 | 0x02);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 < _local_32) && (_local_21 < _local_32)) && (_local_24 < _local_32)))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                if (_local_11.vertex.cameraZ >= _local_32)
                                {
                                    _local_35 = (_local_35 | 0x02);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x02);
                        };
                    };
                };
                if (_local_27)
                {
                    if ((((_local_18 <= -(_local_16)) && (_local_21 <= -(_local_19))) && (_local_24 <= -(_local_22))))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            _local_10 = _local_11.vertex;
                            if (-(_local_10.cameraX) < _local_10.cameraZ)
                            {
                                _local_35 = (_local_35 | 0x04);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 > -(_local_16)) && (_local_21 > -(_local_19))) && (_local_24 > -(_local_22))))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                _local_10 = _local_11.vertex;
                                if (-(_local_10.cameraX) >= _local_10.cameraZ)
                                {
                                    _local_35 = (_local_35 | 0x04);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x04);
                        };
                    };
                };
                if (_local_28)
                {
                    if ((((_local_18 <= _local_16) && (_local_21 <= _local_19)) && (_local_24 <= _local_22)))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            _local_10 = _local_11.vertex;
                            if (_local_10.cameraX < _local_10.cameraZ)
                            {
                                _local_35 = (_local_35 | 0x08);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 > _local_16) && (_local_21 > _local_19)) && (_local_24 > _local_22)))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                _local_10 = _local_11.vertex;
                                if (_local_10.cameraX >= _local_10.cameraZ)
                                {
                                    _local_35 = (_local_35 | 0x08);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x08);
                        };
                    };
                };
                if (_local_29)
                {
                    if ((((_local_18 <= -(_local_17)) && (_local_21 <= -(_local_20))) && (_local_24 <= -(_local_23))))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            _local_10 = _local_11.vertex;
                            if (-(_local_10.cameraY) < _local_10.cameraZ)
                            {
                                _local_35 = (_local_35 | 0x10);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 > -(_local_17)) && (_local_21 > -(_local_20))) && (_local_24 > -(_local_23))))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                _local_10 = _local_11.vertex;
                                if (-(_local_10.cameraY) >= _local_10.cameraZ)
                                {
                                    _local_35 = (_local_35 | 0x10);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x10);
                        };
                    };
                };
                if (_local_30)
                {
                    if ((((_local_18 <= _local_17) && (_local_21 <= _local_20)) && (_local_24 <= _local_23)))
                    {
                        _local_11 = _local_9;
                        while (_local_11 != null)
                        {
                            _local_10 = _local_11.vertex;
                            if (_local_10.cameraY < _local_10.cameraZ)
                            {
                                _local_35 = (_local_35 | 0x20);
                                break;
                            };
                            _local_11 = _local_11.next;
                        };
                        if (_local_11 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    } else
                    {
                        if ((((_local_18 > _local_17) && (_local_21 > _local_20)) && (_local_24 > _local_23)))
                        {
                            _local_11 = _local_9;
                            while (_local_11 != null)
                            {
                                _local_10 = _local_11.vertex;
                                if (_local_10.cameraY >= _local_10.cameraZ)
                                {
                                    _local_35 = (_local_35 | 0x20);
                                    break;
                                };
                                _local_11 = _local_11.next;
                            };
                        } else
                        {
                            _local_35 = (_local_35 | 0x20);
                        };
                    };
                };
                if (_local_35 > 0)
                {
                    _local_38 = ((!(_local_37.material == null)) && (_local_37.material.useVerticesNormals));
                    _local_12 = null;
                    _local_13 = null;
                    _local_11 = _local_37.wrapper;
                    while (_local_11 != null)
                    {
                        _local_15 = _local_11.create();
                        _local_15.vertex = _local_11.vertex;
                        if (_local_12 != null)
                        {
                            _local_13.next = _local_15;
                        } else
                        {
                            _local_12 = _local_15;
                        };
                        _local_13 = _local_15;
                        _local_11 = _local_11.next;
                    };
                    if ((_local_35 & 0x01))
                    {
                        _local_6 = _local_13.vertex;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 > _local_31) && (_local_18 <= _local_31)) || ((_local_21 <= _local_31) && (_local_18 > _local_31))))
                            {
                                _local_36 = ((_local_31 - _local_18) / (_local_21 - _local_18));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_6.cameraX + ((_local_7.cameraX - _local_6.cameraX) * _local_36));
                                _local_10.cameraY = (_local_6.cameraY + ((_local_7.cameraY - _local_6.cameraY) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 > _local_31)
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    if ((_local_35 & 0x02))
                    {
                        _local_6 = _local_13.vertex;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 < _local_32) && (_local_18 >= _local_32)) || ((_local_21 >= _local_32) && (_local_18 < _local_32))))
                            {
                                _local_36 = ((_local_32 - _local_18) / (_local_21 - _local_18));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_6.cameraX + ((_local_7.cameraX - _local_6.cameraX) * _local_36));
                                _local_10.cameraY = (_local_6.cameraY + ((_local_7.cameraY - _local_6.cameraY) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 < _local_32)
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    if ((_local_35 & 0x04))
                    {
                        _local_6 = _local_13.vertex;
                        _local_16 = _local_6.cameraX;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_19 = _local_7.cameraX;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 > -(_local_19)) && (_local_18 <= -(_local_16))) || ((_local_21 <= -(_local_19)) && (_local_18 > -(_local_16)))))
                            {
                                _local_36 = ((_local_16 + _local_18) / (((_local_16 + _local_18) - _local_19) - _local_21));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_16 + ((_local_19 - _local_16) * _local_36));
                                _local_10.cameraY = (_local_6.cameraY + ((_local_7.cameraY - _local_6.cameraY) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 > -(_local_19))
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_16 = _local_19;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    if ((_local_35 & 0x08))
                    {
                        _local_6 = _local_13.vertex;
                        _local_16 = _local_6.cameraX;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_19 = _local_7.cameraX;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 > _local_19) && (_local_18 <= _local_16)) || ((_local_21 <= _local_19) && (_local_18 > _local_16))))
                            {
                                _local_36 = ((_local_18 - _local_16) / (((_local_18 - _local_16) + _local_19) - _local_21));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_16 + ((_local_19 - _local_16) * _local_36));
                                _local_10.cameraY = (_local_6.cameraY + ((_local_7.cameraY - _local_6.cameraY) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 > _local_19)
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_16 = _local_19;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    if ((_local_35 & 0x10))
                    {
                        _local_6 = _local_13.vertex;
                        _local_17 = _local_6.cameraY;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_20 = _local_7.cameraY;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 > -(_local_20)) && (_local_18 <= -(_local_17))) || ((_local_21 <= -(_local_20)) && (_local_18 > -(_local_17)))))
                            {
                                _local_36 = ((_local_17 + _local_18) / (((_local_17 + _local_18) - _local_20) - _local_21));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_6.cameraX + ((_local_7.cameraX - _local_6.cameraX) * _local_36));
                                _local_10.cameraY = (_local_17 + ((_local_20 - _local_17) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 > -(_local_20))
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_17 = _local_20;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    if ((_local_35 & 0x20))
                    {
                        _local_6 = _local_13.vertex;
                        _local_17 = _local_6.cameraY;
                        _local_18 = _local_6.cameraZ;
                        _local_11 = _local_12;
                        _local_12 = null;
                        _local_13 = null;
                        while (_local_11 != null)
                        {
                            _local_14 = _local_11.next;
                            _local_7 = _local_11.vertex;
                            _local_20 = _local_7.cameraY;
                            _local_21 = _local_7.cameraZ;
                            if ((((_local_21 > _local_20) && (_local_18 <= _local_17)) || ((_local_21 <= _local_20) && (_local_18 > _local_17))))
                            {
                                _local_36 = ((_local_18 - _local_17) / (((_local_18 - _local_17) + _local_20) - _local_21));
                                _local_10 = _local_7.create();
                                this.lastVertex.next = _local_10;
                                this.lastVertex = _local_10;
                                _local_10.cameraX = (_local_6.cameraX + ((_local_7.cameraX - _local_6.cameraX) * _local_36));
                                _local_10.cameraY = (_local_17 + ((_local_20 - _local_17) * _local_36));
                                _local_10.cameraZ = (_local_18 + ((_local_21 - _local_18) * _local_36));
                                _local_10.x = (_local_6.x + ((_local_7.x - _local_6.x) * _local_36));
                                _local_10.y = (_local_6.y + ((_local_7.y - _local_6.y) * _local_36));
                                _local_10.z = (_local_6.z + ((_local_7.z - _local_6.z) * _local_36));
                                _local_10.u = (_local_6.u + ((_local_7.u - _local_6.u) * _local_36));
                                _local_10.v = (_local_6.v + ((_local_7.v - _local_6.v) * _local_36));
                                if (_local_38)
                                {
                                    _local_10.normalX = (_local_6.normalX + ((_local_7.normalX - _local_6.normalX) * _local_36));
                                    _local_10.normalY = (_local_6.normalY + ((_local_7.normalY - _local_6.normalY) * _local_36));
                                    _local_10.normalZ = (_local_6.normalZ + ((_local_7.normalZ - _local_6.normalZ) * _local_36));
                                };
                                _local_15 = _local_11.create();
                                _local_15.vertex = _local_10;
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_15;
                                } else
                                {
                                    _local_12 = _local_15;
                                };
                                _local_13 = _local_15;
                            };
                            if (_local_21 > _local_20)
                            {
                                if (_local_12 != null)
                                {
                                    _local_13.next = _local_11;
                                } else
                                {
                                    _local_12 = _local_11;
                                };
                                _local_13 = _local_11;
                                _local_11.next = null;
                            } else
                            {
                                _local_11.vertex = null;
                                _local_11.next = Wrapper.collector;
                                Wrapper.collector = _local_11;
                            };
                            _local_6 = _local_7;
                            _local_17 = _local_20;
                            _local_18 = _local_21;
                            _local_11 = _local_14;
                        };
                        if (_local_12 == null)
                        {
                            _local_37.processNext = null;
                            continue;
                        };
                    };
                    _local_37.processNext = null;
                    _local_39 = _local_37.create();
                    _local_39.material = _local_37.material;
                    this.lastFace.next = _local_39;
                    this.lastFace = _local_39;
                    _local_39.wrapper = _local_12;
                    _local_37 = _local_39;
                };
                if (_local_3 != null)
                {
                    _local_4.processNext = _local_37;
                } else
                {
                    _local_3 = _local_37;
                };
                _local_4 = _local_37;
            };
            if (_local_4 != null)
            {
                _local_4.processNext = null;
            };
            return (_local_3);
        }


    }
}//package alternativa.engine3d.core