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
package mx.display
{
    import mx.core.UIComponent;
    import mx.utils.ByteArray;
    import mx.controls.Image;
    import org.apache.royale.net.URLRequest;
    import org.apache.royale.events.Event;

    public class Loader extends UIComponent
    {
        private var _contentLoaderInfo:LoaderInfo;
        private var _content:UIComponent;

        public function get contentLoaderInfo():LoaderInfo
        {
            if (!_contentLoaderInfo)
            {
                _contentLoaderInfo = new LoaderInfo(this);
            }
            return _contentLoaderInfo;
        }

        public function get content():UIComponent
        {
            if (!_content)
            {
                _content = new Image();
                _content.addEventListener(Event.COMPLETE, loadCompleteHandler)
            }
            return _content;
        }
        
        public function load(request:URLRequest, context:Object=null):void
        {
            // TODO do we need to add element before loading from source?
            (content as Image).source = request.url;
        }

        public function loadBytes(bytes:ByteArray):void
	    {
		    // TODO not implemented
	    }

        private function loadCompleteHandler(event:Event):void
        {
            addElement(_content);
            contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}
