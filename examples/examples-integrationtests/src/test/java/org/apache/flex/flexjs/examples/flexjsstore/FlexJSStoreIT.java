package org.apache.flex.flexjs.examples.flexjsstore;

import org.apache.flex.flexjs.examples.AbstractIT;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

/**
 * Created by christoferdutz on 13.01.17.
 */
public class FlexJSStoreIT extends AbstractIT {

    @Override
    protected String getContext() {
        return "FlexJSStore";
    }

    @Test
    public void testDeveloperSearch() {
        initTest();

        // Get the developerSearch input field.
        WebElement developerSearchInput = driver.findElement(By.id("developerSearchInput"));
        Assert.assertNotNull(developerSearchInput);
        Assert.assertEquals(developerSearchInput.getTagName(), "input");

        // Enter "Test" into the input field.
        developerSearchInput.sendKeys("Test");

        // Get the "Go" button.
        WebElement developerSearchButton = driver.findElement(By.id("developerSearchButton"));
        Assert.assertNotNull(developerSearchButton);
        Assert.assertEquals(developerSearchButton.getTagName(), "button");

        // Click on the "Go" button.
        developerSearchButton.click();

        // Unfortunately this feature is not yet implemented, so we have to close the popup again.
        Alert alert = driver.switchTo().alert();
        Assert.assertNotNull(alert);
        Assert.assertEquals("This feature is not implemented in this sample", alert.getText());
        alert.accept();
    }

    @Test
    @Ignore("Commented out till FLEX-35243 is fixed")
    public void testNavigation() {
        initTest();

        // Get the "Home" button.
        WebElement homeButton = driver.findElement(By.id("homeButton"));
        Assert.assertNotNull(homeButton);
        Assert.assertEquals(homeButton.getTagName(), "button");

        // Get the "Products" button.
        WebElement productsButton = driver.findElement(By.id("productsButton"));
        Assert.assertNotNull(productsButton);
        Assert.assertEquals(productsButton.getTagName(), "button");

        // Get the "Support" button.
        WebElement supportButton = driver.findElement(By.id("supportButton"));
        Assert.assertNotNull(supportButton);
        Assert.assertEquals(supportButton.getTagName(), "button");

        // Click on the "products" button.
        productsButton.click();
        // Wait for the transition to be finished.
        String classes = homeButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));
        classes = productsButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertTrue(classes.contains("toggleTextButton_Selected"));
        classes = supportButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));

        // Click on the "support" button.
        supportButton.click();
        // Wait for the transition to be finished.
        classes = homeButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));
        classes = productsButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));
        classes = supportButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertTrue(classes.contains("toggleTextButton_Selected"));

        // Click on the "home" button.
        homeButton.click();
        // Wait for the transition to be finished.
        classes = homeButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertTrue(classes.contains("toggleTextButton_Selected"));
        classes = productsButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));
        classes = supportButton.getAttribute("class");
        Assert.assertNotNull(classes);
        Assert.assertFalse(classes.contains("toggleTextButton_Selected"));
    }

}
