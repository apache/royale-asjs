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
package org.apache.royale.jewel.supportClasses.view
{
	import org.apache.royale.core.IApplicationView;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IPopUpHostParent;
	import org.apache.royale.jewel.supportClasses.group.GroupBase;
	import org.apache.royale.utils.sendEvent;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched at startup. Attributes and sub-instances of
     *  the MXML document have been created and assigned.
     *  The component lifecycle is different
     *  than the Flex SDK.  There is no creationComplete event.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

    /**
     *  The Jewel ViewBase class is the base class for most views in a Royale
     *  Jewel application.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class ViewBase extends GroupBase implements IPopUpHost, IPopUpHostParent, IApplicationView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function ViewBase()
		{
			super();
		}

		private var _applicationModel:Object;
        /**
         *  A reference to the Application's model.  Usually,
         *  a view is displaying the main model for an
         *  application.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		[Bindable("modelChanged")]
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
            sendEvent(this,"modelChanged");
        }

        /**
         *  A view can be the parent of a popup that will be part of the layout.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get popUpParent():IPopUpHostParent
        {
            return this;
        }
        
        /**
         * A view can host popups that will be part of the layout.
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }
    }
}
