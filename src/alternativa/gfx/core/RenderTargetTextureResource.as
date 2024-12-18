package alternativa.gfx.core{
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3D;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class RenderTargetTextureResource extends TextureResource {

        private var _width:int;
        private var _height:int;
        private var _available:Boolean = true;

        public function RenderTargetTextureResource(_arg_1:int, _arg_2:int){
            this._width = _arg_1;
            this._height = _arg_2;
        }

        public function get width():int{
            return (this._width);
        }

        public function get height():int{
            return (this._height);
        }

        override public function dispose():void{
            super.dispose();
            this._available = false;
        }

        override public function get available():Boolean{
            return (this._available);
        }

        override alternativagfx function create(_arg_1:Context3D):void{
            super.create(_arg_1);
            texture = _arg_1.createTexture(this._width, this._height, Context3DTextureFormat.BGRA, true);
        }


    }
}//package alternativa.gfx.core