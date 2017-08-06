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
package org.apache.flex.express
{
	import org.apache.flex.binding.ContainerDataBinding;
	import org.apache.flex.core.BindableCSSStyles;
	import org.apache.flex.core.StyleChangeNotifier;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.beads.layouts.LayoutOnShow;
	import org.apache.flex.html.supportClasses.ScrollingViewport;
	
	COMPILE::SWF {
		import org.apache.flex.html.beads.SingleLineBorderWithChangeListenerBead;
		import org.apache.flex.html.beads.SolidBackgroundWithChangeListenerBead;
	}
	
	/**
	 * This class extends the standard Container and adds the
	 * ContainerDataBinding bead and ScrollingViewport beads for
	 * convenience.
	 */
	public class Container extends org.apache.flex.html.Container
	{
		public function Container()
		{
			super();
			
			var wasStyle:Object = style;
			
			style = new BindableCSSStyles();
			
			addBead(new ContainerDataBinding());
			addBead(new ScrollingViewport());
			addBead(new StyleChangeNotifier());
			addBead(new LayoutOnShow());
			
			COMPILE::SWF {
				addBead(new SolidBackgroundWithChangeListenerBead());
				addBead(new SingleLineBorderWithChangeListenerBead());
			}
		}
	}
}