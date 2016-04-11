#!/bin/bash

filename="goodip.txt"
while read line
do
  #echo $line;
  expect ssh.exp $line
done <$filename
~                                                                                                                         
~               