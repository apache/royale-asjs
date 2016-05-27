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
package org.apache.flex.core
{
    import org.apache.flex.events.IEventDispatcher;

    /**
     *  The IUIBase interface is the basic interface for user interface components.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public interface IUIBase extends IStrand, IEventDispatcher, IVisualElement
	{
        /**
         *  Each IUIBase has an element that is actually added to
         *  the platform's display list DOM.  It may not be the actual
         *  component itself.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::AS3
        function get element():IFlexJSElement;
        
        /**
         *  Each IUIBase has an element that is actually added to
         *  the platform's display list DOM.  It may not be the actual
         *  component itself.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::JS
        function get element():WrappedHTMLElement;
        
        /**
         *  Each IUIBase has an element that is actually added to
         *  the platform's display list DOM.  It may not be the actual
         *  component itself.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::JS
        function get positioner():WrappedHTMLElement;
        
        /**
         *  Called by parent components when the component is
         *  added via a call to addElement or addElementAt.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		function addedToParent():void;
		
        /**
         *  The top most event dispatcher.  Good for trying to capture
         *  all input events.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        function get topMostEventDispatcher():IEventDispatcher;
    }
}
