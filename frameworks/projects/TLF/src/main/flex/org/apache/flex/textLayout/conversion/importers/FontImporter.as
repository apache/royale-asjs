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

	public class FontImporter extends TLFormatImporter {
		public function FontImporter(classType:Class, description:Object) {
			super(classType, description);
		}

		public override function importOneFormat(key:String, val:String):Boolean {
			key = key.toUpperCase();
			if (key == "LETTERSPACING")
				key = "trackingRight";
			else if (key == "FACE")
				key = "fontFamily";
			else if (key == "COLOR")
				key = "color";
			return super.importOneFormat(key, val);  // no case-coversion required, values for these formats in TLF are case-insensitive
		}
	}
}
