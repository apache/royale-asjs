package org.apache.flex.flexjs.examples;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.openqa.selenium.firefox.FirefoxDriver;

import java.util.concurrent.TimeUnit;

/**
 * Created by christoferdutz on 13.01.17.
 */
public abstract class AbstractIT {

    protected static FirefoxDriver driver;

    @BeforeClass
    public static void openBrowser() {
        driver = new FirefoxDriver();
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    }

    @AfterClass
    public static void closeBrowser() {
        if(driver != null) {
            driver.quit();
        }
    }

    protected void initTest() {
        driver.get("http://localhost:8082/"+ getContext() +"/index.html");
    }

    protected abstract String getContext();

}
