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

package mx.managers
{

//import flash.events.IEventDispatcher;
import org.apache.royale.events.IEventDispatcher;
/**
 *  Dispatched when the URL is changed either
 *  by the user interacting with the browser, invoking an
 *  application in AIR, or by setting the property programmatically.
 *
 *  @eventType flash.events.Event.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="change", type="flash.events.Event")]

/**
 *  Dispatched when the URL is changed
 *  by the browser.
 *
 *  @eventType mx.events.BrowserChangeEvent.BROWSER_URL_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="browserURLChange", type="mx.events.BrowserChangeEvent")]

/**
 *  Dispatched when the URL is changed
 *  by the application.
 *
 *  @eventType mx.events.BrowserChangeEvent.URL_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="urlChange", type="mx.events.BrowserChangeEvent")]

/**
 *  The interface that the shared instance of the BrowserManager
 *  implements. Applications listen for events,
 *  call methods, and access properties on the shared instance
 *  which is accessed with the <code>BrowserManager.getInstance()</code> method.
 * 
 *  @see mx.managers.BrowserManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public interface IBrowserManager extends org.apache.royale.events.IEventDispatcher
{
 
 function setTitle(value:String):void;
 
 

   
}

}

