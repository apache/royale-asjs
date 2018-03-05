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
[Bindable]
private var flatData:ArrayCollection = new ArrayCollection(
[
  {customer:"AAA", product:"ColdFusion", quarter:"Q1", revenue:210, cost:25},
  {customer:"AAA", product:"Flex", quarter:"Q2", revenue:210, cost:25},
  {customer:"AAA", product:"Dreamweaver", quarter:"Q3", revenue:250, cost:125},
  {customer:"AAA", product:"Flash", quarter:"Q4", revenue:430, cost:75},
  
  {customer:"BBB", product:"ColdFusion", quarter:"Q2", revenue:125, cost:20},
  {customer:"BBB", product:"Flex", quarter:"Q3", revenue:210, cost:20},
  {customer:"BBB", product:"Dreamweaver", quarter:"Q4", revenue:320, cost:120},
  {customer:"BBB", product:"Flash", quarter:"Q1", revenue:280, cost:70},
  
  {customer:"CCC", product:"ColdFusion", quarter:"Q3", revenue:375, cost:120},
  {customer:"CCC", product:"Flex", quarter:"Q4", revenue:430, cost:120},
  {customer:"CCC", product:"Dreamweaver", quarter:"Q1", revenue:470, cost:220},
  {customer:"CCC", product:"Flash", quarter:"Q2", revenue:570, cost:170},
  
  {customer:"AAA", product:"ColdFusion", quarter:"Q4", revenue:215, cost:90},
  {customer:"AAA", product:"Flex", quarter:"Q1", revenue:210, cost:90},
  {customer:"AAA", product:"Dreamweaver", quarter:"Q2", revenue:175, cost:190},
  {customer:"AAA", product:"Flash", quarter:"Q3", revenue:670, cost:75},
  
  {customer:"BBB", product:"ColdFusion", quarter:"Q1", revenue:175, cost:20},
  {customer:"BBB", product:"Flex", quarter:"Q2", revenue:210, cost:20},
  {customer:"BBB", product:"Dreamweaver",quarter:"Q3", revenue:120, cost:120},
  {customer:"BBB", product:"Flash", quarter:"Q4", revenue:310, cost:70},
  
  {customer:"CCC", product:"ColdFusion", quarter:"Q1", revenue:385, cost:120},
  {customer:"CCC", product:"Flex", quarter:"Q2", revenue:340, cost:120},
  {customer:"CCC", product:"Dreamweaver", quarter:"Q3", revenue:470, cost:220},
  {customer:"CCC", product:"Flash", quarter:"Q4", revenue:270, cost:170},
  
  
  {customer:"AAA", product:"ColdFusion", quarter:"Q1", revenue:100, cost:25},
  {customer:"AAA", product:"Flex", quarter:"Q2", revenue:150, cost:25},
  {customer:"AAA", product:"Dreamweaver", quarter:"Q3", revenue:200, cost:125},
  {customer:"AAA", product:"Flash", quarter:"Q4", revenue:300, cost:75},
  
  {customer:"BBB", product:"ColdFusion", quarter:"Q2", revenue:175, cost:20},
  {customer:"BBB", product:"Flex", quarter:"Q3", revenue:100, cost:20},
  {customer:"BBB", product:"Dreamweaver", quarter:"Q4", revenue:270, cost:120},
  {customer:"BBB", product:"Flash", quarter:"Q1", revenue:370, cost:70},
  
  {customer:"CCC", product:"ColdFusion", quarter:"Q3", revenue:410, cost:120},
  {customer:"CCC", product:"Flex", quarter:"Q4", revenue:300, cost:320},
  {customer:"CCC", product:"Dreamweaver", quarter:"Q1", revenue:510, cost:220},
  {customer:"CCC", product:"Flash", quarter:"Q2", revenue:620, cost:170},
  
  {customer:"AAA", product:"ColdFusion", quarter:"Q4", revenue:215, cost:90},
  {customer:"AAA", product:"Flex", quarter:"Q1", revenue:210, cost:90},
  {customer:"AAA", product:"Dreamweaver", quarter:"Q2", revenue:175, cost:190},
  {customer:"AAA", product:"Flash", quarter:"Q3", revenue:420, cost:75},
  
  {customer:"BBB", product:"ColdFusion", quarter:"Q1", revenue:240, cost:20},
  {customer:"BBB", product:"Flex", quarter:"Q2", revenue:100, cost:20},
  {customer:"BBB", product:"Dreamweaver", quarter:"Q3", revenue:270, cost:120},
  {customer:"BBB", product:"Flash", quarter:"Q4", revenue:370, cost:70},
  
  {customer:"CCC", product:"ColdFusion", quarter:"Q1", revenue:375, cost:120},
  {customer:"CCC", product:"Flex", quarter:"Q2", revenue:420, cost:120},
  {customer:"CCC", product:"Dreamweaver", quarter:"Q3", revenue:680, cost:220},
  {customer:"CCC", product:"Flash", quarter:"Q4", revenue:570, cost:170}
          
]);
