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

package org.apache.royale.effects
{

import org.apache.royale.core.IDocument;
import org.apache.royale.core.IUIBase;

/**
 *  The Resize effect animates a UI component's width or height.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class Resize extends Tween implements IDocument
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target Object ID or reference to an object that will
	 *  have its x and/or y property animated.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function Resize(target:IUIBase = null)
    {
        super();

		this.actualTarget = target;
		startValue = 0;
		endValue = 1;
		
		listener = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 *  The document.
	 */
	private var document:Object;

	/**
	 *  @private
	 *  The target.
	 */
	private var actualTarget:IUIBase;
    
    // there is already a _target in the base class
    // and JS can't hide it
    private var target_:String;
    
    /**
     *  The target as the String id 
     *  of a widget in an MXML Document.
     */
    public function get target():String
    {
        return target_;
    }
    
    public function set target(value:String):void
    {
        target_ = value;
    }
    
    private var _widthBy:Number;
    
	/**
	 *  The change in width.
	 */
    public function get widthBy():Number
    {
        return _widthBy;
    }
    
    public function set widthBy(value:Number):void
    {
        _widthBy = value;
    }
	
    private var _heightBy:Number;
    
	/**
	 *  The change in height.
	 */
    public function get heightBy():Number
    {
        return _heightBy;
    }
    
    public function set heightBy(value:Number):void
    {
        _heightBy = value;
    }
	
	/**
	 *  @private
	 *  The starting width.
	 */
	private var widthStart:Number;
	
	/**
	 *  @private
	 *  The starting height.
	 */
	private var heightStart:Number;

    private var _widthFrom:Number;
    
	/**
	 *  Starting width value.  If NaN, the current width value is used
     */
    public function get widthFrom():Number
    {
        return _widthFrom;
    }
    
    public function set widthFrom(value:Number):void
    {
        _widthFrom = value;
    }
    
    private var _heightFrom:Number;
    
	/**
	 *  Starting height value.  If NaN, the current height value is used
	 */
    public function get heightFrom():Number
    {
        return _heightFrom;
    }
    
    public function set heightFrom(value:Number):void
    {
        _heightFrom = value;
    }
		
    private var _widthTo:Number;
    
    /**
     *  Ending width value.
     */
    public function get widthTo():Number
    {
        return _widthTo;
    }
    
    public function set widthTo(value:Number):void
    {
        _widthTo = value;
    }
    
    private var _heightTo:Number;
    
    /**
     *  Ending height value.
     */
    public function get heightTo():Number
    {
        return _heightTo;
    }
    
    public function set heightTo(value:Number):void
    {
        _heightTo = value;
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	public function setDocument(document:Object, id:String = null):void
	{
		this.document = document;	
	}
	
	/**
	 *  @private
	 */
	override public function play():void
	{
        if (target != null)
            actualTarget = document[target];
		
		if (isNaN(widthFrom))
			widthStart = actualTarget.width;
        if (isNaN(widthBy))
        {
    		if (isNaN(widthTo))
                widthBy = 0;
    		else
                widthBy = widthTo - widthStart;
        }
        
		if (isNaN(heightFrom))
			heightStart = actualTarget.height;
        if (isNaN(heightBy))
        {
    		if (isNaN(heightTo))
                heightBy = 0;
    		else
                heightBy = heightTo - heightStart;
        }			
		super.play();
	}

	public function onTweenUpdate(value:Number):void
	{
		if (widthBy)
			actualTarget.width = widthStart + value * widthBy;
		if (heightBy)
			actualTarget.height = heightStart + value * heightBy;
	}
	
	public function onTweenEnd(value:Number):void
	{
		if (widthBy)
			actualTarget.width = widthStart + widthBy;
		if (heightBy)
			actualTarget.height = heightStart + heightBy;
	}
}

}
