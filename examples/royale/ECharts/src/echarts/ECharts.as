package echarts
{
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.UIBase;
    import goog.global;

    public class ECharts extends UIBase {
        
        private var echartsContainer:WrappedHTMLElement;
        private var echartsInstance:Object;

        //EChart options
        private var _chartOptions:EChartsOptions;

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

            var option:Object = 
             {
                xAxis: {
                    data: ["shirt","cardign","chiffon shirt","pants","heels","socks"]
                },
                yAxis: {

                },
                series:[{
                    data: [5, 20, 36, 10, 10, 20],
                    type: "bar",
                    name: "Sales"
                }],
                tooltip: {},
                legend: {
                    data:['Sales']
                }           
            };

            //echartsInstance.setOption(option);

            return echartsContainer;
        }

        public function set chartOptions(v:EChartsOptions):void {
            this._chartOptions = v;
            echartsInstance.setOption(v);
        }

        public function get chartOptions():EChartsOptions {
            return this._chartOptions;
        }
    }
}