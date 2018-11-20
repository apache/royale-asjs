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
import org.apache.royale.amfsamples.valueobjects.Taxonomy;
import org.apache.royale.amfsamples.valueobjects.Zone;
import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

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

    public Zone getSomeZone()
    {
        System.out.println("getSomeZone called");

        Zone zone =  new Zone();
        zone.setId(1);
        zone.setName("Europe");

        return zone;
    }

    public Product getSomeProduct()
    {
        System.out.println("getSomeProduct called");

        Product product = new Product();
        product.setName("Some product");
        product.setDescription("This product is only a test typed value object to test AMF strong types");
        
        Taxonomy taxonomy = new Taxonomy();
        taxonomy.setType("a type");
        taxonomy.setDescription("a taxonomy for this product");

        product.setTaxonomy(taxonomy);

        Set<Zone> zones = new HashSet<Zone>();
        
        Zone zone1 =  new Zone();
        zone1.setId(1);
        zone1.setName("Europe");
        zones.add(zone1);

        Zone zone2 =  new Zone();
        zone2.setId(2);
        zone2.setName("USA");
        zones.add(zone2);

        Zone zone3 =  new Zone();
        zone3.setId(3);
        zone3.setName("Asia");
        zones.add(zone3);
        

        /*Object[] zones = new Object[3];
        for (int i = 0; i < zones.length; i++)
        {
            Zone zone = new Zone();
            zone.setId(i);
            if (i == 0)
                zone.setName("Europa");
            else if (i == 1)
                zone.setName("USA");
            else if (i == 2)
                zone.setName("Asia");
            zones[i] = zone;
        }*/

        product.setZones(zones);
        
        List<CharSequence> list = new ArrayList<CharSequence>();
        list.add("A");
        list.add("B");
        list.add("A");
        list.add("C");
        list.add("C");
        list.add("B");
        product.setFlavors(new HashSet<CharSequence>(list));

        return product;
    }

    public String sendClientVO(ServerCustomType clientVO)
    {
        System.out.println("sendClientVO called!!");

        System.out.println(clientVO);

        return clientVO.toString();
    }

    public String sendSomeProduct(Product product)
    {
        System.out.println("sendSomeProduct called!!");

        System.out.println(product);

        return product.toString();
    }
}
