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

package mx.charts.skins.halo
{

import mx.display.Graphics;
import org.apache.royale.geom.Rectangle;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

/**
 *  @private
 */
public class SelectionSkin extends ProgrammaticSkin
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SelectionSkin() 
	{
		super();
	}

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var fill:IFill =
			GraphicsUtilities.fillFromStyle(getStyle("selectionFill"));
		var stroke:IStroke = getStyle("selectionStroke");
				
		var w:Number = stroke ? stroke.weight / 2 : 0;
		var rc:Rectangle = new Rectangle(w, w, width - 2 * w, height - 2 * w);
		
		var g:Graphics = graphics;
		g.clear();		
		g.moveTo(rc.left, rc.top);
		if (stroke)
			stroke.apply(g);
		if (fill)
			fill.begin(g, rc);
		g.lineTo(rc.right, rc.top);
		g.lineTo(rc.right, rc.bottom);
		g.lineTo(rc.left, rc.bottom);
		g.lineTo(rc.left, rc.top);
		if (fill)
			fill.end(g);
	}
}

}
