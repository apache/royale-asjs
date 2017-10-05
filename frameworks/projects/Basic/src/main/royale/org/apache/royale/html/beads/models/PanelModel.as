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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IPanelModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 *  The PanelModel bead class holds the values for a org.apache.royale.html.Panel, such as its
	 *  title.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PanelModel extends EventDispatcher implements IBead, IPanelModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PanelModel()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
        private var _controlBar:Array;
        
        /**
         *  The items in the org.apache.royale.html.ControlBar. Setting this property automatically
         *  causes the ControlBar to display if you are using a View bead that supports it.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get controlBar():Array
        {
            return _controlBar;
        }
        public function set controlBar(value:Array):void
        {
            _controlBar = value;
        }

        private var _title:String;
		
		/**
		 *  The title string for the org.apache.royale.html.Panel.
		 * 
		 *  @copy org.apache.royale.core.ITitleBarModel#title
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			if( value != _title ) {
				_title = value;
				dispatchEvent( new Event('titleChange') );
			}
		}
		
		private var _htmlTitle:String;
		
		/**
		 *  The HTML string for the title.
		 * 
		 *  @copy org.apache.royale.core.ITitleBarModel#htmlTitle
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get htmlTitle():String
		{
			return _htmlTitle;
		}
		public function set htmlTitle(value:String):void
		{
			if( value != _htmlTitle ) {
				_htmlTitle = value;
				dispatchEvent( new Event('htmlTitleChange') );
			}
		}
		
		private var _showCloseButton:Boolean = false;
		
		/**
		 *  Indicates whether or not there is a Close button for the org.apache.royale.html.Panel.
		 * 
		 *  @copy org.apache.royale.core.ITitleBarModel#showCloseButton
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}
		public function set showCloseButton(value:Boolean):void
		{
			if( value != _showCloseButton ) {
				_showCloseButton = value;
				dispatchEvent( new Event('showCloseButtonChange') );
			}
		}
	}
}
