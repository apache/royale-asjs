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
package org.apache.royale.externsjs.inspiretree.beads
{

	/**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	COMPILE::JS{
	import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Strand;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModel;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.utils.sendStrandEvent;
    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.events.Event;
	}
    /**
     * Simulates the Read-Only state in checkboxes.
     * This implementation modifies the 'style' attribute by adding 'z-index:-1' to make the checkbox inaccessible.
     * Does not depend on extra CSS classes
     */
    COMPILE::JS
	public class InspireTreeReadOnlyCheckBead_V0  extends Strand implements IBead
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */

		public function InspireTreeReadOnlyCheckBead_V0()
		{
			super();
		}
		protected var lastElementZIndexVal:String = null;
		protected var initialized:Boolean = false;

        private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get strand():IStrand
        {
            return _strand;
        }
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
            _strand = value;
			(_strand as IEventDispatcher).addEventListener("onCreationComplete", updateHost);
		}

		private var _readonly:Boolean = false;
        /**
		 *  A boolean flag to enable or disable the host control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable]
        public function get readOnly():Boolean
        {
            return _readonly;
        }
        public function set readOnly(value:Boolean):void
        {
			if(value != _readonly)
			{
				_readonly = value;
				updateHost();
				sendStrandEvent(_strand, new ValueEvent("readonlyChange", readOnly));
			}
        }

		private function updateHost(event:Event = null):void
		{
			if(!strand)
				return;

            //If it is the first time it is executed and readOnly=false, the process does not need to be performed.
            if(!initialized && !readOnly)
                return;

			var elements:NodeList = (_strand as StyledUIBase).element.querySelectorAll("input[type='checkbox']");
			for (var i:int = 0; i < elements.length; i++)
			{
                var htmlElement:HTMLElement = elements[i] as HTMLElement;
				if (htmlElement)
				{
                    if(!initialized){
                        initialized = true;
                        var css:CSSStyleDeclaration = getComputedStyle(htmlElement);
                        lastElementZIndexVal = css['zIndex'];
                        if(!lastElementZIndexVal)
                            lastElementZIndexVal = "2";
                    }
                    if(_readonly)
					    htmlElement.style["z-index"] = "-1";
                    else
					    htmlElement.style["z-index"] = lastElementZIndexVal; //restore
				}
			}
		}

	}

    COMPILE::SWF
	public class InspireTreeReadOnlyCheckBead_V0
	{
    }
}
