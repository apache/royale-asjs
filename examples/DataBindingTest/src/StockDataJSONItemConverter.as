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
			if (obj["query"]["count"] == 0)
				return "No Data";
			
			obj = obj["query"]["results"]["quote"];
			return obj;
        }
    }
}