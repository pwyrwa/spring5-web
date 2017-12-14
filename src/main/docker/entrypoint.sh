#!/bin/bash

export LOGS_HOME=${LOGS_HOME:=/var/log}

java -jar $JAVA_OPTS service.jar
