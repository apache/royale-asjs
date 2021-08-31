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
	import mx.core.FlexGlobals;
	import mx.managers.SystemManager;

	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.accessories.ToolTipBead;
	import org.apache.royale.geom.Rectangle;
    
    import mx.core.UIComponent;
	
	public class ToolTipBead extends org.apache.royale.html.accessories.ToolTipBead
	{
		public function ToolTipBead()
		{
			super();
		}
		
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			IEventDispatcher(value).addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
		}
		
		/**
		 * @private
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			super.rollOutHandler(event);
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
            super.rollOverHandler(event);
            COMPILE::JS
            {
                if (tt)
                {
                    tt.element.style.color = isError ? "#ff0000" : "#000";
					adjustInsideBoundsIfNecessary();
                }
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