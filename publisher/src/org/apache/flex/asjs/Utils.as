package org.apache.flex.asjs
{

import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;

public class Utils
{

	//----------------------------------------------------------------------
	//
	//    Class constants
	//
	//----------------------------------------------------------------------
	
	private static const PATH:String = "Path";
	
	//----------------------------------------------------------------------
	//
	//    Class methods
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    readELS
	//----------------------------------
	
	public static function readPath(name:String):String
	{
		var elsValue:ByteArray = EncryptedLocalStore.getItem(name + PATH);
		if (!elsValue)
			return "";
		else
			return elsValue.readUTFBytes(elsValue.length);
	}
	
	//----------------------------------
	//    writeELS
	//----------------------------------
	
	public static function writePath(name:String, value:String):void
	{
		var data:ByteArray = new ByteArray();
		data.writeUTFBytes(value);
		
		EncryptedLocalStore.setItem(name + PATH, data);
	}
	
	
	
	//----------------------------------------------------------------------
	//
	//    Constructor
	//
	//----------------------------------------------------------------------
	
	public function Utils() {}
	
}
}