package alternativa.gfx.core
{
    import flash.display3D.IndexBuffer3D;
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class IndexBufferResource extends Resource 
    {

        alternativagfx var buffer:IndexBuffer3D;
        private var _indices:Vector.<uint>;
        private var _numIndices:int;

        public function IndexBufferResource(_arg_1:Vector.<uint>)
        {
            this._indices = _arg_1;
            this._numIndices = this._indices.length;
        }

        public function get indices():Vector.<uint>
        {
            return (this._indices);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.buffer != null)
            {
                this.buffer.dispose();
                this.buffer = null;
            };
            this._indices = null;
        }

        override public function reset():void
        {
            super.reset();
            if (this.buffer != null)
            {
                this.buffer.dispose();
                this.buffer = null;
            };
        }

        override public function get available():Boolean
        {
            return (!(this._indices == null));
        }

        override alternativagfx function create(_arg_1:Context3D):void
        {
            super.create(_arg_1);
            this.buffer = _arg_1.createIndexBuffer(this._numIndices);
        }

        override alternativagfx function upload():void
        {
            super.upload();
            this.buffer.uploadFromVector(this._indices, 0, this._numIndices);
        }


    }
}//package alternativa.gfx.core