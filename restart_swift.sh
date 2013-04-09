#! /bim/bash
vagrant destroy swift -f
vagrant destroy controller -f
vagrant up controller
vagrant up swift
