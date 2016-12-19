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
	COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.display.Sprite;
	}
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
    import org.apache.flex.mdl.Button;
    import org.apache.flex.html.beads.ISliderView;
	
	/**
	 *  The SliderView class creates the visual elements of the org.apache.flex.html.Slider 
	 *  component. The Slider has a track and a thumb control which are also created with view beads.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SliderView extends BeadViewBase implements ISliderView, IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SliderView()
		{
		}
		
		private var rangeModel:IRangeModel;
		
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
				var s:UIBase = UIBase(_strand);
				
				_track = new Button();
				_track.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iTrackView")) as IBead);
				_track.className = "SliderTrack";
				s.addElement(_track);
				
				_thumb = new Button();
				_thumb.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iThumbView")) as IBead);
				_thumb.className = "SliderThumb";
				s.addElement(_thumb);
				
			}
			COMPILE::JS {
				_track = new Button();
				//_track.className = "SliderTrack";
				UIBase(_strand).addElement(_track);
				
				_thumb = new Button();
				//_thumb.className = "SliderThumb";
				UIBase(_strand).addElement(_thumb);
			}
			
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
			
			rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;
			
			// listen for changes to the model and adjust the UI accordingly.
			IEventDispatcher(rangeModel).addEventListener("valueChange",modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("minimumChange",modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("maximumChange",modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("stepSizeChange",modelChangeHandler);
			IEventDispatcher(rangeModel).addEventListener("snapIntervalChange",modelChangeHandler);
			
			sizeChangeHandler(null);
		}
		
		private var _track:Button;
		private var _thumb:Button;
		
		
		/**
		 *  The track component.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
		 */
		public function get thumb():IUIBase
		{
			return _thumb;
		}
		
		/**
		 * @private
		 */
		private function sizeChangeHandler( event:Event ) : void
		{
			var host:UIBase = UIBase(_strand);
			var w:Number = host.width;
			var h:Number = host.height;
			
			_thumb.width = 20;
			_thumb.height = host.height;
		
			// the track is inset 1/2 of the thumbwidth so the thumb can
			// overlay the track on either end with the thumb center being
			// on the track's edge
			_track.width = host.width - _thumb.width;
			_track.height = 5;
			_track.x = _thumb.width/2;
			_track.y = (host.height - _track.height)/2;
			
			setThumbPositionFromValue(rangeModel.value);
		}
		
		/**
		 * @private
		 */
		private function modelChangeHandler( event:Event ) : void
		{
			setThumbPositionFromValue(rangeModel.value);
		}
		
		/**
		 * @private
		 */
		private function setThumbPositionFromValue( value:Number ) : void
		{
			var p:Number = (value-rangeModel.minimum)/(rangeModel.maximum-rangeModel.minimum);
			var xloc:Number = (p*_track.width); 
			_thumb.x = xloc;
		}
	}
}
