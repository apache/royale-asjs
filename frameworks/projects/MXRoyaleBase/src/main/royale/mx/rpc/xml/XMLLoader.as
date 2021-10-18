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

package mx.rpc.xml
{

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

import mx.core.mx_internal;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.XMLLoadEvent;
import mx.rpc.http.HTTPService;
import mx.utils.URLUtil;

use namespace mx_internal;

[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="xmlLoad", type="mx.rpc.events.XMLLoadEvent")]

[ExcludeClass]

/**
 * Base class to help manage loading of an XML document at runtime.
 * @private
 */
public class XMLLoader extends EventDispatcher
{
    public function XMLLoader(httpService:HTTPService = null)
    {
        super();

        initializeService(httpService);
    }

    /**
     * Asynchronously loads an XML document for the given URL.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function load(url:String):void
    {
        url = getQualifiedLocation(url);
        internalLoad(url);
    }

    protected function initializeService(httpService:HTTPService = null):void
    {
        loader = new HTTPService();

        if (httpService != null)
        {
            loader.asyncRequest = httpService.asyncRequest;
            if (httpService.destination != null)
                loader.destination = httpService.destination;
            loader.useProxy = httpService.useProxy;
            loader.rootURL = httpService.rootURL;
            loader.headers = httpService.headers;
        }

        loader.addEventListener(ResultEvent.RESULT, resultHandler);
        loader.addEventListener(FaultEvent.FAULT, faultHandler);
        loader.resultFormat = HTTPService.RESULT_FORMAT_E4X;
    }

    protected function internalLoad(location:String):AsyncToken
    {
        loadsOutstanding++;

        loader.url = location;
        var token:AsyncToken = loader.send();

        if (token != null)
            token.location = location;

        return token;
    }

    protected function getQualifiedLocation(location:String, 
        parentLocation:String = null):String
    {
        if (parentLocation != null)
            location = URLUtil.getFullURL(parentLocation, location);
        else
            location = URLUtil.getFullURL(loader.rootURL, location);

        return location;
    }

    /**
     * If a fault occured trying to load the XML document, a FaultEvent
     * is simply redispatched.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function faultHandler(event:FaultEvent):void
    {
        loadsOutstanding--;
        dispatchEvent(event);
    }

    /**
     * Dispatches an XMLLoadEvent with the XML formatted result
     * and location (if known).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function resultHandler(event:ResultEvent):void
    {
        loadsOutstanding--;

        var xml:XML = XML(event.result);
        var token:AsyncToken = event.token;
        var location:String = token == null ? null : token.location;
        var xmlLoadEvent:XMLLoadEvent = XMLLoadEvent.createEvent(xml, location);

        dispatchEvent(xmlLoadEvent);
    }

    protected var loader:HTTPService;
    public var loadsOutstanding:int;
}
    
}