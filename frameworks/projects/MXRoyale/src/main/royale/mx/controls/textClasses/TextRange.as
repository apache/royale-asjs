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

package mx.controls.textClasses
{

/* import flash.text.TextField;
import flash.text.TextFormat;
import mx.core.mx_internal;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

use namespace mx_internal; */
import mx.core.UIComponent;

/**
 *  The TextRange class provides properties that select and format a range of
 *  text in the Label, Text, TextArea, TextEditor, and RichTextEditor controls.
 *
 *  @see mx.controls.Label
 *  @see mx.controls.RichTextEditor
 *  @see mx.controls.Text
 *  @see mx.controls.TextArea
 *  @see mx.controls.TextInput
 *  @see flash.text.TextFormatAlign
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class TextRange
{
	//include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	//private static var htmlTextField:TextField;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
	/**
	 *  Create a new TextRange Object that represents a subset of the contents
	 *  of a text control, including the formatting information.
	 *
	 *  @param owner The control that contains the text. The control must have
	 *  a <code>textField</code> property, or, as is the case of the
	 *  RichTextEditor control, a <code>textArea</code> property.
	 *
	 *  @param modifiesSelection Whether to select the text in the range.
	 *  If you set this parameter to <code>true</code> and do not specify a
	 *  begin or end index that corresponds to text in the control, Flex
	 *  uses the begin or end index of the current text selection.
	 *  If this parameter is <code>true</code>, you omit the
	 *  <code>beginIndex</code> and <code>endIndex</code>
	 *  parameters, and there is no selection, the TextRange object is empty.
	 *
	 *  @param beginIndex Zero-based index of the first character in the range.
	 *  If the <code>modifiesSelection</code> parameter is <code>false</code>
	 *  and you omit this parameter or specify a negative value,
	 *  the range starts with the first text character.
	 *
	 *  @param endIndex Zero-based index of the position <i>after</i> the
	 *  last character in the range.
	 *  If the <code>modifiesSelection</code> parameter is <code>false</code>
	 *  and you omit this parameter, specify a negative value, or specify
	 *  a value past the end of the text, the range ends with the last
	 *  text character.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function TextRange(owner:UIComponent,
							  modifiesSelection:Boolean = false,
							  beginIndex:int = -1, endIndex:int = -1)
	{
		super();

		/* _owner = owner;

		try
		{
			textField = _owner["textArea"].getTextField();
		}
		catch(e:Error)
		{
			textField = this["_owner"].getTextField();
		}

		_modifiesSelection = modifiesSelection;

		if (!_modifiesSelection)
		{
			if (beginIndex < 0)
				beginIndex = 0;

			if (beginIndex > textField.length)
				beginIndex = textField.length;

			if (endIndex < 0 || endIndex > textField.length)
				endIndex = textField.length;

			_beginIndex = beginIndex;
			_endIndex = endIndex;
		}
		else
		{
			if (beginIndex < 0 || beginIndex > textField.length)
				beginIndex = textField.selectionBeginIndex;

			if (endIndex < 0 || endIndex > textField.length)
				endIndex = textField.selectionEndIndex;

			textField.selectable = true;
			
			if (beginIndex != textField.selectionBeginIndex ||
				endIndex != textField.selectionEndIndex)
			{
				textField.setSelection(beginIndex, endIndex);
			}
		} */
	}

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	//private var textField:TextField;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  beginIndex
    //----------------------------------

	/**
	 *  Storage for the beginIndex property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	private var _beginIndex:int;

	/**
	 *  Zero-based index in the control's text field of the first
	 *  character in the range.
	 *  If the fifth character in the text is the first character in the
	 *  range, this property has a value of 4.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function get beginIndex():int
	{
		/* if (_modifiesSelection)
			return textField.selectionBeginIndex;
		else */
			return _beginIndex;
	}

	/**
	 *  @private
	 */
	public function set beginIndex(value:int):void
	{
		/* if (_modifiesSelection)
			textField.setSelection(value, textField.selectionEndIndex);
		else */
			_beginIndex = value;
	}

   
}

}
