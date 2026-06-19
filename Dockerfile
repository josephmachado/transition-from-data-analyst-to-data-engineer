FROM python:3.14-bookworm

WORKDIR /usr/src/app 

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    openjdk-17-jdk \
    wget \
    make \
    procps \
    gcc \
    g++ \
    cmake \
    pkg-config \
    libssl-dev \
    libzstd-dev \
    libffi-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s $(ls -d /usr/lib/jvm/java-17-openjdk-* | grep -v current | head -1) \
    /usr/lib/jvm/java-17-openjdk-current

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-current

ENV PATH=$JAVA_HOME/bin:$PATH

# Install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"


# Copy code and settings
COPY . .

# Install modules
RUN uv sync

COPY ./ipython_scripts/startup/ /root/.ipython/profile_default/startup/
COPY ./ipython_scripts/overrides.json /usr/src/app/.venv/share/jupyter/lab/settings/overrides.json

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
