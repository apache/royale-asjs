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

package mx.controls
{

/*
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
*/
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.UIComponent;
import mx.events.FlexEvent;

/*
import mx.core.UITextField;
import mx.core.mx_internal;

use namespace mx_internal;
*/
COMPILE::JS
{
	import window.Text;
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
}
import org.apache.royale.core.ITextModel;
import org.apache.royale.events.Event;
import org.apache.royale.binding.ItemRendererDataBinding;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 *
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the user clicks on a Label.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.9.0
 */
[Event(name="click", type="mx.events.MouseEvent")]


//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.LabelAccImpl")]

[DefaultBindingProperty(destination="text")]

/**
 *  The Label control displays a single line of noneditable text.
 *  Use the Text control to create blocks of multiline
 *  noneditable text.
 *
 *  <p>You can format Label text by using HTML tags,
 *  which are applied after the Label control's CSS styles are applied.
 *  You can also put padding around the four sides of the text.
 *  The text of a Label is nonselectable by default,
 *  but you can make it selectable.</p>
 *
 *  <p>If a Label is sized to be smaller than its text,
 *  you can control whether the text is simply clipped or whether
 *  it is truncated with a localizable string such as "...".
 *  (Note: Plain text can be truncated, but HTML text cannot.)
 *  If the entire text of the Label, either plain or HTML,
 *  is not completely visible, and you haven't assigned a tooltip
 *  to the Label, an automatic "truncation tip"
 *  displays the complete plain text when a user holds the mouse over the Label control.</p>
 *
 *  <p>Label controls do not have backgrounds or borders
 *  and cannot take focus.</p>
 *
 *  <p>The Label control has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Width and height large enough for the text</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 by 10000 pixels</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Label&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Label
 *    <b>Properties</b>
 *    condenseWhite="true|false"
 *    data="null"
 *    htmlText=""
 *    listData="null"
 *    selectable="true|false"
 *    text=""
 *    truncateToFit="true|false"
 *    &nbsp;
 *    <b>Styles</b>
 *    color="0x0B333C"
 *    disabledColor="0xAAB3B3"
 *    fontAntiAliasType="advanced|normal"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel|none|subpixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="0"
 *    paddingBottom="0"
 *    styleSheet="null"
 *    textAlign="left|right|center"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    &nbsp;
 *    <b>Events</b>
 *    dataChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/LabelExample.mxml
 *
 *  @see mx.controls.Text
 *  @see mx.controls.TextInput
 *  @see mx.controls.TextArea
 *  @see mx.controls.RichTextEditor
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Label extends UIComponent
                   implements IDataRenderer, IListItemRenderer, IDropInListItemRenderer

{

    //--------------------------------------------------------------------------
    //
    //  Implementation notes
    //
    //--------------------------------------------------------------------------

    /*
        A Label has a single internal child, a UITextField which displays
        the Label's text or htmlText (whichever was last set).

        See the implementation notes for UITextField to understand
        more about how a Flash TextField works.

        The 'text' and 'htmlText' properties of Label work somewhat
        differently from those of a native TextField.

        Because Flex uses invalidation, setting either 'text' or 'htmlText'
        does very little work; the setter only sets a storage var and some
        flags and dispatches an event to trigger bindings to update.

        In fact, the setters are so fast that calling them in a loop
        does not create a performance problem.
        For example, if you have a Text component (which is a subclass of
        Label intended for displaying multiple lines of text) you can
        write code like myTextComponent.text += moreStuff[i] inside a
        loop.

        However, the Flex invalidation approach means that the 'text' and
        'htmlText' properties are not coupled as immediately as with
        a TextField.

        If you set the 'text' of a Label, you can immediately get it back,
        but if you immediately get the 'htmlText' it will be null,
        indicating that it is invalid and will be calculated
        the next time the LayoutManager runs.
        Similarly, if you set the 'htmlText' of a Label, you can immediately
        get back exactly what you set, but the 'text' will be null,
        again an indication that it is invalid and will be calculated
        the next time the LayoutManager runs.

        Later, when the LayoutManager runs to re-validate the Label,
        either the 'text' or the 'htmlText' that you set -- whichever one
        was set last -- will be pushed down into the TextField.
        After that happens, the Label's 'text' and 'htmlText' properties
        will be the same as those of the TextFields; the 'text' and the
        'htmlText' will be in sync with each other, but they will no
        longer necessarily be what you set.

        If you need to force the LayoutManager to run immediately,
        you can call validateNow() on the Label.

        Here are some examples of how these interactions work:

        myLabel.htmlText = "This is <b>bold</b>."
        trace(myLabel.htmlText);
            This is <b>bold</b>.
        trace(myLabel.text);
            null
        myLabel.validateNow();
        trace(myLabel.htmlText);
            <TEXTFORMAT LEADING="2">
            <P ALIGN="LEFT">
            <FONT FACE="Verdana" SIZE="10" COLOR="#0B333C"
                  LETTERSPACING="0" KERNING="0">
            This is <B>bold</B>.
            </FONT>
            </P>
            </TEXTFORMAT>
        trace(myLabel.text);
            This is bold.
    */

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function Label()
    {
        super();
        typeNames = "Label";
    }

	private var textSet:Boolean;
	
    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;

    [Inspectable(category="General")]

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        if (value == enabled)
            return;

        super.enabled = value;
        enabledChanged = true;

        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
	//  selectable
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for selectable property.
	 */
	private var _selectable:Boolean = true;
	
	/**
	 *  @private
	 *  Change flag for selectable property.
	 */
	private var selectableChanged:Boolean;
	
	[Inspectable(category="General", defaultValue="true")]
	
	/**
	 *  Specifies whether the text can be selected. 
	 *  Making the text selectable lets you copy text from the control.
	 *
	 *  <p>When a <code>link</code> event is specified in the Label control, the <code>selectable</code> property must be set 
	 *  to <code>true</code> to execute the <code>link</code> event.</p>
	 *
	 *  @default false;
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get selectable():Boolean
	{
		return _selectable;
	}
	
	/**
	 *  @private
	 */
	public function set selectable(value:Boolean):void
	{
		if (value == selectable)
			return;
		
		_selectable = value;
		selectableChanged = true;
		
		COMPILE::JS {
			element.style["-webkit-touch-callout"] = value ? "auto" : "none";
			element.style["-webkit-user-select"] = value ? "auto" : "none";
			element.style["-khtml-user-select"] = value ? "auto" : "none";
			element.style["-moz-user-select"] = value ? "auto" : "none";
			element.style["-ms-user-select"] = value ? "auto" : "none";
			element.style["-user-select"] = value ? "auto" : "none";
		}
		
		invalidateProperties();
	}

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

    /**
     *  Lets you pass a value to the component
     *  when you use it in an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>When you use the control as a drop-in item renderer or drop-in
     *  item editor, Flex automatically writes the current value of the item
     *  to the <code>text</code> property of this control.</p>
     *
     *  <p>You do not set this property in MXML.</p>
     *
     *  @default null
     *  @see mx.core.IDataRenderer
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
        return _data;
    }

	private var bindingAdded:Boolean;
	
    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        var newText:*;

		_data = value;
		if (!bindingAdded)
		{
			addBead(new ItemRendererDataBinding());
			bindingAdded = true;
		}
		dispatchEvent(new Event("initBindings"));
		
        if (_listData)
        {
            newText = (_listData as BaseListData).label;
        }
        else if (_data != null)
        {
            if (_data is String)
                newText = String(_data);
            else
                newText = _data.toString();
        }

        if (newText !== undefined && !textSet)
        {
            text = newText;
            textSet = false;
        }
		
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    private var _listData:Object;
    
    [Bindable("__NoChangeEvent__")]
    /**
     *  Additional data about the list structure the itemRenderer may
     *  find useful.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get listData():Object
    {
        return _listData;
    }
    public function set listData(value:Object):void
    {
        _listData = value;
    }
    
    //----------------------------------
    //  htmlText
    //----------------------------------

    /**
     *  @private
     *  Storage for the htmlText property.
     *  In addition to being set in the htmlText setter,
     *  it is automatically updated at two other times.
     *  1. When the 'text' or 'htmlText' is pushed down into
     *  the textField in commitProperties(), this causes
     *  the textField to update its own 'htmlText'.
     *  Therefore in commitProperties() we reset this storage var
     *  to be in sync with the textField.
     *  2. When the TextFormat of the textField changes
     *  because a CSS style has changed (see validateNow()
     *  in UITextField), the textField also updates its own 'htmlText'.
     *  Therefore in textField_textFieldStyleChangeHandler()
     */


    [Bindable("htmlChange")]
    [CollapseWhiteSpace]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Specifies the text displayed by the Label control, including HTML markup that
     *  expresses the styles of that text.
     *  When you specify HTML text in this property, you can use the subset of HTML
     *  tags that is supported by the Flash TextField control.
     *
     *  <p>When you set this property, the HTML markup is applied
     *  after the CSS styles for the Label instance are applied.
     *  When you get this property, the HTML markup includes
     *  the CSS styles.</p>
     *
     *  <p>For example, if you set this to be a string such as,
     *  <code>"This is an example of &lt;b&gt;bold&lt;/b&gt; markup"</code>,
     *  the text "This is an example of <b>bold</b> markup" appears
     *  in the Label with whatever CSS styles normally apply.
     *  Also, the word "bold" appears in boldface font because of the
     *  <code>&lt;b&gt;</code> markup.</p>
     *
     *  <p>HTML markup uses characters such as &lt; and &gt;,
     *  which have special meaning in XML (and therefore in MXML). So,
     *  code such as the following does not compile:</p>
     *
     *  <pre>
     *  &lt;mx:Label htmlText="This is an example of &lt;b&gt;bold&lt;/b&gt; markup"/&gt;
     *  </pre>
     *
     *  <p>There are three ways around this problem.</p>
     *
     *  <ul>
     *
     *  <li>
     *
     *  <p>Set the <code>htmlText</code> property in an ActionScript method called as
     *  an <code>initialize</code> handler:</p>
     *
     *  <pre>
     *  &lt;mx:Label id="myLabel" initialize="myLabel_initialize()"/&gt;
     *  </pre>
     *
     *  <p>where the <code>myLabel_initialize</code> method is in a script CDATA section:</p>
     *
     *  <pre>
     *  &lt;fx:Script&gt;
     *  &lt;![CDATA[
     *  private function myLabel_initialize():void {
     *      myLabel.htmlText = "This is an example of &lt;b&gt;bold&lt;/b&gt; markup";
     *  }
     *  ]]&gt;
     *  &lt;/fx:Script&gt;
     *
     *  </pre>
     *
     *  <p>This is the simplest approach because the HTML markup
     *  remains easily readable.
     *  Notice that you must assign an <code>id</code> to the label
     *  so you can refer to it in the <code>initialize</code>
     *  handler.</p>
     *
     *  </li>
     *
     *  <li>
     *
     *  <p>Specify the <code>htmlText</code> property by using a child tag
     *  with a CDATA section. A CDATA section in XML contains character data
     *  where characters like &lt; and &gt; aren't given a special meaning.</p>
     *
     *  <pre>
     *  &lt;mx:Label&gt;
     *      &lt;mx:htmlText&gt;&lt;![CDATA[This is an example of &lt;b&gt;bold&lt;/b&gt; markup]]&gt;&lt;/mx:htmlText&gt;
     *  &lt;mx:Label/&gt;
     *  </pre>
     *
     *  <p>You must write the <code>htmlText</code> property as a child tag
     *  rather than as an attribute on the <code>&lt;mx:Label&gt;</code> tag
     *  because XML doesn't allow CDATA for the value of an attribute.
     *  Notice that the markup is readable, but the CDATA section makes
     *  this approach more complicated.</p>
     *
     *  </li>
     *
     *  <li>
     *
     *  <p>Use an <code>hmtlText</code> attribute where any occurences
     *  of the HTML markup characters &lt; and &gt; in the attribute value
     *  are written instead as the XML "entities" <code>&amp;lt;</code>
     *  and <code>&amp;gt;</code>:</p>
     *
     *  <pre>
     *  &lt;mx:Label htmlText="This is an example of &amp;lt;b&amp;gt;bold&amp;lt;/b&amp;gt; markup"/&amp;gt;
     *  </pre>
     *
     *  Adobe does not recommend this approach because the HTML markup becomes
     *  nearly impossible to read.
     *
     *  </li>
     *
     *  </ul>
     *
     *  <p>If the <code>condenseWhite</code> property is <code>true</code>
     *  when you set the <code>htmlText</code> property, multiple
     *  white-space characters are condensed, as in HTML-based browsers;
     *  for example, three consecutive spaces are displayed
     *  as a single space.
     *  The default value for <code>condenseWhite</code> is
     *  <code>false</code>, so you must set <code>condenseWhite</code>
     *  to <code>true</code> to collapse the white space.</p>
     *
     *  <p>If you read back the <code>htmlText</code> property quickly
     *  after setting it, you get the same string that you set.
     *  However, after the LayoutManager runs, the value changes
     *  to include additional markup that includes the CSS styles.</p>
     *
     *  <p>Setting the <code>htmlText</code> property affects the <code>text</code>
     *  property in several ways.
     *  If you read the <code>text</code> property quickly after setting
     *  the <code>htmlText</code> property, you get <code>null</code>,
     *  which indicates that the <code>text</code> corresponding to the new
     *  <code>htmlText</code> has not yet been determined.
     *  However, after the LayoutManager runs, the <code>text</code> property
     *  value changes to the <code>htmlText</code> string with all the
     *  HTML markup removed; that is,
     *  the value is the characters that the Label actually displays.</p>
     *
     *  <p>Conversely, if you set the <code>text</code> property,
     *  any previously set <code>htmlText</code> is irrelevant.
     *  If you read the <code>htmlText</code> property quickly after setting
     *  the <code>text</code> property, you get <code>null</code>,
     *  which indicates that the <code>htmlText</code> that corresponds to the new
     *  <code>text</code> has not yet been determined.
     *  However, after the LayoutManager runs, the <code>htmlText</code> property
     *  value changes to the new text plus the HTML markup for the CSS styles.</p>
     *
     *  <p>To make the LayoutManager run immediately, you can call the
     *  <code>validateNow()</code> method on the Label.
     *  For example, you could set some <code>htmlText</code>,
     *  call the <code>validateNow()</code> method, and immediately
     *  obtain the corresponding <code>text</code> that doesn't have
     *  the HTML markup.</p>
     *
     *  <p>If you set both <code>text</code> and <code>htmlText</code> properties
     *  in ActionScript, whichever is set last takes effect.
     *  Do not set both in MXML, because MXML does not guarantee that
     *  the properties of an instance get set in any particular order.</p>
     *
     *  <p>Setting either <code>text</code> or <code>htmlText</code> property
     *  inside a loop is a fast operation, because the underlying TextField
     *  that actually renders the text is not updated until
     *  the LayoutManager runs.</p>
     *
     *  <p>If you try to set this property to <code>null</code>,
     *  it is set, instead, to the empty string.
     *  If the property temporarily has the value <code>null</code>,
     *  it indicates that the <code>text</code> has been recently set
     *  and the corresponding <code>htmlText</code>
     *  has not yet been determined.</p>
     *
     *  @default ""
     *
     *  @see flash.text.TextField#htmlText
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	public function get htmlText():String
	{
		COMPILE::SWF
		{
			return ITextModel(model).html;
		}
		COMPILE::JS
		{
			return element.innerHTML;
		}
	}

	/**
	 *  @private
	 */
	public function set htmlText(value:String):void
	{
		COMPILE::SWF
		{
			ITextModel(model).html = value;
		}
		COMPILE::JS
		{
			this.element.innerHTML = value;
			this.dispatchEvent('textChange');
		}
		invalidateSize();
	}

    //----------------------------------
    //  text
    //----------------------------------


	COMPILE::JS
	protected var textNode:window.Text;

	COMPILE::JS
	private var _text:String = "";

	[Bindable("textChange")]
	/**
	 *  The text to display in the label.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function get text():String
	{
		COMPILE::SWF
		{
			return ITextModel(model).text;
		}
		COMPILE::JS
		{
			return _text;
		}
	}

	/**
	 *  @private
	 */
	public function set text(value:String):void
	{
        if (!value)
            value = "";
        
		COMPILE::SWF
		{
			ITextModel(model).text = value;
		}
		COMPILE::JS
		{
			if (textNode)
			{
				_text = value;
				textNode.nodeValue = value;
				this.dispatchEvent('textChange');
			}
		}
		
		textSet = true;
		
		invalidateSize();

	}

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------


	/**
	 *  @private
	 */
	COMPILE::SWF
	override public function addedToParent():void
	{
		super.addedToParent();
		model.addEventListener("textChange", repeaterListener);
		model.addEventListener("htmlChange", repeaterListener);
	}

	/**
	 * @royaleignorecoercion window.Text
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'span');

		textNode = document.createTextNode(_text) as window.Text;
		element.appendChild(textNode);

		element.style.whiteSpace = "nowrap";
		element.style.display = "inline-block";

		return element;
	}
	

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------


}

}
