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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IMXMLDocument;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.utils.sendBeadEvent;
    
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
     *  @royaleignoreimport org.apache.royale.core.IChild
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ParentDocumentBead extends DispatcherBead
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
        
            
        //TODO (aharui) watch for re-parenting

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
                sendBeadEvent(this,"idChanged");
            }
        }
        
        [Bindable("parentDocumentChange")]
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IChild
         * @royaleignorecoercion org.apache.royale.core.IMXMLDocument
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
