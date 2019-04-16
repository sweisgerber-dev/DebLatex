# ===========================================================================================
#
# Dockerfile for compiling latex documents
#
# ===========================================================================================
FROM debian:buster-slim

MAINTAINER Sebastian Weisgerber <sweisgerber.dev@gmail.com>

ENV GOSU_VERSION=1.10

ENV USER=latex
ENV USER=latex
ENV USER_ID_DEFAULT=1000
ENV GROUP_ID_DEFAULT=1000

ENV WORKDIR=/workspace

# See https://github.com/docker/docker/issues/4032
#RUN apk add --no-cache \
#    texlive-full
# --repository http://dl-cdn.alpinelinux.org/alpine/edge/community
#RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
#    gosu

# Install dependencies first texlive, it takes forever
RUN apt-get update && \
    apt-get install -y \
    texlive-bibtex-extra \
    texlive-full \
    texlive-lang-english \
    texlive-lang-german \
    texlive-latex-extra \
&& rm -rf /var/lib/apt/lists/*

# Remaining dependencies
RUN apt-get update && \
    apt-get install -y \
    biber \
    fonts-freefont-otf \
    gosu \
    make \
    python-pygments \
    rubber \
&& rm -rf /var/lib/apt/lists/*

# Create a non-root user that will perform the actual build
# RUN id ${USER} 2>/dev/null || addgroup -S latex && adduser -S latex -G latex useradd --uid ${USER_ID_DEFAULT} --create-home --shell /bin/bash ${USER}
# Create a non-root user that will perform the actual build
RUN id ${USER} 2>/dev/null || useradd --uid ${USER_ID_DEFAULT} --create-home --shell /bin/bash ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN mkdir -p ${WORKDIR}; \
    chown ${USER}:${USER} ${WORKDIR};

COPY config/.bashrc /home/${USER}/.bashrc
RUN chown ${USER}:${USER} /home/${USER}/.bashrc

COPY config/entrypoint.sh /usr/local/bin/entrypoint.sh

# EXPOSE ###############################################################################################################
VOLUME ["/workspace"]
WORKDIR ${WORKDIR}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
