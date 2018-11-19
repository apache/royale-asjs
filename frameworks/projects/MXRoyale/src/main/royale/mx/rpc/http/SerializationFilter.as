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

package mx.rpc.http 
{

import mx.core.mx_internal;
import mx.messaging.errors.ArgumentError;

use namespace mx_internal;

/**
 * This class is useful for framework developers wishing to plug in or modify the
 * HTTP services to use a new serialization format.  This allows you to invoke
 * methods on the service object and control how parameters are mapped to a specific
 * serialiation format such as XML, JSON, etc.  The SerializationFilter mechanism
 * allows you to add a new resultFormat as well.
 * 
 * <p> An instance of this class can manage formatting HTTP requests, responses, and
 * converting their parameters.  When you use HTTPService or HTTPMultiService, you 
 * are usually talking to a server which expects the data to be provided in a specific
 * format - for example, URL encoded values for a type HTML form, XML values or another
 * serialization format such as JSON.  SerializationFilter 
 * allows you to customize how HTTPService and HTTPMultiService convert an operation's
 * parameters into the body of the HTTP request and how the response is converted into
 * the return value of the operation.  Framework developers can introduce a new serialization
 * format to the system by providing a new implementation of the SerializationFilter and
 * use these components and all of the frameworks and tools built on these components
 * without having to know the details of the format itself. </p>
 * 
 * <p>The first thing you do is to extend the SerializationFilter and override one or more
 * of the conversion methods.   The filter allows you to turn the ordered list of parameters
 * into a request body, modify the request body, modify the content type used in the
 * request, modify the actual URL used in the request, and convert the response data into
 * the result object returned in the result event of the service.</p>
 * 
 * <p>There are two ways to specify the SerializationFilter for a particular HTTPService,
 * or HTTPMultiService.  You can either set the serializationFilter property on the service
 * or you can statically register a SerializationFilter for a new result format.  If you
 * use this approach, simply by specifying the resultFormat you can use a pre-registered
 * SerializationFilter.  So for example, you might register a SerializationFilter for the
 * "json" type and can then use that filter by setting resultFormat="json".</p>
 *
 * <p>
 * Note that HTTPService only provides methods which directly take the request body
 * and so does not use the "serializeParameters" method.
 * </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SerializationFilter
{
    // replaces/returns previous with that name or null
    static mx_internal var filterForResultFormatTable:Object = {};

    /**
     * This static function is used to register a new SerializationFilter for a 
     * particular resultFormat value.  If you call this method once at startup,
     * you can then just specify the resultFormat property of an HTTPService or HTTPMultiService
     * to use that serialization filter to make it easier for developers to specify a
     * format.
     *
     * @param resultFormat A custom resultFormat name to be associated with the supplied
     * SerializationFilter.  
     * @param filter The SerializationFilter to register.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function registerFilterForResultFormat(resultFormat:String, filter:SerializationFilter):SerializationFilter
    {
        var old:SerializationFilter = filterForResultFormatTable[resultFormat];
        filterForResultFormatTable[resultFormat] = filter;
        return old;
    }


    /**
     * This method takes the result from the HTTP request in a raw format.  It 
     * can convert it to a more fully typed ActionScript object if desired.  
     * To make the SerializationFilter more general, you can use the resultType or 
     * resultElementType properties of the AbstractOperation provided so your code can 
     * dynamically map the incoming request to the type configured in ActionScript as
     * the return type.
     * <p>
     * Note also that AbstractOperation has a "properties" map which you
     * can use to store additional properties as part of the service invocation
     * in ActionScript to handle the deserialization of a particular type.
     * </p>
     * 
     * @param operation The AbstractOperation which is being invoked.  
     * @param result the raw result as returned from the server.  
     * @return the converted result which will then be supplied in the result event
     * for the service.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function deserializeResult(operation:AbstractOperation, result:Object):Object
    {
        return result;
    }

    /**
     * This method is called by the HTTP service just before a call is made.  Its role
     * is to choose the contentType used for this request.  For many serialization
     * formats, there is a single fixed content type so you might just return that content
     * type here.  Since the HTTPService is itself configured with a content type, that
     * value is passed in here and returned by the default implementation.  The request
     * body being serialized is also provided with the obj parameter just in case the 
     * content type depends on the type of object being sent to the server.
     *
     * @param operation The AbstractionOperation being invoked.
     * @param obj the body of the HTTP request being serialized
     * @param contentType the contentType configured for the operation
     * @return the content type to use for this HTTP request.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getRequestContentType(operation:AbstractOperation, obj:Object, contentType:String):String
    {
        return contentType;
    }

    /**
     * This method is called from the "send" method of the HTTP service invocation to convert the
     * parameters into a request body.  The parameters of the original send call are put into the
     * params array.  This method converts this set of parameters into to a single object which is used as the 
     * data for the HTTP request body.  The default implementation produces an object where the 
     * keys are the values in the Operation's argumentNames array and the values are the values of the parameters.
     * When using the default implementation, you must set argumentNames to have the same number
     * of elements as the parameters array.
     * 
     * <p>Note that this method is not used if you invoke the HTTP operation using the sendBody
     * method which just takes a single object.  In that case, this step is skipped and only
     * the serializeBody method is called.</p>
     *
     * @param operation The AbstractOperation being invoked.
     * @param params the list of parameters passed to the send method
     * @return the body to be used in the HTTP request
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function serializeParameters(operation:AbstractOperation, params:Array):Object
    {
        var argNames:Array = operation.argumentNames;

        if (params == null || params.length == 0)
            return params;

        if (argNames == null || params.length != argNames.length)
            throw new ArgumentError("HTTPMultiService operation called with " + (argNames == null ? 0 : argNames.length) + " argumentNames and " + params.length + " number of parameters.  When argumentNames is specified, it must match the number of arguments passed to the invocation");

        var obj:Object = new Object();
        for (var i:int = 0; i < argNames.length; i++)
            obj[argNames[i]] = params[i];

        return obj;
    }

    /**
     * This method is called for all invocations of the HTTP service.  It is able to convert
     * the supplied object into a form suitable for placing directly in the HTTP's request
     * body.  The default implementation just returns the object passed in as the body without
     * any conversion.
     *
     * @param operation The AbstractOperation being invoked
     * @param obj the initial body of the HTTP request, either the return value of serializeParameters or the parameter to the sendBody method
     * or the send method of HTTPService.
     * @return the potentially converted body to use in the request.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function serializeBody(operation:AbstractOperation, obj:Object):Object
    {
        return obj;
    }

    /**
     * This method is used if you need to take data from the request body object and encode
     * it into the URL string.  It is given the incoming URL as configured on the operation
     * or service.  This implementation just returns the incoming URL without any conversion.
     *
     * @param operation The AbstractOperation being invoked
     * @param url the URL set on the service or operation
     * @return the potentially modified URL to use for this request.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function serializeURL(operation:AbstractOperation, obj:Object, url:String):String
    {
        return url;
    }
}

}
