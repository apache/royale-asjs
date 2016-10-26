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
package org.apache.flex.mdl.beads
{
    import org.apache.flex.core.IStrand;
	import org.apache.flex.mdl.beads.MDLEffect;
    import org.apache.flex.mdl.Button;
	
	/**
	 *  The ButtonEffect class is a specialty bead that can be used with
	 *  an MDL button control to apply some MDL complementary effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ButtonEffect extends MDLEffect
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ButtonEffect()
		{
		}
		
        private var _fab:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--fab" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get fab():Boolean
        {
            return _fab;
        }
        public function set fab(value:Boolean):void
        {
            if(value) {
                _fab = " mdl-button--fab";
            } else {
                _fab = "";
            }   
        }

        private var _raised:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--raised" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get raised():Boolean
        {
            return _raised;
        }
        public function set raised(value:Boolean):void
        {
            if(value) {
                _raised = " mdl-button--raised";
            } else {
                _raised = "";
            }   
        }

        private var _colored:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--colored" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get colored():Boolean
        {
            return _colored;
        }
        public function set colored(value:Boolean):void
        {
            if(value) {
                _colored = " mdl-button--colored";
            } else {
                _colored = "";
            }   
        }

        private var _accent:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--accent" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get accent():Boolean
        {
            return _accent;
        }
        public function set accent(value:Boolean):void
        {
            if(value) {
                _accent = " mdl-button--accent";
            } else {
                _accent = "";
            }   
        }

        private var _primary:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--primary" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get primary():Boolean
        {
            return _primary;
        }
        public function set primary(value:Boolean):void
        {
            if(value) {
                _primary = " mdl-button--primary";
            } else {
                _primary = "";
            }   
        }

        private var _minifab:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--mini-fab" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get minifab():Boolean
        {
            return _minifab;
        }
        public function set minifab(value:Boolean):void
        {
            if(value) {
                _minifab = " mdl-button--mini-fab";
            } else {
                _minifab = "";
            }   
        }

        private var _icon:String = "";
        /**
		 *  A boolean flag to activate "mdl-button--icon" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get icon():Boolean
        {
            return _icon;
        }
        public function set icon(value:Boolean):void
        {
            if(value) {
                _icon = " mdl-button--icon";
            } else {
                _icon = "";
            }   
        }

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion org.apache.flex.mdl.Button;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
                if (value is Button) {
                    var button:Button = value as Button;
                    button.className = _fab + _raised + _colored + _ripple + _accent + _primary + _minifab + _icon;
                } else {
                    throw new Error("Host component must be an MDL Button.");
                }
			}
		}
	}
}
