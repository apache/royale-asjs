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
// shim the mx classes for states
package org.apache.royale.states
{
    import org.apache.royale.core.IDocument;
    
    [ExcludeClass]
    
    /**
     *  The SetEventHandler class is one of the classes in the
     *  view states subsystem.  Note that the Royale
     *  versions are simply data structures interpreted
     *  by a central States implementation.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SetEventHandler implements IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
		public function SetEventHandler()
		{
			super();
		}
		
        private var _target:String;
        
        public function get target():String
        {
            return _target;
        }
        public function set target(value:String):void
        {
            _target = value;
        }
        
        private var _name:String;
        
        public function get name():String
        {
            return _name;
        }
        public function set name(value:String):void
        {
            _name = value;
        }
        
        private var _handlerFunction:Function;
        
        public function get handlerFunction():Function
        {
            return _handlerFunction;
        }
        public function set handlerFunction(value:Function):void
        {
            _handlerFunction = value;
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
        
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
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
