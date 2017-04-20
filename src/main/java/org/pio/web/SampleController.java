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

/**
 * Sample controller
 */
@RestController
@RequestMapping("/pio-web")
public class SampleController {

    private final static Logger LOG = LoggerFactory.getLogger(SampleController.class);

    private final String sampleData;

    public SampleController(@Value("${sample.data}") String sampleData) {
        this.sampleData = sampleData;
    }

    @RequestMapping(value = "/status", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> status() {
        return Collections.singletonMap("status", "OK");
    }

    @RequestMapping(value = "/data", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, String> data() {
        LOG.info("data request");
        return Collections.singletonMap("configurable-data", sampleData);
    }
}
