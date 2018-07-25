###AE4311_Assignment

##Fault Tolerant Flight Control using Model and Sensor based Approaches

#Problem statements:

This assignment is about Fault Tolerant Flight Control (FTFC) using two nonlinear adaptive control approaches: Adaptive Nonlinear Dynamic Inversion (ANDI) and Incremental Nonlinear
Dynamic Inversion (INDI). ANDI is an indirect model based control approach which involves aircraft online model identification, using the two-step approach learnt in the course on System
Identification of Aerospace Vehicles, AE4-320, and Nonlinear Dynamic Inversion (NDI), learnt in the course of Advanced Flight Control, AE4-311. INDI is a sensor based nonlinear adaptive
control approach learnt in the course of Advanced Flight Control. This assignment must be done with the Cessna Citation simulation model supplied in Simulink, and this model can be steered
by means of a joystick. In this assignment, a manual version of an FTFC algorithm will be developed and will be evaluated for one failure scenario.
As learnt in AE4-320, the two step method consists of two major steps, namely aircraft state estimation and aerodynamic model identification. Estimation of aircraft states is done by making
use of the kinematic and observation model, based upon redundant but contaminated information from all sensors (air data, inertial, magnetic and GPS measurements). For this purpose, a Kalman
Filter is used. After the aircraft flight trajectory has been estimated through the aircraft states, the aerodynamic model identification is done in the subsequent step. The aerodynamic model
identification can be performed with the Recursive Least Squares Approach.

Since the implementation of the two step method has been performed already in the assignment
of AE4-320 in a batch setup, this assignment will ignore the Kalman Filter for the state
estimation step. This means that the available sensor information in the to be used Cessna
Citation simulation model can be considered as not contaminated. Mind that this is an
idealization of the reality, but it is better to focus on new developments rather than repeating the
design of algorithms which has already been done before.
The INDI approach uses the angular velocity measurements to reconstruct the angular
acceleration body components which are used in the inner-loop rate NDI controllers.

This assignment consists of 7 major steps:
1. Implement the specified failure dynamics and the given joystick control input in the simulation model.
2. Implement the Aerodynamic Model Identification algorithm in the simulation model
3. Design and implement a monitoring algorithm that triggers the reset switch in the
Aerodynamic Model Identification step after a failure has occurred
4. Design and implement a manual adaptive nonlinear dynamic inversion algorithm for the angular rates in roll, pitch and yaw.
5. Analyse and compare the handling qualities of the aircraft with classical and ANDI based fault tolerant control, before and after activation of the failure.
6. Design the INDI inner-loop rate controller without using the system identification in the control loop.
7. Analyse and compare the handling qualities of the aircraft with INDI based fault tolerant control, before and after activation of the failure.