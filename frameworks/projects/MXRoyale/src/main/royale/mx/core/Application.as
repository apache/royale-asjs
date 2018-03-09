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
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.ContextMenuEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.Capabilities;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.setInterval;

import mx.containers.utilityClasses.ApplicationLayout;
import mx.effects.EffectManager;
import mx.events.FlexEvent;
import mx.managers.FocusManager;
import mx.managers.IActiveWindowManager;
import mx.managers.ILayoutManager;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.utils.LoaderUtil;
import mx.utils.Platform;

use namespace mx_internal;
*/
import org.apache.royale.express.Application;
    
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched after the Application has been initialized,
 *  processed by the LayoutManager, and attached to the display list.
 * 
 *  @eventType mx.events.FlexEvent.APPLICATION_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="applicationComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when an HTTPService call fails.
 * 
 *  @eventType flash.events.ErrorEvent.ERROR
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="error", type="flash.events.ErrorEvent")]


//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="direction", kind="property")]
[Exclude(name="icon", kind="property")]
[Exclude(name="label", kind="property")]
[Exclude(name="tabIndex", kind="property")]
[Exclude(name="toolTip", kind="property")]
[Exclude(name="x", kind="property")]
[Exclude(name="y", kind="property")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  The frameworks must be initialized by SystemManager.
 *  This factoryClass will be automatically subclassed by any
 *  MXML applications that don't explicitly specify a different
 *  factoryClass.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Frame(factoryClass="mx.managers.SystemManager")]

[DefaultProperty("mxmlContent")]

/**
 *  Flex defines a default, or Application, container that lets you start
 *  adding content to your application without explicitly defining
 *  another container.
 *  Flex creates this container from the <code>&lt;mx:Application&gt;</code>
 *  tag, the first tag in an MXML application file.
 *  While you might find it convenient to use the Application container
 *  as the only  container in your application, in most cases you explicitly
 *  define at least one more container before you add any controls
 *  to your application.
 *
 *  <p>Applications support a predefined plain style that sets
 *  a white background, left alignment, and removes all margins.
 *  To use this style, do the following:</p>
 *
 *  <pre>
 *    &lt;mx:Application styleName="plain" /&gt;
 *  </pre>
 *
 *  <p>This is equivalent to setting the following style attributes:</p>
 *
 *  <pre>
 *    backgroundColor="0xFFFFFF"
 *    horizontalAlign="left"
 *    paddingLeft="0"
 *    paddingTop="0"
 *    paddingBottom="0"
 *    paddingRight="0"
 *  </pre>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Application&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Application
 *    <strong>Properties</strong>
 *    application="<i>No default</i>"
 *    controlBar="null"
 *    frameRate="24"
 *    historyManagementEnabled="true|false"
 *    layout="vertical|horizontal|absolute"
 *    pageTitle"<i>No default</i>"
 *    preloader="<i>No default</i>"
 *    resetHistory="false|true"
 *    scriptRecursionLimit="1000"
 *    scriptTimeLimit="60"
 *    usePreloader="true|false"
 *    viewSourceURL=""
 *    xmlns:<i>No default</i>="<i>No default</i>"
 * 
 *    <strong>Styles</strong> 
 *    backgroundGradientAlphas="[ 1.0, 1.0 ]"
 *    backgroundGradientColors="undefined"
 *    horizontalAlign="center|left|right"
 *    horizontalGap="8"
 *    modalTransparency="0.5"
 *    modalTransparencyBlur="3"
 *    modalTransparencyColor="#DDDDDD"
 *    modalTransparencyDuration="100"
 *    paddingBottom="24"
 *    paddingTop="24"
 *    verticalAlign="top|bottom|middle"
 *    verticalGap="6"
 *  
 *    <strong>Events</strong>
 *    applicationComplete="<i>No default</i>"
 *    error="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SimpleApplicationExample.mxml
 *  
 *  @see mx.managers.CursorManager
 *  @see mx.managers.LayoutManager
 *  @see mx.managers.SystemManager
 *  @see flash.events.EventDispatcher
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Application extends org.apache.royale.express.Application
{

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    /**
     *  A reference to the top-level application.
     *
     *  <p>In general, there can be a hierarchy of Application objects,
     *  because an Application can use a SWFLoader control to dynamically
     *  load another Application.
     *  The <code>parentApplication</code> property of a UIComponent can be
     *  used to access the sub-Application in which that UIComponent lives,
     *  and to walk up the hierarchy to the top-level Application.</p>
     *  
     *  <p>This property has been deprecated starting in Flex4. Note that this
     *  property will still return applications of type mx.core.Application and 
     *  mx.core.WindowedApplication as in previous versions. Starting in Flex 4
     *  it will also return applications of type spark.components.Application or 
     *  spark.components.WindowedApplication.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /*
     *  Note: here are two reasons that 'application' is typed as Object
     *  rather than as Application. The first is for consistency with
     *  the 'parentApplication' property of UIComponent. That property is not
     *  typed as Application because it would make UIComponent dependent
     *  on Application, slowing down compile times not only for SWCs
     *  for also for MXML and AS components. Second, if it were typed
     *  as Application, authors would not be able to access properties
     *  and methods in the <Script> of their <Application> without
     *  casting it to their application's subclass, as in
     *  MyApplication(Application.application).myAppMethod().
     *  Therefore we decided to dispense with strict typing for
     *  'application'.
     */
    public static function get application():Object
    {
        return FlexGlobals.topLevelApplication;
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
     *  @productversion Flex 3
     */
    public function Application()
    {
        if (!FlexGlobals.topLevelApplication)
            FlexGlobals.topLevelApplication = this;

        super();

        instanceParent = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function initialize():void
    {
        initManagers();
        super.initialize();
    }
    
    /**
     *  @private
     */
    private function initManagers():void
    {
        // install FocusManager
    }

    /**
     *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var mxmlContent:Array;

}

}
