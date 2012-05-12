---
layout: processingjs
title: "Langton's Ant"
date: 2012-05-11 22:47
comments: true
categories: 
-   cellular-automata
excerpt: |
    A colorful 4-state two-dimensional Turing machine.
pde: /src/langtons-ant/langtons-ant.pde 
image: /src/langtons-ant/langtons-ant.png 
---
## Description

Langton’s Ant is a 4-state two-dimensional Turing machine invented
in the 1980s. The ant starts out on a grid containing black and
white cells, and then proceeds according to the following set of
rules:

1.  If the ant is on a black square, it turns right 90 degrees and
    moves forward one unit.
2.  If the ant is on a white square, it turns left 90 degrees and
    moves forward one unit.
3.  When the ant leaves a square, it inverts the color.




## Tools Used

* [Processing.js](http://processingjs.org/)
