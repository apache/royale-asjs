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
package mx.states
{
    /**
     *  The State class is one of the classes in the
     *  view states subsystem.  It is used to declare a 
     *  view state in an MXML document.  This is one of the
     *  few classes in FlexJS that use the same name as
     *  a Flex SDK class because some of the IDEs and
     *  compilers are hard-coded to assume this name.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class State
	{
        /**
         *  Constructor.
         *  
         *  @param properties This parameter is not used in FlexJS and exists to make legacy compilers happy.
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		public function State(properties:Object = null)
		{
			super();
		}
		
        /**
         *  The name of the state.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		public var name:String;
        
        /**
         *  The array of overrides.  This is normally set by the compiler.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public var overrides:Array;
	}
}