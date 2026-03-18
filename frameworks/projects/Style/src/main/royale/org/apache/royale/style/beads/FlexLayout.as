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
package org.apache.royale.style.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.stylebeads.FlexContainerStyle;
	import org.apache.royale.style.StyleUIBase;
	import org.apache.royale.style.stylebeads.layout.Display;

	public class FlexLayout extends LayoutBase
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function FlexLayout()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.StyleUIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			var styleHost:StyleUIBase = value as StyleUIBase;
			if(!styleHost.styleBeads)
				styleHost.styleBeads = [];
			var displayStyle:Display = new Display();
			displayStyle.value = "flex";
			styleHost.styleBeads.push(displayStyle);
		}
	}
}