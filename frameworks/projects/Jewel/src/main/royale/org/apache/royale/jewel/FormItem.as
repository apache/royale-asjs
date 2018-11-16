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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContainerBaseStrandChildrenHost;
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.models.FormItemModel;
	import org.apache.royale.jewel.beads.views.FormItemView;

    /**
	 * FormItem is a label, and option required indicator (no validation is implied)
	 * and a content with one or more controls
	 */
    public class FormItem extends Group implements IContainerBaseStrandChildrenHost
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormItem()
		{
			super();

            typeNames = "jewel formitem";
		}

		[Bindable(event="change")]
		/**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get label():String
		{
            return ITextModel(model).text;
		}
        /**
         *  @private
         */
		public function set label(value:String):void
		{
            ITextModel(model).text = value;
		}

		[Bindable(event="change")]
		/**
         *  @copy org.apache.royale.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
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
		 *  If <code>true</code>, puts the FormItem skin into the
		 *  <code>required</code> state. By default, this state displays 
		 *  an indicator that the FormItem children require user input.
		 *  If <code>false</code>, the indicator is not displayed.
		 *
		 *  This property controls skin's state only.
		 *  You must assign a validator to the child 
		 *  if you require input validation.
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get required():Boolean
		{
			return FormItemModel(model).required;
		}
		/**
		 *  @private
		 */
		public function set required(value:Boolean):void
		{
			FormItemModel(model).required = value;
		}
		
		/**
		 *  The align of the textLabel component
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get labelAlign():String
		{
			return FormItemModel(model).labelAlign;
		}
		/**
		 *  @private
		 */
		public function set labelAlign(value:String):void
		{
			FormItemModel(model).labelAlign = value;
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
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var formItemView:FormItemView = view as FormItemView;
			formItemView.contentArea.addElement(c, dispatchEvent);
			formItemView.contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var formItemView:FormItemView = view as FormItemView;
			formItemView.contentArea.addElementAt(c, index, dispatchEvent);
			formItemView.contentArea.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function getElementIndex(c:IChild):int
		{
			var formItemView:FormItemView = view as FormItemView;
			return formItemView.contentArea.getElementIndex(c);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var formItemView:FormItemView = view as FormItemView;
			formItemView.contentArea.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function get numElements():int
		{
			var formItemView:FormItemView = view as FormItemView;
			return formItemView.contentArea.numElements;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.html.beads.FormItemView
		 */
		override public function getElementAt(index:int):IChild
		{
			var formItemView:FormItemView = view as FormItemView;
			return formItemView.contentArea.getElementAt(index);
		}
    }
}