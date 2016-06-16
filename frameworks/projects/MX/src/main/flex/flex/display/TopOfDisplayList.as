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

package flex.display
{
COMPILE::SWF
{
	import flash.display.Stage;
}
COMPILE::JS
{
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.HTMLElementWrapper;
	import org.apache.flex.core.WrappedHTMLElement;
}

COMPILE::SWF
public class TopOfDisplayList extends Stage
{
	public function TopOfDisplayList(stage:Stage)
	{
		super();
		_stage = stage;
	}
	
	override public function get width():Number
	{
		return _stage.stageWidth;
	}
	
	override public function get height():Number
	{
		return _stage.stageHeight;
	}
	
	private var _stage:Stage;
	
}

COMPILE::JS
public class TopOfDisplayList extends Sprite
{
	public function TopOfDisplayList()
	{
		super();
	}
	
	/**
	 * @flexjsignorecoercion flex.display.InteractiveObject
	 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
	 */
	public function get focus():InteractiveObject
	{
		return (document.activeElement as WrappedHTMLElement).flexjs_wrapper as InteractiveObject;
	}
	
	/**
	 * @flexjsignorecoercion org.apache.flex.core.HTMLElementWrapper
	 */
	public function set focus(value:InteractiveObject):void
	{
		document.activeElement = (value as HTMLElementWrapper).element;
	}
}

}
