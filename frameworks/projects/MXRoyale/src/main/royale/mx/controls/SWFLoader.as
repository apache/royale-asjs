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
import flash.display.Loader;
import flash.display.LoaderInfo;
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
import flash.system.Capabilities;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;
import mx.utils.org.ByteArray;

import mx.core.FlexGlobals;
import mx.core.FlexLoader;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.ILayoutDirectionElement;
import mx.core.ISWFLoader;
import mx.core.IUIComponent;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.InterManagerRequest;
import mx.events.InvalidateRequestData;
import mx.events.Request;
import mx.events.SWFBridgeEvent;
import mx.events.SWFBridgeRequest;
import mx.managers.CursorManager;
import mx.managers.IMarshalSystemManager;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.managers.SystemManagerGlobals;
import mx.styles.ISimpleStyleClient;
import mx.utils.LoaderUtil;

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

[IconFile("SWFLoader.png")]

[ResourceBundle("controls")]

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
public class SWFLoader extends UIComponent implements ISWFLoader
{
    include "../core/Version.as";
    
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
        
        addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(MouseEvent.CLICK, clickHandler);
        
        showInAutomationHierarchy = false;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    mx_internal var contentHolder:DisplayObject;
    
    /**
     *  @private
     */
    private var contentChanged:Boolean = false;
    
    /**
     *  @private
     */
    private var scaleContentChanged:Boolean = false;
    
    /**
     *  @private
     */
    private var smoothBitmapContentChanged:Boolean = false;
    
    /**
     *  @private
     */
    private var isContentLoaded:Boolean = false;
    
    /**
     *  @private
     */
    private var brokenImage:Boolean = false;
    
    /**
     *  @private
     */
    private var resizableContent:Boolean = false; // true if we've loaded a SWF
    
    /**
     *  @private
     */
    private var flexContent:Boolean = false; // true if we've loaded a Flex SWF
    
    /**
     *  @private
     */
    private var contentRequestID:String = null;
    
    /**
     *  @private
     */
    private var attemptingChildAppDomain:Boolean = false;
    
    /**
     *  @private
     */
    private var requestedURL:URLRequest;
    
    /**
     *  @private
     */
    private var brokenImageBorder:IFlexDisplayObject;
    
    /**
     *  @private
     */
    private var explicitLoaderContext:Boolean = false;
    
    /**
     *  @private
     */
    private var mouseShield:UIComponent;
    
    /**
     *  @private
     * 
     *  When unloading a swf, check this flag to see if we
     *  should use unload() or unloadAndStop().
     */
    private var useUnloadAndStop:Boolean;
    
    /**
     *  @private
     * 
     *  When using unloadAndStop, pass this flag
     *  as the gc parameter.
     */
    private var unloadAndStopGC:Boolean;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  autoLoad
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the autoLoad property.
     */
    private var _autoLoad:Boolean = true;
    
    [Bindable("autoLoadChanged")]
    [Inspectable(defaultValue="true")]
    
    /**
     *  A flag that indicates whether content starts loading automatically
     *  or waits for a call to the <code>load()</code> method.
     *  If <code>true</code>, the content loads automatically. 
     *  If <code>false</code>, you must call the <code>load()</code> method.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get autoLoad():Boolean
    {
        return _autoLoad;
    }
    
    /**
     *  @private
     */
    public function set autoLoad(value:Boolean):void
    {
        if (_autoLoad != value)
        {
            _autoLoad = value;
            
            contentChanged = true;
            
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            
            dispatchEvent(new Event("autoLoadChanged"));
        }
    }
    
    //----------------------------------
    //  loadForCompatibility
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the loadForCompatibility property.
     */
    private var _loadForCompatibility:Boolean = false;
    
    [Bindable("loadForCompatibilityChanged")]
    [Inspectable(defaultValue="false")]
    
    /**
     *  A flag that indicates whether the content is loaded so that it can
     *  interoperate with applications built with a different verion of the Flex compiler.  
     *  Compatibility with other Flex applications is accomplished by loading
     *  the application into a sibling (or peer) ApplicationDomain.
     *  This flag is ignored if the content must be loaded into a different
     *  SecurityDomain.
     *  If <code>true</code>, the content loads into a sibling ApplicationDomain. 
     *  If <code>false</code>, the content loaded into a child ApplicationDomain.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get loadForCompatibility():Boolean
    {
        return _loadForCompatibility;
    }
    
    /**
     *  @private
     */
    public function set loadForCompatibility(value:Boolean):void
    {
        if (_loadForCompatibility != value)
        {
            _loadForCompatibility = value;
            
            contentChanged = true;
            
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            
            dispatchEvent(new Event("loadForCompatibilityChanged"));
        }
    }
    
    //----------------------------------
    //  bytesLoaded (read only)
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the autoLoad property.
     */
    private var _bytesLoaded:Number = NaN;
    
    [Bindable("progress")]
    
    /**
     *  The number of bytes of the SWF or image file already loaded.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get bytesLoaded():Number
    {
        return _bytesLoaded;
    }
    
    //----------------------------------
    //  bytesTotal (read only)
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the bytesTotal property.
     */
    private var _bytesTotal:Number = NaN;
    
    [Bindable("complete")]
    
    /**
     *  The total size of the SWF or image file.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get bytesTotal():Number
    {
        return _bytesTotal;
    }
    
    //----------------------------------
    //  content (read only)
    //----------------------------------
    
    /**
     *  This property contains the object that represents
     *  the content that was loaded in the SWFLoader control. 
     *
     *  @tiptext Returns the content of the SWFLoader.
     *  @helpid 3134
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get content():DisplayObject
    {
        if (contentHolder is Loader)
            return Loader(contentHolder).content;
        
        return contentHolder;
    }
    
    //----------------------------------
    //  contentHeight
    //----------------------------------
    
    /**
     *  Height of the scaled content loaded by the control, in pixels. 
     *  Note that this is not the height of the control itself, but of the 
     *  loaded content. Use the <code>height</code> property of the control
     *  to obtain its height.
     *
     *  <p>The value of this property is not final when the <code>complete</code> event is triggered. 
     *  You can get the value after the <code>updateComplete</code> event is triggered.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get contentHeight():Number
    {
        return contentHolder ? contentHolder.height : NaN;
    }
    
    //----------------------------------
    //  contentHolderHeight (private)
    //----------------------------------
    
    /**
     *  @private
     */
    private function get contentHolderHeight():Number
    {
        // For externally loaded content, use the loaderInfo structure
        var loaderInfo:LoaderInfo;
        if (contentHolder is Loader)
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
        
        if (loaderInfo)
        {
            if (loaderInfo.contentType == "application/x-shockwave-flash")
            {
                try
                {
                    var mp:IMarshalSystemManager = 
                        IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
                    if (mp && mp.swfBridgeGroup)
                    {
                        var bridge:IEventDispatcher = swfBridge;
                        if (bridge)
                        {
                            var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                            bridge.dispatchEvent(request);
                            return request.data.height;
                        }
                    }
                    
                    var content:IFlexDisplayObject =
                        Loader(contentHolder).content as IFlexDisplayObject;
                    if (content)
                        return content.measuredHeight;
                }
                catch(error:Error)
                {
                    return contentHolder.height;
                }
            }
            else
            {
                try
                {
                    var testContent:DisplayObject = Loader(contentHolder).content;
                }
                catch(error:Error)
                {
                    return contentHolder.height;
                }
            }
            
            return loaderInfo.height;
        }
        
        // For internally loaded content, use preferredHeight (if present) or height
        if (contentHolder is IUIComponent)
            return IUIComponent(contentHolder).getExplicitOrMeasuredHeight();
        if (contentHolder is IFlexDisplayObject)
            return IFlexDisplayObject(contentHolder).measuredHeight;
        
        return contentHolder.height;
    }
    
