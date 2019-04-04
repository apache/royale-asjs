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
package org.apache.royale.jewel
{
	import org.apache.royale.core.IApplicationView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IPopUpHostParent;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.events.Event;
	// import org.apache.royale.jewel.beads.layouts.VerticalLayout;

	COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }

	/**
	 *  The ApplicationResponsiveView class is the main Container component capable of parenting other
	 *  components in an Application
	 *  It normaly can host a TopAppBar, a Drawer and a Container with other organized content for
	 *  navigation
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ApplicationResponsiveView extends Group implements IPopUpHost, IPopUpHostParent, IApplicationView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ApplicationResponsiveView()
		{
			super();

            typeNames = "applicationResponsiveView"; //+ VerticalLayout.LAYOUT_TYPE_NAMES;
		}
        
		private var _applicationModel:Object;

		[Bindable("modelChanged")]
        /**
         *  A reference to the Application's model.  Usually,
         *  a view is displaying the main model for an
         *  application.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get applicationModel():Object
		{
			return _applicationModel;
		}

        /**
         *  @private
         */
        public function set applicationModel(value:Object):void
        {
            _applicationModel = value;
            dispatchEvent(new Event("modelChanged"));
        }

		/**
         *  ViewBase can host popups but they will be in the layout, if any
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUpParent():IPopUpHostParent
        {
            return this;
        }

		/**
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }

	}
}
