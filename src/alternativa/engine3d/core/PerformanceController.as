package alternativa.engine3d.core
{
    import flash.net.SharedObject;
    import __AS3__.vec.Vector;
    import flash.display.Stage;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import flash.utils.clearInterval;
    import flash.utils.getTimer;
    import __AS3__.vec.*;

    public class PerformanceController 
    {

        public static const FOG:String = "fog";
        public static const DIRECTIONAL_LIGHT:String = "directionalLight";
        public static const SHADOW_MAP:String = "shadowMap";
        public static const SOFT_TRANSPARENCY:String = "softTransparency";
        public static const SHADOWS:String = "shadows";
        public static const ANTI_ALIAS:String = "antiAlias";
        public static const SSAO:String = "ssao";
        public static const DEFERRED_LIGHTING:String = "deferredLighting";
        private static var storage:SharedObject = SharedObject.getLocal("performance");

        private var types:Vector.<String> = new Vector.<String>();
        private var speeds:Vector.<Number> = new Vector.<Number>();
        private var actives:Vector.<Boolean> = new Vector.<Boolean>();
        private var stage:Stage;
        private var camera:Camera3D;
        private var fpsThreshold:Number;
        private var ratioThreshold:Number;
        private var testTime:Number;
        private var maxAttempts:uint;
        private var key:String;
        private var traceLog:Boolean;
        private var mask:int;
        private var id:uint;
        private var idleId:uint;
        private var timer:int;
        private var frameCounter:int;
        private var lowCounter:int;
        private var state:int;
        private var features:Vector.<Feature>;
        private var featuresCount:int;
        private var index:int;
        private var _block:Boolean = false;
        private var afterIdle:Boolean;


        public function addFeature(_arg_1:String, _arg_2:Number, _arg_3:Boolean):void
        {
            var _local_4:String;
            if (this.camera != null)
            {
                throw (new Error("Cannot add feature during analysis."));
            };
            if (((((((((!(_arg_1 == FOG)) && (!(_arg_1 == SHADOWS))) && (!(_arg_1 == DIRECTIONAL_LIGHT))) && (!(_arg_1 == SHADOW_MAP))) && (!(_arg_1 == SOFT_TRANSPARENCY))) && (!(_arg_1 == ANTI_ALIAS))) && (!(_arg_1 == SSAO))) && (!(_arg_1 == DEFERRED_LIGHTING))))
            {
                throw (new Error("Nonexistent feature."));
            };
            for each (_local_4 in this.types)
            {
                if (_local_4 == _arg_1)
                {
                    throw (new Error("Feature already exists."));
                };
            };
            this.types.push(_arg_1);
            this.speeds.push(_arg_2);
            this.actives.push(_arg_3);
        }

        public function get activated():Boolean
        {
            return (!(this.camera == null));
        }

        public function clearSharedObject():void
        {
            storage.clear();
        }

        public function start(_arg_1:Stage, _arg_2:Camera3D, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:uint, _arg_8:String, _arg_9:Boolean=false):void
        {
            var _local_10:int;
            if (this.camera != null)
            {
                throw (new Error("Analysis already started."));
            };
            var _local_11:int = this.types.length;
            this.stage = _arg_1;
            this.camera = _arg_2;
            this.fpsThreshold = _arg_3;
            this.ratioThreshold = _arg_4;
            this.testTime = _arg_6;
            this.maxAttempts = _arg_7;
            this.key = _arg_8;
            this.traceLog = _arg_9;
            this.mask = 0;
            _local_10 = 0;
            while (_local_10 < _local_11)
            {
                this.key = (this.key + ("_5_" + this.types[_local_10]));
                if (this.actives[_local_10])
                {
                    this.mask = (this.mask | (1 << _local_10));
                };
                _local_10++;
            };
            if (storage.data[this.key] != undefined)
            {
                this.mask = storage.data[this.key];
            } else
            {
                this.save();
            };
            this.features = new Vector.<Feature>();
            this.featuresCount = 0;
            _local_10 = 0;
            while (_local_10 < _local_11)
            {
                if ((this.mask & (1 << _local_10)) > 0)
                {
                    this.features[this.featuresCount] = new Feature(this.types[_local_10], this.speeds[_local_10]);
                    this.featuresCount++;
                };
                _local_10++;
            };
            this.index = (this.featuresCount - 1);
            _local_10 = 0;
            while (_local_10 < _local_11)
            {
                if ((this.mask & (1 << _local_10)) == 0)
                {
                    this.features[this.featuresCount] = new Feature(this.types[_local_10], this.speeds[_local_10]);
                    this.featuresCount++;
                    this.disableFeature(this.types[_local_10]);
                };
                _local_10++;
            };
            this.afterIdle = false;
            if (_arg_5 > 0)
            {
                this.idleId = setTimeout(this.onIdle, (_arg_5 * 1000));
            } else
            {
                this.onIdle();
            };
            this.traceFeatures("\nStart", true);
        }

        public function stop():void
        {
            if (this.camera == null)
            {
                return;
            };
            this.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            clearInterval(this.id);
            clearInterval(this.idleId);
            var _local_1:int = this.types.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.restoreFeature(this.types[_local_2]);
                _local_2++;
            };
            this.stage = null;
            this.camera = null;
        }

        public function get block():Boolean
        {
            return (this._block);
        }

        public function set block(_arg_1:Boolean):void
        {
            if (this._block != _arg_1)
            {
                this._block = _arg_1;
                this.traceFeatures(("\nBlock " + this._block), false);
                if (((!(this.camera == null)) && (this.afterIdle)))
                {
                    if (this._block)
                    {
                        this.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                        clearInterval(this.id);
                        if (this.index < (this.featuresCount - 1))
                        {
                            this.disableFeature(Feature(this.features[(this.index + 1)]).type);
                        };
                    } else
                    {
                        this.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                        this.timer = getTimer();
                        if (this.state == 0)
                        {
                            this.testCurrent();
                        };
                    };
                };
            };
        }

        private function onIdle():void
        {
            this.state = 0;
            this.afterIdle = true;
            if ((!(this._block)))
            {
                this.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                this.timer = getTimer();
                this.testCurrent();
            };
        }

        private function onEnterFrame(_arg_1:Event):void
        {
            var _local_4:Number;
            var _local_2:int = getTimer();
            var _local_3:Number = ((_local_2 - this.timer) / 1000);
            this.timer = _local_2;
            if (this.state == 1)
            {
                _local_4 = this.changeStrength(Feature(this.features[this.index]).type, (_local_3 * this.speeds[this.index]));
                if (_local_4 >= 1)
                {
                    if ((this.index + 1) < this.featuresCount)
                    {
                        this.testNext();
                    } else
                    {
                        this.testCurrent();
                    };
                };
            } else
            {
                if (this.state == -1)
                {
                    _local_4 = this.changeStrength(Feature(this.features[this.index]).type, (-(_local_3) * this.speeds[this.index]));
                    if (_local_4 <= 0)
                    {
                        this.mask = (this.mask & (~(1 << this.types.indexOf(Feature(this.features[this.index]).type))));
                        this.save();
                        this.index--;
                        this.swap();
                        this.traceFeatures(null, true);
                        this.testCurrent();
                    };
                } else
                {
                    this.frameCounter++;
                    if ((1 / _local_3) < this.fpsThreshold)
                    {
                        this.lowCounter++;
                    };
                };
            };
        }

        private function testNext():void
        {
            this.state = 0;
            this.frameCounter = 0;
            this.lowCounter = 0;
            this.testFeature(Feature(this.features[(this.index + 1)]).type);
            this.id = setTimeout(this.onTestNext, (this.testTime * 1000));
            this.traceFeatures(((("\nTest Next " + String((this.index + 1))) + " ") + this.features[(this.index + 1)].type), false);
        }

        private function onTestNext():void
        {
            if ((this.lowCounter / this.frameCounter) < this.ratioThreshold)
            {
                this.index++;
                this.mask = (this.mask | (1 << this.types.indexOf(Feature(this.features[this.index]).type)));
                this.save();
                Feature(this.features[this.index]).attempts = 0;
                this.state = 1;
                this.traceFeatures("SUCCESS", true);
            } else
            {
                this.swap();
                this.traceFeatures("FAIL", true);
                if ((this.index + 1) < this.featuresCount)
                {
                    this.testNext();
                } else
                {
                    this.testCurrent();
                };
            };
        }

        private function testCurrent():void
        {
            this.state = 0;
            this.frameCounter = 0;
            this.lowCounter = 0;
            this.id = setTimeout(this.onTestCurrent, (this.testTime * 1000));
            this.traceFeatures(((("\nTest Current " + this.index) + " ") + ((this.index >= 0) ? this.features[this.index].type : "none")), false);
        }

        private function onTestCurrent():void
        {
            if ((this.lowCounter / this.frameCounter) < this.ratioThreshold)
            {
                this.traceFeatures("SUCCESS", true);
                if ((this.index + 1) < this.featuresCount)
                {
                    this.testNext();
                } else
                {
                    this.testCurrent();
                };
            } else
            {
                if (this.index >= 0)
                {
                    this.traceFeatures("FAIL", false);
                    this.state = -1;
                } else
                {
                    this.traceFeatures("FAIL", true);
                    this.testCurrent();
                };
            };
        }

        private function swap():void
        {
            var _local_1:Feature = Feature(this.features[(this.index + 1)]);
            this.disableFeature(_local_1.type);
            _local_1.attempts++;
            var _local_2:int = (this.index + 1);
            while (_local_2 < (this.featuresCount - 1))
            {
                this.features[_local_2] = this.features[(_local_2 + 1)];
                _local_2++;
            };
            if (_local_1.attempts < this.maxAttempts)
            {
                this.features[(this.featuresCount - 1)] = _local_1;
            } else
            {
                this.featuresCount--;
                this.features.length = this.featuresCount;
            };
        }

        private function save():void
        {
            storage.data[this.key] = this.mask;
        }

        private function traceFeatures(_arg_1:String=null, _arg_2:Boolean=false):void
        {
            var _local_3:int;
            var _local_4:String;
            if (this.traceLog)
            {
                if (_arg_1 != null)
                {
                };
                if (_arg_2)
                {
                    _local_3 = 0;
                    while (_local_3 <= this.index)
                    {
                        _local_3++;
                    };
                    _local_3 = (this.index + 1);
                    while (_local_3 < this.featuresCount)
                    {
                        _local_3++;
                    };
                    _local_4 = " ";
                    _local_3 = 0;
                    while (_local_3 < this.types.length)
                    {
                        _local_4 = (_local_4 + (this.types[_local_3] + (((this.mask & (1 << _local_3)) > 0) ? "+ " : "- ")));
                        _local_3++;
                    };
                };
            };
        }

        private function disableFeature(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case FOG:
                    this.camera.fogStrength = 0;
                    return;
                case DIRECTIONAL_LIGHT:
                    this.camera.directionalLightStrength = 0;
                    return;
                case SHADOW_MAP:
                    this.camera.shadowMapStrength = 0;
                    return;
                case SOFT_TRANSPARENCY:
                    this.camera.softTransparencyStrength = 0;
                    return;
                case SHADOWS:
                    this.camera.shadowsStrength = 0;
                    return;
                case ANTI_ALIAS:
                    this.camera.view.antiAliasEnabled = false;
                    return;
                case SSAO:
                    this.camera.ssaoStrength = 0;
                    return;
                case DEFERRED_LIGHTING:
                    this.camera.deferredLightingStrength = 0;
                    return;
            };
        }

        private function restoreFeature(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case FOG:
                    this.camera.fogStrength = 1;
                    return;
                case DIRECTIONAL_LIGHT:
                    this.camera.directionalLightStrength = 1;
                    return;
                case SHADOW_MAP:
                    this.camera.shadowMapStrength = 1;
                    return;
                case SOFT_TRANSPARENCY:
                    this.camera.softTransparencyStrength = 1;
                    return;
                case SHADOWS:
                    this.camera.shadowsStrength = 1;
                    this.camera.shadowsDistanceMultiplier = 1;
                    return;
                case ANTI_ALIAS:
                    this.camera.view.antiAliasEnabled = true;
                    return;
                case SSAO:
                    this.camera.ssaoStrength = 1;
                    return;
                case DEFERRED_LIGHTING:
                    this.camera.deferredLightingStrength = 1;
                    return;
            };
        }

        private function testFeature(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case FOG:
                    this.camera.fogStrength = 0.01;
                    return;
                case DIRECTIONAL_LIGHT:
                    this.camera.directionalLightStrength = 0.01;
                    return;
                case SHADOW_MAP:
                    this.camera.shadowMapStrength = 0.01;
                    return;
                case SOFT_TRANSPARENCY:
                    this.camera.softTransparencyStrength = 0.01;
                    return;
                case SHADOWS:
                    this.camera.shadowsStrength = 0.01;
                    return;
                case ANTI_ALIAS:
                    this.camera.view.antiAliasEnabled = true;
                    return;
                case SSAO:
                    this.camera.ssaoStrength = 0.01;
                    return;
                case DEFERRED_LIGHTING:
                    this.camera.deferredLightingStrength = 0.01;
                    return;
            };
        }

        private function changeStrength(_arg_1:String, _arg_2:Number):Number
        {
            var _local_3:Number = 0;
            switch (_arg_1)
            {
                case FOG:
                    this.camera.fogStrength = (this.camera.fogStrength + _arg_2);
                    if (this.camera.fogStrength > 1)
                    {
                        this.camera.fogStrength = 1;
                    };
                    if (this.camera.fogStrength < 0)
                    {
                        this.camera.fogStrength = 0;
                    };
                    _local_3 = this.camera.fogStrength;
                    break;
                case DIRECTIONAL_LIGHT:
                    this.camera.directionalLightStrength = (this.camera.directionalLightStrength + _arg_2);
                    if (this.camera.directionalLightStrength > 1)
                    {
                        this.camera.directionalLightStrength = 1;
                    };
                    if (this.camera.directionalLightStrength < 0)
                    {
                        this.camera.directionalLightStrength = 0;
                    };
                    _local_3 = this.camera.directionalLightStrength;
                    break;
                case SHADOW_MAP:
                    this.camera.shadowMapStrength = (this.camera.shadowMapStrength + _arg_2);
                    if (this.camera.shadowMapStrength > 1)
                    {
                        this.camera.shadowMapStrength = 1;
                    };
                    if (this.camera.shadowMapStrength < 0)
                    {
                        this.camera.shadowMapStrength = 0;
                    };
                    _local_3 = this.camera.shadowMapStrength;
                    break;
                case SOFT_TRANSPARENCY:
                    this.camera.softTransparencyStrength = (this.camera.softTransparencyStrength + _arg_2);
                    if (this.camera.softTransparencyStrength > 1)
                    {
                        this.camera.softTransparencyStrength = 1;
                    };
                    if (this.camera.softTransparencyStrength < 0)
                    {
                        this.camera.softTransparencyStrength = 0;
                    };
                    _local_3 = this.camera.softTransparencyStrength;
                    break;
                case SHADOWS:
                    this.camera.shadowsStrength = (this.camera.shadowsStrength + _arg_2);
                    if (this.camera.shadowsStrength > 1)
                    {
                        this.camera.shadowsStrength = 1;
                    };
                    if (this.camera.shadowsStrength < 0)
                    {
                        this.camera.shadowsStrength = 0;
                    };
                    _local_3 = this.camera.shadowsStrength;
                    break;
                case ANTI_ALIAS:
                    this.camera.view.antiAliasEnabled = (_arg_2 > 0);
                    _local_3 = ((this.camera.view.antiAliasEnabled) ? 1 : 0);
                    break;
                case SSAO:
                    this.camera.ssaoStrength = (this.camera.ssaoStrength + _arg_2);
                    if (this.camera.ssaoStrength > 1)
                    {
                        this.camera.ssaoStrength = 1;
                    };
                    if (this.camera.ssaoStrength < 0)
                    {
                        this.camera.ssaoStrength = 0;
                    };
                    _local_3 = this.camera.ssaoStrength;
                    break;
                case DEFERRED_LIGHTING:
                    this.camera.deferredLightingStrength = (this.camera.deferredLightingStrength + _arg_2);
                    if (this.camera.deferredLightingStrength > 1)
                    {
                        this.camera.deferredLightingStrength = 1;
                    };
                    if (this.camera.deferredLightingStrength < 0)
                    {
                        this.camera.deferredLightingStrength = 0;
                    };
                    _local_3 = this.camera.deferredLightingStrength;
                    break;
            };
            return (_local_3);
        }


    }
}//package alternativa.engine3d.core

class Feature 
{

    public var type:String;
    public var speed:Number;
    public var attempts:int = 0;

    public function Feature(_arg_1:String, _arg_2:Number)
    {
        this.type = _arg_1;
        this.speed = _arg_2;
    }

}
