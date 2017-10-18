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
    import org.apache.royale.events.DetailEvent;

	import org.apache.royale.core.Application;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.net.HTTPService;
	import org.apache.royale.collections.LazyCollection;

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
            mainView.addEventListener("addTag", addTagHandler);
            mainView.addEventListener("removeTag", removeTagHandler);

			model = app.model as ASDocModel;
		}

        private function addTagHandler(event:DetailEvent):void
        {
            var tags:Array = model.filterTags;
            if (!tags)
            {
                tags = [];
            }
            tags.push({name: event.detail});
            model.filterTags = tags;
        }
        
        private function removeTagHandler(event:DetailEvent):void
        {
            var tags:Array = model.filterTags;
            var n:int = tags.length;
            for (var i:int = 0; i < n; i++)
            {
                if (tags[i].name == event.detail)
                {
                    tags.splice(i, 1);
                    break;
                }
            }
            if (tags.length == 0)
                model.filterTags = null;
            else
                model.filterTags = tags;
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
