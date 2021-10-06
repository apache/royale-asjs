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

package mx.rpc.soap
{

import mx.rpc.Fault;

/**
 * A subclass of mx.rpc.Fault that provides SOAP specific information from
 * a SOAP envelope Fault element.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SOAPFault extends Fault
{
    /**
     * Constructs a new SOAPFault.
     *
     * @param faultCode The fully qualified name of the fault code.
     * 
     * @param faultString The description of the fault.
     *
     * @param detail Any extra details of the fault.
     *
     * @param element The raw XML of the SOAP fault.
     *
     * @param faultactor Information about who caused the SOAP fault.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SOAPFault(faultCode:QName,
                       faultString:String,
                       detail:String = null,
                       element:XML = null,
                       faultactor:String = null)
    {
        super(faultCode.localName, faultString, detail);

        this.element = element;
        this.faultactor = faultactor;
        this.faultcode = faultCode;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    /**
     * The raw XML of this SOAP Fault.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var element:XML;

    /**
     * A SOAP Fault may provide information about who caused the fault through
     * a faultactor property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var faultactor:String;

    /**
     * The faultcode property is similar to faultCode but exists to both
     * match the case of the faultcode element in a SOAP Fault and to provide
     * the fully qualified name of the code.
     * 
     * @see mx.rpc.Fault#faultDetail
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var faultcode:QName;


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * The detail property is the same as faultDetail but exists
     * to match the case of the detail element in a SOAP Fault.
     * 
     * @see mx.rpc.Fault#faultDetail
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get detail():String
    {
        return _faultDetail;
    }

    public function set detail(value:String):void
    {
        _faultDetail = value;
    }

    /**
     * The faultstring property is the same as faultString but exists
     * to match the case of the faultstring element in a SOAP envelope Fault.
     * 
     * @see mx.rpc.Fault#faultString
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get faultstring():String
    {
        return _faultString;
    }

    public function set faultstring(value:String):void
    {
        _faultString = value;
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Returns the String "SOAPFault" plus the faultCode, faultString, and
     * faultDetail.
     *
     * @return Returns the String "SOAPFault" plus the faultCode, faultString, and
     * faultDetail.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function toString():String
    {
        return "SOAPFault (" + faultCode + "): " + faultString + " " + faultDetail;
    }
}

}
