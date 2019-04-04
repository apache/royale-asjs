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

    import org.apache.royale.core.IAlertModel;
    import org.apache.royale.core.IChild;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.CloseEvent;
	import mx.containers.Panel;
	import mx.managers.ISystemManager;
    import mx.managers.PopUpManager;
	import mx.core.IUIComponent;
	import mx.core.FlexGlobals;
	/*
import flash.events.Event;
import flash.events.EventPhase;

import mx.controls.alertClasses.AlertForm;
import mx.core.EdgeMetrics;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.ISystemManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;
*/
//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Name of the CSS style declaration that specifies 
 *  styles for the Alert buttons. 
 * 
 *  @default "alertButtonStyle"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="buttonStyleName", type="String", inherit="no")]

/**
 *  Name of the CSS style declaration that specifies
 *  styles for the Alert message text. 
 *
 *  <p>You only set this style by using a type selector, which sets the style 
 *  for all Alert controls in your application.  
 *  If you set it on a specific instance of the Alert control, it can cause the control to 
 *  size itself incorrectly.</p>
 * 
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="messageStyleName", type="String", inherit="no")]

/**
 *  Name of the CSS style declaration that specifies styles
 *  for the Alert title text. 
 *
 *  <p>You only set this style by using a type selector, which sets the style 
 *  for all Alert controls in your application.  
 *  If you set it on a specific instance of the Alert control, it can cause the control to 
 *  size itself incorrectly.</p>
 * 
 *  @default "windowStyles" 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="titleStyleName", type="String", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="mx.accessibility.AlertAccImpl")]

//[RequiresDataBinding(true)]

//[ResourceBundle("controls")]
    
/**
 *  The Alert control is a pop-up dialog box that can contain a message,
 *  a title, buttons (any combination of OK, Cancel, Yes, and No) and an icon. 
 *  The Alert control is modal, which means it will retain focus until the user closes it.
 *
 *  <p>Import the mx.controls.Alert class into your application, 
 *  and then call the static <code>show()</code> method in ActionScript to display
 *  an Alert control. You cannot create an Alert control in MXML.</p>
 *
 *  <p>The Alert control closes when you select a button in the control, 
 *  or press the Escape key.</p>
 *
 *  @includeExample examples/SimpleAlert.mxml
 *
 *  @see mx.managers.SystemManager
 *  @see mx.managers.PopUpManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class Alert extends Panel
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Value that enables a Yes button on the Alert control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const YES:uint = 0x0001;
    
    /**
     *  Value that enables a No button on the Alert control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>YES</code>, and <code>NONMODAL</code> flags.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const NO:uint = 0x0002;
    
    /**
     *  Value that enables an OK button on the Alert control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>CANCEL</code>, <code>YES</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const OK:uint = 0x0004;
    
    /**
     *  Value that enables a Cancel button on the Alert control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>YES</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const CANCEL:uint= 0x0008;

    /**
     *  Value that makes an Alert nonmodal when passed as the
     *  <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>YES</code>, and <code>NO</code> flags.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public static const NONMODAL:uint = 0x8000;

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by AlertAccImpl.
     */
    //mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Storage for the resourceManager getter.
     *  This gets initialized on first access,
     *  not at static initialization time, in order to ensure
     *  that the Singleton registry has already been initialized.
     */
    //private static var _resourceManager:IResourceManager;
    
    /**
     *  @private
     */
    //private static var initialized:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  buttonHeight
    //----------------------------------

    //[Inspectable(category="Size")]

    /**
     *  Height of each Alert button, in pixels.
     *  All buttons must be the same height.
     *
     *  @default 22
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static var buttonHeight:Number = 22;
    
    //----------------------------------
    //  buttonWidth
    //----------------------------------

    //[Inspectable(category="Size")]

    /**
     *  Width of each Alert button, in pixels.
     *  All buttons must be the same width.
     *
     *  @default 65
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public static var buttonWidth:Number = 65;
    
    //----------------------------------
    //  cancelLabel
    //----------------------------------
    /**
     *  @private
     *  Storage for the cancelLabel property.
     */
    private static var _cancelLabel:String;
    
    /**
     *  @private
     */
    //private static var cancelLabelOverride:String;

    //[Inspectable(category="General")]

	public static function get cancelLabel():String
	{
		// initialize();
		
		return _cancelLabel;
	}
	
	/**
	 *  @private
	 */
	public static function set cancelLabel(value:String):void
	{
		/*cancelLabelOverride = value;
		
		_cancelLabel = value != null ?
			value :
			resourceManager.getString(
				"controls", "cancelLabel");
		*/
	}
    //----------------------------------
    //  noLabel
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the noLabel property.
     */
    //private static var _noLabel:String;
    
    /**
     *  @private
     */
    //private static var noLabelOverride:String;

    //[Inspectable(category="General")]

    /**
     *  @private
     *  Storage for the okLabel property.
     */
    private static var _okLabel:String;
    
    /**
     *  @private
     */
    //private static var okLabelOverride:String;

    //[Inspectable(category="General")]
	
	public static function get okLabel():String
	{
		// initialize();
		
		return _okLabel;
	}
	
	/**
	 *  @private
	 */
	public static function set okLabel(value:String):void
	{
		/*
		okLabelOverride = value;
		
		_okLabel = value != null ?
			value :
			resourceManager.getString(
				"controls", "okLabel");
		*/
	}
	
    /**
     *  @private
     *  Storage for the yesLabel property.
     */
    //private static var _yesLabel:String;
    
    /**
     *  @private
     */
    //private static var yesLabelOverride:String;

    //[Inspectable(category="General")]

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Static method that pops up the Alert control. The Alert control 
     *  closes when you select a button in the control, or press the Escape key.
     * 
     *  @param text Text string that appears in the Alert control. 
     *  This text is centered in the alert dialog box.
     *
     *  @param title Text string that appears in the title bar. 
     *  This text is left justified.
     *
     *  @param flags Which buttons to place in the Alert control.
     *  Valid values are <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
     *  <code>Alert.YES</code>, and <code>Alert.NO</code>.
     *  The default value is <code>Alert.OK</code>.
     *  Use the bitwise OR operator to display more than one button. 
     *  For example, passing <code>(Alert.YES | Alert.NO)</code>
     *  displays Yes and No buttons.
     *  Regardless of the order that you specify buttons,
     *  they always appear in the following order from left to right:
     *  OK, Yes, No, Cancel.
     *
     *  @param parent Object upon which the Alert control centers itself.
     *
     *  @param closeHandler Event handler that is called when any button
     *  on the Alert control is pressed.
     *  The event object passed to this handler is an instance of CloseEvent;
     *  the <code>detail</code> property of this object contains the value
     *  <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
     *  <code>Alert.YES</code>, or <code>Alert.NO</code>.
     *
     *  @param iconClass Class of the icon that is placed to the left
     *  of the text in the Alert control.
     *
     *  @param defaultButtonFlag A bitflag that specifies the default button.
     *  You can specify one and only one of
     *  <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
     *  <code>Alert.YES</code>, or <code>Alert.NO</code>.
     *  The default value is <code>Alert.OK</code>.
     *  Pressing the Enter key triggers the default button
     *  just as if you clicked it. Pressing Escape triggers the Cancel
     *  or No button just as if you selected it.
     *
     *  @param moduleFactory The moduleFactory where this Alert should look for
     *  its embedded fonts and style manager.
     * 
     *  @return A reference to the Alert control. 
     *
     *  @see mx.events.CloseEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function show(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                //parent:Sprite = null, 
                                parent:IUIComponent = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */,
                                moduleFactory:Object = null):Alert
                                //moduleFactory:IFlexModuleFactory = null):Alert
    {
       // var modal:Boolean = (flags & Alert.NONMODAL) ? false : true;

        if (!parent)
        {
            // var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
            // no types so no dependencies
            // var mp:Object; //= sm.getImplementation("mx.managers::IMarshalSystemManager");
            // if (mp && mp.useSWFBridge())
            //    parent = Sprite(sm.getSandboxRoot());
            //else
            //    parent = Sprite(FlexGlobals.topLevelApplication);
            parent = FlexGlobals.topLevelApplication as IUIComponent;
        }
        
        var alert:Alert = new Alert();
        if (flags & Alert.OK||
            flags & Alert.CANCEL ||
            flags & Alert.YES ||
            flags & Alert.NO)
        {
            alert.buttonFlags = flags;
        }
        else
            /*
        if (defaultButtonFlag == Alert.OK ||
            defaultButtonFlag == Alert.CANCEL ||
            defaultButtonFlag == Alert.YES ||
            defaultButtonFlag == Alert.NO)*/
        {
            alert.buttonFlags = defaultButtonFlag;
        }
        
        alert.text = text;
        alert.title = title;
        //alert.iconClass = iconClass;
            
        if (closeHandler != null)
            alert.addEventListener(CloseEvent.CLOSE, closeHandler);

        // Setting a module factory allows the correct embedded font to be found.
        /*if (moduleFactory)
            alert.moduleFactory = moduleFactory;    
        else if (parent is IFlexModule)
            alert.moduleFactory = IFlexModule(parent).moduleFactory;
        else
        {
            if (parent is IFlexModuleFactory)
                alert.moduleFactory = IFlexModuleFactory(parent);
            else                
                alert.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
            
            // also set document if parent isn't a UIComponent
            if (!parent is UIComponent)
                alert.document = FlexGlobals.topLevelApplication.document;
        }

        alert.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
        */
        PopUpManager.addPopUp(alert, parent, true);

        return alert;
    }

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
    public function Alert()
    {
        super();

        // Panel properties.
        //title = "";
        typeNames = "Alert";
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alertForm
    //----------------------------------
    
    /**
     *  @private
     *  The internal AlertForm object that contains the text, icon, and buttons
     *  of the Alert control.
     */
    //mx_internal var alertForm:AlertForm;

    //----------------------------------
    //  buttonFlags
    //----------------------------------

    /**
     *  A bitmask that contains <code>Alert.OK</code>, <code>Alert.CANCEL</code>, 
     *  <code>Alert.YES</code>, and/or <code>Alert.NO</code> indicating
     *  the buttons available in the Alert control.
     *
     *  @default Alert.OK
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    /**
     *  The buttons to display on the Alert as bit-mask values.
     *
     *  Alert.YES
     *  Alert.NO
     *  Alert.OK
     *  Alert.CANCEL
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get buttonFlags():uint
    {
        return IAlertModel(model).flags;
    }
    public function set buttonFlags(value:uint):void
    {
        IAlertModel(model).flags = value;
    }
    
    //----------------------------------
    //  defaultButtonFlag
    //----------------------------------

    //[Inspectable(category="General")]

    /**
     *  A bitflag that contains either <code>Alert.OK</code>, 
     *  <code>Alert.CANCEL</code>, <code>Alert.YES</code>, 
     *  or <code>Alert.NO</code> to specify the default button.
     *
     *  @default Alert.OK
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    //public var defaultButtonFlag:uint = OK;
	    
    //----------------------------------
    //  iconClass
    //----------------------------------

    //[Inspectable(category="Other")]

    /**
     *  The class of the icon to display.
     *  You typically embed an asset, such as a JPEG or GIF file,
     *  and then use the variable associated with the embedded asset 
     *  to specify the value of this property.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    //public var iconClass:Class;
    
    //----------------------------------
    //  text
    //----------------------------------

    //[Inspectable(category="General")]
    
    /**
     *  The text to display in this alert dialog box.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    /**
     *  The message to display in the Alert body.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get text():String
    {
        return IAlertModel(model).message;
    }
    public function set text(value:String):void
    {
        IAlertModel(model).message = value;
    }
    

    /**
     * @private
     * @royaleignorecoercion mx.core.IUIComponent
     */
    override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        $uibase_addChild(c as IUIComponent);
    }
    
}

}
