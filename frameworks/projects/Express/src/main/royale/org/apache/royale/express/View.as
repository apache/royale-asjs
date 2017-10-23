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
	import org.apache.royale.binding.ViewDataBinding;
	import org.apache.royale.core.View;

	/**
	 * This View extends the standard View and adds the ViewDataBinding bead
	 * for convenience.
	 *
	 * @flexcomponent spark.components.Application
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/Application.html
	 * @commentary Unlike Flex, the Royale Application has no visual aspect. Instead, Royale application's extend the View class which is most often the base class for application MXML components.
	 * @commentary The Royale Express View includes data binding. For convenience, Royale Express also provides HView (horizontal layout) and VView (vertical layout).
	 *
	 */
	public class View extends org.apache.royale.core.View
	{
		public function View()
		{
			super();

			addBead(new ViewDataBinding());
		}
	}
}
