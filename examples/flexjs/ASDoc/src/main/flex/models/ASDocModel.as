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
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
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
            app.service.addEventListener("complete", completeHandler);
            app.service.url = "classes.json";
            app.service.send();
        }
        
        private var masterData:Object;
        
        private function completeHandler(event:Event):void
        {
            app.service.removeEventListener("complete", completeHandler);
            masterData = JSON.parse(app.service.data);
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
	}
}