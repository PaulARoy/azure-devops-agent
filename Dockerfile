FROM ubuntu:20.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

ENV DEBIAN_FRONTEND=noninteractive \
    METADATA_FILE=/image/metadata.txt \
    HELPER_SCRIPTS=/scripts/helpers

ENV AGENT_TOOLSDIRECTORY=/_work/_tool

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes && \
    mkdir /image && \ 
    mkdir agent && \
    touch /image/metadata.txt

COPY scripts /scripts

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

RUN /scripts/base/preparemetadata.sh && \
    /scripts/installers/basic.sh && \
    /scripts/base/repos.sh && \
    /scripts/helpers/apt.sh && \
    /scripts/installers/7-zip.sh

RUN /scripts/installers/azcopy.sh && \
    /scripts/installers/build-essential.sh && \
    /scripts/installers/azure-cli.sh && \
    /scripts/installers/azure-devops-cli.sh

# Uncomment to Install C
#RUN /scripts/installers/clang/clang.sh && \
#    /scripts/installers/clang/cmake.sh && \
#    /scripts/installers/clang/gcc.sh

# Install Docker
RUN /scripts/installers/docker/docker-compose.sh && \
    /scripts/installers/docker/docker-moby.sh && \
    /scripts/installers/docker/kubernetes-tools.sh

# Install .NET Core
RUN /scripts/installers/dotnet/mspackages.sh && \
    /scripts/installers/dotnet/dotnetcore-sdk.sh && \
    /scripts/installers/dotnet/powershellcore.sh && \
    /scripts/installers/dotnet/azpowershell.sh

# Uncomment to Install Python
#RUN /scripts/installers/python/python-build-essentials.sh && \
#    /scripts/installers/python/python.sh && \
#    /scripts/installers/python/python_from_source.sh "3.6.10" && \
#    /scripts/installers/python/python_from_source.sh "3.7.3" && \
#    /scripts/installers/python/python_from_source.sh "3.7.6" && \
#    /scripts/installers/python/python_from_source.sh "3.8.1" && \
#    /scripts/installers/python/python_from_source.sh "3.9.0"

# Install Nodejs
RUN /scripts/installers/nodejs/nodejs.sh

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]