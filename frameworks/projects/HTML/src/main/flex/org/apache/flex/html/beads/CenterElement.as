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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The CenterElement bead breaks the normal layout flow and forces
	 *  a particlular element to stay centered.
	 * 	  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	
	public class CenterElement implements IBead
	{
		private var _strand:IStrand;
		public function CenterElement()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			var layoutParent:ILayoutParent = getLayoutParent((value as IChild).parent);
			IEventDispatcher(layoutParent).addEventListener('layoutComplete', layoutCompleteHandler);
		}
		
		private function layoutCompleteHandler(e:Event):void
		{
			var childWidth:Number = host.width;
			var parentWidth:Number = (host.parent as ILayoutChild).width;
			var childHeight:Number = host.height;
			var parentHeight:Number = (host.parent as ILayoutChild).height;
			host.x = (parentWidth - childWidth) / 2;
			host.y = (parentHeight - childHeight) / 2;
		}
		
		private function get host():ILayoutChild
		{
			return _strand as ILayoutChild;
		}
		
		private function getLayoutParent(value:IParent):ILayoutParent
		{
			while (value)
			{
				if (value is ILayoutParent)
				{
					return value as ILayoutParent;
				}
				value = IChild(value).parent;
			}
			return null;
		}

	}
}