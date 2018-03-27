package echarts
{

    import org.apache.royale.events.EventDispatcher;

    public class SeriesList extends EventDispatcher{
        private var _seriesArray:Array = [];

        [Bindable("seriesListChanged")]
        public function get series():Array {
            return _seriesArray;
        }

        public function set series(v:Array):void {
            _seriesArray = v;
            for(var i:int=0; i<_seriesArray.length; i++) {
                _seriesArray[i].addEventListener("seriesChanged", handleSeriesChanged);
            }
            dispatchEvent(new Event("seriesListChanged"));
        }

        protected function handleSeriesChanged(event:Event):void {
            dispatchEvent(new Event("seriesListChanged"));
        }
        
    }
}