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
	import org.apache.royale.utils.MXMLDataInterpreter;

	[DefaultProperty("beads")]
	/**
	 *  A container bead that aggregates multiple child beads and applies them
	 *  to a strand as a single unit.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.13
	 */
	public class CompoundBead implements IBead, IStrand, IMXMLDocument
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function CompoundBead()
		{
			super();
		}
		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  Applies all currently stored beads to the specified strand.
		 *
		 *  @param value The strand that receives this compound bead's child beads.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			for each (var bead:IBead in beads)
				_strand.addBead(bead);
		}

		/**
		 *  Adds a child bead to this compound bead.
		 *
		 *  If this compound bead is already assigned to a strand, the child bead
		 *  is also added immediately to that strand.
		 *
		 *  @param bead The bead to add.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function addBead(bead:IBead):void
		{
			beads.push(bead);
			if (_strand)
				_strand.addBead(bead);
		}

		/**
		 *  Returns the first child bead that matches the specified type.
		 *
		 *  @param classOrInterface The class or interface type to match.
		 *  @return The first matching bead, or <code>null</code> if none match.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}

		/**
		 *  Removes a child bead from this compound bead.
		 *
		 *  If this compound bead is assigned to a strand, this method also attempts
		 *  to remove the same bead from that strand.
		 *
		 *  @param bead The bead to remove.
		 *  @return The removed bead if found either locally or on the strand;
		 *  otherwise <code>null</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function removeBead(bead:IBead):IBead
		{
			var retVal:IBead = bead;
			var index:int = beads.indexOf(bead);
			if (index != -1)
			{
				retVal = beads.splice(index, 1)[0];
			}
				if (_strand)
					var retVal2:IBead = _strand.removeBead(bead);
			return retVal || retVal2;
		}
		private var _beads:Array = [];

		/**
		 *  The child beads managed by this compound bead.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function get beads():Array
		{
			return _beads;
		}

		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;
		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get MXMLDescriptor():Array
		{
			return _mxmlDescriptor;
		}
		
		/**
		 *  @private
		 */
		public function setMXMLDescriptor(document:Object, value:Array):void
		{
			_mxmlDocument = document;
			_mxmlDescriptor = value;
		}
		
		/**
		 *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
		}
	}
}