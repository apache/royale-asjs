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
    import org.apache.royale.core.IState;
    
    /**
     *  The State class is one of the classes in the
     *  view states subsystem.  It is used to declare a 
     *  view state in an MXML document.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class State implements IState
	{
        /**
         *  Constructor.
         *  
         *  @param properties This parameter is not used in Royale and exists to make legacy compilers happy.
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
		public function State(properties:Object = null)
		{
			super();
		}
		
        private var _name:String;
        
        /**
         *  The name of the state.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
        public function get name():String
        {
            return _name;
        }
        public function set name(value:String):void
        {
            _name = value;
        }
        
        
        private var _stateGroups:String;
        
        /**
         *  Comma-delimited list of state groups of the state.
         *  It is not an array so don't use square brackets [].
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
        public function get stateGroups():String
        {
            return _stateGroups;
        }
        public function set stateGroups(value:String):void
        {
            _stateGroups = value;
        }
        
        private var _overrides:Array;
        
        /**
         *  The array of overrides.  This is normally set by the compiler.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
        public function get overrides():Array
        {
            return _overrides;
        }
        public function set overrides(value:Array):void
        {
            _overrides = value;
        }
	}
}
