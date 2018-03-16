package {
    import goog.global;
    import echarts.ECharts;

    public class EchartsExample {

        private var echartsContainer:HTMLDivElement;
        private var echartsInstance:Object;
        private var instance:ECharts;

        public function start():void {
            setupEchartsContainer();
            createEchartsInstance();
        }

		private function setupEchartsContainer():void
		{
            echartsContainer = HTMLDivElement(document.createElement("div"));
            echartsContainer.setAttribute("style", "width: 600px;height:400px;");
            document.body.appendChild(echartsContainer);
		}

		private function createEchartsInstance():void
		{
            echartsInstance = global["echarts"].init(echartsContainer);

            var option:Object = 
             {
                title: {
                    text: 'ECharts entry example'
                },
                tooltip: {},
                legend: {
                    data:['Sales']
                },
                xAxis: {
                    data: ["shirt","cardign","chiffon shirt","pants","heels","socks"]
                },
                yAxis: {},
                series: [{
                    name: 'Sales',
                    type: 'bar',
                    data: [5, 20, 36, 10, 10, 20]
                }]
            };

            echartsInstance.setOption(option);
		}
    }
}