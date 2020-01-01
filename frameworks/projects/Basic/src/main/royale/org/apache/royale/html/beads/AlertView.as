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
package org.apache.royale.html.beads
{
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IAlertModel;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.CloseEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Alert;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.ControlBar;
	import org.apache.royale.html.Group;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.TitleBar;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.utils.sendEvent;

	COMPILE::SWF
	{
		import org.apache.royale.geom.Rectangle;
		import org.apache.royale.core.ValuesManager;
		import org.apache.royale.utils.loadBeadFromValuesManager;
		import org.apache.royale.core.IMeasurementBead;
		import org.apache.royale.html.beads.IBackgroundBead;
		import org.apache.royale.html.beads.IBorderBead;
	}
	COMPILE::JS
	{
		import org.apache.royale.utils.html.getStyle;
	}
	
	/**
	 *  The AlertView class creates the visual elements of the org.apache.royale.html.Alert
	 *  component. The job of the view bead is to put together the parts of the Alert, such as the 
	 *  title bar, message, and various buttons, within the space of the Alert component strand.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AlertView extends GroupView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AlertView()
		{
		}
		
		protected var titleBar:TitleBar;
		protected var controlBar:UIBase;
		protected var label:Label;
		protected var labelContent:Group;

		protected var okButton:TextButton;
		protected var cancelButton:TextButton;
		protected var yesButton:TextButton;
		protected var noButton:TextButton;

		protected var alertModel:IAlertModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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

			createButtons();

			if (alertModel.title)
			{
				titleBar = new TitleBar();
				titleBar.height = 25;
				titleBar.title = alertModel.title;
				IParent(_strand).addElement(titleBar);
			}

			label = new Label();
			label.text = alertModel.message;
			
			labelContent = new Group();
			labelContent.className = "AlertContent";
			//labelContent.percentWidth = 100;
			//labelContent.percentHeight = 100;

			labelContent.addElement(label);
			
			IParent(_strand).addElement(labelContent);

			COMPILE::JS
			{
				getStyle(label)["white-space"] = "unset";
				// label.element.style["white-space"] = "unset";
				//labelContent.element.style["minHeight"] = "30px";
				var style:CSSStyleDeclaration = getStyle(controlBar);
				style["flex-direction"] = "row";
				style["justify-content"] = "center";
				style["border"] = "none";
				style["background-color"] = "#FFFFFF";
			}
			IParent(_strand).addElement(controlBar);

			COMPILE::SWF
			{
				refreshSize();
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
				controlBar = new ControlBar();
			}

			var flags:uint = alertModel.flags;
			if( flags & Alert.OK )
			{
				okButton = new TextButton();
				okButton.className = "AlertButton";
				okButton.text = alertModel.okLabel;
				okButton.addEventListener("click",handleOK);

				controlBar.addElement(okButton);

				COMPILE::JS
				{
					var style:CSSStyleDeclaration = getStyle(okButton);
					style["height"] = "intrinsic";
					style["margin-left"] = "2px";
					style["margin-right"] = "2px";
				}
			}
			if( flags & Alert.CANCEL )
			{
				cancelButton = new TextButton();
				cancelButton.className = "AlertButton";
				cancelButton.text = alertModel.cancelLabel;
				cancelButton.addEventListener("click",handleCancel);

				controlBar.addElement(cancelButton);

				COMPILE::JS
				{
					style = getStyle(cancelButton);
					style["height"] = "intrinsic";
					style["margin-left"] = "2px";
					style["margin-right"] = "2px";
				}
			}
			if( flags & Alert.YES )
			{
				yesButton = new TextButton();
				yesButton.className = "AlertButton";
				yesButton.text = alertModel.yesLabel;
				yesButton.addEventListener("click",handleYes);

				controlBar.addElement(yesButton);

				COMPILE::JS
				{
					style = getStyle(yesButton);
					style["height"] = "intrinsic";
					style["margin-left"] = "2px";
					style["margin-right"] = "2px";
				}
			}
			if( flags & Alert.NO )
			{
				noButton = new TextButton();
				noButton.className = "AlertButton";
				noButton.text = alertModel.noLabel;
				noButton.addEventListener("click",handleNo);

				controlBar.addElement(noButton);

				COMPILE::JS
				{
					style = getStyle(noButton);
					style["height"] = "intrinsic";
					style["margin-left"] = "2px";
					style["margin-right"] = "2px";
				}
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
				sendEvent(titleBar,"layoutNeeded");
			}

			// content placement here
			label.x = metrics.left;
			label.y = titleBarHeight + metrics.top;
			label.width = maxWidth - metrics.left - metrics.right;
			
			controlBar.x = 0;
			controlBar.y = titleBarHeight + label.y + label.height + metrics.bottom;
			controlBar.width = maxWidth;
			sendEvent(controlBar,"layoutNeeded");
			
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
			sendStrandEvent(_strand,closeEvent);
		}
	}
}
