# DRIVE: Digital twin for self-dRiving Intelligent VEhicles

DRIVE is an open-source vehicular network simulator that merges the world of Cooperative Intelligent Transportation Systems (C-ITSs) and Artificial Intelligence.

It is designed with a scalable and modular architecture in mind to reduce the computation complexity, but still maintain a high true-to-life representation of the world. 

A detailed description about the capabilities of DRIVE, and information on how to set it up and use it, can be found in our [User Manual](https://github.com/ioannismavromatis/smarterSimulator/blob/master/doc/userManualDRIVE.pdf). Also, a detailed description on how to generate a SUMO scenario and integrate it with DRIVE can be found in our [Wiki page](https://github.com/ioannismavromatis/DRIVE_Simulator/wiki).

Requirements
------------
- Recent version of MATLAB (tested with MATLAB 2019a and 2018b).
- SUMO Traffic Generator version >v1.0.0 (tested with SUMO v1.2.0 and v1.6.0).
- Any operating system (tested on Windows 10, Ubuntu 18.04 LTS, and macOS 10.14/10.15).
- TraCI4Matlab ([link](https://github.com/pipeacosta/traci4matlab)).

License and Citing DRIVE
------------

This code is freely available under the terms found in the [LICENCE](https://github.com/ioannismavromatis/DRIVE_Simulator/blob/master/LICENSE) file. If this code is used for drafting a manuscript, we ask the authors to cite our recent paper [DRIVE: A Digital Network Oracle for Cooperative Intelligent Transportation Systems](https://github.com/ioannismavromatis/smarterSimulator/blob/master/doc/publicationDRIVE.pdf).
```    
@inproceedings{driveSimulator
    author={{Mavromatis}, I. and {Piechocki}, R. and {Sooriyabandara}, M. and {Parekh}, A.},
    booktitle={Proc. of IEEE Symposium on Computers and Communications (ISCC)},
    title={{DRIVE: A Digital Network Oracle for Cooperative Intelligent Transportation Systems}},
    year={2020},
    month={jul},
    address={Rennes, France},
}
```

DRIVE At-a-Glance
------------

DRIVE provides a flexible framework that users can develop, train and optimise Machine Learning-based C-ITS solutions with minimal overhead. It can also be used for more traditional communication-related investigation, within large-scale vehicular communication scenarios.

DRIVE leverages from real-world maps, downloaded from [OpenStreetMap](https://www.openstreetmap.org/), and a bidirectional connection with [SUMO traffic generator](https://www.dlr.de/ts/en/desktopdefault.aspx/tabid-9883/16931_read-41000/) via [Traffic Control Interface (TraCI)](https://sumo.dlr.de/wiki/TraCI). It can simulate realistic city-scale 3D scenarios, and the communication interactions between vehicles, pedestrians and the infrastructure network. In alignment with SUMO mobility traces, indoor users are introduced, contributing to the overall network load. Our framework is designed to tackle shortcomings of traditional vehicular network simulators, and dynamically interact with Intelligent Agents, sharing the _“state of the world”_ and applying decision policies. 

The framework is designed in a highly parallelized and vertorized fashion. Intelligently manipulating the buildings, roads and foliage polygons, it can minimize the execution time. Being developed in MATLAB, it can be easily linked with existing optimization and Machine-learning toolboxes provided by MathWorks, as well as external libraries from different programming languages (e.g., this [link](https://uk.mathworks.com/products/matlab/matlab-and-python.html) describes how Python libraries can be called from within MATLAB).

DRIVE In-detail
------------

More details about DRIVE simulation framework capabilities can be found in:

* Our recent publication [DRIVE: A Digital Network Oracle for Cooperative Intelligent Transportation Systems](https://github.com/ioannismavromatis/smarterSimulator/blob/master/doc/publicationDRIVE.pdf).
* The [User Manual](https://github.com/ioannismavromatis/smarterSimulator/blob/master/doc/userManualDRIVE.pdf) accompanying the framework.


This repository contains:
------------

* DRIVE code.
* DRIVE [Licence](https://github.com/ioannismavromatis/smarterSimulator/blob/master/LICENSE).
* DRIVE [User Manual](https://github.com/ioannismavromatis/smarterSimulator/blob/master/doc/userManualDRIVE.pdf).
* **Three example use-cases**, demonstrating the different functionalities of DRIVE:
    * A scenario based on just an OSM map, simulating indoor traffic and a macro-cell communication plane that calculates the average datarate for the given technology.
    * A scenario with both indoor traffic and SUMO mobility traces, that changes the configuration of the given communication planes based on the user density.
	* A scenario that calculates the number of established links between vehicles and pedestrians, in a Vehicle-to-Vehicle and Pedestrian-to-Pedestrian fashion.
* **Three example maps and mobility traces**, provided as the default DRIVE scenarios: 
    * **City of Manhattan**: ~9km<sup>2</sup> of buildings, foliage and roads, with vehicular (2 different types of vehicles) and pedestrian mobility traces generated.
    * **City of London**: ~4km<sup>2</sup> of buildings, foliage and roads, with vehicular (2 types of vehicles) mobility traces generated.
    * **Smart Junction**: An artificially generated cross-junction (one lane per road), and with the corresponding vehicular (2 types of vehicles) mobility traces generated. 

Useful Links
------------

* OpenStreetMap [Website](https://www.openstreetmap.org/) and [map exporting online tool](https://www.openstreetmap.org/export).
* SUMO Traffic Generator: [User Documentation](https://sumo.dlr.de/wiki/SUMO_User_Documentation) and [download links/installation instructions](https://sumo.dlr.de/docs/Installing.html).
* TraCI4Matlab [link](https://github.com/pipeacosta/traci4matlab) and [installation instructions](https://github.com/pipeacosta/traci4matlab/blob/master/user_manual.pdf).
