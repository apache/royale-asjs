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
package org.apache.royale.textLayout.edit {
	
	/**
	 * The SelectionFormat class defines the properties of a selection highlight.
	 * 
	 * @see org.apache.royale.textLayout.edit.ISelectionManager
	 * @see org.apache.royale.textLayout.edit.SelectionManager
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
 	 * @langversion 3.0
	 */
	public class SelectionFormat
	{
		private var _rangeColor:uint;
		private var _rangeAlpha:Number;
		private var _rangeBlendMode:String;
		
		private var _pointColor:uint;
		private var _pointAlpha:Number;
		private var _pointBlendMode:String;
		private var _pointBlinkRate:Number;
		private var _pointBlinkAlpha:Number;
		private var _pointBlinkColor:uint;
		
		/** 
		 * Creates a SelectionFormat object with the specified properties.
		 * 
		 * <p>A SelectionFormat created with the default values will use black for
		 * the highlight colors, 1.0 for the alphas, and BlendMode.DIFFERENCE for the blending modes.
		 * The cursor blink rate is 500 milliseconds.</p>
		 *
		 * <p>Setting the <code>pointAlpha</code> and <code>rangeAlpha</code> properties to zero disables selection highlighting.</p>
		 * 
		 * <p>Non-zero blink rate is only used when an EditManager is attached to the TextFlow.</p>
		 * 
		 * @param rangeColor The color for drawing the highlight.
		 * @param rangeAlpha The transparency value for drawing the highlight. Valid values are between 0
		 * (completely transparent) and 1 (completely opaque, which is the default).
		 * @param rangeBlendMode The blend mode for drawing the highlight. Use constants defined in the BlendMode class
		 * to set this parameter.
		 * @param pointColor The color for the drawing cursor.
		 * @param pointAlpha The transparency value for drawing the cursor. Valid values are between 0
		 * (completely transparent) and 1 (completely opaque, which is the default).
		 * @param pointBlendMode The blend mode for drawing the cursor. Use constants defined in the BlendMode class
		 * to set this parameter.
		 * @param pointBlinkRate The rate at which the cursor blinks, in milliseconds.
		 * 
		 * @see flash.display.BlendMode
		 * @see #pointAlpha
		 * @see #rangeAlpha
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */
		public function SelectionFormat(rangeColor:uint=0xffffff, rangeAlpha:Number=1.0, rangeBlendMode:String="difference", pointColor:uint=0xffffff, pointAlpha:Number=1.0, pointBlendMode:String="difference", pointBlinkRate:Number = 500,pointBlinkAlpha:Number=0,pointBlinkColor:uint=0)
		{ 
			_rangeColor = rangeColor;
			_rangeAlpha = rangeAlpha;
			_rangeBlendMode = rangeBlendMode;
			
			_pointColor = pointColor;
			_pointAlpha = pointAlpha;
			_pointBlendMode = pointBlendMode;
			_pointBlinkRate = pointBlinkRate;
			_pointBlinkAlpha = pointBlinkAlpha;
			_pointBlinkColor = pointBlinkColor;
		}
		
		/**
		 * The color for drawing the highlight of a range selection. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */		
		public function get rangeColor():uint
		{
			return _rangeColor;
		}

		/**
		 * The alpha for drawing the highlight of a range selection. Valid values are between 0
		 * (completely transparent) and 1 (completely opaque, which is the default).
		 *
		 * <p>Setting the <code>pointAlpha</code> and <code>rangeAlpha</code> properties to zero disables selection highlighting.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
 	 	 *
 	 	 * @see #pointAlpha
		 */						
		public function get rangeAlpha():Number
		{
			return _rangeAlpha;
		}

		/**
		 * The blending mode for drawing the highlight of a range selection. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 * @see flash.display.BlendMode
		 */						
		public function get rangeBlendMode():String
		{
			return _rangeBlendMode;
		}
		
		/**
		 * The color for drawing the cursor.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */		
		public function get pointColor():uint
		{
			return _pointColor;
		}

		/**
		 * The alpha for drawing the cursor. Valid values are between 0
		 * (completely transparent) and 1 (completely opaque, which is the default).
		 *
		 * <p>Setting the <code>pointAlpha</code> and <code>rangeAlpha</code> properties to zero disables selection highlighting.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
 	 	 *
 	 	 * @see #rangeAlpha
		 */						
		public function get pointAlpha():Number
		{
			return _pointAlpha;
		}
		
		/**
		 * The rate at which the cursor blinks, in milliseconds.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */						
		public function get pointBlinkRate():Number
		{
			return _pointBlinkRate;
		}

		/**
		 * The alpha of the cursor blinks while blinking.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */						
		public function get pointBlinkAlpha():Number
		{
			return _pointBlinkAlpha;
		}

		/**
		 * The color of the cursor while blinking.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */						
		public function get pointBlinkColor():uint
		{
			return _pointBlinkColor;
		}

		/**
		 * The blend mode for drawing the cursor.
		 * 
		 * @see flash.display.BlendMode
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */						
		public function get pointBlendMode():String
		{
			return _pointBlendMode;
		}

		/**
		 * Determines whether this SelectionFormat object has the same property values
		 * as another SelectionFormat object.
		 *  
		 * @return <code>true</code>, if the property values are identical; <code>false</code>, otherwise.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 * 
		 * @param selectionFormat	the SelectionFormat to compare against.
		 */								
		public function equals(selectionFormat:SelectionFormat):Boolean
		{
			if ((_rangeBlendMode == selectionFormat.rangeBlendMode) &&
				(_rangeAlpha == selectionFormat.rangeAlpha) &&
				(_rangeColor == selectionFormat.rangeColor) &&
				(_pointColor == selectionFormat.pointColor) &&
				(_pointAlpha == selectionFormat.pointAlpha) &&
				(_pointBlendMode == selectionFormat.pointBlendMode) &&
				(_pointBlinkRate == selectionFormat.pointBlinkRate))
				return true;
			return false;
		}
	}
}
