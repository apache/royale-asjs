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
package org.apache.flex.mdl.beads.views
{
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.ISliderView;
	import org.apache.flex.mdl.Button;
	
	/**
	 *  The SliderView class creates the visual elements of the org.apache.flex.mdl.Slider 
	 *  component. In swf the Slider has a track and a thumb control which are also created with view beads.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SliderView extends BeadViewBase implements ISliderView, IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SliderView()
		{
		}

		private var _track:Button;
		private var _thumb:Button;

        private var rangeModel:IRangeModel;

        /**
		 *  The track component.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get track():IUIBase
		{
			return _track;
		}
		
		/**
		 *  The thumb component.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get thumb():IUIBase
		{
			return _thumb;
		}

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            var host:UIBase = UIBase(_strand);
            rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;

            COMPILE::SWF {
				_track = new Button();
				_track.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iTrackView")) as IBead);
				_track.className = "SliderTrack";
				host.addElement(_track);
				
				_thumb = new Button();
				_thumb.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iThumbView")) as IBead);
				_thumb.className = "SliderThumb";
				host.addElement(_thumb);
				
			}

            COMPILE::JS
			{
                var htmlSliderElement:HTMLInputElement = host.element as HTMLInputElement;
                htmlSliderElement.value = String(rangeModel.value);
            }

			// listen for changes to the model and adjust the UI accordingly.
			IEventDispatcher(rangeModel).addEventListener("stepSizeChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("minimumChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("maximumChange", modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("valueChange", modelChangeHandler);

			modelChangeHandler(null);
		}
		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.8
		 */
		private function modelChangeHandler( event:Event ) : void
		{
			COMPILE::JS
			{
				var inputElement:HTMLInputElement = (UIBase(_strand).element as HTMLInputElement);
				inputElement.step = String(rangeModel.stepSize);
				inputElement.min = String(rangeModel.minimum);
				inputElement.max = String(rangeModel.maximum);
				// This makes sure that materialslider can accept programmatic changes to its values
				var materialSlider:Object = (inputElement as Object)["MaterialSlider"];
				if (materialSlider)
				{
					materialSlider["change"](rangeModel.value);
				} else
				{
					inputElement.value = rangeModel.value.toString();
				}
			}
		}
	}
}
