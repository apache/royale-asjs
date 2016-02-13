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

import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  Wraps an object that implements the IAdvancedStyleClient interface. This
 *  interface supports a <code>filterMap</code> property that contains
 *  style-source/style-destination pairs.
 * 
 *  @see mx.styles.IAdvancedStyleClient
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class StyleProxy implements IAdvancedStyleClient
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @param source The object that implements the IStyleClient interface.
     *  @param filterMap The set of styles to pass from the source to the subcomponent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function StyleProxy(source:IStyleClient, filterMap:Object)
    {
        super();
        
        this.filterMap = filterMap;
        this.source = source;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  filterMap
    //----------------------------------

    /**
     *  @private
     *  Storage for the filterMap property.
     */
    private var _filterMap:Object;
    
    /**
     *  A set of string pairs. The first item of the string pair is the name of the style 
     *  in the source component. The second item of the String pair is the name of the style 
     *  in the subcomponent. With this object, you can map a particular style in the parent component 
     *  to a different style in the subcomponent. This is useful if both the parent 
     *  component and the subcomponent share the same style, but you want to be able to 
     *  control the values seperately.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get filterMap():Object
    {
        return _filterMap;
    }
    
    /**
     *  @private
     */
    public function set filterMap(value:Object):void
    {
        _filterMap = value;
    }

    //----------------------------------
    //  source
    //----------------------------------

    /**
     *  @private
     *  Storage for the source property.
     */
    private var _source:IStyleClient;

    /**
     *  @private
     */ 
    private var _advancedSource:IAdvancedStyleClient;

    /**
     *  The object that implements the IStyleClient interface. This is the object
     *  that is being proxied.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():IStyleClient
    {
        return _source;
    }

    /**
     *  @private
     */
    public function set source(value:IStyleClient):void
    {
        _source = value;
        _advancedSource = value as IAdvancedStyleClient;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties - IStyleClient
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  className
    //----------------------------------

    /**
     *  @copy mx.styles.IStyleClient#className
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get className():String
    {
        return _source.className;
    }

    //----------------------------------
    //  inheritingStyles
    //----------------------------------

    /**
     *  @copy mx.styles.IStyleClient#inheritingStyles
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get inheritingStyles():Object
    {
        return _source.inheritingStyles;
    }
    
    /**
     *  @private
     */
    public function set inheritingStyles(value:Object):void
    {
        // This should never happen 
    }

    //----------------------------------
    //  nonInheritingStyles
    //----------------------------------

    /**
     *  @copy mx.styles.IStyleClient#nonInheritingStyles
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get nonInheritingStyles():Object
    {
        return null; // This will always need to get reconstructed
    }

    /**
     *  @private
     */
    public function set nonInheritingStyles(value:Object):void
    {
        // This should never happen
    }

    //----------------------------------
    //  styleDeclaration
    //----------------------------------

    /**
     *  @copy mx.styles.IStyleClient#styleDeclaration
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get styleDeclaration():CSSStyleDeclaration
    {
        return _source.styleDeclaration;
    }

    /**
     *  @private
     */
    public function set styleDeclaration(value:CSSStyleDeclaration):void
    {
        _source.styleDeclaration = styleDeclaration;
    }

    //----------------------------------
    //  styleName
    //----------------------------------

    /**
     *  @copy mx.styles.ISimpleStyleClient#styleName
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get styleName():Object
    {
        if (_source.styleName is IStyleClient)
            return new StyleProxy(IStyleClient(_source.styleName), filterMap);
        else
            return _source.styleName;
    }

    /**
     *  @private
     */
    public function set styleName(value:Object):void
    {
        _source.styleName = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties - IAdvancedStyleClient
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  id
    //----------------------------------

    /**
     *  @copy mx.styles.IAdvancedStyleClient#id
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get id():String
    {
        return _advancedSource ? _advancedSource.id : null;
    }

    //----------------------------------
    //  styleParent
    //----------------------------------

    /**
     *  @copy mx.styles.IAdvancedStyleClient#styleParent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get styleParent():IAdvancedStyleClient
    {
        return _advancedSource ? _advancedSource.styleParent : null;
    }

	public function set styleParent(parent:IAdvancedStyleClient):void
	{
		
	}
    //--------------------------------------------------------------------------
    //
    //  Methods - ISimpleStyleClient and IStyleClient
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy mx.styles.ISimpleStyleClient#styleChanged()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function styleChanged(styleProp:String):void
    {
        return _source.styleChanged(styleProp);
    }

    /**
     *  @copy mx.styles.IStyleClient#getStyle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getStyle(styleProp:String):*
    {
        return _source.getStyle(styleProp);
    }

    /**
     *  @copy mx.styles.IStyleClient#setStyle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setStyle(styleProp:String, newValue:*):void
    {
        _source.setStyle(styleProp, newValue);
    }

    /**
     *  @copy mx.styles.IStyleClient#clearStyle()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clearStyle(styleProp:String):void
    {
        _source.clearStyle(styleProp);
    }

    /**
     *  @copy mx.styles.IStyleClient#getClassStyleDeclarations()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getClassStyleDeclarations():Array
    {
        return _source.getClassStyleDeclarations();
    }

    /**
     *  @copy mx.styles.IStyleClient#notifyStyleChangeInChildren()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function notifyStyleChangeInChildren(styleProp:String,
                                                recursive:Boolean):void
    {
        return _source.notifyStyleChangeInChildren(styleProp, recursive);
    }

    /**
     *  @copy mx.styles.IStyleClient#regenerateStyleCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function regenerateStyleCache(recursive:Boolean):void
    {
        _source.regenerateStyleCache(recursive);
        return;
    }

    /**
     *  @copy mx.styles.IStyleClient#registerEffects()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function registerEffects(effects:Array):void
    {
        return _source.registerEffects(effects);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods - IAdvancedStyleClient
    //
    //--------------------------------------------------------------------------

	/**
	 *  @copy mx.styles.IAdvancedStyleClient#stylesInitialized()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function stylesInitialized():void
	{
		if (_advancedSource)
			_advancedSource.stylesInitialized();
	}
	
	/**
     *  @copy mx.styles.IAdvancedStyleClient#matchesCSSState()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function matchesCSSState(cssState:String):Boolean
    {
        return _advancedSource ? _advancedSource.matchesCSSState(cssState) : false;
    }

    /**
     *  @copy mx.styles.IAdvancedStyleClient#matchesCSSType()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function matchesCSSType(cssType:String):Boolean
    {
        return _advancedSource ? _advancedSource.matchesCSSType(cssType) : false;
    }

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.6
     */
    
    public function hasCSSState():Boolean
    {
        return _advancedSource ? _advancedSource.hasCSSState() : false;
    }    

}

}
