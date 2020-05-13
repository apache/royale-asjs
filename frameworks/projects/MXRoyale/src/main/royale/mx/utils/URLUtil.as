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

package mx.utils
{
    
    import mx.messaging.config.LoaderConfig;
    
    /**
     *  The URLUtil class is a static class with methods for working with
     *  full and relative URLs within Flex.
     *  
     *  @see mx.managers.BrowserManager
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class URLUtil
    {
        //--------------------------------------------------------------------------
        //
        // Private Static Constants
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private 
         */
        private static const SQUARE_BRACKET_LEFT:String = "]";
        private static const SQUARE_BRACKET_RIGHT:String = "[";
        private static const SQUARE_BRACKET_LEFT_ENCODED:String = encodeURIComponent(SQUARE_BRACKET_LEFT);
        private static const SQUARE_BRACKET_RIGHT_ENCODED:String = encodeURIComponent(SQUARE_BRACKET_RIGHT);
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        /**
         *  @private
         */
        public function URLUtil()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Returns the domain and port information from the specified URL.
         *  
         *  @param url The URL to analyze.
         *  @return The server name and port of the specified URL.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getServerNameWithPort(url:String):String
        {
            // Find first slash; second is +1, start 1 after.
            var start:int = url.indexOf("/") + 2;
            var length:int = url.indexOf("/", start);
            return length == -1 ? url.substring(start) : url.substring(start, length);
        }
        
        /**
         *  Returns the server name from the specified URL.
         *  
         *  @param url The URL to analyze.
         *  @return The server name of the specified URL.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getServerName(url:String):String
        {
            var sp:String = getServerNameWithPort(url);
            
            // If IPv6 is in use, start looking after the square bracket.
            var delim:int = URLUtil.indexOfLeftSquareBracket(sp);
            delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");   
            
            if (delim > 0)
                sp = sp.substring(0, delim);
            return sp;
        }
        
        /**
         *  Returns the port number from the specified URL.
         *  
         *  @param url The URL to analyze.
         *  @return The port number of the specified URL.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getPort(url:String):uint
        {
            var sp:String = getServerNameWithPort(url);
            // If IPv6 is in use, start looking after the square bracket.
            var delim:int = URLUtil.indexOfLeftSquareBracket(sp);
            delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");          
            var port:uint = 0;
            if (delim > 0)
            {
                var p:Number = Number(sp.substring(delim + 1));
                if (!isNaN(p))
                    port = int(p);
            }
            
            return port;
        }
        
        /**
         *  Converts a potentially relative URL to a fully-qualified URL.
         *  If the URL is not relative, it is returned as is.
         *  If the URL starts with a slash, the host and port
         *  from the root URL are prepended.
         *  Otherwise, the host, port, and path are prepended.
         *
         *  @param rootURL URL used to resolve the URL specified by the <code>url</code> parameter, if <code>url</code> is relative.
         *  @param url URL to convert.
         *
         *  @return Fully-qualified URL.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getFullURL(rootURL:String, url:String):String
        {
            if (url != null && !URLUtil.isHttpURL(url))
            {
                if (url.indexOf("./") == 0)
                {
                    url = url.substring(2);
                }
                if (URLUtil.isHttpURL(rootURL))
                {
                    var slashPos:Number;
                    
                    if (url.charAt(0) == '/')
                    {
                        // non-relative path, "/dev/foo.bar".
                        slashPos = rootURL.indexOf("/", 8);
                        if (slashPos == -1)
                            slashPos = rootURL.length;
                    }
                    else
                    {
                        // relative path, "dev/foo.bar".
                        slashPos = rootURL.lastIndexOf("/") + 1;
                        if (slashPos <= 8)
                        {
                            rootURL += "/";
                            slashPos = rootURL.length;
                        }
                    }
                    
                    if (slashPos > 0)
                        url = rootURL.substring(0, slashPos) + url;
                }
            }
            
            return url;
        }
        
        // Note: The following code was copied from Flash Remoting's
        // NetServices client components.
        // It is reproduced here to keep the services APIs
        // independent of the deprecated NetServices code.
        // Note that it capitalizes any use of URL in method or class names.
        
        /**
         *  Determines if the URL uses the HTTP, HTTPS, or RTMP protocol. 
         *
         *  @param url The URL to analyze.
         * 
         *  @return <code>true</code> if the URL starts with "http://", "https://", or "rtmp://".
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function isHttpURL(url:String):Boolean
        {
            return url != null &&
                (url.indexOf("http://") == 0 ||
                    url.indexOf("https://") == 0);
        }
        
        /**
         *  Determines if the URL uses the secure HTTPS protocol. 
         *
         *  @param url The URL to analyze.
         * 
         *  @return <code>true</code> if the URL starts with "https://".
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function isHttpsURL(url:String):Boolean
        {
            return url != null && url.indexOf("https://") == 0;
        }
        
        /**
         *  Returns the protocol section of the specified URL.
         *  The following examples show what is returned based on different URLs:
         *  
         *  <pre>
         *  getProtocol("https://localhost:2700/") returns "https"
         *  getProtocol("rtmp://www.myCompany.com/myMainDirectory/groupChatApp/HelpDesk") returns "rtmp"
         *  getProtocol("rtmpt:/sharedWhiteboardApp/June2002") returns "rtmpt"
         *  getProtocol("rtmp::1234/chatApp/room_name") returns "rtmp"
         *  </pre>
         *
         *  @param url String containing the URL to parse.
         *
         *  @return The protocol or an empty String if no protocol is specified.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function getProtocol(url:String):String
        {
            var slash:int = url.indexOf("/");
            var indx:int = url.indexOf(":/");
            if (indx > -1 && indx < slash)
            {
                return url.substring(0, indx);
            }
            else
            {
                indx = url.indexOf("::");
                if (indx > -1 && indx < slash)
                    return url.substring(0, indx);
            }
            
            return "";
        }
        
        /**
         *  Replaces the protocol of the
         *  specified URI with the given protocol.
         *
         *  @param uri String containing the URI in which the protocol
         *  needs to be replaced.
         *
         *  @param newProtocol String containing the new protocol to use.
         *
         *  @return The URI with the protocol replaced,
         *  or an empty String if the URI does not contain a protocol.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function replaceProtocol(uri:String,
                                               newProtocol:String):String
        {
            return uri.replace(getProtocol(uri), newProtocol);
        }
        
        /**
         *  Returns a new String with the port replaced with the specified port.
         *  If there is no port in the specified URI, the port is inserted.
         *  This method expects that a protocol has been specified within the URI.
         *
         *  @param uri String containing the URI in which the port is replaced.
         *  @param newPort uint containing the new port to subsitute.
         *
         *  @return The URI with the new port.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function replacePort(uri:String, newPort:uint):String
        {
            var result:String = "";
            
            // First, determine if IPv6 is in use by looking for square bracket
            var indx:int = uri.indexOf("]");
            
            // If IPv6 is not in use, reset indx to the first colon
            if (indx == -1)
                indx = uri.indexOf(":");
            
            var portStart:int = uri.indexOf(":", indx+1);
            var portEnd:int;
            
            // If we have a port
            if (portStart > -1)
            {
                portStart++; // move past the ":"
                portEnd = uri.indexOf("/", portStart);
                //@TODO: need to throw an invalid uri here if no slash was found
                result = uri.substring(0, portStart) +
                    newPort.toString() +
                    uri.substring(portEnd, uri.length);
            }
            else
            {
                // Insert the specified port
                portEnd = uri.indexOf("/", indx);
                if (portEnd > -1)
                {
                    // Look to see if we have protocol://host:port/
                    // if not then we must have protocol:/relative-path
                    if (uri.charAt(portEnd+1) == "/")
                        portEnd = uri.indexOf("/", portEnd + 2);
                    
                    if (portEnd > 0)
                    {
                        result = uri.substring(0, portEnd) +
                            ":"+ newPort.toString() +
                            uri.substring(portEnd, uri.length);
                    }
                    else
                    {
                        result = uri + ":" + newPort.toString();
                    }
                }
                else
                {
                    result = uri + ":"+ newPort.toString();
                }
            }
            
            return result;
        }
        
        /**
         *  Returns a new String with the port and server tokens replaced with
         *  the port and server from the currently running application.
         *
         *  @param url String containing the <code>SERVER_NAME_TOKEN</code> and/or <code>SERVER_NAME_PORT</code>
         *  which should be replaced by the port and server from the application.
         *
         *  @return The URI with the port and server replaced.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function replaceTokens(url:String):String
        {             
            var loaderURL:String = LoaderConfig.url == null ? "" : LoaderConfig.url;
            
            // if the LoaderConfig.url hasn't been configured yet we need to 
            // throw, informing the user that this value must be setup first
            // TODO: add this back in after each new player build
            //if (LoaderConfig.url == null)
            //    trace("WARNING: LoaderConfig.url hasn't been initialized.");
            
            // Replace {server.name}
            if (url.indexOf(SERVER_NAME_TOKEN) > 0)
            {
                loaderURL = URLUtil.replaceEncodedSquareBrackets(loaderURL);
                var loaderProtocol:String = URLUtil.getProtocol(loaderURL);
                var loaderServerName:String = "localhost";
                if (loaderProtocol.toLowerCase() != "file")
                    loaderServerName = URLUtil.getServerName(loaderURL);
                
                url = url.replace(SERVER_NAME_REGEX, loaderServerName);
            }
            
            // Replace {server.port} either with the loader's port, or
            // remove it and the proceeding token if a port is not
            // specified for the SWF Loader.
            var portToken:int = url.indexOf(SERVER_PORT_TOKEN);
            if (portToken > 0)
            {
                var loaderPort:uint = URLUtil.getPort(loaderURL);
                if (loaderPort > 0)
                {
                    url = url.replace(SERVER_PORT_REGEX, loaderPort);
                }
                else
                {
                    if (url.charAt(portToken - 1) == ":")
                        url = url.substring(0, portToken - 1) + url.substring(portToken);
                    
                    url = url.replace(SERVER_PORT_REGEX, "");
                }
            }
            
            COMPILE::JS
            {
            // Replace {context.root}
            if (url.indexOf(CONTEXT_ROOT_TOKEN) > 0)
            {
                var contextRoot:String = LoaderConfig.contextRoot;
                url = url.replace(CONTEXT_ROOT_REGEX, contextRoot);
            }
            }

            
            return url;
        }
        
        /**
         * Tests whether two URI Strings are equivalent, ignoring case and
         * differences in trailing slashes.
         * 
         *  @param uri1 The first URI to compare.
         *  @param uri2 The second URI to compare.
         *  
         *  @return <code>true</code> if the URIs are equal. Otherwise, <code>false</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function urisEqual(uri1:String, uri2:String):Boolean
        {
            if (uri1 != null && uri2 != null)
            {
                uri1 = StringUtil.trim(uri1).toLowerCase();
                uri2 = StringUtil.trim(uri2).toLowerCase();
                
                if (uri1.charAt(uri1.length - 1) != "/")
                    uri1 = uri1 + "/";
                
                if (uri2.charAt(uri2.length - 1) != "/")
                    uri2 = uri2 + "/";
            }
            
            return uri1 == uri2;
        }
        
        /**
         *  Given a url, determines whether the url contains the server.name and
         *  server.port tokens.
         *
         *  @param url A url string. 
         * 
         *  @return <code>true</code> if the url contains server.name and server.port tokens.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */ 
        public static function hasTokens(url:String):Boolean
        {
            if (url == null || url == "")
                return false;
            if (url.indexOf(SERVER_NAME_TOKEN) > 0)
                return true;
            if (url.indexOf(SERVER_PORT_TOKEN) > 0)
                return true;
            return false;
        }
        
        /**
         * If the <code>LoaderConfig.url</code> property is not available, the <code>replaceTokens()</code> method will not 
         * replace the server name and port properties properly.
         * 
         * @return <code>true</code> if the <code>LoaderConfig.url</code> property is not available. Otherwise, <code>false</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */  
        public static function hasUnresolvableTokens():Boolean
        {
            return LoaderConfig.url != null;
        }
        
        /**
         *  The pattern in the String that is passed to the <code>replaceTokens()</code> method that 
         *  is replaced by the application's server name.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const SERVER_NAME_TOKEN:String = "{server.name}";
        
        /**
         *  The pattern in the String that is passed to the <code>replaceTokens()</code> method that 
         *  is replaced by the application's port.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const SERVER_PORT_TOKEN:String = "{server.port}";
        
        /**
         *  The pattern in the String that is passed to the <code>replaceTokens()</code> method that 
         *  is replaced by the application's server name.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static const CONTEXT_ROOT_TOKEN:String = "{context.root}";
        
        /**
         *  Enumerates an object's dynamic properties (by using a <code>for..in</code> loop)
         *  and returns a String. You typically use this method to convert an ActionScript object to a String that you then append to the end of a URL.
         *  By default, invalid URL characters are URL-encoded (converted to the <code>%XX</code> format).
         *
         *  <p>For example:
         *  <pre>
         *  var o:Object = { name: "Alex", age: 21 };
         *  var s:String = URLUtil.objectToString(o,";",true);
         *  trace(s);
         *  </pre>
         *  Prints "name=Alex;age=21" to the trace log.
         *  </p>
         *  
         *  @param object The object to convert to a String.
         *  @param separator The character that separates each of the object's <code>property:value</code> pair in the String.
         *  @param encodeURL Whether or not to URL-encode the String.
         *  
         *  @return The object that was passed to the method.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function objectToString(object:Object, separator:String=';',
                                              encodeURL:Boolean = true):String
        {
            var s:String = internalObjectToString(object, separator, null, encodeURL);
            return s;
        }
        
        private static function indexOfLeftSquareBracket(value:String):int
        {
            var delim:int = value.indexOf(SQUARE_BRACKET_LEFT);
            if (delim == -1)
                delim = value.indexOf(SQUARE_BRACKET_LEFT_ENCODED);
            return delim;
        }
        
        private static function internalObjectToString(object:Object, separator:String, prefix:String, encodeURL:Boolean):String
        {
            var s:String = "";
            var first:Boolean = true;
            
            for (var p:String in object)
            {
                if (first)
                {
                    first = false;
                }
                else
                    s += separator;
                
                var value:Object = object[p];
                var name:String = prefix ? prefix + "." + p : p;
                if (encodeURL)
                    name = encodeURIComponent(name);
                
                if (value is String)
                {
                    s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
                }
                else if (value is Number)
                {
                    value = value.toString();
                    if (encodeURL)
                        value = encodeURIComponent(value as String);
                    
                    s += name + '=' + value;
                }
                else if (value is Boolean)
                {
                    s += name + '=' + (value ? "true" : "false");
                }
                else
                {
                    if (value is Array)
                    {
                        s += internalArrayToString(value as Array, separator, name, encodeURL);
                    }
                    else // object
                    {
                        s += internalObjectToString(value, separator, name, encodeURL);
                    }
                }
            }
            return s;
        }
        
        private static function replaceEncodedSquareBrackets(value:String):String
        {
            var rightIndex:int = value.indexOf(SQUARE_BRACKET_RIGHT_ENCODED);
            if (rightIndex > -1)
            {
                value = value.replace(SQUARE_BRACKET_RIGHT_ENCODED, SQUARE_BRACKET_RIGHT);
                var leftIndex:int = value.indexOf(SQUARE_BRACKET_LEFT_ENCODED);
                if (leftIndex > -1)
                    value = value.replace(SQUARE_BRACKET_LEFT_ENCODED, SQUARE_BRACKET_LEFT);
            }
            return value;
        }
        
        private static function internalArrayToString(array:Array, separator:String, prefix:String, encodeURL:Boolean):String
        {
            var s:String = "";
            var first:Boolean = true;
            
            var n:int = array.length;
            for (var i:int = 0; i < n; i++)
            {
                if (first)
                {
                    first = false;
                }
                else
                    s += separator;
                
                var value:Object = array[i];
                var name:String = prefix + "." + i;
                if (encodeURL)
                    name = encodeURIComponent(name);
                
                if (value is String)
                {
                    s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
                }
                else if (value is Number)
                {
                    value = value.toString();
                    if (encodeURL)
                        value = encodeURIComponent(value as String);
                    
                    s += name + '=' + value;
                }
                else if (value is Boolean)
                {
                    s += name + '=' + (value ? "true" : "false");
                }
                else
                {
                    if (value is Array)
                    {
                        s += internalArrayToString(value as Array, separator, name, encodeURL);
                    }
                    else // object
                    {
                        s += internalObjectToString(value, separator, name, encodeURL);
                    }
                }
            }
            return s;
        }
        
        /**
         *  Returns an object from a String. The String contains <code>name=value</code> pairs, which become dynamic properties
         *  of the returned object. These property pairs are separated by the specified <code>separator</code>.
         *  This method converts Numbers and Booleans, Arrays (defined by "[]"), 
         *  and sub-objects (defined by "{}"). By default, URL patterns of the format <code>%XX</code> are converted
         *  to the appropriate String character.
         *
         *  <p>For example:
         *  <pre>
         *  var s:String = "name=Alex;age=21";
         *  var o:Object = URLUtil.stringToObject(s, ";", true);
         *  </pre>
         *  
         *  Returns the object: <code>{ name: "Alex", age: 21 }</code>.
         *  </p>
         *  
         *  @param string The String to convert to an object.
         *  @param separator The character that separates <code>name=value</code> pairs in the String.
         *  @param decodeURL Whether or not to decode URL-encoded characters in the String.
         * 
         *  @return The object containing properties and values extracted from the String passed to this method.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function stringToObject(string:String, separator:String = ";",
                                              decodeURL:Boolean = true):Object
        {
            var o:Object = {};
            
            var arr:Array = string.split(separator);
            
            // if someone has a name or value that contains the separator 
            // this will not work correctly, nor will it work well if there are 
            // '=' or '.' in the name or value
            
            var n:int = arr.length;
            for (var i:int = 0; i < n; i++)
            {
                var pieces:Array = arr[i].split('=');
                var name:String = pieces[0];
                if (decodeURL)
                    name = decodeURIComponent(name);
                
                var value:Object = pieces[1];
                if (decodeURL)
                    value = decodeURIComponent(value as String);
                
                if (value == "true")
                    value = true;
                else if (value == "false")
                    value = false;
                else 
                {
                    var temp:Object = int(value);
                    if (temp.toString() == value)
                        value = temp;
                    else
                    {
                        temp = Number(value)
                        if (temp.toString() == value)
                            value = temp;
                    }
                }
                
                var obj:Object = o;
                
                pieces = name.split('.');
                var m:int = pieces.length;
                for (var j:int = 0; j < m - 1; j++)
                {
                    var prop:String = pieces[j];
                    if (obj[prop] == null && j < m - 1)
                    {
                        var subProp:String = pieces[j + 1];
                        var idx:Object = int(subProp);
                        if (idx.toString() == subProp)
                            obj[prop] = [];
                        else
                            obj[prop] = {};
                    }
                    obj = obj[prop];
                }
                obj[pieces[j]] = value;
            }
            
            return o;
        }
        
        // Reusable reg-exp for token replacement. The . means any char, so this means
        // we should handle server.name and server-name, etc...
        private static const SERVER_NAME_REGEX:RegExp = new RegExp("\\{server.name\\}", "g");
        private static const SERVER_PORT_REGEX:RegExp = new RegExp("\\{server.port\\}", "g");    
        private static const CONTEXT_ROOT_REGEX:RegExp = new RegExp("\\{context.root\\}", "g");    
    }
    
}