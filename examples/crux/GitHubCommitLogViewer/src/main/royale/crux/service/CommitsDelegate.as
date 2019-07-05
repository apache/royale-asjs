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
package crux.service
{

	import org.apache.royale.events.IEventDispatcher;
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class CommitsDelegate
	{
		[Dispatcher]
		/**
		 * The [Dispatcher] metadata tag instructs Crux to inject an event dispatcher.
		 * Event's dispatched via this dispatcher can trigger event mediators.
		 */
		public var dispatcher:IEventDispatcher;
		
		
		[Inject('commitsService')]
		public var commitsService:HTTPService;
		
		
		public function CommitsDelegate()
		{
		}
		
		/**
		 *
		 */
		public function getCommits(forRepo:String):AsyncToken
		{
			commitsService.url= "https://api.github.com/repos/" + forRepo + "/commits";
			return commitsService.send();
		}
	}
}
