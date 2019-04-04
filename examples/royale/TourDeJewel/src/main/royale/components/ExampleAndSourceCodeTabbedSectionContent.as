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
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.elements.A;
    import org.apache.royale.html.elements.Code;
    import org.apache.royale.html.elements.Pre;
    import org.apache.royale.jewel.ScrollableSectionContent;
    import org.apache.royale.jewel.TabBar;
    import org.apache.royale.jewel.TabBarContent;

    import services.GitHubService;

    import utils.HighlightCode;

    import vos.TabBarButtonVO;
    
    public class ExampleAndSourceCodeTabbedSectionContent extends ScrollableSectionContent implements IContainerBaseStrandChildrenHost 
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

            exampleTab = new ScrollableSectionContent();
            exampleTab.name = "exampleTab";
            contentArea = exampleTab;

            addEventListener("initComplete", initCompleteHandler);
		}

        private var service:GitHubService;
        private var tabbar:TabBar;
        private var tabBarNavigation:ArrayList;
        private var tabcontent:TabBarContent;
        private var exampleTab:ScrollableSectionContent;
        private var sourceCodeTab:ScrollableSectionContent;
        private var sourceCodeMXMLText:Code;

        private var sourceCodeUrlPrefix:String = "https://api.github.com/repos/apache/royale-asjs/contents/examples/royale/TourDeJewel/src/main/royale/";
        private var sourceCodeUrlWebPrefix:String = "https://github.com/apache/royale-asjs/blob/develop/examples/royale/TourDeJewel/src/main/royale/";
        
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

        private function initCompleteHandler(event:Event):void
        {
            tabBarNavigation = new ArrayList([
				new TabBarButtonVO("Examples", "exampleTab", null),
				new TabBarButtonVO("Source Code", "sourceCodeTab", null)		
			]);

            tabbar = new TabBar();
            tabbar.className = "tabBarIconItemRenderer";
            tabbar.addEventListener(Event.CHANGE, changeHandler);
            tabbar.dataProvider = tabBarNavigation;
            $addElement(tabbar);
            
            sourceCodeTab = new ScrollableSectionContent();
            sourceCodeTab.name = "sourceCodeTab";
            var link:A = new A();
            link.href = sourceCodeUrlWebPrefix + sourceCodeUrl;
            link.text = "Source code in GitHub";
            link.target = "_blank";
            link.rel = "noreferrer noopener"
            sourceCodeTab.addElement(link);
            var pre:Pre = new Pre();
            sourceCodeMXMLText = new Code();
            sourceCodeMXMLText.className = "xml codeExample";
            pre.addElement(sourceCodeMXMLText);
            sourceCodeTab.addElement(pre);

            tabcontent = new TabBarContent();
            tabcontent.addElement(exampleTab);
            tabcontent.addElement(sourceCodeTab);
            tabcontent.selectedContent = "exampleTab";
            $addElement(tabcontent);
            
            service = new GitHubService();
            service.addEventListener("dataReady", dataReadyHandler);
            service.sourceCodeUrl = sourceCodeUrlPrefix + sourceCodeUrl;
        }

        private function changeHandler(event:Event):void
        {
            var item:TabBarButtonVO = (event.target as TabBar).selectedItem as TabBarButtonVO;
            tabcontent.selectedContent = item.href;
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
                var highlightCode:HighlightCode = new HighlightCode();
                highlightCode.highlightBlock(sourceCodeMXMLText.element);
            }
        }

        
        private var _contentArea:ScrollableSectionContent;
		/**
		 * The content area of the formItem.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get contentArea():ScrollableSectionContent
		{
			return _contentArea;
		}
		public function set contentArea(value:ScrollableSectionContent):void
		{
			_contentArea = value;
		}


        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			contentArea.addElement(c, dispatchEvent);
			contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			contentArea.addElementAt(c, index, dispatchEvent);
			contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function getElementIndex(c:IChild):int
		{
			return contentArea.getElementIndex(c);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			contentArea.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function get numElements():int
		{
			return contentArea.numElements;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function getElementAt(index:int):IChild
		{
			return contentArea.getElementAt(index);
		}
    }
}