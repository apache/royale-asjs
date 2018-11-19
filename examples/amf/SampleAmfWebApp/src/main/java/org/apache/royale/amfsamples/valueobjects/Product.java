/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.royale.amfsamples.valueobjects;

import java.util.Collection;
import java.util.Set;

/**
 * The server side object used by AMFConnectionTestService. There is a 
 * corresponding client side object.
 */
public class Product
{
    private String name;
    private String description;
    private Taxonomy taxonomy;
    private Set<Zone> zones;

    public Product()
    {
    }

    public String getName()
    {
        return name;
    }
    public void setName(String name)
    {
        this.name = name;
    }

    public String getDescription()
    {
        return description;
    }
    public void setDescription(String description)
    {
        this.description = description;
    }

    public Taxonomy getTaxonomy()
    {
        return taxonomy;
    }
    public void setTaxonomy(Taxonomy taxonomy)
    {
        this.taxonomy = taxonomy;
    }

    /**
    * The zone list.
    *
    * @return The zone list.
    */
    public Set<Zone> getZones() {
        return zones;
    }

    /**
    * The zones list.
    *
    * @param zones The zones list.
    */
    public void setZones(Set<Zone> zones) {
        this.zones = zones;
    }

    private Set<CharSequence> flavors = null;

    /**
    * The flavors set of names.
    *
    * @return The flavors set of names.
    */
    public Set<CharSequence> getFlavors() {
        return flavors;
    }

    /**
    * The flavors set of names.
    *
    * @param flavors The flavors set of names.
    */
    public void setFlavors(Set<CharSequence> flavors) {
        this.flavors = flavors;
    }


    public String toString()
    {
        return "Product -> name: " + name + ", description: " + description;
    }
}
