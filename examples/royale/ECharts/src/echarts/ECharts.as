package echarts
{
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.UIBase;
    import goog.global;

    public class ECharts extends UIBase {
        
        private var echartsContainer:WrappedHTMLElement;
        private var echartsInstance:Object;
        private var echartsInstanceCreated:Boolean = false;

        //EChart options
        private var _chartOptions:EChartsOptions = null;

        public function ECharts()
        {
            super();
            className = "";
        }

        override protected function createElement():WrappedHTMLElement
        {
			echartsContainer = addElementToWrapper(this,'div');
            echartsContainer.setAttribute("style", "width: 600px;height:400px;");

            echartsInstance = global["echarts"].init(echartsContainer);
            echartsInstanceCreated = true;

            var option:Object = 
             {
                xAxis:{},
                yAxis:{},
                series:[{
                    data: [5, 20, 36, 10, 10, 20],
                    type: "bar",
                    name: "Sales"
                }]
            };

            //echartsInstance.setOption(option);

            return echartsContainer;
        }

        protected function handleChartOptionsChanged(event:Event):void {
            applyChartOptions(EChartsOptions(event.currentTarget).options);
        }

        public function set chartOptions(v:EChartsOptions):void {
            if(this._chartOptions == null) {
                this._chartOptions = v;
                this._chartOptions.addEventListener("chartOptionsChanged", this.handleChartOptionsChanged);
                this.applyChartOptions(this._chartOptions.options);
            }
            else {
                if(!isEqual(this._chartOptions.options, v.options)) {
                    this._chartOptions = v;
                    this._chartOptions.addEventListener("chartOptionsChanged", this.handleChartOptionsChanged);
                    this.applyChartOptions(this._chartOptions.options);
                }
            }
        }

        private function applyChartOptions(options:Object):void {
            if(this.echartsInstanceCreated) {
                this.echartsInstance.setOption(options);
            }
        }

        private function isEqual(a:Object, b:Object):Boolean {
            return JSON.stringify(a) === JSON.stringify(b);
        }

        public function get chartOptions():EChartsOptions {
            return this._chartOptions;
        }

        public function redraw(v:EChartsOptions):void {
            echartsInstance.resize(v);
        }
    }
}