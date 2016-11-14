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
    COMPILE::SWF
    {
    	import flash.display.Graphics;
    	import flash.display.Shape;
    	import flash.display.SimpleButton;
    }	
    import org.apache.flex.core.BeadViewBase;
    import org.apache.flex.core.IBeadView;
    import org.apache.flex.core.IStrand;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The SliderThumbView class creates the draggable input element for the 
	 *  org.apache.flex.html.Slider component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SliderThumbView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SliderThumbView()
		{
            COMPILE::SWF
            {
                hitArea = new Shape();
                upView = new Shape();
                downView = new Shape();
                overView = new Shape();                
            }
		}
		
		/**
		 * @private
		 */
        COMPILE::SWF
		private function drawView(g:Graphics, bgColor:uint):void
		{
			g.clear();
			g.lineStyle(1,0x000000);
			g.beginFill(bgColor);
			g.drawCircle(SimpleButton(_strand).width/2, SimpleButton(_strand).height/2, 10);
			g.endFill();
		}
		
        COMPILE::SWF
		private var hitArea:Shape;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignoreimport org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            COMPILE::SWF
            {
                drawView(hitArea.graphics, 0xDD0000);
                drawView(upView.graphics, 0xFFFFFF);
                drawView(downView.graphics, 0x999999);
                drawView(overView.graphics, 0xDDDDDD);
                
                SimpleButton(value).upState = upView;
                SimpleButton(value).downState = downView;
                SimpleButton(value).overState = overView;
                SimpleButton(value).hitTestState = hitArea;
                
                IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
                IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);                
            }
            COMPILE::JS
            {
                
                element = document.createElement('div') as WrappedHTMLElement;
                element.className = 'SliderThumb';
                element.id = 'thumb';
                element.style.backgroundColor = '#949494';
                element.style.border = 'thin solid #747474';
                element.style.height = '30px';
                element.style.width = '10px';
                element.style.zIndex = '2';
                element.style.top = '-10px';
                element.style.left = '20px';
                
                (host.element as WrappedHTMLElement).appendChild(element);
                
                element.flexjs_wrapper = this;

            }
		}
		
        COMPILE::SWF
		private var upView:Shape;
        COMPILE::SWF
		private var downView:Shape;
        COMPILE::SWF
		private var overView:Shape;
		
        COMPILE::JS
        public var element:WrappedHTMLElement;
        
		/**
		 * @private
		 */
        COMPILE::SWF
		private function sizeChangeHandler( event:Event ) : void
		{
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xFFFFFF);
			drawView(downView.graphics, 0x999999);
			drawView(overView.graphics, 0xDDDDDD);
		}
	}
}
