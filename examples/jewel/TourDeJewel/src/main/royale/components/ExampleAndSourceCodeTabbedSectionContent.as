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
package components
{
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IChild;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.elements.A;
    import org.apache.royale.html.elements.Code;
    import org.apache.royale.html.elements.Pre;
    import org.apache.royale.jewel.ScrollableSectionContent;
    import org.apache.royale.jewel.TabBar;
    import org.apache.royale.jewel.TabBarContent;
    import org.apache.royale.html.beads.layouts.Paddings;

    import services.GitHubService;

    import vos.TabBarButtonVO;
    
    public class ExampleAndSourceCodeTabbedSectionContent extends ScrollableSectionContent
	{
        /**
		 *  constructor.
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ExampleAndSourceCodeTabbedSectionContent()
		{
            super();

            addEventListener("beadsAdded", beadsAddedHandler);
		}

        private var service:GitHubService;
        private var tabbar:TabBar;
        private var tabBarNavigation:ArrayList;
        private var tabcontent:TabBarContent;
        private var exampleTab:ScrollableSectionContent;
        private var sourceCodeTab:ScrollableSectionContent;
        private var sourceCodeMXMLText:Code;

        private var sourceCodeUrlPrefix:String = "https://api.github.com/repos/apache/royale-asjs/contents/examples/jewel/TourDeJewel/src/main/royale/";
        private var sourceCodeUrlWebPrefix:String = "https://github.com/apache/royale-asjs/blob/develop/examples/jewel/TourDeJewel/src/main/royale/";
        
        private var _sourceCodeUrl:String;
        /**
         * sourceCodeUrl, the name of the resource in the project that hangs from "src/main/royale"
         */
        public function get sourceCodeUrl():String
        {
        	return _sourceCodeUrl;
        }
        public function set sourceCodeUrl(value:String):void
        {
        	_sourceCodeUrl = value;
        }

        private function beadsAddedHandler(event:Event):void
        {
            tabBarNavigation = new ArrayList([
				new TabBarButtonVO("Examples", "exampleTab", MaterialIconType.VIEW_COMPACT),
				new TabBarButtonVO("Source Code", "sourceCodeTab", MaterialIconType.CODE)		
			]);
            tabbar = new TabBar();
            tabbar.className = "tabBarVerticalIconItemRenderer";
            tabbar.addEventListener(Event.CHANGE, changeHandler);
            tabbar.dataProvider = tabBarNavigation;
            strandChildren.addElement(tabbar);

            tabcontent = new TabBarContent();

            exampleTab = new ScrollableSectionContent();
            exampleTab.name = "exampleTab";
            tabcontent.addElement(exampleTab);
            
            sourceCodeTab = new ScrollableSectionContent();
            sourceCodeTab.name = "sourceCodeTab";
            
            var paddings:Paddings = new Paddings();
            paddings.padding = 20;
            sourceCodeTab.addBead(paddings);
            
            var link:A = new A();
            link.href = sourceCodeUrlWebPrefix + sourceCodeUrl;
            link.text = "Watch the source code for this page in GitHub";
            link.target = "_blank";
            link.rel = "noreferrer noopener"
            sourceCodeTab.addElement(link);
            
            var pre:Pre = new Pre();
            sourceCodeMXMLText = new Code();
            sourceCodeMXMLText.className = "xml codeExample";
            pre.addElement(sourceCodeMXMLText);
            
            sourceCodeTab.addElement(pre);

            tabcontent.addElement(sourceCodeTab);
            
            tabcontent.selectedContent = "exampleTab";
            strandChildren.addElement(tabcontent);
            
            service = new GitHubService();
            service.addEventListener("dataReady", dataReadyHandler);
            service.sourceCodeUrl = sourceCodeUrlPrefix + sourceCodeUrl;
        }

        private function changeHandler(event:Event):void
        {
            var item:TabBarButtonVO = (event.target as TabBar).selectedItem as TabBarButtonVO;
            tabcontent.selectedContent = item.hash;
            if(sourceCodeTab.isSelected && sourceCodeMXMLText.text == "")
            {
                service.getContent();
            }
        }

        public function dataReadyHandler(event:Event):void
        {
            sourceCodeMXMLText.text = event.target.sourceCode;
            
            COMPILE::JS
            {
            hljs.highlightBlock(sourceCodeMXMLText.element);
            }
        }

        /**
		 * @private
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			exampleTab.addElement(c, dispatchEvent);
			exampleTab.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			exampleTab.addElementAt(c, index, dispatchEvent);
			exampleTab.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private 
		 */
		override public function getElementIndex(c:IChild):int
		{
			return exampleTab.getElementIndex(c);
		}
		
		/**
		 * @private
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			exampleTab.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		override public function get numElements():int
		{
			return exampleTab.numElements;
		}
		
		/**
		 * @private
		 */
		override public function getElementAt(index:int):IChild
		{
			return exampleTab.getElementAt(index);
		}
    }
}