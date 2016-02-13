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
package mx.states
{
    /**
     *  The InterruptionBehavior class defines constants for use with the 
     *  <code>interruptionBehavior</code> property of the mx.states.Transition class.
     * 
     *  @see Transition#interruptionBehavior
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public final class InterruptionBehavior
    {
        /**
         *  Specifies that a transition that interrupts another running
         *  transition ends that other transition before starting.
         *  The transition ends by calling the <code>end()</code> method 
         *  on all effects in the transition.
         *  The <code>end()</code> method causes all effects 
         *  to snap to their end state.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public static const END:String = "end";
        
        /**
         *  Specifies that a transition that interrupts another running
         *  transition stops that other transition in place before starting.
         *  The transition stops by calling the <code>stop()</code> method 
         *  on all effects in the transition.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public static const STOP:String = "stop";
    }
}