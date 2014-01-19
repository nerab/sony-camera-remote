# SonyCameraRemote

[![Build Status](https://secure.travis-ci.org/nerab/sony-camera-remote.png?branch=master)](http://travis-ci.org/nerab/sony-camera-remote)

Provides a Ruby wrapper around the API for cameras that support the Sony [Camera Remote API](http://developer.sony.com/develop/cameras/).

## Installation

Add this line to your application's Gemfile:

    gem 'sony-camera-remote'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sony-camera-remote

## Usage

    require 'sony_camera_remote'

    # Discover cameras and their services using UPnP
    Discovery::Client.new.discover
    # => ['http://10.0.0.1:10000/sony/camera']

    cam = Camera.new('http://10.0.0.1:10000/sony/camera')
    img_uri = cam.shoot
    # => http://10.0.0.1:60152/pict140119_1923230000.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21

## Command-line client

    # Assuming that the camera is in photo mode
    $ sonycam shoot
    http://10.0.0.1:60152/pict140119_1923230000.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21

    # Shoot and open browser with the returned image URL
    $ open $(sonycam)     # Mac
    $ xdg-open $(sonycam) # GNOME

## Manually testing the Camera Remote API

    # Discover devices using UPnP
    bin/search-nex.py

    # Fetch the endpoint URLs manually
    curl http://10.0.0.1:64321/DmsRmtDesc.xml | xmllint --format -

    # take a picture manually
    curl -v -X POST -H "Content-Type: application/json" -d '{"method":"actTakePicture", "params":[], "id":1, "version":"1.0"}' http://10.0.0.1:10000/sony/camera
