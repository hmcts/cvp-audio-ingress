#cloud-config
apt_sources:
  - source: "deb [arch=amd64 trusted=yes] https://packages.microsoft.com/ubuntu/18.04/prod bionic main"
package_upgrade: true
packages:
  - blobfuse
  - fuse
write_files:
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/Server.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root version="2">
              <Server>
                      <Name>Wowza Streaming Engine</Name>
                      <Description>Wowza Streaming Engine is robust, customizable, and scalable server software that powers reliable streaming of high-quality video and audio to any device, anywhere.</Description>
                      <RESTInterface>
                              <Enable>true</Enable>
                              <IPAddress>*</IPAddress>
                              <Port>8087</Port>
                              <!-- none, basic, digest, remotehttp, digestfile -->
                              <AuthenticationMethod>digestfile</AuthenticationMethod>
                              <DiagnosticURLEnable>true</DiagnosticURLEnable>
                              <SSLConfig>
                                      <Enable>true</Enable>
                                      <KeyStorePath>/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks</KeyStorePath>
                                      <KeyStorePassword>${certPassword}</KeyStorePassword>
                                      <KeyStoreType>JKS</KeyStoreType>
                                      <SSLProtocol>TLS</SSLProtocol>
                                      <Algorithm>SunX509</Algorithm>
                                      <CipherSuites></CipherSuites>
                                      <Protocols>TLSv1.2</Protocols>
                              </SSLConfig>
                              <IPWhiteList>*</IPWhiteList>
                              <IPBlackList></IPBlackList>
                              <EnableXMLFile>false</EnableXMLFile>
                              <DocumentationServerEnable>false</DocumentationServerEnable>
                              <DocumentationServerPort>8089</DocumentationServerPort>
                              <!-- none, basic, digest, remotehttp, digestfile -->
                              <DocumentationServerAuthenticationMethod>digestfile</DocumentationServerAuthenticationMethod>
                              <Properties>
                              </Properties>
                      </RESTInterface>
                      <CommandInterface>
                              <HostPort>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>8083</Port>
                              </HostPort>
                      </CommandInterface>
                      <AdminInterface>
                              <!-- Objects exposed through JMX interface: Server, VHost, VHostItem, Application, ApplicationInstance, MediaCaster, Module, Client, MediaStream, SharedObject, Acceptor, IdleWorker -->
                              <ObjectList>Server,VHost,VHostItem,Application,ApplicationInstance,MediaCaster,Module,IdleWorker</ObjectList>
                      </AdminInterface>
                      <Stats>
                              <Enable>true</Enable>
                      </Stats>
                      <!-- JMXUrl: service:jmx:rmi://localhost:8084/jndi/rmi://localhost:8085/jmxrmi -->
                      <JMXRemoteConfiguration>
                              <Enable>false</Enable>
                              <IpAddress>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</IpAddress> <!--changed for default cloud install. <IpAddress>localhost</IpAddress>--> <!-- set to localhost or internal ip address if behind NAT -->
                              <RMIServerHostName>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</RMIServerHostName> <!--changed for default cloud install. <RMIServerHostName>localhost</RMIServerHostName>--> <!-- set to external ip address or domain name if behind NAT -->
                              <RMIConnectionPort>8084</RMIConnectionPort>
                              <RMIRegistryPort>8085</RMIRegistryPort>
                              <Authenticate>true</Authenticate>
                              <PasswordFile>$${com.wowza.wms.ConfigHome}/conf/jmxremote.password</PasswordFile>
                              <AccessFile>$${com.wowza.wms.ConfigHome}/conf/jmxremote.access</AccessFile>
                              <SSLSecure>false</SSLSecure>
                      </JMXRemoteConfiguration>
                      <UserAgents>Shockwave Flash|CFNetwork|MacNetwork/1.0 (Macintosh)</UserAgents>
                      <Streams>
                              <DefaultStreamPrefix>mp4</DefaultStreamPrefix>
                      </Streams>
                      <ServerListeners>
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.module.ServerListenerTranscoderPreload</BaseClass>
                              </ServerListener> <!--changed for default cloud install. -->
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.cloud.platform.env.ServerListenerVariables</BaseClass>
                              </ServerListener> <!--changed for default cloud install. -->
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.mediacache.impl.MediaCacheServerListener</BaseClass>
                              </ServerListener>
                              <!--
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerListener</BaseClass>
                              </ServerListener>
                              -->
                              <!--
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerSender</BaseClass>
                              </ServerListener>
                              -->
                      </ServerListeners>
                      <VHostListeners>
                              <!--
                              <VHostListener>
                                      <BaseClass></BaseClass>
                              </VHostListener>
                              -->
                      </VHostListeners>
                      <HandlerThreadPool>
                              <PoolSize>1024</PoolSize>
                      </HandlerThreadPool>
                      <TransportThreadPool>
                              <PoolSize>1024</PoolSize>
                      </TransportThreadPool>
                      <RTP>
                              <DatagramStartingPort>6970</DatagramStartingPort>
                              <DatagramPortSharing>false</DatagramPortSharing>
                      </RTP>
                      <Manager>
                              <!-- Properties defined are used by the Manager -->
                              <Properties>
                              </Properties>
                      </Manager>
                      <Transcoder>
                              <PluginPaths>
                                      <QuickSync></QuickSync>
                              </PluginPaths>
                      </Transcoder>
                      <!-- Properties defined here will be added to the IServer.getProperties() collection -->
                      <Properties>
                      </Properties>
              </Server>
      </Root>
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/Tune.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root>
            <Tune>
                <HeapSize>$${com.wowza.wms.TuningHeapSizeProduction}</HeapSize>
                <GarbageCollector>-XX:+UseConcMarkSweepGC -XX:NewSize=512m</GarbageCollector>
                <VMOptions>
                        <VMOption>-server</VMOption>
                        <VMOption>-Djava.net.preferIPv4Stack=true</VMOption>
                </VMOptions>
            </Tune>
      </Root>
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/VHost.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root version="2">
              <VHost>
                      <Description></Description>
                      <HostPortList>
                              <HostPort>
                                      <Name>Default SSL Streaming</Name>
                                      <Type>Streaming</Type>
                                      <ProcessorCount>256</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>443</Port>
                                      <HTTPIdent2Response></HTTPIdent2Response>
                                      <SSLConfig>
                                              <Enable>true</Enable>
                                              <KeyStorePath>/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks</KeyStorePath>
                                              <KeyStorePassword>${certPassword}</KeyStorePassword>
                                              <KeyStoreType>JKS</KeyStoreType>
                                              <DomainToKeyStoreMapPath></DomainToKeyStoreMapPath>
                                              <SSLProtocol>TLS</SSLProtocol>
                                              <Algorithm>SunX509</Algorithm>
                                              <CipherSuites></CipherSuites>
                                              <Protocols>TLSv1.2</Protocols>
                                      </SSLConfig>
                                      <SocketConfiguration>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>0</ReceiveBufferSize>
                                              <ReadBufferSize>65000</ReadBufferSize>
                                              <SendBufferSize>0</SendBufferSize>
                                              <KeepAlive>true</KeepAlive>
                                              <AcceptorBackLog>100</AcceptorBackLog>
                                      </SocketConfiguration>
                                      <HTTPStreamerAdapterIDs></HTTPStreamerAdapterIDs>
                                      <HTTPProviders>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPCrossdomain</BaseClass>
                                                      <RequestFilters>*crossdomain.xml</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPClientAccessPolicy</BaseClass>
                                                      <RequestFilters>*clientaccesspolicy.xml</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPProviderMediaList</BaseClass>
                                                      <RequestFilters>*jwplayer.rss|*jwplayer.smil|*medialist.smil|*manifest-rtmp.f4m</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                      </HTTPProviders>
                              </HostPort>
                              <HostPort>
                                      <Name>Default Admin</Name>
                                      <Type>Admin</Type>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>8086</Port>
                                      <HTTPIdent2Response></HTTPIdent2Response>
                                      <SocketConfiguration>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>16000</ReceiveBufferSize>
                                              <ReadBufferSize>16000</ReadBufferSize>
                                              <SendBufferSize>16000</SendBufferSize>
                                              <KeepAlive>true</KeepAlive>
                                              <AcceptorBackLog>100</AcceptorBackLog>
                                      </SocketConfiguration>
                                      <HTTPStreamerAdapterIDs></HTTPStreamerAdapterIDs>
                                      <HTTPProviders>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.streammanager.HTTPStreamManager</BaseClass>
                                                      <RequestFilters>streammanager*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPServerInfoXML</BaseClass>
                                                      <RequestFilters>serverinfo*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPConnectionInfo</BaseClass>
                                                      <RequestFilters>connectioninfo*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPConnectionCountsXML</BaseClass>
                                                      <RequestFilters>connectioncounts*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.transcoder.httpprovider.HTTPTranscoderThumbnail</BaseClass>
                                                      <RequestFilters>transcoderthumbnail*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPProviderMediaList</BaseClass>
                                                      <RequestFilters>medialist*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.livestreamrecord.http.HTTPLiveStreamRecord</BaseClass>
                                                      <RequestFilters>livestreamrecord*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                      </HTTPProviders>
                              </HostPort>
                      </HostPortList>
                      <HTTPStreamerAdapters>
                      </HTTPStreamerAdapters>
                      <!-- When set to zero, thread pool configuration is done in Server.xml -->
                      <HandlerThreadPool>
                              <PoolSize>0</PoolSize>
                      </HandlerThreadPool>
                      <TransportThreadPool>
                              <PoolSize>0</PoolSize>
                      </TransportThreadPool>
                      <IdleWorkers>
                              <WorkerCount>$${com.wowza.wms.TuningAuto}</WorkerCount>
                              <CheckFrequency>50</CheckFrequency>
                              <MinimumWaitTime>5</MinimumWaitTime>
                      </IdleWorkers>
                      <NetConnections>
                              <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              <IdleFrequency>250</IdleFrequency>
                              <SocketConfiguration>
                                      <ReuseAddress>true</ReuseAddress>
                                      <ReceiveBufferSize>0</ReceiveBufferSize>
                                      <ReadBufferSize>65000</ReadBufferSize>
                                      <SendBufferSize>0</SendBufferSize>
                                      <KeepAlive>true</KeepAlive>
                                      <!-- <TrafficClass>0</TrafficClass> -->
                                      <!-- <OobInline>false</OobInline> -->
                                      <!-- <SoLingerTime>-1</SoLingerTime> -->
                                      <!-- <TcpNoDelay>false</TcpNoDelay> -->
                                      <AcceptorBackLog>100</AcceptorBackLog>
                              </SocketConfiguration>
                      </NetConnections>
                      <MediaCasters>
                              <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              <SocketConfiguration>
                                      <ReuseAddress>true</ReuseAddress>
                                      <ReceiveBufferSize>65000</ReceiveBufferSize>
                                      <ReadBufferSize>65000</ReadBufferSize>
                                      <SendBufferSize>65000</SendBufferSize>
                                      <KeepAlive>true</KeepAlive>
                                      <!-- <TrafficClass>0</TrafficClass> -->
                                      <!-- <OobInline>false</OobInline> -->
                                      <!-- <SoLingerTime>-1</SoLingerTime> -->
                                      <!-- <TcpNoDelay>false</TcpNoDelay> -->
                                      <ConnectionTimeout>10000</ConnectionTimeout>
                              </SocketConfiguration>
                      </MediaCasters>
                      <LiveStreamTranscoders>
                              <MaximumConcurrentTranscodes>0</MaximumConcurrentTranscodes>
                      </LiveStreamTranscoders>
                      <HTTPTunnel>
                              <KeepAliveTimeout>2000</KeepAliveTimeout>
                      </HTTPTunnel>
                      <Client>
                              <ClientTimeout>90000</ClientTimeout>
                              <IdleFrequency>250</IdleFrequency>
                      </Client>
                      <!-- RTP/Authentication/Methods defined in Authentication.xml. Default setup includes; none, basic, digest -->
                      <RTP>
                              <IdleFrequency>75</IdleFrequency>
                              <DatagramConfiguration>
                                      <Incoming>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>2048000</ReceiveBufferSize>
                                              <SendBufferSize>65000</SendBufferSize>
                                              <!-- <MulticastBindToAddress>true</MulticastBindToAddress> -->
                                              <!-- <MulticastInterfaceAddress>192.168.1.22</MulticastInterfaceAddress> -->
                                              <!-- <TrafficClass>0</TrafficClass> -->
                                              <MulticastTimeout>50</MulticastTimeout>
                                              <DatagramMaximumPacketSize>4096</DatagramMaximumPacketSize>
                                      </Incoming>
                                      <Outgoing>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>65000</ReceiveBufferSize>
                                              <SendBufferSize>256000</SendBufferSize>
                                              <!-- <MulticastBindToAddress>true</MulticastBindToAddress> -->
                                              <!-- <MulticastInterfaceAddress>192.168.1.22</MulticastInterfaceAddress> -->
                                              <!-- <TrafficClass>0</TrafficClass> -->
                                              <MulticastTimeout>50</MulticastTimeout>
                                              <DatagramMaximumPacketSize>4096</DatagramMaximumPacketSize>
                                              <SendIGMPJoinMsgOnPublish>false</SendIGMPJoinMsgOnPublish>
                                      </Outgoing>
                              </DatagramConfiguration>
                              <UnicastIncoming>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </UnicastIncoming>
                              <UnicastOutgoing>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </UnicastOutgoing>
                              <MulticastIncoming>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </MulticastIncoming>
                              <MulticastOutgoing>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </MulticastOutgoing>
                      </RTP>
                      <HTTPProvider>
                              <KeepAliveTimeout>2000</KeepAliveTimeout>
                              <KillConnectionTimeout>10000</KillConnectionTimeout>
                              <SlowConnectionBitrate>64000</SlowConnectionBitrate>
                              <IdleFrequency>250</IdleFrequency>
                      </HTTPProvider>
                      <WebSocket>
                              <MaximumMessageSize>512k</MaximumMessageSize>
                              <PacketFragmentationSize>0</PacketFragmentationSize>
                              <MaskOutgoingMessages>false</MaskOutgoingMessages>
                              <IdleFrequency>250</IdleFrequency>
                              <ValidationFrequency>20000</ValidationFrequency>
                              <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                              <PingTimeout>12000</PingTimeout>
                      </WebSocket>
                      <Application>
                              <ApplicationTimeout>60000</ApplicationTimeout>
                              <PingTimeout>12000</PingTimeout>
                              <UnidentifiedSessionTimeout>30000</UnidentifiedSessionTimeout>
                              <ValidationFrequency>20000</ValidationFrequency>
                              <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                              <MaximumSetBufferTime>60000</MaximumSetBufferTime>
                      </Application>
                      <StartStartupStreams>true</StartStartupStreams>
                      <Manager>
                              <TestPlayer>
                                      <IpAddress>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</IpAddress>
                                      <!--changed for default cloud install. <IpAddress>$${com.wowza.wms.HostPort.IpAddress}</IpAddress>-->
                                      <Port>$${com.wowza.wms.HostPort.FirstStreamingPort}</Port>
                                      <SSLEnable>$${com.wowza.wms.HostPort.SSLEnable}</SSLEnable>
                              </TestPlayer>
                              <!-- Properties defined are used by the Manager -->
                              <Properties>
                              </Properties>
                      </Manager>
                      <!-- Properties defined here will be added to the IVHost.getProperties() collection -->
                      <Properties>
                      </Properties>
              </VHost>
      </Root>
  - owner: root:root
    permissions: '770' 
    path: /etc/rc.local
    content: |
      #!/bin/sh -e
      #
      # rc.local
      #
      # This script is executed at the end of each multiuser runlevel.
      # Make sure that the script will "exit 0" on success or any other
      # value on error.
      #
      # In order to enable or disable this script just change the execution
      # bits.
      #
      # By default this script does nothing.

      sudo bash /home/wowza/mount.sh /usr/local/WowzaStreamingEngine/content/azurecopy

      exit 0
  - owner: wowza:wowza
    path: /home/wowza/mount.sh
    content: |
      #!/bin/bash

      ## Add BlobFuse
      blobfuse $1 --tmp-path=$2 -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --config-file=$3 -o allow_other -o nonempty

      ## Cron to check remounting
      cronTaskPath="/home/wowza/remount_$4.txt"
      sudo touch $cronTaskPath
      sudo chmod 777 $cronTaskPath
      echo "*/5 * * * * /home/wowza/remount.sh $1 $2 $3 $4 $5
      " > $cronTaskPath
      sudo -u wowza bash -c "crontab $cronTaskPath"
  - owner: wowza:wowza
    path: /home/wowza/remount.sh
    content: |
        mountDir="$5"
        logPath="/usr/local/WowzaStreamingEngine-${wowzaVersion}+1/azlogs/log-mount.log"
        dt=$(date '+%d/%m/%Y %H:%M:%S')

        context="failed"
        if grep -qs $mountDir ../../proc/mounts; then
         context="IS"
        else
          context="WAS NOT"
          echo "Remounting $mountDir"
          sudo /home/wowza/mount.sh $1 $2 $3 $4 $5
        fi
        echo "$dt :: drive $context mounted. :: $mountDir" >> $logPath

  - owner: wowza:wowza
    path: /home/wowza/connection.cfg
    content: |
      accountName ${storageAccountName}
      accountKey ${storageAccountKey}
      containerName ${containerName}
  - owner: wowza:wowza
    path: /home/wowza/connection-logs.cfg
    content: |
      accountName ${storageAccountName}
      accountKey ${storageAccountKey}
      containerName ${logsContainerName}
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/admin.password
    content: |
      # Admin password file (format [username][space][password])
      # username password group|group
      wowza ${restPassword} admin
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/publish.password
    content: |
      # Publish password file (format [username][space][password])
      # username password
      wowza ${streamPassword}
  - owner: wowza:wowza
    path: /home/wowza/Application.xml
    content: |
        <?xml version="1.0" encoding="UTF-8"?>
        <Root version="1">
                <Application>
                        <Name></Name>
                        <AppType>Live</AppType>
                        <Description></Description>
                        <!-- Uncomment to set application level timeout values
                        <ApplicationTimeout>60000</ApplicationTimeout>
                        <PingTimeout>12000</PingTimeout>
                        <ValidationFrequency>8000</ValidationFrequency>
                        <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                        <MaximumSetBufferTime>60000</MaximumSetBufferTime>
                        <MaximumStorageDirDepth>25</MaximumStorageDirDepth>
                        -->
                        <Connections>
                                <AutoAccept>true</AutoAccept>
                                <AllowDomains></AllowDomains>
                        </Connections>
                        <!--
                    StorageDir path variables

                    $${com.wowza.wms.AppHome} - Application home directory
                    $${com.wowza.wms.ConfigHome} - Configuration home directory
                    $${com.wowza.wms.context.VHost} - Virtual host name
                    $${com.wowza.wms.context.VHostConfigHome} - Virtual host config directory
                    $${com.wowza.wms.context.Application} - Application name
                    $${com.wowza.wms.context.ApplicationInstance} - Application instance name

                -->
                        <Streams>
                                <StreamType>live</StreamType>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/content/$${com.wowza.wms.context.Application}</StorageDir>
                                <KeyDir>$${com.wowza.wms.context.VHostConfigHome}/keys</KeyDir>
                                <!-- LiveStreamPacketizers (separate with commas): cupertinostreamingpacketizer, smoothstreamingpacketizer, sanjosestreamingpacketizer, mpegdashstreamingpacketizer, cupertinostreamingrepeater, smoothstreamingrepeater, sanjosestreamingrepeater, mpegdashstreamingrepeater, dvrstreamingpacketizer, dvrstreamingrepeater -->
                                <LiveStreamPacketizers></LiveStreamPacketizers>
                                <!-- Properties defined here will override any properties defined in conf/Streams.xml for any streams types loaded by this application -->
                                <Properties>
                                </Properties>
                        </Streams>
                        <Transcoder>
                                <!-- To turn on transcoder set to: transcoder -->
                                <LiveStreamTranscoder></LiveStreamTranscoder>
                                <!-- [templatename].xml or $${SourceStreamName}.xml -->
                                <Templates>$${SourceStreamName}.xml,transrate.xml</Templates>
                                <ProfileDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/profiles</ProfileDir>
                                <TemplateDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/templates</TemplateDir>
                                <Properties>
                                </Properties>
                        </Transcoder>
                        <DVR>
                                <!-- As a single server or as an origin, use dvrstreamingpacketizer in LiveStreamPacketizers above -->
                                <!-- Or, in an origin-edge configuration, edges use dvrstreamingrepeater in LiveStreamPacketizers above -->
                                <!-- As an origin, also add dvrchunkstreaming to HTTPStreamers below -->
                                <!-- If this is a dvrstreamingrepeater, define Application/Repeater/OriginURL to point back to the origin -->
                                <!-- To turn on DVR recording set Recorders to dvrrecorder.  This works with dvrstreamingpacketizer  -->
                                <Recorders></Recorders>
                                <!-- As a single server or as an origin, set the Store to dvrfilestorage-->
                                <!-- edges should have this empty -->
                                <Store></Store>
                                <!--  Window Duration is length of live DVR window in seconds.  0 means the window is never trimmed. -->
                                <WindowDuration>0</WindowDuration>
                                <!-- Storage Directory is top level location where dvr is stored.  e.g. c:/temp/dvr -->
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/dvr</StorageDir>
                                <!-- valid ArchiveStrategy values are append, version, delete -->
                                <ArchiveStrategy>append</ArchiveStrategy>
                                <!-- Properties for DVR -->
                                <Properties>
                                </Properties>
                        </DVR>
                        <TimedText>
                                <!-- VOD caption providers (separate with commas): vodcaptionprovidermp4_3gpp, vodcaptionproviderttml, vodcaptionproviderwebvtt,  vodcaptionprovidersrt, vodcaptionproviderscc -->
                                <VODTimedTextProviders></VODTimedTextProviders>
                                <!-- Properties for TimedText -->
                                <Properties>
                                </Properties>
                        </TimedText>
                        <MediaCache>
                                <MediaCacheSourceList></MediaCacheSourceList>
                        </MediaCache>
                        <SharedObjects>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/applications/$${com.wowza.wms.context.Application}/sharedobjects/$${com.wowza.wms.context.ApplicationInstance}</StorageDir>
                        </SharedObjects>
                        <Client>
                                <IdleFrequency>-1</IdleFrequency>
                                <Access>
                                        <StreamReadAccess>*</StreamReadAccess>
                                        <StreamWriteAccess>*</StreamWriteAccess>
                                        <StreamAudioSampleAccess></StreamAudioSampleAccess>
                                        <StreamVideoSampleAccess></StreamVideoSampleAccess>
                                        <SharedObjectReadAccess>*</SharedObjectReadAccess>
                                        <SharedObjectWriteAccess>*</SharedObjectWriteAccess>
                                </Access>
                        </Client>
                        <RTP>
                                <!-- RTP/Authentication/[type]Methods defined in Authentication.xml. Default setup includes; none, basic, digest -->
                                <Authentication>
                                        <PublishMethod>block</PublishMethod>
                                        <PlayMethod>none</PlayMethod>
                                </Authentication>
                                <!-- RTP/AVSyncMethod. Valid values are: senderreport, systemclock, rtptimecode -->
                                <AVSyncMethod>senderreport</AVSyncMethod>
                                <MaxRTCPWaitTime>0</MaxRTCPWaitTime>
                                <IdleFrequency>75</IdleFrequency>
                                <RTSPSessionTimeout>90000</RTSPSessionTimeout>
                                <RTSPMaximumPendingWriteBytes>0</RTSPMaximumPendingWriteBytes>
                                <RTSPBindIpAddress></RTSPBindIpAddress>
                                <RTSPConnectionIpAddress>0.0.0.0</RTSPConnectionIpAddress>
                                <RTSPOriginIpAddress>127.0.0.1</RTSPOriginIpAddress>
                                <IncomingDatagramPortRanges>*</IncomingDatagramPortRanges>
                                <!-- Properties defined here will override any properties defined in conf/RTP.xml for any depacketizers loaded by this application -->
                                <Properties>
                                </Properties>
                        </RTP>
                        <MediaCaster>
                                <RTP>
                                        <RTSP>
                                                <!-- udp, interleave -->
                                                <RTPTransportMode>interleave</RTPTransportMode>
                                        </RTSP>
                                </RTP>
                                <StreamValidator>
                                        <Enable>true</Enable>
                                        <ResetNameGroups>true</ResetNameGroups>
                                        <StreamStartTimeout>20000</StreamStartTimeout>
                                        <StreamTimeout>12000</StreamTimeout>
                                        <VideoStartTimeout>0</VideoStartTimeout>
                                        <VideoTimeout>0</VideoTimeout>
                                        <AudioStartTimeout>0</AudioStartTimeout>
                                        <AudioTimeout>0</AudioTimeout>
                                        <VideoTCToleranceEnable>false</VideoTCToleranceEnable>
                                        <VideoTCPosTolerance>3000</VideoTCPosTolerance>
                                        <VideoTCNegTolerance>-500</VideoTCNegTolerance>
                                        <AudioTCToleranceEnable>false</AudioTCToleranceEnable>
                                        <AudioTCPosTolerance>3000</AudioTCPosTolerance>
                                        <AudioTCNegTolerance>-500</AudioTCNegTolerance>
                                        <DataTCToleranceEnable>false</DataTCToleranceEnable>
                                        <DataTCPosTolerance>3000</DataTCPosTolerance>
                                        <DataTCNegTolerance>-500</DataTCNegTolerance>
                                        <AVSyncToleranceEnable>false</AVSyncToleranceEnable>
                                        <AVSyncTolerance>1500</AVSyncTolerance>
                                        <DebugLog>false</DebugLog>
                                </StreamValidator>
                                <!-- Properties defined here will override any properties defined in conf/MediaCasters.xml for any MediaCasters loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaCaster>
                        <MediaReader>
                                <!-- Properties defined here will override any properties defined in conf/MediaReaders.xml for any MediaReaders loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaReader>
                        <MediaWriter>
                                <!-- Properties defined here will override any properties defined in conf/MediaWriter.xml for any MediaWriter loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaWriter>
                        <LiveStreamPacketizer>
                                <!-- Properties defined here will override any properties defined in conf/LiveStreamPacketizers.xml for any LiveStreamPacketizers loaded by this applications -->
                                <Properties>
                                </Properties>
                        </LiveStreamPacketizer>
                        <HTTPStreamer>
                                <!-- Properties defined here will override any properties defined in conf/HTTPStreamers.xml for any HTTPStreamer loaded by this applications -->
                                <Properties>
                                </Properties>
                        </HTTPStreamer>
                        <Manager>
                                <!-- Properties defined are used by the Manager -->
                                <Properties>
                                </Properties>
                        </Manager>
                        <Repeater>
                                <OriginURL></OriginURL>
                                <QueryString><![CDATA[]]></QueryString>
                        </Repeater>
                        <StreamRecorder>
                                <Properties>
                                    <Property>
                                        <Name>streamRecorderFileVersionDelegate</Name>
                                        <Value>LiveStreamRecordFileVersionDelegate</Value>
                                        <Type>String</Type>
                                    </Property>
                                    <Property>
                                        <Name>streamRecorderFileVersionTemplate</Name>
                                        <Value>$${SourceStreamName}_$${RecordingStartTime}_$${SegmentNumber}</Value>
                                        <Type>String</Type>
                                    </Property>
                                    <Property>
                                        <Name>streamRecorderSegmentationType</Name>
                                        <Value>duration</Value>
                                        <Type>String</Type>
                                    </Property>
                                    <Property>
                                        <Name>streamRecorderSegmentDuration</Name>
                                        <Value>20000000</Value> <!-- milliseconds -->
                                        <Type>long</Type>
                                    </Property>
                                </Properties>
                        </StreamRecorder>
                        <Modules>
                                <Module>
                                        <Name>base</Name>
                                        <Description>Base</Description>
                                        <Class>com.wowza.wms.module.ModuleCore</Class>
                                </Module>
                                <Module>
                                        <Name>logging</Name>
                                        <Description>Client Logging</Description>
                                        <Class>com.wowza.wms.module.ModuleClientLogging</Class>
                                </Module>
                                <Module>
                                        <Name>flvplayback</Name>
                                        <Description>FLVPlayback</Description>
                                        <Class>com.wowza.wms.module.ModuleFLVPlayback</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleCoreSecurity</Name>
                                        <Description>Core Security Module for Applications</Description>
                                        <Class>com.wowza.wms.security.ModuleCoreSecurity</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleMediaWriterFileMover</Name>
                                        <Description>ModuleMediaWriterFileMover</Description>
                                        <Class>com.wowza.wms.module.ModuleMediaWriterFileMover</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleAutoRecord</Name>
                                        <Description>Auto-record streams that are published to this application instance.</Description>
                                        <Class>com.wowza.wms.plugin.ModuleAutoRecord</Class>
                                </Module>
                        </Modules>
                        <!-- Properties defined here will be added to the IApplication.getProperties() and IApplicationInstance.getProperties() collections -->
                        <Properties>
                                <Property>
                                        <Name>securityPublishRequirePassword</Name>
                                        <Value>false</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>securityPublishBlockDuplicateStreamNames</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverDestinationPath</Name>
                                        <Value>$${com.wowza.wms.context.VHostConfigHome}/content/azurecopy/$${com.wowza.wms.context.Application}</Value>
                                </Property>
                                <Property>
                                        <Name>fileMoverDeleteOriginal</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverVersionFile</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                        </Properties>
                </Application>
        </Root>
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/wowza-mount.sh
    content: |
        contentDirectory="/usr/local/WowzaStreamingEngine/content/azurecopy"
        # create directories
        [ ! -d /mnt/blobfusetmp ] && sudo mkdir /mnt/blobfusetmp
        [ ! -d $contentDirectory ] && sudo mkdir $contentDirectory

        sudo bash /home/wowza/mount.sh $contentDirectory /mnt/blobfusetmp /home/wowza/connection.cfg "wowzaContent" "/usr/local/WowzaStreamingEngine-${wowzaVersion}+1/content/azurecopy"
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/log-mount.sh
    content: |
      #!/bin/bash
      
      wowzaSource="/usr/local/WowzaStreamingEngine/logs"

      rootDir="/usr/local/WowzaStreamingEngine/azlogs"
      mkdir $rootDir

      hostname=$(cat /proc/sys/kernel/hostname)
      destination="$rootDir/$hostname"
      mkdir $destination

      cronTaskPath="/home/wowza/log_copy.txt"
      sudo touch $cronTaskPath
      sudo chmod 777 $cronTaskPath
      echo "*/5 * * * * /usr/bin/rsync -avz $wowzaSource $destination
      " > $cronTaskPath
      sudo -u wowza bash -c "crontab $cronTaskPath"

      sudo bash /home/wowza/mount.sh $rootDir /mnt/blobfusetmplogs /home/wowza/connection-logs.cfg "azlogs" "/usr/local/WowzaStreamingEngine-${wowzaVersion}+1/azlogs"
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/dir-creator.sh
    content: |
      #!/bin/bash

      max=$1
      prefix="audiostream"
      suffix=""

      echo "Ensuring there are $${max} Applications setup"

      echo "Removing legacy applications"
      rm -Rf /usr/local/WowzaStreamingEngine/applications/hmcts*

      currentAppCount=$(ls -d /usr/local/WowzaStreamingEngine/applications/$${prefix}* | wc -l)

      echo "Currently $${currentAppCount} applications defined."

      if (( max < currentAppCount )) ; then
        ((toDelete = "$currentAppCount - $max"))
        echo "Need to delete $${toDelete} Application(s)"

        start=$max
        end=$currentAppCount

        for ((i=start; i<=end; i++)) ; do
          file="$${prefix}$${i}$${suffix}"
          rm -Rf /usr/local/WowzaStreamingEngine/applications/$${file}
          rm -Rf /usr/local/WowzaStreamingEngine/conf/$${file}
        done
      fi

      targetDir="/usr/local/WowzaStreamingEngine/applications/"
      n=1
      set -- # this sets $@ [the argv array] to an empty list.

      while [ "$n" -le "$max" ]; do
        set -- "$@" "$${targetDir}/$${prefix}$${n}$${suffix}"
        n=$(( n + 1 ));
      done

      mkdir -p "$@"

      targetDir="/usr/local/WowzaStreamingEngine/conf/"
      n=1
      set -- # this sets $@ [the argv array] to an empty list.

      while [ "$n" -le "$max" ]; do
        set -- "$@" "$${targetDir}/$${prefix}$${n}$${suffix}"
        n=$(( n + 1 ));
      done

      mkdir -p "$@"

      targetDir="/usr/local/WowzaStreamingEngine/content/"
      n=1
      set -- # this sets $@ [the argv array] to an empty list.

      while [ "$n" -le "$max" ]; do
        set -- "$@" "$${targetDir}/$${prefix}$${n}$${suffix}"
        n=$(( n + 1 ));
      done

      mkdir -p "$@"

      # Copy Applications.xml file
      cd /usr/local/WowzaStreamingEngine/conf/ || exit
      appDirs=$(ls -d $${prefix}*)
      echo "$${appDirs}" | xargs -n 1 cp -v -f /home/wowza/Application.xml

  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/schedule-cert.sh
    content: |
        #!/bin/bash
        cronTaskPath="/home/wowza/cert-renew.txt"
        sudo touch $cronTaskPath
        sudo chmod 777 $cronTaskPath

        echo "0 0 * * * /home/wowza/renew-cert.sh
        " > $cronTaskPath

        sudo -u wowza bash -c "crontab $cronTaskPath"

  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/renew-cert.sh
    content: |
        #!/bin/bash

        miClientId="${managedIdentityClientId}"

        az login --identity --username $miClientId

        keyVaultName="${keyVaultName}"
        certName="${certName}"
        domain="${domain}"

        jksPath="/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks"
        jksPass="${certPassword}"

        export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin

        expiryDate=$(keytool -list -v -keystore $jksPath -storepass $jksPass | grep until | sed 's/.*until: //')

        echo "Certificate Expires $expiryDate"
        expiryDate="$(date -d "$expiryDate - 14 days" +%Y%m%d)"
        echo "Certificate Forced Expiry is $expiryDate"
        today=$(date +%Y%m%d)

        if [[ $expiryDate -lt $today ]]; then
            echo "Certificate has expired"
            downloadedPfxPath="downloadedCert.pfx"
            signedPfxPath="signedCert.pfx"
        
            rm -rf $downloadedPfxPath || true
            az keyvault secret download --file $downloadedPfxPath --vault-name $keyVaultName --encoding base64 --name $certName
            
            rm -rf $signedPfxPath || true
            openssl pkcs12 -in $downloadedPfxPath -out tmpmycert.pem -passin pass: -passout pass:$jksPass
            openssl pkcs12 -export -out $signedPfxPath -in tmpmycert.pem -passin pass:$jksPass -passout pass:$jksPass

            keytool -delete -alias 1 -keystore $jksPath -storepass $jksPass
            keytool -importkeystore -srckeystore $signedPfxPath -srcstoretype pkcs12 -destkeystore $jksPath -deststoretype JKS -deststorepass $jksPass -srcstorepass $jksPass
        else
            echo "Certificate has NOT expired"
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/log4j-fix.sh
    content: |
        #!/bin/bash

        home_dir="/home/wowza"
        wowza_version="${wowzaVersion}"

        ## Vars
        log4core_name="log4j-core-2.17.0.jar"
        log4api_name="log4j-api-2.17.0.jar"

        lof4j_zip_name="apache-log4j-2.17.0-bin"
        lof4j_zip_url="https://dlcdn.apache.org/logging/log4j/2.17.0/$lof4j_zip_name.zip"

        wowza_dir="/usr/local/WowzaStreamingEngine-$wowza_version"
        wowza_lib_dir="$wowza_dir/lib"
        wowza_tune_dir="$wowza_dir/conf/Tune.xml"
        wowza_startmgr_dir="$wowza_dir/manager/bin/startmgr.sh"

        ## Installs
        sudo apt install curl
        sudo apt install unzip

        ## Patch Directory
        patch_dir="$home_dir/patch"
        mkdir $patch_dir
        cd $patch_dir

        ## Download ZIP
        curl -O $lof4j_zip_url
        unzip $lof4j_zip_name -d .

        ## Stop Wowza
        sudo service WowzaStreamingEngine stop

        ## Delete old files
        sudo mv "$wowza_lib_dir/log4j-core-2.13.3.jar" "$home_dir/patch"
        sudo mv "$wowza_lib_dir/log4j-api-2.13.3.jar" "$home_dir/patch"

        ## Move new files
        sudo mv "$home_dir/patch/$lof4j_zip_name/$log4core_name" "$wowza_lib_dir"
        sudo mv "$home_dir/patch/$lof4j_zip_name/$log4api_name" "$wowza_lib_dir"
        chmod 775 "$wowza_lib_dir/$log4core_name"
        chmod 775 "$wowza_lib_dir/$log4api_name"

        ## Start Wowza
        sudo service WowzaStreamingEngine start

