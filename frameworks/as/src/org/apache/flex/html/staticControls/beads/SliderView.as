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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Button;
	
	public class SliderView implements ISliderView, IBeadView
	{
		public function SliderView()
		{
		}
		
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			_track = new Button();
			Button(_track).addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iTrackView")) as IBead);
			
			_thumb = new Button();
			Button(_thumb).addBead(new (ValuesManager.valuesImpl.getValue(_strand, "iThumbView")) as IBead);
			
			UIBase(_strand).addChild(_track);
			UIBase(_strand).addChild(_thumb);
			
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
			
			rangeModel = _strand.getBeadByType(IBeadModel) as IRangeModel;
			
			// set a minimum size to trigger the size change handler
			var needsSizing:Boolean = true;
			if( UIBase(_strand).width < 100 ) {
				UIBase(_strand).width = 100;
				needsSizing = false;
			}
			if( UIBase(_strand).height < 30 ) {
				UIBase(_strand).height = 30;
				needsSizing = false;
			}
			
			if( needsSizing ) sizeChangeHandler(null);
		}
		
		private var _track:DisplayObject;
		private var _thumb:DisplayObject;
		
		public function get track():DisplayObject
		{
			return _track;
		}
		
		public function get thumb():DisplayObject
		{
			return _thumb;
		}
		
		private function sizeChangeHandler( event:Event ) : void
		{
			var w:Number = UIBase(_strand).width;
			var h:Number = UIBase(_strand).height;
			
			_track.width = UIBase(_strand).width;
			_track.height = 5;
			_track.x = 0;
			_track.y = (UIBase(_strand).height - _track.height)/2;
			
			_thumb.width = 20;
			_thumb.height = UIBase(_strand).height;
			
			_thumb.x = 10;
			_thumb.y = 0;//(UIBase(_strand).height - _thumb.height)/2;
			
			trace("track y="+_track.y+"; _thumb y="+_thumb.y);
		}
	}
}