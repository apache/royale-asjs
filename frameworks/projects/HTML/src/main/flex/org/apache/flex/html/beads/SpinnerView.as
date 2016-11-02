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
COMPILE::SWF {
	import flash.display.DisplayObject;
}

    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Button;
	import org.apache.flex.html.beads.controllers.ButtonAutoRepeatController;

COMPILE::JS {
	import org.apache.flex.html.beads.controllers.SpinnerMouseController;
    import org.apache.flex.html.supportClasses.SpinnerButton;
}

	/**
	 *  The SpinnerView class creates the visual elements of the org.apache.flex.html.Spinner
	 *  component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SpinnerView extends BeadViewBase implements ISpinnerView, IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SpinnerView()
		{
		}

		private var rangeModel:IRangeModel;

		COMPILE::JS {
		public var _increment:SpinnerButton;
        public var _decrement:SpinnerButton;
        private var controller:SpinnerMouseController;
		}

		COMPILE::SWF {
		private var _decrement:Button;
		private var _increment:Button;
		}

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            COMPILE::SWF {
				_increment = new Button();
				var i:Button = _increment
				i.addBead(new UpArrowButtonView());
				i.addBead(new ButtonAutoRepeatController());
				_decrement = new Button();
				var d:Button = _decrement
				d.addBead(new DownArrowButtonView());
				d.addBead(new ButtonAutoRepeatController());

				i.x = 0;
				i.y = 0;
				d.x = 0;
				d.y = i.height;

				UIBase(_strand).$sprite.addChild(d.$button);
				UIBase(_strand).$sprite.addChild(i.$button);
				rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;

				IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
				IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
			}
			COMPILE::JS {
				var host:UIBase = value as UIBase;

				_increment = new SpinnerButton();
				_increment.text = '\u25B2';
				host.addElement(_increment);

				_decrement = new SpinnerButton();
				_decrement.text = '\u25BC';
				host.addElement(_decrement);

// add this in CSS!
				controller = new SpinnerMouseController();
				host.addBead(controller);
			}
		}

		/**
		 *  The component for decrementing the org.apache.flex.html.Spinner value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		COMPILE::SWF
		public function get decrement():Button
		{
			return _decrement;
		}
		COMPILE::JS
		public function get decrement():SpinnerButton
		{
			return _decrement;
		}

		/**
		 *  The component for incrementing the org.apache.flex.html.Spinner value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		COMPILE::SWF
		public function get increment():Button
		{
			return _increment;
		}
		COMPILE::JS
		public function get increment():SpinnerButton
		{
			return _increment;
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		private function sizeChangeHandler( event:Event ) : void
		{
            var w:Number = UIBase(_strand).width;
            var h:Number =  UIBase(_strand).height / 2;
			_increment.width = w;
			_increment.height = h;
			_increment.y      = 0;
			_decrement.width = w;
			_decrement.height = h;
			_decrement.y      = h;
		}
	}
}
