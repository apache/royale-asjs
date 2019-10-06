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
        public static const DELIMITER:String = "/";
        
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
        
        private var _platforms:Array = ["js", "swf"];
        
        public function get platforms():Array
        {
            return _platforms;
        }
        public function set platforms(value:Array):void
        {
            _platforms = value;
        }
        
        private var _knownTags:Array;
        
        [Bindable("packageListChanged")]
        public function get knownTags():Array
        {
            return _knownTags;
        }
        
        private var platformList:Array;
        private var currentPlatform:String;
        
        private function configCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", configCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            tagNameMap = config["tagNames"];
            
            platformList = platforms.slice();
            currentPlatform = platformList.shift();
            var middle:String = "." + currentPlatform;
            app.service.addEventListener("complete", tagsCompleteHandler);
            app.service.url = "tags" + middle + ".json";
            app.service.send();
        }
        
        private function tagsCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", tagsCompleteHandler);
            var config:Object = JSON.parse(app.service.data);
            if (!_knownTags)
                _knownTags = config["tags"];
            else
            {
                var arr:Array = config["tags"];
                var n:int = arr.length;
                for (var i:int = 0; i < n; i++)
                {
                    var tag:String = arr[i];
                    if (_knownTags.indexOf(tag) == -1)
                        _knownTags.push(tag);
                }
            }
            var middle:String;
            if (platformList.length)
            {
                currentPlatform = platformList.shift();
                middle = "." + currentPlatform;
                app.service.addEventListener("complete", tagsCompleteHandler);
                app.service.url = "tags" + middle + ".json";
                app.service.send();                                
            }
            else
            {
                platformList = platforms.slice();
                currentPlatform = platformList.shift();
                middle = "." + currentPlatform;
                app.service.addEventListener("complete", completeHandler);
                app.service.url = "classlist" + middle + ".json";
                app.service.send();                
            }
        }
        
        private var masterData:Object;
        
        public function get allClasses():Array
        {
        	return masterData["classnames"];
        }
        
        /**
         * @royaleignorecoercion ASDocClassData 
         */
        private function completeHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeHandler);
            if (!masterData)
                masterData = { "classnames": [], "data": [] };
            var allNames:Array = allClasses;
            var moreData:Object = JSON.parse(app.service.data);
            var arr:Array = moreData["classnames"];
            var n:int = arr.length;
            var item:ASDocClassData;
            for (var i:int = 0; i < n; i++)
            {
                var cname:String = arr[i];
                var j:int = allNames.indexOf(cname);
                if (j != -1)
                {
                   item = masterData["data"][i] as ASDocClassData;
                   item.platforms.push(currentPlatform);
                }
                else
                {
                    item = new ASDocClassData(cname, currentPlatform);
                    masterData["data"].push(item);
                    masterData["classnames"].push(cname);
                }
            }
            if (platformList.length)
            {
                currentPlatform = platformList.shift();
                var middle:String = "." + currentPlatform;
                app.service.addEventListener("complete", completeHandler);
                app.service.url = "classlist" + middle + ".json";
                app.service.send();
            }
            else
            {
                filterPackageList();
                platformList = platforms.slice();
                currentPlatform = platformList.shift();
                middle = "." + currentPlatform;
                app.service.addEventListener("complete", classesCompleteHandler);
                app.service.url = "classes" + middle + ".json";
                app.service.send();                
            }
        }
        
        /**
         * @royaleignorecoercion ASDocClass 
         */
        private function classesCompleteHandler(event:Event):void
        {
            app.service.removeEventListener("complete", classesCompleteHandler);
            if (!masterData["filterData"])
                masterData["filterData"] = {};
            var allNames:Array = allClasses;
            var moreData:Object = JSON.parse(app.service.data);
            var arr:Array = moreData["classes"];
            var n:int = arr.length;
            var item:ASDocClass;
            for (var i:int = 0; i < n; i++)
            {
                var cname:String = arr[i].name;
                item = masterData["filterData"][cname] as ASDocClass;
                if (item)
                {
                    addTags(item, arr[i]["tags"]);
                }
                else
                {
                    item = new ASDocClass();
                    item.qname = cname;
                    item.description = arr[i]["description"];
                    addTags(item, arr[i]["tags"]);
                    masterData["filterData"][cname] = item;
                }
            }
            if (platformList.length)
            {
                currentPlatform = platformList.shift();
                var middle:String = "." + currentPlatform;
                app.service.addEventListener("complete", classesCompleteHandler);
                app.service.url = "classes" + middle + ".json";
                app.service.send();
            }
        }
        
        private function addTags(item:ASDocClass, tags:Array):void
        {
            var tag:Object;
            if (!tags) return;
            if (!item.tags)
            {
                item.tags = tags;
            }
            else
            {
                for each (tag in tags)
                {
                    var foundit:Boolean = false;
                    for each (var t:Object in item.tags)
                    {
                        if (t["tagName"] == tag["tagName"])
                        {
                            foundit = true;
                            break;
                        }
                    }
                    if (!foundit)
                        item.tags.push(tag);
                }
            }
        }
        
        private function filterPackageList():void
        {
            var packages:Object = {};
            for each (var cdata:ASDocClassData in masterData.data)
            {
                var qname:String = cdata.label;
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
                        arr.push({ label: p, href: value + DELIMITER + p});
                    else if (filter(value == "Top Level" ? p : value + "." + p))
                        arr.push({ label: p, href: value + DELIMITER + p});
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
                platformList = platforms.slice();
                currentPlatform = platformList.shift();
                app.service.addEventListener("complete", completeClassHandler);
                app.service.url = computeFileName(_currentPackage + "." + _currentClass);
                app.service.send();
                _currentClassData = null;
            }
        }
        
        private var _currentClassData:Object;
        
        private var _baseClassList:Array;
        
        private var _attributesMap:Object;
        
        /**
         * @royaleignorecoercion ASDocClass 
         * @royaleignorecoercion ASDocClassMembers
         * @royaleignorecoercion ASDocClassFunction
         */
        private function completeClassHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeClassHandler);
            var data:ASDocClass = app.reviver.parse(app.service.data) as ASDocClass;
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
            // track base classes if primary platform
            // don't list base classes for other platforms
            // because they might be duplicates or different
            // class hierarchy.
            else if (currentPlatform == platforms[0])
                _baseClassList.push(data.qname);
            for each (var m:ASDocClassFunction in data.members)
            {
                if (!m.platforms)
                    m.platforms = [];
                m.platforms.push(currentPlatform);
                m.shortDescription = makeShortDescription(m.description);
                if (m.type == "method")
                {
                    if (m.qname == _currentPackage + "." + _currentClass)
                    {
                        var foundMatch:Boolean = false;
                        var n:int = _constructorList.length;
                        for (var i:int; i < n; i++)
                        {
                            var q:ASDocClassMembers = _constructorList[i] as ASDocClassMembers;
                            var mm:ASDocClassMembers = m as ASDocClassMembers
                            if (q.params.length == mm.params.length)
                            {
                                foundMatch = true;
                                if (q.platforms.indexOf(mm.platforms[0]) == -1)
                                    q.platforms.push(mm.platforms[0]);
                                break;
                            }
                        }
                        if (!foundMatch)
                            _constructorList.push(m);
                    }
                    else if (m.qname != data.qname)
                        addIfNeededAndMakeAttributes(_publicMethods, m);
                }
                else if (m.type == "accessor")
                {
                    var a:ASDocClassAccessor = m as ASDocClassAccessor; // force link class
                    addIfNeededAndMakeAttributes(_publicProperties, a);
                }
                if (masterData["classnames"].indexOf(m.return) != -1)
                {
                    var href:String = m.return;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	m.return = href.substr(c + 1);
                    	href = href.substr(0, c) + DELIMITER + href.substr(c + 1);
                    }
                    m.returnhref = "#!" +href;
                }
                    
            }
            for each (var e:ASDocClassEvents in data.events)
            {
                if (!e.platforms)
                    e.platforms = [];
                e.platforms.push(currentPlatform);
                e.shortDescription = makeShortDescription(e.description);
                addIfNeededAndMakeAttributes(_publicEvents, e);
                if (masterData["classnames"].indexOf(e.type) != -1)
                {
                    href = e.type;
                    c = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	e.type = href.substr(c + 1);
                    	href = href.substr(0, c) + DELIMITER + href.substr(c + 1);
                    }
                    e.typehref = "#!" +href;
                }
            }
            for each (var t:ASDocClassTags in data.tags)
            {
                if (!_attributesMap[t.tagName])
                {
                    _attributesMap[t.tagName] = t.values;
                }
            }

            if (data.type == "class" && data.baseClassname && 
            	data.baseClassname.indexOf("flash.") != 0  && data.baseClassname.indexOf("goog.") != 0)
            {
                app.service.addEventListener("complete", completeClassHandler);
                app.service.url = computeFileName(data.baseClassname);
                app.service.send();
            }
            else if (data.type == "interface" && data.baseInterfaceNames && 
            	data.baseInterfaceNames[0].indexOf("flash.") != 0 && data.baseInterfaceNames[0].indexOf("goog.") != 0)
            {
                app.service.addEventListener("complete", completeInterfaceHandler);
                extensions = data.baseInterfaceNames;
                app.service.url = computeFileName(data.baseInterfaceNames[0]);
                app.service.send();
                
            }
            else
            {
                if (platformList.length)
                {
                    currentPlatform = platformList.shift();
                    app.service.addEventListener("complete", completeClassHandler);
                    app.service.url = computeFileName(_currentPackage + "." + _currentClass);
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
        }
        
        /**
         * @royalesuppresscompleximplicitcoercion true
         */
        private function addIfNeededAndMakeAttributes(arr:Array, data:ASDocClassEvents):void
        {
        	var n:int = arr.length;
        	for (var i:int = 0; i < n; i++)
        	{
        		var obj:ASDocClassEvents = arr[i];
        		if (obj.qname == data.qname)
        		{
                    var platform:String = data.platforms[0];
                    if (obj.platforms.indexOf(platform) == -1)
                        obj.platforms.push(platform);
        			// if no description and the base definition has one
        			// then use base description
        			if (obj.description == "" && data.description != "")
        			{
        			    addAttributes(data, data);
        				arr.splice(i, 1, data);
                        data.ownerhref = currentPackage + DELIMITER + currentClass;
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
        		processParams(data as ASDocClassMembers);
        	}
        	data.ownerhref = currentPackage + DELIMITER + currentClass;
        	arr.push(data);
        }

        /**
         * @royalesuppresscompleximplicitcoercion true
         */
		private function addAttributes(dest:ASDocClassEvents, src:ASDocClassEvents):void
		{
			if (!src.tags) return;
			
			var arr:Array;
        	if (!dest.attributes)
        	{
        	    dest.attributes = [];
        	}
        	arr = dest.attributes;
        	var map:Object = {};
            var attr:ASDocClassAttribute;
        	var tag:ASDocClassTags;
        	var n:int = arr.length;
        	for (var i:int = 0; i < n; i++)
        	{
        		attr = arr[i];
        		map[attr.name] = attr.value;
        	}
        	n = src.tags.length;
            for (i = 0; i < n; i++)
            {
            	tag = src.tags[i];
            	if (map[tag.tagName]) 
            		continue;
            	var obj:ASDocClassAttribute = new ASDocClassAttribute();
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
		
		private function processParams(data:ASDocClassMembers):void
		{
			var n:int = data.params.length;
			for (var i:int = 0; i < n; i++)
			{
				var param:Object = data.params[i];
				if (masterData["classnames"].indexOf(param.type) != -1)
				{
                    var href:String = param.type;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	param.type = href.substr(c + 1);
                    	href = href.substr(0, c) + DELIMITER + href.substr(c + 1);
                    }
                    param.typehref = "#!" +href;
				}
			}
		}
		
        private function computeFileName(input:String):String
        {
            return input.replace(new RegExp("\\.", "g"), "/")  + "." + currentPlatform + ".json";     
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
            var data:ASDocClass = app.reviver.parse(app.service.data) as ASDocClass;
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
            // track base classes if primary platform
            // don't list base classes for other platforms
            // because they might be duplicates or different
            // class hierarchy.
            else if (currentPlatform == platforms[0])
                _baseClassList.push(data.qname);
            for each (var m:ASDocClassMembers in data.members)
            {
                if (!m.platforms)
                    m.platforms = [];
                m.platforms.push(currentPlatform);
                m.shortDescription = makeShortDescription(m.description);
                if (m.type == "method")
                {
                    if (m.qname == _currentPackage + "." + _currentClass)
                    {
                        var foundMatch:Boolean = false;
                        var n:int = _constructorList.length;
                        for (var i:int; i < n; i++)
                        {
                            var q:ASDocClassMembers = _constructorList[i] as ASDocClassMembers;
                            if (q.params.length == m.params.length)
                            {
                                foundMatch = true;
                                if (q.platforms.indexOf(m.platforms[0]) == -1)
                                    q.platforms.push(m.platforms[0]);
                                break;
                            }
                        }
                        if (!foundMatch)
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
            for each (var e:ASDocClassEvents in data.events)
            {
                if (!e.platforms)
                    e.platforms = [];
                e.platforms.push(currentPlatform);
                e.shortDescription = makeShortDescription(e.description);
                addIfNeededAndMakeAttributes(_publicEvents, e);
                if (masterData["classnames"].indexOf(e.type) != -1)
                {
                    var href:String = e.type;
                    var c:int = href.lastIndexOf(".");
                    if (c != -1)
                    {
                    	e.type = href.substr(c + 1);
                    	href = href.substr(0, c) + DELIMITER + href.substr(c + 1);
                    }
                    e.typehref = "#!" +href;
                }
            }
            for each (var t:ASDocClassTags in data.tags)
            {
                if (!_attributesMap[t.tagName])
                {
                    _attributesMap[t.tagName] = t.values;
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
                if (platformList.length)
                {
                    currentPlatform = platformList.shift();
                    app.service.addEventListener("complete", completeInterfaceHandler);
                    app.service.url = computeFileName(_currentPackage + "." + _currentClass);
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
                        if (masterData["classnames"].indexOf(p) != -1)
                        {
                        	c = p.lastIndexOf(".");
                        	if (c != -1)
                        	{
                        		p = p.substr(0, c) + DELIMITER + p.substr(c + 1);
                        	}
                        	else
                        	{
                        		p = DELIMITER + p;
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
                    if (p == "commentary")
                    	joiner = "  ";
                    if (p == "example")
                    {
                        joiner = "<br/>";
                        firstOne = false;
                    }
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
                if (filter(p == "Top Level" ? pd : p + "." + pd))
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

        /**
         * @royalesuppresscompleximplicitcoercion true
         */
        public function filterByTags(className:String):Boolean
        {
            var classData:ASDocClass = masterData["filterData"][className];
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

