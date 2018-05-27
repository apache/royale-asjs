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

@Service("compressedService")
@RemotingDestination
public class CompressedService {

    public Product getSomeCompressedProduct()
    {
        System.out.println("getSomeCompressedProduct called");

        Product product = new Product();
        product.setName("Some compressed product");
        product.setDescription("This compressed product is only a test typed value object to test AMF strong types");
        
        Taxonomy taxonomy = new Taxonomy();
        taxonomy.setType("a type");
        taxonomy.setDescription("a taxonomy for this compressed product");

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
}
