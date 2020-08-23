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
package org.apache.royale.jewel.beads.views
{
    COMPILE::SWF
	{
	import flash.utils.setTimeout;

	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IMeasurementBead;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.IBackgroundBead;
	import org.apache.royale.html.beads.IBorderBead;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	}
    COMPILE::JS
	{
    import org.apache.royale.jewel.HGroup;
	}
    import org.apache.royale.core.IAlertModel;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.CloseEvent;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.jewel.Alert;
    import org.apache.royale.jewel.Button;
    import org.apache.royale.jewel.Group;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.TitleBar;
    import org.apache.royale.jewel.VGroup;
    import org.apache.royale.jewel.beads.views.AlertTitleBarView;
	
	/**
	 *  The AlertView class creates the visual elements of the org.apache.royale.jewel.Alert
	 *  component. The job of the view bead is to put together the parts of the Alert, such as the 
	 *  title bar, message, and various buttons, within the space of the Alert component strand.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class AlertView extends GroupView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function AlertView()
		{
		}

        protected var alertModel:IAlertModel;
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var titleBar:TitleBar;

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var content:Group;

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var label:Label;

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var controlBar:UIBase;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var okButton:Button;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var cancelButton:Button;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var yesButton:Button;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var noButton:Button;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::SWF
            {
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(value, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				loadBeadFromValuesManager(IBackgroundBead, "iBackgroundBead", value);
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
				loadBeadFromValuesManager(IBorderBead, "iBorderBead", value);
			}
            }

			alertModel = (_strand as UIBase).model as IAlertModel;

			// TitleBar
			titleBar = new TitleBar();
			titleBar.addBead(new AlertTitleBarView());
			titleBar.title = alertModel.title;
			IParent(_strand).addElement(titleBar);

			// Text
			label = new Label();
			label.multiline = true;
			label.html = alertModel.message ? alertModel.message : "";
			
			content = new VGroup();
			content.addClass("content");
			content.addElement(label);
			IParent(_strand).addElement(content);
			
			// controlBar
			createButtons();
			IParent(_strand).addElement(controlBar);

			COMPILE::SWF
            {
            refreshSize();
            }

			setTimeout(prepareForPopUp,  300);
		}

		private function prepareForPopUp():void
        {
			COMPILE::JS
			{
			UIBase(_strand).element.classList.add("open");
			}
		}

		private function createButtons():void
		{
			COMPILE::SWF
			{
			controlBar = new Group();
            }

			COMPILE::JS
			{
			controlBar = new HGroup();
			controlBar.className = "controlbar";

			(controlBar as HGroup).itemsHorizontalAlign = "itemsRight";
			(controlBar as HGroup).gap = 2;
			}

            var flags:uint = alertModel.flags;

            if( flags & Alert.OK )
            {
                okButton = new Button();
				okButton.width = 100;
				okButton.emphasis = StyledUIBase.PRIMARY;
                okButton.text = alertModel.okLabel;
                okButton.addEventListener(MouseEvent.CLICK, handleOK);

                controlBar.addElement(okButton);
            }

			if( flags & Alert.CANCEL )
            {
                cancelButton = new Button();
				cancelButton.width = 100;
                cancelButton.text = alertModel.cancelLabel;
                cancelButton.addEventListener(MouseEvent.CLICK, handleCancel);

                controlBar.addElement(cancelButton);
            }
            
            if( flags & Alert.YES )
            {
                yesButton = new Button();
				yesButton.width = 100;
				yesButton.emphasis = StyledUIBase.PRIMARY;
                yesButton.text = alertModel.yesLabel;
                yesButton.addEventListener(MouseEvent.CLICK, handleYes);

                controlBar.addElement(yesButton);
            }

			if( flags & Alert.NO )
            {
                noButton = new Button();
				noButton.width = 100;
                noButton.text = alertModel.noLabel;
                noButton.addEventListener(MouseEvent.CLICK, handleNo);

                controlBar.addElement(noButton);
            }
		}

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		private function refreshSize():void
		{
			var labelMeasure:IMeasurementBead = label.measurementBead;
			var titleMeasure:IMeasurementBead = titleBar.measurementBead;
			var titleBarWidth:Number = titleBar ? titleBar.measurementBead.measuredWidth : 0;

			var maxWidth:Number = Math.max(titleMeasure.measuredWidth, titleBarWidth, labelMeasure.measuredWidth);

			var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(_strand as IUIBase);

            var titleBarHeight:Number = 0;
			if (titleBar)
            {
                titleBarHeight = titleBar.height;
                titleBar.x = 0;
                titleBar.y = 0;
                titleBar.width = maxWidth;
                titleBar.dispatchEvent(new Event("layoutNeeded"));
            }

			// content placement here
			label.x = metrics.left;
			label.y = titleBarHeight + metrics.top;
			label.width = maxWidth - metrics.left - metrics.right;
			
			controlBar.x = 0;
			controlBar.y = titleBarHeight + label.y + label.height + metrics.bottom;
			controlBar.width = maxWidth;
			controlBar.dispatchEvent(new Event("layoutNeeded"));
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = titleBarHeight + label.height + controlBar.height + metrics.top + metrics.bottom;
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
			var closeEvent:CloseEvent = new CloseEvent("close", false, false, buttonFlag);
			IEventDispatcher(_strand).dispatchEvent(closeEvent);
		}
	}
}
