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
package org.apache.royale.jewel.supportClasses.button
{
    COMPILE::SWF
    {
    import org.apache.royale.core.UIButtonBase;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.events.Event;
    }

    COMPILE::JS
    {
    import org.apache.royale.core.StyledUIBase;
    }

    import org.apache.royale.core.ISelectable;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user selected or deselects this component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The SelectableButtonBase is a support class (not for direct use) and implements the ISelectable interface
     *  to be override in subclasses. Jewel CheckBox and RadioButtons are direct extensions of this class.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    COMPILE::SWF
	public class SelectableButtonBase extends UIButtonBase implements ISelectable
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function SelectableButtonBase()
		{
			super();
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}

        /**
		 * @private
		 */
        protected function internalMouseHandler(event:org.apache.royale.events.MouseEvent):void
		{
			selected = !selected;
			dispatchEvent(new Event(Event.CHANGE));
		}

        /**
         *  <code>true</code> if selected, <code>false</code> otherwise.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get selected():Boolean
		{
            // to implement in subclasses
			return false;
		}
        /**
         *  @private
         */
		public function set selected(value:Boolean):void
		{
			// to implement in subclasses
		}
	}
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	[Event(name="change", type="org.apache.royale.events.Event")]
    
    /**
     *  The SelectableButtonBase is a support class (not for direct use) and implements the ISelectable interface
     *  to be override in subclasses. Jewel CheckBox and RadioButtons are direct extensions of this class.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    COMPILE::JS
    public class SelectableButtonBase extends StyledUIBase implements ISelectable
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function SelectableButtonBase()
		{
			super();
        }
        
        /**
         *  <code>true</code> if selected, <code>false</code> otherwise.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function get selected():Boolean
		{
            // to implement in subclasses
            return false;
		}
        /**
         * @private
         */
        public function set selected(value:Boolean):void
        {
            // to implement in subclasses
        }      
    }
}
