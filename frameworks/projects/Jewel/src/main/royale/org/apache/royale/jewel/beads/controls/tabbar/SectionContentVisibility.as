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
package org.apache.royale.jewel.beads.controls.tabbar
{
	import org.apache.royale.events.Event;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.SectionContent;
    import org.apache.royale.jewel.TabBarContent;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.IBead;

	/**
	 *  The SectionContentVisibility class is a specialty bead that can be used with
	 *  SectionContent contained in TabBarContent. The bead add visible function to the TabBar section
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.9
	 */
    public class SectionContentVisibility implements IBead
    {
        private var sectionContent:SectionContent;
        private var _visible:Boolean = true;

		public function SectionContentVisibility()
		{
			super();
		}

        public function get visible():Boolean
        {
            return _visible;
        }

        public function set visible(value:Boolean):void
        {
            _visible = value;

            if (sectionContent != null)
                setTabVisibility();
        }

		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
        public function set strand(value:IStrand):void
		{
            sectionContent = value as SectionContent;

            (value as SectionContent).addEventListener("beadsAdded", childrenAddedHandler);
		}

        private function childrenAddedHandler(event:Event):void
        {
            sectionContent.removeEventListener("beadsAdded", childrenAddedHandler);

            setTabVisibility();
        }

        private function setTabVisibility():void
        {
            var tabBar:TabBarContent = sectionContent.parent as TabBarContent;

            COMPILE::JS
    		{
                var styleDeclaration:CSSStyleDeclaration = (tabBar.parent.getElementAt(0) as UIBase).getElementAt(tabBar.getElementIndex(sectionContent)).element.style;
                if (visible)
                    styleDeclaration.removeProperty("display");
                else
                    styleDeclaration.display = "none";
            }
        }        
    }
}