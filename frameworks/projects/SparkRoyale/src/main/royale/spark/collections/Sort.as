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

package spark.collections
{
	
	// import flash.events.Event;
	import org.apache.royale.events.Event;
	import mx.styles.IAdvancedStyleClient;
	import mx.collections.ISortField;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModule;
	import mx.core.IMXMLObject;
	
	[DefaultProperty("fields")]
	// [ResourceBundle("collections")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  The locale identifier that specifies the language, region, script
	 *  and optionally other related tags and keys.
	 *  The syntax of this identifier must follow the syntax defined
	 *  by the Unicode Technical Standard #35 (for example, en-US, de-DE, zh-Hans-CN).
	 * 
	 *  <p>For browser based apps, the default locale is based on the language settings from the browser. 
	 *  (Note that this is not the browser UI language that is available from Javascript, but rather is the list of 
	 *  preferred locales for web pages that the user has set in the browser preferences.) For AIR applications, 
	 *  the default UI locale is based on the user's system preferences.</p>
	 * 
	 *  @see http://www.unicode.org/reports/tr35/
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="locale", type="String", inherit="yes")]
	
	/**
	 *  Provides the sorting information required to establish a sort on an
	 *  existing view (<code>ICollectionView</code> interface or class that 
	 *  implements the interface). After you assign a <code>Sort</code> instance to the view's
	 *  <code>sort</code> property, you must call the view's
	 *  <code>refresh()</code> method to apply the sort criteria.
	 *
	 *  <p>Typically the sort is defined for collections of complex items, that is 
	 *  collections in which the sort is performed on one or more properties of 
	 *  the objects in the collection.
	 *  The following example shows this use:</p>
	 *  <pre><code>
	 *     var col:ICollectionView = new ArrayCollection();
	 *     // In the real world, the collection would have more than one item.
	 *     col.addItem({first:"Anders", last:"Dickerson"});
	 * 
	 *     // Create the Sort instance.
	 *     var sort:ISort = new Sort();
	 * 
	 *     // Set the sort field; sort on the last name first, first name second.
	 *     var sortfieldLastName:ISortField = new SortField("last",true);
	 *     var sortfieldFirstName:ISortField = new SortField("first",true);
	 * 
	 *     // Set the locale style to "en-US" to cause the strings
	 *     // to be ordered according to the rules for English as used in the USA.
	 *     sortfieldLastName.setStyle("locale","en-US");
	 *     sortfieldFirstName.setStyle("locale","en-US");
	 *     sort.fields = [sortfieldLastName, sortfieldFirstName];
	 * 
	 *     // Assign the Sort object to the view.
	 *     col.sort = sort;
	 * 
	 *     // Apply the sort to the collection.
	 *     col.refresh();
	 *  </code></pre>
	 *
	 *  <p>There are situations in which the collection contains simple items, 
	 *  like <code>String</code>, <code>Date</code>, <code>Boolean</code>, etc.
	 *  In this case, apply the sort to the simple type directly.
	 *  When constructing a sort for simple items, use a single sort field,
	 *  and specify a <code>null</code> <code>name</code> (first) parameter
	 *  in the SortField object constructor.
	 *  For example:
	 *  <pre><code>
	 *     import mx.collections.ArrayCollection;
	 *     import spark.collections.Sort;
	 *     import spark.collections.SortField;
	 * 
	 *     var col:ICollectionView = new ArrayCollection();
	 *     col.addItem("California");
	 *     col.addItem("Arizona");
	 *     var sort:Sort = new Sort();
	 * 
	 *     // There is only one sort field, so use a <code>null</code> 
	 *     // first parameter. 
	 *     var sortfield:SortField = new SortField("null",true);
	 * 
	 *     // Set the locale style to "en-US" to set the language for the sort.
	 *     sortfield.setStyle("locale","en-US");
	 *     sort.fields = [sortfield];
	 *     col.sort = sort;
	 *     col.refresh();
	 *  </code></pre>
	 *  </p>
	 *
	 *  <p>The Flex implementations of the <code>ICollectionView</code> interface 
	 *  retrieve all items from a remote location before executing a sort.
	 *  If you use paging with a sorted list, apply the sort to the remote
	 *  collection before you retrieve the data.
	 *  </p>
	 *
	 *  <p>The default comparison provided by the <code>SortField</code> class 
	 *  provides correct language-specific
	 *  sorting for strings. The language is selected by setting the locale
	 *  style on an instance of the class in one of the following ways:
	 *  </p>
	 *  <ul>
	 *  <li>
	 *  By using the class in an MXML declaration and inheriting the
	 *  locale from the document that contains the declaration.
	 *  </li>
	 *  Example:
	 *  <pre>
	 *  &lt;fx:Declarations&gt; <br>
	 *         &lt;s:SortField id="sf" /&gt; <br>
	 *  &lt;/fx:Declarations&gt;
	 *  </pre>
	 *  <li>
	 *  By using an MXML declaration and specifying the locale value
	 *  in the list of assignments.
	 *  </li>
	 *  Example:
	 *  <pre>
	 *  &lt;fx:Declarations&gt; <br>
	 *      &lt;s:SortField id="sf_SimplifiedChinese" locale="zh-Hans-CN" /&gt; <br>
	 *  &lt;/fx:Declarations&gt;
	 *  </pre>
	 *  <li>
	 *  Calling the <code>setStyle</code> method,
	 *  e.g. <code>sf.setStyle("locale", "zh-Hans-CN")</code>
	 *  </li>
	 *  <li> 
	 *  Inheriting the style from a <code>UIComponent</code> by calling the
	 *  UIComponent's <code>addStyleClient()</code> method.
	 *  </li>
	 *  </ul>
	 *
	 *  Note: to prevent problems like
	 *  <a href="https://issues.apache.org/jira/browse/FLEX-34853">FLEX-34853</a>
	 *  it is recommended to use SortField
	 *  instances as immutable objects (by not changing their state).
	 *  
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:Sort&gt;</code> tag has the following attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:Sort
	 *  <b>Properties</b>
	 *  compareFunction="<em>Internal compare function</em>"
	 *  fields="null"
	 *  unique="false | true"
	 *  /&gt;
	 *  </pre>
	 *
	 *  <p>In case items have inconsistent data types or items have complex data types, the use of the default
	 *  built-in compare functions is not recommended. Inconsistent sorting results may occur in such cases.
	 *  To avoid such problem, provide a custom compare function and/or make the item types consistent.</p>
	 *
	 *  @includeExample examples/SortExample1.mxml
	 *  @includeExample examples/SortExample2.mxml
	 * 
	 *  @see mx.collections.ICollectionView
	 *  @see spark.collections.SortField
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class Sort extends mx.collections.Sort implements IAdvancedStyleClient, IFlexModule, IMXMLObject
	{
		// include "../core/Version.as";
		// include "AdvancedStyleClientImplementation.as";
		
        public function get styleName():Object
        {
            return null;
        }
        public function set styleName(value:Object):void
        {
        }
        
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  When executing a find return the index any matching item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const ANY_INDEX_MODE:String = "any";
		
		/**
		 *  When executing a find return the index for the first matching item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const FIRST_INDEX_MODE:String = "first";
		
		/**
		 *  When executing a find return the index for the last matching item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const LAST_INDEX_MODE:String = "last";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  <p>Creates a new Sort with no fields set and no custom comparator.</p>
		 *
		 *  @param fields An <code>Array</code> of <code>ISortField</code> objects that
		 *  specifies the fields to compare.
		 *  @param customCompareFunction Use a custom function to compare the
		 *  objects in the collection to which this sort will be applied.
		 *  @param unique Indicates if the sort should be unique.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function Sort(fields:Array = null, customCompareFunction:Function = null, unique:Boolean = false)
		{
			super(fields, customCompareFunction, unique);
			// mx_internal::useSortOn = false;
			
			// initAdvancedStyleClient();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Cache for "locale" style.
		 *
		 *  The code needs be able to find out if the locale style has been changed
		 *  from earlier.
		 */
		private var localeStyle:* = undefined;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function _getStyle(styleProp:String):*
		{
			/*if (styleProp != "locale")
				return _advancedStyleClient.getStyleImpl(styleProp);
			
			if ((localeStyle !== undefined) && (localeStyle !== null))
				return localeStyle;
			
			if (styleParent)
				return styleParent.getStyle(styleProp);
			
			if (FlexGlobals.topLevelApplication)
				return FlexGlobals.topLevelApplication.getStyle(styleProp);*/
			
			return undefined;
		}
		
		/**
		 *  @private
		 *  Intercept style change for "locale".
		 *
		 *  In the case that there is no associated UI component or the
		 *  module factory of the UIComponent has not yet been intialized
		 *  style changes are only recorded but the styleChanged method
		 *  is not called.  Overriding the setStyle method allows
		 *  the class to be updated immediately when the locale style is
		 *  set directly on this class instance.
		 */
		private function _setStyle(styleProp:String, newValue:*):void
		{
			//_advancedStyleClient.setStyleImpl(styleProp, newValue);
			
			if (styleProp != "locale")
				return;
			
			localeChanged();
		}
		
		/**
		 *  @private
		 *  Detects changes to style properties. When any style property is set,
		 *  Flex calls the <code>styleChanged()</code> method,
		 *  passing to it the name of the style being set.
		 *
		 *  For the Collator class this method determines whether or not the
		 *  locale style has changed and if needed updates the instance of
		 *  the class to reflect this change. If the locale has been
		 *  updated the <code>change</code> event will be dispatched and
		 *  uses of the bindable methods or properties will be updated.
		 *
		 *  @param styleProp The name of the style property, or null if
		 *  all styles for this component have changed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		private function _styleChanged(styleProp:String):void
		{
			localeChanged();
			//_advancedStyleClient.styleChangedImpl(styleProp);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Ensure some style source exists for this instance of a globalization
		 *  object.
		 *
		 *  A style source is considered exist if (A) styleParent value is non-null,
		 *  or (B) localeStyle value has some useable value.
		 *  If neither is the case, this style client will be added to the
		 *  FlexGlobals.topLevelApplication as a child if possible.
		 *
		 *  As a side effect this will call the styleChanged method and if the
		 *  locale has changed will cause the createWorkingInstance method
		 *  to be called.
		 */
		private function ensureStyleSource():void
		{
			if (!styleParent &&
				((localeStyle === undefined) || (localeStyle === null)))
			{
				if (FlexGlobals.topLevelApplication) 
				{
					FlexGlobals.topLevelApplication.addStyleClient(this);
				}
			}
		}
		
		
		
		private var defaultEmptyField:SortField;
		
		override protected function createEmptySortField():ISortField
		{
			ensureStyleSource();
			var sortField:SortField = new SortField();
			const locale:* = getStyle("locale");
			/*if (locale !== undefined)
				sortField.setStyle("locale", locale);*/
			return sortField;
		}
		
		/**
		 *  @private
		 *  This method is called if a style is changed on the instances of
		 *  this formatter.
		 *
		 *  This method determines if the locale style has changed and if
		 *  so it updates the formatter to reflect this change.
		 *  If the locale has been updated the <code>change</code> event
		 *  will be dispatched and uses of the
		 *  bindable methods or properties will be updated.
		 */
		private function localeChanged():void
		{
			/*const newLocaleStyle:* = _advancedStyleClient.getStyleImpl("locale");
			
			if (localeStyle === newLocaleStyle)
				return;
			
			localeStyle = newLocaleStyle;
			if (defaultEmptyField)
				defaultEmptyField.setStyle("locale", localeStyle);
			*/
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get id():String
		{
			return "";
		}
		
		public function get styleParent():IAdvancedStyleClient
		{
			return null;
		}
		
		public function set styleParent(parent:IAdvancedStyleClient):void
		{
		}
		
		public function stylesInitialized():void
		{
		}
		
		public function matchesCSSState(cssState:String):Boolean
		{
			return false;
		}
		
		public function matchesCSSType(cssType:String):Boolean
		{
			return false;
		}
		
		public function hasCSSState():Boolean
		{
			return false;
		}
		
		public function get className():String
		{
			return null;
		}
		
		public function getStyle(styleProp:String):*
		{
			return null;
		}
		
		public function get moduleFactory():mx.core.IFlexModuleFactory 
		{
			return null;
		}
		
		public function set moduleFactory(factory:mx.core.IFlexModuleFactory):void
		{
		}
		
		public function initialized(document:Object, id:String):void
		{
		}

	}
}