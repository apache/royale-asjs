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
package org.apache.flex.binding
{	
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IDocument;
    import org.apache.flex.events.ValueChangeEvent;

    /**
     *  The SimpleBinding class is lightweight data-binding class that
     *  is optimized for simple assignments of one object's property to
     *  another object's property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SimpleBinding implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SimpleBinding()
		{
		}
		
        /**
         *  The source object that dispatches an event
         *  when the property changes
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected var source:IEventDispatcher;

        /**
         *  The host mxml document for the source and
         *  destination objects.  The source object
         *  is either this document for simple bindings
         *  like {foo} where foo is a property on
         *  the mxml documnet, or found as document[sourceID]
         *  for simple bindings like {someid.someproperty}
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected var document:Object;

        /**
         *  The destination object.  It is always the same
         *  as the strand.  SimpleBindings are attached to
         *  the strand of the destination object.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var destination:Object;

        /**
         *  If not null, the id of the mxml tag who's property
         *  is being watched for changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var sourceID:String;

        /**
         *  If not null, the name of a property on the
         *  mxml document that is being watched for changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var sourcePropertyName:String;
        
        /**
         *  The event name that is dispatched when the source
         *  property changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var eventName:String;
        
        /**
         *  The name of the property on the strand that
         *  is set when the source property changes.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var destinationPropertyName:String;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			if (destination == null)
                destination = value;
            if (sourceID != null)
            {
    			source = document[sourceID] as IEventDispatcher;
                if (source == null)
                {
                    document.addEventListener("valueChange", 
                        sourceChangeHandler);
                    return;
                }
            }
            else
                source = document as IEventDispatcher;
			source.addEventListener(eventName, changeHandler);
			destination[destinationPropertyName] = source[sourcePropertyName];
		}
		
        /**
         *  @copy org.apache.flex.core.IDocument#setDocument()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
		}
		
		private function changeHandler(event:Event):void
		{
			destination[destinationPropertyName] = source[sourcePropertyName];
		}
        
        private function sourceChangeHandler(event:ValueChangeEvent):void
        {
            if (event.propertyName != sourceID)
                return;
            
            if (source)
                source.removeEventListener(eventName, changeHandler);
            
            source = document[sourceID] as IEventDispatcher;
            if (source)
            {
                source.addEventListener(eventName, changeHandler);
                destination[destinationPropertyName] = source[sourcePropertyName];
            }
        }
	}
}