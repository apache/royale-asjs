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
	/*import flash.events.Event;*/
	import org.apache.royale.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import spark.core.IDisplayText;
	
	use namespace mx_internal;
	
	/**
	 *  Specifies the image source to use for the required indicator. 
	 *
	 *  The default value is "assets/RequiredIndicator.png".
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="requiredIndicatorSource", type="Object", inherit="no")]
	
	/**
	 *  Specifies the image source to use for the error indicator. 
	 *
	 *  The default value is "assets/ErrorIndicator.png".
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="errorIndicatorSource", type="Object", inherit="no")]
	
	/**
	 *  The FormItem container defines the following in a Spark From:
	 *
	 *  <ul>
	 *    <li>A single label.</li>
	 *    <li>A sequence label.</li>
	 *    <li>One or more child controls or containers.</li>
	 *    <li>Help content that provides a description of the form item 
	 *      or instructions for filling it in.</li>
	 *    <li>Required indicator to indicate if a form item has to be filled</li>
	 *  </ul>
	 *
	 *  Children can be controls or other containers.
	 *  A single Form container can hold multiple FormItem containers.
	 *  By default, all the FormItem elements are arranged in a horizontal 
	 *  layout with the label placed on the left and the Help content on the right.
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:FormItem&gt;</code> tag inherits all the tag 
	 *  attributes of its superclass and adds no new tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:FormItem
	 *    <strong>Properties</strong>
	 *    helpContent="null"
	 *    label=""
	 *    required="false"
	 *    sequenceLabel=""
	 *  
	 *    <strong>Common Styles</strong>
	 *    errorIndicatorSource="assets/ErrorIndicator.png"
	 *    requiredIndicatorSource="assets/RequiredIndicator.png"
	 * 
	 *    <strong>Mobile Styles</strong>
	 *    leading="2"
	 *    letterSpacing="0"
	 *  /&gt;
	 *  </pre>
	 * 
	 *  @see spark.components.Form
	 *  @see spark.components.FormHeading
	 *  @see spark.layouts.FormLayout
	 *  @see spark.skins.spark.FormItemSkin
	 *
	 *  @includeExample examples/FormItemExample.mxml
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5 
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class FormItem extends SkinnableContainer
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
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function FormItem()
		{
			super();
            typeNames += " FormItem";
            
			// Set these here instead of in the CSS type selector for Form
			// We want to hide the fact that the Form itself doesn't show
			// the error skin or error tip, but that its children do. 
			setStyle("showErrorSkin", false);
			setStyle("showErrorTip", false);
			
			/*showInAutomationHierarchy = false;*/
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		/**
		 *   A reference to the visual element that displays this FormItem's label.
		 */
		[SkinPart(required="false")]
		public var labelDisplay:IDisplayText;
		
		/**
		 *  A reference to the visual element that displays the FormItem's sequenceLabel.
		 */
		[SkinPart(required="false")]
		public var sequenceLabelDisplay:IDisplayText;
		
		/**
		 *  A reference to the Group that contains the FormItem's helpContentGroup.
		 */
		[SkinPart(required="false")]
		public var helpContentGroup:Group;
		
		/**
		 *  A reference to the visual element that display the FormItem's error strings.
		 */
		[SkinPart(required="false")]
		public var errorTextDisplay:IDisplayText;
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		mx_internal var _elementErrorStrings:Vector.<String> = new Vector.<String>;
		
		/**
		 *  Each Vector item contains the error string from a content element. 
		 *  If none of the content elements are invalid, then the vector 
		 *  is empty. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */     
		[Bindable(event="elementErrorStringsChanged")]
		
		public function get elementErrorStrings():Vector.<String>
		{
			return _elementErrorStrings;
		}
		
		//----------------------------------
		//  helpContent
		//----------------------------------
		
		private var _helpContent:Array;
		private var helpContentChanged:Boolean = false;
		
		[ArrayElementType("mx.core.IVisualElement")]
		[Bindable("helpContentChanged")]
		[Inspectable(category="General", arrayType="mx.core.IVisualElement", defaultValue="")]
		
		/** 
		 *  The set of components to include in the help content 
		 *  area of the FormItem.
		 * 
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get helpContent():Array
		{
			if (helpContentGroup)
				return helpContentGroup.getMXMLContent();
			else
				return _helpContent;
		}
		
		/**
		 *  @private
		 */
		public function set helpContent(value:Array):void
		{
			_helpContent = value;
			helpContentChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  label
		//----------------------------------
		
		private var _label:String = "";
		
		[Bindable("labelChanged")]
		[Inspectable(category="General", defaultValue="")]
		
		/**
		 *  Text label for the FormItem.
		 *  For example, a FormItem used to input an 
		 *  address might have the label of "Address".
		 * 
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 *  @private
		 */
		public function set label(value:String):void
		{
			if (_label == value)
				return;
			
			_label = value;
			
			if (labelDisplay)
				labelDisplay.text = label;
				dispatchEvent(new Event("labelChanged"));
		}
		
		//----------------------------------
		//  required
		//----------------------------------
		
		private var _required:Boolean = false;
		
		[Bindable("requiredChanged")]
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 *  If <code>true</code>, puts the FormItem skin into the
		 *  <code>required</code> state. By default, this state displays 
		 *  an indicator that the FormItem children require user input.
		 *  If <code>false</code>, the indicator is not displayed.
		 *
		 *  <p>This property controls skin's state only.
		 *  You must assign a validator to the child 
		 *  if you require input validation.</p>
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get required():Boolean
		{
			return _required;
		}
		
		/**
		 *  @private
		 */
		public function set required(value:Boolean):void
		{
			if (value == _required)
				return;
			
			_required = value;
			invalidateSkinState();
		}
		
		//----------------------------------
		//  sequenceLabel
		//----------------------------------
		
		private var _sequenceLabel:String = "";
		
		[Bindable("sequenceLabelChanged")]
		[Inspectable(category="General", defaultValue="")]
		
		/**
		 *  The number of the form item in the form. 
		 * 
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get sequenceLabel():String
		{
			return _sequenceLabel;
		}
		
		/**
		 *  @private
		 */
		public function set sequenceLabel(value:String):void
		{
			if (_sequenceLabel == value)
				return;
			
			_sequenceLabel = value;
			
			if (sequenceLabelDisplay)
				sequenceLabelDisplay.text = sequenceLabel;
			dispatchEvent(new Event("sequenceLabelChanged"));
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  baselinePosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return 0; /*getBaselinePositionForPart(labelDisplay as IVisualElement);*/
		}     
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (helpContentChanged)
			{
				createHelpContent();
				helpContentChanged = false;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			if (required)
			{
				if (!enabled)
					return "requiredAndDisabled";
				else if (elementErrorStrings.length > 0)
					return "requiredAndError";
				else
					return "required";
			}
			else
			{
				if (!enabled)
					return "disabled";
				else if (elementErrorStrings.length > 0)
					return "error";
				else
					return "normal";       
			}
		}
		        
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if (instance == labelDisplay)
				labelDisplay.text = label;
			else if (instance == sequenceLabelDisplay)
				sequenceLabelDisplay.text = sequenceLabel;
			else if (instance == errorTextDisplay)
				updateErrorTextDisplay();
			else if (instance == helpContentGroup)
			{
				helpContentChanged = true;
				createHelpContent();
			}
			else if (instance == contentGroup)
			{
				contentGroup.addEventListener("errorStringChanged", contentGroup_errorStringdHandler, true);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			
			// Remove the helpContent from the helpContentGroup so that it can be parented
			// by a different skin's helpContentGroup
			if (instance == helpContentGroup)
				/*helpContentGroup.removeAllElements();*/
			if (instance == contentGroup)
				contentGroup.removeEventListener("errorStringChanged", contentGroup_errorStringdHandler, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function updateErrorString():void
		{
			var uicElt:UIComponent;
			_elementErrorStrings = new Vector.<String>;
			
			for (var i:int = 0; i < numElements; i++)
			{
				uicElt = getElementAt(i) as UIComponent;
				
				if (uicElt)
				{
					if (uicElt.errorString != "")
					{
						_elementErrorStrings.push(uicElt.errorString);
					}
				}
			}
			
			invalidateSkinState();
			
			updateErrorTextDisplay();
			dispatchEvent(new Event("elementErrorStringsChanged"));
		}
		
		/**
		 *  Converts <code>elementErrorStrings</code> into a String, and assigns
		 *  that String to the <code>errorTextDisplay</code> skin part for display. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected function updateErrorTextDisplay():void
		{
			var msg:String = "";
			for (var i:int=0; i < elementErrorStrings.length; i++)
			{
				if (msg != "")
					msg += "\n";
				msg += elementErrorStrings[i];
			}
			
			if (errorTextDisplay)
				errorTextDisplay.text = msg;
			errorString = msg;
		}
		
		/**
		 *  @private
		 */
		private function createHelpContent():void
		{
			if (helpContentGroup)
				helpContentGroup.mxmlContent = _helpContent; 
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers 
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function contentGroup_errorStringdHandler(event:Event):void
		{
			updateErrorString();
		}
	}
}