    //----------------------------------
    //  contentHolderWidth (private)
    //----------------------------------
    
    /**
     *  @private
     */
    private function get contentHolderWidth():Number
    {
        // For externally loaded content, use the loaderInfo structure
        var loaderInfo:LoaderInfo;
        if (contentHolder is Loader)
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
        
        if (loaderInfo)
        {
            if (loaderInfo.contentType == "application/x-shockwave-flash")
            {
                try
                {
                    if (swfBridge)
                    {
                        var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                        swfBridge.dispatchEvent(request);
                        return request.data.width;
                    }
                    
                    var content:IFlexDisplayObject =
                        Loader(contentHolder).content as IFlexDisplayObject;
                    if (content)
                        return content.measuredWidth;
                }
                catch(error:Error)
                {
                    return contentHolder.width;
                }
            }
            else
            {
                try
                {
                    var testContent:DisplayObject = Loader(contentHolder).content;
                }
                catch(error:Error)
                {
                    return contentHolder.width;
                }
            }
            
            return loaderInfo.width;
        }
        
        // For internally loaded content, use explicitWidth (if present) or explicitWidth
        if (contentHolder is IUIComponent)
            return IUIComponent(contentHolder).getExplicitOrMeasuredWidth();
        if (contentHolder is IFlexDisplayObject)
            return IFlexDisplayObject(contentHolder).measuredWidth;
        
        return contentHolder.width;
    }
    
    //----------------------------------
    //  contentWidth
    //----------------------------------
    
    /**
     *  Width of the scaled content loaded by the control, in pixels. 
     *  Note that this is not the width of the control itself, but of the 
     *  loaded content. Use the <code>width</code> property of the control
     *  to obtain its width.
     *
     *  <p>The value of this property is not final when the <code>complete</code> event is triggered. 
     *  You can get the value after the <code>updateComplete</code> event is triggered.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get contentWidth():Number
    {
        return contentHolder ? contentHolder.width : NaN;
    }
    
    //----------------------------------
    //  loaderContext
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the loaderContext property.
     */
    private var _loaderContext:LoaderContext;
    
    [Bindable("loaderContextChanged")]
    [Inspectable(defaultValue="true")]
    
    /**
     *  A LoaderContext object to use to control loading of the content.
     *  This is an advanced property. 
     *  Most of the time you can use the <code>trustContent</code> property.
     *
     *  <p>The default value is <code>null</code>, which causes the control
     *  to use the <code>trustContent</code> property to create
     *  a LoaderContext object, which you can read back
     *  after the load starts.</p>
     *
     *  <p>To use a custom LoaderContext object, you must understand the 
     *  SecurityDomain and ApplicationDomain classes.
     *  Setting this property will not start a load;
     *  you must set this before the load starts.
     *  This does not mean that you have to set <code>autoLoad</code> property
     *  to <code>false</code>, because the load does not actually start
     *  immediately, but waiting for the <code>creationComplete</code> event 
     *  to set it is too late.</p>
     *
     *  @default null
     *  @see flash.system.LoaderContext
     *  @see mx.system.ApplicationDomain
     *  @see flash.system.SecurityDomain
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get loaderContext():LoaderContext
    {
        return _loaderContext;
    }
    
    /**
     *  @private
     */
    public function set loaderContext(value:LoaderContext):void
    {
        _loaderContext = value;
        explicitLoaderContext = true;
        
        dispatchEvent(new Event("loaderContextChanged"));
    }
    
    //----------------------------------
    //  maintainAspectRatio
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the maintainAspectRatio property.
     */
    private var _maintainAspectRatio:Boolean = true;
    
    [Bindable("maintainAspectRatioChanged")]
    [Inspectable(defaultValue="true")]
    
    /**
     *  A flag that indicates whether to maintain the aspect ratio
     *  of the loaded content.
     *  If <code>true</code>, specifies to display the image with the same ratio of
     *  height to width as the original image.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maintainAspectRatio():Boolean
    {
        return _maintainAspectRatio;
    }
    
    /**
     *  @private
     */
    public function set maintainAspectRatio(value:Boolean):void
    {
        _maintainAspectRatio = value;
        
        dispatchEvent(new Event("maintainAspectRatioChanged"));
    }
    
    
    //----------------------------------
    //  sandBoxBridge (read only)
    //----------------------------------
    private var _swfBridge:IEventDispatcher;
    
    //----------------------------------
    //  percentLoaded (read only)
    //----------------------------------
    
    [Bindable("progress")]
    
    /**
     *  The percentage of the image or SWF file already loaded.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get percentLoaded():Number
    {
        var p:Number = isNaN(_bytesTotal) || _bytesTotal == 0 ?
            0 :
            100 * (_bytesLoaded / _bytesTotal);
        
        if (isNaN(p))
            p = 0;
        
        return p;
    }
    
    //----------------------------------
    //  scaleContent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the scaleContent property.
     */
    private var _scaleContent:Boolean = true;
    
    [Bindable("scaleContentChanged")]
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  A flag that indicates whether to scale the content to fit the
     *  size of the control or resize the control to the content's size.
     *  If <code>true</code>, the content scales to fit the SWFLoader control.
     *  If <code>false</code>, the SWFLoader scales to fit the content. 
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get scaleContent():Boolean
    {
        return _scaleContent;
    }
    
