package com.digicarts.e2e.steps.api;

import com.digicarts.e2e.api.context.ScenarioContext;
import com.digicarts.e2e.config.EnvConfig;
import io.cucumber.java.en.*;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

public class PlatformApiSteps {

    private static final String BASE = EnvConfig.API_URL;

    @When("I request the platform analytics")
    public void getPlatformAnalytics() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/analytics");
        ScenarioContext.setResponse(r);
    }

    @When("I request the platform analytics without auth")
    public void getPlatformAnalyticsNoAuth() {
        ScenarioContext.setResponse(RestAssured.given().baseUri(BASE).get("/api/platform/analytics"));
    }

    @When("I request the platform config")
    public void getPlatformConfig() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/platform-config");
        ScenarioContext.setResponse(r);
    }

    @When("I request the platform services status")
    public void getPlatformServicesStatus() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/services/status");
        ScenarioContext.setResponse(r);
    }

    @When("I request the setup wizard")
    public void getSetupWizard() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/setup-wizard");
        ScenarioContext.setResponse(r);
    }

    @When("I request the subscriptions list")
    public void getSubscriptions() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/subscriptions");
        ScenarioContext.setResponse(r);
    }

    @When("I create a subscription without required fields")
    public void createSubscriptionNoFields() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .contentType(ContentType.JSON)
                .header("Authorization", "Bearer " + token)
                .body("{}")
                .post("/api/platform/subscriptions");
        ScenarioContext.setResponse(r);
    }

    @When("I request the support tickets list")
    public void getSupportTickets() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/support");
        ScenarioContext.setResponse(r);
    }

    @When("I request the platform AI config")
    public void getPlatformAiConfig() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/platform-config/ai");
        ScenarioContext.setResponse(r);
    }

    @When("I patch platform info content with empty body")
    public void patchPlatformInfoContent() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .contentType(ContentType.JSON)
                .header("Authorization", "Bearer " + token)
                .body("{}")
                .patch("/api/platform/platform-config/info-content");
        ScenarioContext.setResponse(r);
    }

    @When("I send AI chat message {string}")
    public void sendAiChatMessage(String message) {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .contentType(ContentType.JSON)
                .header("Authorization", "Bearer " + token)
                .body("{\"message\":\"" + message + "\"}")
                .post("/api/platform/platform-config/ai-chat");
        ScenarioContext.setResponse(r);
    }

    @When("I upsert admin user by email {string}")
    public void upsertAdminUser(String email) {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .contentType(ContentType.JSON)
                .header("Authorization", "Bearer " + token)
                .body("{\"email\":\"" + email + "\",\"status\":\"active\"}")
                .post("/api/platform/admin/upsert-status");
        ScenarioContext.setResponse(r);
    }

    @When("I request the admin users list")
    public void getAdminUsers() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/admin");
        ScenarioContext.setResponse(r);
    }

    @When("I request the cleanup schema")
    public void getCleanupSchema() {
        String token = ScenarioContext.get("authToken");
        Response r = RestAssured.given().baseUri(BASE)
                .header("Authorization", "Bearer " + token)
                .get("/api/platform/cleanup/schema");
        ScenarioContext.setResponse(r);
    }
}
