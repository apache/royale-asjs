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
package models
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.collections.HierarchicalData;

	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
			treeData = new HierarchicalData(store);
			treeData.childrenField = "children";
		}

		public var treeData:HierarchicalData;

		private var store:Object = { title:"That's Entertainment",
        		children:[
        			{title:"My Music",
        				children:[
        					{title:"Language and Perspective", artist:"Bad Suns",
        					    children:[
        					    	{title:"Matthew James", length:"3:24"},
        					    	{title:"We Move Like the Ocean", length:"3:56"},
        					    	{title:"Cardiac Arrest", length:"3:15"}
        					    ]},
        					{title:"Strange Desire", artist:"Bleachers",
        						children:[
        							{title:"Wild Heart", length:"4:15"},
        							{title:"Rollercoaster", length:"3:39"},
        							{title:"Shadow", length:"3:46"},
        							{title:"I Wanna Get Better", length:"4:23"}
        						]}
        				]},
        			{title:"My Books",
        				children:[
        					{title:"Wizard of Oz",
        						children:[
        							{title:"So this is Kansas?", length:"82"},
        							{title:"A Might Dusty Here", length:"63"},
        							{title:"Is that a Tornado?", length:"103"}
        						]},
        					{title:"Favorite Book #2",
        						children:[
        							{title:"Chapter 1", length:"15"},
        							{title:"Chapter 2", length:"86"},
        							{title:"Chapter 3", length:"104"},
        							{title:"Chapter 4", length:"99"}
        						]}
        				]}
        		]};

	}
}
