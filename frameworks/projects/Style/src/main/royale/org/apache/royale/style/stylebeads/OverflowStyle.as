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
package org.apache.royale.style.stylebeads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IUIBase;

	/**
	 *  The ScrollStyle class is a StyleBead that applies scroll behavior to a component.
	 *  It allows you to specify how overflow content should be handled, such as whether to
	 *  show scrollbars, hide overflow, or allow content to be visible outside the component's bounds.
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.13
	 */
	public class OverflowStyle extends StyleBeadBase
	{
		public function OverflowStyle()
		{
			super();
		}

		private var _overflowX:String = "visible";
		[Inspectable(category = "General", enumeration = "visible,hidden,scroll,auto", defaultValue = "visible")]
			public function get overflowX():String
			{
				return _overflowX;
			}

			public function set overflowX(value:String):void
			{
				_overflowX = value;
			}
			private var _overflowY:String = "visible";
		[Inspectable(category = "General", enumeration = "visible,hidden,scroll,auto", defaultValue = "visible")]
			public function get overflowY():String
			{
				return _overflowY;
			}

			public function set overflowY(value:String):void
			{
				_overflowY = value;
			}
			private const selectorName:String = "overflow";
			override public function get selectors():Array
			{
				var s:String = selectorName;
				if (overflowX == overflowY)
					return ["." + s + "-" + overflowX];

				return [
					"." + s + "-x-" + overflowX,
					"." + s + "-y-" + overflowY
				];
			}

			override public function get rules():Array
			{
				var s:String = selectorName;
				if (overflowX == overflowY)
					return ["." + s + ":" + overflowX + ";"];

				return [
					s + "-x:" + overflowX + ";",
					s + "-y:" + overflowY + ";"
				];
			}

		}
	}