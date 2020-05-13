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
package org.apache.royale.examples.jewel;

import org.apache.royale.examples.AbstractIT;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

/**
 */
public class TourDeJewelIT extends AbstractIT {

    @Override
    protected String getContext() {
        return "TourDeJewel";
    }

    @Test
    public void testJewelLogo() {
        initTest();

        WebElement jewelLogo = driver.findElement(By.xpath("//input[contains(@src, 'assets/apache-royale-jewel-logo-white.svg')]"));
        Assert.assertNotNull(jewelLogo);

    }
    
}
