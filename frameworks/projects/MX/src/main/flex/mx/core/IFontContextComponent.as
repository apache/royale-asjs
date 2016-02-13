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

/**
 *  Allows a component to support a font context property.
 *  The property will be set on the component by the framework
 *  as the child is added to  the display list.
 * 
 *  A font context is important for components that create flash.text.TextField
 *  objects with embedded fonts.
 *  If an embedded font is not registered using Font.registerFont(), 
 *  TextField objects can only use embedded fonts if they are created
 *  in the context of the embedded font.
 *  This interface provides for tracking the font context of a component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */    
public interface IFontContextComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fontContext
    //----------------------------------

    /**
     *  The module factory that provides the font context for this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get fontContext():IFlexModuleFactory;
    
    /**
     *  @private
     */
    function set fontContext(moduleFactory:IFlexModuleFactory):void;
}

}
