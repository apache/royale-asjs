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
import org.apache.flex.events.Event;

[DefaultProperty("children")]

/**
 *  The Parallel effect animates set of effects at the
 *  same time.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
public class Parallel extends Effect implements IDocument
{

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
    public function Parallel()
    {
        super();
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
	private var target:IUIBase;
    
	/**
	 *  The children.
	 */
	public var children:Array;
	
	
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function set duration(value:Number):void
    {
        var n:int = children ? children.length : 0;
        for (var i:int = 0; i < n; i++)
        {
            children[i].duration = value;
        }
        super.duration = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	public function setDocument(document:Object, id:String = null):void
	{
		this.document = document;	
	}
	
    public function addChild(child:IEffect):void
    {
        if (!children)
            children = [ child ];
        else
            children.push(child);    
    }
    
	/**
	 *  @private
	 */
	override public function play():void
	{
        dispatchEvent(new Event(Effect.EFFECT_START));
        current = 0;
        var n:int = children.length;
        for (var i:int = 0; i < n; i++)          
            playChildEffect(i);
	}
    
    private var current:int;
    
    private function playChildEffect(index:int):void
    {
        var child:IEffect = children[index];
        child.addEventListener(Effect.EFFECT_END, effectEndHandler);
        child.play();   
    }
    
    private function effectEndHandler(event:Event):void
    {
        current++;
        if (current >= children.length)
            dispatchEvent(new Event(Effect.EFFECT_END));
    }
}

}
