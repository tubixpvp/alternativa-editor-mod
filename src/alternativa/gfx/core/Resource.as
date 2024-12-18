package alternativa.gfx.core{
    import flash.display3D.Context3D;
    import alternativa.gfx.alternativagfx; 

    use namespace alternativagfx;

    public class Resource {

        public var context:Context3D = null;


        public function dispose():void{
            this.context = null;
        }

        public function reset():void{
            this.context = null;
        }

        public function get available():Boolean{
            return (false);
        }

        alternativagfx function create(_arg_1:Context3D):void{
            this.context = _arg_1;
        }

        alternativagfx function upload():void{
        }

        public function isCreated(_arg_1:Context3D):Boolean{
            return ((!(this.context == null)) && (this.context == _arg_1));
        }


    }
}//package alternativa.gfx.core