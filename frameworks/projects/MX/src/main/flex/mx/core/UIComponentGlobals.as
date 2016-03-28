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

package mx.core
{

COMPILE::AS3
{
	import flash.display.InteractiveObject;		
}
COMPILE::JS
{
	import flex.display.InteractiveObject;		
}
COMPILE::LATER
{
	import flash.geom.Matrix;		
}
import mx.managers.ILayoutManager;
import mx.managers.SystemManagerGlobals;
import mx.managers.ISystemManager;

use namespace mx_internal;

/**
*  @private
*/
public class UIComponentGlobals
{
    /**
     *  @private
     *  A reference to the sole instance of the LayoutManager
     *  used by all components.
     *
     *  <p>This property is set in the constructor of the Application class.
     *  If you need to override or replace LayoutManager,
     *  set UIComponent.layoutManager in your application's constructor
     *  after calling super().</p>
     */
    mx_internal static var layoutManager:ILayoutManager;

    /**
     *  @private
     *  When this variable is non-zero, no methods queued
     *  by the <code>callLater()</code> method get invoked.
     *  This is used to allow short effects to play without interruption.
     *  This counter is incremented by suspendBackgroundProcessing(),
     *  decremented by resumeBackgroundProcessing(), and checked by
     *  callLaterDispatcher().
     */
    mx_internal static var callLaterSuspendCount:int = 0;

    /**
     *  @private
     *  There is a bug (139390) where setting focus from within callLaterDispatcher
     *  screws up the ActiveX player.  We defer focus until enterframe.
     */
    mx_internal static var callLaterDispatcherCount:int = 0;

    /**
     *  @private
     *  There is a bug (139390) where setting focus from within callLaterDispatcher
     *  screws up the ActiveX player.  We defer focus until enterframe.
     */
    mx_internal static var nextFocusObject:InteractiveObject;

    /**
     *  @private
     *  This single Matrix is used to pass information from the
     *  horizontalGradientMatrix() or verticalGradientMatrix()
     *  utility methods to the drawRoundRect() method.
     *  Each call to horizontalGradientMatrix() or verticalGradientMatrix()
     *  simply calls createGradientBox() to stuff this Matrix with new values.
     *  We can keep restuffing the same Matrix object because these utility
     *  methods are only used inside a call to drawRoundRect()
     *  and the Matrix isn't needed after drawRoundRect() returns.
     */
	COMPILE::LATER
    mx_internal static var tempMatrix:Matrix = new Matrix();

    /**
     *  @private
     *  A global flag that can be read by any component to determine
     *  whether it is currently executing in the context of a design
     *  tool such as Flash Builder's design view.  Most components will
     *  never need to check this flag, but if a component needs to
     *  have different behavior at design time than at runtime, then it
     *  can check this flag.
     */
    mx_internal static var designTime:Boolean = false;

    /**
     *  A global flag that can be read by any component to determine
     *  whether it is currently executing in the context of a design
     *  tool such as Flash Builder's design view.  Most components will
     *  never need to check this flag, but if a component needs to
     *  have different behavior at design time than at runtime, then it
     *  can check this flag.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function get designMode():Boolean
    {
        return designTime;
    }

    /**
     *  @private
     */
    public static function set designMode(value:Boolean):void
    {
        designTime = value;
    }

    /**
     *  @private
     */
    private static var _catchCallLaterExceptions:Boolean = false;

    /**
     *  A global flag that can is used to catch unhandled exceptions
     *  during execution of methods executed via callLater
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function get catchCallLaterExceptions():Boolean
    {
        return _catchCallLaterExceptions;
    }

    /**
     *  @private
     */
    public static function set catchCallLaterExceptions(value:Boolean):void
    {
        _catchCallLaterExceptions = value;
    }
	
	/**
	 *  Blocks the background processing of methods
	 *  queued by <code>callLater()</code>,
	 *  until <code>resumeBackgroundProcessing()</code> is called.
	 *
	 *  <p>These methods can be useful when you have time-critical code
	 *  which needs to execute without interruption.
	 *  For example, when you set the <code>suspendBackgroundProcessing</code>
	 *  property of an Effect to <code>true</code>,
	 *  <code>suspendBackgroundProcessing()</code> is automatically called
	 *  when it starts playing, and <code>resumeBackgroundProcessing</code>
	 *  is called when it stops, in order to ensure that the animation
	 *  is smooth.</p>
	 *
	 *  <p>Since the LayoutManager uses <code>callLater()</code>,
	 *  this means that <code>commitProperties()</code>,
	 *  <code>measure()</code>, and <code>updateDisplayList()</code>
	 *  is not called in between calls to
	 *  <code>suspendBackgroundProcessing()</code> and
	 *  <code>resumeBackgroundProcessing()</code>.</p>
	 *
	 *  <p>It is safe for both an outer method and an inner method
	 *  (i.e., one that the outer methods calls) to call
	 *  <code>suspendBackgroundProcessing()</code>
	 *  and <code>resumeBackgroundProcessing()</code>, because these
	 *  methods actually increment and decrement a counter
	 *  which determines whether background processing occurs.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function suspendBackgroundProcessing():void
	{
		UIComponentGlobals.callLaterSuspendCount++;
	}
	
	/**
	 *  Resumes the background processing of methods
	 *  queued by <code>callLater()</code>, after a call to
	 *  <code>suspendBackgroundProcessing()</code>.
	 *
	 *  <p>Refer to the description of
	 *  <code>suspendBackgroundProcessing()</code> for more information.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function resumeBackgroundProcessing():void
	{
		if (UIComponentGlobals.callLaterSuspendCount > 0)
		{
			UIComponentGlobals.callLaterSuspendCount--;
			
			// Once the suspend count gets back to 0, we need to
			// force a render event to happen
			if (UIComponentGlobals.callLaterSuspendCount == 0)
			{
				var sm:ISystemManager = SystemManagerGlobals.topLevelSystemManagers[0];
				COMPILE::AS3
				{
					if (sm && sm.topOfDisplayList)
						sm.topOfDisplayList.invalidate();
				}
			}
		}
	}

}

}