    /**
     *  @private
     */
    public function set scaleContent(value:Boolean):void
    {
        if (_scaleContent != value)
        {
            _scaleContent = value;
            
            scaleContentChanged = true;
            invalidateDisplayList();
        }
        
        dispatchEvent(new Event("scaleContentChanged"));
    }
    
    //----------------------------------
    //  showBusyCursor
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the scaleContent property.
     */
    private var _showBusyCursor:Boolean = false;
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  A flag that indicates whether to show a busy cursor while
     *  the content loads.
     *  If <code>true</code>, shows a busy cursor while the content loads.
     *  The default busy cursor is the mx.skins.halo.BusyCursor
     *  as defined by the <code>busyCursor</code> property of the CursorManager class.
     *
     *  @default false
     *
     *  @see mx.managers.CursorManager
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showBusyCursor():Boolean
    {
        return _showBusyCursor;
    }
    
    /**
     *  @private
     */
    public function set showBusyCursor(value:Boolean):void
    {
        if (_showBusyCursor != value)
        {
            _showBusyCursor = value;
            
            if (_showBusyCursor)
                CursorManager.registerToUseBusyCursor(this);
            else
                CursorManager.unRegisterToUseBusyCursor(this);
        }
    }
    
    //----------------------------------
    //  smoothBitmapContent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the smoothBitmapContent property.
     */
    private var _smoothBitmapContent:Boolean = false;
    
    [Bindable("smoothBitmapContentChanged")]
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  A flag that indicates whether to smooth the content when it
     *  is scaled. Only Bitmap content can be smoothed.
     *  If <code>true</code>, and the content is a Bitmap then smoothing property 
     *  of the content is set to <code>true</code>. 
     *  If <code>false</code>, the content isn't smoothed. 
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get smoothBitmapContent():Boolean
    {
        return _smoothBitmapContent;
    }
    
    /**
     *  @private
     */
    public function set smoothBitmapContent(value:Boolean):void
    {
        if (_smoothBitmapContent != value)
        {
            _smoothBitmapContent = value;
            
            smoothBitmapContentChanged = true;
            invalidateDisplayList();
        }
        
        dispatchEvent(new Event("smoothBitmapContentChanged"));
    }
    
    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the source property.
     */
    private var _source:Object;
    
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
    
    //----------------------------------
    //  trustContent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the trustContent property.
     */
    private var _trustContent:Boolean = false;
    
    [Bindable("trustContentChanged")]
    [Inspectable(defaultValue="false")]
    
