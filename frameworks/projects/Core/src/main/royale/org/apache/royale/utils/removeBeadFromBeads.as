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
package org.apache.royale.utils
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;

	/**
	 * Utility function for internal use in removeBead methods
	 *  @param beads the implementation's collection of beads to check against
	 *  @param beadToRemove the bead to remove
	 *  @param setStrandNull true if the strand setter of the removed bead should be set to null when it is removed
	 *
	 *  @return the removed Bead (if it was present), with its strand value set to null, otherwise null (no bead was removed).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.9
	*
	*/
	COMPILE::SWF
	public function removeBeadFromBeads(beads:Vector.<IBead>, beadToRemove:IBead, setStrandNull:Boolean):IBead
	{
		var i:uint, n:uint;
		n = beads.length;
		for (i = 0; i < n; i++)
		{
			if (beadToRemove === beads[i])
			{
				beads.splice(i, 1);
				if (setStrandNull) beadToRemove.strand = null;
				return beadToRemove;
			}
		}
		return null;
	}


	/**
	 *  Utility function for internal use in removeBead methods
	 *  @param beads the implementation's collection of beads to check against
	 *  @param beadToRemove the bead to remove
	 *  @param setStrandNull true if the strand setter of the removed bead should be set to null when it is removed
	 *
	 *  @return the removed Bead (if it was present), with its strand value set to null, otherwise null (no bead was removed).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.9
	 *  @royaleignorecoercion org.apache.royale.core.IBead
	 *
	 *  @royalesuppressexport
	 *  @royaleignorecoercion Array
	 */
	COMPILE::JS
	public function removeBeadFromBeads(beads:Object, beadToRemove:IBead, setStrandNull:Boolean):IBead
	{
		var i:uint, n:uint;
		var arr:Array = beads as Array; //we don't really have a Vector.<IBead> internally
		n = arr.length;
		for (i = 0; i < n; i++)
		{
			if (beadToRemove === arr[i])
			{
				arr.splice(i, 1);
				if (setStrandNull) beadToRemove.strand = null;
				return beadToRemove;
			}
		}
		return null;
	}
}
