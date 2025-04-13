ARG VER=3.20.3
ARG KUBE_LINT_VER=0.6.8
FROM alpine:${VER}
COPY ash.rc /usr/bin/

RUN apk update && apk upgrade && apk add --no-cache nano neovim sudo wget curl python3 py3-pip mysql-client git \
    openssh-client-default nfs-utils go sshpass tree bash shadow procps bind-tools util-linux coreutils \
    binutils findutils grep libcap jq yq zip unzip fuse shellcheck && passwd -dl root && \

    # install s3fs-fuse
    apk add s3fs-fuse --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted && \
    apk add mailcap --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted && \
    echo 'user_allow_other' >> /etc/fuse.conf && \

    # install JuiceFS Client
    curl -sSL https://d.juicefs.com/install | sh -

    # install hadolint
RUN wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -O /usr/bin/hadolint && \
    chmod +x /usr/bin/hadolint && \

    # install kube-linter
    curl -sSL https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINT_VER}/kube-linter-linux -o /usr/bin/kube-linter && \
    chmod +x /usr/bin/kube-linter && \

    # install mc
    curl -sSL https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/bin/mc && \
    chmod +x /usr/bin/mc


ENV ENV=/usr/bin/ash.rc

#CMD ["/bin/ash"]
CMD ["/bin/sleep","infinity"]
