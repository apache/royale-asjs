package nl.ixms
{
public final class Utils
{
	public static function cleanClassQName(classQName:String):String {
		return classQName.
			replace(/\//g, '.').
			replace(/:/g, '.').
			replace(/\.\./g, '.');
	}
	
	public static function parseType(type:String):String {
		var result:String;
		
		switch (type) {
			case 'int' :
			case 'uint' :
				result = 'number';
				
				break;
			
			case 'Boolean' :
			case 'String' :
				result = type.toLowerCase();
				
				break;
			
			default :
				if (type.indexOf('.') > 0) {
					result = Utils.cleanClassQName(type);
				} else {
					result = type;
				}
				
				break;
		}
		
		return result;
	}
	
	public function Utils() {}
	
}
}
