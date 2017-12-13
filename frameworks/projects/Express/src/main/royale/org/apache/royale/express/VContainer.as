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
	import org.apache.royale.html.beads.layouts.VerticalLayout;

	/**
	 * This class extends Container and adds the VerticalLayout bead
	 * for convenience.
	 *
	 * @flexcomponent spark.components.VGroup
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/Group.html
	 * @commentary In the Royale Express package, data binding is prepackaged into the VContainer component.
	 * @commentary Royale Express VContainer also includes support for scrolling.
	 * @commentary Royale Express also provides Container (basic layout) and HContainer (horizontal layout) for convenience.
	 */
	public class VContainer extends Container
	{
		public function VContainer()
		{
			super();

			addBead(new VerticalLayout());
		}
	}
}
