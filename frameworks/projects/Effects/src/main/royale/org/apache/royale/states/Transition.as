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
package org.apache.royale.states
{
	
    [DefaultProperty("effects")]
    
	/**
	 *  The Transition class holds information describing what to do when
     *  changing from one state to another.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Transition
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Transition()
		{
			super();
		}
		
        private var _fromState:String;
        
		/**
		 *  The state or states from which the view is leaving.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
        public function get fromState():String
        {
            return _fromState;
        }
        
        public function set fromState(value:String):void
        {
            _fromState = value;
        }
        
        private var _toState:String;
        
        /**
         *  The state or states to which the view is going.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get toState():String
        {
            return _toState;
        }
        
        public function set toState(value:String):void
        {
            _toState = value;
        }
		
		
        private var _effects:Array;
        
        /**
         *  The list of effects to play
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get effects():Array
        {
            return _effects;
        }
        
        public function set effects(value:Array):void
        {
            _effects = value;
        }
        
	}
}
