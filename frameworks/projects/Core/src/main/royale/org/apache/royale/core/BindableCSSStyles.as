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
package org.apache.royale.core
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ValueChangeEvent;

    /**
     *  The BindableCSSStyles class contains CSS style
     *  properties supported by SimpleCSSValuesImpl but
     *  dispatch change events when modified
     *  
     *  The class is a bead but should be added to a UI
     *  object via the <code>style</code> property rather
     *  than within the beads list. The reference to the
     *  strand is used to update its CSS style value when
     *  any of the styles are modified.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Bindable]
	public class BindableCSSStyles extends EventDispatcher implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function BindableCSSStyles()
		{
			super();
		}
		
        /**
         * @private
         */
        private var _strand : IStrand;

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  Sets the strand reference so that we can updates the HTML element
         *  styles on this if our properties are changed in the future.
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            COMPILE::JS
            {
                // listen to ourselves in case one of the styles is changed programmatically
                this.addEventListener(ValueChangeEvent.VALUE_CHANGE, styleChangeHandler);
            }
        }

        /**
         * Handles a single style value being updated, and applies this to the strand
         * @param value The event containing new style properties.
         */
        COMPILE::JS
        protected function styleChangeHandler(value:ValueChangeEvent):void
        {
            var uiObject : IUIBase = _strand as IUIBase;
            if (uiObject)
            {
                var newStyle:Object = {};
                newStyle[value.propertyName] = value.newValue;
                ValuesManager.valuesImpl.applyStyles(uiObject, newStyle);
            }
        }

        public var styleList:Object = {
            "top": 1,
            "bottom": 1,
            "left": 1,
            "right": 1,
            "padding": 1,
            "paddingLeft": 1,
            "paddingRight": 1,
            "paddingTop": 1,
            "paddingBottom": 1,
            "margin": 1,
            "marginLeft": 1,
            "marginRight": 1,
            "marginTop": 1,
            "marginBottom": 1,
            "verticalAlign": 1,
            "fontFamily": 1,
            "fontSize": 1,
            "color": 1,
            "fontWeight": 1,
            "fontStyle": 1,
            "backgroundColor": 1,
            "backgroundImage": 1,
			"border": 1,
            "borderColor": 1,
            "borderStyle": 1,
            "borderRadius": 1,
            "borderWidth": 1
        };

        public var top:*;
        public var bottom:*;
        public var left:*;
        public var right:*;
        public var padding:*;
		public var paddingLeft:*;
        public var paddingRight:*;
        public var paddingTop:*;
        public var paddingBottom:*;
        public var margin:*;
        public var marginLeft:*;
        public var marginRight:*;
        public var marginTop:*;
        public var marginBottom:*;
        public var verticalAlign:*;
        public var fontFamily:*;
        public var fontSize:*;
        public var color:*;
        public var fontWeight:*;
        public var fontStyle:*;
        public var backgroundColor:*;
        public var backgroundImage:*;
		public var border:*;
        public var borderColor:*;
        public var borderStyle:*;
        public var borderRadius:*;
        public var borderWidth:*;
	}
}
