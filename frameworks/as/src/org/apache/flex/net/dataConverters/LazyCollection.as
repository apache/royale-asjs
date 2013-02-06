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
package org.apache.flex.net.dataConverters
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.data.ICollection;
    import org.apache.flex.net.IInputParser;
    import org.apache.flex.net.IItemConverter;
    
	public class LazyCollection extends EventDispatcher implements IBead, ICollection
	{
		public function LazyCollection()
		{
			super();
		}
		
		private var _inputParser:IInputParser;
		public function get inputParser():IInputParser
		{
			return _inputParser;
		}
		public function set inputParser(value:IInputParser):void
		{
			if (_inputParser != value)
			{
                _inputParser = value;
				dispatchEvent(new Event("inputParserChanged"));
			}
		}
		
        private var _itemConverter:IItemConverter;
        public function get itemConverter():IItemConverter
        {
            return _itemConverter;
        }
        public function set itemConverter(value:IItemConverter):void
        {
            if (_itemConverter != value)
            {
                _itemConverter = value;
                dispatchEvent(new Event("itemConverterChanged"));
            }
        }

        private var _id:String;
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}
		
        private var _strand:IStrand;
        
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener(Event.COMPLETE, completeHandler);
        }
        
        private var rawData:Array;
        private var data:Array;
        
        private function completeHandler(event:Event):void
        {
            rawData = inputParser.parseItems(_strand["data"]);  
            data = new Array(rawData.length);
        }
        
        public function getItemAt(index:int):Object
        {
            if (data[index] == undefined)
            {
                data[index] = itemConverter.convertItem(rawData[index]);
            }
            return data[index];
        }   
	}
}