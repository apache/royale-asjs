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
	import mx.utils.ObjectUtil;
	
	// import spark.globalization.SortingCollator;
	
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
	 *  Provides the sorting information required to establish a sort on a field
	 *  or property in a collection view.
	 *
	 *  The SortField class is meant to be used with the Sort class.
	 *
	 *  Typically the sort is defined for collections of complex items, that
	 *  is items in which the sort is performed on properties of those objects.
	 *  As in the following example:
	 *
	 *  <pre><code>
	 *     var col:ICollectionView = new ArrayCollection();
	 *     col.addItem({first:"Anders", last:"Dickerson"});
	 *     var sort:Sort = new Sort();
	 *     var sortfield:SortField = new SortField("first", true);
	 *     sortfield.setStyle("locale", "en-US");
	 *     sort.fields = [sortfield];
	 *     col.sort = sort;
	 *  </code></pre>
	 *
	 *  There are situations in which the collection contains simple items, like
	 *  <code>String</code>, <code>Date</code>, <code>Boolean</code>, etc.
	 *  In this case, sorting should be applied to the simple type directly.
	 *  When constructing a sort for this situation only a single sort field is
	 *  required and should not have a <code>name</code> specified.
	 *  For example:
	 *
	 *  <pre><code>
	 *     var col:ICollectionView = new ArrayCollection();
	 *     col.addItem("California");
	 *     col.addItem("Arizona");
	 *     var sort:Sort = new Sort();
	 *     var sortfield:SortField = new SortField(null, true);
	 *     sortfield.setStyle("locale", "en-US");
	 *     sort.fields = [sortfield];
	 *     col.sort = sort;
	 *  </code></pre>
	 *
	 *  <p>The default comparison provided by the <code>SortField</code> class 
	 *  provides correct language specific
	 *  sorting for strings. The language is selected by the setting the locale
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
	 *  <p>The <code>&lt;s:SortField&gt;</code> tag has the following attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:SortField
	 *  <b>Properties</b>
	 *  compareFunction="<em>Internal compare function</em>"
	 *  descending="false"
	 *  name="null"
	 *  numeric="null"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/SortExample1.mxml
	 *  @includeExample examples/SortExample2.mxml
	 * 
	 *  @see mx.collections.ICollectionView
	 *  @see spark.collections.Sort
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class SortField extends mx.collections.SortField implements IAdvancedStyleClient, IFlexModule, IMXMLObject
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
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param name The name of the property that this field uses for
		 *              comparison.
		 *              If the object is a simple type, pass <code>null</code>.
		 *  @param descending Tells the comparator whether to arrange items in
		 *              descending order.
		 *  @param numeric Tells the comparator whether to compare sort items as
		 *              numbers, instead of alphabetically.
		 *  @param sortCompareType Gives an indication to SortField which of the
		 *              default compare functions to use.
		 *  @param customCompareFunction Use a custom function to compare the
		 *              objects based on this SortField.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function SortField(name:String = null,
								  descending:Boolean = false,
								  numeric:Object = null,
								  sortCompareType:String = null,
								  customCompareFunction:Function = null)
		{
			super(name, false, descending, numeric, sortCompareType, customCompareFunction);
			
			//initAdvancedStyleClient();
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
		
		[Inspectable(category="General")]
		
		/**
		 *  The function that compares two items during a sort of items for the
		 *  associated collection. If you specify a <code>compareFunction</code>
		 *  property in an <code>ISort</code> object, Flex ignores any 
		 *  <code>compareFunction</code> properties of the ISort's 
		 *  <code>SortField</code> objects.
		 * 
		 *  <p>The compare function must have the following signature:</p>
		 *
		 *  <p><code>function myCompare(a:Object, b:Object):int</code></p>
		 *
		 *  <p>This function must return the following values:</p>
		 *
		 *   <ul>
		 *        <li>-1, if the <code>Object a</code> should appear before the 
		 *        <code>Object b</code> in the sorted sequence</li>
		 *        <li>0, if the <code>Object a</code> equals the 
		 *        <code>Object b</code></li>
		 *        <li>1, if the <code>Object a</code> should appear after the 
		 *        <code>Object b</code> in the sorted sequence</li>
		 *  </ul>
		 *
		 *  <p>The default value is an internal compare function that can perform
		 *  a string, numeric, or date comparison in ascending or descending order.
		 *  The string comparison is performed using the locale (language,
		 *  region and script) specific comparison method from the
		 *  <code>SortingCollator</code> class.
		 *  This class uses the locale style to determine a locale.
		 *  Specify your own function only if you need a need a custom comparison
		 *  algorithm. This is normally only the case if a calculated field is
		 *  used in a display.</p>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		override public function get compareFunction():Function
		{
			return super.compareFunction;
		}
		
		/**
		 *  @deprecated A future release of Apache Flex SDK will remove this function. Please use the constructor
		 *  argument instead.
		 */
		override public function set compareFunction(c:Function):void
		{
			super.compareFunction = c;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *
		 *  Called by AdvancedStyleClientImplementation.as
		 */
		private function _getStyle(styleProp:String):*
		{
			/*if (styleProp != "locale")
				return _advancedStyleClient.getStyleImpl(styleProp);*/
			
			if ((localeStyle !== undefined) && (localeStyle !== null))
				return localeStyle;
			
			if (styleParent)
				return styleParent.getStyle(styleProp);
			
			if (FlexGlobals.topLevelApplication)
				return FlexGlobals.topLevelApplication.getStyle(styleProp);
			
			return undefined;
		}
		
		/**
		 *  @private
		 *  Intercept style change for "locale".
		 *
		 *  In the case that there is no associated UI component or the
		 *  module factory of the UIComponent has not yet been initialized
		 *  style changes are only recorded but the styleChanged method
		 *  is not called.  Overriding the setStyle method allows
		 *  the class to be updated immediately when the locale style is
		 *  set directly on this class instance.
		 *
		 *  Called by AdvancedStyleClientImplementation.as
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
		 *  Called by AdvancedStyleClientImplementation.as
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
		// Private Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------
		//  stringCollator
		//---------------------------------
		
		/**
		 *  @private
		 *  Locale-aware string collator.
		 */
		// private var internalStringCollator:SortingCollator;
		
		/**
		 *  @private
		 *  Locale-aware string collator
		 *
		 *  @default false
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		/*private function get stringCollator():SortingCollator
		{
			if (!internalStringCollator)
			{
				ensureStyleSource();
				const locale:* = getStyle("locale");
				
				internalStringCollator = new SortingCollator();
				internalStringCollator.setStyle("locale", locale);
			}
			
			return internalStringCollator;
		}*/
		
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
		
		
		
		
		
		/**
		 *  Pull the strings from the objects and call the implementation.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		override protected function stringCompare(a:Object, b:Object):int
		{
			var fa:String = name == null ? String(a) : String(getSortFieldValue(a));
			var fb:String = name == null ? String(b) : String(getSortFieldValue(b));
			
			return null; //stringCollator.compare(fa, fb);
		}
		
		/**
		 *  Pull the values out fo the XML object, then compare
		 *  using the string or numeric comparator depending
		 *  on the numeric flag.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		override protected function xmlCompare(a:Object, b:Object):int
		{
			var sa:String = name == null ? a.toString() : getSortFieldValue(a).toString();
			var sb:String = name == null ? b.toString() : getSortFieldValue(b).toString();
			
			if (numeric == true)
			{
				return ObjectUtil.numericCompare(parseFloat(sa), parseFloat(sb));
			}
			else
			{
				return null; //stringCollator.compare(sa, sb);
			}
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
			const newLocaleStyle:* = null; //_advancedStyleClient.getStyleImpl("locale");
			
			if (localeStyle === newLocaleStyle)
				return;
			
			localeStyle = newLocaleStyle;
			
			/*if (internalStringCollator)
			{
				internalStringCollator.setStyle("locale", localeStyle);
			}*/
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function initialized(document:Object, id:String):void
		{
		}
		
		public function get className():String
		{
			return null;
		}
		
		public function getStyle(styleProp:String):*
		{
			return null;
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
		
		public function set moduleFactory(factory:mx.core.IFlexModuleFactory):void
		{
		}
		
		public function get moduleFactory():mx.core.IFlexModuleFactory 
		{
			return null;
		}

	}
}
