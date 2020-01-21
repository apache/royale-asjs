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
	
    import mx.core.IVisualElement;
    
	import spark.components.supportClasses.SkinnableTextBase;
    
	import org.apache.royale.events.Event;
	import org.apache.royale.textLayout.elements.TextFlow;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */ 
	//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	/**
	 *  Indicates under what conditions the horizontal scroll bar is displayed.
	 *
	 *  <p><b>For the Mobile theme, this is not supported.</b></p>
	 * 
	 *  @copy spark.components.Scroller#style:horizontalScrollPolicy
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */ 
	//[Style(name="horizontalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]
	
	/**
	 *  Indicates under what conditions the vertical scroll bar is displayed.
	 *
	 *  <p><b>For the Mobile theme, this is not supported.</b></p>
	 * 
	 *  @copy spark.components.Scroller#style:verticalScrollPolicy
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */ 
	[Style(name="verticalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	//[DefaultProperty("content")]
	
	//[DefaultTriggerEvent("change")]
	
	//[IconFile("TextArea.png")]
	
	/**
	 *  TextArea is a text-entry control that lets users enter and edit
	 *  multiple lines of formatted text.
	 *
	 *  <p><b>The skin for the Spark theme
	 *  uses the RichEditableText class. This means that the Spark TextArea control supports 
	 *  the Text Layout Framework (TLF) library,
	 *  which builds on the Flash Text Engine (FTE).</b>
	 *  In combination, these layers provide text editing with
	 *  high-quality international typography and layout.  
	 *  The skin includes a scroller that can display horizontal and vertical scrollbars
	 *  for scrolling through the text and supports vertical scrolling with the mouse wheel.
	 *  The RichEditableText can be accessed as <code>textDisplay</code>
	 *  and the Scroller as <code>scroller</code>.</p>
	 *  
	 *  <p><b>The skin for the mobile theme uses the StyleableStageText class.</b>  
	 *  Since StyleableStageText uses native text fields it allows for better text entry and 
	 *  manipulation experiences on mobile devices however there are some
	 *  <a href="supportClasses/StyleableStageText.html">limitations and differences</a> that you should consider.
	 *  Because StageText is not capable of measuring text, the TextArea must be given explicit, 
	 *  percent-based, or constraint-based <code>width</code> and <code>height</code>.
	 *  The StyleableStageText can be accessed as <code>textDisplay</code>.
	 *  If you wish to use the TextField-based skin, rather than the
	 *  StageText-based skin, set the <code>skinClass</code> property to
	 *  <code>"spark.skins.mobile.TextAreaSkin"</code>.</p>
	 *
	 *  <p>You can set the text to be displayed, or get the text that the user
	 *  has entered, using the <code>text</code> property.</p>
	 *
	 *  <p>The text is formatted using CSS styles such as <code>fontFamily</code>
	 *  and <code>fontSize</code>.</p>
	 *
	 *  <p>For the Spark theme,  the <code>widthInChars</code> and <code>heightInLines</code>
	 *  properties let you specify the width and height of the TextArea 
	 *  in a way that scales with the font size or you can use the <code>typicalText</code> property.
	 *  Note that if you use <code>typicalText</code>, the <code>widthInChars</code> and 
	 *  <code>heightInLines</code> properties are ignored.
	 *  For all themes, you can also specify an explicit width or height in pixels,
	 *  or use a percent width and height or constraints such as
	 *  <code>left</code> and <code>right</code>
	 *  or <code>top</code> and <code>bottom</code>.</p>
	 *
	 *  <p>You can use the <code>maxChars</code> property to limit the number
	 *  of character that the user can enter, and the <code>restrict</code>
	 *  to limit which characters the user can enter.
	 *  To use this control for password input, set the
	 *  <code>displayAsPassword</code> property to <code>true</code>.</p>
	 *
	 *  <p>For the mobile theme, the soft-keyboard-specific properties, <code>autoCapitalize</code>,
	 *  <code>autoCorrect</code>, <code>returnKeyLabel</code> and <code>softKeyboardType</code>
	 *  properties specify keyboard hints. 
	 *  If a soft-keyboard is present but does not support a feature represented by the 
	 *  hint, the hint is ignored. 
	 *  In mobile environments with only hardware keyboards, these hints are ignored. 
	 *  </p>
	 *  
	 *  <p><b>Text Area for the Spark Theme</b></p>
	 * 
	 *  <p>The most important differences between Spark TextArea and the
	 *  MX TextArea control are as follows:
	 *  <ul>
	 *    <li>Spark TextArea offers better typography, better support
	 *        for international languages, and better text layout.</li>
	 *    <li>Spark TextArea has an object-oriented model of rich text,
	 *        while the MX version does not.</li>
	 *    <li>Spark TextArea has better support for displaying
	 *        large amounts of text.</li>
	 *    <li>Spark TextArea requires that fonts be embedded
	 *        differently than the MX version.
	 *        To learn how to use the
	 *        <code>embedAsCFF</code> attribute when you embed a font,
	 *    see the font documentation.</li>
	 *  </ul></p>
	 *
	 *  <p>The Spark TextArea control uses the TLF object-oriented model of rich text,
	 *  in which text layout elements such as divisions, paragraphs, spans,
	 *  hyperlinks, and images are represented at runtime by ActionScript
	 *  objects. You can programmatically access and manipulate these objects.
	 *  The central object in TLF for representing rich text is a
	 *  TextFlow. Specify rich text for a TextArea control
	 *  by setting its <code>textFlow</code> property to a TextFlow instance.</p>
	 * 
	 *  <p>If you don't need to display text that has multiple formats,
	 *  set the TextArea <code>text</code> property to a plain text string.
	 *  See the descriptions of the <code>text</code> and <code>textFlow</code>
	 *  properties for information about how they interact;
	 *  for example, you can set one and get the other.</p>
	 *
	 *  <p>At compile time, you can put TLF markup tags inside
	 *  the TextArea tag, as the following example shows:
	 *  <pre>
	 *  &lt;s:TextArea&gt;Hello &lt;s:span fontWeight="bold"&gt;World!&lt;/s:span&gt;&lt;/s:TextArea&gt;
	 *  </pre>
	 *  In this example, the MXML compiler sets the TextArea <code>content</code>
	 *  property, causing a TextFlow object to be created from the FlowElements that you specify.</p>
	 *
	 *  <p>The TextArea control does not include any user interface for changing
	 *  the formatting of the text but contains 
	 *  APIs that you can use to programmatically format text.
	 *  For example, you can create a 
	 *  a button that, when clicked, makes the selected text bold.</p>
	 *
	 *  <p>The default text formatting is determined by CSS styles
	 *  such as <a href="supportClasses/SkinnableTextBase.html#style:fontFamily">fontFamily</a>
	 *  and <a href="supportClasses/SkinnableTextBase.html#style:fontSize">fontSize</a>.
	 *  Any formatting information in the TextFlow object overrides
	 *  the default formatting provided by the CSS styles.</p>
	 *
	 *  <p>You can control many characteristics of TextArea content with styles. Here
	 *  are a few popular ones:</p>
	 *
	 *  <ul><li>Control spacing between lines with the
	 *  <code>lineHeight</code> style.</li>
	 *  <li>Control the spacing between paragraphs with the 
	 *  <code>paragraphSpaceBefore</code> and <code>paragraphSpaceAfter</code> styles.</li>
	 *  <li>Align or justify text using the <code>textAlign</code> and <code>textAlignLast</code> styles.</li>
	 *  <li>Inset text from the border of the control using the <code>paddingLeft</code>, <code>paddingTop</code>, 
	 *  <code>paddingRight</code>, and <code>paddingBottom</code> styles.</li>
	 *  </ul>
	 *
	 *  <p>By default, the text wraps at the right edge of the control.
	 *  A vertical scrollbar automatically appears when there is more
	 *  text than fits in the TextArea.
	 *  If you set the <code>lineBreak</code> style to <code>explicit</code>,
	 *  new lines start only at explicit line breaks. This has the same effect as
	 *  if you use CR (<code>\r</code>), LF (<code>\n</code>),
	 *  or CR+LF (<code>\r\n</code>) in <code>text</code>,
	 *  or if you use <code>&lt;p&gt;</code> and <code>&lt;br/&gt;</code>
	 *  in TLF markup.
	 *  In those cases, a horizontal scrollbar automatically appears
	 *  if any lines of text are wider than the control.</p>
	 *
	 *
	 *  <p>The Spark TextArea
	 *  can display left-to-right (LTR) text, such as French,
	 *  right-to-left (RTL) text, such as Arabic, and bidirectional text,
	 *  such as a French phrase inside of an Arabic one.
	 *  If the predominant text direction is right-to-left,
	 *  set the <code>direction</code> style to <code>rtl</code>.
	 *  The <code>textAlign</code> style defaults to <code>start</code>,
	 *  which makes the text left-aligned when <code>direction</code>
	 *  is <code>ltr</code> and right-aligned when <code>direction</code>
	 *  is <code>rtl</code>. To get the opposite alignment,
	 *  set <code>textAlign</code> to <code>end</code>.</p>
	 *
	 *  <p>The Spark TextArea also supports
	 *  unlimited undo/redo within one editing session.
	 *  An editing session starts when the control gets keyboard focus
	 *  and ends when the control loses focus.</p>
	 *
	 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
	 *  create an item renderer.
	 *  For information about creating an item renderer, see 
	 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
	 *  Custom Spark item renderers</a>. </p>
	 *
	 *  <p>For the Spark theme, the TextArea control has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>188 pixels wide by 149 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>36 pixels wide and 36 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>10000 pixels wide and 10000 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin class</td>
	 *           <td>spark.skins.spark.TextAreaSkin</td>
	 *        </tr>
	 *     </table>
	 *
	 *  <p>For the Mobile theme, the TextArea control has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin class</td>
	 *           <td>spark.skins.mobile.StageTextAreaSkin</td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:TextArea&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:TextArea
	 *    <strong>Properties</strong>
	 *    heightInLines="<i>Calculated default</i>"  <b>[Spark theme only]</b>
	 *    textFlow="<i>TextFlow</i>"  <b>[Spark theme only]</b>
	 *    typicalText=null  <b>[Spark theme only]</b>
	 *    widthInChars="<i>Calculated default</i>"  <b>[Spark theme only]</b>
	 *  
	 *    <strong>Styles</strong>
	 *    horizontalScrollPolicy="auto"  <b>[Spark theme only]</b>
	 *    symbolColor=""
	 *    verticalScrollPolicy="auto"  <b>[Spark theme only]</b>
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see #text
	 *  @see #textFlow
	 *  @see spark.components.TextInput
	 *  @see spark.components.RichText
	 *  @see spark.components.RichEditableText
	 *  @see spark.components.Scroller
	 *  @see spark.components.Label
	 *  @see spark.skins.mobile.StageTextAreaSkin
	 *  @see spark.skins.mobile.TextAreaSkin
	 *  @see spark.skins.spark.TextAreaSkin
	 *
	 *  @includeExample examples/TextAreaExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.4
	 */
	public class TextArea extends SkinnableTextBase
	{
		//  include "../core/Version.as";
		
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
		 *  @productversion Royale 0.9.4
		 */    
		public function TextArea()
		{
			super();
            typeNames += " SparkTextArea";
		}
		
        override protected function createChildren():void
        {
            scroller = new Scroller();
            scroller.percentHeight = 100;
            scroller.percentWidth = 100;
            textDisplay = new RichEditableText();
            partAdded("textDisplay", textDisplay);
            scroller.viewport = textDisplay as IVisualElement;
            addElement(scroller);
        }
        
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		//private var horizontalScrollPolicyChanged:Boolean = false;
		
		/**
		 *  @private
		 */
		//private var verticalScrollPolicyChanged:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  scroller
		//----------------------------------
		
		//[SkinPart(required="false")]
		
		/**
		 *  The optional Scroller in the skin,
		 *  used to scroll the RichEditableText.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var scroller:Scroller;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  suggestedFocusSkinExclusions
		//----------------------------------
		
		/** 
		 * @private 
		 */     
		//private static const focusExclusions:Array = ["scroller", "textDisplay"];
		
		/**
		 *  @private
		 */
		/* override public function get suggestedFocusSkinExclusions():Array
		{
		return focusExclusions;
		} */
		
		//----------------------------------
		//  text
		//----------------------------------
		
		//[Bindable("change")]
		//[Bindable("textChanged")]
		
		// Compiler will strip leading and trailing whitespace from text string.
		//[CollapseWhiteSpace]
		
		/**
		 *  @private
		 */
		override public function set text(value:String):void
		{
			// Of 'text', 'textFlow', and 'content', the last one set wins.
		
			super.text = value;
		
			// Trigger bindings to textChanged.
			dispatchEvent(new Event("textChanged"));        
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  content
		//----------------------------------
		
		/**
		 *  @private
		 *  This metadata tells the MXML compiler to disable some of its default
		 *  interpretation of the value specified for the 'content' property.
		 *  Normally, for properties of type Object, it assumes that things
		 *  looking like numbers are numbers and things looking like arrays
		 *  are arrays. But <content>1</content> should generate code to set the
		 *  content to  the String "1", not the int 1, and <content>[1]</content>
		 *  should set it to the String "[1]", not the Array [ 1 ].
		 *  However, {...} continues to be interpreted as a databinding
		 *  expression, and @Resource(...), @Embed(...), etc.
		 *  as compiler directives.
		 *  Similar metadata on TLF classes causes the same rules to apply
		 *  within <p>, <span>, etc.
		 */
		//[RichTextContent]
		
		/**
		 *  This property is intended for use in MXML at compile time;
		 *  to get or set rich text content at runtime,
		 *  use the <code>textFlow</code> property instead. Adobe recommends using 
		 *  <code>textFlow</code> property to get and set rich text content at runtime,
		 *  because it is strongly typed as a TextFlow rather than as an Object.
		 *  A TextFlow is the canonical representation 
		 *  for rich text content in the Text Layout Framework.
		 *
		 *  <p>The <code>content</code> property is the default property
		 *  for TextArea, so that you can write MXML, as the following example shows:
		 *  <pre>
		 *  &lt;s:TextArea&gt;Hello &lt;s:span fontWeight="bold"&gt;World&lt;/s:span&gt;&lt;/s:TextArea&gt;
		 *  </pre>
		 *  In this example, the String and SpanElement that you specify
		 *  as the content are used to create a TextFlow.</p>
		 *
		 *  <p>This property is typed as Object because you can set it to
		 *  to a String, a FlowElement, or an Array of Strings and FlowElements.
		 *  In the example above, the content is
		 *  a 2-element array. The first array element is the String
		 *  "Hello". The second array element is a SpanElement object with the text
		 *  "World" in boldface.</p>
		 * 
		 *  <p>No matter how you specify the content, the content is converted
		 *  to a TextFlow object. When you get the value of this property, you get
		 *  the resulting TextFlow object.</p>
		 * 
		 *  <p><b>For the Mobile theme, this is not supported.</b></p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		public function get content():Object
		{
			return textFlow;
		}
		
		/**
		 *  @private
		 */   
		public function set content(value:Object):void
		{
			// Of 'text', 'textFlow', and 'content', the last one set wins.
		
			setContent(value);
		}
		
		//----------------------------------
		//  heightInLines
		//----------------------------------
		
		//[Inspectable(category="General", minValue="0.0")]
		
		/**
		 *  The default height of the control, measured in lines.
		 *
		 *  <p>For the Spark theme, see
		 *  <b>spark.components.RichEditableText.heightInLines</b></p>
		 *
		 *  <p><b>For the Mobile theme, this is not supported.</b></p>
		 * 
		 *  @see spark.components.RichEditableText#heightInLines
		 * 
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		/* public function get heightInLines():Number
		{
		return getHeightInLines();
		} */
		
		/**
		 *  @private
		 */
		/* public function set heightInLines(value:Number):void
		{
		setHeightInLines(value);
		} */
		
		//----------------------------------
		//  textFlow
		//----------------------------------
		
		// Note:
		// The 'textFlow' property is not bindable because you can't share a 
		// TextFlow between two editable components, due to the way that FTE and 
		// TLF work.
		
		/**
		 *  The TextFlow representing the rich text displayed by this component.
		 *
		 *  <p>For the Spark theme, see
		 *  <b>spark.components.RichEditableText.textFlow</b></p>
		 *
		 *  <p><b>For the Mobile theme, this is not supported.</b></p>
		 * 
		 *  @see spark.components.RichEditableText#textFlow
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		public function get textFlow():TextFlow
		{
			//trace("TextArea textFlow not implemented");
			return getTextFlow();
			//return null;
		}
		
		/**
		 *  @private
		 */
		public function set textFlow(value:TextFlow):void
		{
			// Of 'text', 'textFlow', and 'content', the last one set wins.
			
			setTextFlow(value);
		} 
		
		//----------------------------------
		//  widthInChars
		//----------------------------------
		
		//[Inspectable(category="General", minValue="0.0")]
		
		/**
		 *  The default width of the control, measured in em units.
		 *
		 *  <p>For the Spark theme, see
		 *  <b>spark.components.RichEditableText.widthInChars</b></p>
		 *
		 *  <p><b>For the Mobile theme, this is not supported.</b></p>
		 * 
		 *  @see spark.components.RichEditableText#widthInChars
		 * 
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		/* public function get widthInChars():Number
		{
		return getWidthInChars();
		} */
		
		/**
		 *  @private
		 */
		/* public function set widthInChars(value:Number):void
		{
		setWidthInChars(value);
		} */
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Pushes various TextInput properties down into the RichEditableText. 
		 */
		/* override protected function commitProperties():void
		{
		super.commitProperties();
		
		if (horizontalScrollPolicyChanged)
		{
		if (scroller)
		scroller.setStyle("horizontalScrollPolicy", getStyle("horizontalScrollPolicy"));
		horizontalScrollPolicyChanged = false;
		}
		
		if (verticalScrollPolicyChanged)
		{
		if (scroller)
		scroller.setStyle("verticalScrollPolicy", getStyle("verticalScrollPolicy"));
		verticalScrollPolicyChanged = false;
		}
		} */
		
		/**
		 *  @private
		 */
		/* override public function styleChanged(styleProp:String):void
		{
		var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
		super.styleChanged(styleProp);
		
		if (allStyles || styleProp == "horizontalScrollPolicy")
		{
		horizontalScrollPolicyChanged = true;
		invalidateProperties();
		}
		if (allStyles || styleProp == "verticalScrollPolicy")
		{
		verticalScrollPolicyChanged = true;
		invalidateProperties();
		}
		} */
		
		/**
		 *  @private
		 */
		/* override protected function partAdded(partName:String, instance:Object):void
		{
		super.partAdded(partName, instance);
		
		if (instance == textDisplay)
		{
		// In default.css, the TextArea selector has a declaration
		// for lineBreak which sets it to "toFit".
		
		// The skin is loaded after the intial properties have been
		// set so these wipe out explicit sets.
		textDisplay.multiline = true;
		}
		
		// The scroller, between textDisplay and this in the chain, should not 
		// getFocus.
		else if (instance == scroller)
		{
		scroller.focusEnabled = false;
		
		// TLF does scrolling in real numbers.  If the scroller doesn't
		// round to ints then the sets of verticalScrollPosition and
		// horizontalScrollPosition will be no-ops which is desirable.
		if (scroller.horizontalScrollBar)
		scroller.horizontalScrollBar.snapInterval = 0;
		if (scroller.verticalScrollBar)
		scroller.verticalScrollBar.snapInterval = 0;
		}
		} */
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#getFormatOfRange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		/* public function getFormatOfRange(requestedFormats:Vector.<String>=null,
		anchorPosition:int=-1,
		activePosition:int=-1):TextLayoutFormat
		{
		if (!(textDisplay is RichEditableText))
		return null;
		
		return RichEditableText(textDisplay).getFormatOfRange(
		requestedFormats, anchorPosition, activePosition);
		} */
		
		/**
		 *  @copy spark.components.RichEditableText#setFormatOfRange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		/* public function setFormatOfRange(format:TextLayoutFormat,
		anchorPosition:int=-1, 
		activePosition:int=-1):void
		{
		if (!(textDisplay is RichEditableText))
		return;
		
		RichEditableText(textDisplay).setFormatOfRange(
		format, anchorPosition, activePosition);
		} */
		
		/**
		 *  @copy spark.components.RichEditableText#scrollToRange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.4
		 */
		public function scrollToRange(anchorPosition:int = 0, activePosition:int = 0 /*int.MAX_VALUE*/):void
		{
			// if (!textDisplay)
			//    return;
			
			// textDisplay.scrollToRange(anchorPosition, activePosition);
		}        
	}
	
}
