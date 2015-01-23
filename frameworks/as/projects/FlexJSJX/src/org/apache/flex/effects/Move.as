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
 *  The Move effect animates a UI component's x or y position.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
public class Move extends Tween implements IDocument
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
    public function Move(target:IUIBase = null)
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
     *  The actual target.
     */
    private var actualTarget:IUIBase;
    
	/**
	 *  The target as the String id 
     *  of a widget in an MXML Document.
	 */
	public var target:String;
    
	/**
	 *  The change in x.
	 */
	public var xBy:Number;
	
	/**
	 *  The change in y.
	 */
	public var yBy:Number;
	
	/**
	 *  @private
	 *  The starting x.
	 */
	private var xStart:Number;
	
	/**
	 *  @private
	 *  The starting y.
	 */
	private var yStart:Number;

    /**
     *  @private
     *  The total change for x.
     */
    private var xMove:Number;
    
    /**
     *  @private
     *  The total change for y.
     */
    private var yMove:Number;
    
	/**
	 *  Starting x value.  If NaN, the current x value is used
     */
    public var xFrom:Number;
    
	/**
	 *  Ending x value.  If NaN, the current x value is not changed
	 */
	public var xTo:Number;
	
	/**
	 *  Starting y value.  If NaN, the current y value is used
	 */
	public var yFrom:Number;
	
	/**
	 *  Ending y value.  If NaN, the current y value is not changed
	 */
	public var yTo:Number;
	
    
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
			actualTarget = getProperty(document, target);
		
		if (isNaN(xFrom))
			xStart = actualTarget.x;
        else
            xStart = xFrom;
        
        if (isNaN(xBy))
        {
    		if (isNaN(xTo))
                xMove = 0;
    		else
                xMove = xTo - xStart;
        }
        else
            xMove = xBy;
        
		if (isNaN(yFrom))
			yStart = actualTarget.y;
        else
            yStart = yFrom;
        if (isNaN(yBy))
        {
    		if (isNaN(yTo))
                yMove = 0;
    		else
                yMove = yTo - yStart;
        }
        else
            yMove = yBy;
        
		super.play();
	}

	public function onTweenUpdate(value:Number):void
	{
		if (xMove)
			actualTarget.x = xStart + value * xMove;
		if (yMove)
			actualTarget.y = yStart + value * yMove;
	}
	
	public function onTweenEnd(value:Number):void
	{
		if (xMove)
			actualTarget.x = xStart + xMove;
		if (yMove)
			actualTarget.y = yStart + yMove;
        
	}
    
    override public function captureStartValues():void
    {
        if (target != null)
        {
            actualTarget = getProperty(document, target);
            xFrom = actualTarget.x;
            yFrom = actualTarget.y;
        }
    }
    
    override public function captureEndValues():void
    {
        if (target != null)
        {
            actualTarget = getProperty(document, target);
            xTo = actualTarget.x;
            yTo = actualTarget.y;
        }
    }
}

}
