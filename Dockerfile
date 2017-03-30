#FROM bitriseio/docker-android:latest
FROM bitriseio/docker-bitrise-base:latest
ENV ANDROID_HOME /opt/android-sdk-linux
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386
ENV VERSION_SDK_TOOLS "25.2.5"
ENV VERSION_BUILD_TOOLS "25.0.2"
ENV VERSION_TARGET_SDK "25"
ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"
# ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-support,extra-android-m2repository,extra-google-google_play_services"
# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME
RUN cd /opt && wget -q https://dl.google.com/android/repository/tools_r25.2.5-linux.zip -O android-sdk-tools.zip
RUN cd /opt && unzip -q android-sdk-tools.zip
RUN mkdir -p ${ANDROID_HOME}
RUN cd /opt && mv tools/ ${ANDROID_HOME}/tools/
RUN cd /opt && rm -f android-sdk-tools.zip
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
# SDKs
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
# build tools
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2 | grep 'package installed'
# Android System Images, for emulators
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-24 | grep 'package installed'
# Extras
#RUN echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter extra-google-google_play_services | grep 'package installed'
# google apis
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter addon-google_apis-google-25 | grep 'package installed'
RUN mkdir -p "$ANDROID_HOME/licenses"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"
RUN echo -e "\nd975f751698a77b662f1254ddbeed3901e976f5a" > "$ANDROID_HOME/licenses/intel-android-extra-license"
RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}
# RVM & Ruby needed for fastlane below

#RUN \curl -L https://get.rvm.io | bash -s stable
#RUN /bin/bash -l -c "rvm requirements"
#RUN /bin/bash -l -c "rvm install 2.4"
#RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
# Fast lane for easy apk upload to hockey app
#RUN /bin/bash -l -c "gem install fastlane --no-document"
#RUN /bin/bash -l -c "gem install fastlane --no-rdoc --no-ri"
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

