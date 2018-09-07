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
	import flash.text.engine.TabAlignment;
	
	import mx.skins.RectangularBorder;

	public class TabMarkerSkin extends RectangularBorder
	{
		public function TabMarkerSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
		    super.updateDisplayList(w, h);
		    
		    var tabKind:String = getStyle("tabkind");
		    
			graphics.clear();

		    graphics.lineStyle(3, 0xffffff);
		    drawOrnament(tabKind, w, h);
		    graphics.lineStyle(1, 0x000000);
		    drawOrnament(tabKind, w, h);
		    
		    if (tabKind == flash.text.engine.TabAlignment.DECIMAL)
		    {
				graphics.beginFill(0x000000);
				graphics.drawCircle(w / 2 + 3, (h - w / 2) / 2, .75);
				graphics.endFill();
		    }
		    
			graphics.beginFill(0x000000);
			graphics.moveTo(0, h - w / 2);
			graphics.lineTo(w / 2, h);
			graphics.lineTo(w, h - w / 2);
			graphics.lineTo(0, h - w / 2);
			graphics.endFill();
			
		    var selected:Boolean = getStyle("selected");
	  		graphics.lineStyle();
	    	graphics.beginFill(0x0000ff, selected ? .3 : 0);
	    	graphics.drawRect(0, 0, w, h);
	    	graphics.endFill();
		}

		private function drawOrnament(inKind:String, w:Number, h:Number):void
		{
			switch (inKind)
			{
			case flash.text.engine.TabAlignment.START:
				graphics.moveTo(w / 2, h - w / 2);
				graphics.lineTo(w / 2, 1);
				graphics.lineTo(w, 1);
				break;
			case flash.text.engine.TabAlignment.CENTER:
				graphics.moveTo(w / 2, h - w / 2);
				graphics.lineTo(w / 2, 0);
				break;
			case flash.text.engine.TabAlignment.END:
				graphics.moveTo(w / 2, h - w / 2);
				graphics.lineTo(w / 2, 1);
				graphics.lineTo(0, 1);
				break;
			case flash.text.engine.TabAlignment.DECIMAL:
				graphics.moveTo(w / 2, h - w / 2);
				graphics.lineTo(w / 2, 0);
				break;
			}
		}
		

	}
}