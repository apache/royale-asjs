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

package mx.containers
{

	import org.apache.royale.events.CloseEvent;
	import org.apache.royale.html.beads.DragBead;
	import org.apache.royale.events.IEventDispatcher;
	import mx.core.UIComponent;
	import mx.containers.beads.PanelView;
/*
import mx.core.mx_internal;

use namespace mx_internal;
*/
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user selects the close button.
 *
 *  @eventType mx.events.CloseEvent.CLOSE
 *  @helpid 3985
 *  @tiptext close event
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="close", type="mx.events.CloseEvent")]

//--------------------------------------
//  Styles
//--------------------------------------
/**
 *  The close button default skin.
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="closeButtonSkin", type="Class", inherit="no", states="up, over, down, disabled")]

/**
 *  The close button disabled skin.
 *
 *  The default value is the "CloseButtonDisabled" symbol in the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="closeButtonDisabledSkin", type="Class", inherit="no")]

/**
 *  The close button down skin.
 *
 *  The default value is the "CloseButtonDown" symbol in the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="closeButtonDownSkin", type="Class", inherit="no")]

/**
 *  The close button over skin.
 *
 *  The default value is the "CloseButtonOver" symbol in the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="closeButtonOverSkin", type="Class", inherit="no")]

/**
 *  The close button up skin.
 *
 *  The default value is the "CloseButtonUp" symbol in the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="closeButtonUpSkin", type="Class", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------
/*
[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]

[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.TitleWindowAccImpl")]

[IconFile("TitleWindow.png")]

[Alternative(replacement="spark.components.TitleWindow", since="4.0")]
*/
/**
 *  A TitleWindow layout container contains a title bar, a caption,
 *  a border, and a content area for its child.
 *  Typically, you use TitleWindow containers to wrap self-contained
 *  application modules.
 *  For example, you could include a form in a TitleWindow container.
 *  When the user completes the form, you can close the TitleWindow
 *  container programmatically, or let the user close it by using the
 *  Close button.
 *  
 *  <p>The TitleWindow container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Height is large enough to hold all of the children in the content area at the default or 
 *               explicit heights of the children, plus the title bar and border, plus any vertical gap between 
 *               the children, plus the top and bottom padding of the container.<br/> 
 *               Width is the larger of the default or explicit width of the widest child, plus the left and 
 *               right container borders padding, or the width of the title text.</td>
 *        </tr>
 *        <tr>
 *           <td>borders</td>
 *           <td>10 pixels for the left and right values.<br/>
 *               2 pixels for the top value.<br/>
 *               0 pixels for the bottom value.
 *           </td>
 *        </tr>
 *        <tr>
 *           <td>padding</td>
 *           <td>4 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:TitleWindow&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass, and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:TitleWindow
 *   <b>Properties</b>
 *   showCloseButton="false|true"
 * 
 *   <b>Styles</b>
 *   closeButtonDisabledSkin="<i>'CloseButtonDisabled' symbol in Assets.swf</i>"
 *   closeButtonDownSkin="<i>'CloseButtonDown' symbol in Assets.swf</i>"
 *   closeButtonOverSkin="<i>'CloseButtonOver' symbol in Assets.swf</i>"
 *   closeButtonUpSkin="<i>'CloseButtonUp' symbol in Assets.swf</i>"
 *  
 *   <strong>Events</strong>
 *   close="<i>No default</i>"
 *   &gt;
 *    ...
 *      child tags
 *    ...
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/SimpleTitleWindowExample.mxml -noswf
 *  @includeExample examples/TitleWindowApp.mxml
 *  
 *  @see mx.core.Application
 *  @see mx.managers.PopUpManager
 *  @see mx.containers.Panel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class TitleWindow extends Panel
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by TitleWindowAccImpl.
     */
    //mx_internal static var createAccessibilityImplementation:Function;

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
     *  @productversion Royale 0.9.3
     */
    public function TitleWindow()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  showCloseButton
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  Whether to display a Close button in the TitleWindow container.
     *  The default value is <code>false</code>.
     *  Set it to <code>true</code> to display the Close button.
     *  Selecting the Close button generates a <code>close</code> event,
     *  but does not close the TitleWindow container.
     *  You must write a handler for the <code>close</code> event
     *  and close the TitleWindow from within it.
     *
     *  @default false
     *
     *  @tiptext If true, the close button is displayed
     *  @helpid 3986
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    private var _showCloseButton:Boolean = false;
	
    public function get showCloseButton():Boolean
    {
        return _showCloseButton;
    }

    /**
     *  @private
     */
    public function set showCloseButton(value:Boolean):void
    {
        _showCloseButton = value;
    }

    override public function addedToParent():void
	{
		super.addedToParent();
		var dragBead:DragBead = new DragBead();
		var titleBar:IEventDispatcher = (view as PanelView).titleBar as IEventDispatcher;
		dragBead.hitArea = titleBar;
		dragBead.moveArea = (titleBar as UIComponent).screen;
		addBead(dragBead);
	}

}

}
