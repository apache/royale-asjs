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

package mx.core
{

/*
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.managers.IFocusManagerComponent;
import mx.styles.IStyleClient;
*/

/**
 *  Defines an interface for a single-line text field that is optionally editable.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface ITextInput
    extends IDataRenderer, IUIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  selectionActivePosition
    //----------------------------------

    /**
     *  The zero-based index of the position <i>after</i> the last character
     *  in the current selection (equivalent to the one-based index of the last
     *  character).
     *  If the last character in the selection, for example, is the fifth
     *  character, this property has the value 5.
     *  When the control gets the focus, the selection is visible if the
     *  <code>selectionAnchorIndex</code> and <code>selectionActiveIndex</code>
     *  properties are both set.
     *
     *  @default 0
     *
     *  @tiptext The zero-based index value of the last character
     *  in the selection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get selectionActivePosition():int;

    //----------------------------------
    //  selectionAnchorPosition
    //----------------------------------

    /**
     *  The zero-based character index value of the first character
     *  in the current selection.
     *  For example, the first character is 0, the second character is 1,
     *  and so on.
     *  When the control gets the focus, the selection is visible if the
     *  <code>selectionAnchorIndex</code> and <code>selectionActiveIndex</code>
     *  properties are both set.
     *
     *  @default 0
     *
     *  @tiptext The zero-based index value of the first character
     *  in the selection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get selectionAnchorPosition():int;

    //----------------------------------
    //  editable
    //----------------------------------

    /**
     *  Indicates whether the user is allowed to edit the text in this control.
     *  If <code>true</code>, the user can edit the text.
     *
     *  @default true
     *
     *  @tiptext Specifies whether the component is editable or not
     *  @helpid 3196
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get editable():Boolean;

    /**
     *  @private
     */
    function set editable(value:Boolean):void;

    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------

    /**
     *  Pixel position in the content area of the leftmost pixel
     *  that is currently displayed.
     *  (The content area includes all contents of a control, not just
     *  the portion that is currently displayed.)
     *  This property is always set to 0, and ignores changes,
     *  if <code>wordWrap</code> is set to <code>true</code>.
     *
     *  @default 0

     *  @tiptext The pixel position of the left-most character
     *  that is currently displayed
     *  @helpid 3194
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get horizontalScrollPosition():Number;

    /**
     *  @private
     */
    function set horizontalScrollPosition(value:Number):void;

    //----------------------------------
    //  maxChars
    //----------------------------------

    /**
     *  Maximum number of characters that users can enter in the text field.
     *  This property does not limit the length of text specified by the
     *  setting the control's <code>text</code> or <code>htmlText</code> property.
     *
     *  <p>The default value is 0, which is a special case
     *  meaning an unlimited number.</p>
     *
     *  @tiptext The maximum number of characters
     *  that the TextInput can contain
     *  @helpid 3191
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get maxChars():int;

    /**
     *  @private
     */
    function set maxChars(value:int):void;

    //----------------------------------
    //  parentDrawsFocus
    //----------------------------------

    /**
     *  If true, calls to this control's <code>drawFocus()</code> method are forwarded
     *  to its parent's <code>drawFocus()</code> method.
     *  This is used when a TextInput is part of a composite control
     *  like NumericStepper or ComboBox;
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get parentDrawsFocus():Boolean;

    /**
     *  @private
     */
    function set parentDrawsFocus(value:Boolean):void;

    //----------------------------------
    //  restrict
    //----------------------------------

    /**
     *  Indicates the set of characters that a user can enter into the control.
     *  If the value of the <code>restrict</code> property is <code>null</code>,
     *  you can enter any character. If the value of the <code>restrict</code>
     *  property is an empty string, you cannot enter any character.
     *  This property only restricts user interaction; a script
     *  can put any text into the text field. If the value of
     *  the <code>restrict</code> property is a string of characters,
     *  you may enter only characters in that string into the
     *  text field.
     *
     *  <p>Flex scans the string from left to right. You can specify a range by
     *  using the hyphen (-) character.
     *  If the string begins with a caret (^) character, all characters are
     *  initially accepted and succeeding characters in the string are excluded
     *  from the set of accepted characters. If the string does not begin with a
     *  caret (^) character, no characters are initially accepted and succeeding
     *  characters in the string are included in the set of accepted characters.</p>
     *
     *  <p>Because some characters have a special meaning when used
     *  in the <code>restrict</code> property, you must use
     *  backslash characters to specify the literal characters -, &#094;, and \.
     *  When you use the <code>restrict</code> property as an attribute
     *  in an MXML tag, use single backslashes, as in the following
     *  example: \&#094;\-\\.
     *  When you set the <code>restrict</code> In and ActionScript expression,
     *  use double backslashes, as in the following example: \\&#094;\\-\\\.</p>
     *
     *  @default null
     *  @see flash.text.TextField#restrict
     *  @tiptext The set of characters that may be entered
     *  into the TextInput.
     *  @helpid 3193
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get restrict():String;

    /**
     *  @private
     */
    function set restrict(value:String):void;

    //----------------------------------
    //  selectable
    //----------------------------------

    /**
     *  A flag indicating whether the text in the TextInput can be selected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get selectable():Boolean;

    /**
     *  @private
     */
    function set selectable(value:Boolean):void;

    //----------------------------------
    //  text
    //----------------------------------

    /**
     *  Plain text that appears in the control.
     *  Its appearance is determined by the CSS styles of this Label control.
     *
     *  <p>Any HTML tags in the text string are ignored,
     *  and appear as entered in the string.
     *  To display text formatted using HTML tags,
     *  use the <code>htmlText</code> property instead.
     *  If you set the <code>htmlText</code> property,
     *  the HTML replaces any text you had set using this propety, and the
     *  <code>text</code> property returns a plain-text version of the
     *  HTML text, with all HTML tags stripped out. For more information
     *  see the <code>htmlText</code> property.</p>
     *
     *  <p>To include the special characters left angle  bracket (&lt;),
     *  right angle bracket (&gt;), or ampersand (&amp;) in the text,
     *  wrap the text string in the CDATA tag.
     *  Alternatively, you can use HTML character entities for the
     *  special characters, for example, <code>&amp;lt;</code>.</p>
     *
     *  <p>If you try to set this property to <code>null</code>,
     *  it is set, instead, to the empty string.
     *  The <code>text</code> property can temporarily have the value <code>null</code>,
     *  which indicates that the <code>htmlText</code> has been recently set
     *  and the corresponding <code>text</code> value
     *  has not yet been determined.</p>
     *
     *  @default ""
     *  @tiptext Gets or sets the TextInput content
     *  @helpid 3190
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get text():String;

    /**
     *  @private
     */
    function set text(value:String):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Selects the text in the range specified by the parameters.
     *
     *  @param anchorPosition The zero-based character index value
     *  of the first character in the current selection.
     *
     *  @param activePosition The zero-based index of the position
     *  after the last character in the current selection
     *  (equivalent to the one-based index of the last character).
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function selectRange(anchorPosition:int, activePosition:int):void;
}

}
