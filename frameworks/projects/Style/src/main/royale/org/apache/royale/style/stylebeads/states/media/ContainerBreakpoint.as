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
package org.apache.royale.style.stylebeads.states.media
{
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.stylebeads.states.QueryBaseStyle;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	public class ContainerBreakpoint extends QueryBaseStyle
	{
		public function ContainerBreakpoint(size:* = null, styles:Array = null)
		{
			super();
			queryType = "container";
			if (styles)
				this.styles = styles;
			if (size != null)
				this.size = size;
		}

		private var _containerType:String = "inline-size";
		/**
		 * The type of the container query. Defaults to "inline-size".
		 * Can also be "size" or "normal".
		 */
		public function get containerType():String
		{
			return _containerType;
		}

		public function set containerType(value:String):void
		{
			_containerType = value;
			if (strand)
			{
				applyContainerStyles();
			}
		}

		override protected function applyContainerStyles():void
		{
			if (strand is IStyleUIBase)
			{
				(strand as IStyleUIBase).setStyle("container-type", _containerType);
			}
		}

		private var _size:*;

		public function get size():*
		{
			return _size;
		}

		public function set size(value:*):void
		{
			_size = value;
			if(value == null)
			{
				queryBody = "";
				querySelector = "";
				return;
			}
			var sizeValue:String = computeSize(value);
			queryBody = "(min-width: " + sizeValue + ")";
			querySelector = "container-min-width-" + sanitizeIdentifier(sizeValue);
		}
	}
}