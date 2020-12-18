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

import mx.display.Bitmap;
import mx.core.UIComponent;
//import flash.display.Loader;
//import flash.display.LoaderInfo;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import mx.events.HTTPStatusEvent;
import org.apache.royale.events.IEventDispatcher;
import mx.events.IOErrorEvent;
import org.apache.royale.events.MouseEvent;
import mx.events.ProgressEvent;
import mx.events.SecurityErrorEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.net.URLRequest;
import mx.system.ApplicationDomain;
//import flash.system.Capabilities;
//import flash.system.LoaderContext;
//import flash.system.SecurityDomain;
//import mx.utils.org.ByteArray;

import mx.core.FlexGlobals;
//import mx.core.FlexLoader;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
//import mx.core.ILayoutDirectionElement;
//import mx.core.ISWFLoader;
import mx.core.IUIComponent;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
//import mx.events.InterManagerRequest;
//import mx.events.InvalidateRequestData;
//import mx.events.Request;
//import mx.events.SWFBridgeEvent;
//import mx.events.SWFBridgeRequest;
import mx.managers.CursorManager;
//import mx.managers.IMarshalSystemManager;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.managers.SystemManagerGlobals;
import mx.styles.ISimpleStyleClient;
//import mx.utils.LoaderUtil;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when content loading is complete.
 *
 *  <p>This event is dispatched regardless of whether the load was triggered
 *  by an autoload or an explicit call to the <code>load()</code> method.</p>
 *
 *  @eventType org.apache.royale.events.Event.COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="complete", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when a network request is made over HTTP 
 *  and Flash Player or AIR can detect the HTTP status code.
 * 
 *  @eventType mx.events.HTTPStatusEvent.HTTP_STATUS
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="httpStatus", type="mx.events.HTTPStatusEvent")]

