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
package org.apache.flex.html.beads
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	COMPILE::JS
		{
			import org.apache.flex.core.IRenderedObject;
			import goog.events;
		}
		
		COMPILE::SWF
		{
			import flash.events.FocusEvent;
			import flash.events.KeyboardEvent;
			import org.apache.flex.html.beads.ITextFieldView;
		}
		
		/**
		 *  The DispatchInputFinishedBead class dispatched INPUT_FINISHED on strand
		 *  when enter is pressed, or when foucus is out.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public class DispatchInputFinishedBead implements IBead
		{
			/**
			 *  constructor.
			 *  
			 *  @langversion 3.0
			 *  @playerversion Flash 10.2
			 *  @playerversion AIR 2.6
			 *  @productversion FlexJS 0.0
			 */
			public function DispatchInputFinishedBead()
			{
			}
			
			public static const INPUT_FINISHED:String = "inputFinished";
			
			
			
			private var _strand:IStrand;
			
			/**
			 *  @copy org.apache.flex.core.IBead#strand
			 *  
			 *  @langversion 3.0
			 *  @playerversion Flash 10.2
			 *  @playerversion AIR 2.6
			 *  @productversion FlexJS 0.0
			 */
			public function set strand(value:IStrand):void
			{
				_strand = value;
				
				COMPILE::SWF
					{
						var viewBead:ITextFieldView = _strand.getBeadByType(ITextFieldView) as ITextFieldView;
						viewBead.textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
						viewBead.textField.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
					}
					COMPILE::JS
					{
						goog.events.listen((_strand as IRenderedObject).element, 'keydown', keydownHandler);
						goog.events.listen((_strand as IRenderedObject).element, 'focusout', focusoutHandler);
					}
			}
			
			/**
			 * @private
			 */
			COMPILE::SWF
			protected function focusOutHandler(event:FocusEvent):void
			{
				(_strand as IEventDispatcher).dispatchEvent(new Event(INPUT_FINISHED));
			}
			
			/**
			 * @private
			 */
			COMPILE::SWF
			private function keyDownHandler( event:KeyboardEvent ) : void
			{
				// this will otherwise bubble an event of flash.events.Event
				event.stopImmediatePropagation();
				if (event.keyCode == 13) //enter
				{
					(_strand as IEventDispatcher).dispatchEvent(new Event(INPUT_FINISHED));
				}
			}
			
			/**
			 * @private
			 */
			COMPILE::JS
			private function keydownHandler( event:Object ) : void
			{
				if (event.keyCode == 13) //enter
				{
					(_strand as IEventDispatcher).dispatchEvent(new Event(INPUT_FINISHED));
				}
			}

			
			/**
			 * @private
			 */
			COMPILE::JS
			private function focusoutHandler( event:Object ) : void
			{
				(_strand as IEventDispatcher).dispatchEvent(new Event(INPUT_FINISHED));
			}
			
		}
}
