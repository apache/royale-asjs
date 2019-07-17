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
package crux.controller
{
	import crux.model.Project;
	import crux.service.ConfigurationDelegate;
	import mx.rpc.events.ResultEvent;	
	import org.apache.royale.crux.utils.services.ServiceHelper;
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class ConfigurationController
	{
		[Inject]
		public var configurationDelegate : ConfigurationDelegate;
		
		
		[Bindable]
		public var project : Project;
		
		
		private var serviceHelper:ServiceHelper;
		
		
		[PostConstruct]
		/**
		 * [PostConstruct] methods are invoked after all dependencies are injected.
		 * In this example, we set up a default user after the bean is created.
		 */
		public function postConstruct() : void
		{
			project = new Project();
			serviceHelper = new ServiceHelper();
			trace('getProject executing in ConfigurationController via PostConstruct processing');
			getProject();
		}
		
		

		/**
		 * Perform a server request to save the user
		 */ 
		public function getProject( ) : void
		{
			serviceHelper.executeServiceCall( configurationDelegate.getProject(), handleGetProjectResult );
		}
		
		/**
		 * Handle the server call result
		 */ 
		private function handleGetProjectResult( event : ResultEvent ) : void
		{
			
			var text:String = event.result as String;
			
			if (text && text.length) {
				var value:Object = JSON.parse(text);
				var p:Project = new Project();
				p.projectName = value['projectName'];
				p.license = value['license'];
				p.repos = value['repos'];
				project = p;
			}
			
		}
		
	}
}


