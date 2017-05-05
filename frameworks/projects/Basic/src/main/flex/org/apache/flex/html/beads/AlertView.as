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
package org.apache.flex.html.beads
{
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IAlertModel;
	import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IMeasurementBead;
    import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    import org.apache.flex.events.MouseEvent;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.Alert;
	import org.apache.flex.html.ControlBar;
    import org.apache.flex.html.Label;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.CSSContainerUtils;
	
	/**
	 *  The AlertView class creates the visual elements of the org.apache.flex.html.Alert
	 *  component. The job of the view bead is to put together the parts of the Alert, such as the 
	 *  title bar, message, and various buttons, within the space of the Alert component strand.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class AlertView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function AlertView()
		{
		}
		
		private var _titleBar:TitleBar;
		private var _controlBar:ControlBar;
		private var _label:Label;
		private var _okButton:TextButton;
		private var _cancelButton:TextButton;
		private var _yesButton:TextButton;
		private var _noButton:TextButton;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(value, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				if (value.getBeadByType(IBackgroundBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBackgroundBead")) as IBead);					
			}
			
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border");
			if (borderStyles is Array)
			{
				borderStyle = borderStyles[1];
			}
			if (borderStyle == null)
			{
				borderStyle = ValuesManager.valuesImpl.getValue(value, "border-style") as String;
			}
			if (borderStyle != null && borderStyle != "none")
			{
				if (value.getBeadByType(IBorderBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);	
			}
			
			var flags:uint = IAlertModel(UIBase(_strand).model).flags;
			if( flags & Alert.OK ) {
				_okButton = new TextButton();
				_okButton.text = IAlertModel(UIBase(_strand).model).okLabel;
				_okButton.addEventListener("click",handleOK);
			}
			if( flags & Alert.CANCEL ) {
				_cancelButton = new TextButton();
				_cancelButton.text = IAlertModel(UIBase(_strand).model).cancelLabel;
				_cancelButton.addEventListener("click",handleCancel);
			}
			if( flags & Alert.YES ) {
				_yesButton = new TextButton();
				_yesButton.text = IAlertModel(UIBase(_strand).model).yesLabel;
				_yesButton.addEventListener("click",handleYes);
			}
			if( flags & Alert.NO ) {
				_noButton = new TextButton();
				_noButton.text = IAlertModel(UIBase(_strand).model).noLabel;
				_noButton.addEventListener("click",handleNo);
			}
			
			_titleBar = new TitleBar();
			_titleBar.title = IAlertModel(UIBase(_strand).model).title;
			
			_label = new Label();
			_label.text = IAlertModel(UIBase(_strand).model).message;
			
			_controlBar = new ControlBar();
			if( _okButton ) _controlBar.addElement(_okButton);
			if( _cancelButton ) _controlBar.addElement(_cancelButton);
			if( _yesButton  ) _controlBar.addElement(_yesButton);
			if( _noButton ) _controlBar.addElement(_noButton);
			
		    IParent(_strand).addElement(_titleBar);
            IParent(_strand).addElement(_controlBar);
            IParent(_strand).addElement(_label);
			
			sizeHandler(null);
		}
		
		/**
		 * @private
		 */
		private function sizeHandler(event:Event):void
		{
			var labelMeasure:IMeasurementBead = _label.measurementBead;
			var titleMeasure:IMeasurementBead = _titleBar.measurementBead;
			var ctrlMeasure:IMeasurementBead  = _controlBar.measurementBead;
			var maxWidth:Number = Math.max(titleMeasure.measuredWidth, ctrlMeasure.measuredWidth, labelMeasure.measuredWidth);
			
			var metrics:Rectangle = CSSContainerUtils.getBorderAndPaddingMetrics(_strand);

			_titleBar.x = 0;
			_titleBar.y = 0;
			_titleBar.width = maxWidth;
			_titleBar.height = 25;
			_titleBar.dispatchEvent(new Event("layoutNeeded"));
			
			// content placement here
			_label.x = metrics.left;
			_label.y = _titleBar.y + _titleBar.height + metrics.top;
			_label.width = maxWidth - metrics.left - metrics.right;
			
			_controlBar.x = 0;
			_controlBar.y = _titleBar.height + _label.y + _label.height + metrics.bottom;
			_controlBar.width = maxWidth;
			_controlBar.height = 25;
			_controlBar.dispatchEvent(new Event("layoutNeeded"));
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = _titleBar.height + _label.height + _controlBar.height + metrics.top + metrics.bottom;
		}
		
		/**
		 * @private
		 */
		private function handleOK(event:MouseEvent):void
		{
			// create some custom event where the detail value
			// is the OK button flag. Do same for other event handlers
			dispatchCloseEvent(Alert.OK);
		}
		
		/**
		 * @private
		 */
		private function handleCancel(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.CANCEL);
		}
		
		/**
		 * @private
		 */
		private function handleYes(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.YES);
		}
		
		/**
		 * @private
		 */
		private function handleNo(event:MouseEvent):void
		{
			dispatchCloseEvent(Alert.NO);
		}
		
		/**
		 * @private
		 */
		public function dispatchCloseEvent(buttonFlag:uint):void
		{
			// TO DO: buttonFlag should be part of the event
			var newEvent:Event = new Event("close",true);
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}
	}
}
