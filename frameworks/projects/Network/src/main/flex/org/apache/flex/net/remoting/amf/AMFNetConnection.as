////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

/***
 * AMF JavaScript library by Emil Malinov https://github.com/emilkm/amfjs
 */

package org.apache.royale.net.remoting.amf
{

COMPILE::SWF
{
import flash.events.AsyncErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
}
    
import org.apache.royale.net.Responder;
import org.apache.royale.net.remoting.messages.ActionMessage;
import org.apache.royale.net.remoting.messages.ErrorMessage;
import org.apache.royale.net.remoting.messages.MessageBody;
import org.apache.royale.net.remoting.messages.MessageHeader;
    
/**
 *  Send data via AMF to a server.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class AMFNetConnection
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function AMFNetConnection()
    {
        super();
        COMPILE::SWF
        {
            nc = new NetConnection();
            nc.objectEncoding = ObjectEncoding.AMF3;
            nc.client = this;
        }
    }
    
    private var url:String;
    
    COMPILE::SWF
    private var nc:NetConnection;
    
    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------    

    /**
     *  Connect to a server.  Pass in an http URL as the commmand for
     *  connection to AMF server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function connect(command:String, ... params):void
    {
        // send a ping to the URL in the command param
        url = command;
        COMPILE::SWF
        {
            var args:Array = params.slice();
            args.unshift(command);
            nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            nc.connect.apply(nc, args);
        }
    }

    COMPILE::SWF
    private function statusHandler(event:NetStatusEvent):void
    {
        trace("statusHandler", event.info.code);
    }
    
    COMPILE::SWF
    private function securityErrorHandler(event:SecurityErrorEvent):void
    {
        trace("securityErrorHandler", event);
    }
    
    COMPILE::SWF
    private function ioErrorHandler(event:IOErrorEvent):void
    {
        trace("ioErrorHandler", event);
    }
    
    COMPILE::SWF
    private function asyncErrorHandler(event:AsyncErrorEvent):void
    {
        trace("asyncErrorHandler", event);
    }
    
    
    /**
     *  @private
     *  Special handler for legacy AMF packet level header "AppendToGatewayUrl".
     *  When we receive this header we assume the server detected that a session was
     *  created but it believed the client could not accept its session cookie, so we
     *  need to decorate the channel endpoint with the session id.
     *
     *  We do not modify the underlying endpoint property, however, as this session
     *  is transient and should not apply if the channel is disconnected and re-connected
     *  at some point in the future.
     */
    COMPILE::SWF
    public function AppendToGatewayUrl(value:String):void
    {
        if (value != null && value != "")
        {
            nc.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            trace("disconnecting because AppendToGatewayUrl called");
            nc.close();
            trace("disconnecting returned from close()");
            // WSRP support - append any extra stuff on the wsrp-url, not the actual url.
            
            // Do we have a wsrp-url?
            var i:int = url.indexOf("wsrp-url=");
            if (i != -1)
            {
                // Extract the wsrp-url in to a string which will get the
                // extra info appended to it
                var temp:String = url.substr(i + 9, url.length);
                var j:int = temp.indexOf("&");
                if (j != -1)
                {
                    temp = temp.substr(0, j);
                }
                
                // Replace the wsrp-url with a version that has the extra stuff
                url = url.replace(temp, temp + value);
            }
            else
            {
                // If we didn't find a wsrp-url, just append the info
                url += value;
            }
            nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            trace("reconnecting with " + url);
            nc.connect(url);
            trace("reconnecting returned from connect()");
        }
    }
    
    COMPILE::JS
    private var xhr:XMLHttpRequest;

    private var responder:Responder;

    COMPILE::JS
    private var args:Array;
    
    /**
     *  Call a server function.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function call(command:String, responder:Responder, ... params):void
    {
        COMPILE::SWF
        {
            var args:Array = params.slice();
            args.unshift(responder.getActualResponder());
            args.unshift(command);
            nc.call.apply(nc, args);
        }
        COMPILE::JS
        {
            this.responder = responder;
            this.args = params;
            
            if (!xhr)
            {
                xhr = new XMLHttpRequest();
                xhr.onreadystatechange = onReadyStateChange;
            }
            
            xhr.open("POST", url, true);
        }
    }
    
    private var sequence:int = 0;
    
    /**
     * @royaleignorecoercion Array
     */
    COMPILE::JS
    private function onReadyStateChange():void
    {
        var readyState:int = xhr.readyState;
        if (readyState === 1)
        {
            xhr.setRequestHeader("Content-Type", "application/x-amf; charset=UTF-8");
            xhr.responseType = "arraybuffer";
            var actionMessage:ActionMessage = new ActionMessage();
            var messageBody:MessageBody = new MessageBody();
            sequence++;
            messageBody.responseURI = "/" + sequence.toString();
            messageBody.data = args;
            actionMessage.bodies = [ messageBody ];
            var binaryData:AMFBinaryData = new AMFBinaryData();
            writeMessage(binaryData, actionMessage);
            xhr.send(new Uint8Array(binaryData.data));
        }
        else if (readyState === 4)
        {
            try 
            {
                if (xhr.status >= 200 && xhr.status <= 300
                    && xhr.responseType == "arraybuffer"
                    && xhr.getResponseHeader("Content-type").indexOf("application/x-amf") > -1) 
                {
                    var message:ActionMessage;
                    var body:MessageBody;
                    var deserializer:AMFBinaryData = new AMFBinaryData(new Uint8Array(xhr.response) as Array);
                    try 
                    {
                        message = readMessage(deserializer) as ActionMessage;
                    } 
                    catch (e) 
                    {
                        responder.onFailure({code:-1001, message:"Failed decoding the response.", detail:null, data:null});
                        return;
                    }
                    for (var i:int in message.bodies)
                    {
                        body = message.bodies[i];
                        if (!(body.data is ErrorMessage))
                            responder.onSuccess(body.data);
                        else
                            responder.onFailure(body.data);
                    }
                } 
                else if (xhr.status == 0 || xhr.responseType == "text")
                {
                    responder.onFailure({code:-1004, message:"Invalid response type.", detail:"Invalid XMLHttpRequest response status or type.", data:null});
                }
                else
                {
                    responder.onFailure({code:-1005, message:"Invalid response.", detail:"", data:null});
                }
            } 
            catch (e) 
            {
                responder.onFailure({code:-1006, message:"Unknown error.", detail:e.message, data:null});
            }

        }
    }
        
    COMPILE::JS
    private function writeMessage(writer:AMFBinaryData, message:ActionMessage):void
    {
        try {
            writer.writeShort(message.version);
            writer.writeShort(message.headers.length);
            for (var header:MessageHeader in message.headers) {
                this.writeHeader(writer, message.headers[header]);
            }
            writer.writeShort(message.bodies.length);
            for (var body:MessageBody in message.bodies) {
                this.writeBody(writer, message.bodies[body]);
            }
        } catch (error) {
            console.log(error);
        }
    }
    
    COMPILE::JS
    private function writeHeader(writer:AMFBinaryData, header:MessageHeader):void
    {
        writer.writeUTF(header.name);
        writer.writeBoolean(header.mustUnderstand);
        writer.writeInt(AMFBinaryData.UNKNOWN_CONTENT_LENGTH);
        writer.reset();
        //writer.writeObject(header.data);
        writer.write(AMFBinaryData.AMF0_BOOLEAN);
        writer.writeBoolean(true);
    }
    
    COMPILE::JS
    private function writeBody(writer:AMFBinaryData, body:MessageBody):void
    {
        if (body.targetURI == null) {
            writer.writeUTF(AMFBinaryData.NULL_STRING);
        } else {
            writer.writeUTF(body.targetURI);
        }
        if (body.responseURI == null) {
            writer.writeUTF(AMFBinaryData.NULL_STRING);
        } else {
            writer.writeUTF(body.responseURI);
        }
        writer.writeInt(AMFBinaryData.UNKNOWN_CONTENT_LENGTH);
        writer.reset();
        writer.write(AMFBinaryData.AMF0_AMF3);
        writer.writeObject(body.data);

    }
    
    COMPILE::JS
    private function readMessage(reader:AMFBinaryData):ActionMessage
    {
        var message:ActionMessage = new ActionMessage();
        message.version = reader.readUnsignedShort();
        var headerCount:uint = reader.readUnsignedShort();
        for (var i:uint = 0; i < headerCount; i++) {
            message.headers.push(this.readHeader(reader));
        }
        var bodyCount:uint = reader.readUnsignedShort();
        for (i = 0; i < bodyCount; i++) {
            message.bodies.push(this.readBody(reader));
        }
        return message;
    }
    
    COMPILE::JS
    private function readHeader(reader:AMFBinaryData):MessageHeader
    {
        var header:MessageHeader = new MessageHeader();
        header.name = reader.readUTF();
        header.mustUnderstand = reader.readBoolean();
        reader.pos += 4; //length
        reader.reset();
        var type:uint = reader.read();
        if (type != 2) { //amf0 string
            throw "Only string header data supported.";
        }
        header.data = reader.readUTF();
        return header;
    }
    
    COMPILE::JS
    private function readBody(reader:AMFBinaryData):MessageBody
    {
        var body:MessageBody = new MessageBody();
        body.targetURI = reader.readUTF();
        body.responseURI = reader.readUTF();
        reader.pos += 4; //length
        reader.reset();
        body.data = reader.readObject();
        return body; 
    }
}

}
