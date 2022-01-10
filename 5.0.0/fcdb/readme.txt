# To create image, run following command

docker build --build-arg MDM_VERSION=9.1.0 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 -t fcdb:5.0.0 --rm=true .

# to run this images, following command can be used. 

docker run -d --name=fcdb5.0.0 -e POSTGRES_PASSWORD=postgres -p 5432:5432 fcdb:5.0.0