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
package org.apache.royale.textLayout.conversion.importers {
	import org.apache.royale.textLayout.conversion.TLFormatImporter;

/** Specialized to provide case insensitivity (as required by TEXT_FIELD_HTML_FORMAT)
 *  Keys need to be lower-cased. Values may or may not based on a flag passed to the constructor. 
 */
public class CaseInsensitiveTLFFormatImporter extends TLFormatImporter
{
	private var _convertValuesToLowerCase:Boolean;

	public function CaseInsensitiveTLFFormatImporter(classType:Class,description:Object, convertValuesToLowerCase:Boolean=true)
	{
		_convertValuesToLowerCase = convertValuesToLowerCase;
		
		var lowerCaseDescription:Object = {};
		for (var prop:Object in description)
		{
			lowerCaseDescription[prop.toUpperCase()] = description[prop];
		}
		
		super(classType, lowerCaseDescription);
	}
	
	public override function importOneFormat(key:String,val:String):Boolean
	{
		return super.importOneFormat(key.toUpperCase(), _convertValuesToLowerCase ? val.toLowerCase() : val);  
	} 
	
	public function getFormatValue (key:String):*
	{
		return result ? result[key.toUpperCase()] : undefined;
	}
	
}

}
