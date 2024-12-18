package alternativa.engine3d.materials
{
    import __AS3__.vec.Vector;
    import flash.geom.Matrix;
    import __AS3__.vec.*;

    public class UVMatrixProvider 
    {

        private var matrixValues:Vector.<Number> = new Vector.<Number>(8);
        private var matrix:Matrix = new Matrix();


        public function getMatrix():Matrix
        {
            return (this.matrix);
        }

        public function getValues():Vector.<Number>
        {
            var _local_1:Matrix = this.getMatrix();
            this.matrixValues[0] = _local_1.a;
            this.matrixValues[1] = _local_1.b;
            this.matrixValues[2] = _local_1.tx;
            this.matrixValues[3] = 0;
            this.matrixValues[4] = _local_1.c;
            this.matrixValues[5] = _local_1.d;
            this.matrixValues[6] = _local_1.ty;
            this.matrixValues[7] = 0;
            return (this.matrixValues);
        }


    }
}//package alternativa.engine3d.materials