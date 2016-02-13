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

/**
 *  The IInvalidating interface defines the interface for components
 *  that use invalidation to do delayed -- rather than immediate --
 *  property commitment, measurement, drawing, and layout.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IInvalidating
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Calling this method results in a call to the component's
	 *  <code>validateProperties()</code> method
	 *  before the display list is rendered.
	 *
	 *  <p>For components that extend UIComponent, this implies
	 *  that <code>commitProperties()</code> is called.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function invalidateProperties():void;

	/**
	 *  Calling this method results in a call to the component's
	 *  <code>validateSize()</code> method
	 *  before the display list is rendered.
	 *
	 *  <p>For components that extend UIComponent, this implies
	 *  that <code>measure()</code> is called, unless the component
	 *  has both <code>explicitWidth</code> and <code>explicitHeight</code>
	 *  set.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function invalidateSize():void;

	/**
	 *  Calling this method results in a call to the component's
	 *  <code>validateDisplayList()</code> method
	 *  before the display list is rendered.
	 *
	 *  <p>For components that extend UIComponent, this implies
	 *  that <code>updateDisplayList()</code> is called.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function invalidateDisplayList():void;

    /**
     *  Validates and updates the properties and layout of this object
     *  by immediately calling <code>validateProperties()</code>,
	 *  <code>validateSize()</code>, and <code>validateDisplayList()</code>,
	 *  if necessary.
     *
     *  <p>When properties are changed, the new values do not usually have
	 *  an immediate effect on the component.
	 *  Usually, all of the application code that needs to be run
	 *  at that time is executed. Then the LayoutManager starts
	 *  calling the <code>validateProperties()</code>,
	 *  <code>validateSize()</code>, and <code>validateDisplayList()</code>
	 *  methods on components, based on their need to be validated and their 
	 *  depth in the hierarchy of display list objects.</p>
	 *
     *  <p>For example, setting the <code>width</code> property is delayed, because
	 *  it may require recalculating the widths of the object's children
	 *  or its parent.
     *  Delaying the processing also prevents it from being repeated
     *  multiple times if the application code sets the <code>width</code> property
	 *  more than once.
     *  This method lets you manually override this behavior.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateNow():void;
}

}
