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

import mx.core.UIComponent;
import org.apache.royale.events.Event;
COMPILE::JS
{
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
}

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the editor changes.
 *
 *  @eventType mx.events.FlexEvent.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.events.FlexEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(destination="text")]

/**
 *  The TinyEditor control is a JS RichTextEditor that uses
 *  tiny-editor: https://www.cssscript.com/tiny-rich-text-editor/
 *  @see mx.controls.RichTextEditor
 *
 *  To use this control, you have to download and deploy the tiny-rich-text-editor
 *  code.  To install it, do the following:
 *  
 *  npm init
 *  npm install tiny-editor --save
 *  
 *  after building the code, copy node_modules into the output folders so that
 *  bin/js-debug/node_modules/tiny-editor/dist/bundle.js
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TinyEditor extends UIComponent
{

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
    public function TinyEditor()
    {
        super();
        typeNames = "TinyEditor";
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
     *  Specifies the text displayed by the TinyEditor control, including HTML markup that
     *  expresses the styles of that text.
     *  When you specify HTML text in this property, you can use the subset of HTML
     *  tags that is supported by the Flash TextField control.
     *
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
			return null;
		}
		COMPILE::JS
		{
			return editorDiv.innerHTML;
		}
	}

	/**
	 *  @private
	 */
	public function set htmlText(value:String):void
	{
		COMPILE::JS
		{
			this.editorDiv.innerHTML = value;
			this.dispatchEvent(new Event('textChange'));
		}
		invalidateSize();
	}

    //----------------------------------
    //  text
    //----------------------------------


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
		return _text;
	}

	/**
	 *  @private
	 */
	public function set text(value:String):void
	{
        if (!value)
            value = "";
        
		COMPILE::JS
		{
			editorDiv.innerHTML = value;
		}
		this.dispatchEvent(new Event('textChange'));		
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

	COMPILE::JS
	private var editorDiv:HTMLDivElement;
	
	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		super.createElement();
		
		var wrapperDiv:HTMLDivElement = document.createElement("div") as HTMLDivElement;
		wrapperDiv.className = "__wrapper";
		element.appendChild(wrapperDiv);
		
		editorDiv = document.createElement("div") as HTMLDivElement;		
		editorDiv.setAttribute('data-tiny-editor', 1);
		editorDiv.setAttribute('data-bold', "yes");
		editorDiv.setAttribute('data-italic', "yes");
		editorDiv.setAttribute('data-underline', "yes");
		editorDiv.setAttribute('data-justifycenter', "yes");
		editorDiv.setAttribute('data-justifyleft', "yes");
		editorDiv.setAttribute('data-justifyright', "yes");
		wrapperDiv.appendChild(editorDiv);
	
		/**	
		 * <inject_script> */
	    var script:WrappedHTMLElement = document.createElement("script") as WrappedHTMLElement;
	    script.setAttribute("src", "node_modules/tiny-editor/dist/bundle.js");
	    document.head.appendChild(script);
	    var link:WrappedHTMLElement = document.createElement("link") as WrappedHTMLElement;
	    link.setAttribute("rel", "stylesheet"); 
        link.setAttribute("href", "https://use.fontawesome.com/releases/v5.3.1/css/all.css"); 
        link.setAttribute("integrity", "sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU");
        link.setAttribute("crossorigin", "anonymous");
	    document.head.appendChild(link);
        /**
         * </inject_script> */

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
