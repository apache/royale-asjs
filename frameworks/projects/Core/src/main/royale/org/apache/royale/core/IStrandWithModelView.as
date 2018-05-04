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
     *  The IStrandWithModelView interface is the basic interface for a host component for
     *  a set of plug-ins known as Beads where two of the plugins are a model and a view.
     *  In Royale, the recommended pattern is to break out optional functionality
     *  into small plug-ins that can be re-used in other components, or replaced with
     *  different implementations optimized for different things such as size,
     *  performance, advanced features, debugging, etc.
     * 
     *  Beads are added to and removed from a Strand and can find and coordinate with
     *  other beads on the strand.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IStrandWithModelView extends IStrandWithModel
	{
        /**
         *  Each Strand has an view object.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get view():IBeadView;
        	
	}
}
