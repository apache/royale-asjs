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
 *  The Move effect animates a UI component's x or y position.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
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
     *  @productversion Royale 1.0.0
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
    
    private var _xBy:Number;
    
	/**
	 *  The change in x.
	 */
    public function get xBy():Number
    {
        return _xBy;
    }
    
    public function set xBy(value:Number):void
    {
        _xBy = value;
    }
	
    private var _yBy:Number;
    
	/**
	 *  The change in y.
	 */
    public function get yBy():Number
    {
        return _yBy;
    }
    
    public function set yBy(value:Number):void
    {
        _yBy = value;
    }
	
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
    
    private var _xFrom:Number;
    
	/**
	 *  Starting x value.  If NaN, the current x value is used
     */
    public function get xFrom():Number
    {
        return _xFrom;
    }
    
    public function set xFrom(value:Number):void
    {
        _xFrom = value;
    }
    
    private var _xTo:Number;
    
	/**
	 *  Ending x value.  If NaN, the current x value is not changed
	 */
    public function get xTo():Number
    {
        return _xTo;
    }
    
    public function set xTo(value:Number):void
    {
        _xTo = value;
    }
	
    private var _yFrom:Number;
    
	/**
	 *  Starting y value.  If NaN, the current y value is used
	 */
    public function get yFrom():Number
    {
        return _yFrom;
    }
    
    public function set yFrom(value:Number):void
    {
        _yFrom = value;
    }
	
    private var _yTo:Number;
    
	/**
	 *  Ending y value.  If NaN, the current y value is not changed
	 */
    public function get yTo():Number
    {
        return _yTo;
    }
    
    public function set yTo(value:Number):void
    {
        _yTo = value;
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
            actualTarget = document[target];
            xFrom = actualTarget.x;
            yFrom = actualTarget.y;
        }
    }
    
    override public function captureEndValues():void
    {
        if (target != null)
        {
            actualTarget = document[target];
            xTo = actualTarget.x;
            yTo = actualTarget.y;
        }
    }
}

}
