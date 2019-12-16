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
	/*import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;*/
	
	import org.apache.royale.events.Event;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	/**
	 *  Because this component does not define a skin for the mobile theme, Adobe
	 *  recommends that you not use it in a mobile application. Alternatively, you
	 *  can define your own mobile skin for the component. For more information,
	 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
	 */
	[DiscouragedForProfile("mobileDevice")]
	
	// [IconFile("Form.png")]
	
	/**
	 *  The Spark Form container lets you control the layout of a form,
	 *  mark form fields as required or optional, handle error messages,
	 *  and bind your form data to the Flex data model to perform
	 *  data checking and validation.
	 *  It also lets you use style sheets to configure the appearance
	 *  of your forms.
	 *
	 *  <p>The following table describes the components you use to create forms in Flex:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Component</th>
	 *           <th>Tag</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Form</td>
	 *           <td><code>&lt;s:Form&gt;</code></td>
	 *           <td>Defines the container for the entire form, including the overall form layout. 
	 *               Use the FormHeading control and FormItem control to define content. 
	 *               You can also insert other types of components in a Form container.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>FormHeading</td>
	 *           <td><code>&lt;s:FormHeading&gt;</code></td>
	 *           <td>Defines a heading within your form. </td>
	 *        </tr>
	 *        <tr>
	 *           <td>FormItem</td>
	 *           <td><code>&lt;s:FormItem&gt;</code></td>
	 *           <td>Contains one or more form children arranged horizontally or vertically. Children can be controls or other containers. 
	 *               A single Form container can hold multiple FormItem containers.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>FormLayout</td>
	 *           <td><code>&lt;s:FormLayout&gt;</code></td>
	 *           <td>Defines the default layout for Spark Form skins.</td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:Form&gt;</code> tag inherits all the tag 
	 *  attributes of its superclass and adds no new tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:Form&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/s:Form&gt;
	 *  </pre>
	 * 
	 *  @includeExample examples/FormExample.mxml
	 *  @includeExample examples/StackedFormSkinExample.mxml
	 *
	 *  @see spark.components.FormHeading
	 *  @see spark.components.FormItem
	 *  @see spark.layouts.FormLayout
	 *  @see spark.skins.spark.FormSkin
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5 
	 */
	public class Form extends SkinnableContainer
	{
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function Form()
		{
			super();
            typeNames += " Form";
            
			// addEventListener(FlexEvent.VALID, validHandler, true);
			// addEventListener(FlexEvent.INVALID, invalidHandler, true);
			
			// Set these here instead of in the CSS type selector for Form
			// We want to hide the fact that the Form itself doesn't show
			// the error skin or error tip, but that its children do. 
			setStyle("showErrorSkin", false);
			setStyle("showErrorTip", false);
		}
		
		private var errorStateChanged:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
        /**
         *  @royalesuppresspublicvarwarning
         */
		mx_internal var _invalidElements:Array = [];
		
		/**
		 *  A sorted Array of descendant elements that are in an invalid state.
		 *  The items in the array are Objects with the following properties:
		 * 
		 *  <ul>
		 *    <li>element:UIComponent - the invalid descendant element</li>
		 * 
		 *    <li>position:Vector.&lt;int&gt; - a Vector of integers representing the position
		 *     of the element in the display list tree. 
		 *     This property is used for sorting the Array.</li>  
		 *  </ul>
		 * 
		 *  <p>If a descendant is removed from the Form, the dictionary is not updated.</p> 
		 *     
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get invalidElements():Array
		{
			return _invalidElements;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  If an element is invalid, then we listen for changes to the errorString
		 */
		private function errorStringChangedHandler(event:Event):void
		{
			var uicElt:UIComponent = event.target as UIComponent;
			
			// If errorString == "", then remove the target from the invalidElement dictionary
			if (uicElt && uicElt.errorString == "")
			{
				var elementIndex:int = findInvalidElementIndex(uicElt);
				if (elementIndex != -1)
					_invalidElements.splice(elementIndex, 1);
				
				uicElt.removeEventListener("errorStringChanged", errorStringChangedHandler);
				
				errorStateChanged = true;
				invalidateSkinState();
			}
		}
		
		/**
		 *  @private
		 *  If one of our descendants has just passed validation, then
		 *  remove it from the invalidElements dictionary
		 */
		private function validHandler(event:FlexEvent):void
		{
			if (event.isDefaultPrevented())
				return;
			
			var targ:UIComponent = event.target as UIComponent;
			
			if (targ)
			{            
				var elementIndex:int = findInvalidElementIndex(targ);
				if (elementIndex != -1)
					_invalidElements.splice(elementIndex, 1);
				
				targ.removeEventListener("errorStringChanged", errorStringChangedHandler);
			}    
			
			errorStateChanged = true;
			invalidateSkinState();
		}
		
		/**
		 *  @private
		 *  If one of our descendants has just failed validation, then
		 *  add it to the invalidElements dictionary
		 */
		private function invalidHandler(event:FlexEvent):void
		{/*
			if (event.isDefaultPrevented())
				return;
			
			var targ:UIComponent = event.target as UIComponent;
			
			if (targ)
			{         
				if (findInvalidElementIndex(targ) == -1)   
				{
					// Insert a new element into the array and re-sort
					var position:Vector.<int> = getElementNestedPosition(targ, contentGroup);
					var item:Object = {element:targ, position: position};
					
					_invalidElements.push(item);
					_invalidElements.sort(compareNestedPosition);
					
					// Listen for errorString == ""
					targ.addEventListener("errorStringChanged", errorStringChangedHandler);
				}
			}
			
			errorStateChanged = true;
			invalidateSkinState();
		*/}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			var result:String = super.getCurrentSkinState();
			var key:Object;
			
			if (errorStateChanged)
			{
				errorStateChanged = false;
				var isEmpty:Boolean = true;
				var errMsg:String = "";
				
				for (var i:int = 0; i < invalidElements.length; i++)
				{
					isEmpty = false;
					if (errMsg != "")
					{
						errMsg += "\n";
					}
					
					errMsg += UIComponent(invalidElements[i].element).errorString; 
				}
				
				// disabled state takes precedence over error state
				if (!isEmpty && enabled)
					result = "error";
				
				// Either set this to the concatenated string or empty string
				errorString = errMsg;
			}
			else if (enabled && invalidElements.length > 0)
			{
				result = "error";
			}
			
			return result;
		}
		
		/**
		 *  @private
		 *  Used to sort the element positions calculated using getElementNestedPosition. 
		 *  
		 *  @param item1 first element to compare
		 *  @param item2 second element to compare
		 *  @return -1 if item1 is less than item2, 0 if they are equal, 
		 *  1 if item1 is greater than item2 
		 */
		private function compareNestedPosition(item1:Object, item2:Object):int
		{
			var item1Pos:Vector.<int> = item1.position;
			var item2Pos:Vector.<int> = item2.position;
			
			var item1Depth:int = item1Pos.length;
			var item2Depth:int = item2Pos.length;
			
			var minDepth:int = Math.min(item1Depth, item2Depth);
			
			var currentDepth:int = 0;
			
			// Iterate through the elements of the position Vectors
			// Each element in the Vectors represents a level in the display list tree
			// We compare the child index of each element at each depth
			// If they are equal, then we move down to the next depth
			while (currentDepth < minDepth)
			{
				var item1Value:int = item1Pos[currentDepth];
				var item2Value:int = item2Pos[currentDepth];
				
				if (item1Value < item2Value)
					return -1;
				else if (item1Value > item2Value)
					return 1;
				else
				{
					currentDepth++;
				}
			} 
			
			// If all of the previous levels shared the same child index, then
			// compare the depth of the elements. A deeper element is always greater
			// if the elements share the same ancestors. 
			if (item1Depth < item2Depth)
				return -1;
			else if (item1Depth > item2Depth)
				return 1;
			else
				return 0;
		}
		
		/**
		 *  @private
		 *  Helper function to find a target in the invalidElementsArray
		 */
		private function findInvalidElementIndex(element:UIComponent):int
		{
			for (var i:int = 0; i < invalidElements.length; i++)
			{
				if (element == invalidElements[i].element)
					return i;
			}
			
			return -1;
		}
		
		/**
		 *  @private
		 *  
		 *  Calculates the position of the target relative to the subTreeRoot. Used to compare the position
		 *  of two tree nodes. The return value is a Vector of ints. Each int represents the childIndex of the 
		 *  target's ancestor at a particular depth. The highest depths are at the beginning of the Vector
		 * 
		 *  @param target Return the position of this displayObject 
		 *  @param subTreeRoot The displayObject to use as the root of the subTree
		 *  
		 *  @return a Vector of ints representing the position of the target in the display list tree
		 * 
		 */
		/*private function getElementNestedPosition(target:DisplayObject, subTreeRoot:DisplayObjectContainer = undefined):Vector.<int>
		{
		var p:DisplayObjectContainer = target.parent;
		var current:DisplayObject = target;
		var pos:Vector.<int> = new Vector.<int>();
		
		if (p == null || current == subTreeRoot)
		{
		pos.push(0);
		}
		else
		{
		while (p != null && current != subTreeRoot)
		{
		pos.splice(0, 0, p.getChildIndex(current));
		current = p;
		p = p.parent;
		}
		
		}
		return pos;
		}*/
		
		
	}
}
