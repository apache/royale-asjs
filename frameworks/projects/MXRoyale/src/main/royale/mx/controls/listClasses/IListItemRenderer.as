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

package mx.controls.listClasses
{
	// import flash.events.IEventDispatcher;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.events.IEventDispatcher;
		
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	import mx.managers.ILayoutManagerClient;
	import mx.styles.ISimpleStyleClient;
	
	/**
	 *  Item renderers and item editors for list components must implement 
	 *  the IListItemRenderer interface.
	 *  The IListItemRenderer interface is a set of several other interfaces. 
	 *  It does not define any new class methods or properties. 
	 *
	 *  <p>The set of interfaces includes the following:
	 *  IDataRenderer, IFlexDisplayObject, ILayoutManagerClient,
	 *  ISimpleStyleClient, IUIComponent.
	 *  The UIComponent class implements all of these interfaces,
	 *  except the IDataRenderer interface. 
	 *  Therefore, if you create a custom item renderer or item editor
	 *  as a subclass  of the UIComponent class, you only have to implement
	 *  the IDataRenderer interface and then you can add to the class
	 *  definition that the class implements IDataRenderer and IListItemRenderer.</p>
	 *
	 *	<p>IListItemRenderers are generally dedicated to displaying a particular
	 *  field from the data provider item and cannot be re-used in other
	 *  DataGrid columns or in other lists with different fields.  If you want
	 *  to create a renderer that can be re-used you can also implement
	 *  IDropInListItemRenderer, and the list will pass more data to
	 *  the renderer that allows the renderer to be re-used with different
	 *  data fields.</p>
	 *
	 *  <p>Item renderers and item editors are passed data from a list class'
	 *  data provider using the IDataRenderer interface.
	 *  Renderers and editors that implement the IDropInListItemRenderer
	 *  interface get other information from the list class.
	 *  The item renderer or item editor uses one or both pieces of information
	 *  to display the data.</p>
	 *
	 *  <p>The renderers and editors are often recycled.
	 *  Once they are created, they may be used again simply by being given
	 *  a new data and optional <code>listData</code> property.
	 *  Therefore in your implementation you must make sure that component
	 *  properties are not assumed to contain their initial, or default values.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public interface IListItemRenderer extends IDataRenderer, IEventDispatcher,
		IFlexDisplayObject,
		//ILayoutManagerClient,
		ISimpleStyleClient, IUIComponent, IIndexedItemRenderer
	{
	}
	
}
