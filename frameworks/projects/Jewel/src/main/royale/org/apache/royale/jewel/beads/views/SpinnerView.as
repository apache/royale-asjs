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
package org.apache.royale.jewel.beads.views
{
	COMPILE::SWF {
	import flash.display.DisplayObject;

	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.ILayoutChild;
	}
	COMPILE::JS {
	import org.apache.royale.jewel.beads.controllers.SpinnerMouseController;
	}
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IRangeModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.Button;
    import org.apache.royale.jewel.beads.controls.spinner.ISpinnerView;

	/**
	 *  The SpinnerView class creates the visual elements of the org.apache.royale.jewel.Spinner
	 *  component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SpinnerView extends BeadViewBase implements ISpinnerView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SpinnerView()
		{
		}

		private var rangeModel:IRangeModel;

		COMPILE::JS {
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var _increment:Button;
		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var _decrement:Button;
        private var controller:SpinnerMouseController;
		}

		COMPILE::SWF {
		private var _decrement:DisplayObject;
		private var _increment:DisplayObject;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            COMPILE::SWF {
				_increment = new Button();
				// Button(_increment).addBead(new UpArrowButtonView());
				// Button(_increment).addBead(new ButtonAutoRepeatController());
				_decrement = new Button();
				// Button(_decrement).addBead(new DownArrowButtonView());
				// Button(_decrement).addBead(new ButtonAutoRepeatController());

				Button(_increment).x = 0;
				Button(_increment).y = 0;
				Button(_decrement).x = 0;
				Button(_decrement).y = Button(_increment).height;

				UIBase(_strand).addChild(_decrement);
				UIBase(_strand).addChild(_increment);
				rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;
			}
			
			listenOnStrand("widthChanged",sizeChangeHandler);
			listenOnStrand("heightChanged",sizeChangeHandler);
			
            COMPILE::JS {
				var host:UIBase = value as UIBase;
				
				_increment = new Button();
                _increment.addClass("up");
				_increment.text = '\u25B2';
				host.addElement(_increment);
				
				_decrement = new Button();
                _decrement.addClass("down");
				_decrement.text = '\u25BC';
				
				host.addElement(_decrement);
			}
				
			COMPILE::SWF
			{
				var host:ILayoutChild = ILayoutChild(value);
				
				// Complete the setup if the height is sized to content or has been explicitly set
				// and the width is sized to content or has been explicitly set
				if ((host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
					(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
					sizeChangeHandler(null);
			}
			COMPILE::JS
			{
				// always run size change since there are no size change events
				sizeChangeHandler(null);
			}
		}

		/**
		 *  The component for decrementing the org.apache.royale.jewel.Spinner value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		COMPILE::SWF
		public function get decrement():DisplayObject
		{
			return _decrement;
		}
		COMPILE::JS
		public function get decrement():Button
		{
			return _decrement;
		}

		/**
		 *  The component for incrementing the org.apache.royale.jewel.Spinner value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		COMPILE::SWF
		public function get increment():DisplayObject
		{
			return _increment;
		}
		COMPILE::JS
		public function get increment():Button
		{
			return _increment;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function sizeChangeHandler( event:Event ) : void
		{
            var w:Number = UIBase(_strand).width;
            var h:Number =  UIBase(_strand).height / 2;
			// _increment.width = w;
			// _increment.height = h;
			COMPILE::SWF
			{
			_increment.y      = 0;
			}
			// _decrement.width = w;
			// _decrement.height = h;
			COMPILE::SWF
			{
			_decrement.y      = h;
			}
		}
	}
}
