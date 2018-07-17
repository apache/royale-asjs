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
package org.apache.royale.core
{
    /**
     *  The IContainerBaseStrandChildrenHost interface is implemented by 
     *  components that use a ContainerBaseStrandChildren to proxy
     *  addElement/removeElement calls to an internal child and
     *  has the following APIs so the View can set up the "chrome" around
     *  the internal child.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public interface IContainerBaseStrandChildrenHost
	{
		function get $numElements():int;
		function $addElement(c:IChild, dispatchEvent:Boolean = true):void;
		function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void;
		function $removeElement(c:IChild, dispatchEvent:Boolean = true):void;
		function $getElementIndex(c:IChild):int;
		function $getElementAt(index:int):IChild;
	}
}
