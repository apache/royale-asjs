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

package mx.styles
{

/**
 *  This interface describes the properties and methods that an object 
 *  must implement so that it can participate in the style subsystem. 
 *  This interface is intended to be used by classes that obtain their
 *  style values from other objects rather than through locally set values
 *  and type selectors.
 *  This interface is implemented by ProgrammaticSkin.
 *
 *  @see mx.styles.IStyleClient
 *  @see mx.styles.CSSStyleDeclaration
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public interface ISimpleStyleClient
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  styleName
    //----------------------------------

    /**
     *  The source of this object's style values.
     *  The value of the <code>styleName</code> property can be one of three possible types:
     *
     *  <ul>
     *    <li>String, such as "headerStyle". The String names a class selector that is defined in a CSS style sheet.</li>
     *
     *    <li>CSSStyleDeclaration, such as <code>StyleManager.getStyleDeclaration(".headerStyle")</code>.</li>
     *
     *    <li>UIComponent. The object that implements this interface inherits all the style values from the referenced UIComponent.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    function get styleName():Object
	
    /**
     *  @private
     */
    function set styleName(value:Object):void
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Called when the value of a style property is changed. 
     *
     *  @param styleProp The name of the style property that changed.    
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /* function styleChanged(styleProp:String):void; */
}

}
