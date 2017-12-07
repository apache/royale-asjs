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
package org.apache.royale.net
{
	import org.apache.royale.core.IStrand;
    COMPILE::SWF
    {
        import org.apache.royale.events.EventDispatcher;
        import org.apache.royale.core.addBeadsToStrand;
        import org.apache.royale.core.IBead;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.ElementWrapper;
    }
    
    /**
     *  The data class for HTTP headers in HTTP server communications.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class HTTPServiceBase extends EventDispatcher implements IStrand, IBead
	{
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            if(beads && beads.length)
            {
                addBeads();
            }
       }

		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.royale.core.IStrand#registerBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function registerBead(bead:IBead):void
        {
            if(beads)
                beads.push(bead);
            else
                beads = [bead];
        }

        /**
         *  @copy org.apache.royale.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}

        /**
         *  @copy org.apache.royale.core.IStrand#addBeads()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function addBeads():void
        {
            addBeadsToStrand(this,beads);
        }
		
        /**
         *  @copy org.apache.royale.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}        
    }

    COMPILE::JS
    public class HTTPServiceBase extends ElementWrapper
    {
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            if(beads && beads.length)
            {
                addBeads();
            }
       }
    }
}
