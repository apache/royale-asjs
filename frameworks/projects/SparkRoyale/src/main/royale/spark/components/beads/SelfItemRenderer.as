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
	import spark.components.supportClasses.ItemRenderer;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.events.Event;

	/**
	 *  The SelfItemRenderer class defines the Spark item renderer class 
	 *  these uses the item to render itself.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 0.9.8
	 */
	public class SelfItemRenderer extends ItemRenderer implements IIndexedItemRenderer
	{    
		/**
		 *  Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 0.9.8
		 */
		public function SelfItemRenderer()
		{
			super();
			typeNames = "SelfItemRenderer";
		}
	}
}
