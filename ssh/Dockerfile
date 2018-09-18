FROM corbinu/ssh-server:latest
ADD authorized_keys /root/.ssh/authorized_keys

RUN apt-get update && sudo apt-get install -y apt-transport-https curl gpgv bash-completion &&\
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
    touch /etc/apt/sources.list.d/kubernetes.list &&\
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list &&\
    apt-get update &&\
    apt-get install -y kubectl
RUN curl https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz -o helm.tgz &&\
    tar -zxf helm.tgz &&\
    chmod +x linux-amd64/helm &&\
    mv linux-amd64/helm /usr/local/bin/
RUN echo 'source <(kubectl completion bash)' >> .bashrc &&\
    echo 'source <(helm completion bash)' >> .bashrc 
