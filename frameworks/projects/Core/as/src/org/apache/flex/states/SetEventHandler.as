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
package org.apache.flex.states
{
    import org.apache.flex.core.IDocument;
    
    [ExcludeClass]
    
    /**
     *  The SetEventHandler class is one of the classes in the
     *  view states subsystem.  Note that the FlexJS
     *  versions are simply data structures interpreted
     *  by a central States implementation.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::AS3
	public class SetEventHandler implements IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		public function SetEventHandler()
		{
			super();
		}
		
        public var target:String;
        
        public var name:String;
        
        public var handlerFunction:Function;

        public var document:Object;
        
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
