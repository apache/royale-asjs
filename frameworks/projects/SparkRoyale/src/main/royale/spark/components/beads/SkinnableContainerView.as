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

package spark.components.beads
{
	import mx.core.UIComponent;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.Skin;
	
	/**
	 *  @private
	 *  The SkinnableContainerView for emulation.
	 */
	public class SkinnableContainerView extends SparkContainerView
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.6
		 */
		public function SkinnableContainerView()
		{
			super();
		}
		
		override public function get displayView():GroupBase
		{
			var skinhost:SkinnableComponent = _strand as SkinnableComponent;
			if (skinhost && skinhost.skin)
				return skinhost.skin as GroupBase;
			else	
				return super.displayView;
		}

		override protected function addViewport():void
		{
			var chost:IContainer = host as IContainer;
			var skinhost:SkinnableComponent = _strand as SkinnableComponent;
			if (chost && skinhost.skin)
			{
				chost.addElement(skinhost.skin);
			}
			else
			{
				super.addViewport();
			}
		}
	}
}
