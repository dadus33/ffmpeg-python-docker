FROM python:3.7

# Change default shell to bash
SHELL ["/bin/bash", "-c"]

# Download and unpack the prebuilt binaries for 4.1.4
RUN wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.1.4-amd64-static.tar.xz
RUN tar -xf ffmpeg-4.1.4-amd64-static.tar.xz

# CD inside the extracted directory to move all files to their required locations
WORKDIR ffmpeg-4.1.4-amd64-static

# Move binaries to the bin directory
RUN mv ffmpeg /usr/local/bin/
RUN mv ffprobe /usr/local/bin/

# Rename manpages to their appropriate section (1) and move them to the man directory
RUN for file in manpages/*.txt; do mv "$file" "${file/.txt/.1}"; done
RUN mv manpages/*.1 /usr/local/man/man1/

# Ensure man is installed
RUN apt-get update -y && apt-get install -y man

#CD back to root
WORKDIR /

# Cleanup
RUN rm -rf ffmpeg-4.1.4-amd64-static*

# Set the original shell back
SHELL ["bin/sh", "-c"]

# Override python entrypoint
ENTRYPOINT ["bin/bash"]
