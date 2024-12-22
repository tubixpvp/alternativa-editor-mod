package alternativa.engine3d.core{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import alternativa.gfx.core.Device;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.display.Bitmap;
    import flash.ui.ContextMenuItem;
    import alternativa.Alternativa3D;
    import flash.events.ContextMenuEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.ui.ContextMenu;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.display3D.Context3DRenderMode;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;
    import flash.display3D.Context3DClearMask;
    import flash.ui.Mouse;
    import flash.display.DisplayObject;
    import flash.display.StageAlign;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 
    import flash.display3D.Context3D;
    import mx.controls.Alert;
    import flash.geom.Vector3D;
    import alternativa.math.Quaternion;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.math.Matrix3;

    use namespace alternativa3d;

    public class View extends Canvas {

        private static const mouse:Point = new Point();
        private static const coords:Point = new Point();
        private static const branch:Vector.<Object3D> = new Vector.<Object3D>();
        private static const overedBranch:Vector.<Object3D> = new Vector.<Object3D>();
        private static const changedBranch:Vector.<Object3D> = new Vector.<Object3D>();
        private static const functions:Vector.<Function> = new Vector.<Function>();
        private static var staticDevice:Device;
        private static var views:Vector.<View> = new Vector.<View>();
        private static var configured:Boolean = false;
        private static var cleared:Boolean = true;
        
        private static const v1:Vector3D = new Vector3D();
        private static const v2:Vector3D = new Vector3D();
        private static const tmpMatrix3:Matrix3 = new Matrix3();

        private var presented:Boolean = false;
        private var globalCoords:Point;
        alternativa3d var rect:Rectangle = new Rectangle();
        alternativa3d var correction:Boolean = false;
        alternativa3d var device:Device;
        alternativa3d var quality:Boolean;
        alternativa3d var constrained:Boolean;
        alternativa3d var camera:Camera3D;
        alternativa3d var _width:Number;
        alternativa3d var _height:Number;
        alternativa3d var canvas:Sprite = new Sprite();
        private var lastEvent:MouseEvent;
        private var target:Object3D;
        private var pressedTarget:Object3D;
        private var clickedTarget:Object3D;
        private var overedTarget:Object3D;
        private var altKey:Boolean;
        private var ctrlKey:Boolean;
        private var shiftKey:Boolean;
        private var delta:int;
        private var buttonDown:Boolean;
        private var area:Sprite;
        private var logo:Logo;
        private var bitmap:Bitmap;
        private var _logoAlign:String = "BR";
        private var _logoHorizontalMargin:Number = 0;
        private var _logoVerticalMargin:Number = 0;
        public var enableErrorChecking:Boolean = false;
        public var zBufferPrecision:int = 16;
        public var antiAliasEnabled:Boolean = true;
        public var offsetX:Number = 0;
        public var offsetY:Number = 0;

        private var _interactive:Boolean = false;

        public function View(camera:Camera3D, width:Number, height:Number, constrainedMode:Boolean=false){
            super();
            this._width = width;
            this._height = height;
            this.camera = camera;
            camera.view = this;
            this.constrained = constrainedMode;
            mouseEnabled = true;
            mouseChildren = true;
            doubleClickEnabled = true;
            buttonMode = true;
            useHandCursor = false;
            tabEnabled = false;
            tabChildren = false;
            /*var item:ContextMenuItem = new ContextMenuItem(("Powered by Alternativa3D " + Alternativa3D.version));
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (_arg_1:ContextMenuEvent):void{
                try
                {
                    navigateToURL(new URLRequest("http://alternativaplatform.com"), "_blank");
                }
                catch(e:Error)
                {
                };
            });
            var menu:ContextMenu = new ContextMenu();
            menu.customItems = [item];
            contextMenu = menu;*/
            this.area = new Sprite();
            this.area.graphics.beginFill(0xFF0000);
            this.area.graphics.drawRect(0, 0, width, height);
            this.area.mouseEnabled = false;
            this.area.visible = false;
            hitArea = this.area;
            super.addChild(hitArea);
            this.canvas.mouseEnabled = false;
            super.addChild(this.canvas);
            //this.showLogo();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
        }

        public static function getStaticDevice() : Device
        {
            return staticDevice;
        }

        public function getContext3D() : Context3D
        {
            return this.device.getContext3D();
        }

        private function onAddToStage(_arg_1:Event):void{
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStage);
            if (staticDevice == null)
            {
                staticDevice = new Device(stage, Context3DRenderMode.AUTO, ((this.constrained) ? "baselineConstrained" : "baseline"));
            };
            views.push(this);
            this.device = staticDevice;
        }

        public function get interactive() : Boolean
      {
         return this._interactive;
      }
      
      public function set interactive(param1:Boolean) : void
      {
         if(this._interactive == param1)
         {
            return;
         }
         this._interactive = param1;
         if(this._interactive)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            this.pressedTarget = this.overedTarget = this.clickedTarget = null;
         }
      }

        private function onRemoveFromStage(_arg_1:Event):void{
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStage);
            this.interactive = false;
            this.canvas.graphics.clear();
            var _local_2:int = views.indexOf(this);
            while (_local_2 < (views.length - 1))
            {
                views[_local_2] = views[int((_local_2 + 1))];
                _local_2++;
            };
            views.pop();
            if (views.length == 0)
            {
                staticDevice.dispose();
                staticDevice = null;
            };
            this.device = null;
        }

        private function onKeyDown(_arg_1:KeyboardEvent):void{
            this.altKey = _arg_1.altKey;
            this.ctrlKey = _arg_1.ctrlKey;
            this.shiftKey = _arg_1.shiftKey;
            if (((((this.ctrlKey) && (this.shiftKey)) && (_arg_1.keyCode == Keyboard.F1)) && (this.bitmap == null)))
            {
                this.bitmap = new Bitmap(Logo.image);
                this.bitmap.x = Math.round(((this._width - this.bitmap.width) / 2));
                this.bitmap.y = Math.round(((this._height - this.bitmap.height) / 2));
                super.addChild(this.bitmap);
                setTimeout(this.removeBitmap, 0x0800);
            };
        }

        private function removeBitmap():void{
            if (this.bitmap != null)
            {
                super.removeChild(this.bitmap);
                this.bitmap = null;
            };
        }

        private function onKeyUp(_arg_1:KeyboardEvent):void{
            this.altKey = _arg_1.altKey;
            this.ctrlKey = _arg_1.ctrlKey;
            this.shiftKey = _arg_1.shiftKey;
        }

        private function onMouse(_arg_1:MouseEvent):void{
            this.altKey = _arg_1.altKey;
            this.ctrlKey = _arg_1.ctrlKey;
            this.shiftKey = _arg_1.shiftKey;
            this.buttonDown = _arg_1.buttonDown;
            this.delta = _arg_1.delta;
            this.lastEvent = _arg_1;
        }

        private function onMouseDown(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            this.defineTarget(_arg_1);
            if (this.target != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_DOWN, this.target, this.branchToVector(this.target, branch));
            };
            this.pressedTarget = this.target;
            this.target = null;
        }

        private function onMouseUp(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            if (this.pressedTarget != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_UP, this.pressedTarget, this.branchToVector(this.pressedTarget, branch));
                this.pressedTarget = null;
            }
        }

        private function onMouseWheel(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            this.defineTarget(_arg_1);
            if (this.target != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_WHEEL, this.target, this.branchToVector(this.target, branch));
            };
            this.target = null;
        }

        private function onClick(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            this.defineTarget(_arg_1);
            if (this.target != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_UP, this.target, this.branchToVector(this.target, branch));
                if (this.pressedTarget == this.target)
                {
                    this.clickedTarget = this.target;
                    this.propagateEvent(MouseEvent3D.CLICK, this.target, this.branchToVector(this.target, branch));
                };
            };
            this.pressedTarget = null;
            this.target = null;
        }

        private function onDoubleClick(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            this.defineTarget(_arg_1);
            if (this.target != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_UP, this.target, this.branchToVector(this.target, branch));
                if (this.pressedTarget == this.target)
                {
                    this.propagateEvent((((this.clickedTarget == this.target) && (this.target.doubleClickEnabled)) ? MouseEvent3D.DOUBLE_CLICK : MouseEvent3D.CLICK), this.target, this.branchToVector(this.target, branch));
                };
            };
            this.clickedTarget = null;
            this.pressedTarget = null;
            this.target = null;
        }

        private function onMouseMove(_arg_1:MouseEvent):void{
            return; //disable for optimization because it is not used
            this.onMouse(_arg_1);
            this.defineTarget(_arg_1);
            if (this.target != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_MOVE, this.target, this.branchToVector(this.target, branch));
            };
            if (this.overedTarget != this.target)
            {
                this.processOverOut();
            };
            this.target = null;
        }

        private function onMouseOut(_arg_1:MouseEvent):void{
            this.onMouse(_arg_1);
            this.lastEvent = null;
            this.target = null;
            if (this.overedTarget != this.target)
            {
                this.processOverOut();
            };
            this.target = null;
        }

        alternativa3d function configure():void{
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:int;
            var _local_8:View;
            var _local_1:int = ((stage.quality == "LOW") ? 0 : ((stage.quality == "MEDIUM") ? 2 : 4));
            var _local_2:int = (((this.antiAliasEnabled) && (!(this.constrained))) ? _local_1 : 0);
            this.quality = (_local_1 > 0);
            if ((!(configured)))
            {
                _local_3 = 1000000;
                _local_4 = 1000000;
                _local_5 = -1000000;
                _local_6 = -1000000;
                _local_7 = 0;
                while (_local_7 < views.length)
                {
                    _local_8 = views[_local_7];
                    coords.x = 0;
                    coords.y = 0;
                    _local_8.globalCoords = _local_8.localToGlobal(coords);
                    if (_local_8.globalCoords.x < _local_3)
                    {
                        _local_3 = _local_8.globalCoords.x;
                    };
                    if (_local_8.globalCoords.y < _local_4)
                    {
                        _local_4 = _local_8.globalCoords.y;
                    };
                    if ((_local_8.globalCoords.x + _local_8._width) > _local_5)
                    {
                        _local_5 = (_local_8.globalCoords.x + _local_8._width);
                    };
                    if ((_local_8.globalCoords.y + _local_8._height) > _local_6)
                    {
                        _local_6 = (_local_8.globalCoords.y + _local_8._height);
                    };
                    _local_7++;
                };
                this.device.x = _local_3;
                this.device.y = _local_4;
                this.device.width = (_local_5 - _local_3);
                this.device.height = (_local_6 - _local_4);
                this.device.antiAlias = _local_2;
                this.device.enableDepthAndStencil = true;
                this.device.enableErrorChecking = this.enableErrorChecking;
                configured = true;
            };
            if (this.globalCoords == null)
            {
                this.globalCoords = localToGlobal(new Point(0, 0));
            };
            this.rect.x = (int(this.globalCoords.x) - this.device.x);
            this.rect.y = (int(this.globalCoords.y) - this.device.y);
            this.rect.width = int(this._width);
            this.rect.height = int(this._height);
            this.correction = false;
            this.canvas.x = (this._width / 2);
            this.canvas.y = (this._height / 2);
            this.canvas.graphics.clear();
        }

        alternativa3d function clearArea():void{
            if ((!(cleared)))
            {
                this.device.clear((((stage.color >> 16) & 0xFF) / 0xFF), (((stage.color >> 8) & 0xFF) / 0xFF), ((stage.color & 0xFF) / 0xFF));
                cleared = true;
            }
            else
            {
                this.device.clear((((stage.color >> 16) & 0xFF) / 0xFF), (((stage.color >> 8) & 0xFF) / 0xFF), ((stage.color & 0xFF) / 0xFF), 1, 1, 0, (Context3DClearMask.DEPTH | Context3DClearMask.STENCIL));
            };
            if (((((!(this.rect.x == 0)) || (!(this.rect.y == 0))) || (!(this.rect.width == this.device.width))) || (!(this.rect.height == this.device.height))))
            {
                this.device.setScissorRectangle(this.rect);
                this.correction = true;
            };
        }

        alternativa3d function present():void{
            var _local_1:int;
            var _local_2:View;
            this.presented = true;
            this.device.setScissorRectangle(null);
            this.correction = false;
            _local_1 = 0;
            while (_local_1 < views.length)
            {
                _local_2 = views[_local_1];
                if ((!(_local_2.presented))) break;
                _local_1++;
            };
            if (_local_1 == views.length)
            {
                this.device.present();
                configured = false;
                cleared = false;
                _local_1 = 0;
                while (_local_1 < views.length)
                {
                    _local_2 = views[_local_1];
                    _local_2.presented = false;
                    _local_1++;
                };
            };
        }

        alternativa3d function onRender(_arg_1:Camera3D):void{
        }

        private function processOverOut():void{
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Object3D;
            this.branchToVector(this.target, branch);
            this.branchToVector(this.overedTarget, overedBranch);
            var _local_1:int = branch.length;
            var _local_2:int = overedBranch.length;
            if (this.overedTarget != null)
            {
                this.propagateEvent(MouseEvent3D.MOUSE_OUT, this.overedTarget, overedBranch, true, this.target);
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    _local_6 = overedBranch[_local_4];
                    _local_5 = 0;
                    while (_local_5 < _local_1)
                    {
                        if (_local_6 == branch[_local_5]) break;
                        _local_5++;
                    };
                    if (_local_5 == _local_1)
                    {
                        changedBranch[_local_3] = _local_6;
                        _local_3++;
                    };
                    _local_4++;
                };
                if (_local_3 > 0)
                {
                    changedBranch.length = _local_3;
                    this.propagateEvent(MouseEvent3D.ROLL_OUT, this.overedTarget, changedBranch, false, this.target);
                };
            };
            if (this.target != null)
            {
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < _local_1)
                {
                    _local_6 = branch[_local_4];
                    _local_5 = 0;
                    while (_local_5 < _local_2)
                    {
                        if (_local_6 == overedBranch[_local_5]) break;
                        _local_5++;
                    };
                    if (_local_5 == _local_2)
                    {
                        changedBranch[_local_3] = _local_6;
                        _local_3++;
                    };
                    _local_4++;
                };
                if (_local_3 > 0)
                {
                    changedBranch.length = _local_3;
                    this.propagateEvent(MouseEvent3D.ROLL_OVER, this.target, changedBranch, false, this.overedTarget);
                };
                this.propagateEvent(MouseEvent3D.MOUSE_OVER, this.target, branch, true, this.overedTarget);
                useHandCursor = this.target.useHandCursor;
            }
            else
            {
                useHandCursor = false;
            };
            Mouse.cursor = Mouse.cursor;
            this.overedTarget = this.target;
        }

        private function branchToVector(_arg_1:Object3D, _arg_2:Vector.<Object3D>):Vector.<Object3D>{
            var _local_3:int;
            while (_arg_1 != null)
            {
                _arg_2[_local_3] = _arg_1;
                _local_3++;
                _arg_1 = _arg_1._parent;
            };
            _arg_2.length = _local_3;
            return (_arg_2);
        }

        private function propagateEvent(_arg_1:String, _arg_2:Object3D, _arg_3:Vector.<Object3D>, _arg_4:Boolean=true, _arg_5:Object3D=null):void{
            var _local_7:Object3D;
            var _local_8:Vector.<Function>;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:MouseEvent3D;
            var _local_6:int = _arg_3.length;
            _local_10 = (_local_6 - 1);
            while (_local_10 > 0)
            {
                _local_7 = _arg_3[_local_10];
                if (_local_7.captureListeners != null)
                {
                    _local_8 = _local_7.captureListeners[_arg_1];
                    if (_local_8 != null)
                    {
                        if (_local_12 == null)
                        {
                            _local_12 = new MouseEvent3D(_arg_1, _arg_4, _arg_5, this.altKey, this.ctrlKey, this.shiftKey, this.buttonDown, this.delta);
                            _local_12._target = _arg_2;
                            _local_12.calculateLocalRay(mouseX, mouseY, _arg_2, this.camera);
                        };
                        _local_12._currentTarget = _local_7;
                        _local_12._eventPhase = 1;
                        _local_9 = _local_8.length;
                        _local_11 = 0;
                        while (_local_11 < _local_9)
                        {
                            functions[_local_11] = _local_8[_local_11];
                            _local_11++;
                        };
                        _local_11 = 0;
                        while (_local_11 < _local_9)
                        {
                            (functions[_local_11] as Function).call(null, _local_12);
                            if (_local_12.stopImmediate)
                            {
                                return;
                            };
                            _local_11++;
                        };
                        if (_local_12.stop)
                        {
                            return;
                        };
                    };
                };
                _local_10--;
            };
            _local_10 = 0;
            while (_local_10 < _local_6)
            {
                _local_7 = _arg_3[_local_10];
                if (_local_7.bubbleListeners != null)
                {
                    _local_8 = _local_7.bubbleListeners[_arg_1];
                    if (_local_8 != null)
                    {
                        if (_local_12 == null)
                        {
                            _local_12 = new MouseEvent3D(_arg_1, _arg_4, _arg_5, this.altKey, this.ctrlKey, this.shiftKey, this.buttonDown, this.delta);
                            _local_12._target = _arg_2;
                            _local_12.calculateLocalRay(mouseX, mouseY, _arg_2, this.camera);
                        };
                        _local_12._currentTarget = _local_7;
                        _local_12._eventPhase = ((_local_10 == 0) ? 2 : 3);
                        _local_9 = _local_8.length;
                        _local_11 = 0;
                        while (_local_11 < _local_9)
                        {
                            functions[_local_11] = _local_8[_local_11];
                            _local_11++;
                        };
                        _local_11 = 0;
                        while (_local_11 < _local_9)
                        {
                            (functions[_local_11] as Function).call(null, _local_12);
                            if (_local_12.stopImmediate)
                            {
                                return;
                            };
                            _local_11++;
                        };
                        if (_local_12.stop)
                        {
                            return;
                        };
                    };
                };
                _local_10++;
            };
        }

        private function defineTarget(_arg_1:MouseEvent):void
        {
            mouse.x = _arg_1.localX;
            mouse.y = _arg_1.localY;

            this.target = null;

            var root:Object3DContainer = this.camera.parent;

            while(root != null)
            {
                var parent:Object3DContainer = root.parent;
                if(parent == null)
                    break;
                if(!parent.mouseChildren)
                    continue;
                root = parent;
            }
            if(!root.mouseChildren)
                return;

            var origin:Vector3D = v1;
            var direction:Vector3D = v2;

            this.camera.calculateRay(origin, direction, mouse.x, mouse.y);

            var rayHit:RayIntersectionData = root.intersectRay(origin, direction, null, this.camera);

            if(rayHit == null)
                return;

            this.target = rayHit.object;
        }

        override public function getObjectsUnderPoint(_arg_1:Point):Array{
            return (null);
        }

        public function showLogo():void{
            if (this.logo == null)
            {
                this.logo = new Logo();
                super.addChild(this.logo);
                this.resizeLogo();
            };
        }

        public function hideLogo():void{
            if (this.logo != null)
            {
                super.removeChild(this.logo);
                this.logo = null;
            };
        }

        public function get logoAlign():String{
            return (this._logoAlign);
        }

        public function set logoAlign(_arg_1:String):void{
            this._logoAlign = _arg_1;
            this.resizeLogo();
        }

        public function get logoHorizontalMargin():Number{
            return (this._logoHorizontalMargin);
        }

        public function set logoHorizontalMargin(_arg_1:Number):void{
            this._logoHorizontalMargin = _arg_1;
            this.resizeLogo();
        }

        public function get logoVerticalMargin():Number{
            return (this._logoVerticalMargin);
        }

        public function set logoVerticalMargin(_arg_1:Number):void{
            this._logoVerticalMargin = _arg_1;
            this.resizeLogo();
        }

        private function resizeLogo():void{
            if (this.logo != null)
            {
                if ((((this._logoAlign == StageAlign.TOP_LEFT) || (this._logoAlign == StageAlign.LEFT)) || (this._logoAlign == StageAlign.BOTTOM_LEFT)))
                {
                    this.logo.x = Math.round(this._logoHorizontalMargin);
                };
                if (((this._logoAlign == StageAlign.TOP) || (this._logoAlign == StageAlign.BOTTOM)))
                {
                    this.logo.x = Math.round(((this._width - this.logo.width) / 2));
                };
                if ((((this._logoAlign == StageAlign.TOP_RIGHT) || (this._logoAlign == StageAlign.RIGHT)) || (this._logoAlign == StageAlign.BOTTOM_RIGHT)))
                {
                    this.logo.x = Math.round(((this._width - this._logoHorizontalMargin) - this.logo.width));
                };
                if ((((this._logoAlign == StageAlign.TOP_LEFT) || (this._logoAlign == StageAlign.TOP)) || (this._logoAlign == StageAlign.TOP_RIGHT)))
                {
                    this.logo.y = Math.round(this._logoVerticalMargin);
                };
                if (((this._logoAlign == StageAlign.LEFT) || (this._logoAlign == StageAlign.RIGHT)))
                {
                    this.logo.y = Math.round(((this._height - this.logo.height) / 2));
                };
                if ((((this._logoAlign == StageAlign.BOTTOM_LEFT) || (this._logoAlign == StageAlign.BOTTOM)) || (this._logoAlign == StageAlign.BOTTOM_RIGHT)))
                {
                    this.logo.y = Math.round(((this._height - this._logoVerticalMargin) - this.logo.height));
                };
            };
        }

        public function clear():void{
            if (((!(this.device == null)) && (this.device.ready)))
            {
                this.device.clear((((stage.color >> 16) & 0xFF) / 0xFF), (((stage.color >> 8) & 0xFF) / 0xFF), ((stage.color & 0xFF) / 0xFF));
            };
            this.canvas.graphics.clear();
        }

        override public function get width():Number{
            return (this._width);
        }

        override public function set width(_arg_1:Number):void{
            this._width = _arg_1;
            this.area.width = _arg_1;
            this.resizeLogo();
        }

        override public function get height():Number{
            return (this._height);
        }

        override public function set height(_arg_1:Number):void{
            this._height = _arg_1;
            this.area.height = _arg_1;
            this.resizeLogo();
        }

        override public function addChild(_arg_1:DisplayObject):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function removeChild(_arg_1:DisplayObject):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function addChildAt(_arg_1:DisplayObject, _arg_2:int):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function removeChildAt(_arg_1:int):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function getChildAt(_arg_1:int):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function getChildIndex(_arg_1:DisplayObject):int{
            throw (new Error("Unsupported operation."));
        }

        override public function setChildIndex(_arg_1:DisplayObject, _arg_2:int):void{
            throw (new Error("Unsupported operation."));
        }

        override public function swapChildren(_arg_1:DisplayObject, _arg_2:DisplayObject):void{
            throw (new Error("Unsupported operation."));
        }

        override public function swapChildrenAt(_arg_1:int, _arg_2:int):void{
            throw (new Error("Unsupported operation."));
        }

        override public function getChildByName(_arg_1:String):DisplayObject{
            throw (new Error("Unsupported operation."));
        }

        override public function get numChildren():int{
            return (0);
        }


    }
}//package alternativa.engine3d.core

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.events.MouseEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;
import __AS3__.vec.*;

