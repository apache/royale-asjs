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
package org.apache.royale.binding
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.ValueChangeEvent;
    
    /**
     *  The GenericBinding class is the data-binding class that applies
     *  changes to properties of source objects to a property of the
     *  destination object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class GenericBinding implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function GenericBinding()
		{
		}


        /**
         *  The mxml document for the
         *  binding expression.  If you bind to
         *  {someid.someproperty} then there must
         *  be a tag in the mxml document with
         *  the id "someid".
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected var document:Object;
        
        /**
         *  The object whose property will be
         *  changed by the binding expression.  
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var destination:Object;

        /**
         *  The string or array of strings that describe
         *  the chain of properties to access to get to
         *  the source property's value. 
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var source:Object;
        
        /**
         *  The string or array of strings that describe
         *  the chain of properties to access to assign
         *  the source property's value to the destination
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var destinationData:Object;

        /**
         *  The function used to assign
         *  the source property's value to the destination
         *  if the destination is not a public property
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var destinationFunction:Function;


        /**
         *  Flag used to indicate that the document
         *  value refers to a Class with a static
         *  bindable source
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var isStatic:Boolean;
        public var staticRoot:Object;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			destination = value;
            try 
            {
                var val:Object = getValueFromSource();
                applyValue(val);
            }
            catch (e:Error)
            {
            }
        }
        
        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion Function
         */
        private function getValueFromSource():Object
        {
            if (source is Array)
            {
                var arr:Array = source as Array;
                var n:int = arr.length;
                var obj:Object;
                if (isStatic) {
                    //ignore first element in the array, it is text representation of
                    //staticRoot which here refers to the class
                    obj=staticRoot;
                } else obj = document[arr[0]];

                if (obj == null)
                    return null;
                for (var i:int = 1; i < n; i++)
                {
                    obj = obj[arr[i]];
                    if (obj == null)
                        return null;
                }
                return obj;
            }
            else if (source is Function)
            {
                var fn:Function = source as Function;
                obj = fn.apply(document);
                return obj;
            }
            else if (source is String)
            {
                obj = isStatic ? staticRoot[source] : document[source];
                return obj;
            }
            return null;
		}
        
        private var _listening:Boolean;
        /**
         * @royaleignorecoercion Array
         */
        private function applyValue(value:Object):void
        {
			if (destinationFunction != null)
			{
				destinationFunction.apply(document, [value]);
			}
			else if (destinationData is Array)
            {
                var arr:Array = destinationData as Array;
                var n:int = arr.length;
                var obj:Object = document[arr[0]];
				if (obj == null && arr[0] == 'this')
					obj = document;
                if (obj == null)
                {
                    if (!_listening) {
                        document.addEventListener(ValueChangeEvent.VALUE_CHANGE,
                            destinationChangeHandler);
                        _listening = true;
                    }
                    return;
                }
                for (var i:int = 1; i < n - 1; i++)
                {
                    obj = obj[arr[i]];
                    if (obj == null)
                        return;
                }
                obj[arr[n-1]] = value;                
            } else if (destinationData is String) {
                document[destinationData] = value;
            }
        }
		
        /**
         *  @copy org.apache.royale.core.IDocument#setDocument()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
		}
		
        /**
         *  The method that gets called by the watcher when the value
         *  may have changed.
         *
         *  @param value The new value.
         *  @param getFromSource true if the value parameter should be ignored, and an
         *  attempt should be made to get the value directly from the source object.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function valueChanged(value:Object, getFromSource:Boolean):void
		{
            try 
            {
			
                if (getFromSource) {
					value = getValueFromSource();
				}
                applyValue(value);
            } 
            catch (e:Error)
            {
            }
		}
        
        private function destinationChangeHandler(event:ValueChangeEvent):void
        {
            if (event.propertyName == destinationData[0])
                valueChanged(null, true);
        }
	}
}
