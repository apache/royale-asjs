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
package flexUnitTests.network.support
{
    import org.apache.royale.utils.net.IDynamicPropertyWriter;
    import org.apache.royale.reflection.*;
    
    COMPILE::JS{
        import org.apache.royale.utils.net.IDynamicPropertyOutput;
    }
    
    COMPILE::SWF{
        import flash.net.IDynamicPropertyOutput;
    }
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class DynamicPropertyWriter implements IDynamicPropertyWriter
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing with it
        
        
        public function DynamicPropertyWriter()
        {
            // constructor code
        }
        
        public var excludeBeginningUnderscores:Boolean = true;
        
        public function writeDynamicProperties(obj:Object, output:IDynamicPropertyOutput):void
        {
            var dynamicProperties:Array = getDynamicFields(obj);
            while (dynamicProperties.length)
            {
                var prop:String = dynamicProperties.shift();
                if (excludeBeginningUnderscores && (prop.charAt(0) == '_')) continue;
                output.writeDynamicProperty(prop, obj[prop]);
            }
        }
        
    }
    
}
