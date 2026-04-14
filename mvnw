#!/bin/sh
# ----------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Apache Maven Wrapper startup script, version 3.3.2
#
# Required ENV vars:
# ------------------
#   JAVA_HOME - location of a JDK home dir
#
# Optional ENV vars
# -----------------
#   MAVEN_OPTS - parameters passed to the Java VM when running Maven
#     e.g. to debug Maven itself, use
#       set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000
#   MAVEN_SKIP_RC - flag to disable loading of mavenrc files
# ----------------------------------------------------------------------------

if [ -z "$MAVEN_SKIP_RC" ] ; then

  if [ -f /usr/local/etc/mavenrc ] ; then
    . /usr/local/etc/mavenrc
  fi

  if [ -f /etc/mavenrc ] ; then
    . /etc/mavenrc
  fi

  if [ -f "$HOME/.mavenrc" ] ; then
    . "$HOME/.mavenrc"
  fi

fi

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
mingw=false
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  MINGW*) mingw=true;;
  Darwin*) darwin=true
    # Use /usr/libexec/java_home if available, otherwise fall through
    # see https://developer.apple.com/library/mac/qa/qa1170/_index.html
    if [ -z "$JAVA_HOME" ]; then
      if [ -x "/usr/libexec/java_home" ]; then
        JAVA_HOME="`/usr/libexec/java_home`"; export JAVA_HOME
      fi
    fi
    ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] &&
    JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] &&
    CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# For Mingw, ensure paths are in UNIX format before anything is touched
if $mingw ; then
  [ -n "$JAVA_HOME" ] &&
    JAVA_HOME="`(cd "$JAVA_HOME"; pwd)`"
fi

if [ -z "$JAVA_HOME" ]; then
  javaExecutable="`which javaw`"
  if [ -z "$javaExecutable" ] || [ "`expr \"$javaExecutable\" : '\([^ ]*\)'`" = "javaw" ]; then
    javaExecutable="`which java`"
  fi
  if [ -n "$javaExecutable" ] && ! [ "`expr \"$javaExecutable\" : '\([^ ]*\)'`" = "java" ]; then
    # readlink(1) is not available as standard on Solaris 10.
    readLink=`which readlink`
    if [ ! `expr "$readLink" : '\([^ ]*\)'` = "readlink" ]; then
      readLink="readlink -f"
    fi
    javaHome="`dirname \"$($readLink \"$javaExecutable\")\"`"
    javaExecutable="$javaHome/../bin/java"
    javaHome="`dirname \"$($readLink \"$javaExecutable\")\"` "
    JAVA_HOME="`cd \"$javaHome/..\"; pwd`"
    export JAVA_HOME
  fi
fi

if [ -z "$JAVA_HOME" ] ; then
  echo "Warning: JAVA_HOME environment variable is not set."
fi

# traverses directory structure from process work directory to filesystem root,
# looking for the specified file.  Returns the absolute path of the directory
# where the file was found, or exit code 1 if not found.
find_maven_basedir() {
    if [ -z "$1" ]
    then
        echo "Path not specified to find_maven_basedir"
        return 1
    fi

    basedir="$1"
    wdir="$1"
    while [ "$wdir" != '/' ] ; do
        if [ -d "$wdir"/.mvn ] ; then
            basedir=$wdir
            break
        fi
        # workaround for JBEAP-8937 (on Solaris 10/Sparc)
        if [ -d "${wdir}" ]; then
            wdir=`cd "$wdir/.."; pwd`
        fi
        # end JBEAP-8937
    done
    printf '%s' "$(cd "$basedir"; pwd)"
}

# concatenates all lines of a file
concat_lines() {
    if [ -f "$1" ]; then
        echo "$(tr -s '\n' ' ' < "$1")"
    fi
}

log() {
    if [ "$MVNW_VERBOSE" = true ]; then
        printf '%s\n' "$1"
    fi
}

BASE_DIR=$(find_maven_basedir "$(dirname $0)")
if [ -z "$BASE_DIR" ]; then
    exit 1;
fi

##########################################################################################
# Extension to allow automatically downloading the maven-wrapper.jar from Maven-central
# This allows using the maven wrapper in projects that prohibit checking in binary data.
##########################################################################################
wrapperJarPath="$BASE_DIR/.mvn/wrapper/maven-wrapper.jar"
if [ -r "$wrapperJarPath" ]; then
    log "Found $wrapperJarPath"
