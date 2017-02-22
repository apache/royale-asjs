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
package org.apache.flex.html.beads.layouts
{
	import org.apache.flex.html.beads.layouts.VerticalLayout;
	
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	
	public class VerticalFlexLayout extends VerticalLayout
	{
		public function VerticalFlexLayout()
		{
			super();
		}
		
		// the strand/host container is also an ILayoutChild because
		// can have its size dictated by the host's parent which is
		// important to know for layout optimization
		private var host:ILayoutChild;
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			host = value as ILayoutChild;
		}
		
		/**
		 * 
		 *  @flexjsignorecoercion org.apache.flex.core.ILayoutHost
		 */
		override public function layout():Boolean
		{
			COMPILE::SWF {
				return super.layout();
			}
			
			COMPILE::JS {
				var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
				
				// set the display on the contentView
				viewBead.contentView.width = host.width;
				viewBead.contentView.element.style["display"] = "flex";
				viewBead.contentView.element.style["flex-flow"] = "column";
				
				return true;
			}
		}
	}
}