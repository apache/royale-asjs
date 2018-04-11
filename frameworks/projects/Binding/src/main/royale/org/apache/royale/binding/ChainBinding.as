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
     *  The ChainBinding class is used to track changes of nested properties.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ChainBinding implements IBead, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ChainBinding()
		{
		}
		
        private var _source:Array;
        
        /**
         *  The source chain of property names
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get source():Array
        {
            return _source;
        }
        
        public function set source(value:Array):void
        {
            _source = value;
        }

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
         *  @productversion Royale 0.0
         */
        protected var document:Object;

        private var _destination:Object;

        /**
         *  The destination property name or chain.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get destination():Object
        {
            return _destination;
        }
        
        public function set destination(value:Object):void
        {
            _destination = value;
        }
        
        /**
         *  The watcher for the component at
         *  document[source[0]]
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var watcherChain:Object;
        // TODO: (aharui) handle watcher chain
        
        private var value:Object;
        
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
            applyBinding();
        }
        
        private function applyBinding():void
        {
            var chainSet:Boolean = evaluateSourceChain();
            if (chainSet)
                applyValue();
        }
        
        private function evaluateSourceChain():Boolean
        {
            var n:int = source.length;
            var obj:Object = document;
            for (var i:int = 0; i < n - 1; i++)
            {
                var propName:String = source[i];
                var propObj:Object = obj[propName];
                var watcher:ChainWatcher = new ChainWatcher(propName, applyBinding);
                obj.addEventListener("valueChange", watcher.handler);
                if (propObj == null)
                    return false;
                obj = propObj;
            }
            propName = source[n - 1];
            function valueChangeHandler(event:ValueChangeEvent):void {
                if (event.propertyName != propName)
                    return;
                value = event.newValue;
                applyValue();
            }
            obj.addEventListener("valueChange", valueChangeHandler);
            
            // we have a complete chain, get the value
            value = obj[propName];
            return true;
        }
        /**
         * @royaleignorecoercion String
         */
        private function applyValue():void
        {
            var destinationName:String;
            if (destination is String)
            {
                destinationName = destination as String;
                document[destinationName] = value;
                return;
            }

            var n:int = destination.length;
            var obj:Object = document;
            for (var i:int = 0; i < n - 1; i++)
            {
                var propName:String = destination[i];
                var propObj:Object = obj[propName];
                function handler(event:ValueChangeEvent):void {
                    if (event.propertyName != propName)
                        return;
                    if (event.oldValue != null)
                        event.oldValue.removeEventListener("valueChange", handler);
                    applyValue();
                }
                if (propObj == null)
                {
                    obj.addEventListener("valueChange", handler);
                    return;
                }
                obj = propObj;
            }
            obj[destination[n - 1]] = value;
            
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
	}
}

import org.apache.royale.events.ValueChangeEvent;

class ChainWatcher
{
    public function ChainWatcher(propertyName:String, callback:Function)
    {
        this.propertyName = propertyName;
        this.callback = callback;
    }

    private var propertyName:String;
    private var callback:Function;
    
    public function handler(event:ValueChangeEvent):void
    {
        if (event.propertyName != propertyName)
            return;
        if (event.oldValue != null)
            event.oldValue.removeEventListener("valueChange", handler);
        callback();               
    }
}
