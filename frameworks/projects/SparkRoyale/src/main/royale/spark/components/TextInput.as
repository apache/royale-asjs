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

/* import flash.events.Event;
import flash.events.FocusEvent;

import flashx.textLayout.formats.LineBreak; */
COMPILE::JS
{
	import goog.events;
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
}

import org.apache.royale.core.ITextModel;
import org.apache.royale.events.Event;
import org.apache.royale.html.accessories.RestrictTextInputBead;
import mx.core.mx_internal;
import mx.events.FlexEvent;
    
import spark.components.supportClasses.SkinnableTextBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user presses the Enter key.
 *
 *  @eventType mx.events.FlexEvent.ENTER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="enter", type="mx.events.FlexEvent")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="verticalAlign", kind="style")]
[Exclude(name="lineBreak", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("text")]

[DefaultTriggerEvent("change")]

//[IconFile("TextInput.png")]

/**
 *  TextInput is a text-entry control that lets users enter and edit
 *  a single line of uniformly-formatted text.
 *
 *  <p><b>The TextInput skin for the Spark theme
 *  uses the RichEditableText class. This means that the Spark TextInput control supports 
 *  the Text Layout Framework (TLF) library,
 *  which builds on the Flash Text Engine (FTE).</b>
 *  In combination, these layers provide text editing with
 *  high-quality international typography and layout.</p>
 * 
 *  <p><b>The TextInput skin for the mobile theme uses the StyleableStageText class instead 
 *  of RichEditableText.</b>  
 *  Since StyleableStageText uses native text fields it allows for better text entry and 
 *  manipulation experiences on mobile devices however there are
 *  <a href="supportClasses/StyleableStageText.html">limitations and differences</a> that you should
 *  consider.
 *  The native text controls used by StageText apply different paddings around text. 
 *  In order to avoid vertical scrolling, the StageText-based TextInput skin attempts to estimate 
 *  this padding and compensate for that. 
 *  Because of this and other differences in how native text controls treat text, the default 
 *  height of the TextInput control using StageText-based skin will differ from its default height 
 *  using the the TextField-based TextInput skin.
 * </p>
 *
 *  <p>You can set the text to be displayed, or get the text that the user
 *  has entered, using the <code>text</code> property.
 *  This property is a String, so if the user enter a numeric value
 *  it will be reported, for example, as "123.45" rather than 123.45.</p>
 *
 *  <p>The text is formatted using CSS styles such as <code>fontFamily</code>
 *  and <code>fontSize</code>.</p>
 *
 *  <p>For the Spark theme you can specify the width of the control using the 
 *  <code>widthInChars</code> property which provides a convenient way to specify the width in a 
 *  way that scales with the font size or you can use the <code>typicalText</code> property.
 *  Note that if you use <code>typicalText</code>, the <code>widthInChars</code> property is ignored.
 *  For all themes, you can also specify an explicit width in pixels,
 *  a percent width, or use constraints such as <code>left</code>
 *  and <code>right</code>.
 *  You do not normally do anything to specify the height;
 *  the control's default height is sufficient to display
 *  one line of text.
 *  </p>
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
 *  <p>This control dispatches a <code>FlexEvent.ENTER</code> event
 *  when the user pressed the Enter key rather than inserting a line
 *  break, because this control does not support entering multiple
 *  lines of text. By default, this control has explicit line breaks.</p>
 *
 *  <p>This control is a skinnable control whose default skin contains either a
 *  RichEditableText instance for the Spark theme or a StyleableStageText instance for the
 *  Mobile theme. It handles displaying and editing the text.
 *  (The skin also handles drawing the border and background.)
 *  This RichEditableText or StyleableStageText instance can be accessed as the <code>textDisplay</code>
 *  object.  For the mobile theme, if you wish to use the TextField-based skin, rather than the
 *  StageText-based skin, set the <code>skinClass</code> property to
 *  <code>"spark.skins.mobile.TextInputSkin"</code>.</p>
 *
 *  <p>For the Spark theme, as a result of its RichEditableText using TLF, 
 *  the Spark TextInput control supports displaying left-to-right (LTR) text, such as French,
 *  right-to-left (RTL) text, such as Arabic, and bidirectional text
 *  such as a French phrase inside of an Arabic one.
 *  If the predominant text direction is right-to-left,
 *  set the <code>direction</code> style to <code>rtl</code>.
 *  The <code>textAlign</code> style defaults to <code>start</code>,
 *  which makes the text left-aligned when <code>direction</code>
 *  is <code>ltr</code> and right-aligned when <code>direction</code>
 *  is <code>rtl</code>.
 *  To get the opposite alignment,
 *  set <code>textAlign</code> to <code>end</code>.</p>
 *
 *  <p>Also as a result of using TLF, the Spark TextInput supports
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
 *  <p>For the Spark theme, the TextInput control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>128 pixels wide by 22 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.TextInputSkin</td>
 *        </tr>
 *     </table>
 *
 *  <p>For the Mobile theme, the TextInput control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.mobile.StageTextInputSkin</td>
 *        </tr>
 *     </table>
 *
 *  @includeExample examples/TextInputExample.mxml
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:TextInput&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:TextInput
    <strong>Properties</strong>
 *    widthInChars="<i>Calculated default</i>"  <b>[applies to Spark theme]</b>
 *  
 *    <strong>Events</strong>
 *    enter="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.Label
 *  @see spark.components.RichEditableText
 *  @see spark.skins.mobile.StageTextInputSkin
 *  @see spark.skins.mobile.TextInputSkin
 *  @see spark.skins.spark.TextInputSkin
 *  @see TextArea
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class TextInput extends SkinnableTextBase
{
    //include "../core/Version.as";

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
    public function TextInput()
    {
        super();
        typeNames = "TextInput";
    }

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
   // private static const focusExclusions:Array = ["textDisplay"];
    
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
    [CollapseWhiteSpace]
       
    /**
     *  @private
     */
    override public function get text():String
    {
		COMPILE::SWF
		{
			return ITextModel(model).text;
		}
		COMPILE::JS
		{
			return (element as HTMLInputElement).value;
		}
    }
    override public function set text(value:String):void
    {
        // BEGIN - this code shouldn't exist once SkinnableTextBase is fixed
        COMPILE::SWF
		{
			inSetter = true;
			ITextModel(model).text = value;
			inSetter = false;
		}
		
		COMPILE::JS
		{
			(element as HTMLInputElement).value = value;
		}
        // END

      /*  super.text = value; */
        // Trigger bindings to textChanged.
        dispatchEvent(new Event("textChanged"));
	dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }
	
    private var _editable:Boolean = true;
    override public function get editable():Boolean{
	return _editable;
    }
    override public function set editable(value:Boolean):void{
	_editable = value;
	COMPILE::JS
	{
		if(value == false) {
			(element as HTMLInputElement).readOnly = true;
		}
		else {
			 (element as HTMLInputElement).readOnly = value;
		}
	}
   }
    override public function set maxChars(value:int):void
    {
        super.maxChars = value;
        COMPILE::JS
        {
            (element as HTMLInputElement).maxLength = value;
            //dispatchEvent(new Event('htmlTextChanged'));
        }  
    }
    
    private var restrictBead:RestrictTextInputBead;
    
    override public function get restrict():String 
    {
        if (!restrictBead) return null;
        return restrictBead.restrict;
    }

    override public function set restrict(value:String):void
    {
        if (!restrictBead)
        {
            restrictBead = new RestrictTextInputBead();
            addBead(restrictBead);
        }
        restrictBead.restrict = value;
    }
    
    COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this,'input');
		element.setAttribute('type', 'text');
        
		//attach input handler to dispatch royale change event when user write in textinput
		//goog.events.listen(element, 'change', killChangeHandler);
		goog.events.listen(element, 'input', textChangeHandler);
		return element;
	}
	private var inSetter:Boolean;

	/**
	 *  dispatch change event in response to a textChange event
	 *
	 *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 */
	public function textChangeHandler(event:Event):void
	{
        if (!inSetter)
            dispatchEvent(new Event(Event.CHANGE));
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  widthInChars
    //----------------------------------
    
    //[Inspectable(category="General", minValue="0.0")]    

    /**
     *  The default width of the control, measured in em units.
     *
     *  <p>An em is a unit of typographic measurement
     *  equal to the point size.
     *  It is not necessarily exactly the width of the "M" character,
     *  but in many fonts the "M" is about one em wide.
     *  The control's <code>fontSize</code> style is used,
     *  to calculate the em unit in pixels.</p>
     *
     *  <p>You would, for example, set this property to 20 if you want
     *  the width of the TextInput to be sufficient
     *  to input about 20 characters of text.</p>
     *
     *  <p>This property will be ignored if you specify an explicit width,
     *  a percent width, or both <code>left</code> and <code>right</code>
     *  constraints.</p>
     *
     *  <p>This property will also be ignored if the <code>typicalText</code> 
     *  property is specified.</p>
     * 
     *  <p><b>For the Mobile theme, this is not supported.</b></p>
     *      
     *  @default 10
     *
     *  @see spark.primitives.heightInLines
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get widthInChars():Number
    {
        return 0; //getWidthInChars();
    }

    /**
     *  @private
     */
    public function set widthInChars(value:Number):void
    {
        // setWidthInChars(value);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);

        if (instance == textDisplay)
        {
            textDisplay.multiline = false;

            // Single line for interactive input.  Multi-line text can be
            // set.
            textDisplay.lineBreak = "explicit";
            
            // TextInput should always be 1 line.
            if (textDisplay is RichEditableText)
                RichEditableText(textDisplay).heightInLines = 1;
        }
    } */
}

}
