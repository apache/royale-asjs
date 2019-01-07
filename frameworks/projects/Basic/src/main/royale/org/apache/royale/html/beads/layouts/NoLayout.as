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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IStrand;

  /**
   *  The NoLayout class allows specifying no layout
   *  to components which normally have a Layout bead.
   *
   *  @langversion 3.0
   *  @playerversion Flash 10.2
   *  @playerversion AIR 2.6
   *  @productversion Royale 0.9.6
   */
	public class NoLayout implements IBeadLayout
	{
    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
		public function NoLayout()
		{
			super();
		}

    /**
     * @copy org.apache.royale.core.IBeadLayout#layout
     */
		public function layout():Boolean
		{
      // do nothing
      return true;
		}
    public function set strand(value:IStrand):void
    {
      // do nothing
    }

	}
}
