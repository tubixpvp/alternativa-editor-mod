package alternativa.gfx.core{
    import flash.display3D.textures.Texture;

    public class TextureResource extends Resource {

        protected var useNullTexture:Boolean = false;
        private var _texture:Texture = null;


        override public function dispose():void{
            super.dispose();
            if (this._texture != null)
            {
                this._texture.dispose();
                this._texture = null;
            };
        }

        public function get texture():Texture{
            if (this.useNullTexture)
            {
                return (this.getNullTexture());
            };
            return (this._texture);
        }

        public function set texture(_arg_1:Texture):void{
            this._texture = _arg_1;
        }

        protected function getNullTexture():Texture{
            return (null);
        }


    }
}//package alternativa.gfx.core