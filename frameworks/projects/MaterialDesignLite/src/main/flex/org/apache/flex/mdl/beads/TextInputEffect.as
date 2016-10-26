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
	import org.apache.flex.mdl.TextInput;
	
	
	/**
	 *  The TextInputEffect class is a specialty bead that can be used with
	 *  a MDL TextInput control to apply some MDL complementary effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TextInputEffect extends MDLEffect
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TextInputEffect()
		{
		}

        private var _floatingLabel:String = "";
        /**
		 *  A boolean flag to activate "mdl-textfield--floating-label" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get floatingLabel():Boolean
        {
            return _floatingLabel;
        }
        public function set floatingLabel(value:Boolean):void
        {
            if(value) {
                _floatingLabel = " mdl-textfield--floating-label";
            } else {
                _floatingLabel = "";
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
		 *  @flexjsignorecoercion org.apache.flex.mdl.TextInput;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				if (value is TextInput) {
					var textinput:TextInput = value as TextInput;
					textinput.positioner.className = textinput.positioner.className + _floatingLabel;
				} else {
					throw new Error("Host component must be an MDL TextInput.");
				}
			}
		}
	}
}
