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

package mx.skins.halo
{

import mx.display.Graphics;
import org.apache.royale.reflection.getQualifiedClassName;
import org.apache.royale.reflection.describeType;
import org.apache.royale.reflection.getAncestry;

import mx.containers.BoxDirection;
import mx.skins.ProgrammaticSkin;



/**
 *  The skin for the separator between the Links in a LinkBar.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LinkSeparator extends ProgrammaticSkin {
	//include "../../core/Version.as";

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
	public function LinkSeparator() {
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
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		var separatorColor:uint = getStyle("separatorColor");
		var separatorWidth:Number = getStyle("separatorWidth");

		var isVertical:Boolean = false;

		var g:Graphics = graphics;

		g.clear();

		if (separatorWidth > 0) {
			if (isBox(parent))
				isVertical = Object(parent).direction == BoxDirection.VERTICAL;

			g.lineStyle(separatorWidth, separatorColor);
			if (isVertical) {
				g.moveTo(4, h / 2);
				g.lineTo(w - 4, h / 2);
			} else {
				g.moveTo(w / 2, 6);
				g.lineTo(w / 2, h - 5);
			}
		}
	}

	/**
	 *  We don't use 'is' to prevent dependency issues
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private static var boxes:Object = {};

	private static function isBox(parent:Object):Boolean {
		var s:String = getQualifiedClassName(parent);
		if (boxes[s] == 1)
			return true;

		if (boxes[s] == 0)
			return false;

		if (s == "mx.containers.Box") {
			boxes[s] == 1;
			return true;
		}

		var ancestry:Array = getAncestry(parent);
		if (ancestry.indexOf('mx.containers.Box') != -1) {
			boxes[s] = 0;
			return false;
		}


		boxes[s] = 1;
		return true;
	}
}
}