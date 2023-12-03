FROM ubuntu

#Install Google CLI
RUN apt-get -y update && \
apt-get -y install gcc python2.7 python2-dev python3-pip wget ca-certificates software-properties-common curl apt-transport-https gettext-base openjdk-8-jre-headless jq

#Install YQ
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod a+x /usr/local/bin/yq

# Install Git >2.0.1
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get -y update 
RUN apt-get -y install git

#Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt update
RUN apt install terraform

# Setup Google Cloud SDK (latest)
RUN mkdir -p /usr/local/gcloud
RUN wget -qO- https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-392.0.0-linux-x86_64.tar.gz | tar zxv -C /usr/local/gcloud
RUN /usr/local/gcloud/google-cloud-sdk/install.sh --usage-reporting=false --rc-path /root/.bashrc --command-completion =true --path-update=true --quiet
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# install crcmod: https://cloud.google.com/storage/docs/gsutil/addlhelp/CRC32CandInstallingcrcmod
RUN pip install -U crcmod
RUN pip3 install -U crcmod

# Clean up
RUN apt-get -y remove gcc python-dev wget python-pip python3-pip
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf ~/.config/gcloud

# Install Helm latest
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt update
RUN apt -y install helm

# Install kubectl with the Google CLI Tools
RUN /usr/local/gcloud/google-cloud-sdk/bin/gcloud components install kubectl

# Install Docker engine latest 
RUN curl https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | tee /usr/share/keyrings/docker.gpg > /dev/null
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt update && apt install -y docker-ce docker-ce-cli
RUN apt install -y docker-ce docker-ce-cli containerd.io 

# Install Podman, includes Buildah
RUN apt -y install podman

# Cleanup aptitude
RUN apt -y autoremove