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
	
	public class ASDocModel extends EventDispatcher implements IBeadModel
	{
		public function ASDocModel()
		{
		}
		
        private var app:ASDoc;
        
        public function set strand(value:IStrand):void
        {
            app = value as ASDoc;
            app.addEventListener("initialize", initializeHandler);
            
        }
        
        private function initializeHandler(event:Event):void
        {
            app.service.addEventListener("complete", configCompleteHandler);
            app.service.url = "config.json";
            app.service.send();
        }
        
        private var tagNameMap:Object;
        
        private var _knownTags:Array;
        
        [Bindable("packageListChanged")]
        public function get knownTags():Array
        {
            return _knownTags;
        }
        
        private function configCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", configCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            tagNameMap = config.tagNames;
            
            app.service.addEventListener("complete", tagsCompleteHandler);
            app.service.url = "tags.json";
            app.service.send();
        }
        
        private function tagsCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", tagsCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            _knownTags = config.tags;
            
            app.service.addEventListener("complete", completeHandler);
            app.service.url = "classlist.json";
            app.service.send();
        }
        
        private var masterData:Object;
        
        public function get allClasses():Array
        {
        	return masterData.classnames;
        }
        
        private function completeHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeHandler);
            masterData = JSON.parse(app.service.data);
            filterPackageList();
        }
        
        private function filterPackageList():void
        {
            var packages:Object = {};
            for each (var qname:String in masterData.classnames)
            {
                var packageName:String;
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
                packages[packageName][qname] = {};
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
                        arr.push({ label: p, href: value + "/" + p});
                    else if (filter(packageData[p]))
                        arr.push({ label: p, href: value + "/" + p});
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
                app.service.addEventListener("complete", completeClassHandler);
                app.service.url = computeFileName(_currentPackage + "." + _currentClass);
                app.service.send();
                _currentClassData = null;
            }
        }
        
        private var _currentClassData:Object;
        
        private var _baseClassList:Array;
        
        private var _attributesMap:Object;
        
        private function completeClassHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeClassHandler);
            var data:Object = JSON.parse(app.service.data);
            if (_currentClassData == null)
            {
                _currentClassData = data;
                _publicProperties = [];
                _publicMethods = [];
                _publicEvents = [];
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
                        addIfNeededAndMakeAttributes(_publicMethods, m);
                }
                else
                {
                    addIfNeededAndMakeAttributes(_publicProperties, m);
                }
                if (masterData.classnames.indexOf(m.return) != -1)
                {
                    var href:String = m.return;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	m.return = href.substr(c + 1);
                    	href = href.substr(0, c) + "/" + href.substr(c + 1);
                    }
                    m.returnhref = "#!" +href;
                }
                    
            }
            for each (m in data.events)
            {
                m.shortDescription = makeShortDescription(m.description);
                addIfNeededAndMakeAttributes(_publicEvents, m);
                if (masterData.classnames.indexOf(m.type) != -1)
                {
                    href = m.type;
                    c = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	m.type = href.substr(c + 1);
                    	href = href.substr(0, c) + "/" + href.substr(c + 1);
                    }
                    m.typehref = "#!" +href;
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
                _publicEvents.sortOn("qname");
                _publicProperties.sortOn("qname");
                dispatchEvent(new Event("currentDataChanged"));
            }
        }
        
        private function addIfNeededAndMakeAttributes(arr:Array, data:Object):void
        {
        	var n:int = arr.length;
        	for (var i:int = 0; i < n; i++)
        	{
        		var obj:Object = arr[i];
        		if (obj.qname == data.qname)
        		{
        			// if no description and the base definition has one
        			// then use base description
        			if (obj.description == "" && data.description != "")
        			{
        			    addAttributes(data, data);
        				arr.splice(i, 1, data);
        			}
        			else
        			{
        				addAttributes(obj, data);
        			}
        			return;
        		}
        	}
        	addAttributes(data, data);
        	if (data.type == "method")
        	{
        		processParams(data);
        	}
        	data.ownerhref = currentPackage + "/" + currentClass;
        	arr.push(data);
        }

		private function addAttributes(dest:Object, src:Object):void
		{
			if (!src.tags) return;
			
			var arr:Array;
        	if (!dest.attributes)
        	{
        	    dest.attributes = [];
        	}
        	arr = dest.attributes;
        	var map:Object = {};
        	var tag:Object;
        	var n:int = arr.length;
        	for (var i:int = 0; i < n; i++)
        	{
        		tag = arr[i];
        		map[tag.name] = tag.value;
        	}
        	n = src.tags.length;
            for (i = 0; i < n; i++)
            {
            	tag = src.tags[i];
            	if (map[tag.tagName]) 
            		continue;
            	var obj:Object = {};
                var k:String = tagNameMap[tag.tagName];
                if (k != null)
                    obj.name = k;
                else
                    obj.name = tag.tagName;
                var s:String = "";
                var firstOne:Boolean = true;
                var o:Array = tag.values;
                for each (var q:String in o)
                {
                    if (!firstOne)
                        s += ", ";
                    firstOne = false;
                    s += q;
                }
                if (map[obj.name])
                {
                	map[obj.name].value += "," + s;
                }
                else
                {
	                obj.value = s;
                    arr.push(obj);
                }
            }
		}
		
		private function processParams(data:Object):void
		{
			var n:int = data.params.length;
			for (var i:int = 0; i < n; i++)
			{
				var param:Object = data.params[i];
				if (masterData.classnames.indexOf(param.type) != -1)
				{
                    var href:String = param.type;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	param.type = href.substr(c + 1);
                    	href = href.substr(0, c) + "/" + href.substr(c + 1);
                    }
                    param.typehref = "#!" +href;
				}
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
                _publicEvents = [];
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
                        addIfNeededAndMakeAttributes(_publicMethods, m);
                }
                else
                {
                    addIfNeededAndMakeAttributes(_publicProperties, m);
                }
                
            }
            for each (m in data.events)
            {
                m.shortDescription = makeShortDescription(m.description);
                addIfNeededAndMakeAttributes(_publicEvents, m);
                if (masterData.classnames.indexOf(m.type) != -1)
                {
                    var href:String = m.type;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	m.type = href.substr(c + 1);
                    	href = href.substr(0, c) + "/" + href.substr(c + 1);
                    }
                    m.typehref = "#!" +href;
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
                _publicEvents.sortOn("qname");
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
        
        private var _publicEvents:Array;
        
        [Bindable("currentDataChanged")]
        public function get publicEvents():Array
        {
            return _publicEvents;
        }
        
        [Bindable("currentDataChanged")]
        public function get description():String
        {
            return _currentClassData.description;
        }
        
        private var _inheritance:Array;
        
        [Bindable("currentDataChanged")]
        public function get inheritance():Array
        {
            if (!_inheritance)
            {
                var s:Array;
                if (_baseClassList.length == 0)
                    s = [{label: currentClass}, { label: "Object"}];
                else
                {
                    s = [{label: currentClass}];
                    for each (var p:String in _baseClassList)
                    {
                    	var end:String = p;
                    	var c:int = end.lastIndexOf(".");
                    	if (c != -1)
                    		end = end.substr(c + 1);
                        var data:Object = {label: end };
                        if (masterData.classnames.indexOf(p) != -1)
                        {
                        	c = p.lastIndexOf(".");
                        	if (c != -1)
                        	{
                        		p = p.substr(0, c) + "/" + p.substr(c + 1);
                        	}
                        	else
                        	{
                        		p = "/"+ p;
                        	}
                        	data.href = p;
                        }
                        s.push(data);
                    }
                }
                _inheritance = s;
            }
            return _inheritance;
        }
       
        private var _attributes:Array;
        
        [Bindable("currentDataChanged")]
        public function get attributes():Array
        {
            if (!_attributes)
            {
            	_attributes = [];
                for (var p:String in _attributesMap)
                {
                    var obj:Object = {};
                    var o:Array = _attributesMap[p];
                    var k:String = tagNameMap[p];
                    if (k != null)
                        obj.name = k;
                    else
                        obj.name = p;
                    var s:String = "";
                    var firstOne:Boolean = true;
                    var joiner:String = ", ";
                    if (obj.name == "commentary")
                    	joiner = "  ";
                    if (obj.name == "example")
                        joiner = "<br/>";
                    for each (var q:String in o)
                    {
                        if (!firstOne)
                            s += joiner;
                        firstOne = false;
                        s += q;
                    }
                    obj.value = s;
                    _attributes.push(obj);
                }
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
