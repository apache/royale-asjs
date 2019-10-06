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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.text.engine.TextBaseline;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.LeadingModel;

	public class LeadingUtils
	{
		/** @private */
		public static function getLeadingBasis(leadingModel:String):String
		{
			switch (leadingModel)
			{
				default:
					CONFIG::debug
					{
						assert(false, "Unsupported parameter to ParagraphElement.getLeadingBasis"); } // In particular, AUTO is not supported by this method. Must be mapped to one of the above
				case LeadingModel.ASCENT_DESCENT_UP:
				case LeadingModel.APPROXIMATE_TEXT_FIELD:
				case LeadingModel.BOX:
				case LeadingModel.ROMAN_UP:
					return org.apache.royale.text.engine.TextBaseline.ROMAN;
				case LeadingModel.IDEOGRAPHIC_TOP_UP:
				case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
					return org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_TOP;
				case LeadingModel.IDEOGRAPHIC_CENTER_UP:
				case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
					return org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_CENTER;
			}
            return null; // makes closure compiler 20181210 happy
		}

		/** @private */
		public static function useUpLeadingDirection(leadingModel:String):Boolean
		{
			switch (leadingModel)
			{
				default:
					CONFIG::debug
					{
						assert(false, "Unsupported parameter to ParagraphElement.useUpLeadingDirection"); } // In particular, AUTO is not supported by this method. Must be mapped to one of the above
				case LeadingModel.ASCENT_DESCENT_UP:
				case LeadingModel.APPROXIMATE_TEXT_FIELD:
				case LeadingModel.BOX:
				case LeadingModel.ROMAN_UP:
				case LeadingModel.IDEOGRAPHIC_TOP_UP:
				case LeadingModel.IDEOGRAPHIC_CENTER_UP:
					return true;
				case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
				case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
					return false;
			}
            return true; // makes closure compiler 20181210 happy
		}
	}
}
