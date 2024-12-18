package alternativa.engine3d.containers
{
    import alternativa.engine3d.core.Object3DContainer;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Camera3D;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d; 

    use namespace alternativa3d;

    public class DistanceSortContainer extends Object3DContainer 
    {

        private static const sortingStack:Vector.<int> = new Vector.<int>();

        public var sortByZ:Boolean = false;


        override public function clone():Object3D
        {
            var _local_1:DistanceSortContainer = new DistanceSortContainer();
            _local_1.clonePropertiesFrom(this);
            return (_local_1);
        }

        override protected function clonePropertiesFrom(_arg_1:Object3D):void
        {
            super.clonePropertiesFrom(_arg_1);
            var _local_2:DistanceSortContainer = (_arg_1 as DistanceSortContainer);
            this.sortByZ = _local_2.sortByZ;
        }

        override alternativa3d function drawVisibleChildren(_arg_1:Camera3D):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:Object3D;
            var _local_7:int;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Number;
            var _local_12:Number;
            var _local_5:int;
            var _local_6:int = (numVisibleChildren - 1);
            sortingStack[0] = _local_5;
            sortingStack[1] = _local_6;
            _local_7 = 2;
            if (this.sortByZ)
            {
                while (_local_7 > 0)
                {
                    _local_6 = sortingStack[--_local_7];
                    _local_5 = sortingStack[--_local_7];
                    _local_3 = _local_6;
                    _local_2 = _local_5;
                    _local_4 = visibleChildren[((_local_6 + _local_5) >> 1)];
                    _local_9 = _local_4.ml;
                    do 
                    {
                        while ((_local_8 = (visibleChildren[_local_2] as Object3D).ml) > _local_9)
                        {
                            _local_2++;
                        };
                        while ((_local_10 = (visibleChildren[_local_3] as Object3D).ml) < _local_9)
                        {
                            _local_3--;
                        };
                        if (_local_2 <= _local_3)
                        {
                            _local_4 = visibleChildren[_local_2];
                            var _local_13:* = _local_2++;
                            visibleChildren[_local_13] = visibleChildren[_local_3];
                            var _local_14:* = _local_3--;
                            visibleChildren[_local_14] = _local_4;
                        };
                    } while (_local_2 <= _local_3);
                    if (_local_5 < _local_3)
                    {
                        _local_13 = _local_7++;
                        sortingStack[_local_13] = _local_5;
                        _local_14 = _local_7++;
                        sortingStack[_local_14] = _local_3;
                    };
                    if (_local_2 < _local_6)
                    {
                        _local_13 = _local_7++;
                        sortingStack[_local_13] = _local_2;
                        _local_14 = _local_7++;
                        sortingStack[_local_14] = _local_6;
                    };
                };
            } else
            {
                _local_2 = 0;
                while (_local_2 < numVisibleChildren)
                {
                    _local_4 = visibleChildren[_local_2];
                    _local_11 = ((_local_4.md * _arg_1.viewSizeX) / _arg_1.focalLength);
                    _local_12 = ((_local_4.mh * _arg_1.viewSizeY) / _arg_1.focalLength);
                    _local_4.distance = (((_local_11 * _local_11) + (_local_12 * _local_12)) + (_local_4.ml * _local_4.ml));
                    _local_2++;
                };
                while (_local_7 > 0)
                {
                    _local_6 = sortingStack[--_local_7];
                    _local_5 = sortingStack[--_local_7];
                    _local_3 = _local_6;
                    _local_2 = _local_5;
                    _local_4 = visibleChildren[((_local_6 + _local_5) >> 1)];
                    _local_9 = _local_4.distance;
                    do 
                    {
                        while ((_local_8 = (visibleChildren[_local_2] as Object3D).distance) > _local_9)
                        {
                            _local_2++;
                        };
                        while ((_local_10 = (visibleChildren[_local_3] as Object3D).distance) < _local_9)
                        {
                            _local_3--;
                        };
                        if (_local_2 <= _local_3)
                        {
                            _local_4 = visibleChildren[_local_2];
                            _local_13 = _local_2++;
                            visibleChildren[_local_13] = visibleChildren[_local_3];
                            _local_14 = _local_3--;
                            visibleChildren[_local_14] = _local_4;
                        };
                    } while (_local_2 <= _local_3);
                    if (_local_5 < _local_3)
                    {
                        _local_13 = _local_7++;
                        sortingStack[_local_13] = _local_5;
                        _local_14 = _local_7++;
                        sortingStack[_local_14] = _local_3;
                    };
                    if (_local_2 < _local_6)
                    {
                        _local_13 = _local_7++;
                        sortingStack[_local_13] = _local_2;
                        _local_14 = _local_7++;
                        sortingStack[_local_14] = _local_6;
                    };
                };
            };
            _local_2 = (numVisibleChildren - 1);
            while (_local_2 >= 0)
            {
                _local_4 = visibleChildren[_local_2];
                _local_4.concat(this);
                _local_4.draw(_arg_1);
                visibleChildren[_local_2] = null;
                _local_2--;
            };
        }


    }
}//package alternativa.engine3d.containers