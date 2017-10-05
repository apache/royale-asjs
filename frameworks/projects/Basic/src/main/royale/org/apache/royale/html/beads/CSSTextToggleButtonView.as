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
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

    /**
     *  The CSSTextToggleButtonView class is the default view for
     *  the org.apache.royale.html.TextToggleButton class.
     *  It allows the look of the button to be expressed
     *  in CSS via the background-image style and displays
     *  a text label.  This view does not support right-to-left
     *  text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CSSTextToggleButtonView extends CSSTextButtonView
	{
        /**
         *  The suffix appended to the className when selected.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const SELECTED:String = "_Selected";
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSTextToggleButtonView()
		{
		}
		
		private var toggleButtonModel:IToggleButtonModel;
		
        private var _selected:Boolean;
        
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
            
			toggleButtonModel = value.getBeadByType(IToggleButtonModel) as IToggleButtonModel;
            toggleButtonModel.addEventListener("selectedChange", selectedChangeHandler);
		}
	
		private function selectedChangeHandler(event:org.apache.royale.events.Event):void
		{
            var className:String = IStyleableObject(_strand).className;
            if (toggleButtonModel.selected)
            {
                if (className && className.indexOf(SELECTED) == className.length - SELECTED.length)
                    IStyleableObject(_strand).className = className.substring(0, className.length - SELECTED.length);
                setupSkins();
            }
            else
            {
                if (className && className.indexOf(SELECTED) == -1)
                    IStyleableObject(_strand).className += SELECTED;
                setupSkins();                
            }
		}
		
	}
}
