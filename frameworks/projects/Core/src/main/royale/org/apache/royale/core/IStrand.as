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
     *  The IStrand interface is the basic interface for a host component for
     *  a set of plug-ins known as Beads.
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
	public interface IStrand
	{
        /**
         *  Add a bead to the strand.
         *
         *  @param bead The bead (IBead instance) to be added.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function addBead(bead:IBead):void;
        
        /**
         *  Find a bead (IBead instance) on the strand.
         *
         *  @param classOrInterface The class or interface to use
         *                                to search for the bead
         *  @return The bead.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function getBeadByType(classOrInterface:Class):IBead;

        /**
         *  Remove a bead from the strand.
         *
         *  @param bead The bead (IBead instance) to be removed.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function removeBead(bead:IBead):IBead;		
	}
}
