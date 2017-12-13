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
package org.apache.royale.express
{
	import org.apache.royale.binding.ContainerDataBinding;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.supportClasses.ScrollingViewport;

	import org.apache.royale.core.BindableCSSStyles;
	import org.apache.royale.core.StyleChangeNotifier;

	COMPILE::SWF {
		import org.apache.royale.html.beads.SolidBackgroundWithChangeListenerBead;
		import org.apache.royale.html.beads.SingleLineBorderWithChangeListenerBead;
	}

	/**
	 * This class extends the standard Container and adds the
	 * ContainerDataBinding bead and ScrollingViewport beads for
	 * convenience.
	 *
	 * @flexcomponent spark.components.Group
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/Group.html
	 * @commentary In the Royale Express package, data binding is prepackaged into the Container component.
	 * @commentary Royale Express Container also includes support for scrolling.
	 * @commentary Royale Express also provides HContainer (horizontal layout) and VContainer (vertical layout) for convenience.
	 */
	public class Container extends org.apache.royale.html.Container
	{
		public function Container()
		{
			super();

			var wasStyle:Object = style;

			style = new BindableCSSStyles();

			addBead(new ContainerDataBinding());
			addBead(new ScrollingViewport());
			addBead(new StyleChangeNotifier());

			COMPILE::SWF {
				addBead(new SolidBackgroundWithChangeListenerBead());
				addBead(new SingleLineBorderWithChangeListenerBead());
			}
		}
	}
}
