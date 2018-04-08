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

// shim the mx classes for states.  Be careful about updates to the main SDK's
// version as that will move the timestamp ahead of this one and then it will
// take precedence over this one at link time.
package org.apache.royale.states
{
    import org.apache.royale.core.IDocument;
    
    [ExcludeClass]
    
    /**
     *  The AddItems class is one of the classes in the
     *  view states subsystem.  Note that the Royale
     *  versions are simply data structures interpreted
     *  by a central States implementation.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AddItems implements IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
		public function AddItems()
		{
			super();
		}
		
        private var _items:Array;
        
        public function get items():Array
        {
            return _items;
        }
        public function set items(value:Array):void
        {
            _items = value;
        }
        
		private var _itemsDescriptorIndex:int;     
        
        public function get itemsDescriptorIndex():int
        {
            return _itemsDescriptorIndex;
        }
        public function set itemsDescriptorIndex(value:int):void
        {
            _itemsDescriptorIndex = value;
        }

        private var _itemsDescriptor:ItemAndDescriptor;  
        
        public function get itemsDescriptor():ItemAndDescriptor
        {
            return _itemsDescriptor;
        }
        
        public function set itemsDescriptor(value:ItemAndDescriptor):void
        {
            _itemsDescriptor = value;
        }
        
        private var _destination:String;
        
        public function get destination():String
        {
            return _destination;
        }
        public function set destination(value:String):void
        {
            _destination = value;
        }
        
        private var _propertyName:String;

        public function get propertyName():String
        {
            return _propertyName;
        }
        public function set propertyName(value:String):void
        {
            _propertyName = value;
        }

        private var _position:String;
        
        public function get position():String
        {
            return _position;
        }
        public function set position(value:String):void
        {
            _position = value;
        }
        
        private var _relativeTo:String;
        
        public function get relativeTo():String
        {
            return _relativeTo;
        }
        public function set relativeTo(value:String):void
        {
            _relativeTo = value;
        }
        
        private var _document:Object;
        
        public function get document():Object
        {
            return _document;
        }
        public function set document(value:Object):void
        {
            _document = value;
        }
        
        /**
         * @see org.apache.royale.core.IDocument#setDocument
         * @royaleignorecoercion Array
         * @royaleignorecoercion org.apache.royale.states.ItemAndDescriptor
         */
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
            var data:Object = document.mxmlsd[itemsDescriptorIndex];
            if (data is Array)
            {
                itemsDescriptor = new ItemAndDescriptor();
                itemsDescriptor.descriptor = data as Array;
                // replace the entry in the document so subsequent
                // addItems know it is shared
                document.mxmlsd[itemsDescriptorIndex] = itemsDescriptor;
            }
            else
                itemsDescriptor = data as ItemAndDescriptor;
        }
        
        /**
         * @private 
         * Initialize this object from a descriptor.
         */
        public function initializeFromObject(properties:Object):Object
        {
            for (var p:String in properties)
            {
                this[p] = properties[p];
            }
            
            return Object(this);
        }
	}
}
