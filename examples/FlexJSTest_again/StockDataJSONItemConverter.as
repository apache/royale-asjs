package
{
    import org.apache.flex.net.JSONItemConverter;
    
    public class StockDataJSONItemConverter extends JSONItemConverter
    {
        public function StockDataJSONItemConverter()
        {
            super();
        }
        
        override public function convertItem(data:String):Object
        {
            var obj:Object = super.convertItem(data);
            return obj.query.results.quote.Ask;
        }
    }
}