package com.rbkmoney.skipper;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@ServletComponentScan
@SpringBootApplication
public class SkipperApplication extends SpringApplication {

    public static void main(String[] args) {
        SpringApplication.run(SkipperApplication.class, args);
    }

}
