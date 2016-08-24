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

COMPILE::SWF
{
    import flash.text.TextField;
}
COMPILE::JS
{
    import flex.text.TextField;
}
COMPILE::LATER
{
import flash.utils.Dictionary;
}

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 *  Singleton to create TextFields in the context of various ModuleFactories. 
 *  One module factory will have at most one TextField created for it.
 *  The text fields are only used for measurement;
 *  they are not on the display list.
 */
public class TextFieldFactory implements ITextFieldFactory
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
	/**
	 *  @private
	 * 
	 *  This classes singleton.
	 */
	private static var instance:ITextFieldFactory;

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	public static function getInstance():ITextFieldFactory
	{
		if (!instance)
			instance = new TextFieldFactory();

		return instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Cache of TextFields. Limit of one per module factory.
	 *  In this Dictionary, each key is a weak reference
	 *  to an IFlexModuleFactory and each value is a Dictionary
	 *  with a single entry (a TextField as a weak key).
	 */
    COMPILE::LATER
	private var textFields:Dictionary = new Dictionary(true);
    COMPILE::SWF
    private var textField:TextField;
    COMPILE::JS
    private var textField:TextField;
			
	/**
	 *  @private
	 *  Cache of FTETextFields. Limit of one per module factory.
	 *  In this Dictionary, each key is a weak reference
	 *  to an IFlexModuleFactory and each value is a Dictionary
	 *  with a single entry (a FTETextField as a weak key).
	 */
    COMPILE::LATER
	private var fteTextFields:Dictionary = new Dictionary(true);
			
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Creates an instance of TextField
	 *  in the context of the specified IFlexModuleFactory.
	 *
	 *  @param moduleFactory The IFlexModuleFactory requesting the TextField.
	 *
	 *	@return A FTETextField created in the context
	 *  of <code>moduleFactory</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function createTextField(moduleFactory:IFlexModuleFactory):TextField
	{
        COMPILE::LATER
        {
		// Check to see if we already have a text field for this module factory.
		var textField:TextField = null;
		var textFieldDictionary:Dictionary = textFields[moduleFactory];

		if (textFieldDictionary)
		{
			for (var iter:Object in textFieldDictionary)
			{
				textField = TextField(iter);
				break;
			}
		}
		if (!textField)
		{
			if (moduleFactory)
				textField = TextField(moduleFactory.create("flash.text.TextField"));			
			else 
				textField = new TextField();	
			
			// The dictionary could be empty, but not null because entries in the dictionary
			// could be garbage collected.
			if (!textFieldDictionary)
				textFieldDictionary = new Dictionary(true);
			textFieldDictionary[textField] = 1;
			textFields[moduleFactory] = textFieldDictionary;
		}
        }
        if (!textField)
            textField = new TextField();

		return textField;
	}

	/**
	 *  @private
	 *  Creates an instance of FTETextField
	 *  in the context of the specified module factory.
	 * 
	 *  @param moduleFactory The IFlexModuleFactory requesting the TextField.
	 *  May not be <code>null</code>.
	 *
	 *	@return A FTETextField created in the context
	 *  of <code>moduleFactory</code>.
	 *  The return value is loosely typed as Object
	 *  to avoid linking in FTETextField (and therefore much of TLF).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public function createFTETextField(moduleFactory:IFlexModuleFactory):Object
	{
        COMPILE::LATER
        {
		// Check to see if we already have a text field for this module factory.
		var fteTextField:Object = null;
		var fteTextFieldDictionary:Dictionary = fteTextFields[moduleFactory];

		if (fteTextFieldDictionary)
		{
			for (var iter:Object in fteTextFieldDictionary)
			{
				fteTextField = iter;
				break;
			}
		}
		if (!fteTextField)
		{
			if (moduleFactory)
			{
				fteTextField = moduleFactory.create(
					"mx.core.FTETextField");
                fteTextField.fontContext = moduleFactory;
			}			
			
			// The dictionary could be empty, but not null because entries in the dictionary
			// could be garbage collected.
			if (!fteTextFieldDictionary)
				fteTextFieldDictionary = new Dictionary(true);
			fteTextFieldDictionary[fteTextField] = 1;
			fteTextFields[moduleFactory] = fteTextFieldDictionary;
		}
		return fteTextField;
        }
        return textField;
	}
}

}
