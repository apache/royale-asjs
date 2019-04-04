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

package mx.charts.chartClasses
{

import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;
//import mx.styles.StyleProtoChain;

use namespace mx_internal;

/**
 *  The DualStyleObject class serves as a base class for components that have a need to assign
 *  class selectors outside of the client developer's control. DualStyleObject instances have two styleName 
 *  properties...the standard styleName, and the additional internalStyleName.  A component can assign
 *  the internalStyleName property as necessary and leave the styleName property for the client developer
 *  to assign.
 *
 *  @mxml
 *  <p><b>Common MXML Syntax Inherited from DualStyleObject</b></p>
 *  
 *  <p>Flex components inherit the following properties
 *  from the DualStyleObject class:</p>
 *
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    internalStyleName="<i>Style; No default</i>"
 *  &gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DualStyleObject extends UIComponent
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor 
    //
    //--------------------------------------------------------------------------
    
    /** 
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DualStyleObject()
    {
        super();
    }   

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  internalStyleName
    //----------------------------------

    /** 
     *  @private.
     */
    private var _internalStyleName:Object;

    [Inspectable(environment="none")]

    /**
     *  The name of a class selector this instance inherits values from.
     *  The <code>internalStyleName</code> property has lower priority than the <code>styleName</code>
     *  selector.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get internalStyleName():Object
    {
        return _internalStyleName;
    }

    /**
     *  @private
     */
    public function set internalStyleName(v:Object):void
    {
        if (_internalStyleName == v)
            return;

        _internalStyleName = v;
    
        /*
        // If inheritingStyles is undefined, then this object is being
        // initialized and we haven't yet generated the proto chain.
        // To avoid redundant work, don't bother to create the proto chain here.
        if (inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED)
        {
            regenerateStyleCache(true);
            
            initThemeColor();
            
            styleChanged("internalStyleName");

            // Just to be sure we catch the weird things that happen
            // when styleName changes, we'll invalidate that too.
            styleChanged("styleName");
            
            notifyStyleChangeInChildren("styleName", true);
        }
        */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
    override mx_internal function initProtoChain():void
    {
        var classSelector:CSSStyleDeclaration;
        var internalClassSelector:CSSStyleDeclaration;
        
        if (styleName)
        {
            if (styleName is CSSStyleDeclaration)
            {
                // Get the style sheet referenced by the styleName property
                classSelector = CSSStyleDeclaration(styleName);
            }
            else if (styleName is IFlexDisplayObject)
            {
                // If the styleName property is a UIComponent, then there's a
                // special search path for that case.
                StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                return;
            }
            else if (styleName is String)
            {
                // Get the style sheet referenced by the styleName property
                classSelector =
                    styleManager.getStyleDeclaration("." + styleName);
            }
        }

        if (internalStyleName)
        {
            if (internalStyleName is CSSStyleDeclaration)
            {
                // Get the style sheet referenced by the styleName property
                internalClassSelector = CSSStyleDeclaration(internalStyleName);
            }
            else if (internalStyleName is IFlexDisplayObject)
            {
                // If the styleName property is a UIComponent, then there's a
                // special search path for that case.
                StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                return;
            }
            else if (internalStyleName is String)
            {
                // Get the style sheet referenced by the styleName property
                internalClassSelector =
                    styleManager.getStyleDeclaration("." + internalStyleName);
            }
        }

        // To build the proto chain, we start at the end and work forward.
        // Referring to the list at the top of this function, we'll start by
        // getting the tail of the proto chain, which is:
        //  - for non-inheriting styles, the global style sheet
        //  - for inheriting styles, my parent's style object
        var nonInheritChain:Object = styleManager.stylesRoot;

        if (nonInheritChain.effects)
            registerEffects(nonInheritChain.effects);

        var p:IStyleClient = parent as IStyleClient;
        if (p)
        {
            var inheritChain:Object = p.inheritingStyles;
            if (inheritChain == StyleProtoChain.STYLE_UNINITIALIZED)
                inheritChain = nonInheritChain;
        }
        else
        {
            inheritChain = styleManager.stylesRoot;
        }

        // Working backwards up the list, the next element in the
        // search path is the type selector
        var typeSelectors:Array = getClassStyleDeclarations();
        var n:int = typeSelectors.length;
        for (var i:int = 0; i < n; i++)
        {
            var typeSelector:CSSStyleDeclaration = typeSelectors[i];
            
            inheritChain =
                typeSelector.addStyleToProtoChain(inheritChain, this);

            nonInheritChain =
                typeSelector.addStyleToProtoChain(nonInheritChain, this);

            if (typeSelector.effects)
                registerEffects(typeSelector.effects);
                
        }

        // Next is the class selector
        if (internalClassSelector)
        {
            inheritChain =
                internalClassSelector.addStyleToProtoChain(inheritChain, this);

            nonInheritChain =
                internalClassSelector.addStyleToProtoChain(nonInheritChain,
                                                           this);

            if (internalClassSelector.effects)
                registerEffects(internalClassSelector.effects);
        }

        // Next is the class selector
        if (classSelector)
        {
            inheritChain =
                classSelector.addStyleToProtoChain(inheritChain, this);

            nonInheritChain =
                classSelector.addStyleToProtoChain(nonInheritChain, this);

            if (classSelector.effects)
                registerEffects(classSelector.effects);
        }

        // Finally, we'll add the in-line styles
        // to the head of the proto chain.
        inheritingStyles =
            styleDeclaration ?
            styleDeclaration.addStyleToProtoChain(inheritChain, this) :
            inheritChain;

        nonInheritingStyles =
            styleDeclaration ?
            styleDeclaration.addStyleToProtoChain(nonInheritChain, this) :
            nonInheritChain;
         
    }
     */

    override public function getStyle(styleProp:String):*
    {
        var value:*;
        if (internalStyleName != null)
        {
            var internalClassSelector:CSSStyleDeclaration;
            internalClassSelector =
                styleManager.getStyleDeclaration("." + internalStyleName);
            value = internalClassSelector.getStyle(styleProp);
        }
        if (value === undefined)
        {
            value = super.getStyle(styleProp)
        }
        return value;
    }

}

}
