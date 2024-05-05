Designed a traffic light controller for the intersection of two one-way streets
The traffic light controller will have two inputs (car sensors on North and East roads to detect whether there is a car or not) and six outputs (one for each light in the traffic signal). The traffic light is to operate as follows:
 - If no cars are coming, stay in a green state, but which one doesn’t matter.
 - To change from green to red, implement a yellow light of 5 seconds.
 - Green lights will last at least 30 seconds.
 - If cars are only coming in one direction, stay green in that direction.
 - If cars are coming in both directions, cycle through all four states (greenN-redE (30 seconds), yellowN- yellowE (5 seconds), redN-greenE(30 seconds), yellowN-yellowE (5 seconds)).

Used two switches on the FPGA board as the car sensors’ inputs and six LEDs for the traffic lights. and the time counter output in seconds on the seven segment display.
