package org.pio.web;

import java.util.Collections;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.common.collect.ImmutableMap;

/**
 * Sample controller
 */
@RestController
@RequestMapping("/pio-web")
public class SampleController {

    private final static Logger LOG = LoggerFactory.getLogger(SampleController.class);

    private final String sampleData;
    private final String environment;

    public SampleController(@Value("${sample.data}") String sampleData,
            @Value("${environment}") String environment) {
        this.sampleData = sampleData;
        this.environment = environment;
    }


    @RequestMapping(value = "/status", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> status() {
        return new ImmutableMap.Builder<String, String>()
                .put("status", "OK")
                .put("env", environment)
                .put("data", sampleData)
                .build();
    }

    @RequestMapping(value = "/data", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> data() {
        LOG.info("data request");
        return Collections.singletonMap("configurable-data", sampleData);
    }
}