/**
 *  Dispatched when the properties and methods of a loaded SWF file 
 *  are accessible. The following two conditions must exist
 *  for this event to be dispatched:
 * 
 *  <ul>
 *    <li>All properties and methods associated with the loaded 
 *    object and those associated with the control are accessible.</li>
 *    <li>The constructors for all child objects have completed.</li>
 *  </ul>
 * 
 *  @eventType org.apache.royale.events.Event.INIT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="init", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when an input/output error occurs.
 *  @see mx.events.IOErrorEvent
 *
 *  @eventType mx.events.IOErrorEvent.IO_ERROR
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="ioError", type="mx.events.IOErrorEvent")]

/**
 *  Dispatched when a network operation starts.
 * 
 *  @eventType org.apache.royale.events.Event.OPEN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="open", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when content is loading.
 *
 *  <p>This event is dispatched regardless of whether the load was triggered
 *  by an autoload or an explicit call to the <code>load()</code> method.</p>
 *
 *  <p><strong>Note:</strong> 
 *  The <code>progress</code> event is not guaranteed to be dispatched.
 *  The <code>complete</code> event may be received, without any
 *  <code>progress</code> events being dispatched.
 *  This can happen when the loaded content is a local file.</p>
 *
 *  @eventType mx.events.ProgressEvent.PROGRESS
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="progress", type="mx.events.ProgressEvent")]

/**
 *  Dispatched when a security error occurs while content is loading.
 *  For more information, see the SecurityErrorEvent class.
 *
 *  @eventType mx.events.SecurityErrorEvent.SECURITY_ERROR
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="securityError", type="mx.events.SecurityErrorEvent")]

/**
 *  Dispatched when a loaded object is removed, 
 *  or when a second load is performed by the same SWFLoader control 
 *  and the original content is removed prior to the new load beginning.
 * 
 *  @eventType org.apache.royale.events.Event.UNLOAD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="unload", type="org.apache.royale.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The name of class to use as the SWFLoader border skin if the control cannot
 *  load the content.
 *  @default BrokenImageBorderSkin
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="brokenImageBorderSkin", type="Class", inherit="no")]

/**
 *  The name of the class to use as the SWFLoader skin if the control cannot load
 *  the content.
 *  The default value is the "__brokenImage" symbol in the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="brokenImageSkin", type="Class", inherit="no")]

/**
 *  The horizontal alignment of the content when it does not have
 *  a one-to-one aspect ratio.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *  @default "left"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  The vertical alignment of the content when it does not have
 *  a one-to-one aspect ratio.
 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
 *  and <code>"bottom"</code>.
 *  @default "top"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]

//--------------------------------------
//  Effects
//--------------------------------------

/**
 *  An effect that is started when the complete event is dispatched.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="completeEffect", event="complete")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="chromeColor", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="percentLoaded", destination="source")]

[DefaultTriggerEvent("progress")]

//[IconFile("SWFLoader.png")]

//[ResourceBundle("controls")]

/**
 *  The SWFLoader control loads and displays a specified SWF file.
 *  You typically use SWFLoader for loading one Flex application
 *  into a host Flex application.
 *
 *  <p><strong>Note:</strong> You can use the SWFLoader control to load
 *  a GIF, JPEG, or PNG image file at runtime, 
 *  to load a ByteArray representing a SWF, GIF, JPEG, or PNG image at runtime, 
 *  or load an embedded version of any of these file types, 
 *  and SVG files, at compile time
 *  by using <code>&#64;Embed(source='filename')</code>.
 *  However, the Image control is better suited for this capability
 *  and should be used for most image loading.
 *  The Image control is also designed to be used
 *  in custom item renderers and item editors. 
 *  When using either SWFLoader or Image with an SVG file,
 *  you can only load the SVG if it has been embedded in your
 *  application using an Embed statement;
 *  you cannot load an SVG from the network at runtime.</p>
 *
 *  <p>The SWFLoader control lets you scale its content and set its size. 
 *  It can also resize itself to fit the size of its content.
 *  By default, content is scaled to fit the size of the SWFLoader control.
 *  It can also load content on demand programmatically,
 *  and monitor the progress of a load.</p>  
 *
 *  <p>A SWFLoader control cannot receive focus.
 *  However, the contents of a SWFLoader control can accept focus
 *  and have its own focus interactions.</p>
 *
 *  <p>The SWFLoader control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Width and height large enough for the loaded content</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>Undefined</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The &lt;mx:SWFLoader&gt; tag inherits all of the tag attributes
 *  of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:SWFLoader
 *    <strong>Properties</strong>
 *    autoLoad="true|false"
 *    loadForCompatibility="false|true"
 *    loaderContext="null"
 *    maintainAspectRatio="true|false"
 *    scaleContent="true|false"
 *    showBusyCursor="false|true"
 *    source="<i>No default</i>"
 *    trustContent="false|true"
 *  
 *    <strong>Styles</strong>
 *    brokenImageBorderSkin="BrokenImageBorderSkin"
 *    brokenImageSkin="<i>'__brokenImage' symbol in Assets.swf</i>"
 *    horizontalAlign="left|center|right"
 *    verticalAlign="top|middle|bottom"
 *  
 *    <strong>Effects</strong>
 *    completeEffect="<i>No default</i>"
 *    
 *    <strong>Events</strong>
 *    complete="<i>No default</i>"
 *    httpStatus="<i>No default</i>"
 *    init="<i>No default</i>"
 *    ioError="<i>No default</i>"
 *    open="<i>No default</i>"
 *    progress="<i>No default</i>"
 *    securityError="<i>No default</i>"
 *    unload="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/local.mxml -noswf
 *  @includeExample examples/SimpleLoader.mxml
 *
 *  @see mx.controls.Image
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SWFLoader extends UIComponent //implements ISWFLoader
{
   // include "../core/Version.as";
    
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
    public function SWFLoader()
    {
        super();
        
        tabEnabled = false;
        tabFocusEnabled = false;
        
        //addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        //addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        //addEventListener(MouseEvent.CLICK, clickHandler);
        
        //showInAutomationHierarchy = false;
    }
	
	//----------------------------------
    //  source
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the source property.
     */
    private var _source:Object;
	private var contentChanged:Boolean = false;
    
    [Bindable("sourceChanged")]
    [Inspectable(category="General", defaultValue="", format="File")]
    
    /**
     *  The URL, object, class or string name of a class to
     *  load as the content.
     *  The <code>source</code> property takes the following form:
     *
     *  <p><pre>
     *  <code>source="<i>URLOrPathOrClass</i>"</code></pre></p>
     *
     *  <p><pre>
     *  <code>source="&#64;Embed(source='<i>PathOrClass</i>')"</code></pre></p>
     *
     *  <p>The value of the <code>source</code> property represents 
     *  a relative or absolute URL; a ByteArray representing a 
     *  SWF, GIF, JPEG, or PNG; an object that implements 
     *  IFlexDisplayObject; a class whose type implements IFlexDisplayObject;
     *  or a String that represents a class. </p> 
     *
     *  <p>When you specify a path to a SWF, GIF, JPEG, PNG, or SVG file,
     *  Flex automatically converts the file to the correct data type 
     *  for use with the SWFLoader control.</p> 
     *
     *  <p>If you omit the Embed statement, Flex loads the referenced file at runtime; 
     *  it is not packaged as part of the generated SWF file. 
     *  At runtime, the <code>source</code> property only supports the loading of
     *  GIF, JPEG, PNG images, and SWF files.</p>
     *
     *  <p>Flex Data Services users can use the SWFLoader control to 
     *  load a Flex application by using the following form:</p>
     *
     *  <p><pre>
     *  <code>source="<i>MXMLPath</i>.mxml.swf"</code></pre></p>
     *
     *  <p>Flex Data Services compiles the MXML file, 
     *  and returns the SWF file to the main application. This technique works well 
     *  with SWF files that add graphics or animations to an application, 
     *  but are not intended to have a large amount of user interaction. 
     *  If you import SWF files that require a large amount of user interaction, 
     *  you should build them as custom components. </p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():Object
    {
        return _source;
    }
    
    /**
     *  @private
     */
    public function set source(value:Object):void
    {
        if (_source != value)
        {
            _source = value;
            
            contentChanged = true;
            
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList()
            
            dispatchEvent(new Event("sourceChanged"));
        }
    }
}

}