    /**
     *  If <code>true</code>, the content is loaded
     *  into your security domain.
     *  This means that the load fails if the content is in another domain
     *  and that domain does not have a crossdomain.xml file allowing your
     *  domain to access it. 
     *  This property only has an affect on the next load,
     *  it will not start a new load on already loaded content.
     *
     *  <p>The default value is <code>false</code>, which means load
     *  any content without failing, but you cannot access the content.
     *  Most importantly, the loaded content cannot 
     *  access your objects and code, which is the safest scenario.
     *  Do not set this property to <code>true</code> unless you are absolutely sure of the safety
     *  of the loaded content, especially active content like SWF files.</p>
     *
     *  <p>You can also use the <code>loaderContext</code> property
     *  to exactly determine how content gets loaded,
     *  if setting <code>trustContent</code> does not exactly
     *  meet your needs. 
     *  The <code>loaderContext</code> property causes the SWFLoader
     *  to ignore the value of the <code>trustContent</code> property.
     *  But, you should be familiar with the SecurityDomain
     *  and ApplicationDomain classes to use the <code>loaderContext</code> property.</p>
     *
     *  @default false
     *  @see flash.system.SecurityDomain
     *  @see mx.system.ApplicationDomain
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get trustContent():Boolean
    {
        return _trustContent;
    }
    
    /**
     *  @private
     */
    public function set trustContent(value:Boolean):void
    {
        if (_trustContent != value)
        {
            _trustContent = value;
            
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            
            dispatchEvent(new Event("trustContentChanged"));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties of ISWFBridgeProvider
    //
    //--------------------------------------------------------------------------
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get swfBridge():IEventDispatcher
    {
        return _swfBridge;
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get childAllowsParent():Boolean
    {
        if (!isContentLoaded)
            return false;
        
        try
        {
            if (contentHolder is Loader)
                return Loader(contentHolder).contentLoaderInfo.childAllowsParent;
        }
        catch (error:Error)
        {
            // Error #2099: The loading object is not sufficiently loaded to provide this information.
            // We can get this if this content has been unload
            return false;
        }
        
        return true;
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get parentAllowsChild():Boolean
    {
        if (!isContentLoaded)
            return false;
        
        try
        {
            if (contentHolder is Loader)
                return Loader(contentHolder).contentLoaderInfo.parentAllowsChild;
        }
        catch (error:Error)
        {
            // Error #2099: The loading object is not sufficiently loaded to provide this information.
            // We can get this if this content has been unload
            return false;
        }
        
        return true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (contentChanged)
        {
            contentChanged = false;
            
            if (_autoLoad)
                load(_source);
        }
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();
        
        if (isContentLoaded)
        {
            var oldScaleX:Number = contentHolder.scaleX;
            var oldScaleY:Number = contentHolder.scaleY;
            
            contentHolder.scaleX = 1.0;
            contentHolder.scaleY = 1.0;
            
            measuredWidth = contentHolderWidth;
            measuredHeight = contentHolderHeight;
            
            contentHolder.scaleX = oldScaleX;
            contentHolder.scaleY = oldScaleY;
        }
        else
        {
            // If we're in the process of loading new content,
            // keep the old measuredWidth/measuredHeight for now.
            // Otherwise, we size down to 0,0 for a frame and then
            // resize back up once the new content has loaded.
            // Bug 151518.
            if (!_source || _source == "")
            {
                measuredWidth = 0;
                measuredHeight = 0;
            }
        }
    }
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (contentChanged)
        {
            contentChanged = false;
            
            if (_autoLoad)
                load(_source);
        }
        
        if (isContentLoaded)
        {
            // We will either scale the content to the size of the SWFLoader,
            // or we will scale the loader to the size of the content.
            if (_scaleContent && !brokenImage)
                doScaleContent();
            else
                doScaleLoader();
            
            scaleContentChanged = false;
            
            if (smoothBitmapContentChanged) {
                doSmoothBitmapContent();
                smoothBitmapContentChanged = false;
            }
        }
        
        if (brokenImage && !brokenImageBorder)
        {
            var skinClass:Class = getStyle("brokenImageBorderSkin");
            if (skinClass)
            {
                brokenImageBorder = IFlexDisplayObject(new skinClass());
                if (brokenImageBorder is ISimpleStyleClient)
                    ISimpleStyleClient(brokenImageBorder).styleName = this;
                addChild(DisplayObject(brokenImageBorder));
            }
        }
        else if (!brokenImage && brokenImageBorder)
        {
            removeChild(DisplayObject(brokenImageBorder));
            brokenImageBorder = null;
        }
        
        if (brokenImageBorder)
            brokenImageBorder.setActualSize(unscaledWidth, unscaledHeight);
        
        sizeShield();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Loads an image or SWF file.
     *  The <code>url</code> argument can reference a GIF, JPEG, PNG,
     *  or SWF file; you cannot use this method to load an SVG file.
     *  Instead,  you must load it using an Embed statement
     *  with the <code>source</code> property.
     *
     *  @param url Absolute or relative URL of the GIF, JPEG, PNG,
     *  or SWF file to load.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function load(url:Object = null):void
    {
        if (url)
            _source = url;
        
        unloadContent();
        
        isContentLoaded = false;
        brokenImage = false;
        useUnloadAndStop = false;
        
        // Prevent double loading an app when properties are set and
        // then load() is called directly from application code instead
        // of from commitProperties().
        contentChanged = false;
        
        if (!_source || _source == "")
            return;
        
        loadContent(_source);
    }
    
    /**
     *  Unloads an image or SWF file. After this method returns the 
     *  <code>source</code> property will be null. This is only supported
     *  if the host Flash Player is version 10 or greater. If the host Flash 
     *  Player is less than version 10, then this method will unload the 
     *  content the same way as if <code>source</code> was set to null. 
     * 
     *  This method attempts to unload SWF files by removing references to 
     *  EventDispatcher, NetConnection, Timer, Sound, or Video objects of the
     *  child SWF file. As a result, the following occurs for the child SWF file
     *  and the child SWF file's display list: 
     *  <ul>
     *  <li>Sounds are stopped.</li>
     *  <li>Stage event listeners are removed.</li>
     *  <li>Event listeners for <code>enterFrame</code>, 
     *  <code>frameConstructed</code>, <code>exitFrame</code>,
     *  <code>activate</code> and <code>deactivate</code> are removed.</li>
     *  <li>Timers are stopped.</li>
     *  <li>Camera and Microphone instances are detached</li>
     *  <li>Movie clips are stopped.</li>
     *  </ul>
     * 
     *  @param invokeGarbageCollector  Provides a hint to the garbage collector to run
     *  on the child SWF objects (<code>true</code>) or not (<code>false</code>).
     *  If you are unloading many objects asynchronously, setting the 
     *  <code>gc</code> parameter to <code>false</code> might improve application
     *  performance. However, if the parameter is set to <code>false</code>, media
     *  and display objects of the child SWF file might persist in memory after
     *  the child SWF has been unloaded.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function unloadAndStop(invokeGarbageCollector:Boolean = true):void
    {
        useUnloadAndStop = true;
        unloadAndStopGC = invokeGarbageCollector;
        source = null;        // this will cause an unload unless autoload is true
        if (!autoLoad)
            load(null);
    }
    
    //--------------------------------------------------------------------------
    //
    //  ISWFLoader
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public function getVisibleApplicationRect(allApplications:Boolean=false):Rectangle
    {
        var rect:Rectangle = getVisibleRect();
        
        if (allApplications)
            rect = systemManager.getVisibleApplicationRect(rect);
        
        return rect;
    }
    
    
    /**
     *  @private
     *  
     *  Unload any existing content.
     */
    private function unloadContent():void
    {
        if (contentHolder)
        {
            if (isContentLoaded)
            {
                // can get rid of bitmap data if it's an image on unload
                // this helps with garbage collection (SDK-9533)
                var imageData:Bitmap;
                
                if (contentHolder is Loader)
                {
                    var contentLoader:Loader = Loader(contentHolder);
                    
                    try
                    {
                        if (contentLoader.content is Bitmap)
                        {
                            imageData = Bitmap(contentLoader.content);
                            if (imageData.bitmapData)
                                imageData.bitmapData = null; 
                        }
                    }
                    catch(error:Error)
                    {
                        // Ignore any errors trying to access the Bitmap
                        // b/c we may cause a security violation trying to do it
                    }
                    
                    if (_swfBridge)
                    {
                        var request:SWFBridgeEvent = new SWFBridgeEvent(
                            SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,
                            false, false,
                            _swfBridge);
                        _swfBridge.dispatchEvent(request);
                    }
                    
                    if (contentLoader.contentLoaderInfo.contentType == "application/x-shockwave-flash" &&
                        contentLoader.contentLoaderInfo.parentAllowsChild && 
                        contentLoader.contentLoaderInfo.childAllowsParent &&
                        contentLoader.content)
                    {
                        contentLoader.content.removeEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
                            contentHolder_getFlexModuleFactoryRequestHandler);            
                    }
                    
                    contentHolder.removeEventListener(Event.ADDED, contentHolder_addedHandler);
                    removeInitSystemManagerCompleteListener(contentLoader.contentLoaderInfo);
                    
                    if (useUnloadAndStop)
                        contentLoader.unloadAndStop(unloadAndStopGC);
                    else 
                        contentLoader.unload();
                    
                    if (!explicitLoaderContext)
                        _loaderContext = null;
                }
                else
                {
                    if (contentHolder is Bitmap)
                    {
                        imageData = Bitmap(contentHolder);
                        if (imageData.bitmapData)
                            imageData.bitmapData = null;
                    }
                }
            }
            else
            {
                if (contentHolder is Loader)
                {
                    try
                    {
                        Loader(contentHolder).close();
                    }
                    catch(error:Error)
                    {
                        // Ignore any errors thrown by close()
                    }
                }
            }
            
            // when SWFLoader/Image is used with renderer
            // recycling and the content is a DisplayObject instance
            // the instance can be stolen from us while
            // we're on the free list
            try
            {
                if (contentHolder.parent == this)
                    removeChild(contentHolder);
            }
            catch(error:Error)
            {
                try
                {
                    // just try to remove it anyway
                    removeChild(contentHolder);
                }
                catch(error1:Error)
                {
                    // Ignore any errors thrown by removeChild()
                }
            }
            
            contentHolder = null;
        }
        
    }
    
    /**
     *  @private
     *  If changes are made to this method, make sure to look at
     *  RectangularBorder.updateDisplayList()
     *  to see if changes are needed there as well.
     */
    private function loadContent(classOrString:Object):void
    {
        var child:DisplayObject;
        var cls:Class;
        var url:String;
        var byteArray:ByteArray;
        var loader:Loader;
        
        if (classOrString is Class)
        {
            // We've got a class. Use it.
            cls = Class(classOrString);
        }
        else if (classOrString is String)
        {
            // We've got a string. First we'll see if it is a class name,
            // otherwise just use the string.
            try
            {
                cls = Class(systemManager.getDefinitionByName(String(classOrString)));
            }
            catch(e:Error)
            { // ignore
            }
            url = String(classOrString);
        }
        else if (classOrString is ByteArray)
        {
            byteArray = ByteArray(classOrString);
        }
        else
        {
            // We have something that is not a class or string (XMLNode, for 
            // example). Call toString() and try to load it.
            url = classOrString.toString();
        }
        
        // Create a child UIComponent based on a class reference, such as Button.
        if (cls)
        {
            contentHolder = child = new cls();
            contentHolder.addEventListener(Event.ADDED, contentHolder_addedHandler, false, 0, true);
            addChild(child);
            contentLoaded();
        }
        else if (classOrString is DisplayObject)
        {
            contentHolder = child = DisplayObject(classOrString);
            addChild(child);
            contentLoaded();
            
            // Listen for requests to get the flex module factory.
            contentHolder.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
                contentHolder_getFlexModuleFactoryRequestHandler);            
        }
        else if (byteArray)
        {
            loader = new FlexLoader();
            contentHolder = child = loader;
            addChild(child);
            
            loader.contentLoaderInfo.addEventListener(
                Event.COMPLETE, contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(
                Event.INIT, contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(
                IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(
                Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
            
            // if loaderContext null, it will use default, which is AppDomain
            // of child of Loader's context
            loader.loadBytes(byteArray, loaderContext);
        }
        else if (url)
        {
            // Create an instance of the Flash Player Loader class to do all the work
            loader = new FlexLoader();
            contentHolder = child = loader;
            
            // addChild needs to be called before load()
            addChild(loader);
            
            // Forward the events from the Flash Loader to anyone
            // who has registered as an event listener on this Loader.
            loader.contentLoaderInfo.addEventListener(
                Event.COMPLETE, contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(
                HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusEventHandler);
            loader.contentLoaderInfo.addEventListener(
                Event.INIT, contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(
                IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(
                Event.OPEN, contentLoaderInfo_openEventHandler);
            loader.contentLoaderInfo.addEventListener(
                ProgressEvent.PROGRESS, contentLoaderInfo_progressEventHandler);
            loader.contentLoaderInfo.addEventListener(
                SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(
                Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
            
            // are we in a debug player and this was a debug=true request
            if ( (Capabilities.isDebugger == true) && 
                (url.indexOf(".jpg") == -1) && 
                (LoaderUtil.normalizeURL(
                    FlexGlobals.topLevelApplication.systemManager.loaderInfo).indexOf("debug=true") > -1) )
                url = url + ( (url.indexOf("?") > -1) ? "&debug=true" : "?debug=true" );
            
            // make relative paths relative to the SWF loading it, not the top-level SWF
            if (!(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
            {
                var rootURL:String;
                if (SystemManagerGlobals.bootstrapLoaderInfoURL != null && SystemManagerGlobals.bootstrapLoaderInfoURL != "")
                    rootURL = SystemManagerGlobals.bootstrapLoaderInfoURL;
                else if (root)
                    rootURL = LoaderUtil.normalizeURL(root.loaderInfo);
                else if (systemManager)
                    rootURL = LoaderUtil.normalizeURL(DisplayObject(systemManager).loaderInfo);
                
                url = LoaderUtil.OSToPlayerURI(url, LoaderUtil.isLocal(rootURL ? rootURL : url));
                if (rootURL)
                    url = LoaderUtil.createAbsoluteURL(rootURL, url);
            } else {
                url = LoaderUtil.OSToPlayerURI(url, LoaderUtil.isLocal(url));
            }
            
            requestedURL = new URLRequest(url);
            
            var lc:LoaderContext = loaderContext;
            if (!lc)
            {
                lc = new LoaderContext();
                _loaderContext = lc;
                
                var currentDomain:ApplicationDomain;
                
                // Try to use the application domain of this component from 
                // the moduleFactory. If we don't have a moduleFactory then 
                // fallback to using ApplicationDomain.currentDomain which 
                // could give us a parent ApplicationDomain of where the first
                // SWFLoader was used. If no SWFLoaders were used by parent
                // applications or modules then ApplicationDomain.currentDomain
                // will be correct.
                if (moduleFactory &&
                    FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
                    currentDomain = moduleFactory.info()["currentDomain"];
                else
                    currentDomain = ApplicationDomain.currentDomain;
                
                // To get a peer application domain (relative to framework classes), 
                // get the topmost parent domain of the current domain. This
                // will either be the application domain of the 
                // bootstrap loader (non-framework classes), or null. Either way we get
                // an application domain free of framework classes.
                if (loadForCompatibility) 
                {
                    // the AD.currentDomain.parentDomain could be null, 
                    // the domain of the top-level system manager, or
                    // the bootstrap loader. The bootstrap loader will always be topmost
                    // if it is present.
                    var appDomain:ApplicationDomain = currentDomain.parentDomain;
                    var topmostDomain:ApplicationDomain = null;
                    while (appDomain)
                    {
                        topmostDomain = appDomain;
                        appDomain = appDomain.parentDomain;
                    }
                    lc.applicationDomain = new ApplicationDomain(topmostDomain);
                }
                
                if (trustContent)
                {
                    lc.securityDomain = SecurityDomain.currentDomain;
                }
                else if (!loadForCompatibility)
                {
                    attemptingChildAppDomain = true;
                    // assume the best, which is that it is in the same domain and
                    // we can make it a child app domain.
                    lc.applicationDomain = new ApplicationDomain(currentDomain);
                }
            }
            
            loader.load(requestedURL, lc);
        }
        else
        {
            var message:String = resourceManager.getString(
                "controls", "notLoadable", [ source ]);
            throw new Error(message);
        }
        
        // contentHolder should inherit the layoutDirection
        // (sometimes its an asset which defaults to LTR). 
        if (contentHolder && contentHolder is ILayoutDirectionElement)
            ILayoutDirectionElement(contentHolder).layoutDirection = null;
        
        invalidateDisplayList();
    }
        
    /**
     *  @private
     *  Called when the content has successfully loaded.
     */
    protected function contentLoaded():void
    {
        isContentLoaded = true;
        
        // For externally loaded content, use the loaderInfo structure
        var loaderInfo:LoaderInfo;
        if (contentHolder is Loader)
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
        
        resizableContent = false;
        if (loaderInfo)
        {
            if (loaderInfo.contentType == "application/x-shockwave-flash")
                resizableContent = true;
            
            if (resizableContent)
            {
                try 
                {
                    if (Loader(contentHolder).content is IFlexDisplayObject)
                        flexContent = true;
                    else
                        flexContent = swfBridge != null;
                }
                catch(e:Error)
                {
                    // trace("contentLoader: " + e);
                    flexContent = swfBridge != null;
                }
            }
        }
        
        try
        {
            if (tabChildren &&
                contentHolder is Loader &&
                (loaderInfo.contentType == "application/x-shockwave-flash" ||
                    Loader(contentHolder).content is DisplayObjectContainer))
            {
                Loader(contentHolder).tabChildren = true;
                DisplayObjectContainer(Loader(contentHolder).content).tabChildren = true;
            }
        }
        catch(e:Error)
        {
            // eat security errors from x-domain content.
        }
        
        invalidateSize();
        invalidateDisplayList();
    }
    
    /**
     *  @private
     *  If scaleContent = true then two situations arise:
     *  1) the SWFLoader has explicitWidth/Height set so we
     *  simply scale or resize the content to those dimensions; or
     *  2) the SWFLoader doesn't have explicitWidth/Height.
     *  In this case we should have had our measure() method called
     *  which would set the measuredWidth/Height to that of the content,
     *  and when we pass through this code we should just end up at scale = 1.0.
     */
    private function doScaleContent():void
    {
        if (!isContentLoaded)
            return;
        
        // if not a SWF, then we scale it, otherwise we just set the size of the SWF.
        if (!resizableContent || (maintainAspectRatio && !flexContent))
        {
            // Make sure any previous scaling is undone.
            unScaleContent();
            
            // Scale the content to the size of the SWFLoader, preserving aspect ratio.
            var interiorWidth:Number = unscaledWidth;
            var interiorHeight:Number = unscaledHeight;
            var contentWidth:Number = contentHolderWidth;
            var contentHeight:Number = contentHolderHeight;
            
            var x:Number = 0;
            var y:Number = 0;
            
            // bug 84294 a swf may still not have size at this point
            var newXScale:Number = contentWidth == 0 ?
                1 :
                interiorWidth / contentWidth;
            var newYScale:Number = contentHeight == 0 ?
                1 :
                interiorHeight / contentHeight;
            
            var scale:Number;
            
            if (_maintainAspectRatio)
            {
                if (newXScale > newYScale)
                {
                    x = Math.floor((interiorWidth - contentWidth * newYScale) *
                        getHorizontalAlignValue());
                    scale = newYScale;
                }
                else
                {
                    y = Math.floor((interiorHeight - contentHeight * newXScale) *
                        getVerticalAlignValue());
                    scale = newXScale;
                }
                
                // Scale by the same amount in both directions.
                contentHolder.scaleX = scale;
                contentHolder.scaleY = scale;
            }
            else
            {
                contentHolder.scaleX = newXScale;
                contentHolder.scaleY = newYScale;
            }
            
            contentHolder.x = x;
            contentHolder.y = y;
        }
        else
        {
            contentHolder.x = 0;
            contentHolder.y = 0;
            
            var w:Number = unscaledWidth;
            var h:Number = unscaledHeight;
            
            if (contentHolder is Loader)
            {
                var holder:Loader = Loader(contentHolder);
                try
                {
                    // don't resize contentHolder until after it is layed out
                    if (getContentSize().x > 0)
                    {
                        var sizeSet:Boolean = false;
                        
                        if (holder.contentLoaderInfo.contentType == "application/x-shockwave-flash")
                        {
                            if (childAllowsParent)
                            {
                                if (holder.content is IFlexDisplayObject)
                                {
                                    IFlexDisplayObject(holder.content).setActualSize(w, h);
                                    sizeSet = true;
                                }
                            }
                            
                            if (!sizeSet && swfBridge) 
                            {
                                swfBridge.dispatchEvent(new SWFBridgeRequest(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST, 
                                    false, false, null,
                                    { width: w, height: h}));
                                sizeSet = true;
                            }                               
                        }
                        
                        if (!sizeSet)
                        {
                            // Bug 142705 - we can't just set width and height here. If the SWF content
                            // does not fill the stage, the width/height of the content holder is NOT
                            // the same as the loaderInfo width/height. If we just set width/height
                            // here is can scale the content in unpredictable ways.
                            var lInfo:LoaderInfo = holder.contentLoaderInfo;
                            
                            if (lInfo)
                            {
                                contentHolder.scaleX = w / lInfo.width;
                                contentHolder.scaleY = h / lInfo.height;
                            }
                            else
                            {
                                contentHolder.width = w;
                                contentHolder.height = h;
                            }
                        }
                    }
                    else if (childAllowsParent &&
                        !(holder.content is IFlexDisplayObject))
                    {
                        contentHolder.width = w;
                        contentHolder.height = h;
                    }
                }
                catch(error:Error)
                {
                    contentHolder.width = w;
                    contentHolder.height = h;
                }
                
                if (!parentAllowsChild)
                    contentHolder.scrollRect = new Rectangle(0, 0, 
                        w / contentHolder.scaleX, 
                        h / contentHolder.scaleY);
            }
            else
            {
                contentHolder.width = w;
                contentHolder.height = h;
            }
        }
    }
    
    /**
     *  @private
     *  If scaleContent = false then two situations arise:
     *  1) the SWFLoader has been given explicitWidth/Height so we don't change
     *  the size of the SWFLoader and simply place the content at 0,0
     *  and don't scale it and clip it if needed; or
     *  2) the SWFLoader does not have explicitWidth/Height in which case
     *  our measure() method should have been called and we should have
     *  been given the right size.
     *  However if some other constraint applies we simply clip as in
     *  situation #1, which is why there is only one code path in here.
     */
    private function doScaleLoader():void
    {
        if (!isContentLoaded)
            return;
        
        unScaleContent();
        
        var w:Number = unscaledWidth;
        var h:Number = unscaledHeight;
        
        if ((contentHolderWidth > w) ||
            (contentHolderHeight > h) ||
            !parentAllowsChild)
        {
            contentHolder.scrollRect = new Rectangle(0, 0, w, h);
        }
        else
        {
            contentHolder.scrollRect = null;
        }
        
        contentHolder.x = (w - contentHolderWidth) * getHorizontalAlignValue();
        contentHolder.y = (h - contentHolderHeight) * getVerticalAlignValue();
    }
    
    /**
     *  @private
     */
    private function doSmoothBitmapContent():void
    {
        if (content is Bitmap) 
            (content as Bitmap).smoothing = _smoothBitmapContent;
    }
    
    /**
     *  @private
     */
    private function unScaleContent():void
    {
        contentHolder.scaleX = 1.0;
        contentHolder.scaleY = 1.0;
        contentHolder.x = 0;
        contentHolder.y = 0;
    }
    
    
    /**
     *  @private
     */
    private function getHorizontalAlignValue():Number
    {
        var horizontalAlign:String = getStyle("horizontalAlign");
        
        if (horizontalAlign == "left")
            return 0;
        else if (horizontalAlign == "right")
            return 1;
        
        // default = center
        return 0.5;
    }
    
    /**
     *  @private
     */
    private function getVerticalAlignValue():Number
    {
        var verticalAlign:String = getStyle("verticalAlign");
        
        if (verticalAlign == "top")
            return 0;
        else if (verticalAlign == "bottom")
            return 1;
        
        // default = middle
        return 0.5;
    }
    
    /**
     *  @private
     *  
     *  Dispatch an invalidate request to a parent application using
     *  a sandbox bridge.
     */     
    private function dispatchInvalidateRequest(invalidateProperites:Boolean,
                                               invalidateSize:Boolean,
                                               invalidateDisplayList:Boolean):void
    {
        var sm:ISystemManager = systemManager;
        var mp:IMarshalSystemManager = 
            IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
        if (!mp || !mp.useSWFBridge())
            return;
        
        var bridge:IEventDispatcher = mp.swfBridgeGroup.parentBridge;
        var flags:uint = 0;
        
        if (invalidateProperites)
            flags |= InvalidateRequestData.PROPERTIES;
        if (invalidateSize)
            flags |= InvalidateRequestData.SIZE;
        if (invalidateDisplayList)
            flags |= InvalidateRequestData.DISPLAY_LIST;
        
        var request:SWFBridgeRequest = new SWFBridgeRequest(
            SWFBridgeRequest.INVALIDATE_REQUEST,
            false, false,
            bridge,
            flags);
        bridge.dispatchEvent(request);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function initializeHandler(event:FlexEvent):void
    {
        if (contentChanged)
        {
            contentChanged = false;
            
            if (_autoLoad)
                load(_source);
        }
    }
    
    /**
     *  @private
     */
    private function addedToStageHandler(event:Event):void
    {
        systemManager.getSandboxRoot().addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST, 
            mouseShieldHandler, false, 0, true);
    }
    
    
    /**
     *  @private
     */
    mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void
    {
        // Sometimes we interrupt a load to start another load after
        // the bytes are in but before the complete event is dispatched.
        // In this case we get an IOError when we call close()
        // and the complete event is dispatched anyway.
        // Meanwhile we've started the new load.
        // We ignore the complete if the contentHolder doesn't match
        // because that means it was for the old content
        if (LoaderInfo(event.target).loader != contentHolder)
            return;
        
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
        
        contentLoaded();
        
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_httpStatusEventHandler(
        event:HTTPStatusEvent):void
    {
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_initEventHandler(event:Event):void
    {
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
        
        // if we are loading a swf listen of a message if it ends up needing to
        // use a sandbox bridge to communicate.
        var loaderInfo:LoaderInfo = LoaderInfo(event.target);
        addInitSystemManagerCompleteListener(loaderInfo.loader.contentLoaderInfo);
        
        // Listen for requests to get the flex module factory.
        if (loaderInfo.contentType == "application/x-shockwave-flash" &&
            loaderInfo.parentAllowsChild && loaderInfo.childAllowsParent && 
            loaderInfo.content)
        {
            loaderInfo.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
                contentHolder_getFlexModuleFactoryRequestHandler);            
        }
        
    }
    
    
    /**
     *  @private
     * 
     *  If we are loading a swf, listen for a message from the swf telling us it was loading
     *  into an application domain where it needs to use a sandbox bridge to communicate.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function addInitSystemManagerCompleteListener(loaderInfo:LoaderInfo):void
    {
        if (loaderInfo.contentType == "application/x-shockwave-flash")
        {
            var bridge:EventDispatcher = loaderInfo.sharedEvents;
            bridge.addEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION, 
                initSystemManagerCompleteEventHandler);
        }
    }
    
    /**
     *  @private
     * 
     *  Remove the listener after the swf is loaded.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function removeInitSystemManagerCompleteListener(loaderInfo:LoaderInfo):void
    {
        if (loaderInfo.contentType == "application/x-shockwave-flash")
        {
            var bridge:EventDispatcher = loaderInfo.sharedEvents;                   
            bridge.removeEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION, 
                initSystemManagerCompleteEventHandler);
        }
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_ioErrorEventHandler(
        event:IOErrorEvent):void
    {
        // Error loading content, show the broken image.
        source = getStyle("brokenImageSkin");
        
        // Force the load of the broken image skin here, since that will
        // clear the brokenImage flag. After the image is loaded we set
        // the brokenImage flag.
        load();
        contentChanged = false;
        brokenImage = true;
        
        // Redispatch the event from this SWFLoader,
        // but only if there is a listener.
        // If there are no listeners for ioError event,
        // a runtime error is displayed.
        if (hasEventListener(event.type))
            dispatchEvent(event);
        
        if (contentHolder is Loader)
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
        
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_openEventHandler(event:Event):void
    {
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_progressEventHandler(
        event:ProgressEvent):void
    {
        _bytesTotal = event.bytesTotal;
        _bytesLoaded = event.bytesLoaded;
        
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_securityErrorEventHandler(
        event:SecurityErrorEvent):void
    {
        if (attemptingChildAppDomain)
        {
            attemptingChildAppDomain = false;
            var lc:LoaderContext = new LoaderContext();
            _loaderContext = lc;
            callLater(load);
            return;
        }
        
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
        
        if (contentHolder is Loader)
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
    }
    
    /**
     *  @private
     */
    private function contentLoaderInfo_unloadEventHandler(event:Event):void
    {
        isContentLoaded = false;
        
        // Redispatch the event from this SWFLoader.
        dispatchEvent(event);
        
        // remove the sandbox bridge if we had one.
        if (_swfBridge)
        {
            _swfBridge.removeEventListener(SWFBridgeRequest.INVALIDATE_REQUEST, 
                invalidateRequestHandler);
            
            var sm:ISystemManager = systemManager;
            var mp:IMarshalSystemManager = 
                IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.removeChildBridge(_swfBridge);
            _swfBridge = null;
        }
    }
    
    /**
     *  @private
     * 
     *  @param request Use type Event instead of Request because the event may be send from
     *  another ApplicationDomain (A.2).
     */
    private function contentHolder_getFlexModuleFactoryRequestHandler(request:Event):void
    {
        if ("value" in request)
            request["value"] = moduleFactory;
    }
    
    /**
     *  @private
     * 
     *  Used when we are loading a class. If the embedded class is a SWF, then wait for
     *  the added event where the target is a IFlexModuleFactory. This will be message after
     *  the event for the class being added. 
     * 
     *  All this is done to support the module factory parent request when loading an 
     *  embedded swf.
     */
    private function contentHolder_addedHandler(event:Event):void
    {
        if (event.target == contentHolder)
            return;  // wait for next message
        
        if (event.target is IFlexModuleFactory)
        {
            // Listen for requests to get the flex module factory.
            event.target.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, 
                contentHolder_getFlexModuleFactoryRequestHandler);            
        }
        
        contentHolder.removeEventListener(Event.ADDED, contentHolder_addedHandler);
    }
    
    /**
     *  @private
     * 
     *  Message dispatched from System Manager. This gives us the child bridge
     *  of the application we loaded.
     */
    private function initSystemManagerCompleteEventHandler(event:Event):void
    {
        var eObj:Object = Object(event);
        
        // make sure this is the child we created by checking the loader info.
        if (contentHolder is Loader && 
            eObj.data == Loader(contentHolder).contentLoaderInfo.sharedEvents)
        {
            _swfBridge = Loader(contentHolder).contentLoaderInfo.sharedEvents;
            
            flexContent = true;
            // if we got validated before we got this event
            // then we might have accidentally scaled the loader
            unScaleContent();
            
            var sm:ISystemManager = systemManager;
            IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager")).addChildBridge(_swfBridge, this);
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            
            _swfBridge.addEventListener(SWFBridgeRequest.INVALIDATE_REQUEST, 
                invalidateRequestHandler);
        }
    }
    
    
    /**
     *  @private
     * 
     *  Handle invalidate requests send from the child using the
     *  sandbox bridge. 
     * 
     */  
    private function invalidateRequestHandler(event:Event):void
    {
        if (event is SWFBridgeRequest)
            return;
        
        // handle request
        var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
        
        var invalidateFlags:uint = uint(request.data);        
        
        if (invalidateFlags & InvalidateRequestData.PROPERTIES)
            invalidateProperties();
        
        if (invalidateFlags & InvalidateRequestData.SIZE)
            invalidateSize();
        
        if (invalidateFlags & InvalidateRequestData.DISPLAY_LIST)
            invalidateDisplayList();
        
        // redispatch the request up the parent chain
        dispatchInvalidateRequest(
            (invalidateFlags & InvalidateRequestData.PROPERTIES) != 0,
            (invalidateFlags & InvalidateRequestData.SIZE) != 0,
            (invalidateFlags & InvalidateRequestData.DISPLAY_LIST) != 0);
    }
    
    
    /**
     *      @private
     * 
     *      Put up or takedown a mouseshield that covers the content
     *  of the application we loaded.
     */
    private function mouseShieldHandler(event:Event):void
    {
        if (event["name"] != "mouseShield")
            return;
        
        if (!isContentLoaded || parentAllowsChild)
            return;
        
        if (event["value"])
        {
            if (!mouseShield)
            {
                mouseShield = new UIComponent();
                mouseShield.graphics.beginFill(0, 0);
                mouseShield.graphics.drawRect(0, 0, 100, 100);
                mouseShield.graphics.endFill();
            }
            if (!mouseShield.parent)
                addChild(mouseShield);
            sizeShield();
        }
        else
        {
            if (mouseShield && mouseShield.parent)
                removeChild(mouseShield)
        }
    }
    
    /**
     *      @private
     * 
     *      size the shield if needed
     */
    private function sizeShield():void
    {
        if (mouseShield && mouseShield.parent)
        {
            mouseShield.width = unscaledWidth;
            mouseShield.height = unscaledHeight;
        }
    }
    
    /**
     *  @private
     * 
     *  Just push this change, wholesale, onto the loaded content, if the
     *  content is another Flex SWF
     */
    override public function regenerateStyleCache(recursive:Boolean):void
    {
        super.regenerateStyleCache(recursive);
        
        try
        {
            var sm:ISystemManager = content as ISystemManager;
            if (sm != null)
            {
                var cm:Object = sm.getImplementation("mx.managers::ISystemManagerChildManager");
                Object(cm).regenerateStyleCache(recursive);
            }
        }
        catch(error:Error)
        {
            // Ignore any errors trying to access the content
            // b/c we may cause a security violation trying to do it
            // Also ignore if the sm doesn't have a regenerateStyleCache method
        }
    }
    
    /**
     *  @private
     * 
     *  Just push this change, wholesale, onto the loaded content, if the
     *  content is another Flex SWF
     */
    override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void
    {
        super.notifyStyleChangeInChildren(styleProp, recursive);
        
        try
        {
            var sm:ISystemManager = content as ISystemManager;
            if (sm != null)
            {
                var cm:Object = sm.getImplementation("mx.managers::ISystemManagerChildManager");
                Object(cm).notifyStyleChangeInChildren(styleProp, recursive);
            }
        }
        catch(error:Error)
        {
            // Ignore any errors trying to access the content
            // b/c we may cause a security violation trying to do it
            // Also ignore if the sm doesn't have a notifyStyleChangeInChildren method
        }
    }
    
    /**
     *  @private 
     *  @throws Error - #2099 if the content has been unloaded 
     */    
    private function getContentSize():Point
    {
        var pt:Point = new Point();
        
        if (!contentHolder is Loader)
            return pt;
        
        var holder:Loader = Loader(contentHolder);
        if (holder.contentLoaderInfo.childAllowsParent)
        {
            pt.x = holder.content.width;
            pt.y = holder.content.height;
        }
        else
        {
            var bridge:IEventDispatcher = swfBridge;
            if (bridge)
            {
                var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                bridge.dispatchEvent(request);
                pt.x = request.data.width;
                pt.y = request.data.height;
            }
        }
        
        // don't return zero out of here otherwise the Loader's scale goes to zero
        if (pt.x == 0)
            pt.x = holder.contentLoaderInfo.width;
        if (pt.y == 0)
            pt.y = holder.contentLoaderInfo.height;
        
        return pt;
    }
    
    /**
     *  @private
     *  The default handler for the <code>MouseEvent.CLICK</code> event.
     *
     *  @param The event object.
     */    
    protected function clickHandler(event:MouseEvent):void
    {
        if (!enabled)
        {
            // Prevent the propagation of click from a disabled component.
            // This is conceptually a higher-level event and
            // developers will expect their click handlers not to fire
            // if the Button is disabled.
            event.stopImmediatePropagation();
            return;
        }
    }      
}

}
