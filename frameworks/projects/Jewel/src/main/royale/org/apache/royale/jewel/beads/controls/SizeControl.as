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
	import org.apache.royale.core.StyledUIBase;

	/**
	 *  The SizeControl bead class is a specialty bead that can be used to size a Jewel control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SizeControl implements IBead
	{
		public static const XSMALL:String = "xsmall";
        public static const SMALL:String = "small";
        public static const LARGE:String = "large";
        public static const XLARGE:String = "xlarge";

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SizeControl()
		{
		}

		private var _oldSize:String;
		private var _size:String;

        /**
         *  A size selector.
         *  Sets the size of the button using one of the "size"
         *  constants (XSMALL, SMALL, LARGE and XLARGE)
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get size():String
        {
            return _size;
        }

		[Inspectable(category="General", enumeration="xsmall,small,large,xlarge")]
		public function set size(value:String):void
		{
			COMPILE::JS
            {
				_oldSize = _size;
				_size = value;

				if(_strand)
                	sizeHost();
            }
        }

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IStrand;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS
			{
				sizeHost();
			}
		}

		COMPILE::JS
		private function sizeHost():void
		{
			var host:StyledUIBase = _strand as StyledUIBase;
			if (host)
            {
				if(_oldSize)
					host.removeClass(_oldSize);
				if (_size)
                	host.addClass(_size);
            }
		}
	}
}
