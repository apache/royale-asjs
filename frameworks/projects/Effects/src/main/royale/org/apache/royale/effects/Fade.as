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
 *  The Fade effect animates a UI component's alpha or opacity.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class Fade extends Tween implements IDocument
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target An object that will
	 *  have its x and/or y property animated.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function Fade(target:IUIBase = null)
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
    
	/**
	 *  @private
	 *  The change in alpha.
	 */
	private var d:Number;
	
	/**
	 *  @private
	 *  The starting value.
	 */
	private var start:Number;
	
    private var _alphaFrom:Number;
    
	/**
	 *  Starting alpha value.  If NaN, the current alpha value is used
     */
    public function get alphaFrom():Number
    {
        return _alphaFrom;
    }
    
    public function set alphaFrom(value:Number):void
    {
        _alphaFrom = value;
    }
    
    private var _alphaTo:Number;
    
	/**
	 *  Ending alpha value.  If NaN, the current alpha value is not changed
	 */
    public function get alphaTo():Number
    {
        return _alphaTo;
    }
    
    public function set alphaTo(value:Number):void
    {
        _alphaTo = value;
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
		
		if (isNaN(alphaFrom))
			start = actualTarget.alpha;
		else
			start = alphaFrom;
		
		if (isNaN(alphaTo))
			d = 0;
		else
			d = alphaTo - start;
					
		super.play();
	}

	public function onTweenUpdate(value:Number):void
	{
		if (d)
			actualTarget.alpha = start + value * d;
	}
	
	public function onTweenEnd(value:Number):void
	{
		if (d)
			actualTarget.alpha = start + d;
	}
}

}
