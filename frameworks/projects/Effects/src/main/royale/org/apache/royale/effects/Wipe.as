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
import org.apache.royale.geom.Rectangle;

/**
 *  The Fade effect animates a UI component's alpha or opacity.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class Wipe extends Tween implements IDocument
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
    public function Wipe(target:IUIBase = null)
    {
        super();

		this.actualTarget = target;
        
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
    
    private var _direction:String;
    
	/**
	 *  The direction of the Wipe.  "up" means the top will be the last
     *  part to disappear. "down" will reveal from the top down.
     */
    public function get direction():String
    {
        return _direction;
    }
    
    public function set direction(value:String):void
    {
        _direction = value;
    }
    	
    private var wiper:PlatformWiper = new PlatformWiper();	
    
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
        
		
        wiper.target = actualTarget;
        if (direction == "up")
        {
            startValue = actualTarget.height;
            endValue = 0;
        }
        else
        {
            startValue = 0;
            endValue = actualTarget.height;
            // WipeDown makes something appear
            actualTarget.visible = true;
            wiper.visibleRect = new Rectangle(0, 0, actualTarget.width, 0);
        }
        
		super.play();
	}

	public function onTweenUpdate(value:Number):void
	{
		wiper.visibleRect = new Rectangle(0, 0, actualTarget.width, value);
	}
	
	public function onTweenEnd(value:Number):void
	{
        // WipeUp makes something disappear
        if (direction == "up") {
            actualTarget.visible = false;
			COMPILE::JS {
				//reset height in js
                actualTarget.positioner.style.height = this.startValue+"px";
			}
		}
        else
        {
            actualTarget.height = endValue;
            COMPILE::JS {
                //reset height in js
                actualTarget.positioner.style.height = this.endValue+"px";
            }
        }

        wiper.target = null;
	}
}

}
