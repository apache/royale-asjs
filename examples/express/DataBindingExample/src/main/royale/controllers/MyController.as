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
    import org.apache.royale.events.Event;

	import org.apache.royale.core.Application;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.collections.LazyCollection;

    import models.MyModel;

	public class MyController implements IDocument
	{
		public function MyController(app:Application = null)
		{
			if (app)
			{
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}

		private var model:MyModel;
		private var initialView:Object;
		private var service:HTTPService;
		private var collection:LazyCollection;

        private var queryBegin:String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22";
        private var queryEnd:String = "%22)%0A%09%09&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json";

		private function viewChangeHandler(event:Event):void
		{
			var app:Application = event.target as Application;
			app.initialView.addEventListener("buttonClicked", buttonClickHandler);
			app.initialView.addEventListener("radioClicked", radioClickHandler);
            app.initialView.addEventListener("listChanged", listChangedHandler);

            initialView = app.initialView;
			model = app.model as MyModel;
			service = app["service"] as HTTPService;
			collection = app["collection"] as LazyCollection;
		}

        private function buttonClickHandler(event:Event):void
        {
            var sym:String = MyInitialView(initialView).symbol;
            service.url = queryBegin + sym + queryEnd;
            service.send();
            service.addEventListener("complete", completeHandler);
        }

		private function radioClickHandler(event:Event):void
		{
			var field:String = MyInitialView(initialView).requestedField;
			model.requestedField = field;
		}

        private function completeHandler(event:Event):void
        {
			model.responseData = collection.getItemAt(0);
        }

        private function listChangedHandler(event:Event):void
        {
            model.stockSymbol = MyInitialView(initialView).symbol;
        }

		public function setDocument(document:Object, id:String = null):void
		{
			var app:Application = document as Application;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

	}
}
