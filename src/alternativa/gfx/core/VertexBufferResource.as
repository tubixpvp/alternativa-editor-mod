package alternativa.gfx.core{
    import flash.display3D.VertexBuffer3D;
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class VertexBufferResource extends Resource {

        alternativagfx var buffer:VertexBuffer3D;
        protected var _vertices:Vector.<Number>;
        protected var _numVertices:int;
        protected var _data32PerVertex:int;

        public function VertexBufferResource(_arg_1:Vector.<Number>, _arg_2:int){
            this._vertices = _arg_1;
            this._data32PerVertex = _arg_2;
            this._numVertices = (this._vertices.length / this._data32PerVertex);
        }

        public function get vertices():Vector.<Number>{
            return (this._vertices);
        }

        public function get numVertices():int{
            return (this._numVertices);
        }

        public function get data32PerVertex():int{
            return (this._data32PerVertex);
        }

        override public function dispose():void{
            super.dispose();
            if (this.buffer != null)
            {
                this.buffer.dispose();
                this.buffer = null;
            };
            this._vertices = null;
        }

        override public function reset():void{
            super.reset();
            if (this.buffer != null)
            {
                this.buffer.dispose();
                this.buffer = null;
            };
        }

        override public function get available():Boolean{
            return (!(this._vertices == null));
        }

        override alternativagfx function create(_arg_1:Context3D):void{
            super.create(_arg_1);
            this.buffer = _arg_1.createVertexBuffer(this._numVertices, this._data32PerVertex);
        }

        override alternativagfx function upload():void{
            super.upload();
            this.buffer.uploadFromVector(this._vertices, 0, this._numVertices);
        }


    }
}//package alternativa.gfx.core