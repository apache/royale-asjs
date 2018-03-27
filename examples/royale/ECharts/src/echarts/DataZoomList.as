package echarts
{

    import org.apache.royale.events.EventDispatcher;

    public class DataZoomList extends EventDispatcher{
        private var _dataZoomArray:Array = [];

        [Bindable("dataZoomListChanged")]
        public function get dataZoom():Array {
            return _dataZoomArray;
        }

        public function set dataZoom(v:Array):void {
            _dataZoomArray = v;
            for(var i:int=0; i<_dataZoomArray.length; i++) {
                _dataZoomArray[i].addEventListener("dataZoomChanged", handleDataZoomChanged);
            }
            dispatchEvent(new Event("dataZoomListChanged"));
        }

        protected function handleDataZoomChanged(event:Event):void {
            dispatchEvent(new Event("dataZoomListChanged"));
        }
        
    }
}