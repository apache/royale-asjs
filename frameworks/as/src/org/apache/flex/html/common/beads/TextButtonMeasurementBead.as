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
package org.apache.flex.html.common.beads
{
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.html.staticControls.beads.TextButtonView;
	
	public class TextButtonMeasurementBead implements IMeasurementBead
	{
		public function TextButtonMeasurementBead()
		{
		}
		
		public function get measuredWidth():Number
		{
			var view:TextButtonView = _strand.getBeadByType(TextButtonView) as TextButtonView;
			if( view ) return Math.max(view.upTextField.textWidth,view.downTextField.textWidth,view.overTextField.textWidth);
			else return 0;
		}
		
		public function get measuredHeight():Number
		{
			var view:TextButtonView = _strand.getBeadByType(TextButtonView) as TextButtonView;
			if( view ) return Math.max(view.upTextField.textHeight,view.downTextField.textHeight,view.overTextField.textHeight);
			else return 0;
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}