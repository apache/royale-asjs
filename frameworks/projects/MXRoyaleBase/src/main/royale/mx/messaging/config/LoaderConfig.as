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

package mx.messaging.config
{
COMPILE::SWF
{
import flash.display.DisplayObject;
}
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;

use namespace mx_internal;

[ExcludeClass]
[Mixin]

/**
 *  @private
 *  This class acts as a context for the messaging framework so that it
 *  has access the URL and arguments of the SWF without needing
 *  access to the root MovieClip's LoaderInfo or Flex's Application
 *  class.
 */
public class LoaderConfig
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  class initialization
    //
    //--------------------------------------------------------------------------
    
    COMPILE::SWF
    public static function init(root:DisplayObject):void
    {
        // if somebody has set this in our applicationdomain hierarchy, don't overwrite it
        if (!_url)
        {
            _url = root.loaderInfo.url;
            _parameters = root.loaderInfo.parameters;
            _swfVersion = root.loaderInfo.swfVersion;
        }
    }
    
    COMPILE::JS
    public static function init(root:Object):void
    {
        // if somebody has set this in our applicationdomain hierarchy, don't overwrite it
        if (!_url)
        {
            if (root is IFlexModuleFactory)
                _contextRoot = (root as IFlexModuleFactory).info()["contextRoot"];
            
            _url = location.href;
            _parameters = {};
            var query:String = location.search.substring(1);
            if(query)
            {
                var vars:Array = query.split("&");
                for (var i:int=0;i<vars.length;i++) {
                    var pair:Array = vars[i].split("=");
                    _parameters[pair[0]] = decodeURIComponent(pair[1]);
                }
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>One instance of LoaderConfig is created by the SystemManager. 
     *  You should not need to construct your own.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LoaderConfig()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  contextRoot
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the contextRoot property.
     */
    COMPILE::JS
    mx_internal static var _contextRoot:String = null;
    
    /**
     *  If the LoaderConfig has been initialized, this
     *  should represent the contextRoot specified at compile time.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0
     */
    COMPILE::JS
    public static function get contextRoot():String
    {
        return _contextRoot;
    }
    
    //----------------------------------
    //  parameters
    //----------------------------------

    /**
     *  @private
     *  Storage for the parameters property.
     */
    mx_internal static var _parameters:Object;

    /**
     *  If the LoaderConfig has been initialized, this
     *  should represent the top-level MovieClip's parameters.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function get parameters():Object
    {
        return _parameters;
    }

    //----------------------------------
    //  swfVersion
    //----------------------------------

    mx_internal static var _swfVersion:uint;

    /**
     *  If the LoaderConfig has been initialized, this should represent the
     *  top-level MovieClip's swfVersion.
     */
    public static function get swfVersion():uint
    {
        return _swfVersion;
    }

	//----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     *  Storage for the url property.
     */
    mx_internal static var _url:String = null;

    /**
     *  If the LoaderConfig has been initialized, this
     *  should represent the top-level MovieClip's URL.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function get url():String
    {
        return _url;
    }
}

}
