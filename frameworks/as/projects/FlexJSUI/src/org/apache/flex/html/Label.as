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
package org.apache.flex.html
{
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/*
	 *  Label probably should extend TextField directly,
	 *  but the player's APIs for TextLine do not allow
	 *  direct instantiation, and we might want to allow
	 *  Labels to be declared and have their actual
	 *  view be swapped out.
	 */

    /**
     *  The Label class implements the basic control for labeling
     *  other controls.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
    public class Label extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Label()
		{
			super();
		}
		
        /**
         *  The text to display in the label.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get text():String
		{
			return ITextModel(model).text;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}
		
        /**
         *  The html-formatted text to display in the label.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get html():String
		{
			return ITextModel(model).html;
		}

        /**
         *  @private
         */
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
				
        /**
         *  @private
         */
		override public function set width(value:Number):void
		{
			super.width = value;
			IEventDispatcher(model).dispatchEvent( new Event("widthChanged") );
		}
		
        /**
         *  @private
         */
		override public function set height(value:Number):void
		{
			super.height = value;
			IEventDispatcher(model).dispatchEvent( new Event("heightChanged") );
		}
	}
}
