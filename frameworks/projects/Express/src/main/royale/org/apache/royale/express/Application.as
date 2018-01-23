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
	import org.apache.royale.binding.ApplicationDataBinding;
	import org.apache.royale.core.Application;
	import org.apache.royale.core.AllCSSValuesImpl;

	/**
	 * This class extends the standard Application and sets up the
	 * SimpleCSSValuesImpl (implementation) for convenience.
	 *
	 * @flexcomponent spark.components.Application
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/Application.html
	 * @commentary Unlike Flex Application, Royale Application does not provide a user interface container. Instead, you create an instance of org.apache.royale.express.View as the Application's initialView property.
	 * @commentary The Express version of Application pre-packages some additional beads.
	 * @example &lt;js:Application&gt;
	 * @example &nbsp;&nbsp;&lt;js:initialView&gt;
	 * @example &nbsp;&nbsp;&nbsp;&nbsp;&lt;local:MyInitialView /&gt;
	 * @example &nbsp;&nbsp;&lt;/js:initialView&gt;
	 * @example &lt;/js:Application&gt;
	 */
	public class Application extends org.apache.royale.core.Application
	{
		public function Application()
		{
			super();

			this.valuesImpl = new AllCSSValuesImpl();
			addBead(new ApplicationDataBinding());
		}
	}
}
