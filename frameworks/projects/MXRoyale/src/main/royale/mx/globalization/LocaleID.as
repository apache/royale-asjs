////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.globalization
{

public class LocaleID
{
	public static const DEFAULT:String = "i-default";

	public var lastOperationStatus:String;
	public var name:String;

	public function LocaleID(name:String)
	{
		this.name = name;
	}
 	 	
	public function determinePreferredLocales(want:Vector.<String>, have:Vector.<String>, keyword:String = "userinterface"):Vector.<String>
	{
		return null;
	}

	public function getKeysAndValues():Object
	{
		return null;
	}
 	 	
	public function getLanguage():String
	{
		return "";
	}
 	 	
	public function getRegion():String
	{
		return "";
	}

	public function getScript():String
	{
		return "";
	}

	public function getVariant():String
	{
		return "";
	}

	public function isRightToLeft():Boolean
	{
		return false;
	}
}

}
