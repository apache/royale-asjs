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
	import org.apache.flex.net.HTTPService;
	import org.apache.flex.collections.LazyCollection;

    import models.ASDocModel;

	public class ASDocController implements IDocument
	{
		public function ASDocController(app:Application = null)
		{
			if (app)
			{
				app.addEventListener("viewChanged", viewChangeHandler);
			}
		}

		private var model:ASDocModel;
		private var mainView:ASDocMainView;

		private function viewChangeHandler(event:Event):void
		{
			var app:ASDoc = event.target as ASDoc;
            mainView = app.mainView as ASDocMainView;
			mainView.addEventListener("packageChanged", packageChangedHandler);
            mainView.addEventListener("classChanged", classChangedHandler);

			model = app.model as ASDocModel;
		}

        private function packageChangedHandler(event:Event):void
        {
            var sym:String = mainView.currentPackage;
            model.currentPackage = sym;
        }

        private function classChangedHandler(event:Event):void
        {
            var sym:String = mainView.currentClass;
            model.currentClass = sym;
        }
        
		public function setDocument(document:Object, id:String = null):void
		{
			var app:Application = document as Application;
			app.addEventListener("viewChanged", viewChangeHandler);
		}

	}
}
