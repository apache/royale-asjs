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
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IAlertModel;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IMeasurementBead;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.html.Label;
    import org.apache.royale.html.TextButton;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.html.beads.IBackgroundBead;
	import org.apache.royale.html.beads.IBorderBead;
	
	/**
	 *  The SimpleAlertView class creates the visual elements of the 
	 *  org.apache.royale.html.SimpleAlert component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SimpleAlertView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SimpleAlertView()
		{
		}
		
		private var messageLabel:Label;
		private var okButton:TextButton;
		
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
			
			var model:IAlertModel = _strand.getBeadByType(IAlertModel) as IAlertModel;
			model.addEventListener("messageChange",handleMessageChange);
			model.addEventListener("htmlMessageChange",handleMessageChange);

            messageLabel = new Label();
			messageLabel.text = model.message;
			messageLabel.html = model.htmlMessage;
            (host as IParent).addElement(messageLabel);
			
			okButton = new TextButton();
			okButton.text = model.okLabel;
            (host as IParent).addElement(okButton);
			okButton.addEventListener("click",handleOK);
			
			handleMessageChange(null);
		}
		
		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		private function handleMessageChange(event:Event):void
		{
			var ruler:IMeasurementBead = messageLabel.getBeadByType(IMeasurementBead) as IMeasurementBead;
			if( ruler == null ) {
				messageLabel.addBead(ruler = new (ValuesManager.valuesImpl.getValue(messageLabel, "iMeasurementBead")) as IMeasurementBead);
			}
			var maxWidth:Number = Math.max(host.width,ruler.measuredWidth);
			
			var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(_strand as IUIBase);
			
			messageLabel.x = metrics.left;
			messageLabel.y = metrics.top;
			messageLabel.width = maxWidth;
			
			okButton.x = (maxWidth - okButton.width)/2;
			okButton.y = messageLabel.y + messageLabel.height + 20;
			
			host.width = maxWidth + metrics.left + metrics.right;
			host.height = okButton.y + okButton.height + metrics.bottom;
		}
		
		/**
		 * @private
		 */
		private function handleOK(event:MouseEvent):void
		{
			var newEvent:Event = new Event("close");
			host.dispatchEvent(newEvent);
		}
	}
}
