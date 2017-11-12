/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.royale.amfsamples.services;

import org.apache.royale.amfsamples.valueobjects.ServerCustomType;
import org.apache.royale.amfsamples.valueobjects.Product;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.stereotype.Service;

@Service("exampleService")
@RemotingDestination
public class ExampleService {

    public String echo(String name) {
        System.out.println(String.format("Got message from: %s", name));
        return String.format("Hello %s", name);
    }
    
    public Object[] getObjectArray1()
    {
        System.out.println("getObjectArray1 called");
        Object[] customTypes = new Object[10];
        for (int i = 0; i < customTypes.length; i++)
        {
            ServerCustomType sct = new ServerCustomType();
            sct.setId(i);
            customTypes[i] = sct;
        }
        return customTypes;
    }

    public Product getSomeProduct()
    {
        System.out.println("getSomeProduct called");

        Product product = new Product();
        product.setName("Some product");
        product.setDescription("This product is only a test typed value object to test AMF strong types");

        return product;
    }
}