# PLEASE LEAVE THIS AT THE BOTTOM
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/runcmd.sh
    content: |
        #!/bin/bash

        # Install packages
        dpkg-query -l fuse && echo "Fuse already installed" || sudo apt-get install -y fuse
        dpkg-query -l blobfuse && echo "Blobfuse already installed" || sudo apt-get install -y blobfuse

        # install Wowza patch
        [[ -f "/wse-plugin-autorecord.zip" ]] && echo "wse-plugin-autorecord.zip aready downloaded" || wget https://www.wowza.com/downloads/forums/collection/wse-plugin-autorecord.zip && unzip wse-plugin-autorecord.zip && mv lib/wse-plugin-autorecord.jar /usr/local/WowzaStreamingEngine/lib/ && chown wowza: /usr/local/WowzaStreamingEngine/lib/wse-plugin-autorecord.jar
        sudo /home/wowza/log4j-fix.sh

        # create wowza apps
        /home/wowza/dir-creator.sh ${numApplications}

        # mount drives
        /home/wowza/wowza-mount.sh
        /home/wowza/log-mount.sh

        # install certificates
        sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash # Az cli install
        sudo /home/wowza/renew-cert.sh
        sudo /home/wowza/schedule-cert.sh

        # restart wowza
        sudo service WowzaStreamingEngine restart
runcmd:
  - 'sudo /home/wowza/runcmd.sh'

final_message: "The system is finally up, after $UPTIME seconds"
