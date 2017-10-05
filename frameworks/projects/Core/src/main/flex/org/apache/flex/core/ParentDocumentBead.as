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
package org.apache.flex.core
{
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IMXMLDocument;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    
    /**
     *  The ParentDocumentBead class looks up the parent
     *  chain to find a parent that was written in MXML.
     *  Because it is usually rare for an application
     *  to need to know this information, an optional bead
     *  is used to compute it, instead of baking in the
     *  overhead of a recursive infrastucture to store
     *  this information.  It is intended to be used
     *  as a bead in the top-level tag of an MXML document.
     *  
     *  @royaleignoreimport org.apache.flex.core.IChild
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ParentDocumentBead extends EventDispatcher implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ParentDocumentBead()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            
            //TODO (aharui) watch for re-parenting
        }    

        private var _id:String;
        
        /**
         *  An id property for MXML documents.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get id():String
        {
            return _id;
        }
        
        /**
         *  @private
         */
        public function set id(value:String):void
        {
            if (_id != value)
            {
                _id = value;
                dispatchEvent(new org.apache.flex.events.Event("idChanged"));
            }
        }
        
        [Bindable("parentDocumentChange")]
        /**
         *  @private
         *  @royaleignorecoercion org.apache.flex.core.IChild
         */
        public function get parentDocument():Object
        {
            var child:IChild = _strand as IChild;
            child = child.parent as IChild;
            while (child)
            {
                if (child is IMXMLDocument)
                {
                    var doc:IMXMLDocument = child as IMXMLDocument;
                    if (doc.MXMLDescriptor != null)
                        return doc;
                }
                child = child.parent as IChild;
            }
            return null;
        }
        
    }
}
