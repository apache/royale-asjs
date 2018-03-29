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
package spark.views.styleTest
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.core.FlexGlobals;
	import mx.styles.AdvancedStyleClient;
	import mx.styles.CSSStyleDeclaration;
	
	//The possible values of the format property of the [Style] metadata tag are:
	// Boolean, Color, Number, Length, uint, Time, File, EmbeddedFile, int, 
	// ICollectionView, Array, Class, String, Object 
	
	//style with String type
	[Style(name="teststyle_1_string_noinh", type="String", inherit="no")]
	
	//sample as <s:ComboBox paddingBottom="13.5" />
	[Style(name="teststyle_2_number_noinh", type="Number", inherit="no")]
	
	[Style(name="teststyle_3_uint_inh", type="uint", inherit="yes")]
	
	
	
	/**
	 * this event will be dispatched when a style named start with "teststyle_" has been changed.
	 * and event's property: changedStyleName will contain this style name.
	 */
	[Event(name="testStylesChanged", type="assets.styleTest.ADVStyleTestEvent")]
		
	public class ADVStyleTestClass extends AdvancedStyleClient
	{
		
		// Define a static variable.
		private static var classConstructed:Boolean = classConstruct();
		
		// Define a static method.
		private static function classConstruct():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("assets.styleTest.ADVStyleTestClass"))
			{
				// If there is no CSS definition for StyledRectangle, 
				// then create one and set the default value.
				var cssStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				cssStyle.defaultFactory = function():void
				{
					this.teststyle_1_string_noinh = 'defaultString';
					/**
					 * 2, 3 unset here, so can set them using Application and global selector.
					 */
					//this.teststyle_2_number_noinh = 11111.2345;
					//this.teststyle_3_uint_inh = 9870;
					
				}
					
				FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("assets.styleTest.ADVStyleTestClass", cssStyle, true);
				
			}
			
			return true;
		}
		
		/**
		 * a list that fill with all style's name defined in this ADVStyleTestClass class.
		 */
		public static const STYLE_NAME_LIST:ArrayCollection = new ArrayCollection([
			'teststyle_1_string_noinh',
			'teststyle_2_number_noinh',
			'teststyle_3_uint_inh'
			
		
		]);
		
		public function ADVStyleTestClass()
		{
			super();
		}
		
		/**
		 *  Detects changes to style properties. When any style property is set,
		 *  Flex calls the <code>styleChanged()</code> method,
		 *  passing to it the name of the style being set.
		 * 
		 * 	Override this method to dispatch an event:ADVStyleTestEvent(ADVStyleTestEvent.TEST_STYLE_CHANGED)
		 *  when a "teststyle_*" has changed.
		 */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			
			if (styleProp) {
				if (styleProp.indexOf('teststyle_') == 0) {
					var event:ADVStyleTestEvent = new ADVStyleTestEvent(ADVStyleTestEvent.TEST_STYLE_CHANGED);
					event.changedStyleName = styleProp;
					
					this.dispatchEvent(event);
				}
			}
		}

	}
}