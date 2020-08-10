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
package org.apache.royale.jewel.supportClasses.table
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 *  TableColumn define a column for a Jewel Table component
	 *  with special table properties.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TableColumn extends EventDispatcher implements ITableColumn
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TableColumn()
		{
		}
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The itemRenderer class or factory to use to make instances of itemRenderers for
		 *  display of data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}

		protected var _explicitColumnWidth:Number;
        /**
         *  The explicitly set columnWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function get explicitColumnWidth():Number
		{
			return _explicitColumnWidth;
		}
        /**
         *  @private
         */
        public function set explicitColumnWidth(value:Number):void
		{
			if (_explicitColumnWidth == value)
				return;
			
			// width can be pixel or percent not both
			if (!isNaN(value))
				_percentColumnWidth = NaN;
			
			_explicitColumnWidth = value;
			// sendEvent(this,"explicitColumnWidthChanged");
		}

		protected var _percentColumnWidth:Number = NaN;
		/**
         *  The requested percentage width this component
         *  should have in the parent container.  Note that
         *  the actual percentage may be different if the 
         *  total is more than 100% or if there are other
         *  components with explicitly set widths.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function get percentColumnWidth():Number
		{
			return _percentColumnWidth;
		}
		/**
         *  @private
         */
		public function set percentColumnWidth(value:Number):void
		{
			COMPILE::SWF {
				if (_percentColumnWidth == value)
					return;
				
				if (!isNaN(value))
					_explicitColumnWidth = NaN;
				
				_percentColumnWidth = value;
			}
			COMPILE::JS {
				this._percentColumnWidth = value;
				
				// this.positioner.style.width = value.toString() + '%';
				if (!isNaN(value))
					this._explicitColumnWidth = NaN;
			}
			// sendEvent(this,"percentColumnWidthChanged");
		}
		
		protected var _columnWidth:Number = NaN;
		/**
		 *  The width of the column (default is 100 pixels).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion String
		 */
		[Bindable("columnWidthChanged")]
		[PercentProxy("percentColumnWidth")]
		public function get columnWidth():Number
		{
			if (!isNaN(_columnWidth))
                return _columnWidth;
            // if (!isNaN(_explicitColumnWidth))
            return _explicitColumnWidth;
            // var pixels:Number;
            // var strpixels:String = element.style.width as String;
            // if(strpixels == null)
            //     pixels = NaN;
            // else
            //     pixels = CSSUtils.toNumber(strpixels,NaN);
            // if (isNaN(pixels)) {
            //     pixels = positioner.offsetWidth;
            //     if (pixels == 0 && positioner.scrollWidth != 0) {
            //         // invisible child elements cause offsetWidth to be 0.
            //         pixels = positioner.scrollWidth;
            //     }
            // }
            // return pixels;
		}
		public function set columnWidth(value:Number):void
		{
			if (explicitColumnWidth !== value)
            {
                explicitColumnWidth = value;
            }
            
            setColumnWidth(value);
		}

		/**
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function setColumnWidth(value:Number, noEvent:Boolean = false):void
        {
            if (_columnWidth !== value)
            {
                _columnWidth = value;
				
                // COMPILE::JS
                // {
                //     this.positioner.style.width = value.toString() + 'px';        
                // }
                // if (!noEvent)
                //     sendEvent(this,"columnWidthChanged");
            }
        }
		
		private var _label:String;
		
		/**
		 *  The label for the column (appears in the header area).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable("labelChanged")]
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			if (value !== _label)
            {
                _label = value;
                dispatchEvent(new Event('labelChanged'));
            }
		}
		
		private var _dataField:String;
		
		/**
		 *  The name of the field containing the data value presented by the column. This value is used
		 *  by the itemRenderer is select the property from the data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
		}

		private var _labelFunction:Function;
        /**
         *  A user-supplied function to run on each item to determine its label.  
         *  By default, the list looks for a property named <code>label</code> 
         *  on each data provider item and displays it.
         *  However, some data sets do not have a <code>label</code> property
         *  nor do they have another property that can be used for displaying.
         *  An example is a data set that has lastName and firstName fields
         *  but you want to display full names.
         *
         *  <p>You can supply a <code>labelFunction</code> that finds the 
         *  appropriate fields and returns a displayable string. The 
         *  <code>labelFunction</code> is also good for handling formatting and 
         *  localization. </p>
         *
         *  <p>For most components, the label function takes a single argument
         *  which is the item in the data provider and returns a String.</p>
         *  <pre>
         *  myLabelFunction(item:Object):String</pre>
         *
         *  <p>The method signature for the data grid classes is:</p>
         *  <pre>
         *  myLabelFunction(item:Object, column:DataGridColumn):String</pre>
         * 
         *  <p>where <code>item</code> contains the DataGrid item object, and
         *  <code>column</code> specifies the DataGrid column.</p>
         *
         *  @default null
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.10.0
         */
        public function get labelFunction():Function
        {
            return _labelFunction;
        }
        /**
         *  @private
         */
        public function set labelFunction(value:Function):void
        {
            _labelFunction = value;
        }
		
		private var _className:String;
		
		/**
		 *  The name of the style class to use for this column.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get className():String
		{
			return _className;
		}
		public function set className(value:String):void
		{
			_className = value;
		}

		private var _align:String = "";
		/**
		 *  How text align in the column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;
		}

		private var _columnLabelAlign:String = ""
		/**
		 *  How column label text align in the header
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get columnLabelAlign():String
		{
			return _columnLabelAlign;
		}

		public function set columnLabelAlign(value:String):void
		{
			_columnLabelAlign = value;
		}
	}
}
