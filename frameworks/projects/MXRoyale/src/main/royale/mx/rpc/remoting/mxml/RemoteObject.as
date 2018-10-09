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
import org.apache.royale.core.IDocument;

COMPILE::SWF
{
    import flash.events.ErrorEvent;        
}
COMPILE::JS
{
    import mx.events.ErrorEvent;        
}

import mx.core.mx_internal;
import mx.core.IMXMLObject;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.mxml.IMXMLSupport;
import mx.rpc.remoting.mxml.Operation;
import mx.rpc.remoting.RemoteObject;

use namespace mx_internal;

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
 *  @productversion Flex 3
 *
 */
public dynamic class RemoteObject extends mx.rpc.remoting.RemoteObject implements IMXMLSupport, IMXMLObject, IDocument
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
     *  @productversion Flex 3
     */
    public function RemoteObject(destination:String = null)
    {
        super(destination);
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * If this event is an error or fault, and the event type does not
     * have a listener, we notify the parent document.  If the     
     * parent document does not have a listener, then we throw
     * a runtime exception.  However, this is an asynchronous runtime
     * exception which is only exposed through the debug player.
     * A listener should be defined.
     *
     * @private
     */
    override public function dispatchEvent(event:Event):Boolean
    {
        if (hasEventListener(event.type))
        {
            return super.dispatchEvent(event);
        }
        else if ((event is FaultEvent && !hasTokenResponders(event)) || event is ErrorEvent)
        {
            var reason:String = (event is FaultEvent) ?
                FaultEvent(event).fault.faultString :
                ErrorEvent(event).text;

            if (document && document.willTrigger(ErrorEvent.ERROR))
            {
                var evt:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, true, true);
                evt.text = reason;
                return document.dispatchEvent(evt);
            }
            else if (event is FaultEvent)
            {
                throw FaultEvent(event).fault;
            }
            else
            {
                var message:String = resourceManager.getString(
                    "rpc", "noListenerForEvent", [ reason ]);
                throw new Error(message);
            }
        }

        return false;
    }

    /**
     * Returns an Operation of the given name. If the Operation wasn't
     * created beforehand, a new <code>mx.rpc.remoting.mxml.Operation</code> is
     * created during this call. Operations are usually accessible by simply
     * naming them after the service variable
     * (<code>myService.someOperation</code>), but if your Operation name
     * happens to match a defined method on the service
     * (like <code>setCredentials</code>), you can use this method to get the
     * Operation instead.
     * @param name Name of the Operation.
     * @return Operation that executes for this name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getOperation(name:String):AbstractOperation
    {
        var o:Object = _operations[name];
        var op:AbstractOperation = (o is AbstractOperation) ? AbstractOperation(o) : null;
        if (op == null)
        {
            op = new Operation(this, name);
            _operations[name] = op;
            op.asyncRequest = asyncRequest;
            op.setKeepLastResultIfNotSet(_keepLastResult);
        }
        return op;
    }

    /**
     * Called automatically by the MXML compiler if the RemoteObject is set up using a tag.  If you create
     * the RemoteObject through ActionScript you may want to call this method yourself as it is useful for
     * validating any arguments.
     *
     * @param document the MXML document on which this RemoteObject lives
     * @param id the id of this RemoteObject within the document
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initialized(document:Object, id:String):void
    {
        this.document = document;
        this.id = id;

        initialize();
    }
    
    public function setDocument(document:Object, id:String = null):void
    {
        this.document = document;
        this.id = id;
        
        initialize();
    }


    public function getDocument():Object
    {
        return document;
    }
    
    public function getID():String
    {
        return id;
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    private var document:Object;
    
    private var id:String;
    
}

}
