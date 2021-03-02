FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
#RUN bundle config --global frozen 1

RUN apt-get -y update && apt-get dist-upgrade -y && apt-get install -y nodejs npm && npm install npm@latest -g

ARG ARG_WORKDIR
ARG BA_GID
ARG BA_UID
ARG BA_USER_GROUP_NAME
ARG BA_USER_NAME



RUN groupadd -f -g ${BA_GID:-$BA_UID} ${BA_USER_GROUP_NAME:-$BA_USER_NAME} \
    && useradd -ms /bin/bash $BA_USER_NAME -d $ARG_WORKDIR -u $BA_UID -g ${BA_GID:-$BA_UID} \
    && passwd -d $BA_USER_NAME 
    #\
    #&& echo "$BA_ANDROID_DK_USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${BA_USER_NAME}
WORKDIR ${ARG_WORKDIR}
COPY . .
#USER root
RUN bundle install
#USER ${BA_USER_NAME}
RUN npm install

ENV WORKDIR=${ARG_WORKDIR}
ENV PATH=${WORKDIR}/bin:${WORKDIR}/node_modules/.bin:${PATH}
ENV NODE_PATH=${WORKDIR}/node_modules:${NODE_PATH}

#CMD ["bundle", "exec", "rspec", "spec/compare_spec.rb"]
CMD ["./bin/bootloop.sh"]