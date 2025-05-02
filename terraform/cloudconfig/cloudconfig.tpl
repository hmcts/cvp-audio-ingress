#cloud-config
apt_sources:
  - source: "deb [arch=amd64 trusted=yes] https://packages.microsoft.com/ubuntu/18.04/prod bionic main"
package_upgrade: true
packages:
  - blobfuse
  - fuse
  - acl
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
                              <Enable>false</Enable>
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
                              <PoolSize>$${com.wowza.wms.TuningAuto}</PoolSize>
                      </HandlerThreadPool>
                      <TransportThreadPool>
                              <PoolSize>$${com.wowza.wms.TuningAuto}</PoolSize>
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
                <HeapSize>8192M</HeapSize>
                <GarbageCollector>$${com.wowza.wms.TuningGarbageCollectorG1Default}</GarbageCollector>
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
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
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
    path: /usr/local/WowzaStreamingEngine/manager/conf/tomcat.properties
    content: |
      httpsPort=8090
      httpsKeyStore=/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks
      httpsKeyStorePassword=${certPassword}
  - owner: wowza:wowza
    path: /home/wowza/mount.sh
    permissions: 0775
    content: |
        #!/bin/bash

        # This Script Should Be Run As ROOT!

        mkdir -p $1 $2
        lastPath="$(basename $1)"

        mountsTmp="/home/wowza/$lastPath-mounts.txt"
        df -h > $mountsTmp

        # Add BlobFuse
        echo "Starting Blob Fuse Mount For $1 @ $(date)" 

        if grep -q "$(realpath $1)" $mountsTmp && grep -q "blobfuse" $mountsTmp; then
           echo "Blob IS Mounted."
        else
           echo "Blob IS NOT Mounted, Mounting Blob Fuse..." 
           echo "Removing Redunant Mounts..."
           fusermount -u "$(realpath $1)"
           blobfuse $1 --tmp-path=$2 -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --config-file=$3 -o allow_other -o nonempty
        fi

        rm -f $mountsTmp
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
    path: /home/wowza/check-file-size.sh
    content: |
        #!/bin/bash

        # Project
        project="CVP"

        # Set Log Path.
        logFolder="/home/wowza/logs"
        logPath="/home/wowza/logs/check-file-size.log"

        # Set Dynatrace Details.
        dynatrace_token="${dynatrace_token}"
        dynatrace_tenant="${dynatrace_tenant}"

        # test 
        size="1MB"
        date="_$(date '+%Y-%m-%d')-"
        fileName="*$date*"
        sourcePath="/usr/local/WowzaStreamingEngine/content/azurecopy/"
        foundItems=$(find $sourcePath -type f -name  $fileName  -size -1M;)

        # Set logs
        NOW=`date '+%F %H:%M:%S'`
        mkdir -p $logFolder
        touch $logPath

        echo "Starting Check at $NOW" >> $logPath
        if [ -z "$foundItems" ]; then
                echo "No files under $size found today" >> $logPath
        else
                echo "Files under $size found" >> $logPath
                echo "$foundItems" >> $logPath
                curl --location --request POST "https://$dynatrace_tenant.live.dynatrace.com/api/v2/events/ingest" \
                --header "Authorization: API-Token $dynatrace_token" \
                --header 'Content-Type: application/json' \
                --data-raw "{
                        \"eventType\": \"ERROR_EVENT\",
                        \"title\": \"FH - $project - Files under $size\",
                        \"entitySelector\": \"type(HOST),entityName.startsWith($HOSTNAME)\",
                        \"properties\": {
                        \"Size\": \"$size\",
                        \"Files\": \"$foundItems\"
                        }
                }" >> $logPath
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/check-cert.sh
    content: |
        #!/bin/bash

        # Project
        project="CVP"

        # Set Dynatrace Details.
        dynatrace_token="${dynatrace_token}"
        dynatrace_tenant="${dynatrace_tenant}"

        # Java Key Store Details.
        jksPath="/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks"
        jksPass="${certPassword}"

        # Set Log Path.
        logFolder="/home/wowza/logs"
        logPath="/home/wowza/logs/check-cert.log"

        # Wowza Engine Path.
        export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin

        # Get Certificate Expiry Date.
        expiryDate=$(keytool -list -v -keystore $jksPath -storepass $jksPass | grep until | head -1 | sed 's/.*until: //')
        echo "Certificate Expires $expiryDate"
        certExpiryDate=$expiryDate
        expiryDate="$(date -d "$expiryDate - 12 days" +%Y%m%d)"
        echo "Certificate Forced Expiry is $expiryDate"
        today=$(date +%Y%m%d)

        # Send Alert to Dynatrace if Expirary Date within 12 Days.
        NOW=`date '+%F %H:%M:%S'`
        mkdir -p $logFolder
        touch $logPath

        echo "Starting Check at $NOW" >> $logPath
        if [[ $expiryDate -lt $today ]]; then
                echo "Wowza Certificate Has Expired" >> $logPath
                curl --location --request POST "https://$dynatrace_tenant.live.dynatrace.com/api/v2/events/ingest" \
                --header "Authorization: API-Token $dynatrace_token" \
                --header 'Content-Type: application/json' \
                --data-raw "{
                        \"eventType\": \"ERROR_EVENT\",
                        \"title\": \"FH - $project - Wowza Certificte Expiry\",
                        \"entitySelector\": \"type(HOST),entityName.startsWith($HOSTNAME)\",
                        \"properties\": {
                        \"Certificte.expiry\": \"$certExpiryDate\",
                        \"Certificte.renewal\": \"$expiryDate\"
                        }
                }" >> $logPath
        else
                echo "Wowza Certificate Has NOT Expired" >> $logPath
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/renew-cert.sh
    content: |
        #!/bin/bash

        miClientId="${managedIdentityClientId}"

        az login --identity --client-id $miClientId

        keyVaultName="${keyVaultName}"
        certName="${certName}"
        domain="${domain}"

        jksPath="/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks"
        jksPass="${certPassword}"

        export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin

        expiryDate=$(keytool -list -v -keystore $jksPath -storepass $jksPass | grep until | head -1 | sed 's/.*until: //')

        echo "Certificate Expires $expiryDate"
        expiryDate="$(date -d "$expiryDate - 14 days" +%Y%m%d)"
        echo "Certificate Forced Expiry is $expiryDate"
        today=$(date +%Y%m%d)

        if [[ $expiryDate -lt $today ]]; then
            echo "Certificate has expired"
            downloadedPfxPath="downloadedCert.pfx"
        
            rm -rf $downloadedPfxPath || true
            rm -f $jksPath || true

            az keyvault secret download --file $downloadedPfxPath --vault-name $keyVaultName --encoding base64 --name $certName

            keytool -storepasswd -new $jksPass -keystore $downloadedPfxPath -storepass "" -storetype PKCS12
            keytool -importkeystore -srckeystore $downloadedPfxPath -srcstoretype pkcs12 -destkeystore $jksPath -deststoretype JKS -deststorepass $jksPass -srcstorepass $jksPass

            sudo service WowzaStreamingEngine restart
        else
            echo "Certificate has NOT expired"
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/move-recordings.sh
    content: |
        #!/bin/bash

        streams=$(find /usr/local/WowzaStreamingEngine/content/ -name "*.mp4" -not -path "/usr/local/WowzaStreamingEngine/content/azurecopy/*")

        for stream in $streams; do
        IFS="/" read -a myarray <<< $stream
        echo "Copying..."
        echo $stream
        echo "to..."
        echo "/usr/local/WowzaStreamingEngine/content/azurecopy/$${myarray[5]}/$${myarray[6]}"
        cp $stream "/usr/local/WowzaStreamingEngine/content/azurecopy/$${myarray[5]}/$${myarray[6]}"
        if [[ -f "/usr/local/WowzaStreamingEngine/content/azurecopy/$${myarray[5]}/$${myarray[6]}" ]]; then
                echo "File moved OK, removing local file"
                sudo rm $stream
        else
                echo "File didnt move!"
        fi
        done
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/get-recordings.sh
    content: |
        #!/bin/bash

        files=$(find /usr/local/WowzaStreamingEngine/content/ -name "*.mp4" -not -path "/usr/local/WowzaStreamingEngine/content/azurecopy/*")
        for file in $files; do
                if [[ "$file" == *audiostream* ]]; then
                        echo ""
                        echo "-----------------------------------------------"
                        echo "File: $file"

                        IFS="/" read -ra myarray <<< $file
                        room_name="$${myarray[5]}"
                        file_name="$${myarray[6]}"

                        IFS="_" read -ra file_array <<< $file_name
                        case="$${file_array[0]}"
                        date="$${file_array[1]}"

                        echo "Case: $case"
                        echo "Room: $room_name"
                        echo "Started: $date"

                        FILESIZE_1=$(stat -c%s "$file")
                        sleep 1
                        FILESIZE_2=$(stat -c%s "$file")
                        if [ "$FILESIZE_1" != "$FILESIZE_2" ]; then
                                echo "Status: In Progress"
                                file_date_formatted="$${date:0:4}-$${date:5:2}-$${date:8:2} $${date:11:2}:$${date:14:2}:$${date:17:2}"
                                file_timestamp=$(date -u -d "$file_date_formatted" +%s)
                                current_timestamp=$(date -u +%s)

                                # Calculate the difference
                                diff_seconds=$((current_timestamp - file_timestamp))
                                diff_hours=$((diff_seconds / 3600))
                                diff_minutes=$(( (diff_seconds % 3600) / 60 ))
                                diff_seconds=$((diff_seconds % 60))

                                echo "Duration: $diff_hours hours, $diff_minutes minutes, and $diff_seconds seconds"
                        else
                                echo "Status: Not Recording"
                                mod_date=$(date -r $file "+%m-%d-%Y %H:%M:%S")
                                mod_file_date_formatted="$${mod_date:6:4}-$${mod_date:3:2}-$${mod_date:0:2} $${mod_date:11:2}:$${mod_date:14:2}:$${mod_date:17:2}"
                                mod_file_timestamp=$(date -u -d "$mod_file_date_formatted" +%s)

                                file_date_formatted="$${date:0:4}-$${date:5:2}-$${date:8:2} $${date:11:2}:$${date:14:2}:$${date:17:2}"
                                file_timestamp=$(date -u -d "$file_date_formatted" +%s)

                                # Calculate the difference
                                diff_seconds=$((mod_file_timestamp - file_timestamp))
                                diff_hours=$((diff_seconds / 3600))
                                diff_minutes=$(( (diff_seconds % 3600) / 60 ))
                                diff_seconds=$((diff_seconds % 60))

                                echo "Duration: $diff_hours hours, $diff_minutes minutes, and $diff_seconds seconds"
                        fi
                fi
        done
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/log4j-fix.sh
    content: |
        #!/bin/bash

        home_dir="/home/wowza"

        ## Vars
        log4core_name="log4j-core-2.17.0.jar"
        log4api_name="log4j-api-2.17.0.jar"
        old_log4j_api=$(find $wowza_lib_dir -name 'log4j*api*')
        old_log4j_core=$(find $wowza_lib_dir -name 'log4j*core*')
        
        lof4j_zip_name="apache-log4j-2.17.0-bin"
        lof4j_zip_url="https://dlcdn.apache.org/logging/log4j/2.17.0/$lof4j_zip_name.zip"

        wowza_dir="/usr/local/WowzaStreamingEngine"
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
        sudo mv $old_log4j_core "$home_dir/patch"
        sudo mv $old_log4j_api "$home_dir/patch"

        ## Move new files
        sudo mv "$home_dir/patch/$lof4j_zip_name/$log4core_name" "$wowza_lib_dir"
        sudo mv "$home_dir/patch/$lof4j_zip_name/$log4api_name" "$wowza_lib_dir"
        chmod 775 "$wowza_lib_dir/$log4core_name"
        chmod 775 "$wowza_lib_dir/$log4api_name"

        ## Start Wowza
        sudo service WowzaStreamingEngine start
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/wowza-restart.sh
    content: |
        #!/bin/bash

        # Restart the WowzaStreamingEngine
        sudo service WowzaStreamingEngine restart

        # Restart the WowzaStreamingEngineManager
        sudo service WowzaStreamingEngineManager restart

        # Log the restart command 
        dt=$(date)
        echo $HOSTNAME "Wowza Restart commanded at:" $dt#!/bin/bash
  - owner: wowza:wowza
    path: /home/wowza/sync-logs.sh
    permissions: 0775
    content: |
        #!/bin/bash

        # Source directory where the log files are stored
        src_dir="/usr/local/WowzaStreamingEngine/logs"
        destination="/usr/local/WowzaStreamingEngine/azlogs/daily"
        mkdir -p $destination

        log_files=("wowzastreamingengine_access.log" "wowzastreamingengine_error.log" "wowzastreamingengine_stats.log")

        # Get the current date and time
        timestamp=$(date +%Y%m%d)

        # Find the log files in the source directory
        for file in "$${log_files[@]}"
        do
          # Append the timestamp to the filename
          dest_file="$destination/$${timestamp}_$${HOSTNAME}_$${file}"
          src_file="$src_dir/$${file}"

          # copy the file
          cp "$src_file" "$dest_file"

          dt=$(date +%Y%m%d_%H%M%S)
          echo "$dt copied $file -> ./daily/$${timestamp}_$${HOSTNAME}_$${file}"
        done
  - owner: wowza:wowza
    path: /home/wowza/get-sas.sh
    permissions: 0775
    content: |
        #!/bin/bash

        miClientId="${managedIdentityClientId}"
        az login --identity --client-id $miClientId

        keyVaultName="${keyVaultName}"
        accountName="${storageAccountName}"

        # RECORDINGS #

        secret_sas_recordings="cvp-sas-recordings--rlw"
        containerNameRecordings="recordings"
        tempFileRecordings="/home/wowza/connection_temp.cfg"
        connFileRecordings="/home/wowza/connection.cfg"

        blobMount="/usr/local/WowzaStreamingEngine/content/azurecopy"
        blobTmp="/mnt/blobfusetmp"

        echo "Getting recordings SAS..."
        sas_recordings=$(az keyvault secret show --vault-name $keyVaultName --name $secret_sas_recordings --query "value" --output tsv)
        sas_recordings=$${sas_recordings//[$'\"']/}
        sas_recordings=$(echo "$sas_recordings" | tr -d '[:space:]')

        echo "AKV:$sas_recordings"

        sas_recordings_line=$(grep -E "^sasToken" $connFileRecordings)
        sas_recordings_current=$(echo "$sas_recordings_line" | awk -F' ' '{print $2}' | tr -d '[:space:]')

        echo "CFG:$sas_recordings_current"

        if [ "$sas_recordings" == "$sas_recordings_current" ]; then
                echo "No change to recordings SAS"
        else
                echo "Recordings SAS has changed, need to update and remount"
                echo accountName $accountName >> $tempFileRecordings
                echo authType SAS >> $tempFileRecordings
                echo sasToken $sas_recordings >> $tempFileRecordings
                echo containerName $containerNameRecordings >> $tempFileRecordings
                sudo mv $tempFileRecordings $connFileRecordings

                echo "Remove mount"
                sudo fusermount -u $blobMount

                echo "Mounting"
                sudo blobfuse $blobMount --tmp-path=$blobTmp -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --config-file=$connFileRecordings -o allow_other -o nonempty

        fi

        # LOGS #

        secret_sas_wowzalogs="cvp-sas-wowzalogs--rlw"
        containerNameWowzalogs="wowzalogs"
        tempFilewowzalogs="/home/wowza/connection-logs_temp.cfg"
        connFilewowzalogs="/home/wowza/connection-logs.cfg"

        logMount="/usr/local/WowzaStreamingEngine/azlogs"
        logTmp="/mnt/blobfusetmplogs"

        echo "Getting recordings SAS..."
        sas_wowzalogs=$(az keyvault secret show --vault-name $keyVaultName --name $secret_sas_wowzalogs --query "value" --output tsv)
        sas_wowzalogs=$${sas_wowzalogs//[$'\"']/}
        sas_wowzalogs=$(echo "$sas_wowzalogs" | tr -d '[:space:]')

        echo "AKV:$sas_wowzalogs"

        sas_wowzalogs_line=$(grep -E "^sasToken" $connFilewowzalogs)
        sas_wowzalogs_current=$(echo "$sas_wowzalogs_line" | awk -F' ' '{print $2}' | tr -d '[:space:]')

        echo "CFG:$sas_wowzalogs_current"

        if [ "$sas_wowzalogs" == "$sas_wowzalogs_current" ]; then
                echo "No change to log SAS"
        else
                echo "Log SAS has changed, need to update and remount"
                echo accountName $accountName >> $tempFilewowzalogs
                echo authType SAS >> $tempFilewowzalogs
                echo sasToken $sas_wowzalogs >> $tempFilewowzalogs
                echo containerName $containerNameWowzalogs >> $tempFilewowzalogs
                sudo mv $tempFilewowzalogs $connFilewowzalogs

                echo "Remove mount"
                sudo fusermount -u $logMount

                echo "Mounting"
                sudo blobfuse $logMount --tmp-path=$logTmp -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --config-file=$connFilewowzalogs -o allow_other -o nonempty

        fi
  - owner: wowza:wowza
    path: /home/wowza/cron.sh
    permissions: 0775
    content: |
        #!/bin/bash
        # Prepare Script.
        cronTaskPath='/home/wowza/cronjobs.txt'
        cronTaskPathRoot='/home/wowza/cronjobsRoot.txt'


        # Cron For Mounting.
        logFolder='/home/wowza/logs'
        mkdir -p $logFolder
        echo "5-59/10 * * * * /home/wowza/mount.sh $1 $2 $3 >> $logFolder/wowza_mount.log 2>&1" >> $cronTaskPathRoot
        echo "*/10 * * * * /home/wowza/mount.sh $4 $5 $6 >> $logFolder/log_mount.log 2>&1" >> $cronTaskPathRoot
        echo "0 0 * * * /home/wowza/renew-cert.sh >> $logFolder/renew-cert.log 2>&1" >> $cronTaskPathRoot

        # Cron for getting SAS
        echo "@reboot /home/wowza/get-sas.sh >> $logFolder/get_sas.log 2>&1" >> $cronTaskPathRoot
        echo "0 1 * * * /home/wowza/get-sas.sh >> $logFolder/get_sas.log 2>&1" >> $cronTaskPathRoot

        # Cron For Log Mount.
        wowzaSource="/usr/local/WowzaStreamingEngine/logs"
        destination="/usr/local/WowzaStreamingEngine/azlogs/$HOSTNAME"
        mkdir -p $destination
        echo "*/5 * * * * /usr/bin/rsync -avz $wowzaSource $destination" >> $cronTaskPath # Old script, causing many files to be created
        echo "*/5 * * * * /home/wowza/sync-logs.sh >> $logFolder/sync-logs.txt" >> $cronTaskPath # New script that shoudl only copy one file per log per day

        # Cron For Certs.
        if [[ $HOSTNAME == *"prod"* ]] || [[ $HOSTNAME == *"stg"* ]]; then
        echo "10 0 * * * /home/wowza/check-cert.sh" >> $cronTaskPath
        echo "10 0 * * * /home/wowza/check-file-size.sh" >> $cronTaskPath
        fi

        # Set Up Cron Jobs for Wowza & Root.
        crontab -u wowza $cronTaskPath
        crontab $cronTaskPathRoot
        
        # Remove To Avoid Duplicates.
        rm -f $cronTaskPath
        rm -f $cronTaskPathRoot
# PLEASE LEAVE THIS AT THE BOTTOM
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/runcmd.sh
    content: |
        #!/bin/bash

        blobMount="/usr/local/WowzaStreamingEngine/content/azurecopy"
        blobTmp="/mnt/blobfusetmp"
        blobCfg="/home/wowza/connection.cfg"
        logMount="/usr/local/WowzaStreamingEngine/azlogs"
        logTmp="/mnt/blobfusetmplogs"
        logCfg="/home/wowza/connection-logs.cfg"
        logDir="/home/wowza/logs"

        # Create Log Dir
        mkdir -p $logDir && chown wowza:wowza $logDir

        # Install packages
        dpkg-query -l fuse && echo "Fuse already installed" || sudo apt-get install -y fuse
        dpkg-query -l blobfuse && echo "Blobfuse already installed" || sudo apt-get install -y blobfuse
        dpkg-query -l acl && echo "acl already installed" || sudo apt-get install -y acl
        sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash # Az cli install

        # install Wowza patch
        [[ -f "/wse-plugin-autorecord.zip" ]] && echo "wse-plugin-autorecord.zip aready downloaded" || wget https://www.wowza.com/downloads/forums/collection/wse-plugin-autorecord.zip && unzip wse-plugin-autorecord.zip && mv lib/wse-plugin-autorecord.jar /usr/local/WowzaStreamingEngine/lib/ && chown wowza: /usr/local/WowzaStreamingEngine/lib/wse-plugin-autorecord.jar && chmod 775 /usr/local/WowzaStreamingEngine/lib/wse-plugin-autorecord.jar
        sudo /home/wowza/log4j-fix.sh

        # Create Wowza Apps
        /home/wowza/dir-creator.sh ${numApplications}

        # Update blobfuse connection configuration.
        /home/wowza/get-sas.sh

        # Mount Drives For Wowza & Logs.
        /home/wowza/mount.sh $blobMount $blobTmp $blobCfg
        /home/wowza/mount.sh $logMount $logTmp $logCfg

        # Install Certificates.
        /home/wowza/renew-cert.sh

        # Set Up CronJobs.
        /home/wowza/cron.sh $blobMount $blobTmp $blobCfg $logMount $logTmp $logCfg

        # Restart Wowza and WSEM
        sudo service WowzaStreamingEngine restart
        sudo service WowzaStreamingEngineManager restart
runcmd:
  - 'sudo /home/wowza/runcmd.sh'

final_message: "The system is finally up, after $UPTIME seconds"
