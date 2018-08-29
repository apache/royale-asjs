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

package mx.rpc.remoting.mxml
{

import org.apache.royale.events.Event;
import mx.rpc.remoting.RemoteObject;

/*import flash.events.ErrorEvent;

import mx.core.mx_internal;
import mx.core.IMXMLObject;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.mxml.IMXMLSupport;
import mx.rpc.remoting.mxml.Operation;

use namespace mx_internal;
*/
//[ResourceBundle("rpc")]

/**
 *  Use the &lt;mx:RemoteObject&gt; tag to represent an HTTPService object in an MXML file.
 *  This tag gives you access to the methods of
 * Java objects using Action Message Format (AMF) encoding.

 * @mxml
 * <p>
 * The &lt;mx:RemoteObject&gt; tag accepts the following tag attributes:
 * </p>
 * <pre>
 * &lt;mx:RemoteObject
 *  <b>Properties</b>
 *  concurrency="multiple|single|last"
 *  destination="<i>No default.</i>"
 *  id="<i>No default.</i>"
 *  endpoint="<i>No default.</i>"
 *  showBusyCursor="false|true"
 *  source="<i>No default.</i>" (currently, Adobe ColdFusion only)
 *  makeObjectsBindable="false|true"
 *  
 *  <b>Events</b>
 *  fault="<i>No default.</i>"
 *  result="<i>No default.</i>"  
 * /&gt;
 * </pre>
 * </p>
 *
 * <p>
 * &lt;mx:RemoteObject&gt; can have multiple &lt;mx:method&gt; tags, which have the following tag attributes:
 * </p>
 * <pre>
 * &lt;mx:method
 *  <b>Properties</b>
 *  concurrency="multiple|single|last"
 *  name="<i>No default, required.</i>"
 *  makeObjectsBindable="false|true"
 *         
 * <b>Events</b>
 *  fault="<i>No default.</i>"
 *  result="<i>No default.</i>"
 * /&gt;
 * </pre>
 * <p>
 * It then can have a single &lt;mx:arguments&gt; child tag which is an array of objects that is passed
 * in order.
 *
 * @includeExample examples/RemoteObjectExample.mxml -noswf
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *
 */
public dynamic class RemoteObject extends mx.rpc.remoting.RemoteObject 
	//		implements IMXMLSupport, IMXMLObject
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     * Create a new RemoteObject.
     * 
     *  @param destination The destination of the RemoteObject, should match a destination name 
     * in the services-config.xml file.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	 
	public function RemoteObject(destination:String = null)
    {
        super(destination);
		
		showBusyCursor = false;
    }
	
	//--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------
   	
	public static const FAULT:String = "fault";
	
	//----------------------------------
    //  requestTimeout
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  Provides access to the request timeout in seconds for sent messages. 
     *  A value less than or equal to zero prevents request timeout.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function get requestTimeout():int
    {
        return 0;
    }

    /**
     *  @private
     */
    public function set requestTimeout(value:int):void
    {
        if (requestTimeout != value)
        {
            requestTimeout = value;
        }
    }

	public static const RESULT:String = "result";

}

}
