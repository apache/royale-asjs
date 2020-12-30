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
package org.apache.royale.jewel.beads.controls.datechooser
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.jewel.beads.controls.Disabled;
    import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;
    import org.apache.royale.jewel.beads.models.DateChooserModel;
    import org.apache.royale.jewel.beads.views.DateChooserView;
    import org.apache.royale.jewel.supportClasses.datechooser.DateChooserTable;
    import org.apache.royale.jewel.supportClasses.table.TBodyContentArea;
    import org.apache.royale.jewel.supportClasses.table.TableCell;
    import org.apache.royale.jewel.supportClasses.table.TableRow;
													
	/**
	 *  Disable dates which are outside restriction provided by minDate and maxDate properties
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DateRangeRestriction implements IBead
	{
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function DateRangeRestriction()
		{
		}
		
		private var _minDate:Date;
        /**
         *  The minimun date
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		[Bindable]
		public function get minDate():Date
		{
			return _minDate;
		}
		public function set minDate(value:Date):void
		{
			if (_minDate != value)
			{
				_minDate = value;
				refreshDateRange();
			}
		}
		
		private var _maxDate:Date;
        /**
         *  The maximun date
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		[Bindable]
		public function get maxDate():Date
		{
			return _maxDate;
		}
		public function set maxDate(value:Date):void
		{
			if (_maxDate != value)
			{
				_maxDate = value;
				refreshDateRange();
			}
		}
		
		private var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(_strand as IEventDispatcher).addEventListener("initComplete", handlerDateChooserInitComplete);
		}
		
		private function handlerDateChooserInitComplete(event:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener("initComplete", handlerDateChooserInitComplete);
			
			refreshDateRange();
		}
		
		protected function refreshDateRange():void
		{
            if (!minDate || !maxDate) return;
			
			var model:DateChooserModel = _strand.getBeadByType(DateChooserModel) as DateChooserModel;
            var dateChooserView:DateChooserView = _strand.getBeadByType(DateChooserView) as DateChooserView;
            var table:DateChooserTable = dateChooserView.table;
            var tableContent:TBodyContentArea = table.getBeadByType(TBodyContentArea) as TBodyContentArea;
            
            var n:int = table.dataProvider.length;
			for (var i:int = 0; i < tableContent.numElements; i++)
			{
				var row:TableRow = tableContent.getElementAt(i) as TableRow;
			    for(var j:int = 0; j < row.numElements; j++)
				{
			        var tableCell:TableCell = row.getElementAt(j) as TableCell;
			        var renderer:ITextItemRenderer  = tableCell.getElementAt(0) as ITextItemRenderer;
                    disableRenderer(renderer);
		        }
		    }
		}		
		
		private function disableRenderer(renderer:ITextItemRenderer):void
		{
			var rendererDate:Date = renderer.data[renderer.labelField];
            if (!rendererDate) return;
			
			var minTime:Number = minDate.getTime();
			var maxTime:Number = maxDate.getTime();
			var itemTime:Number = rendererDate.getTime();
			
			var disabled:Disabled = (renderer as IStrand).getBeadByType(Disabled) as Disabled;
			if (disabled == null)
			{
			    disabled = new Disabled();
				(renderer as IStrand).addBead(disabled);
			}

			if ((minTime < itemTime) && (itemTime > maxTime))
			{
                trace("disabling ", rendererDate.day, rendererDate.month, rendererDate.fullYear, " -- ", minDate.day, minDate.month, minDate.fullYear, " -- ", maxDate.day, maxDate.month, maxDate.fullYear);
				disabled.disabled = true;
			}
			else
			{
                trace(" - ENABLING ", rendererDate.day, rendererDate.month, rendererDate.fullYear, " -- ", minDate.day, minDate.month, minDate.fullYear, " -- ", maxDate.day, maxDate.month, maxDate.fullYear);
				disabled.disabled = false;
			}
		}
    }
}