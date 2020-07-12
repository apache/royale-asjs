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
	import org.apache.royale.core.IMeasurementBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.TitleBar;
	import org.apache.royale.core.Bead;
	
	/**
	 *  The TitleBarMeasurementBead class measures the overall size of a 
	 *  org.apache.royale.html.TitleBar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TitleBarMeasurementBead extends Bead implements IMeasurementBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TitleBarMeasurementBead()
		{
		}
		
		/**
		 *  The overall width of the org.apache.royale.html.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.html.TitleBar
		 *  @royaleignorecoercion org.apache.royale.html.beads.TitleBarView
		 */
		public function get measuredWidth():Number
		{
			var mwidth:Number = 0;
			//TODO this should use interfaces
			var titleBar:TitleBar = _strand as TitleBar;
			var titleView:TitleBarView = _strand.getBeadByType(TitleBarView) as TitleBarView;
			var labelMeasure:IMeasurementBead = titleView.titleLabel.measurementBead;
			mwidth = labelMeasure.measuredWidth;
			if( titleBar.showCloseButton ) {
				var buttonMeasure:IMeasurementBead = titleView.closeButton.measurementBead;
				mwidth += buttonMeasure.measuredWidth;
			}
			return mwidth;
		}
		
		/**
		 *  The overall height of the org.apache.royale.html.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.html.TitleBar
		 *  @royaleignorecoercion org.apache.royale.html.beads.TitleBarView
		 */
		public function get measuredHeight():Number
		{
			var mheight:Number = 0;
			//TODO this should use interfaces
			var titleBar:TitleBar = _strand as TitleBar;
			var titleView:TitleBarView = _strand.getBeadByType(TitleBarView) as TitleBarView;
			var labelMeasure:IMeasurementBead = titleView.titleLabel.measurementBead;
			mheight = labelMeasure.measuredHeight;
			if( titleBar.showCloseButton ) {
				var buttonMeasure:IMeasurementBead = titleView.closeButton.measurementBead;
				mheight = Math.max(mheight,buttonMeasure.measuredHeight);
			}
			return mheight;
		}
		
	}
}
