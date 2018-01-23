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
package renderers
{
	import org.apache.royale.html.supportClasses.StringItemRenderer;
	
	public class StockRenderer extends StringItemRenderer
	{
		public function StockRenderer()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var n1:Number = Number(value[labelField]);
			if (!isNaN(n1)) {
				n1 = Math.round(n1*100)/100.0;
				
				// something to keep in mind when using Royale for cross-platform
				// use: make sure that public properties are used versus protected
				// functions or properties. in most cases, internal vars and functions
				// will be platform-specific whereas public properties and function
				// should be cross-platform. 
				text = String(n1);
			}
		}
	}
}
