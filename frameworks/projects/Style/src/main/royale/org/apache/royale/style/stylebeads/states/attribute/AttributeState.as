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
package org.apache.royale.style.stylebeads.states.attribute
{

	import org.apache.royale.style.stylebeads.states.LeafDecorator;

	public class AttributeState extends LeafDecorator
	{
		override public function get isGroup():Boolean
		{
			return true;
		}
		public function AttributeState(attribute:String = null, styles:Array = null)
		{
			super(styles);
			if(attribute)
				this.attribute = attribute;

		}
		private var _attribute:String;

		public function get attribute():String
		{
			return _attribute;
		}

		public function set attribute(value:String):void
		{
			_attribute = value;
			selectorDecorator = value + ":";
			ruleDecorator = "[" + value + "]";
		}
	}
}