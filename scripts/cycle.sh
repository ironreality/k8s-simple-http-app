#!/bin/bash

echo "Destroing env..."
vagrant destroy -f

echo "Creating env..."
time vagrant up
