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
	import org.apache.flex.events.Event;
	
	import org.apache.flex.core.Application;
	import org.apache.flex.core.IDocument;
    
    import models.MyModel;
    	
	public class MyController implements IDocument
	{
		public function MyController(app:Application = null)
		{
			if (app)
			{
				this.app = app as DataBindingTest;
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}
		
        private var queryBegin:String = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22";
        private var queryEnd:String = "%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json";
		private var app:DataBindingTest;
		
		private function viewChangeHandler(event:Event):void
		{
			app.initialView.addEventListener("buttonClicked", buttonClickHandler);
			app.initialView.addEventListener("radioClicked", radioClickHandler);
            app.initialView.addEventListener("listChanged", listChangedHandler);
		}
		
        private function buttonClickHandler(event:Event):void
        {
            var sym:String = MyInitialView(app.initialView).symbol;
            app.service.url = queryBegin + sym + queryEnd;
            app.service.send();
            app.service.addEventListener("complete", completeHandler);
        }
        
		private function radioClickHandler(event:Event):void
		{
			var field:String = MyInitialView(app.initialView).requestedField;
			MyModel(app.model).requestedField = field;
		}
		
        private function completeHandler(event:Event):void
        {
			MyModel(app.model).responseData = app.collection.getItemAt(0);
        }
        
        private function listChangedHandler(event:Event):void
        {
            MyModel(app.model).stockSymbol = MyInitialView(app.initialView).symbol;
        }
        
		public function setDocument(document:Object, id:String = null):void
		{
			this.app = document as DataBindingTest;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

	}
}