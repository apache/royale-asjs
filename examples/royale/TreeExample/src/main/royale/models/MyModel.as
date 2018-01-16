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
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
			treeData = new HierarchicalData(store);
			treeData.childrenField = "children";
			
			gridData = new HierarchicalData(process);
			gridData.childrenField = "children";
		}

		public var treeData:HierarchicalData;

		private var store:Object = { title:"That's Entertainment",
        		children:[
        			{title:"My Music", artist:"", length:"",
        				children:[
        					{title:"Language and Perspective", artist:"Bad Suns", length:"31:47",
        					    children:[
        					    	{title:"Matthew James", artist:"Bad Suns (feat BS)", length:"3:24"},
        					    	{title:"We Move Like the Ocean", artist:"Bad Suns", length:"3:56"},
        					    	{title:"Cardiac Arrest", artist:"Bad Suns", length:"3:15"}
        					    ]},
        					{title:"Strange Desire", artist:"Bleachers", length:"28:56",
        						children:[
        							{title:"Wild Heart", artist:"Bleachers", length:"4:15"},
        							{title:"Rollercoaster", artist:"Bleachers", length:"3:39"},
        							{title:"Shadow", artist:"Bleachers", length:"3:46"},
        							{title:"I Wanna Get Better", artist:"Bleachers", length:"4:23"}
        						]}
        				]},
        			{title:"My Books", artist:"", length:"",
        				children:[
        					{title:"Wizard of Oz", artist:"Frank L Baum", length: "1024",
        						children:[
        							{title:"So this is Kansas?", artist:"Frank L Baum", length:"82"},
        							{title:"A Might Dusty Here", artist:"Frank L Baum", length:"63"},
        							{title:"Is that a Tornado?", artist:"Frank L Baum", length:"103"}
        						]},
        					{title:"Favorite Book #2", artist: "The Writer", length: "4095",
        						children:[
        							{title:"Chapter 1", artist: "The Writer", length:"15"},
        							{title:"Chapter 2", artist: "The Writer", length:"86"},
        							{title:"Chapter 3", artist: "The Writer", length:"104"},
        							{title:"Chapter 4", artist: "The Writer", length:"99"}
        						]}
        				]}
        		]};
		
		public var gridData:HierarchicalData;
		
		private var process:Object = {title:"Projects",
									  children:[
										  {title:"Layout Branch", status:"in progress", hours:120, children:[
											  {title:"Accordion", status:"finalized", hours:42},
											  {title:"Multiview", status:"finalized", hours:34}
										  ]},
										  {title:"Data branch", status:"in progress", hours:150, children:[
											  {title:"List", status:"finalized", hours:50}
										  ]},
										  {title:"Calendar", status:"planning", hours:0}
									  ]};

	}
}
