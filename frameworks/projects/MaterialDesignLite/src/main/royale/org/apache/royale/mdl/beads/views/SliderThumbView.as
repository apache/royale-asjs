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
package org.apache.royale.mdl.beads.views
{
	COMPILE::SWF{
		import flash.display.Graphics;
		import flash.display.Shape;
		import flash.display.SimpleButton;
	}

    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IStrand;
	import org.apache.royale.html.Button;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IChild;

	/**
	 *  The SliderThumbView class creates the draggable input element for the 
	 *  org.apache.royale.mdl.Slider component (swf version).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	COMPILE::SWF
	public class SliderThumbView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SliderThumbView()
		{
            hitArea = new Shape();
            upView = new Shape();
            downView = new Shape();
            overView = new Shape();                
		}
		
		/**
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		private function drawView(g:Graphics, bgColor:uint):void
		{
			var host:Button = Button(_strand);
            var button:SimpleButton = IChild(_strand).$displayObject as SimpleButton;
			g.clear();
			g.lineStyle(1,0x000000);
			g.beginFill(bgColor,1.0);
			g.drawCircle(host.width/2, host.height/2, 10);
			g.endFill();
		}
		
		private var hitArea:Shape;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         *  @royaleignoreimport org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            drawView(hitArea.graphics, 0xDD0000);
            drawView(upView.graphics, 0xFFFFFF);
            drawView(downView.graphics, 0x999999);
            drawView(overView.graphics, 0xDDDDDD);
            
            var button:SimpleButton = IChild(value).$displayObject as SimpleButton;
            button.upState = upView;
            button.downState = downView;
            button.overState = overView;
            button.hitTestState = hitArea;
            
            IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
            IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);                
		}
		
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
        
		/**
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		private function sizeChangeHandler( event:Event ) : void
		{
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xFFFFFF);
			drawView(downView.graphics, 0x999999);
			drawView(overView.graphics, 0xDDDDDD);
		}
	}
}
