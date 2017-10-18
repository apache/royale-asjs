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
package org.apache.royale.mdl.beads.views
{
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.beads.ListView;

	import org.apache.royale.events.Event;

	/**
	 *  ListView makes sure the itemRendererFactory and the layout beads are installed.
	 * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public class ListView extends org.apache.royale.html.beads.ListView
	{
		public function ListView()
		{
			super();
		}
	}
}
