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
package org.apache.royale.html
{
	import org.apache.royale.core.IPanelModel;
	import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
	import org.apache.royale.html.beads.PanelView;
	import org.apache.royale.events.Event;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
    
	[Event(name="close", type="org.apache.royale.events.Event")]
	
	/**
	 *  The Panel class is a Container component capable of parenting other
	 *  components. The Panel has a TitleBar.  If you want to a Panel with
     *  a ControlBar, use PanelWithControlBar which
     *  will instantiate, by default, an ControlBar. 
	 *  The Panel uses the following bead types:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model for the Panel that includes the title and whether
	 *  or not to display the close button.
	 *  org.apache.royale.core.IBeadView: creates the parts of the Panel.
	 *  org.apache.royale.html.beads.IBorderBead: if present, draws a border around the Panel.
	 *  org.apache.royale.html.beads.IBackgroundBead: if present, provides a colored background for the Panel.
	 *  
     *  @toplevel
	 *  @see PanelWithControlBar
	 *  @see ControlBar
	 *  @see TitleBar
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Panel extends Group implements IContainerBaseStrandChildrenHost
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Panel()
		{
			super();
			
			typeNames = "Panel";
		}
		
		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            super.addElementAt(c, index, dispatchEvent);
        }
        
		public function get $numElements():int
		{
			return super.numElements;
		}
		
		public function $getElementAt(index:int):IChild
		{
			return super.getElementAt(index);
		}
		
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.removeElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementIndex(c:IChild):int
        {
            return super.getElementIndex(c);
        }
        
		/**
		 *  The string to display in the org.apache.royale.html.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function get title():String
		{
			return IPanelModel(model).title;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function set title(value:String):void
		{
			IPanelModel(model).title = value;
		}
		
		/**
		 *  The HTML string to display in the org.apache.royale.html.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function get htmlTitle():String
		{
			return IPanelModel(model).htmlTitle;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function set htmlTitle(value:String):void
		{
			IPanelModel(model).htmlTitle = value;
		}
		
		/**
		 * Whether or not to show a Close button in the org.apache.royale.html.TitleBar.
		 * @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function get showCloseButton():Boolean
		{
			return IPanelModel(model).showCloseButton;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IPanelModel
		 */
		public function set showCloseButton(value:Boolean):void
		{
			IPanelModel(model).showCloseButton = value;
		}
		
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var panelView:PanelView = view as PanelView;
			panelView.contentArea.addElement(c, dispatchEvent);
			panelView.contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var panelView:PanelView = view as PanelView;
			panelView.contentArea.addElementAt(c, index, dispatchEvent);
			panelView.contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function getElementIndex(c:IChild):int
		{
			var panelView:PanelView = view as PanelView;
			return panelView.contentArea.getElementIndex(c);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var panelView:PanelView = view as PanelView;
			panelView.contentArea.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function get numElements():int
		{
			var panelView:PanelView = view as PanelView;
			return panelView.contentArea.numElements;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.PanelView
		 */
		override public function getElementAt(index:int):IChild
		{
			var panelView:PanelView = view as PanelView;
			return panelView.contentArea.getElementAt(index);
		}
	}
}
