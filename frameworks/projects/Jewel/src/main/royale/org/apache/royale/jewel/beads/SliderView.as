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
package org.apache.royale.jewel.beads
{
	COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.display.Sprite;
	}
	
    import org.apache.royale.html.beads.ISliderView;
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IRangeModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.Button;
    import org.apache.royale.html.TextButton;
	
	/**
	 *  The SliderView class creates the visual elements of the org.apache.royale.jewel.Slider 
	 *  component. The Slider has a track and a thumb control which are also created with view beads.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SliderView extends BeadViewBase implements ISliderView, IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function SliderView()
		{
			super();
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
		 *  @copy org.apache.royale.core.IBead#strand
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
				inputElement.value = rangeModel.value.toString();
			}

			//(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
	}
}
