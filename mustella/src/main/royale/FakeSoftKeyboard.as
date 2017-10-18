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
package {

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.SoftKeyboardEvent;
import flash.events.SoftKeyboardTrigger;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.utils.getQualifiedClassName;

import mx.core.mx_internal;

[Mixin]
/**
 *  A hash table of tests not to run.
 */
public class FakeSoftKeyboard 
{

	private static var kbdrect:QName = new QName(mx_internal, "_softKeyboardRect");
	
	public static var portraitHeight:Number = 200;
	public static var landscapeHeight:Number = 150;
	
	/**
	 *  Mixin callback that checks if we're in the emulator
	 *  and tries to fake what would happen in terms of events
	 *  and sizing if you were on the device.  It doesn't actually
	 *  need a useful UI since to type, you should just use
	 *  DispatchKeyEvent
	 */
	public static function init(root:DisplayObject):void
	{
		if (DeviceNames.getFromOS() == "")
			return;	// not mac or win
		
		FakeSoftKeyboard.root = root;
		
		root.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
		root.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);		
	}

	public static var kbd:Sprite;
	public static var root:DisplayObject;
	
	public static function focusInHandler(event:FocusEvent):void
	{
		var comp:Object = event.target;
		if (comp is TextField || comp is InteractiveObject)
		{
            var className: String = getQualifiedClassName(comp);
			if (!(comp.needsSoftKeyboard || className.indexOf("StyleableStageText") > 0 || className.indexOf("ScrollableStageText") > 0 ))
				return;
			
			if (!comp.dispatchEvent(new SoftKeyboardEvent(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, 
							true, true, event.relatedObject, SoftKeyboardTrigger.USER_TRIGGERED)))
			{
				root.stage.focus = null;
				return;
			}
			
			if (!kbd)
			{
				kbd = new Sprite();
				kbd.graphics.beginFill(0x808080);
				kbd.graphics.drawRect(0, 0, 10, 10);
				kbd.graphics.endFill();
			}
			
			// root is actually a systemManager
			if (kbd.parent == null)
				root["popUpChildren"].addChild(kbd);
			if (root.stage.stageHeight > root.stage.stageWidth)
			{
				kbd.height = portraitHeight;
				kbd.width = root.stage.stageWidth;
				kbd.y = root.stage.stageHeight - portraitHeight;
				root["document"][kbdrect] = new Rectangle(0, kbd.y, kbd.width, kbd.height);
			}
			else
			{
				kbd.height = landscapeHeight;
				kbd.width = root.stage.stageWidth;
				kbd.y = root.stage.stageHeight - landscapeHeight;
				root["document"][kbdrect] = new Rectangle(0, kbd.y, kbd.width, kbd.height);
			}
			trace("sent softKeyboardActivate from", comp);
			comp.dispatchEvent(new SoftKeyboardEvent(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, 
							true, false, event.relatedObject, SoftKeyboardTrigger.USER_TRIGGERED));
		}
	}

	public static function focusOutHandler(event:FocusEvent):void
	{
		trace("fakesoftkeyboard focusOut", event.target, event.relatedObject, kbd);
		if (kbd && kbd.parent)
		{
			// root is actually a systemManager
			root["popUpChildren"].removeChild(kbd);
			root["document"][kbdrect] = new Rectangle(0, 0, 0, 0);
			trace("sent softKeyboardDeactivate from", event.target);
			event.target.dispatchEvent(new SoftKeyboardEvent(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 
								true, false, event.relatedObject, SoftKeyboardTrigger.USER_TRIGGERED));
		}
	}

}

}
