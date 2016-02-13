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

package mx.managers
{

import flash.display.DisplayObject;

import mx.core.IToolTip;
import mx.core.IUIComponent;
import mx.effects.Effect;

[ExcludeClass]

/**
 *  @private
 *  This interface was used by Flex 2.0.1.
 *  Flex 3 uses IToolTipManager2 instead.
 */
public interface IToolTipManager
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentTarget
    //----------------------------------

	/**
	 *  @private
	 */
	function get currentTarget():DisplayObject;
	
	/**
	 *  @private
	 */
	function set currentTarget(value:DisplayObject):void;
	
    //----------------------------------
    //  currentToolTip
    //----------------------------------

	/**
	 *  @private
	 */
	function get currentToolTip():IToolTip;
	
	/**
	 *  @private
	 */
	function set currentToolTip(value:IToolTip):void;
	
    //----------------------------------
    //  enabled
    //----------------------------------

	/**
	 *  @private
	 */
	function get enabled():Boolean;
	
	/**
	 *  @private
	 */
	function set enabled(value:Boolean):void;
	
    //----------------------------------
    //  hideDelay
    //----------------------------------

	/**
	 *  @private
	 */
	function get hideDelay():Number;
	
	/**
	 *  @private
	 */
	function set hideDelay(value:Number):void;
	
    //----------------------------------
    //  hideEffect
    //----------------------------------

	/**
	 *  @private
	 */
	function get hideEffect():Effect;

	/**
	 *  @private
	 */
	function set hideEffect(value:Effect):void;
	
    //----------------------------------
    //  scrubDelay
    //----------------------------------

	/**
	 *  @private
	 */
	function get scrubDelay():Number;
	
	/**
	 *  @private
	 */
	function set scrubDelay(value:Number):void;
	
    //----------------------------------
    //  showDelay
    //----------------------------------

	/**
	 *  @private
	 */
	function get showDelay():Number;
	
	/**
	 *  @private
	 */
	function set showDelay(value:Number):void;
	
    //----------------------------------
    //  showEffect
    //----------------------------------

	/**
	 *  @private
	 */
	function get showEffect():Effect;
	
	/**
	 *  @private
	 */
	function set showEffect(value:Effect):void;

    //----------------------------------
    //  showEffect
    //----------------------------------

	/**
	 *  @private
	 */
	function get toolTipClass():Class;
	
	/**
	 *  @private
	 */
	function set toolTipClass(value:Class):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	function registerToolTip(target:DisplayObject, oldToolTip:String,
							 newToolTip:String):void;
	
	/**
	 *  @private
	 */
	function registerErrorString(target:DisplayObject, oldErrorString:String,
								 newErrorString:String):void;
	
	/**
	 *  @private
	 */
	function sizeTip(toolTip:IToolTip):void;

	/**
	 *  @private
	 */
	function createToolTip(text:String, x:Number, y:Number,
						   errorTipBorderStyle:String = null,
						   context:IUIComponent = null):IToolTip;
	
	/**
	 *  @private
	 */
	function destroyToolTip(toolTip:IToolTip):void;
}

}