else
    log "Couldn't find $wrapperJarPath, downloading it ..."

    if [ -n "$MVNW_REPOURL" ]; then
        wrapperUrl="$MVNW_REPOURL/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar"
    else
        wrapperUrl="https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar"
    fi
    while IFS="=" read key value; do
        case "$key" in (wrapperUrl) wrapperUrl="$value"; break ;;
        esac
    done < "$BASE_DIR/.mvn/wrapper/maven-wrapper.properties"
    log "Downloading from: $wrapperUrl"

    if $cygwin; then
        wrapperJarPath=`cygpath --path --windows "$wrapperJarPath"`
    fi

    if command -v wget > /dev/null; then
        log "Found wget ... using wget"
        [ "$MVNW_VERBOSE" = true ] && QUIET="" || QUIET="--quiet"
        if [ -z "$MVNW_USERNAME" ] || [ -z "$MVNW_PASSWORD" ]; then
            wget $QUIET "$wrapperUrl" -O "$wrapperJarPath" || rm -f "$wrapperJarPath"
        else
            wget $QUIET --http-user="$MVNW_USERNAME" --http-password="$MVNW_PASSWORD" "$wrapperUrl" -O "$wrapperJarPath" || rm -f "$wrapperJarPath"
        fi
    elif command -v curl > /dev/null; then
        log "Found curl ... using curl"
        [ "$MVNW_VERBOSE" = true ] && QUIET="" || QUIET="--silent"
        if [ -z "$MVNW_USERNAME" ] || [ -z "$MVNW_PASSWORD" ]; then
            curl $QUIET -o "$wrapperJarPath" "$wrapperUrl" -f -L || rm -f "$wrapperJarPath"
        else
            curl $QUIET --user "$MVNW_USERNAME:$MVNW_PASSWORD" -o "$wrapperJarPath" "$wrapperUrl" -f -L || rm -f "$wrapperJarPath"
        fi
    else
        log "Falling back to using Java to download"
        javaSource="$BASE_DIR/.mvn/wrapper/MavenWrapperDownloader.java"
        javaClass="$BASE_DIR/.mvn/wrapper/MavenWrapperDownloader"
        if [ -e "$javaSource" ]; then
            if [ ! -e "$javaClass.class" ]; then
                log " - Compiling MavenWrapperDownloader.java ..."
                ("$JAVA_HOME/bin/javac" "$javaSource")
            fi
            log " - Running MavenWrapperDownloader.java ..."
            ("$JAVA_HOME/bin/java" -cp .mvn/wrapper MavenWrapperDownloader "$wrapperUrl" "$wrapperJarPath") || rm -f "$wrapperJarPath"
        fi
    fi
fi
##########################################################################################
# End of extension
##########################################################################################

# If specified, validate the SHA-256 sum of the Maven wrapper jar file
wrapperSha256Sum=""
while IFS="=" read key value; do
    case "$key" in (wrapperSha256Sum) wrapperSha256Sum=$value; break ;;
    esac
done < "$BASE_DIR/.mvn/wrapper/maven-wrapper.properties"
if [ -n "$wrapperSha256Sum" ]; then
    wrapperSha256Result=false
    if command -v sha256sum > /dev/null; then
        if echo "$wrapperSha256Sum  $wrapperJarPath" | sha256sum -c > /dev/null 2>&1; then
            wrapperSha256Result=true
        fi
    elif command -v shasum > /dev/null; then
        if echo "$wrapperSha256Sum  $wrapperJarPath" | shasum -a 256 -c > /dev/null 2>&1; then
            wrapperSha256Result=true
        fi
    else
        echo "Checksum validation was requested but neither 'sha256sum' nor 'shasum' are available."
        echo "Please install either command, or disable validation by removing 'wrapperSha256Sum' from your maven-wrapper.properties."
        exit 1
    fi
    if [ $wrapperSha256Result = false ]; then
        echo "Error: Failed to validate Maven wrapper SHA-256, your Maven wrapper installation is corrupt. To fix that you can remove"
        echo "your Maven wrapper installation by running 'rm -rf ~/.m2/wrapper/dists/apache-maven-3.9.9-bin' and then run your mvnw command again."
        exit 1
    fi
fi

MAVEN_OPTS="$(concat_lines "$BASE_DIR/.mvn/jvm.config") $MAVEN_OPTS"

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    [ -n "$JAVA_HOME" ] &&
        JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    [ -n "$CLASSPATH" ] &&
        CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
    [ -n "$PROJECTS_HOME" ] &&
        PROJECTS_HOME=`cygpath --path --windows "$PROJECTS_HOME"`
fi

WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

exec "$JAVA_HOME/bin/java" \
  $MAVEN_OPTS \
  $MAVEN_DEBUG_OPTS \
  -classpath "$BASE_DIR/.mvn/wrapper/maven-wrapper.jar" \
  "-Dmaven.multiModuleProjectDirectory=${BASE_DIR}" \
  ${WRAPPER_LAUNCHER} "$@"
