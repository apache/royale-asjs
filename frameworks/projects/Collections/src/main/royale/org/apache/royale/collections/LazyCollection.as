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
package org.apache.royale.collections
{
    COMPILE::SWF
    {
        import flash.events.Event;            
    }
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.collections.parsers.IInputParser;
    import org.apache.royale.collections.converters.IItemConverter;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the collection has processed a complete event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="complete", type="org.apache.royale.events.Event")]
    
    /**
     *  The LazyCollection class implements a collection
     *  whose items require conversion from a source data format
     *  to some other data type.  For example, converting
     *  SOAP or JSON to ActionScript data classes.
     *  The Flex SDK used to convert all of the data items
     *  when the source data arrived, which, for very large data sets
     *  or complex data classes, could lock up the user interface.
     *  The lazy collection converts items as they are fetched from
     *  the collection, resulting in significant performance savings
     *  in many cases.  Note that, if you need to compute a summary of
     *  data in the collection when the source data arrives, the
     *  computation can still lock up the user interface as you will
     *  have to visit and convert every data item.  Of course, it is
     *  possible to compute that summary in a worker or pseudo-thread.
     *  The LazyCollection class is designed to be a bead that attaches
     *  to a data retrieval strand that dispatches an Event.COMPLETE and
     *  has a "data" property that gets passed to the input parser.
     * 
     *  This LazyCollection does not support adding/removing items from
     *  the collection or sending data back to the source.  Subclasses
     *  have that additional functionality.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class LazyCollection extends EventDispatcher implements IBead, ICollection
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function LazyCollection()
		{
			super();
		}
		
		private var _inputParser:IInputParser;

        /**
         *  A lazy collection uses an IInputParser to convert the source data items
         *  into an array of data items.  This is required in order to determine
         *  the length of the collection.  This conversion happens as the source
         *  data arrives so it needs to be fast to avoid locking up the UI.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get inputParser():IInputParser
		{
			return _inputParser;
		}
        
        /**
         *  @private
         */
		public function set inputParser(value:IInputParser):void
		{
			if (_inputParser != value)
			{
                _inputParser = value;
				dispatchEvent(new org.apache.royale.events.Event("inputParserChanged"));
			}
		}
		
        private var _itemConverter:IItemConverter;

        /**
         *  A lazy collection uses an IItemConverter to convert the source data items
         *  into the desired data type.  The converter is only called as items
         *  are fetched from the collection.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get itemConverter():IItemConverter
        {
            return _itemConverter;
        }

        /**
         *  @private
         */
        public function set itemConverter(value:IItemConverter):void
        {
            if (_itemConverter != value)
            {
                _itemConverter = value;
                dispatchEvent(new org.apache.royale.events.Event("itemConverterChanged"));
            }
        }

        private var _id:String;
        
        /**
         *  @copy org.apache.royale.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get id():String
		{
			return _id;
		}

        /**
         *  @private
         */
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new org.apache.royale.events.Event("idChanged"));
			}
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            COMPILE::SWF
            {
                IEventDispatcher(_strand).addEventListener(flash.events.Event.COMPLETE, completeHandler);                    
            }
            COMPILE::JS
            {
                IEventDispatcher(_strand).addEventListener("complete", completeHandler);                    
            }
        }
        
        /**
         *  The array of raw data needing conversion.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var rawData:Array;

        /**
         *  The array of desired data types. This array is sparse and
         *  unconverted items are therefore undefined in the array.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var data:Array;
        
        COMPILE::SWF
        private function completeHandler(event:flash.events.Event):void
        {
            rawData = inputParser.parseItems(_strand["data"]);  
            data = new Array(rawData.length);
            dispatchEvent(event);
        }
        COMPILE::JS
        private function completeHandler(event:org.apache.royale.events.Event):void
        {
            rawData = inputParser.parseItems(_strand["data"]);  
            data = new Array(rawData.length);
            dispatchEvent(event);
        }
        
        /**
         *  Fetches an item from the collection, converting it first if necessary.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getItemAt(index:int):Object
        {
            if (data[index] == undefined)
            {
                data[index] = itemConverter.convertItem(rawData[index]);
            }
            return data[index];
        }   
        
        /**
         *  The number of items.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get length():int
        {
            return rawData ? rawData.length : 0;   
        }

	}
}
