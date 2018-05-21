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

package mx.events
{

//import flash.events.Event;
//import flash.events.ProgressEvent;
import mx.modules.IModuleInfo;
import org.apache.royale.events.Event;
import org.apache.royale.events.ProgressEvent;

/**
 *  The ModuleEvent class represents the event object passed to the event listener
 *  for events related to dynamically-loaded modules. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class ModuleEvent extends ProgressEvent
{
//
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Dispatched when there is an error downloading the module.
     *  The <code>ModuleEvent.ERROR</code> constant defines the value of the
     *  <code>type</code> property of the event object for an <code>error</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>bytesLoaded</code></td><td>Empty</td></tr>
     *     <tr><td><code>bytesTotal</code></td><td>Empty</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>errorText</code></td><td>The error message.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType error
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ERROR:String = "error";

    /**
     *  Dispatched when the module is in the process of downloading. This module is
     *  dispatched at regular intervals during the download process.
     *  The <code>ModuleEvent.PROGRESS</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>progress</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>bytesLoaded</code></td><td>The number of bytes loaded.</td></tr>
     *     <tr><td><code>bytesTotal</code></td><td>The total number of bytes to load.</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>errorText</code></td><td>Empty</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType progress
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const PROGRESS:String = "progress";

    /**
     *  Dispatched when the module has finished downloading.     
     *  The <code>ModuleEvent.READY</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>complete</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>bytesLoaded</code></td><td>The number of bytes loaded.</td></tr>
     *     <tr><td><code>bytesTotal</code></td><td>The total number of bytes to load.</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>errorText</code></td><td>Empty</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType ready
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const READY:String = "ready";

    /**
     *  Dispatched when enough of a module has been downloaded that you can get information
     *  about the module. You do this by calling the <code>IFlexModuleFactory.info()</code>
     *  method on the module.
     *  The <code>ModuleEvent.SETUP</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>setup</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>bytesLoaded</code></td><td>Empty</td></tr>
     *     <tr><td><code>bytesTotal</code></td><td>Empty</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>errorText</code></td><td>An error message.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType setup
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const SETUP:String = "setup";

    /**
     *  Dispatched when the module is unloaded.
     *
     *  The <code>ModuleEvent.UNLOAD</code> constant defines the value of the
     *  <code>type</code> property of the event object for an <code>unload</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>bytesLoaded</code></td><td>Empty</td></tr>
     *     <tr><td><code>bytesTotal</code></td><td>Empty</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>errorText</code></td><td>An error message.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType unload
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const UNLOAD:String = "unload";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     *  @param type The type of event. Possible values are:
     *  <ul>
     *     <li>"progress" (<code>ModuleEvent.PROGRESS</code>);</li>
     *     <li>"ready" (<code>ModuleEvent.READY</code>);</li>
     *     <li>"setup" (<code>ModuleEvent.SETUP</code>);</li>
     *     <li>"error" (<code>ModuleEvent.ERROR</code>);</li>
     *     <li>"unload" (<code>ModuleEvent.UNLOAD</code>);</li>
     *  </ul>
     *
     *  @param bubbles Determines whether the Event object
     *  participates in the bubbling stage of the event flow.
     *
     *  @param cancelable Determines whether the Event object can be cancelled
     *  during event propagation.
     *
     *  @param bytesLoaded The number of bytes loaded
     *  at the time the listener processes the event.
     *
     *  @param bytesTotal The total number of bytes
     *  that will be loaded if the loading process succeeds.
     *
     *  @param errorText The error message when the event type 
     *  is <code>ModuleEvent.ERROR</code>.
     *
     *  @param module An instance of an interface for a particular module. .
     *
     *  @tiptext Constructor for <code>ModuleEvent</code> objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */    
	
    public function ModuleEvent(type:String, bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                bytesLoaded:uint = 0, bytesTotal:uint = 0,
                                errorText:String = null, module:IModuleInfo = null)
    {
        super(type, bubbles, cancelable, bytesLoaded, bytesTotal);

        this.errorText = errorText;
        this._module = module;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  errorText
    //----------------------------------

    /**
     *  The error message if the type is <code>ModuleEvent.ERROR</code>;
     *  otherwise, it is <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    public var errorText:String;
	
    //----------------------------------
    //  module
    //----------------------------------

    private var _module:IModuleInfo;

    /**
     *  The <code>target</code>, which is an instance of an
     *  interface for a particular module.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	
    public function get module():IModuleInfo
    {
        if (_module) return _module;
        //return target as IModuleInfo;
		return _module;
    }

}

}
