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

package mx.controls
{
COMPILE::JS
{
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
}

/**
 *  The DownloadButton control is a Button control
 *  that initiates the downloading of some data
 *  when the user clicks the button.  The user can
 *  also right click to choose the location of the download.
 *  It only works on JS.  The data must be set before
 *  the user clicks or right-clicks.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DownloadButton extends Button
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
	public function DownloadButton()
	{
		super();
		typeNames = "DownloadButton";
	}

	COMPILE::JS
	override protected function createElement():WrappedHTMLElement
	{
		addElementToWrapper(this, "a");
		return element;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	override public function set data(value:Object):void
	{
		super.data = value;
		COMPILE::JS
		{
			(element as HTMLAnchorElement).href = URL.createObjectURL(new Blob([data]));
		}
	}
	
	private var _defaultFileName:String;
	
	public function get defaultFileName():String
	{
		return _defaultFileName;
	}

	public function set defaultFileName(value:String):void
	{
		_defaultFileName = value;
		COMPILE::JS
		{
			(element as HTMLAnchorElement).setAttribute("download", _defaultFileName);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: UIComponent
	//
	//--------------------------------------------------------------------------

}

}
