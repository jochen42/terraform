# Dockerimage with some useful community plugins

[![Build Status](https://travis-ci.org/jochen42/terraform.svg?branch=master)](https://travis-ci.org/jochen42/terraform)

## Current included community plugins

- pingdom - github.com/russellcardullo/terraform-provider-pingdom
- keycloak - mrparkers/terraform-provider-keycloak
- kong - github.com/kevholditch/terraform-provider-kong
- dead man's snitch github.com/kevholditch/terraform-provider-dmsnitch
- kibana - github.com/ewilde/terraform-provider-kibana
- pass/gopass - camptocamp/terraform-provider-pass
- mozilla sops - github.com/carlpett/terraform-provider-sops
- elasticsearch - phillbaker/terraform-provider-elasticsearch

## Current supported terraform-versions

- 0.12.19
- 0.11.14

## Current golang version

- 0.13

## pipeline

A commit in the master-branch automaticly builds and pushs the image for serveral terraform-versions.

## TODO

- add some basic tests for initializon the plugins to ensure version-compatbility
