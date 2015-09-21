package controllers
{
	import org.apache.flex.collections.parsers.JSONInputParser;
	
	public class GAJSONInputParser extends JSONInputParser
	{
		public function GAJSONInputParser()
		{
		}
		
		override public function parseItems(s:String):Array
		{
			var rowsArrayStartIndex:int = s.indexOf('"rows": [', 0);
			var rowsArrayEndIndex:int = s.indexOf("]]", rowsArrayStartIndex);
			var rowsArrayString:String = s.slice(rowsArrayStartIndex + 9,rowsArrayEndIndex);
			var rowsArray:Array = rowsArrayString.split("],");
			return rowsArray;
		}
	}
}