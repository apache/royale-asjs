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


//[ResourceBundle("core")]

/** 
 *  This class controls the backward-compatibility of the framework.
 *  With every new release, some aspects of the framework such as behaviors, 
 *  styles, and default settings, are changed which can affect your application.
 *  By setting the <code>compatibilityVersion</code> property, the behavior can be changed
 *  to match previous releases.
 *  This is a 'global' flag; you cannot apply one version to one component or group of components
 *  and a different version to another component or group of components.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class FlexVersion 
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    
    /** 
     *  The <code>compatibilityVersion</code> value of Flex 3.0,
     *  encoded numerically as a <code>uint</code>.
     *  Code can compare this constant against
     *  the <code>compatibilityVersion</code>
     *  to implement version-specific behavior.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const VERSION_3_0:uint = 0x03000000;

   

    //----------------------------------
    //  compatibilityVersion
    //----------------------------------

    /**
     *  @private
     *  Storage for the compatibilityVersion property.
     */
    private static var _compatibilityVersion:uint =  0x04100001;

   
    /** 
     *  The current version that the framework maintains compatibility for.  
     *  This defaults to <code>CURRENT_VERSION</code>.
     *  It can be changed only once; changing it a second time
     *  results in a call to the <code>compatibilityErrorFunction()</code> method
     *  if it exists, or results in a runtime error. 
     *  Changing it after the <code>compatibilityVersion</code> property has been read results in an error
     *  because code that is dependent on the version has already run.
     *  There are no notifications; the assumption is that this is set only once, and this it is set
     *  early enough that no code that depends on it has run yet.
     *
     *  @default FlexVersion.CURRENT_VERSION
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function get compatibilityVersion():uint
    {
      //  compatibilityVersionRead = true;

        return _compatibilityVersion;
    }

    /**
     *  @private
     */
    public static function set compatibilityVersion(value:uint):void
    {
      /*   if (value == _compatibilityVersion)
            return;

        var s:String;
        
        if (compatibilityVersionChanged)
        {
            if (compatibilityErrorFunction == null)
            {
                s = ResourceManager.getInstance().getString(
                    "core", VERSION_ALREADY_SET);           
                throw new Error(s);
            }
            else
                compatibilityErrorFunction(value, VERSION_ALREADY_SET);
        }

        if (compatibilityVersionRead)
        {
            if (compatibilityErrorFunction == null)
            {
                s = ResourceManager.getInstance().getString(
                    "core", VERSION_ALREADY_READ);          
                throw new Error(s);
            }
            else
                compatibilityErrorFunction(value, VERSION_ALREADY_READ);
        } */

        _compatibilityVersion = value;
       // compatibilityVersionChanged = true;
    }

  
}

}
