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

package flashx.textLayout.ui.rulers
{
	import mx.skins.RectangularBorder;

	public class ParagraphPropertyMarkerSkin extends RectangularBorder
	{
		public function ParagraphPropertyMarkerSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
		    super.updateDisplayList(w, h);
		    
		    var propKind:String = getStyle("propkind");
		    var rightToLeftPar:Boolean = getStyle("rightToLeftPar");
		    
		    var t:Number = 0;
		    var b:Number = h;
		    
			graphics.clear();

			graphics.beginFill(0x000000);
			if (rightToLeftPar)
			{
				switch(propKind) {
				case "textIndent":
					b = (h - 1) / 2;
					graphics.moveTo(w, 0);
					graphics.lineTo(w, b);
					graphics.lineTo(0, b);
					graphics.lineTo(w, 0);
					break;
				case "paragraphStartIndent":
					graphics.moveTo(0, 0);
					graphics.lineTo(0, h);
					graphics.lineTo(w, h / 2);
					graphics.lineTo(0, 0);
					break;
				case "paragraphEndIndent":
					t = h - (h - 1) / 2;
					graphics.moveTo(w, h);
					graphics.lineTo(0, t);
					graphics.lineTo(w, t);
					graphics.lineTo(w, h);
					break;
				}
			}
			else
			{
				switch(propKind) {
				case "textIndent":
					b = (h - 1) / 2;
					graphics.moveTo(0, 0);
					graphics.lineTo(w, b);
					graphics.lineTo(0, b);
					graphics.lineTo(0, 0);
					break;
				case "paragraphStartIndent":
					t = h - (h - 1) / 2;
					graphics.moveTo(0, h);
					graphics.lineTo(0, t);
					graphics.lineTo(w, t);
					graphics.lineTo(0, h);
					break;
				case "paragraphEndIndent":
					graphics.moveTo(w, 0);
					graphics.lineTo(w, h);
					graphics.lineTo(0, h / 2);
					graphics.lineTo(w, 0);
					break;
				}
			}
			graphics.endFill();
			
			// this makes the whole rect hittable
	  		graphics.lineStyle();
	    	graphics.beginFill(0x0000ff, 0);
	    	graphics.drawRect(0, t, w, b);
	    	graphics.endFill();
		}
	}
}
