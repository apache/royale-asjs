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

package mx.core
{
//import mx.managers.IToolTipManagerClient;
import org.apache.royale.events.IEventDispatcher

/**
 *  The INavigatorContent interface defines the interface that a container must 
 *  implement to be used as the child of a navigator container, 
 *  such as the ViewStack, TabNavigator, and Accordion navigator containers.
 *
 *  @see mx.containers.Accordion
 *  @see mx.containers.TabNavigator
 *  @see mx.containers.ViewStack
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface INavigatorContent extends IEventDispatcher // IDeferredContentOwner, IToolTipManagerClient
{
    [Bindable("labelChanged")]
    /**
     *  The text displayed by the navigator container for this container.
     *  For example, the text appears in the button area of an Accordion container
     *  and in the tab area of the TabNavigator container.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get label():String;

    [Bindable("iconChanged")]
    /**
     *  The icon displayed by the navigator container for this container.
     *  The icon appears in the button area of an Accordion container
     *  and in the tab area of the TabNavigator container.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get icon():Class;
}

}