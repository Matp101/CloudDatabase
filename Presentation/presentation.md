# Presentation for Cloud Database

## Introduction

- mathew made it
- it's a database that stores battery data in the cloud
- we used it as a backend for our battery characterization project
- now, it is being used for data collection for other projects as well, as it is simple, scalable and easy to use

## Architecture

### Client

- The client is a bash script that runs on the raspberry pi, calling the `daly-bms-cli` tool to collect data from the battery
- each pi gets a unique serial number, login credentials, and a destination address
- a VPN was used to connect the pi to the database
- the client script runs on boot, and collects data from the battery as soon as it detects that the BMS is connected
- data points are collected at a fixed interval, and are both stored locally, and sent to the database as they are collected

### Server

- the server is a python mqtt client that runs on a cloud server
- it receives data from the clients, and stores it in a database
- The database is a simple MySQL database, with a single table for each battery
