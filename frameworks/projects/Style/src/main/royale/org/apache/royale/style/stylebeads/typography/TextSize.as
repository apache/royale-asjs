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
package org.apache.royale.style.stylebeads.typography
{
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.CompositeStyle;

	public class TextSize extends CompositeStyle
	{
		public function TextSize(value:* = null)
		{
			super();
			fontSize = new FontSize();
			lineHeight = new LineHeight();
			styles = [fontSize, lineHeight];
			if(value != null)
				this.value = value;
		}
		private var fontSize:FontSize;
		private var lineHeight:LineHeight;
		public function get value():*
		{
			return _value;
		}
		[Inspectable(category="General", enumeration="xs,sm,base,lg,xl,2xl,3xl,4xl,5xl,6xl,7xl,8xl,9xl", defaultValue="base")]
		public function set value(value:*):void
		{
			_value = fontSize.value = lineHeight.value = value;
		}
		private var _value:*;
	}
}