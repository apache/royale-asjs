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
package mx.controls.beads
{
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.events.ToolTipEvent;
	import mx.managers.SystemManager;

	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IToolTip;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.accessories.ToolTipBead;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.events.Event;
    
    import mx.core.UIComponent;
	
	public class ToolTipBead extends org.apache.royale.html.accessories.ToolTipBead
	{
		public function ToolTipBead()
		{
			super();
		}

		private static var _activeInstance:mx.controls.beads.ToolTipBead;
		private static var _monitorRemovalActive:Boolean;

		/**
		 * @private
		 */
		COMPILE::SWF
		private static function onFrame(event:Event):void{
			if (_activeInstance != event.target) {
					event.target.removeEventListener('enterFrame',onFrame);
			} else {
				monitorRemoval();
			}
		}

		/**
		 * @private
		 * @royaleignorecoercion Node
		 */
		COMPILE::JS
		private static function onFrame(timestamp:Number):void{
			if (_activeInstance) {
				monitorRemoval();
				requestAnimationFrame(onFrame);
				_monitorRemovalActive = true;
			} else {
				_monitorRemovalActive = false;
			}
		}
		/**
		 * @private
		 * @royaleignorecoercion Node
		 */
		private static function monitorRemoval(explicit:Boolean = false):void{
			if (explicit ) {
				COMPILE::SWF{
					if (_activeInstance) {
						_activeInstance.componentHost.addEventListener('enterFrame',onFrame);
					}
				}
				COMPILE::JS{
					if (!_monitorRemovalActive && _activeInstance) requestAnimationFrame(onFrame)
				}
				_monitorRemovalActive = _activeInstance != null;
			} else {
				COMPILE::SWF{
					if (_activeInstance) {
						if (!_activeInstance.componentHost.stage) {
							_activeInstance.componentHost.removeEventListener('enterFrame',onFrame);
							_activeInstance.removeTip();
						}
					}
				}

				COMPILE::JS{
					if (_activeInstance) {
						if (!document.body.contains(Node(_activeInstance.componentHost.element))) {
							_activeInstance.removeTip();
						}
					}
				}
			}
		}

		public function get componentHost():UIComponent{
			return _strand  as UIComponent;
		}


        private var _isError:Boolean;

        public function get isError():Boolean
        {
            return _isError;    
        }
        public function set isError(value:Boolean):void
        {
            _isError = value;
        }
        
        override protected function rollOverHandler(event:MouseEvent):void
        {

			if (_activeInstance && _activeInstance != this) {
				_activeInstance.removeTip();
			}
			if (!toolTip || tt)
				return;
			dispatchHostEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_START));

			super.rollOverHandler(event);
			if (tt){
				_activeInstance = this;
				monitorRemoval(true);
			}
			listenOnStrand(MouseEvent.MOUSE_DOWN, rollOutHandler);
			listenOnStrand(MouseEvent.CLICK, rollOutHandler);

            COMPILE::JS
            {
                if (tt)
                {
                    tt.element.style.color = isError ? "#ff0000" : "#000";
					adjustInsideBoundsIfNecessary();
					tt.element.style.maxWidth = "300px";
					tt.element.style.whiteSpace = "pre-wrap";
                }
            }

			if (tt) {
				dispatchHostEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW,false,false, tt as mx.core.IToolTip));
			}
        }

		private function dispatchHostEvent(event:org.apache.royale.events.Event):void{
			(_strand as IEventDispatcher).dispatchEvent(event);
		}

		override protected function createToolTip():org.apache.royale.core.IToolTip{

			var event:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_CREATE);
			dispatchHostEvent(event);
			var currentToolTip:org.apache.royale.core.IToolTip;
			if (event.toolTip) {
				currentToolTip = event.toolTip
			} else {
				currentToolTip = new ToolTip();
				// currentToolTip = super.createToolTip();
			}
			dispatchHostEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW,false,false, currentToolTip as mx.core.IToolTip));
			return currentToolTip;
		}

		override public function removeTip():void
		{
			var removalTip:IToolTip = tt;
			var event:ToolTipEvent;
			if (removalTip) {
				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
				event.toolTip = removalTip as mx.core.IToolTip;
				dispatchHostEvent(event);
			}
			super.removeTip();
			_activeInstance = null;
			listenOnStrand(MouseEvent.MOUSE_DOWN, rollOutHandler, false, true);
			listenOnStrand(MouseEvent.CLICK, rollOutHandler, false, true);
			if (removalTip) {
				//we don't currently have an effect/animation out
				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_END);
				event.toolTip = removalTip as mx.core.IToolTip;
				dispatchHostEvent(event);
			}
		}

		COMPILE::JS
		private function adjustInsideBoundsIfNecessary():void{ //could override determinePosition instead
			var screen:Rectangle = ((FlexGlobals.topLevelApplication as UIComponent).systemManager as SystemManager).screen;
			var deltaX:int = 0;
			var deltaY:int = 0;
			if (tt.x + tt.width > screen.width) {
				deltaX -= (tt.x + tt.width - screen.width)
			} else if (tt.x < 0) {
				deltaX = tt.x;
			}
			if (tt.y + tt.height > screen.height) {
				deltaY -= (tt.y + tt.height - screen.height)
			} else if (tt.y < 0) {
				deltaY = tt.y;
			}

			if (deltaX || deltaY) {
				tt.x += deltaX;
				tt.y += deltaY;
			}
		}

	}
}