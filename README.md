# SMARTER: Simulation Framework for City-Scale Experimentation

SMARTER is an open-source framework for experimenting with large-scale heterogeneous communication scenarios. It is designed to be easily configurable and able to reduce the computational complexity of the existing simulation frameworks, still providing a very realistic representation of the real-world.

A detailed description about the capabilities of SMARTER simulation framework, as well information about how to use it can be found in the [User Manual](https://github.com/ioannismavromatis/smarterSimulator/blob/master/userManualSMARTER.pdf) provided by this repository.

## SMARTER At-a-Glance

SMARTER is capable of using real-world maps downloaded from [OpenStreetMap](https://www.openstreetmap.org/), manipulating the buildings and foliage in such a way that the execution time is minimised, without though losing from the realism provided from traditional simulation frameworks. On top of that, it provides a bidirectional connection with [SUMO traffic generator](https://www.dlr.de/ts/en/desktopdefault.aspx/tabid-9883/16931_read-41000/), via [Traffic Control Interface (TraCI)](https://sumo.dlr.de/wiki/TraCI) in a server-client fashion. By that, vehicles and pedestrian mobility traces can be generated and utilised for experimentation with mobile nodes. In alignment with the SUMO mobility traces, indoor user traffic introduced per building block that contributes to the overall network load.

SMARTER can be used for investigating different communication-related problems, such as optimising the basestation placement and switch-on-switch-off approaches on the deployed basestations, heterogeneous resource allocation techniques, efficient content dissemination and fetching, quality-of-service centric optimisation as perceived from the system-level perspective, etc. All the above problems can be tackled from both the indoor user, as well as the Vehicle-to-Everything (V2X) perspective.

The framework is designed in such a way to be highly parallelised and vectorised. Therefore, the execution time is minimised making it a great tool for developing AI- and Machine Learning algorithms for the above-mentioned problems. Of course, traditional optimisation algorithms can be used in a similar fashion. This framework, being designed in MATLAB, can be very easily linked with the existing optimisation and Machine-learning toolboxes provided by MathWorks. However, the MATLAB implementation does not limit the end-user to use machine-learning algorithms on different programming languages as well. For example, [this link](https://uk.mathworks.com/products/matlab/matlab-and-python.html) describes how Python libraries can be called from within MATLAB.

## This repository contains:

* SMARTER code.
* SMARTER [Licence](https://github.com/ioannismavromatis/smarterSimulator/blob/master/LICENSE).
* SMARTER [User Manual](https://github.com/ioannismavromatis/smarterSimulator/blob/master/userManualSMARTER.pdf).
* Three example use-cases, demonstrating the different functionalities of SMARTER:
    * A scenario based on just an OSM map, simulating indoor traffic and a macro-cell communication plane that calculates the average datarate for the given technology.
    * A scenario with both indoor traffic and SUMO mobility traces, that changes the configuration of the given communication planes based on the user density.
	* A scenario that calculates the number of established links between vehicles and pedestrians, in a Vehicle-to-Vehicle and Pedestrian-to-Pedestrian fashion.
* Two example maps extracted from [OpenStreetMap](https://www.openstreetmap.org/), with their corresponding mobility traces, generated using [SUMO traffic generator](https://www.dlr.de/ts/en/desktopdefault.aspx/tabid-9883/16931_read-41000/).
    * Manhattan -- ~9km<sup>2</sup> of buildings, foliage and roads, with vehicular (2 different types of vehicles) and pedestrian mobility traces generated.
    * London -- ~4km<sup>2</sup> of buildings, foliage and roads, with vehicular (2 types of vehicles) mobility traces generated.

## Useful Links

* OpenStreetMap [Website](https://www.openstreetmap.org/) and [map exporting online tool](https://www.openstreetmap.org/export).
* SUMO Traffic Generator: [User Documentation](https://sumo.dlr.de/wiki/SUMO_User_Documentation) and [download links/installation instructions](https://sumo.dlr.de/userdoc/Downloads.html).
* TraCI4Matlab [link](https://www.mathworks.com/matlabcentral/fileexchange/44805-traci4matlab) and [installation instructions](https://usermanual.wiki/Pdf/usermanual.2041518461.pdf).
