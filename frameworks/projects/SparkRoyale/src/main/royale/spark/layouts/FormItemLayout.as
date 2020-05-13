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

package spark.layouts
{
	import mx.containers.utilityClasses.ConstraintColumn;
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.GroupBase;
	
	use namespace mx_internal;
	
	/**
	 *  The FormItemLayout is used by FormItems to provide a constraint based layout.
	 *  Elements using FormItemLayout within a FormLayout are aligned along columns.  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */ 
	public class FormItemLayout extends ConstraintLayout
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function FormItemLayout()
		{
			super();
		}
		
		private var layoutColumnWidths:Vector.<Number> = null;
		
		/**
		 *  @private
		 *  Only resize columns and rows if setLayoutColumnWidths hasn't been called.
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			checkUseVirtualLayout();
			
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			// need to parse constraints and rows may resize.
			measureAndPositionColumnsAndRows(unscaledWidth, unscaledHeight);
			
			if (layoutColumnWidths)
				setColumnWidths(layoutColumnWidths);
			
			layoutContent(unscaledWidth, unscaledHeight);
		}
		
		/**
		 *  @private
		 *  Used by layout to get the measured column widths
		 */
		public function getMeasuredColumnWidths():Vector.<Number>
		{
			return measureColumns();
		}
		
		/**
		 *  @private
		 *  Used by layout to set the column widths for updateDisplayList. Must
		 *  call this if you want to override the default widths of the columns.
		 */
		public function setLayoutColumnWidths(value:Vector.<Number>):void
		{
			// apply new measurements and position the columns again.
			layoutColumnWidths = value;
			
			setColumnWidths(layoutColumnWidths);
			
			// target.invalidateDisplayList();
		}
		
	}
}