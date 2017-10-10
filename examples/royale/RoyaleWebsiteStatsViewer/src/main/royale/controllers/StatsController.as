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
package controllers
{
	
	import models.StatsModel;
	
	import org.apache.royale.core.Application;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.events.Event;
    	
	public class StatsController implements IDocument
	{
		public function StatsController(a:Application = null)
		{
			if (a)
			{
				this.app = a as RoyaleWebsiteStatsViewer;
				this.app.addEventListener("viewChanged", viewChangeHandler);
			}
		}
		
        private var lastThirtyDaysUsers:String = 'https://apache.royale-dashboard.appspot.com/query?id=ahdzfmFwYWNoZS1mbGV4LWRhc2hib2FyZHIVCxIIQXBpUXVlcnkYgICAgICAgAoM&format=json'
		
		private var app:RoyaleWebsiteStatsViewer;
		
		private function viewChangeHandler(event:Event):void
		{
			app.initialView.addEventListener("refresh", buttonClickHandler);
		}
		
        private function buttonClickHandler(event:Event):void
        {
            app.service.url = lastThirtyDaysUsers;
            app.service.send();
            app.service.addEventListener("complete", completeHandler);
        }
		
        private function completeHandler(event:Event):void
        {
			var lastThirtyDaysUsers:Array = [];
			if(app.collection)
			{
				for (var i:int = 0; i < app.collection.length; i++) 
				{
					lastThirtyDaysUsers.push(app.collection.getItemAt(i))	
				}
				
			}
			
			StatsModel(app.model).lastThirtyDaysUsers = lastThirtyDaysUsers;
        }
        
		public function setDocument(document:Object, id:String = null):void
		{
			this.app = document as RoyaleWebsiteStatsViewer;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

	}
}
