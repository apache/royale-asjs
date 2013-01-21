package org.apache.flex.asjs.enums
{
public class BrowseTypes
{

	//----------------------------------------------------------------------
	//
	//    Class constants
	//
	//----------------------------------------------------------------------
	
	public static const BROWSE_DIR:BrowseTypes = new BrowseTypes("dir");
	public static const BROWSE_FILE:BrowseTypes = new BrowseTypes("file");
	
	//----------------------------------------------------------------------
	//
	//    Constructor
	//
	//----------------------------------------------------------------------
	
	public function BrowseTypes(stringValue:String) 
	{
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
	
	public function toString():String
	{
		return stringValue;
	}
	
}
}