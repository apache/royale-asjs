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
	import models.MyModel;
	
	import org.apache.flex.core.Application;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.events.Event;
    	
	public class MyController implements IDocument
	{
		public function MyController(app:Application = null)
		{
			if (app)
			{
				this.app = app as RoyaleTest_SVG;
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}
		
		private var app:RoyaleTest_SVG;
		
		private function viewChangeHandler(event:Event):void
		{
		}
		
        
		public function setDocument(document:Object, id:String = null):void
		{
			this.app = document as RoyaleTest_SVG;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

	}
}
