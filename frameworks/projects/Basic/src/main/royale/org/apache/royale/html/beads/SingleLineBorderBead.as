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
	import flash.display.Graphics;

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStatesObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.CSSBorderUtils;
	import org.apache.royale.html.beads.IBorderBead;
	import org.apache.royale.core.Bead;

    /**
     *  The SingleLineBorderBead class draws a single line solid border.
     *  The color and thickness can be specified in CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SingleLineBorderBead extends Bead implements IBorderBead, IGraphicsDrawing
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SingleLineBorderBead()
		{
		}
		
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
			_strand = value;
			listenOnStrand("heightChanged", changeHandler);
			listenOnStrand("widthChanged", changeHandler);
			listenOnStrand("sizeChanged", changeHandler);
			listenOnStrand("initComplete", changeHandler);
			listenOnStrand("layoutComplete", changeHandler);
			var ilc:ILayoutChild = value as ILayoutChild;
			if (ilc)
			{
				if (!isNaN(ilc.explicitWidth) && !isNaN(ilc.explicitHeight))
				{
					changeHandler(null);
				}
			}
		}
		        
		protected function changeHandler(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var g:Graphics = host.graphics;
			var w:Number = host.width;
			var h:Number = host.height;
			var state:String;
			if (host is IStatesObject)
				state = IStatesObject(host).currentState;
			
			var gd:IGraphicsDrawing = _strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();
            
			CSSBorderUtils.draw(g, w, h, host, state, false, false);
		}
	}
}
