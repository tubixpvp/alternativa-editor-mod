package alternativa.gfx.core
{
    import flash.display3D.Program3D;
    import flash.utils.ByteArray;
    import flash.display3D.Context3D;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class ProgramResource extends Resource 
    {

        alternativagfx var program:Program3D;
        private var _vertexProgram:ByteArray;
        private var _fragmentProgram:ByteArray;

        public function ProgramResource(_arg_1:ByteArray, _arg_2:ByteArray)
        {
            this._vertexProgram = _arg_1;
            this._fragmentProgram = _arg_2;
        }

        public function get vertexProgram():ByteArray
        {
            return (this._vertexProgram);
        }

        public function get fragmentProgram():ByteArray
        {
            return (this._fragmentProgram);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.program != null)
            {
                this.program.dispose();
                this.program = null;
            };
            this._vertexProgram = null;
            this._fragmentProgram = null;
        }

        override public function reset():void
        {
            super.reset();
            if (this.program != null)
            {
                this.program.dispose();
                this.program = null;
            };
        }

        override public function get available():Boolean
        {
            return ((!(this._vertexProgram == null)) && (!(this._fragmentProgram == null)));
        }

        override alternativagfx function create(_arg_1:Context3D):void
        {
            super.create(_arg_1);
            this.program = _arg_1.createProgram();
        }

        override alternativagfx function upload():void
        {
            super.upload();
            this.program.upload(this.vertexProgram, this.fragmentProgram);
        }


    }
}//package alternativa.gfx.core