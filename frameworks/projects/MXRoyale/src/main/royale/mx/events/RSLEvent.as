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

//import flash.display.LoaderInfo;
import org.apache.royale.events.Event;
import org.apache.royale.net.URLRequest;

/**
 *  The RSLEvent class represents an event object used by the 
 *  DownloadProgressBar class when an RSL is being downloaded by the Preloader class. 
 *
 *  @see mx.preloaders.DownloadProgressBar
 *  @see mx.preloaders.Preloader
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class RSLEvent extends ProgressEvent
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

    /**
     *  The <code>RSLEvent.RSL_ADD_PRELOADED</code> constant defines the value of the
     *  <code>type</code> property of the event object for an 
     *  <code>rslAddPreloaded</code> event. This event is dispatched from an 
     *  IFlexModuleFactory after a child IFlexModuleFactory preloads an RSL
     *  into its application domain. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>loaderInfo</code></td><td>The LoaderInfo instance 
     *     associated with this RSL.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType rslAddPreloaded
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.5
     */
    public static const RSL_ADD_PRELOADED:String = "rslAddPreloaded";
    
	/**
	 *  Dispatched when the RSL has finished downloading. 	
	 *  The <code>RSLEvent.RSL_COMPLETE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>rslComplete</code> event.
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
     *     <tr><td><code>isResourceModule</code></td><td>True if we loaded a resourceModule
	 *        instead of an RSL</td></tr>
     *     <tr><td><code>rslIndex</code></td><td>The index number of the RSL 
     *       currently being downloaded. </td></tr>
     *     <tr><td><code>rslTotal</code></td><td>The total number of RSLs 
     *       being downloaded. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>url</code></td><td>The URLRequest object that represents 
     *       the location of the RSL being downloaded.</td></tr>
	 *  </table>
	 *
     *  @eventType rslComplete
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const RSL_COMPLETE:String = "rslComplete";
	
	/**
	 *  Dispatched when there is an error downloading the RSL.
	 *  The <code>RSLEvent.RSL_ERROR</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>rslError</code> event.
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
     *     <tr><td><code>errorText</code></td>An error message.<td></td></tr>
     *     <tr><td><code>isResourceModule</code></td><td>True if we loaded a resourceModule
	 *        instead of an RSL</td></tr>
     *     <tr><td><code>rslIndex</code></td><td>The index number of the RSL 
     *       currently being downloaded. </td></tr>
     *     <tr><td><code>rslTotal</code></td><td>The total number of RSLs 
     *       being downloaded. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>url</code></td><td>The URLRequest object that represents 
     *       the location of the RSL being downloaded.</td></tr>
	 *  </table>
	 *
     *  @eventType rslError
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const RSL_ERROR:String = "rslError";

	/**
	 *  Dispatched when the RSL is downloading.
	 *  The <code>RSLEvent.RSL_PROGRESS</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>rslProgress</code> event.
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
     *     <tr><td><code>errorText</code></td>Empty<td></td></tr>
     *     <tr><td><code>isResourceModule</code></td><td>True if we loaded a resourceModule
	 *        instead of an RSL</td></tr>
     *     <tr><td><code>rslIndex</code></td><td>The index number of the RSL 
     *       currently being downloaded. </td></tr>
     *     <tr><td><code>rslTotal</code></td><td>The total number of RSLs 
     *       being downloaded. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>url</code></td><td>The URLRequest object that represents 
     *       the location of the RSL being downloaded.</td></tr>
	 *  </table>
	 *
     *  @eventType rslProgress
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const RSL_PROGRESS:String = "rslProgress"; 
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 * 
	 *  @param type The type of the event. Possible values are:
	 *  <ul>
	 *     <li>"rslProgress" (<code>RSLEvent.RSL_PROGRESS</code>);</li>
	 *     <li>"rslComplete" (<code>RSLEvent.RSL_COMPLETE</code>);</li>
	 *     <li>"rslError" (<code>RSLEvent.RSL_ERROR</code>);</li>
	 *  </ul>
	 *
	 *  @param bubbles  Determines whether the Event object participates in the bubbling stage of the event flow.
	 *
	 *  @param cancelable Determines whether the Event object can be cancelled.
	 *
	 *  @param bytesLoaded The number of bytes loaded at the time the listener processes the event.
	 *
	 *  @param bytesTotal The total number of bytes that will ultimately be loaded if the loading process succeeds.
	 *
	 *  @param rslIndex The index number of the RSL relative to the total. This should be a value between 0 and <code>total - 1</code>.
	 *
	 *  @param rslTotal The total number of RSLs being loaded.
	 *
	 *  @param url The location of the RSL.
	 *
	 *  @param errorText The error message of the error when type is RSLEvent.RSL_ERROR.
	 *
	 *  @param isResourceModule True if the event occurred when loading a ResourceModule.
	 *
	 *  @tiptext Constructor for <code>RSLEvent</code> objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */	
	public function RSLEvent(type:String,  bubbles:Boolean = false,
							 cancelable:Boolean = false,
							 bytesLoaded:int = -1, bytesTotal:int = -1,
							 rslIndex:int = -1, rslTotal:int = -1,
							 url:URLRequest = null, errorText:String = null,
							 isResourceModule:Boolean = false,
                             loaderInfo:Object = null)
	{
		super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
		
		this.rslIndex = rslIndex;
		this.rslTotal = rslTotal;
		this.url = url;
		this.errorText = errorText;
		this.isResourceModule = isResourceModule;
        this.loaderInfo = loaderInfo;
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
	 *  The error message if the type is RSL_ERROR; otherwise, it is null;
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var errorText:String;
	
    //----------------------------------
	//  isResourceModule
	//----------------------------------

	/**
	 *  True if the event is for loading a resourceModule instead of an RSL
	 */
	public var isResourceModule:Boolean;
	
    //----------------------------------
    //  loaderInfo
    //----------------------------------
    
    /**
     *  The loaderInfo associated with this event. This is only set in the 
     *  RSLEvent.RSL_COMPLETE event. Otherwise loaderInfo will be null.
     */
    //public var loaderInfo:LoaderInfo;
    public var loaderInfo:Object;

    //----------------------------------
	//  rslIndex
	//----------------------------------

	/**
	 *  The index number of the RSL currently being downloaded.
	 *  This is a number between 0 and <code>rslTotal - 1</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var rslIndex:int;

	//----------------------------------
	//  rslTotal
	//----------------------------------

	/**
	 *  The total number of RSLs being downloaded by the preloader
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var rslTotal:int;
	
	//----------------------------------
	//  url
	//----------------------------------

	/**
	 *  The URLRequest object that represents the location
	 *  of the RSL being downloaded.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var url:URLRequest;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function cloneEvent():Event
	{
		return new RSLEvent(type, bubbles, cancelable,
							bytesLoaded, bytesTotal, rslIndex,
							rslTotal, url, errorText, isResourceModule,
                            loaderInfo);
	}
}

}