class Logo extends Sprite {

    public static const image:BitmapData = createBMP();

    private var border:int = 5;
    private var over:Boolean = false;
    private var press:Boolean;

    public function Logo(){
        graphics.beginFill(0xFF0000, 0);
        graphics.drawRect(0, 0, ((image.width + this.border) + this.border), ((image.height + this.border) + this.border));
        graphics.drawRect(this.border, this.border, image.width, image.height);
        graphics.beginBitmapFill(image, new Matrix(1, 0, 0, 1, this.border, this.border), false, true);
        graphics.drawRect(this.border, this.border, image.width, image.height);
        tabEnabled = false;
        buttonMode = true;
        useHandCursor = true;
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addEventListener(MouseEvent.CLICK, this.onClick);
        addEventListener(MouseEvent.DOUBLE_CLICK, this.onDoubleClick);
        addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseMove);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
    }

    private static function createBMP():BitmapData{
        var _local_1:BitmapData = new BitmapData(103, 22, true, 0);
        _local_1.setVector(_local_1.rect, Vector.<uint>([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x3E000000, 0xA1000000, 0x95000000, 0x2C000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x2E000000, 0x97000000, 4282199055, 4288505883, 4287716373, 4280949511, 0x89000000, 0xE000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x67000000, 4279504646, 4287917866, 4294285341, 4294478345, 4294478346, 4293626391, 4285810708, 4278387201, 0x4D000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x83000000, 4280753934, 4291530288, 4294412558, 4294411013, 4294411784, 4294411784, 4294411271, 4294411790, 4289816858, 4279635461, 0x66000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 4294892416, 0xFF000000, 0, 0, 0, 0, 0xFF000000, 4294892416, 4294892416, 4294892416, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x8B000000, 4283252258, 4293301553, 4294409478, 4294409991, 4294410761, 4294476552, 4294476296, 4294410249, 4294344200, 4294343945, 4291392799, 4280752908, 0x79000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x88000000, 4283186471, 4293692972, 4294276097, 4294343176, 4294409225, 4294475017, 4293554194, 4293817874, 4294408967, 4294342921, 4294342664, 4294341895, 4292640548, 4281936662, 0x83000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x79000000, 4282068512, 4293561399, 4294208769, 4294210313, 4294407689, 4294210313, 4290530057, 4281734151, 4282851341, 4291913754, 4294275848, 4294275591, 4294275592, 4294208517, 4293164329, 4282133785, 0x7C000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x61000000, 4280293393, 4292577349, 4294272769, 4294208264, 4294471177, 4293617417, 4286918406, 4279502337, 0x72000000, 0x79000000, 4280422919, 4289945382, 4294009867, 4293875462, 4293743369, 4293610244, 4292440624, 4280950288, 0x69000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0xFF000000, 4294892416, 4294892416, 4294892416, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x2F000000, 4279044359, 4291067728, 4294075141, 4294075143, 4294338057, 4293352968, 4284490243, 0xFF020100, 0x4D000000, 0, 0, 0x58000000, 4278781187, 4288236848, 4293610511, 4293609221, 4293610249, 4293609989, 4291261239, 4279241478, 0x4D000000, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x98000000, 4287849288, 4294009360, 4293941509, 4294007817, 4293679113, 4284620803, 0xAA000000, 0x31000000, 0, 0, 0, 0, 0x3B000000, 0xA4000000, 4288172857, 4293610511, 4293543429, 4293543943, 4293611019, 4289621050, 4278649858, 0x25000000, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 4294892416, 4294892416, 4294892416, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x79000000, 4283380775, 4294011945, 4293873409, 4293939977, 4293808649, 4285867012, 0xFF070200, 0x41000000, 0, 0, 0, 0, 0, 0, 0x38000000, 0xFF010100, 4288764223, 4293609227, 4293543175, 4293542917, 4293677843, 4287124784, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x30000000, 4279569674, 4292243009, 4293609217, 4293676041, 4293937929, 4288687621, 0xFF110400, 0x5C000000, 0, 0, 0, 0, 0, 0, 0, 0x1B000000, 0x84000000, 4278781188, 4290602054, 4293410821, 4293477384, 4293476868, 4293745950, 4283773466, 0x82000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x99000000, 4287714107, 4293543949, 4293542919, 4293673225, 4291834377, 4280879106, 0x7C000000, 0, 0, 0, 0, 0, 0, 0, 0x75000000, 4279898124, 4286467380, 4278846980, 4280686612, 4292961598, 4293343745, 4293411081, 4293476100, 4292566822, 4280357128, 0x44000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0x48000000, 4281539862, 4293417771, 4293343234, 4293277193, 4292947466, 4284880134, 0x94000000, 0, 0, 0, 0, 0, 0, 0x3B000000, 0xA4000000, 4282917657, 4291648314, 4293346067, 4288303409, 0xA3000000, 4284299053, 4293479197, 4293343493, 4293409801, 4293410569, 4288759582, 0xAD000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF000000, 0xFFE42300, 0xFFE42300, 0xFFE42300, 0xFF000000, 0x96000000, 0, 0, 0, 0xFF000000, 0xFFE42300, 0xFF000000, 0, 0, 0xB1000000, 4289023795, 4293211656, 4293144328, 4293143305, 4290389514, 4279108353, 0x20000000, 0, 0, 0, 0x14000000, 0x5C000000, 0xB2000000, 4281076999, 4287967257, 4293213977, 4293078532, 4293078275, 4293412634, 4284428061, 0xB2000000, 4289023285, 4293277192, 4293343240, 4293277191, 4293412372, 4282850829, 0x66000000, 0, 0, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFE42300, 0xFF000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFE42300, 0xFF000000, 0, 0x39000000, 4281604366, 4293149982, 4293077253, 4293078025, 4292684810, 4282912516, 0x76000000, 0x63000000, 0x6A000000, 0x7F000000, 0xBF000000, 4279371011, 4283635982, 4288752661, 4292621844, 4293078537, 4293078022, 4293078537, 4293210121, 4293144583, 4290726433, 4278518273, 4280422668, 4292691489, 4293210117, 4293276937, 4293276680, 4290592536, 4278649601, 0x8000000, 0, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0, 0xFF000000, 0xFFE42300, 0xFFE42300, 0xFF000000, 0x96000000, 0xFF000000, 0xFFE42300, 0xFFE42300, 0xFFE42300, 0xFFE42300, 0xFF000000, 0, 0xA2000000, 4287903514, 4293078538, 4293078280, 4293143817, 4290652684, 4281666563, 4281797635, 4283831561, 4284292110, 4285670934, 4289475868, 4291769878, 4293079566, 4293078281, 4293078023, 4293078280, 4293209609, 4293275145, 4292357130, 4287900432, 4280290309, 0x67000000, 0x91000000, 4286854178, 4293145355, 4293144584, 4293144328, 4293212431, 4283636492, 0x60000000, 0, 0, 0, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFFE42300, 0xFF000000, 0xFFE42300, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0x1F000000, 4280027652, 4292426772, 4293078279, 4293079049, 4293144329, 4292751115, 4292555019, 4292948491, 4293079819, 4293146126, 4293211917, 4293210888, 4293145095, 4293210632, 4293144841, 4293210633, 4293275913, 4292685578, 4288618760, 4282584324, 0xB1000000, 0x48000000, 0, 0x28000000, 4279896839, 4292362526, 4293078022, 4293078793, 4293078536, 4290065172, 4278780673, 0xA000000, 0, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0, 0, 0xFF000000, 0xFFE42300, 0xFF000000, 0xFFE42300, 0xFF000000, 0, 0xFF000000, 0xFFE42300, 0xFF000000, 0x6C000000, 4284620297, 4293211403, 4293210888, 4293211145, 4293276937, 4293277193, 4293277961, 4293344265, 4293410056, 4293344776, 4293344776, 4293345033, 4293410569, 4293475848, 4293344265, 4292819211, 4289276169, 4283437573, 0xFF080200, 0x6D000000, 0, 0, 0, 0, 0x96000000, 4287181084, 4293078538, 4293078025, 4293143560, 4293211664, 4283110665, 0x54000000, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFE42300, 0xFF000000, 0xFFE42300, 0xFF000000, 0xFF000000, 0xFF000000, 0xFFE42300, 0xFF000000, 0xB8000000, 4289148172, 4293345035, 4293345034, 4293411080, 4293476870, 4293477893, 4293544453, 4293611013, 4293677063, 4293677833, 4293677833, 4293612298, 4293218572, 4292102669, 4287771145, 4282651909, 0xFF080200, 0x72000000, 0xD000000, 0, 0, 0, 0, 0, 0x2E000000, 4280880904, 4292621585, 4293143048, 4292685067, 4290916111, 4284160266, 0x6C000000, 0, 0, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x96000000, 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFE42300, 0xFFE42300, 0xFFE42300, 0xFF000000, 0x96000000, 0xFF000000, 0xFFE42300, 0xFFE42300, 0xFFE42300, 0xFF000000, 0x96000000, 0x4F000000, 4280618243, 4284819723, 4287709972, 4289877530, 4293028892, 4293948702, 4293883680, 4293818144, 4292045341, 4289484568, 4288433169, 4286856717, 4282916870, 4279831042, 0xB5000000, 0x5B000000, 0xB000000, 0, 0, 0, 0, 0, 0, 0, 0, 0xC5000000, 4289014285, 4288159495, 4283372037, 4279370753, 0x81000000, 0x3000000, 0, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0x96000000, 0, 0, 0x96000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0x96000000, 0xFF000000, 0xFF000000, 0xFF000000, 0x96000000, 0, 0, 0x28000000, 0x6D000000, 0x9B000000, 0xBD000000, 0xF0000000, 0xFE000000, 0xFE000000, 0xFE000000, 0xE3000000, 0xBD000000, 0xB1000000, 0x9F000000, 0x5B000000, 0x21000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x5C000000, 0xC5000000, 0xBA000000, 0x6C000000, 0x17000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        return (_local_1);
    }


    private function onMouseDown(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
    }

    private function onClick(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
        try
        {
            navigateToURL(new URLRequest("http://alternativaplatform.com"), "_blank");
        }
        catch(e:Error)
        {
        };
    }

    private function onDoubleClick(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
    }

    private function onMouseMove(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
    }

    private function onMouseOut(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
    }

    private function onMouseWheel(_arg_1:MouseEvent):void{
        _arg_1.stopPropagation();
    }


}
