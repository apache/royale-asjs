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
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	
	public class TextButtonMeasurementBead implements IMeasurementBead
	{
		public function TextButtonMeasurementBead()
		{
		}
		
		public function get measuredWidth():Number
		{
			var bead:TextButtonBead = _strand.getBeadByType(ITextButtonBead) as TextButtonBead;
			if( bead ) return Math.max(bead.upTextField.textWidth,bead.downTextField.textWidth,bead.overTextField.textWidth);
			else return 0;
		}
		
		public function get measuredHeight():Number
		{
			var bead:TextButtonBead = _strand.getBeadByType(ITextButtonBead) as TextButtonBead;
			if( bead ) return Math.max(bead.upTextField.textHeight,bead.downTextField.textHeight,bead.overTextField.textHeight);
			else return 0;
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}