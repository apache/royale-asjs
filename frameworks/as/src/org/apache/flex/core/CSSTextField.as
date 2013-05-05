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
package org.apache.flex.core
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.apache.flex.core.ValuesManager;
		
	public class CSSTextField extends TextField
	{
		public function CSSTextField()
		{
			super();
		}
		
		// if used as the display object in a button, parent is null and
		// the css lookup doesn't work.  This will be used if parent is 
		// null.
		public var styleParent:Object;
		
		override public function set text(value:String):void
		{
			var sp:Object = parent;
			if (!sp)
				sp = styleParent;
			
			var tf: TextFormat = new TextFormat();
			tf.font = ValuesManager.valuesImpl.getValue(sp, "fontFamily") as String;
			tf.size = ValuesManager.valuesImpl.getValue(sp, "fontSize");
			tf.bold = ValuesManager.valuesImpl.getValue(sp, "fontWeight") == "bold";
			tf.color = ValuesManager.valuesImpl.getValue(sp, "color");
			var padding:Object = ValuesManager.valuesImpl.getValue(sp, "padding");
			if (padding != null)
			{
				tf.leftMargin = padding;
				tf.rightMargin = padding;
			}
			defaultTextFormat = tf;
			super.text = value;
		}
	}
}