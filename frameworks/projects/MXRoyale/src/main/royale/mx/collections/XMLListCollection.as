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

package mx.collections
{

/* [DefaultProperty("source")]
 */
/**
 *  The XMLListCollection class provides collection functionality to
 *  an XMLList object and makes available some of the methods of
 *  the native XMLList class.
 *
 *  @mxml
 * 
 *  <p>The <code>&lt;mx:XMLListCollection&gt;</code> tag inherits all
 *  the attributes of its superclass, and adds the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:XMLListCollection
 *  <b>Properties</b>
 *  source="null"
 *  /&gt;
 *  </pre>
 * 
 *  @see XMLList
 *  @see XML
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class XMLListCollection 
{
/*     include "../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *
     *  <p>Creates a new XMLListCollection object
     *  using the specified XMLList object.</p>
     * 
     *  @param source The XMLList object containing the data to be represented
     *                by the XMLListCollection object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function XMLListCollection(source:Object = null)
    {
        super();

       // this.source = source;
    }

    

}

}
