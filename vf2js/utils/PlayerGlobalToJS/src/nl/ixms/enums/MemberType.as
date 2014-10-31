package nl.ixms.enums
{
	
public class MemberType
{
	
	//--------------------------------------------------------------------------
	//
	//    Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const CONSTANT:MemberType = new MemberType("constants");
	public static const METHOD:MemberType = new MemberType("methods");
	public static const PROPERTY:MemberType = new MemberType("properties");
	public static const STATIC_CONSTANT:MemberType = new MemberType("static_constants");
	public static const STATIC_METHOD:MemberType = new MemberType("static_methods");
	public static const STATIC_PROPERTY:MemberType = new MemberType("static_properties");
	public static const STATIC_VARIABLE:MemberType = new MemberType("static_variables");
	public static const VARIABLE:MemberType = new MemberType("variables");
	
	
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function MemberType(stringValue:String) {
		this.stringValue = stringValue;
	}
	
	
	
	//--------------------------------------------------------------------------
	//
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var stringValue:String;
	
	
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    toString
	//----------------------------------
	
	public function toString():String {
		return stringValue;
	}
	
}

}
