package alternativa.engine3d.core{
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class Wrapper {

        alternativa3d static var collector:Wrapper;

        alternativa3d var next:Wrapper;
        alternativa3d var vertex:Vertex;


        alternativa3d static function create():Wrapper{
            var _local_1:Wrapper;
            if (collector != null)
            {
                _local_1 = collector;
                collector = collector.next;
                _local_1.next = null;
                return (_local_1);
            };
            return (new (Wrapper)());
        }


        alternativa3d function create():Wrapper{
            var _local_1:Wrapper;
            if (collector != null)
            {
                _local_1 = collector;
                collector = collector.next;
                _local_1.next = null;
                return (_local_1);
            };
            return (new Wrapper());
        }
		
	   public function destroy() : void
      {
         if(this.vertex != null)
         {
            this.vertex = null;
         }
      }


    }
}//package alternativa.engine3d.core