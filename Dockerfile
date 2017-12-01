FROM bitriseio/docker-bitrise-base:latest

ENV ANDROID_HOME /opt/android-sdk-linux

RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  openjdk-8-jdk libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386
                                                                              
ENV VERSION_BUILD_TOOLS "27.0.1"
ENV VERSION_TARGET_SDK "27"
ENV SDK_PACKAGES '"build-tools;${VERSION_BUILD_TOOLS}" "platforms;android-${VERSION_TARGET_SDK}" "add-ons;addon-google_apis-google-${VERSION_TARGET_SDK}" "platform-tools" "extras:extra-android-m2repository" "extras;android;m2repository" "extras;google;google_play_services" "extras:google;m2repository"' 

#ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME
#RUN cd /opt && wget -q https://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip -O android-sdk-tools.zip

RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p $ANDROID_HOME/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license

#RUN yes | sdkmanager --licenses

#RUN mkdir -p "$ANDROID_HOME/licenses"
#RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
#RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"
#RUN echo -e "\nd975f751698a77b662f1254ddbeed3901e976f5a" > "$ANDROID_HOME/licenses/intel-android-extra-license"
#RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${VERSION_BUILD_TOOLS}" "platforms;android-26" "add-ons;addon-google_apis-google-24" "platform-tools" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"


RUN apt-get clean

