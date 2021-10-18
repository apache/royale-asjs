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
package mx.controls.beads
{	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	
    import mx.controls.ProgressBar;
    
	/**
	 *  The RadioButtonView class creates the visual elements of the org.apache.royale.html.RadioButton 
	 *  component. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ProgressBarView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ProgressBarView()
		{
		}
		
        private var host:UIBase;
		COMPILE::JS
		private var bar:HTMLElement;
		COMPILE::JS
		private var inner:HTMLElement;
		COMPILE::JS
		private var label:HTMLSpanElement;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *
		 *  @royaleignorecoercion HTMLElement
		 *  @royaleignorecoercion HTMLSpanElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			host = value as UIBase;
			COMPILE::JS 
			{
				bar = document.createElement('div') as HTMLElement;
				bar.style.width = '100%';
				bar.style.height = '8px';
				bar.style.border = 'solid 1px';
				bar.style.backgroundColor = '#404040';
				host.element.appendChild(bar);
				inner = document.createElement('div') as HTMLElement;
				inner.style.height = '8px';
				inner.style.backgroundColor = '#C0C0C0';
				bar.appendChild(inner);
				label = document.createElement('span') as HTMLSpanElement;
				host.element.appendChild(label);
			}
		}
		
		COMPILE::JS
		public function setProgress(value:Number):void
		{
			inner.style.width = (value * 100) + '%';
		}
		
		/**
		 *  The string label for the org.apache.royale.html.RadioButton.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function get text():String
		{
			return label.innerText;
		}
		COMPILE::JS
		public function set text(value:String):void
		{
			label.innerText = value;
		}
		
	}
}
