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
	import crux.model.Commits;
	import crux.model.LogEntry;
	import crux.service.CommitsDelegate;

	import mx.rpc.events.ResultEvent;	
	import org.apache.royale.crux.utils.services.ServiceHelper;
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class CommitsController
	{
		[Inject]
		public var commitsDelegate : CommitsDelegate;
		
		
		[Bindable]
		public var commits : Commits;
		
		[Inject]
		/**
		 * Crux will automatically create any Bean for the built-in helper classes
		 * if one has not been defined.
		 */ 
		public var serviceHelper : ServiceHelper;
		
		[EventHandler( event="ServiceEvent.RESET_COMMITS" )]
		public function resetCommits():void{
			if (commits) {
				commits.commits = [];
			} else {
				commits = new Commits()
			}
		}
		

		
		[EventHandler( event="ServiceEvent.REQUEST_REPO_COMMITS", properties="repo" )]
		/**
		 * Perform a server request to save the user
		 */ 
		public function getCommits( repo : String ) : void
		{
			trace('[EventHandler] executing getCommits in CommitsController via EventHandler processing');
			serviceHelper.executeServiceCall( commitsDelegate.getCommits( repo ), handleGetCommitsResult );
		}
		
		/**
		 * Handle the server call result
		 */ 
		private function handleGetCommitsResult( event : ResultEvent ) : void
		{
			// Show an Alert just to make it obvious that the save was successful.
			trace( handleGetCommitsResult, event );
			
			var text:String= event.result as String;
			
			if (text && text.length) {
				var contents:Array = JSON.parse(text) as Array;
				var n:int = contents.length;
				for (var i:int = 0; i < n; i++)
				{
					var obj:Object = contents[i];
					var data:LogEntry = new LogEntry();
					var commitObj:Object = obj["commit"];
					var authorObj:Object = commitObj["author"];
					data.author = authorObj["name"];
					// clip date after yyyy-mm-dd
					data.date = authorObj["date"].substr(0, 10);
					data.message = commitObj["message"];
					contents[i] = data;
				}
				commits.commits = commits.commits.concat(contents);
				
				trace(commits.commits)
			}
			
		}
		
	}
}


