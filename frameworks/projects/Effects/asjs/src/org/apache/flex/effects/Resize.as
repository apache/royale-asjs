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

package org.apache.flex.effects
{

import org.apache.flex.core.IDocument;
import org.apache.flex.core.IUIBase;

/**
 *  The Resize effect animates a UI component's width or height.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
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
     *  @productversion Flex 3
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
    
    /**
     *  The target as the String id 
     *  of a widget in an MXML Document.
     */
    public var target:String;
    
	/**
	 *  The change in width.
	 */
	public var widthBy:Number;
	
	/**
	 *  The change in height.
	 */
	public var heightBy:Number;
	
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

	/**
	 *  Starting width value.  If NaN, the current width value is used
     */
    public var widthFrom:Number;
    
	/**
	 *  Starting height value.  If NaN, the current height value is used
	 */
	public var heightFrom:Number;
		
    /**
     *  Ending width value.
     */
    public var widthTo:Number;
    
    /**
     *  Ending height value.
     */
    public var heightTo:Number;
    
    
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
