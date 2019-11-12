# Example host distro
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget unzip gcc

RUN wget https://github.com/DomBennett/om..pathd8/raw/master/PATHd8.zip && \
    unzip PATHd8.zip

# Compile
RUN cc PATHd8.c -O3 -lm -o PATHd8

# Move
RUN mv PATHd8 bin/

# Clean
RUN rm PATHd8.c PATHd8.zip
RUN rm -r headers

# outsider *requires* working_dir
RUN mkdir /working_dir
WORKDIR /working_dir
