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
package org.apache.royale.html.beads.controllers
{
    import org.apache.royale.core.UIBase;

    COMPILE::SWF
    {
        import flash.display.DisplayObject;
    }

	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.CloseEvent;
	import org.apache.royale.core.Bead;

	/**
	 *  The AlertControler class bead handles the close event on the org.apache.royale.html.Alert 
	 *  by removing the org.apache.royale.html.Alert from the display.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    public class AlertController extends Bead implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AlertController()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
        public function get strand():IStrand
        {
            return _strand;
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
			_strand = value;
			listenOnStrand("close", alertCloseHandler);
		}
        
		/**
		 * @private
		 */
        protected function alertCloseHandler(event:CloseEvent):void
        {
			COMPILE::SWF
            {
                DisplayObject(_strand).parent.removeChild(DisplayObject(_strand));
            }

			COMPILE::JS
			{
				var host:UIBase = strand as UIBase;
                var htmlElement:HTMLElement = host.element as HTMLElement;
                htmlElement.parentElement.removeChild(host.element);
			}
        }
	}
}
