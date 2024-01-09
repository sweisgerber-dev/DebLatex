# ===========================================================================================
#
# Dockerfile for compiling latex documents
#
# ===========================================================================================
FROM debian:bookworm-slim

LABEL org.opencontainers.image.authors="it@cǐspa.de"

ENV USER=latex
ENV USER_ID_DEFAULT=1000
ENV GROUP_ID_DEFAULT=1000

ENV WORKDIR=/workspace

#
# Include custom files in the image
#
COPY config/.bashrc /home/${USER}/.bashrc
COPY config/entrypoint.sh /usr/local/bin/entrypoint.sh

# 1. Install dependencies
# 2. Create a non-root user that will perform the actual build
RUN  set -ex \
  echo "**** Installing Packages ****" \
  && apt-get update \
  && apt-get install -y \
    texlive-bibtex-extra \
    texlive-full \
    texlive-lang-english \
    texlive-lang-german \
    texlive-latex-extra \
    biber \
    fonts-freefont-otf \
    gosu \
    git \
    make \
    python3 \
    python3-pip \
    python3-pygments \
    python3-venv \
    rubber \
  && echo "**** user setup ****" \
  && id ${USER} 2>/dev/null || useradd --uid ${USER_ID_DEFAULT} --create-home --shell /bin/bash ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers \
  && echo "**** folder setup ****" \
  && mkdir -p ${WORKDIR} \
  && chown ${USER}:${USER} ${WORKDIR} \
  && chown ${USER}:${USER} /home/${USER}/.bashrc \
  && echo "**** cleanup ****" \
  && apt-get -y autoremove \
  && apt-get clean  \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /var/log/* \
    /usr/share/man

# EXPOSE ###############################################################################################################
VOLUME ["/workspace"]
WORKDIR ${WORKDIR}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
