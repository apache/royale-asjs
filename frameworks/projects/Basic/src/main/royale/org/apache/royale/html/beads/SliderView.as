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
package org.apache.royale.html.beads
{
	COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.display.Sprite;
	}
	
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IRangeModel;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.Button;
    import org.apache.royale.html.TextButton;
    import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The SliderView class creates the visual elements of the org.apache.royale.html.Slider 
	 *  component. The Slider has a track and a thumb control which are also created with view beads.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SliderView extends BeadViewBase implements ISliderView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SliderView()
		{
		}
		
		private var rangeModel:IRangeModel;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 * 
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var layout:IBeadLayout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
			if (layout == null) {
				var klass:Class = ValuesManager.valuesImpl.getValue(_strand, "iBeadLayout");
				_strand.addBead(new klass() as IBead);
			}
			
			COMPILE::SWF {
				var s:UIBase = UIBase(_strand);
				
				_track = new Button();
				_track.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iTrackView")) as IBead);
				_track.className = "SliderTrack";
				s.addElement(_track);
				
				_thumb = new TextButton();
				_thumb.text = '\u29BF';
				_thumb.addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iThumbView")) as IBead);
				_thumb.className = "SliderThumb";
				s.addElement(_thumb);
				
			}
			COMPILE::JS {
				_track = new Button();
				_track.className = "SliderTrack";
				_track.style = {"position": "absolute", "padding" : 0};
				(host as IParent).addElement(_track);
				
				_thumb = new TextButton();
				_thumb.className = "SliderThumb";
				_thumb.style = {"position" : "absolute", "padding" : 0};
				_thumb.text = '\u29BF';
				(host as IParent).addElement(_thumb);
			}
			
			rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;

			var rm:IEventDispatcher = rangeModel as IEventDispatcher;
			
			// listen for changes to the model and adjust the UI accordingly.
			rm.addEventListener("valueChange",modelChangeHandler);
			rm.addEventListener("minimumChange",modelChangeHandler);
			rm.addEventListener("maximumChange",modelChangeHandler);
			rm.addEventListener("stepSizeChange",modelChangeHandler);
			rm.addEventListener("snapIntervalChange",modelChangeHandler);
			sendStrandEvent(_strand,"layoutNeeded");
		}
		
		private var _track:Button;
		private var _thumb:TextButton;
		
		
		/**
		 *  The track component.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function get thumb():IUIBase
		{
			return _thumb;
		}
		
		/**
		 * @private
		 */
		private function modelChangeHandler( event:Event ) : void
		{
			sendStrandEvent(_strand,"layoutNeeded");
		}
	}
}
