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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.utils.view {

	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IFlexInfo;

	COMPILE::SWF{
		import flash.display.DisplayObjectContainer;
		import flash.display.DisplayObject;
	}
    
    COMPILE::JS{
        import org.apache.royale.core.ElementWrapper;
    }


	/**
	 * A utility function to check whether a content item has a container in its parent chain
	 *
	 * @param container
	 * @param content
	 * @return true if the content is present in the child hierarchy of the container
	 *
	 * @royaleignorecoercion org.apache.royale.core.ElementWrapper
	 */
	public function applicationContains(container:IFlexInfo, content:UIBase):Boolean {
		if (!content) return false;
		if (!container) return false;
		COMPILE::SWF{
			return DisplayObjectContainer(container).contains(DisplayObject(content));
		}

		COMPILE::JS{
			return (container as ElementWrapper).element.contains(content.element)
		}

	}
}
