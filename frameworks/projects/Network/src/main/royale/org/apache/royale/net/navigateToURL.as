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
package org.apache.royale.net
{
   COMPILE::SWF{
       import flash.net.URLRequest;
       import flash.net.navigateToURL;
       import flash.net.URLRequestHeader;
   }

    COMPILE::SWF
    public function navigateToURL(request:org.apache.royale.net.URLRequest, windowName:String = null):void{
        var req:flash.net.URLRequest = new flash.net.URLRequest();
        req.url = request.url;
        req.data = request.data;
        req.method = request.method;
        req.contentType = request.contentType;
        var n:int = request.requestHeaders.length;
        for (var i:int; i < n; i++)
        {
            var hdr:flash.net.URLRequestHeader =
                    new flash.net.URLRequestHeader(req[i].name, req[i].value);
            req.requestHeaders.push(hdr);
        }
        flash.net.navigateToURL(req, windowName);
    }

    COMPILE::JS
    /**
     *  Opens or replaces a window in the application
     *
     *  @throws Error If the method is not called in response to a user action, such as a mouse event or keypress event.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function navigateToURL(request:URLRequest, windowName:String = null):void{
        var url:String = request.url;
        var needsPostSupport:Boolean;
        if (request.data) {
            if (HTTPConstants.POST == request.method) {
                needsPostSupport = true;

            } else if (HTTPConstants.GET == request.method){
                var append:String = url.lastIndexOf('?')!=-1 ? '&' : '?';
                url = url + append + request.data.toString();
            } else {
                throw new Error('unsupported request method in navigateToURL');
            }
        }
        var windowTarget:Window = window.open(needsPostSupport? "" : url, windowName);
        if (!windowTarget) throw new Error('navigateToURL requires interaction trigger');
        if (needsPostSupport) {
            var submittedForm:HTMLFormElement = doPostForm(url, windowName, request.data, request.contentType, request.method);
            if (!submittedForm) {
                throw new Error('unsupported contentType in navigateToURL', request.contentType);
            }
            submittedForm.parentNode.removeChild(submittedForm);
        }

    }
}



COMPILE::JS
/**
 *
 * @royaleignorecoercion HTMLFormElement
 * @royaleignorecoercion HTMLInputElement
 */
function doPostForm(url:String,target:String, values:Object, encoding:String,method:String):HTMLFormElement{
    //@todo check https://www.w3.org/TR/html-json-forms/
    import org.apache.royale.net.URLVariables;

    if (encoding == "application/json") {
        //trace('json encoding not yet supporteed todo:WIP');
        return null;
    }
    else if (encoding == "multipart/form-data") {
        //trace('multipart/form-data encoding not yet supporteed todo:WIP');
        return null;
    } else if (encoding == 'application/x-www-form-urlencoded') {
        //if it is a string, then decode it first
        if (values is String) values = new URLVariables(String(values) );
    } else {
        //trace('unknown/unsupported encoding', encoding);
        return null;
    }
    var form:HTMLFormElement = document.createElement('form') as HTMLFormElement;
    form.setAttribute('target', target);
    form.setAttribute('method', method);
    form.setAttribute('action', url);
    form.setAttribute('enctype', encoding);
    form.style.display = 'none';

    if (values) {
        for each(var key:String in Object.getOwnPropertyNames(values)) {
            var fakeField:HTMLInputElement = document.createElement('input') as HTMLInputElement;
            fakeField.setAttribute('type', 'hidden');
            fakeField.setAttribute('name', key);
            fakeField.setAttribute('value', values[key]);
            form.appendChild(fakeField);
        }
    }

    document.body.appendChild(form);
    form.submit();
    return form;
}
