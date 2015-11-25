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
package org.apache.flex.states
{
    import org.apache.flex.core.IDocument;
    
    [ExcludeClass]
    
    /**
     *  The AddItems class is one of the classes in the
     *  view states subsystem.  Note that the FlexJS
     *  versions are simply data structures interpreted
     *  by a central States implementation.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class AddItems implements IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		public function AddItems()
		{
			super();
		}
		
        public var items:Array;
        
		public var itemsDescriptorIndex:int;     

        public var itemsDescriptor:ItemAndDescriptor;     
        
        public var destination:String;
        
        public var propertyName:String;
        
        public var position:String;
        
        public var relativeTo:String;
        
        public var document:Object;
        
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