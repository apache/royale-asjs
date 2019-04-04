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

package spark.components
{ 
	/*
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.IEventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	*/
	
	import org.apache.royale.events.Event;
	
	import spark.components.supportClasses.ButtonBarBase;
	import spark.events.IndexChangeEvent;
	// import spark.events.RendererExistenceEvent;
	
	import mx.collections.IList;
	import mx.core.EventPriority;
	import mx.core.IFactory;
	// import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
	
	use namespace mx_internal;  //ListBase and List share selection properties that are mx_internal
	
	// [IconFile("ButtonBar.png")]
	
	/**
	 *  The ButtonBar control defines a horizontal group of 
	 *  logically related buttons with a common look and navigation.
	 *
	 *  <p>The typical use for a button bar is for grouping
	 *  a set of related buttons together, which gives them a common look
	 *  and navigation, and handling the logic for the <code>change</code> event
	 *  in a single place. </p>
	 *
	 *  <p>The ButtonBar control creates Button controls based on the value of 
	 *  its <code>dataProvider</code> property. 
	 *  Use methods such as <code>addItem()</code> and <code>removeItem()</code> 
	 *  to manipulate the <code>dataProvider</code> property to add and remove data items. 
	 *  The ButtonBar control automatically adds or removes the necessary children based on 
	 *  changes to the <code>dataProvider</code> property.</p>
	 *
	 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
	 *  create an item renderer.
	 *  For information about creating an item renderer, see 
	 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
	 *  Custom Spark item renderers</a>. </p>
	 *
	 *  <p>For non-mobile projects, you can use the ButtonBar control to set the
	 *  active child of a ViewStack container, as the following example shows:</p>
	 *
	 *  <p><b>Note: </b>The Spark list-based controls (the Spark ListBase class and its subclasses
	 *  such as ButtonBar, ComboBox, DropDownList, List, and TabBar) do not support the BasicLayout class
	 *  as the value of the <code>layout</code> property. 
	 *  Do not use BasicLayout with the Spark list-based controls.</p>
	 *
	 *  <pre>
	 *  &lt;s:ButtonBar dataProvider="{myViewStack}" requireSelection="true" /&gt; 
	 *  
	 *  &lt;mx:ViewStack id="myViewStack" 
	 *      borderStyle="solid"&gt; 
	 *  
	 *      &lt;s:NavigatorContent id="search" label="Search"&gt; 
	 *          &lt;s:Label text="Search Screen"/&gt; 
	 *          &lt;/s:NavigatorContent&gt; 
	 *  
	 *      &lt;s:NavigatorContent id="custInfo" label="Customer Info"&gt; 
	 *          &lt;s:Label text="Customer Info"/&gt; 
	 *          &lt;/s:NavigatorContent&gt; 
	 *  
	 *      &lt;s:NavigatorContent id="accountInfo" label="Account Info"&gt; 
	 *          &lt;s:Label text="Account Info"/&gt; 
	 *          &lt;/s:NavigatorContent&gt; 
	 *      &lt;/mx:ViewStack&gt; </pre>
	 *  
	 *  <p>The ButtonBar control has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display all buttons</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>No limit</td></tr>
	 *     <tr><td>Default skin class</td><td>spark.skins.spark.ButtonBarSkin</td></tr>
	 *  </table>
	 *  
	 *  @mxml <p>The <code>&lt;s:ButtonBar&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:ButtonBar
	 *
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.containers.ViewStack
	 *  @see spark.components.ButtonBarButton
	 *  @see spark.skins.spark.ButtonBarSkin
	 *
	 *  @includeExample examples/ButtonBarExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class ButtonBar extends ButtonBarBase // implements IFocusManagerComponent 
	{
		// include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ButtonBar()
		{
			super();
			
			// itemRendererFunction = defaultButtonBarItemRendererFunction;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  firstButton
		//---------------------------------- 
		
		[SkinPart(required="false", type="mx.core.IVisualElement")]
		
		/**
		 * A skin part that defines the first button.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var firstButton:IFactory;
		
		//----------------------------------
		//  lastButton
		//---------------------------------- 
		
		[SkinPart(required="false", type="mx.core.IVisualElement")]
		
		/**
		 * A skin part that defines the last button.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var lastButton:IFactory;
		
		//----------------------------------
		//  middleButton
		//---------------------------------- 
		
		[SkinPart(required="true", type="mx.core.IVisualElement")]
		
		/**
		 * A skin part that defines the middle button(s).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var middleButton:IFactory;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		[Inspectable(category="Data")]
		
		/**
		 *  @private
		 */    
		/*override public function set dataProvider(value:IList):void
		{
			if (dataProvider)
				dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, resetCollectionChangeHandler);
			
			// not really a default handler, we just want it to run after the datagroup
			if (value)
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, resetCollectionChangeHandler, false, EventPriority.DEFAULT_HANDLER, true);
			
			super.dataProvider = value;
		}*/
		
		/**
		 *  @private
		 */
		private function resetCollectionChangeHandler(event:Event):void
		{
			/*if (event is CollectionEvent)
			{
				var ce:CollectionEvent = CollectionEvent(event);
				
				if (ce.kind == CollectionEventKind.ADD || 
					ce.kind == CollectionEventKind.REMOVE)
				{
					// force reset here so first/middle/last skins
					// get reassigned
					if (dataGroup)
					{
						dataGroup.layout.useVirtualLayout = true;
						dataGroup.layout.useVirtualLayout = false;
					}
				}
			}*/
		}
		
		/**
		 *  @private
		 *  button bar always keeps something under the caret so don't let it
		 *  become -1
		 */
		/*override mx_internal function setCurrentCaretIndex(value:Number):void
		{
			if (value == -1)
				return;
			
			super.setCurrentCaretIndex(value);
		}*/
		
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function defaultButtonBarItemRendererFunction(data:Object):IFactory
		{
			/*var i:int = dataProvider.getItemIndex(data);
			if (i == 0)
				return firstButton ? firstButton : middleButton;
			
			var n:int = dataProvider.length - 1;
			if (i == n)
				return lastButton ? lastButton : middleButton;
			*/
			return middleButton;
		}
	}
	
}

