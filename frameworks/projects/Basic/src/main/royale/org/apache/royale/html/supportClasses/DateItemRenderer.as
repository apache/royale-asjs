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
package org.apache.royale.html.supportClasses
{
	COMPILE::SWF
	{
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFieldType;

		import org.apache.royale.core.CSSTextField;
	}
	import org.apache.royale.events.Event;

	/**
	 *  The DateItemRenderer class renders date values for the DateChooser.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DateItemRenderer extends StringItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DateItemRenderer()
		{
			super();

			className = "DateItemRenderer";
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion Date
		 */
		override public function set data(value:Object):void
		{
			super.data = value;

			COMPILE::SWF {
				textField.autoSize = TextFieldAutoSize.CENTER;
			}

			if (value is Date) {
				this.text = String( (value as Date).getDate() );

				COMPILE::SWF {
					mouseEnabled = true;
					mouseChildren = true;
				}

				COMPILE::JS {
					element.style["pointer-events"] = "";
				}
			} else {
				this.text = "";

				COMPILE::SWF {
					mouseEnabled = false;
					mouseChildren = false;
				}

				COMPILE::JS {
				  element.style["pointer-events"] = "none";
				}
			}
		}

		/**
		 * @private
		 */
		COMPILE::JS
		override public function set height(value:Number):void
		{
			super.height = value;
			element.style["line-height"] = String(value)+"px";
		}
	}
}
