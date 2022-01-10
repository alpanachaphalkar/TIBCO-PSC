#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#How to Build the OPD docker image  :

docker build -t fcopd:5.0.0 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --rm=true .

#How to Run the FC docker image locally  :
docker run -p 8070:8070 imagename

