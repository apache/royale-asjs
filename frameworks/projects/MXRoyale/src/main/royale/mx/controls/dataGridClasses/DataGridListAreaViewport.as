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
package mx.controls.dataGridClasses
{

	import org.apache.royale.html.supportClasses.ScrollingViewport;

	import mx.core.ScrollControlBase;
	import mx.core.ScrollPolicy;
	/**
	 * The ScrollingViewport extends the Viewport class by adding horizontal and
	 * vertical scroll bars, if needed, to the content area of a Container. In
	 * addition, the content of the Container is clipped so that items extending
	 * outside the Container are hidden and reachable only by scrolling.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::JS
	public class DataGridListAreaViewport extends ScrollingViewport
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridListAreaViewport()
		{
			super();
		}

		
		/**
		 * 
     *  @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 */
		override protected function setScrollStyle():void
		{
			//get the startup values from the base component
			var scrollBase:ScrollControlBase = this.contentArea.parent as ScrollControlBase;
			if (scrollBase) {
				var listElement:HTMLElement = this.contentArea.element;
				var policy:String = scrollBase.horizontalScrollPolicy;
				listElement.style.overflowX = policy == ScrollPolicy.OFF ? 'hidden' : (policy == ScrollPolicy.ON ? 'scroll' : 'auto');
				policy = scrollBase.verticalScrollPolicy;
				listElement.style.overflowY = policy == ScrollPolicy.OFF ? 'hidden' : (policy == ScrollPolicy.ON ? 'scroll' : 'auto');
			}
			adaptContentArea();
		}

	}
	
	COMPILE::SWF
	public class DataGridListAreaViewport extends ScrollingViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function DataGridListAreaViewport()
		{
			super();
		}

	}
}
