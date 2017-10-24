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
package models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	public class MainModel extends EventDispatcher implements IBeadModel
	{
		public function MainModel()
		{
		}

        private var app:Flex2Royale;

        public function set strand(value:IStrand):void
        {
            app = value as Flex2Royale;
            app.addEventListener("initialize", initializeHandler);

        }

        private function initializeHandler(event:Event):void
        {
            app.service.addEventListener("complete", configCompleteHandler);
            app.service.url = "commentary.json";
            app.service.send();
        }

        private var tagNameMap:Object;

        private var _knownTags:Array;

        [Bindable("packageListChanged")]
        public function get knownTags():Array
        {
            return _knownTags;
        }

        [Bindable("recordChanged")]
        public function get record():Object
        {
        	return {flexClass: flexClassName,
        	        royaleClass: royaleExpressClassName,
        	        commentary: royaleExpressCommentary,
        	        example: royaleExpressExample,
        	        description: royaleExpressDescription};
        }

        private var configData:Array;
        private var configIndex:int = 0;

        private function configCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", configCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            var list:Array = config["list"];

            for(var i:int=0; i < list.length; i++) {
                var item:Object = list[i];
                trace("Item "+i+": "+item["flexComponent"]);

                processItem(item);
            }
        }

        private function processItem(item:Object):void
        {
            trace("Process "+item);

            flexClassName = item["flexcomponent"][0];
            flexDocUrl = item["flexdocurl"][0];
            royaleExpressCommentary = item["commentary"];
            royaleExpressDescription = item["description"];
            royaleExpressExample = item["example"];
            royaleExpressClassName = item["className"];

            dispatchEvent(new Event("recordChanged"));
        }

        public var flexClassName:String = "";
        public var flexDocUrl:String = "";
        public var royaleExpressClassName:String = "";
        public var royaleExpressCommentary:Array = [];
        public var royaleExpressDescription:String = "";
        public var royaleExpressExample:Array = [];

        private function processConfigData():void
        {
        	_currentClassData = null;

        	var item:Object = configData[configIndex];
        	var fileURL:String = computeFileName(item.royaleExpressClassName);
        	app.service.addEventListener("complete", completeClassHandler);
        	app.service.url = fileURL;
        	app.service.send();
        }

        private function completeClassHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeClassHandler);
            var data:Object = JSON.parse(app.service.data);
            if (_currentClassData == null)
            {
                _currentClassData = data;

				flexClassName = configData[configIndex].flexClassName;
				royaleExpressClassName = configData[configIndex].royaleExpressClassName;
                royaleExpressCommentary = [];
                royaleExpressDescription = data["description"];
                royaleExpressExample = [];

                var tags:Array = data["tags"];
                for (var i:int=0; i < tags.length; i++) {
                	var tag:Object = tags[i];
                	if (tag.tagName == "commentary") {
                		royaleExpressCommentary = tag.values;
                    }
                    else if (tag.tagName == "example") {
                    	royaleExpressExample = tag.values;
                    }
                }

                dispatchEvent(new Event("recordChanged"));

                if (++configIndex < configData.length) {
                	processConfigData();
                }
            }
        }




        private function tagsCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", tagsCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            _knownTags = config.tags;

            app.service.addEventListener("complete", completeHandler);
            app.service.url = "classes.json";
            app.service.send();
        }

        private var masterData:Object;

        private function completeHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeHandler);
            masterData = JSON.parse(app.service.data);
            filterPackageList();
        }

        private function filterPackageList():void
        {
            var packages:Object = {};
            for each (var classData:Object in masterData.classes)
            {
                var packageName:String;
                var qname:String = classData.name;
                var c:int = qname.lastIndexOf(".")
                if (c == -1)
                    packageName = "Top Level";
                else
                {
                    packageName = qname.substr(0, c);
                    qname = qname.substr(c + 1);
                }
                if (packages[packageName] == null)
                {
                    packages[packageName] = {};
                }
                packages[packageName][qname] = classData;
            }
            var arr:Array = [];
            for (var p:String in packages)
            {
                if (filter == null)
                    arr.push(p);
                else if (filterPackage(p))
                    arr.push(p);
            }
            arr.sort();
            _packageList = arr;
            allPackages = packages;
            dispatchEvent(new Event("packageListChanged"));
        }

        private var allPackages:Object;

        private var _packageList:Array;

		[Bindable("packageListChanged")]
		public function get packageList():Array
		{
			return _packageList;
		}

		private var _currentPackage:String;

		[Bindable("currentPackageChanged")]
		public function get currentPackage():String
		{
			return _currentPackage;
		}

		public function set currentPackage(value:String):void
		{
			if (value != _currentPackage)
			{
                _currentPackage = value;
                var packageData:Object = allPackages[value];
                var arr:Array = [];
                for (var p:String in packageData)
                {
                    if (filter == null)
                        arr.push(p);
                    else if (filter(packageData[p]))
                        arr.push(p);
                }
                arr.sort();
                _classList = arr;
				dispatchEvent(new Event("currentPackageChanged"));
			}
		}

        private var _classList:Array;

        [Bindable("currentPackageChanged")]
        public function get classList():Array
        {
            return _classList;
        }

        private var _currentClass:String;

        [Bindable("currentClassChanged")]
        public function get currentClass():String
        {
            return _currentClass;
        }

        public function set currentClass(value:String):void
        {
            if (value != _currentClass)
            {
                _currentClass = value;
                var packageData:Object = allPackages[_currentPackage];
                dispatchEvent(new Event("currentClassChanged"));

                var fileURL:String = computeFileName(_currentPackage + "." + _currentClass);
                app.service.addEventListener("complete", completeClassHandler);
                app.service.url = fileURL;
                app.service.send();
                _currentClassData = null;
            }
        }

        private var _currentClassData:Object;

        private var _baseClassList:Array;

        private var _attributesMap:Object;

        private function completeClassHandlerOLD(event:Event):void
        {
            app.service.removeEventListener("complete", completeClassHandler);
            var data:Object = JSON.parse(app.service.data);
            if (_currentClassData == null)
            {
                _currentClassData = data;
                _publicProperties = [];
                _publicMethods = [];
                _constructorList = [];
                _baseClassList = [];
                _inheritance = null;
                _attributesMap = {};
                _attributes = null;
            }
            else
                _baseClassList.push(data.qname);
            for each (var m:Object in data.members)
            {
                m.shortDescription = makeShortDescription(m.description);
                if (m.type == "method")
                {
                    if (m.qname == _currentPackage + "." + _currentClass)
                    {
                        _constructorList.push(m);
                    }
                    else if (m.qname != data.qname)
                        _publicMethods.push(m);
                }
                else
                {
                    _publicProperties.push(m);
                }

            }
            for each (m in data.tags)
            {
                if (!_attributesMap[m.tagName])
                {
                    _attributesMap[m.tagName] = m.values;
                }
            }

            if (data.type == "class" && data.baseClassname && data.baseClassname.indexOf("flash.") != 0)
            {
                app.service.addEventListener("complete", completeClassHandler);
                app.service.url = computeFileName(data.baseClassname);
                app.service.send();
            }
            else if (data.type == "interface" && data.baseInterfaceNames && data.baseInterfaceNames[0].indexOf("flash.") != 0)
            {
                app.service.addEventListener("complete", completeInterfaceHandler);
                extensions = data.baseInterfaceNames;
                app.service.url = computeFileName(data.baseInterfaceNames[0]);
                app.service.send();

            }
            else
            {
                _publicMethods.sortOn("qname");
                _publicProperties.sortOn("qname");
                dispatchEvent(new Event("currentDataChanged"));
            }
        }

        private function computeFileName(input:String):String
        {
            return input.replace(new RegExp("\\.", "g"), "/") + ".json";
        }

        private function makeShortDescription(input:String):String
        {
            if (!input) return "";
            var c:int = input.indexOf(".");
            if (c == -1) return input;

            return input.substr(0, c + 1);
        }

        private var extensions:Array;

        private function completeInterfaceHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeInterfaceHandler);
            var data:Object = JSON.parse(app.service.data);
            if (_currentClassData == null)
            {
                _currentClassData = data;
                _publicProperties = [];
                _publicMethods = [];
                _constructorList = [];
                _baseClassList = [];
                _inheritance = null;
                _attributesMap = {};
                _attributes = null;
            }
            else
                _baseClassList.push(data.qname);
            for each (var m:Object in data.members)
            {
                m.shortDescription = makeShortDescription(m.description);
                if (m.type == "method")
                {
                    if (m.qname == _currentPackage + "." + _currentClass)
                    {
                        _constructorList.push(m);
                    }
                    else if (m.qname != data.qname)
                        _publicMethods.push(m);
                }
                else
                {
                    _publicProperties.push(m);
                }

            }
            for each (m in data.tags)
            {
                if (!_attributesMap[m.tagName])
                {
                    _attributesMap[m.tagName] = m.values;
                }
            }
            if (data.baseInterfaceNames)
                extensions = extensions.concat(data.baseInterfaceNames);

            while (extensions.length && extensions[0].indexOf("flash.") == 0)
                extensions.shift();

            if (extensions.length)
            {
                app.service.addEventListener("complete", completeInterfaceHandler);
                app.service.url = computeFileName(extensions.shift());
                app.service.send();
            }
            else
            {
                _publicMethods.sortOn("qname");
                _publicProperties.sortOn("qname");
                dispatchEvent(new Event("currentDataChanged"));
            }
        }

        private var _publicProperties:Array;

        [Bindable("currentDataChanged")]
        public function get publicProperties():Array
        {
            return _publicProperties;
        }

        private var _publicMethods:Array;

        [Bindable("currentDataChanged")]
        public function get publicMethods():Array
        {
            return _publicMethods;
        }

        private var _constructorList:Array;

        [Bindable("currentDataChanged")]
        public function get constructorList():Array
        {
            return _constructorList;
        }

        [Bindable("currentDataChanged")]
        public function get description():String
        {
            return _currentClassData.description;
        }

        private var _inheritance:String;

        [Bindable("currentDataChanged")]
        public function get inheritance():String
        {
            if (!_inheritance)
            {
                var s:String = "extends ";
                if (_baseClassList.length == 0)
                    s += "Object";
                else
                {
                    s += _baseClassList.shift();
                    for each (var p:String in _baseClassList)
                    {
                        s += "-> " + p;
                    }
                }
                _inheritance = s;
            }
            return _inheritance;
        }

        private var _attributes:String;

        [Bindable("currentDataChanged")]
        public function get attributes():String
        {
            if (!_attributes)
            {
                var s:String = "";
                for (var p:String in _attributesMap)
                {
                    var o:Array = _attributesMap[p];
                    var k:String = tagNameMap[p];
                    if (k != null)
                        s += k + " ";
                    else
                        s += p + ": ";
                    var firstOne:Boolean = true;
                    for each (var q:String in o)
                    {
                        if (!firstOne)
                            s += ", ";
                        firstOne = false;
                        s += q;
                    }
                    s += "\n";
                }
                _attributes = s;
            }
            return _attributes;
        }

        public function filterPackage(p:String):Boolean
        {
            var packageData:Object = allPackages[p];
            for (var pd:String in packageData)
            {
                if (filter(packageData[pd]))
                    return true;
            }
            return false;
        }

        private var filter:Function;

        private var _filterTags:Array;

        /**
         *  Array of name/value pairs to search for
         */
        public function get filterTags():Array
        {
            return _filterTags;
        }

        public function set filterTags(value:Array):void
        {
            _filterTags = value;
            if (_filterTags)
                filter = filterByTags;
            else
                filter = null;
            filterPackageList();
        }

        public function filterByTags(classData:Object):Boolean
        {
            var tags:Array = classData.tags;
            if (!tags) return false;
            for each (var tag:Object in tags)
            {
                for each (var obj:Object in filterTags)
                {
                    if (obj.name == tag.tagName)
                    {
                        if (tag.values == null || tag.values.length == 0)
                            return true;
                        for each (var v:Object in tag.values)
                        {
                            if (v == obj.value)
                                return true;
                        }
                    }
                }
            }
            return false;
        }
	}
}
