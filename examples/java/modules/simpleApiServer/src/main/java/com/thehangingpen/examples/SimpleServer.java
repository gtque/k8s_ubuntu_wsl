package com.thehangingpen.examples;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.ApplicationContext;

/**
 * Created by Eric Angeli on 11/30/2018.
 */
@SpringBootApplication
@EnableDiscoveryClient
public class SimpleServer {

    public static void main(String[] args) {
        System.out.println("*******************************");
        System.out.println("          STARTING UP          ");
        System.out.println("*******************************");
//        Map<String, String> envMap = System.getenv();
//
//        for (String envName : envMap.keySet()) {
//            System.out.format("%s = %s%n", envName, envMap.get(envName));
//        }
        ApplicationContext ctx = SpringApplication.run(SimpleServer.class, args);
    }
}