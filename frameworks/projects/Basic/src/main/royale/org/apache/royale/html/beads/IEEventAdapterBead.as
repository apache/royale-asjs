////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.html.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
	COMPILE::JS
	{
		import org.apache.royale.utils.object.defineSimpleGetter;
	}

	/**
	 *  The IEEventAdapterBead is used to enable correct handling of MouseEvents and KeyboardEvents in IE.
	 *  This is needed because IE does not support the <code>name</code> property.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
    public class IEEventAdapterBead implements IBead
    {
        public function IEEventAdapterBead()
        {
            
        }

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function set strand(value:IStrand):void
		{
			COMPILE::JS
			{
				if(typeof window["KeyboardEvent"]["name"] == "undefined")
				{// IE does not have a prototype name property
					defineSimpleGetter(window["KeyboardEvent"],"name","KeyboardEvent");
					defineSimpleGetter(window["MouseEvent"],"name","MouseEvent");
				}
			}
		}

    }
}