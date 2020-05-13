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
package org.apache.royale.jewel.beads.controls
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.Label;
	import org.apache.royale.utils.IEmphasis;
	
	/**
	 *  The Badge class provides a small status descriptors for UI elements.
	 *
	 *  A Badge is an onscreen notification element consists of a small circle, 
     *  typically containing a number or other characters, that appears in 
     *  proximity to another object
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class Badge implements IBead, IEmphasis
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function Badge()
		{
			badge = createBadge();
		}

		/**
		 * the internal instance of the badge
		 */
		private var badge:Label;

		/**
		 * used to create the badge ui element
		 * that will be a Label
		 */
		protected function createBadge():Label
		{
			var badge:Label = new Label();
			badge.typeNames = "jewel badge";

			return badge;
		}

		private var host:UIBase;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function set strand(value:IStrand):void
		{
			host = value as UIBase;
			COMPILE::JS
			{
				host.element.classList.add("visible");
				host.element.classList.add("viewport");
			}
			badge.toggleClass("preindex", _preindex);
			badge.toggleClass("subindex", _subindex);
			badge.toggleClass("overlap", _overlap);
			badge.visible = text == '' ? false : true;
			
			host.addElement(badge);
		}

		private var _text:String = '';
		/**
		 *  The current value of the Badge that appers inside the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		[Bindable]
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			badge.text = _text;
			badge.visible = text == '' ? false : true;
		}

		private var _emphasis:String;
		/**
		 *  The color of this Badge
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get emphasis():String
		{
			return _emphasis;
		}
		public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    badge.removeClass(_emphasis);
                }
                _emphasis = value;

                badge.addClass(_emphasis);
            }
        }

        private var _overlap:Boolean = false;
        /**
		 *  A boolean flag to activate "overlap" effect selector.
		 *  Make the badge overlap with its container
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get overlap():Boolean
        {
            return _overlap;
        }
        public function set overlap(value:Boolean):void
        {
			if (_overlap != value)
            {
                _overlap = value;

				badge.toggleClass("overlap", _overlap);
            }
        }
        
		private var _subindex:Boolean = false;
        /**
		 *  A boolean flag to activate "subindex" effect selector.
		 *  Make the badge position subindex instead of default superindex
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get subindex():Boolean
        {
            return _subindex;
        }
        public function set subindex(value:Boolean):void
        {
			if (_subindex != value)
            {
                _subindex = value;

				badge.toggleClass("subindex", _subindex);
            }
        }

		private var _preindex:Boolean = false;
        /**
		 *  A boolean flag to activate "preindex" effect selector.
		 *  Make the badge position preindex instead of default postindex
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get preindex():Boolean
        {
            return _preindex;
        }
        public function set preindex(value:Boolean):void
        {
			if (_preindex != value)
            {
                _preindex = value;

				badge.toggleClass("preindex", _preindex);
            }
        }
	}
}
