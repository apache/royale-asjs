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
package org.apache.royale.style
{
	import org.apache.royale.style.support.ContentContainerBase;

	public class GridContainer extends ContentContainerBase
	{
		public function GridContainer()
		{
			displayType = "grid";			
			super();
		}

		/**
		 * Sets the place-content property which is a shorthand for setting align-content and justify-content in a single declaration.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get placeContent():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["placeContent"];}
		}

		public function set placeContent(value:String):void
		{
			setStyle("place-content", value);
		}

		/**
		 * Sets the place-items property which is a shorthand for setting align-items and justify-items in a single declaration.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get placeItems():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["placeItems"];}
		}

		public function set placeItems(value:String):void
		{
			setStyle("place-items", value);
		}
		/**
		 * Sets the justify-items property.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get justifyItems():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["justifyItems"];}
		}

		public function set justifyItems(value:String):void
		{
			setStyle("justify-items", value);
		}

		/**
		 * Sets the grid property which is a shorthand for setting grid-template-rows, grid-template-columns,
		 * grid-template-areas, grid-auto-rows, grid-auto-columns, and grid-auto-flow in a single declaration.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get grid():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["grid"];}
		}

		public function set grid(value:String):void
		{
			setStyle("grid",value);
		}

		/**
		 * Sets the grid-row property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridRow():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridRow"];}
		}

		public function set gridRow(value:String):void
		{
			setStyle("grid-row", value);
		}

		/**
		 * Sets the grid-column property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridColumn():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridColumn"];}
		}

		public function set gridColumn(value:String):void
		{
			setStyle("grid-column", value);
		}

		/**
		 * Sets the grid-row-start property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridRowStart():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridRowStart"];}
		}

		public function set gridRowStart(value:String):void
		{
			setStyle("grid-row-start", value);
		}

		/**
		 * Sets the grid-row-end property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridRowEnd():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridRowEnd"];}
		}

		public function set gridRowEnd(value:String):void
		{
			setStyle("grid-row-end", value);
		}

		/**
		 * Sets the grid-column-start property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridColumnStart():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridColumnStart"];}
		}

		public function set gridColumnStart(value:String):void
		{
			setStyle("grid-column-start", value);
		}

		/**
		 * Sets the grid-column-end property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridColumnEnd():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridColumnEnd"];}
		}

		public function set gridColumnEnd(value:String):void
		{
			setStyle("grid-column-end", value);
		}

		
		/**
		 * Sets the grid-area property which is a shorthand for setting grid-row-start, grid-column-start, grid-row-end and grid-column-end in a single declaration.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridArea():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridArea"];}
		}

		public function set gridArea(value:String):void
		{
			setStyle("grid-area", value);
		}

		/**

		 * Sets the grid-template-columns property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridTemplateColumns():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridTemplateColumns"];}
		}

		public function set gridTemplateColumns(value:String):void
		{
			setStyle("grid-template-columns", value);
		}
		/**
		 * Sets the grid-template-rows property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridTemplateRows():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridTemplateRows"];}
		}

		public function set gridTemplateRows(value:String):void
		{
			setStyle("grid-template-rows", value);
		}

		/**
		 * Sets the grid-template-areas property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridTemplateAreas():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridTemplateAreas"];}
		}

		public function set gridTemplateAreas(value:String):void
		{
			setStyle("grid-template-areas", value);
		}

		/**
		 * Sets the grid-auto-rows property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridAutoRows():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridAutoRows"];}
		}

		public function set gridAutoRows(value:String):void
		{
			setStyle("grid-auto-rows", value);
		}

		/**
		 * Sets the grid-auto-columns property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridAutoColumns():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridAutoColumns"];}
		}

		public function set gridAutoColumns(value:String):void
		{
			setStyle("grid-auto-columns", value);
		}

		/**
		 * Sets the grid-auto-flow property.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get gridAutoFlow():String
		{
			COMPILE::SWF{return "";}
			COMPILE::JS{return element.style["gridAutoFlow"];}
		}

		public function set gridAutoFlow(value:String):void
		{
			setStyle("grid-auto-flow", value);
		}


	}
}